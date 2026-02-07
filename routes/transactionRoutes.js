const express = require('express');
const router = express.Router();
const axios = require('axios');
const db = require('../db');

// Remplacez par vos vraies infos d'authentification Ebilling
const EBILLING_USERNAME = process.env.EBILLING_USERNAME || 'smeby33';
const EBILLING_SHARED_KEY = process.env.EBILLING_SHARED_KEY || '0d14ed02-33fc-496b-9e03-04a00563d270';
const EBILLING_URL = 'https://lab.billing-easy.net/api/v1/merchant/e_bills';

// Middleware de logging pour toutes les routes
router.use((req, res, next) => {
    console.log(`📥 [${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
    if (Object.keys(req.body).length > 0) {
        console.log(`📦 Body:`, JSON.stringify(req.body, null, 2));
    }
    if (Object.keys(req.params).length > 0) {
        console.log(`📌 Params:`, JSON.stringify(req.params, null, 2));
    }
    if (Object.keys(req.query).length > 0) {
        console.log(`❓ Query:`, JSON.stringify(req.query, null, 2));
    }
    next();
});

// ➕ Créer une facture (Invoice)
router.post('/createInvoice', async (req, res) => {
    console.log('🚀 [POST /createInvoice] Début création facture');
    const { amount, external_reference, short_description, payer_msisdn, payer_email, payer_name, expiry_period, return_url } = req.body;

    console.log(`📋 [createInvoice] Données reçues:`, {
        amount,
        external_reference,
        short_description,
        payer_msisdn: payer_msisdn ? `${payer_msisdn.substring(0, 3)}...` : 'non fourni',
        payer_email,
        payer_name: payer_name ? `${payer_name.substring(0, 10)}...` : 'non fourni',
        expiry_period,
        return_url
    });

    // Validation minimale des champs requis (payer_msisdn est optionnel)
    if (!amount || !external_reference || !short_description || !payer_email || !payer_name) {
        console.error('❌ [createInvoice] Validation échouée - champs manquants');
        console.error('   Manquants:', {
            amount: !amount,
            external_reference: !external_reference,
            short_description: !short_description,
            payer_email: !payer_email,
            payer_name: !payer_name
        });
        return res.status(400).json({ error: 'amount, external_reference, short_description, payer_email et payer_name sont requis.' });
    }

    console.log('✅ [createInvoice] Validation des données réussie');

    // Normaliser le numéro de téléphone si fourni.
    // Si non fourni, essayer de le récupérer depuis la réservation (table `reservation`) puis depuis `renter.phone`.
    let normalizedMsisdn = '';
    if (payer_msisdn && payer_msisdn.toString().trim() !== '') {
        normalizedMsisdn = payer_msisdn.toString().trim().replace(/\s+/g, '');
    } else {
        // tenter de récupérer le numéro via la réservation (external_reference correspond à reservation.id)
        try {
            const [resaRows] = await db.query('SELECT * FROM reservation WHERE id = ?', [external_reference]);
            if (resaRows && resaRows.length > 0) {
                const resa = resaRows[0];
                // Prioriser un numéro stocké directement dans la réservation
                if (resa.phone && resa.phone.toString().trim() !== '') {
                    normalizedMsisdn = resa.phone.toString().trim().replace(/\s+/g, '');
                    console.log('[createInvoice] Numéro récupéré depuis reservation.phone pour la réservation', external_reference);
                } else if (resa.telephone && resa.telephone.toString().trim() !== '') {
                    normalizedMsisdn = resa.telephone.toString().trim().replace(/\s+/g, '');
                    console.log('[createInvoice] Numéro récupéré depuis reservation.telephone pour la réservation', external_reference);
                } else {
                    // la table reservation ne contient pas de numéro — récupérer le conducteur (renter id)
                    const conducteurId = resa.conducteur || resa.user_id || null;
                    if (conducteurId) {
                        const [renterRows] = await db.query('SELECT phone FROM renter WHERE id = ?', [conducteurId]);
                        if (renterRows && renterRows.length > 0 && renterRows[0].phone) {
                            normalizedMsisdn = renterRows[0].phone.toString().trim().replace(/\s+/g, '');
                            console.log('[createInvoice] Numéro récupéré depuis renter.phone pour la réservation', external_reference);
                        }
                    }
                }
            }
        } catch (lookupErr) {
            console.warn('[createInvoice] Impossible de récupérer le numéro depuis reservation/renter:', lookupErr.message);
        }
    }

    // Si toujours aucun numéro, utiliser le placeholder accepté par Ebilling
    if (!normalizedMsisdn) normalizedMsisdn = '00000000';

    const data = {
        payer_msisdn: normalizedMsisdn,
        payer_email,
        payer_name,
        amount,
        external_reference,
        short_description,
        expiry_period: expiry_period || '100',
        ...(return_url ? { return_url } : {})
    };

    const auth = Buffer.from(`${EBILLING_USERNAME}:${EBILLING_SHARED_KEY}`).toString('base64');

    console.log(`🔑 [createInvoice] Préparation appel Ebilling:`, {
        url: EBILLING_URL,
        auth_header: `Basic ${auth.substring(0, 20)}...`
    });

    try {
        console.log('📤 [createInvoice] Envoi requête vers Ebilling...');
        const response = await axios.post(EBILLING_URL, data, {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': `Basic ${auth}`
            },
            timeout: 30000 // 30 secondes timeout
        });

        console.log('✅ [createInvoice] Réponse Ebilling reçue:', {
            status: response.status,
            data_keys: Object.keys(response.data)
        });

        if (response.data && response.data.e_bill && response.data.e_bill.bill_id) {
            const facture = response.data.e_bill;
            const e_external_reference = facture.external_reference || external_reference;
            const bill_id = facture.bill_id;
            const statuspay = 0;
            const created_at = facture.created_at ? facture.created_at.replace('T', ' ').substring(0, 19) : null;
            
            console.log(`💾 [createInvoice] Insertion en base de données:`, {
                external_reference: e_external_reference,
                bill_id,
                statuspay,
                created_at
            });

            try {
                await db.query(
                    `INSERT INTO factures (external_reference, bill_id, statuspay, created_at) VALUES (?, ?, ?, ?)`,
                    [e_external_reference, bill_id, statuspay, created_at]
                );
                console.log('✅ [createInvoice] Facture insérée en base avec succès');
            } catch (dbError) {
                console.error('⚠️ [createInvoice] Erreur insertion BDD:', dbError.message);
                // On continue car l'API Ebilling a répondu
            }
        } else {
            console.warn('⚠️ [createInvoice] Réponse Ebilling incomplète:', response.data);
        }

        console.log('🎉 [createInvoice] Facture créée avec succès');

        // Construire une payment_url fiable pour le frontend
        let paymentUrl = response.data?.e_bill?.payment_url || null;
        if (!paymentUrl && response.data?.e_bill?.bill_id) {
            const portal = (process.env.EBILLING_PORTAL_URL || 'https://test.billing-easy.net').replace(/\/$/, '');
            const billId = response.data.e_bill.bill_id;
            if (return_url) {
                paymentUrl = `${portal}?invoice=${billId}&redirect_url=${encodeURIComponent(return_url)}`;
            } else {
                paymentUrl = `${portal}?invoice=${billId}`;
            }
            console.log('[createInvoice] paymentUrl construite en fallback:', paymentUrl);
        }

        const out = { ...response.data, payment_url: paymentUrl };
        console.log('⤴️ [createInvoice] Réponse envoyée au frontend:', JSON.stringify(out, null, 2));
        res.status(201).json(out);
    } catch (err) {
        console.error('❌ [createInvoice] Erreur lors de la création de la facture:', {
            message: err.message,
            response_data: err.response?.data,
            response_status: err.response?.status,
            stack: err.stack
        });

        res.status(500).json({ 
            error: 'Erreur lors de la création de la facture.', 
            details: err.response?.data || err.message 
        });
    }
});


// 🔔 Webhook Ebilling - traiter les callbacks et mettre à jour la table `factures`
router.post('/webhook', async (req, res) => {
    console.log('🔔 [POST /webhook] Callback Ebilling reçu:', {
        timestamp: new Date().toISOString(),
        body: JSON.stringify(req.body, null, 2),
        headers: req.headers
    });

    // Certains environnements (Rails, AppRunner…) enveloppent la charge utile dans notification_params
    let payload = req.body;
    if (typeof payload === 'string') {
        try { payload = JSON.parse(payload); } catch (err) { console.warn('[webhook] Impossible de parser payload string:', err.message); }
    }
    if (payload && payload.notification_params) {
        if (typeof payload.notification_params === 'string') {
            try {
                payload = JSON.parse(payload.notification_params);
            } catch (err) {
                console.warn('[webhook] Impossible de parser notification_params string:', err.message);
                payload = payload.notification_params;
            }
        } else {
            payload = payload.notification_params;
        }
    }

    const billingid = payload.billingid || payload.bill_id || payload.billing_id;
    const external_reference = payload.reference || payload.external_reference || payload.externalref;
    const state = (payload.state || payload.status || '').toString().toLowerCase();

    console.log(`🔍 [webhook] Données extraites:`, {
        billingid,
        external_reference,
        state,
        raw_state: req.body.state || req.body.status
    });

    if (!billingid && !external_reference) {
        console.warn('⚠️ [webhook] Webhook reçu sans billingid ni external_reference');
        console.warn('   Corps complet:', JSON.stringify(req.body, null, 2));
        return res.status(400).json({ error: 'billingid ou external_reference requis' });
    }

    try {
        // Déterminer le nouveau statut
        let statuspay = 0; // 0 = pending
        if (state === 'paid' || state === 'completed' || state === 'success') {
            statuspay = 1; // payé
            console.log(`💰 [webhook] État détecté: PAYÉ (${state})`);
        } else if (state === 'failed' || state === 'cancelled') {
            statuspay = 2; // échec
            console.log(`❌ [webhook] État détecté: ÉCHEC (${state})`);
        } else {
            console.log(`⚡ [webhook] État détecté: EN ATTENTE (${state})`);
        }

        console.log(`🔄 [webhook] Tentative de mise à jour facture:`, {
            billingid,
            external_reference,
            statuspay,
            query: 'UPDATE factures SET statuspay = ?, updated_at = NOW(), raw_callback = ? WHERE bill_id = ? OR external_reference = ?'
        });

        // Mettre à jour la facture existante en se basant sur bill_id ou external_reference
        const [result] = await db.query(
            'UPDATE factures SET statuspay = ?, updated_at = NOW(), raw_callback = ? WHERE bill_id = ? OR external_reference = ?',
            [statuspay, JSON.stringify(payload), billingid || null, external_reference || null]
        );

        if (result.affectedRows > 0) {
            console.log(`✅ [webhook] Facture mise à jour avec succès:`, {
                affectedRows: result.affectedRows,
                billingid,
                external_reference,
                statuspay
            });
            return res.status(200).json({ 
                success: true, 
                message: `Facture mise à jour (statuspay=${statuspay})`,
                billingid,
                external_reference
            });
        } else {
            console.warn('⚠️ [webhook] Aucune facture trouvée pour ce callback, création d une entrée log temporaire');
            console.warn('   Identifiants:', { billingid, external_reference });
            
            // Optionnel : insérer en log pour investigation
            try {
                await db.query(
                    `INSERT INTO factures_logs (billingid, external_reference, payload, created_at) VALUES (?, ?, ?, NOW())`,
                    [billingid || null, external_reference || null, JSON.stringify(payload)]
                );
                console.log('📝 [webhook] Log inséré dans factures_logs');
            } catch (logError) {
                console.error('❌ [webhook] Erreur insertion log:', logError.message);
            }
            
            return res.status(404).json({ 
                error: 'Aucune facture trouvée pour ces identifiants.',
                billingid,
                external_reference
            });
        }
    } catch (err) {
        console.error('❌ [webhook] Erreur traitement webhook Ebilling:', {
            message: err.message,
            stack: err.stack,
            code: err.code,
            sql: err.sql
        });
        return res.status(500).json({ 
            error: 'Erreur traitement webhook', 
            details: err.message,
            timestamp: new Date().toISOString()
        });
    }
});


// 🔍 Récupérer le bill_id via l'external_reference dans la table factures
router.get('/recupererfactureid/:external_reference', async (req, res) => {
    console.log(`🔍 [GET /recupererfactureid] Requête pour:`, {
        external_reference: req.params.external_reference,
        url: req.originalUrl
    });

    const { external_reference } = req.params;
    
    if (!external_reference) {
        console.error('❌ [recupererfactureid] external_reference manquant dans les paramètres');
        return res.status(400).json({ error: 'external_reference est requis dans les paramètres.' });
    }

    try {
        console.log(`📝 [recupererfactureid] Exécution requête SQL: SELECT bill_id FROM factures WHERE external_reference = ?`, external_reference);
        
        const [rows] = await db.query('SELECT bill_id FROM factures WHERE external_reference = ?', [external_reference]);
        
        console.log(`📊 [recupererfactureid] Résultats SQL:`, {
            rowCount: rows.length,
            rows: rows
        });

        if (rows.length > 0) {
            console.log(`✅ [recupererfactureid] Facture trouvée:`, {
                external_reference,
                bill_id: rows[0].bill_id
            });
            res.json({ 
                bill_id: rows[0].bill_id,
                found: true
            });
        } else {
            console.warn(`⚠️ [recupererfactureid] Aucune facture trouvée pour: ${external_reference}`);
            res.status(404).json({ 
                error: 'Aucune facture trouvée pour cette référence.',
                external_reference,
                found: false
            });
        }
    } catch (err) {
        console.error('❌ [recupererfactureid] Erreur lors de la récupération du bill_id:', {
            message: err.message,
            stack: err.stack,
            code: err.code,
            sql: err.sql
        });
        res.status(500).json({ 
            error: 'Erreur lors de la récupération du bill_id.',
            details: err.message
        });
    }
});

// 🔗 Rediriger vers le portail Ebilling pour paiement
const EBILLING_PORTAL_URL = process.env.EBILLING_PORTAL_URL || 'https://test.billing-easy.net';
const EB_CALLBACK_URL = process.env.EB_CALLBACK_URL || 'https://myurlcallbackafterpayement';

router.post('/redirectToEbilling', async (req, res) => {
    console.log('🔗 [POST /redirectToEbilling] Requête reçue:', {
        body: req.body,
        invoice_number: req.body.invoice_number
    });

    const { invoice_number } = req.body;
    if (!invoice_number) {
        console.error('❌ [redirectToEbilling] invoice_number manquant');
        return res.status(400).json({ error: 'invoice_number est requis.' });
    }

    console.log(`🔄 [redirectToEbilling] Préparation redirection vers Ebilling:`, {
        portal_url: EBILLING_PORTAL_URL,
        invoice_number,
        callback_url: EB_CALLBACK_URL
    });

    try {
        const response = await axios.post(EBILLING_PORTAL_URL, {
            invoice_number,
            eb_callbackurl: EB_CALLBACK_URL
        }, {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            timeout: 30000
        });

        console.log('✅ [redirectToEbilling] Réponse Ebilling reçue:', {
            status: response.status,
            data: response.data
        });

        res.status(200).json(response.data);
    } catch (err) {
        console.error('❌ [redirectToEbilling] Erreur lors de la redirection vers Ebilling:', {
            message: err.message,
            response_data: err.response?.data,
            response_status: err.response?.status,
            url: EBILLING_PORTAL_URL
        });

        res.status(500).json({ 
            error: 'Erreur lors de la redirection vers Ebilling.', 
            details: err.response?.data || err.message 
        });
    }
});

// ✅ Mettre à jour le statut de paiement dans la table factures
router.post('/updateFactureStatus', async (req, res) => {
    console.log('✅ [POST /updateFactureStatus] Mise à jour statut:', {
        body: req.body,
        billingid: req.body.billingid,
        reference: req.body.reference
    });

    // Correspondance des noms reçus du front
    const { billingid, reference } = req.body;
    
    if (!billingid || !reference) {
        console.error('❌ [updateFactureStatus] Champs manquants:', {
            hasBillingid: !!billingid,
            hasReference: !!reference
        });
        return res.status(400).json({ error: 'billingid et reference sont requis.' });
    }

    try {
        console.log(`🔄 [updateFactureStatus] Exécution requête SQL:`, {
            query: 'UPDATE factures SET statuspay = 1 WHERE bill_id = ? AND external_reference = ?',
            params: [billingid, reference]
        });

        const [result] = await db.query(
            'UPDATE factures SET statuspay = 1 WHERE bill_id = ? AND external_reference = ?',
            [billingid, reference]
        );

        console.log(`📊 [updateFactureStatus] Résultat mise à jour:`, {
            affectedRows: result.affectedRows,
            changedRows: result.changedRows,
            billingid,
            reference
        });

        if (result.affectedRows > 0) {
            console.log(`✅ [updateFactureStatus] Statut mis à jour avec succès pour:`, { billingid, reference });
            res.json({ 
                success: true, 
                message: 'Statut de paiement mis à jour.',
                billingid,
                reference,
                affectedRows: result.affectedRows
            });
        } else {
            console.warn(`⚠️ [updateFactureStatus] Aucune facture trouvée pour:`, { billingid, reference });
            res.status(404).json({ 
                error: 'Aucune facture trouvée pour ces identifiants.',
                billingid,
                reference
            });
        }
    } catch (err) {
        console.error('❌ [updateFactureStatus] Erreur lors de la mise à jour du statut de paiement:', {
            message: err.message,
            stack: err.stack,
            code: err.code,
            sql: err.sql
        });
        res.status(500).json({ 
            error: 'Erreur lors de la mise à jour du statut de paiement.',
            details: err.message
        });
    }
});

// Route de santé (health check)
router.get('/health', (req, res) => {
    console.log('🏥 [GET /health] Health check appelé');
    res.json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        service: 'Ebilling API',
        routes: [
            'POST /createInvoice',
            'POST /webhook',
            'GET /recupererfactureid/:external_reference',
            'POST /redirectToEbilling',
            'POST /updateFactureStatus',
            'GET /health'
        ]
    });
});

// Log des routes chargées
console.log('📋 Routes Ebilling chargées:');
console.log('  POST   /createInvoice');
console.log('  POST   /webhook');
console.log('  GET    /recupererfactureid/:external_reference');
console.log('  POST   /redirectToEbilling');
console.log('  POST   /updateFactureStatus');
console.log('  GET    /health');

module.exports = router;