const express = require('express');
const router = express.Router();
const axios = require('axios');
const db = require('../db');
const crypto = require('crypto');
const QRCode = require('qrcode');
const nodemailer = require('nodemailer');

// 🔍 Middleware pour capturer les données brutes
router.use(express.json());
router.use(express.urlencoded({ extended: true }));

// Middleware de diagnostic
router.use((req, res, next) => {
    console.log('\n🎫 [ROTARY] ==================');
    console.log('📍 URL:', req.url);
    console.log('📍 Méthode:', req.method);
    console.log('📦 Body:', req.body);
    console.log('🎫 [ROTARY] ==================\n');
    next();
});

// ==================== CONFIGURATION EBILLING ====================
const EBILLING_USERNAME = process.env.EBILLING_USERNAME || 'smeby33';
const EBILLING_SHARED_KEY = process.env.EBILLING_SHARED_KEY || '0d14ed02-33fc-496b-9e03-04a00563d270';
const EBILLING_URL = 'https://lab.billing-easy.net/api/v1/merchant/e_bills';
const EB_CALLBACK_URL = process.env.EB_CALLBACK_URL || 'https://ph8jb63g3p.us-east-1.awsapprunner.com/rotary/webhook';
const FRONTEND_URL = process.env.FRONTEND_URL || 'https://rotary-port-gentil-65th-anniversary.vercel.app';

// Configuration email
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

// ==================== FONCTIONS UTILITAIRES ====================

// Générer un ID unique
function generateId(prefix = 'ID') {
    return `${prefix}-${Date.now()}-${crypto.randomBytes(4).toString('hex').toUpperCase()}`;
}

// Générer une référence unique pour billet
function generateTicketRef() {
    const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const random = crypto.randomBytes(3).toString('hex').toUpperCase();
    return `BIL-${date}-${random}`;
}

// Générer une référence de paiement unique
function generatePaymentRef() {
    const random = crypto.randomBytes(6).toString('hex').toUpperCase();
    return `REF-ROTARY-${random}`;
}

// Fonction pour générer un QR code en base64
async function generateQRCodeBase64(data) {
    try {
        const qrCodeDataURL = await QRCode.toDataURL(data, {
            errorCorrectionLevel: 'H',
            type: 'image/png',
            width: 300,
            margin: 2
        });
        return qrCodeDataURL;
    } catch (err) {
        console.error('❌ Erreur génération QR code:', err);
        return null;
    }
}

// Fonction pour envoyer un email de notification à l'admin
async function sendAdminNotification(type, billetData, eventData) {
    try {
        const adminEmail = process.env.ADMIN_EMAIL || process.env.EMAIL_USER;
        
        let subject = '';
        let message = '';
        
        if (type === 'payment_received') {
            subject = `🎉 Nouveau paiement reçu - ${eventData.titre}`;
            message = `
                <div style="font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5;">
                    <div style="max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px;">
                        <h2 style="color: #01579B;">💰 Nouveau Paiement Confirmé</h2>
                        <p>Un client vient de payer son billet :</p>
                        
                        <div style="background: #E3F2FD; padding: 20px; border-radius: 8px; margin: 20px 0;">
                            <p><strong>👤 Client :</strong> ${billetData.prenom} ${billetData.nom}</p>
                            <p><strong>📧 Email :</strong> ${billetData.email}</p>
                            <p><strong>📱 Téléphone :</strong> ${billetData.telephone || 'Non renseigné'}</p>
                            <p><strong>🎫 Référence :</strong> ${billetData.reference_billet}</p>
                            <p><strong>🎟️ Catégorie :</strong> ${billetData.nom_categorie}</p>
                            <p><strong>👥 Quantité :</strong> ${billetData.quantite} place(s)</p>
                            <p><strong>💰 Montant :</strong> ${billetData.montant_total.toLocaleString('fr-FR')} ${billetData.currency_code}</p>
                        </div>
                        
                        <div style="background: #FFF3CD; padding: 15px; border-radius: 8px; margin: 20px 0;">
                            <p><strong>📅 Événement :</strong> ${eventData.titre}</p>
                            <p><strong>📍 Date :</strong> ${new Date(eventData.date_evenement).toLocaleDateString('fr-FR', { 
                                weekday: 'long', 
                                year: 'numeric', 
                                month: 'long', 
                                day: 'numeric',
                                hour: '2-digit',
                                minute: '2-digit'
                            })}</p>
                            <p><strong>🏠 Lieu :</strong> ${eventData.lieu}</p>
                        </div>
                        
                        <p style="color: #666; font-size: 12px; margin-top: 30px; text-align: center;">
                            Email automatique envoyé le ${new Date().toLocaleString('fr-FR')}
                        </p>
                    </div>
                </div>
            `;
        } else if (type === 'email_sent') {
            subject = `✅ Email de confirmation envoyé - ${billetData.reference_billet}`;
            message = `
                <div style="font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5;">
                    <div style="max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px;">
                        <h2 style="color: #4CAF50;">✅ Email de Confirmation Envoyé</h2>
                        <p>Le billet a été envoyé avec succès au client :</p>
                        
                        <div style="background: #E8F5E9; padding: 20px; border-radius: 8px; margin: 20px 0;">
                            <p><strong>👤 Client :</strong> ${billetData.prenom} ${billetData.nom}</p>
                            <p><strong>📧 Email :</strong> ${billetData.email}</p>
                            <p><strong>🎫 Référence :</strong> ${billetData.reference_billet}</p>
                            <p><strong>🎟️ Catégorie :</strong> ${billetData.nom_categorie}</p>
                        </div>
                        
                        <div style="background: #E3F2FD; padding: 15px; border-radius: 8px; margin: 20px 0;">
                            <p><strong>📅 Événement :</strong> ${eventData.titre}</p>
                            <p><strong>📍 Date :</strong> ${new Date(eventData.date_evenement).toLocaleDateString('fr-FR')}</p>
                        </div>
                        
                        <p style="margin-top: 20px;">✅ Le client a reçu :</p>
                        <ul style="line-height: 2;">
                            <li>Son billet électronique avec QR code</li>
                            <li>Les détails de l'événement</li>
                            <li>Les instructions d'accès</li>
                        </ul>
                        
                        <p style="color: #666; font-size: 12px; margin-top: 30px; text-align: center;">
                            Email automatique envoyé le ${new Date().toLocaleString('fr-FR')}
                        </p>
                    </div>
                </div>
            `;
        }
        
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: adminEmail,
            subject: subject,
            html: message
        };
        
        await transporter.sendMail(mailOptions);
        console.log(`✅ Notification admin envoyée (${type}) à:`, adminEmail);
        return true;
    } catch (err) {
        console.error('❌ Erreur envoi notification admin:', err);
        return false;
    }
}

// Fonction pour envoyer l'email de confirmation avec QR code
async function sendTicketEmail(billetData, eventData, qrCodeBase64) {
    try {
        console.log('📧 Préparation email pour:', billetData.email);
        
        const qrCodeImage = qrCodeBase64.replace(/^data:image\/png;base64,/, '');
        
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: billetData.email,
            subject: `✅ Votre billet pour ${eventData.titre}`,
            html: `
                <!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                        .header { background: linear-gradient(135deg, #01579B 0%, #0277BD 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
                        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
                        .ticket-info { background: white; padding: 20px; border-radius: 8px; margin: 20px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
                        .qr-code { text-align: center; margin: 30px 0; }
                        .qr-code img { max-width: 300px; border: 3px solid #01579B; border-radius: 8px; padding: 10px; background: white; }
                        .info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; }
                        .info-label { font-weight: bold; color: #01579B; }
                        .footer { text-align: center; color: #666; margin-top: 30px; font-size: 12px; }
                        .important { background: #FFF3CD; border-left: 4px solid #F9A825; padding: 15px; margin: 20px 0; border-radius: 4px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🎉 Paiement Confirmé !</h1>
                            <p>Votre billet est prêt</p>
                        </div>
                        
                        <div class="content">
                            <p>Bonjour <strong>${billetData.prenom} ${billetData.nom}</strong>,</p>
                            
                            <p>Nous avons le plaisir de confirmer votre inscription pour :</p>
                            
                            <div class="ticket-info">
                                <h2 style="color: #01579B; margin-top: 0;">${eventData.titre}</h2>
                                
                                <div class="info-row">
                                    <span class="info-label">📅 Date :</span>
                                    <span>${new Date(eventData.date_evenement).toLocaleDateString('fr-FR', { 
                                        weekday: 'long', 
                                        year: 'numeric', 
                                        month: 'long', 
                                        day: 'numeric',
                                        hour: '2-digit',
                                        minute: '2-digit'
                                    })}</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">📍 Lieu :</span>
                                    <span>${eventData.lieu}</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">🎫 Référence :</span>
                                    <span><strong>${billetData.reference_billet}</strong></span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">🎟️ Catégorie :</span>
                                    <span>${billetData.nom_categorie}</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">👥 Quantité :</span>
                                    <span>${billetData.quantite} place(s)</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">💰 Montant payé :</span>
                                    <span><strong>${billetData.montant_total.toLocaleString('fr-FR')} ${billetData.currency_code}</strong></span>
                                </div>
                            </div>
                            
                            <div class="qr-code">
                                <h3 style="color: #01579B;">Votre QR Code d'Accès</h3>
                                <p>Présentez ce QR code à l'entrée</p>
                                <img src="cid:qrcode" alt="QR Code" />
                                <p style="color: #666; font-size: 14px; margin-top: 10px;">
                                    Référence : <strong>${billetData.reference_billet}</strong>
                                </p>
                            </div>
                            
                            <div class="important">
                                <strong>⚠️ Important :</strong>
                                <ul style="margin: 10px 0;">
                                    <li>Conservez ce QR code précieusement</li>
                                    <li>Présentez-le à l'entrée (format numérique ou imprimé)</li>
                                    <li>Arrivez 15 minutes avant le début de l'événement</li>
                                </ul>
                            </div>
                            
                            ${billetData.notes_participant ? `
                            <div style="background: #E3F2FD; padding: 15px; border-radius: 4px; margin: 20px 0;">
                                <strong>📝 Vos notes :</strong><br/>
                                ${billetData.notes_participant}
                            </div>
                            ` : ''}
                            
                            <p style="margin-top: 30px;">
                                Nous avons hâte de vous accueillir !<br/>
                                En cas de question, n'hésitez pas à nous contacter.
                            </p>
                            
                            <p style="margin-top: 20px;">
                                Cordialement,<br/>
                                <strong>L'équipe ${eventData.organisateur_nom || 'Rotary Club'}</strong>
                            </p>
                        </div>
                        
                        <div class="footer">
                            <p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>
                            <p>© ${new Date().getFullYear()} Rotary Club - Tous droits réservés</p>
                        </div>
                    </div>
                </body>
                </html>
            `,
            attachments: [
                {
                    filename: 'qrcode.png',
                    content: qrCodeImage,
                    encoding: 'base64',
                    cid: 'qrcode'
                }
            ]
        };
        
        const info = await transporter.sendMail(mailOptions);
        console.log('✅ Email envoyé avec succès:', info.messageId);
        
        // Envoyer notification à l'admin que l'email a été envoyé
        await sendAdminNotification('email_sent', billetData, eventData);
        
        // Enregistrer dans les logs
        await db.query(`
            INSERT INTO rotary_email_logs 
            (id, billet_id, recipient_email, email_type, subject, sent_at, statut)
            VALUES (?, ?, ?, 'billet_envoye', ?, NOW(), 'sent')
        `, [
            generateId('EMAIL'),
            billetData.id,
            billetData.email,
            mailOptions.subject
        ]);
        
        return true;
    } catch (err) {
        console.error('❌ Erreur envoi email:', err);
        
        // Enregistrer l'erreur dans les logs
        await db.query(`
            INSERT INTO rotary_email_logs 
            (id, billet_id, recipient_email, email_type, subject, statut, error_message)
            VALUES (?, ?, ?, 'billet_envoye', ?, 'failed', ?)
        `, [
            generateId('EMAIL'),
            billetData.id,
            billetData.email,
            `Billet ${billetData.reference_billet}`,
            err.message
        ]);
        
        return false;
    }
}

// ==================== ROUTES ÉVÉNEMENTS ====================

// 📋 Liste tous les événements publiés
router.get('/events', async (req, res) => {
    console.log('📋 [GET /events] Récupération des événements');
    
    try {
        const [events] = await db.query(`
            SELECT 
                e.*,
                (SELECT COUNT(*) FROM rotary_billets b WHERE b.evenement_id = e.id AND b.statut_paiement = 'paye') as billets_vendus,
                (SELECT SUM(quantite) FROM rotary_billets b WHERE b.evenement_id = e.id AND b.statut_paiement = 'paye') as places_vendues
            FROM rotary_evenements e
            WHERE e.statut = 'publie' 
            AND e.date_evenement >= NOW()
            ORDER BY e.date_evenement ASC
        `);
        
        console.log(`✅ [GET /events] ${events.length} événements trouvés`);
        res.json({ success: true, events });
    } catch (err) {
        console.error('❌ [GET /events] Erreur:', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des événements', details: err.message });
    }
});

// 🔍 Détails d'un événement avec ses catégories de billets
router.get('/events/:eventId', async (req, res) => {
    const { eventId } = req.params;
    console.log(`🔍 [GET /events/${eventId}] Récupération détails événement`);
    
    try {
        const [events] = await db.query(`
            SELECT * FROM rotary_evenements WHERE id = ? AND statut = 'publie'
        `, [eventId]);
        
        if (events.length === 0) {
            return res.status(404).json({ error: 'Événement non trouvé' });
        }
        
        const [categories] = await db.query(`
            SELECT 
                id, 
                nom_categorie, 
                description, 
                prix_unitaire, 
                currency_code,
                quantite_disponible,
                quantite_vendue,
                (quantite_disponible - quantite_vendue) as places_restantes,
                couleur_badge,
                avantages
            FROM rotary_billets_categories 
            WHERE evenement_id = ? AND is_active = 1
            ORDER BY ordre_affichage ASC
        `, [eventId]);
        
        console.log(`✅ [GET /events/${eventId}] Événement trouvé avec ${categories.length} catégories`);
        res.json({ 
            success: true, 
            event: events[0], 
            categories 
        });
    } catch (err) {
        console.error(`❌ [GET /events/${eventId}] Erreur:`, err);
        res.status(500).json({ error: 'Erreur lors de la récupération de l\'événement', details: err.message });
    }
});

// 🎫 Créer un billet et initier le paiement
router.post('/tickets/create', async (req, res) => {
    console.log('\n🎫 ================================');
    console.log('🎫 [POST /tickets/create] CRÉATION DE BILLET');
    console.log('🎫 ================================');
    
    const {
        evenement_id,
        categorie_id,
        user_id,
        prenom,
        nom,
        email,
        telephone,
        quantite,
        code_promo,
        notes_participant,
        besoins_speciaux
    } = req.body;
    
    console.log('📦 Données reçues:', {
        evenement_id, categorie_id, prenom, nom, email, quantite
    });
    
    // Validation
    if (!evenement_id || !categorie_id || !prenom || !nom || !email || !quantite) {
        return res.status(400).json({ 
            error: 'Paramètres manquants', 
            required: ['evenement_id', 'categorie_id', 'prenom', 'nom', 'email', 'quantite']
        });
    }
    
    try {
        // 1. Vérifier que l'événement existe et est disponible
        const [events] = await db.query(
            'SELECT * FROM rotary_evenements WHERE id = ? AND statut = ?',
            [evenement_id, 'publie']
        );
        
        if (events.length === 0) {
            return res.status(404).json({ error: 'Événement non trouvé ou non disponible' });
        }
        
        const event = events[0];
        
        // 2. Récupérer la catégorie et vérifier la disponibilité
        const [categories] = await db.query(
            'SELECT * FROM rotary_billets_categories WHERE id = ? AND evenement_id = ? AND is_active = 1',
            [categorie_id, evenement_id]
        );
        
        if (categories.length === 0) {
            return res.status(404).json({ error: 'Catégorie de billet non trouvée' });
        }
        
        const categorie = categories[0];
        const placesRestantes = categorie.quantite_disponible ? 
            (categorie.quantite_disponible - categorie.quantite_vendue) : null;
        
        if (placesRestantes !== null && quantite > placesRestantes) {
            return res.status(400).json({ 
                error: 'Pas assez de places disponibles', 
                places_restantes: placesRestantes 
            });
        }
        
        // 3. Calculer le prix (avec réduction si code promo)
        let prix_unitaire = parseFloat(categorie.prix_unitaire);
        let montant_reduction = 0;
        let code_promo_valide = null;
        
        if (code_promo) {
            const [promos] = await db.query(`
                SELECT * FROM rotary_codes_promo 
                WHERE code = ? 
                AND is_active = 1
                AND NOW() BETWEEN date_debut AND date_fin
                AND (evenement_id IS NULL OR evenement_id = ?)
                AND (utilisation_max IS NULL OR utilisation_actuelle < utilisation_max)
            `, [code_promo, evenement_id]);
            
            if (promos.length > 0) {
                const promo = promos[0];
                if (promo.type_reduction === 'pourcentage') {
                    montant_reduction = (prix_unitaire * promo.valeur_reduction) / 100;
                } else {
                    montant_reduction = promo.valeur_reduction;
                }
                prix_unitaire -= montant_reduction;
                code_promo_valide = promo.id;
                
                await db.query(
                    'UPDATE rotary_codes_promo SET utilisation_actuelle = utilisation_actuelle + 1 WHERE id = ?',
                    [promo.id]
                );
            }
        }
        
        // 4. Calculer le montant total et générer les IDs
        // Si le frontend envoie un montant_total (avec activités optionnelles), on l'utilise
        // Sinon on calcule basé sur le prix de la catégorie
        let montant_total;
        if (req.body.montant_total && parseFloat(req.body.montant_total) > 0) {
            montant_total = parseFloat(req.body.montant_total);
            console.log('💰 Utilisation du montant_total du frontend:', montant_total);
        } else {
            montant_total = prix_unitaire * quantite;
            console.log('💰 Calcul du montant basé sur la catégorie:', montant_total);
        }
        
        const billet_id = generateId('BILLET');
        const reference_billet = generateTicketRef();
        const transaction_id = generateId('TRANS');
        const external_reference = generatePaymentRef();
        
        console.log('🆔 IDs générés:', { billet_id, reference_billet, transaction_id, external_reference });
        
        // 5. Créer le billet
        await db.query(`
            INSERT INTO rotary_billets 
            (id, reference_billet, evenement_id, categorie_id, user_id, prenom, nom, email, telephone, 
            quantite, prix_unitaire, montant_total, currency_code, statut_paiement, statut_billet,
            notes_participant, besoins_speciaux, code_promo, montant_reduction, source_achat)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'en_attente', 'actif', ?, ?, ?, ?, 'site_web')
        `, [
            billet_id, reference_billet, evenement_id, categorie_id, user_id, prenom, nom, email, telephone,
            quantite, prix_unitaire, montant_total, categorie.currency_code,
            notes_participant, besoins_speciaux, code_promo_valide, montant_reduction
        ]);
        
        console.log('✅ Billet créé:', billet_id);
        
        // 6. Créer la transaction
        await db.query(`
            INSERT INTO rotary_transactions 
            (id, billet_id, evenement_id, external_reference, montant, currency_code, 
            statut, payment_provider, payer_name, payer_email, payer_msisdn)
            VALUES (?, ?, ?, ?, ?, ?, 'pending', 'ebilling', ?, ?, ?)
        `, [
            transaction_id, billet_id, evenement_id, external_reference, 
            montant_total, categorie.currency_code,
            `${prenom} ${nom}`, email, telephone
        ]);
        
        console.log('✅ Transaction créée:', transaction_id);
        
        // 7. Incrémenter l'utilisation du code promo
        if (code_promo_valide) {
            await db.query(
                'UPDATE rotary_codes_promo SET utilisation_actuelle = utilisation_actuelle + 1 WHERE code = ?',
                [code_promo_valide]
            );
        }
        
        // 8. Créer la facture Ebilling
        const short_description = `${quantite} billet(s) ${categorie.nom_categorie} - ${event.titre}`;
        const return_url = `${FRONTEND_URL}/rotary/payment-result?ref=${reference_billet}`;
        
        // Nettoyer et formater le numéro de téléphone pour Ebilling
        let cleanedPhone = telephone ? telephone.trim().replace(/\s+/g, '') : '00000000';
        
        // Si le numéro commence par 0, remplacer par +241 (Gabon)
        if (cleanedPhone !== '00000000' && cleanedPhone.startsWith('0')) {
            cleanedPhone = '+241' + cleanedPhone.substring(1);
        }
        
        // S'assurer que le numéro commence par + (sauf si 00000000)
        if (cleanedPhone !== '00000000' && !cleanedPhone.startsWith('+')) {
            cleanedPhone = '+' + cleanedPhone;
        }
        
        const ebillingData = {
            payer_msisdn: cleanedPhone,
            payer_email: email,
            payer_name: `${prenom} ${nom}`,
            amount: Math.round(montant_total), // Ebilling n'accepte que des entiers
            external_reference: external_reference,
            short_description: short_description,
            expiry_period: '100',
            return_url: return_url,
            notification_url: EB_CALLBACK_URL
        };
        
        const auth = Buffer.from(`${EBILLING_USERNAME}:${EBILLING_SHARED_KEY}`).toString('base64');
        
        console.log('🌐 Envoi vers Ebilling...', ebillingData);
        
        const ebillingResponse = await axios.post(EBILLING_URL, ebillingData, {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': `Basic ${auth}`
            }
        });
        
        console.log('✅ Facture Ebilling créée:', ebillingResponse.data);
        
        if (ebillingResponse.data && ebillingResponse.data.e_bill) {
            const bill = ebillingResponse.data.e_bill;
            
            // Mettre à jour la transaction avec bill_id
            await db.query(
                'UPDATE rotary_transactions SET bill_id = ?, transaction_id = ? WHERE id = ?',
                [bill.bill_id, bill.bill_id, transaction_id]
            );
            
            console.log('🎉 Processus complet! Bill ID:', bill.bill_id);
            console.log('🎫 ================================\n');
            
            res.status(201).json({
                success: true,
                message: 'Billet créé avec succès',
                data: {
                    billet_id,
                    reference_billet,
                    transaction_id,
                    bill_id: bill.bill_id,
                    payment_url: bill.payment_url,
                    montant_total,
                    currency_code: categorie.currency_code,
                    event: {
                        titre: event.titre,
                        date: event.date_evenement,
                        lieu: event.lieu
                    }
                }
            });
        } else {
            throw new Error('Réponse Ebilling invalide');
        }
        
    } catch (err) {
        console.error('❌ Erreur création billet:', err);
        res.status(500).json({ 
            error: 'Erreur lors de la création du billet', 
            details: err.response?.data || err.message 
        });
    }
});

// 🔔 Webhook - Recevoir les notifications de paiement Ebilling
router.post('/webhook', async (req, res) => {
    console.log('\n🔔 ================================');
    console.log('🔔 [POST /webhook] NOTIFICATION EBILLING ROTARY');
    console.log('🔔 ================================');
    console.log('📦 Body complet:', JSON.stringify(req.body, null, 2));
    
    const bill_id = req.body.billingid || req.body.bill_id;
    const external_reference = req.body.reference || req.body.external_reference;
    const status = req.body.state || req.body.status;
    const amount = req.body.amount;
    const payment_method = req.body.paymentsystem || req.body.payment_method;
    
    console.log('📊 Données extraites:', { bill_id, external_reference, status, amount, payment_method });
    
    try {
        // 1. Trouver la transaction
        const [transactions] = await db.query(
            'SELECT * FROM rotary_transactions WHERE bill_id = ? OR external_reference = ?',
            [bill_id, external_reference]
        );
        
        if (transactions.length === 0) {
            console.warn('⚠️ Transaction non trouvée');
            return res.status(404).json({ error: 'Transaction non trouvée' });
        }
        
        const transaction = transactions[0];
        console.log('✅ Transaction trouvée:', transaction.id);
        
        // 2. Mettre à jour la transaction
        let new_status = 'pending';
        if (status === 'paid' || status === 'completed' || status === 'success') {
            new_status = 'success';
        } else if (status === 'failed' || status === 'cancelled') {
            new_status = 'failed';
        }
        
        await db.query(`
            UPDATE rotary_transactions 
            SET statut = ?, 
                payment_method = ?,
                payment_details = ?,
                webhook_received_at = NOW()
            WHERE id = ?
        `, [new_status, payment_method, JSON.stringify(req.body), transaction.id]);
        
        console.log(`✅ Transaction mise à jour: ${new_status}`);
        
        // 3. Si paiement réussi, mettre à jour le billet
        if (new_status === 'success') {
            console.log('💰 Paiement réussi détecté, traitement...');
            
            await db.query(
                'UPDATE rotary_billets SET statut_paiement = ? WHERE id = ?',
                ['paye', transaction.billet_id]
            );
            console.log('✅ Statut billet mis à jour en "paye"');
            
            // Récupérer les détails complets du billet pour l'email
            console.log('🔍 Récupération des détails du billet:', transaction.billet_id);
            const [billets] = await db.query(`
                SELECT 
                    b.*,
                    c.nom_categorie,
                    e.titre as evenement_titre,
                    e.date_evenement,
                    e.lieu,
                    e.organisateur_nom
                FROM rotary_billets b
                INNER JOIN rotary_billets_categories c ON b.categorie_id = c.id
                INNER JOIN rotary_evenements e ON b.evenement_id = e.id
                WHERE b.id = ?
            `, [transaction.billet_id]);
            
            console.log('📊 Nombre de billets trouvés:', billets.length);
            
            if (billets.length > 0) {
                const billet = billets[0];
                console.log('✅ Billet récupéré:', billet.reference_billet);
                console.log('📧 Email destinataire:', billet.email);
                
                // Incrémenter le compteur de billets vendus
                await db.query(
                    'UPDATE rotary_billets_categories SET quantite_vendue = quantite_vendue + ? WHERE id = ?',
                    [billet.quantite, billet.categorie_id]
                );
                console.log('✅ Compteur de billets vendus incrémenté');
                
                console.log('🎉 PAIEMENT CONFIRMÉ - Billet validé!');
                
                // Envoyer notification à l'admin du paiement reçu
                await sendAdminNotification('payment_received', billet, {
                    titre: billet.evenement_titre,
                    date_evenement: billet.date_evenement,
                    lieu: billet.lieu,
                    organisateur_nom: billet.organisateur_nom
                });
                
                try {
                    // Générer QR code avec les infos du billet
                    const qrData = JSON.stringify({
                        reference: billet.reference_billet,
                        evenement: billet.evenement_titre,
                        nom: `${billet.prenom} ${billet.nom}`,
                        date: billet.date_evenement,
                        categorie: billet.nom_categorie,
                        quantite: billet.quantite
                    });
                    
                    console.log('🔲 Génération du QR code...');
                    const qrCodeBase64 = await generateQRCodeBase64(qrData);
                    
                    if (qrCodeBase64) {
                        console.log('✅ QR code généré avec succès');
                        
                        // Mettre à jour le billet avec l'URL du QR code
                        await db.query(
                            'UPDATE rotary_billets SET qr_code_url = ? WHERE id = ?',
                            [qrCodeBase64, billet.id]
                        );
                        console.log('✅ QR code enregistré dans la base de données');
                        
                        // Envoyer l'email avec le QR code
                        console.log('📧 Préparation de l\'envoi de l\'email...');
                        const eventDataForEmail = {
                            titre: billet.evenement_titre,
                            date_evenement: billet.date_evenement,
                            lieu: billet.lieu,
                            organisateur_nom: billet.organisateur_nom
                        };
                        
                        const emailSent = await sendTicketEmail(
                            billet,
                            eventDataForEmail,
                            qrCodeBase64
                        );
                        
                        if (emailSent) {
                            console.log('✅ ✅ ✅ Email envoyé avec succès à:', billet.email);
                        } else {
                            console.error('⚠️ Échec envoi email, mais billet validé');
                        }
                    } else {
                        console.error('⚠️ Échec génération QR code');
                    }
                } catch (qrEmailError) {
                    console.error('❌ Erreur lors de la génération QR/envoi email:', qrEmailError);
                    console.error('Stack:', qrEmailError.stack);
                }
            } else {
                console.error('⚠️ Aucun billet trouvé pour l\'ID:', transaction.billet_id);
            }
        }
        
        console.log('🔔 ================================\n');
        res.status(200).json({ success: true, message: 'Notification traitée' });
        
    } catch (err) {
        console.error('❌ Erreur webhook:', err);
        res.status(500).json({ error: 'Erreur traitement webhook', details: err.message });
    }
});

// 🔍 Vérifier le statut d'un billet
router.get('/tickets/:reference', async (req, res) => {
    const { reference } = req.params;
    console.log(`🔍 [GET /tickets/${reference}] Vérification statut billet`);
    
    try {
        const [billets] = await db.query(`
            SELECT 
                b.*,
                e.titre as evenement_titre,
                e.date_evenement,
                e.lieu,
                e.statut as evenement_statut,
                e.organisateur_nom,
                c.nom_categorie,
                t.statut as transaction_statut,
                t.bill_id,
                t.payment_method
            FROM rotary_billets b
            INNER JOIN rotary_evenements e ON b.evenement_id = e.id
            INNER JOIN rotary_billets_categories c ON b.categorie_id = c.id
            LEFT JOIN rotary_transactions t ON b.id = t.billet_id
            WHERE b.reference_billet = ?
        `, [reference]);
        
        if (billets.length === 0) {
            return res.status(404).json({ error: 'Billet non trouvé' });
        }
        
        const billet = billets[0];
        console.log('✅ Billet trouvé:', billet.id, '- Statut:', billet.statut_paiement);
        
        // Si le billet est payé et qu'il n'a pas encore de QR code, générer et envoyer l'email
        if (billet.statut_paiement === 'paye' && !billet.qr_code_url) {
            console.log('🎉 Billet payé détecté - Envoi de l\'email avec QR code...');
            
            try {
                // Générer QR code
                const qrData = JSON.stringify({
                    reference: billet.reference_billet,
                    evenement: billet.evenement_titre,
                    nom: `${billet.prenom} ${billet.nom}`,
                    date: billet.date_evenement,
                    categorie: billet.nom_categorie,
                    quantite: billet.quantite
                });
                
                console.log('🔲 Génération du QR code...');
                const qrCodeBase64 = await generateQRCodeBase64(qrData);
                
                if (qrCodeBase64) {
                    console.log('✅ QR code généré avec succès');
                    
                    // Mettre à jour le billet avec l'URL du QR code
                    await db.query(
                        'UPDATE rotary_billets SET qr_code_url = ? WHERE id = ?',
                        [qrCodeBase64, billet.id]
                    );
                    console.log('✅ QR code enregistré dans la base de données');
                    
                    // Mettre à jour l'objet billet avec le QR code
                    billet.qr_code_url = qrCodeBase64;
                    
                    // Envoyer l'email avec le QR code
                    console.log('📧 Préparation de l\'envoi de l\'email...');
                    const eventDataForEmail = {
                        titre: billet.evenement_titre,
                        date_evenement: billet.date_evenement,
                        lieu: billet.lieu,
                        organisateur_nom: billet.organisateur_nom
                    };
                    
                    const emailSent = await sendTicketEmail(
                        billet,
                        eventDataForEmail,
                        qrCodeBase64
                    );
                    
                    if (emailSent) {
                        console.log('✅ ✅ ✅ Email envoyé avec succès à:', billet.email);
                    } else {
                        console.warn('⚠️ Échec envoi email, mais QR code généré');
                    }
                } else {
                    console.error('⚠️ Échec génération QR code');
                }
            } catch (qrEmailError) {
                console.error('❌ Erreur lors de la génération QR/envoi email:', qrEmailError);
                console.error('Stack:', qrEmailError.stack);
                // On continue quand même pour renvoyer les données du billet
            }
        } else if (billet.statut_paiement === 'paye' && billet.qr_code_url) {
            console.log('✅ Billet déjà traité (QR code existant)');
        } else {
            console.log('⏳ Billet en attente de paiement');
        }
        
        res.json({ success: true, ticket: billet });
        
    } catch (err) {
        console.error('❌ Erreur récupération billet:', err);
        res.status(500).json({ error: 'Erreur lors de la récupération du billet', details: err.message });
    }
});

// 📊 Mes billets (par email ou user_id)
router.get('/my-tickets', async (req, res) => {
    const { email, user_id } = req.query;
    console.log('📊 [GET /my-tickets] Récupération billets:', { email, user_id });
    
    if (!email && !user_id) {
        return res.status(400).json({ error: 'email ou user_id requis' });
    }
    
    try {
        let query = `
            SELECT 
                b.*,
                e.titre as evenement_titre,
                e.date_evenement,
                e.lieu,
                e.image_url as evenement_image,
                c.nom_categorie,
                t.statut as transaction_statut
            FROM rotary_billets b
            INNER JOIN rotary_evenements e ON b.evenement_id = e.id
            INNER JOIN rotary_billets_categories c ON b.categorie_id = c.id
            LEFT JOIN rotary_transactions t ON b.id = t.billet_id
            WHERE 1=1
        `;
        
        const params = [];
        if (email) {
            query += ' AND b.email = ?';
            params.push(email);
        }
        if (user_id) {
            query += ' AND b.user_id = ?';
            params.push(user_id);
        }
        
        query += ' ORDER BY b.created_at DESC';
        
        const [billets] = await db.query(query, params);
        
        console.log(`✅ ${billets.length} billets trouvés`);
        res.json({ success: true, tickets: billets });
        
    } catch (err) {
        console.error('❌ Erreur récupération billets:', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des billets', details: err.message });
    }
});

// 📈 Statistiques d'un événement (admin)
router.get('/events/:eventId/stats', async (req, res) => {
    const { eventId } = req.params;
    console.log(`📈 [GET /events/${eventId}/stats] Statistiques`);
    
    try {
        const [stats] = await db.query(`
            SELECT * FROM rotary_stats_evenements WHERE evenement_id = ?
        `, [eventId]);
        
        if (stats.length === 0) {
            return res.status(404).json({ error: 'Événement non trouvé' });
        }
        
        // Détail par catégorie
        const [categoriesStats] = await db.query(`
            SELECT 
                c.nom_categorie,
                c.prix_unitaire,
                c.quantite_disponible,
                c.quantite_vendue,
                (c.quantite_disponible - c.quantite_vendue) as places_restantes,
                COUNT(DISTINCT b.id) as nb_billets,
                SUM(b.quantite) as total_places,
                SUM(CASE WHEN b.statut_paiement = 'paye' THEN b.montant_total ELSE 0 END) as revenus
            FROM rotary_billets_categories c
            LEFT JOIN rotary_billets b ON c.id = b.categorie_id
            WHERE c.evenement_id = ?
            GROUP BY c.id
        `, [eventId]);
        
        console.log('✅ Statistiques récupérées');
        res.json({ 
            success: true, 
            stats: stats[0],
            categories: categoriesStats
        });
        
    } catch (err) {
        console.error('❌ Erreur statistiques:', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des statistiques', details: err.message });
    }
});

// ✅ Valider un code promo
router.post('/validate-promo', async (req, res) => {
    const { code, evenement_id } = req.body;
    console.log('🎟️ [POST /validate-promo] Validation code:', code);
    
    if (!code) {
        return res.status(400).json({ error: 'Code requis' });
    }
    
    try {
        const [promos] = await db.query(`
            SELECT * FROM rotary_codes_promo 
            WHERE code = ? 
            AND is_active = 1
            AND NOW() BETWEEN date_debut AND date_fin
            AND (evenement_id IS NULL OR evenement_id = ?)
            AND (utilisation_max IS NULL OR utilisation_actuelle < utilisation_max)
        `, [code, evenement_id || null]);
        
        if (promos.length === 0) {
            return res.status(404).json({ 
                valid: false, 
                error: 'Code promo invalide ou expiré' 
            });
        }
        
        const promo = promos[0];
        console.log('✅ Code promo valide:', promo.id);
        
        res.json({
            valid: true,
            promo: {
                code: promo.code,
                type_reduction: promo.type_reduction,
                valeur_reduction: promo.valeur_reduction,
                description: promo.description
            }
        });
        
    } catch (err) {
        console.error('❌ Erreur validation promo:', err);
        res.status(500).json({ error: 'Erreur lors de la validation du code promo', details: err.message });
    }
});

// 📧 Envoyer manuellement l'email pour un billet payé (Admin)
router.post('/tickets/:reference/resend-email', async (req, res) => {
    const { reference } = req.params;
    console.log(`📧 [POST /tickets/${reference}/resend-email] Renvoi manuel email`);
    
    try {
        // Récupérer les détails du billet
        const [billets] = await db.query(`
            SELECT 
                b.*,
                c.nom_categorie,
                e.titre as evenement_titre,
                e.date_evenement,
                e.lieu,
                e.organisateur_nom
            FROM rotary_billets b
            INNER JOIN rotary_billets_categories c ON b.categorie_id = c.id
            INNER JOIN rotary_evenements e ON b.evenement_id = e.id
            WHERE b.reference_billet = ?
        `, [reference]);
        
        if (billets.length === 0) {
            return res.status(404).json({ error: 'Billet non trouvé' });
        }
        
        const billet = billets[0];
        
        // Vérifier que le billet est bien payé
        if (billet.statut_paiement !== 'paye') {
            return res.status(400).json({ 
                error: 'Le billet doit être payé pour envoyer l\'email',
                statut: billet.statut_paiement
            });
        }
        
        console.log('✅ Billet payé trouvé, génération QR code...');
        
        // Générer ou récupérer le QR code
        let qrCodeBase64 = billet.qr_code_url;
        
        if (!qrCodeBase64) {
            const qrData = JSON.stringify({
                reference: billet.reference_billet,
                evenement: billet.evenement_titre,
                nom: `${billet.prenom} ${billet.nom}`,
                date: billet.date_evenement,
                categorie: billet.nom_categorie,
                quantite: billet.quantite
            });
            
            qrCodeBase64 = await generateQRCodeBase64(qrData);
            
            if (qrCodeBase64) {
                // Enregistrer le QR code
                await db.query(
                    'UPDATE rotary_billets SET qr_code_url = ? WHERE id = ?',
                    [qrCodeBase64, billet.id]
                );
                console.log('✅ QR code généré et enregistré');
            } else {
                return res.status(500).json({ error: 'Échec génération QR code' });
            }
        }
        
        // Envoyer l'email
        const eventData = {
            titre: billet.evenement_titre,
            date_evenement: billet.date_evenement,
            lieu: billet.lieu,
            organisateur_nom: billet.organisateur_nom
        };
        
        const emailSent = await sendTicketEmail(billet, eventData, qrCodeBase64);
        
        if (emailSent) {
            console.log('✅ Email renvoyé avec succès');
            res.json({ 
                success: true, 
                message: 'Email envoyé avec succès',
                recipient: billet.email
            });
        } else {
            res.status(500).json({ error: 'Échec lors de l\'envoi de l\'email' });
        }
        
    } catch (err) {
        console.error('❌ Erreur renvoi email:', err);
        res.status(500).json({ 
            error: 'Erreur lors du renvoi de l\'email', 
            details: err.message 
        });
    }
});

module.exports = router;


import React, { useState, useEffect } from 'react';
import { MessageCircleIcon, PhoneIcon, MapPinIcon, CalendarIcon, UsersIcon, ClockIcon, UserPlusIcon, CheckCircleIcon, InfoIcon, HeartIcon, ArrowRightIcon, DownloadIcon, FileTextIcon, ContactIcon } from 'lucide-react';
import DroitsInscription from './DroitsInscription';
import axios from 'axios';

// Configuration API
const API_BASE_URL =  'https://fwwm7ch7se.us-east-1.awsapprunner.com';
const EVENT_ID = 'EV-ROTARY-FORUM-2026';

// Mapping qualité -> catégorie_id
const CATEGORY_MAPPING: Record<string, { id: string; prix: number }> = {
  rotarien: { id: 'CAT-FORUM-2026-ROTARIEN', prix: 40000 },
  rotaractien: { id: 'CAT-FORUM-2026-ROTARACTIEN', prix: 30000 },
  invite: { id: 'CAT-FORUM-2026-INVITE', prix: 35000 }
};

const ACTIVITY_MAPPING: Record<string, { id: string; prix: number }> = {
  // 'Excursion Omboué': { id: 'CAT-FORUM-2026-EXCURSION', prix: 30000 },
  'POG TOUR': { id: 'CAT-FORUM-2026-POG-TOUR', prix: 20000 }
};

export function Contact() {
  const [currentView, setCurrentView] = useState<'contact' | 'droits'>('contact');
  const [formData, setFormData] = useState({
    name: '',
    prenom: '',
    email: '',
    phone: '',
    club: '',
    function: '',
    qualite: 'rotarien',
    accommodation: 'none',
    activite: 'none',
    message: ''
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitStatus, setSubmitStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const [errorMessage, setErrorMessage] = useState('');
  const [totalAmount, setTotalAmount] = useState(0);

  // Calculer le montant total
  useEffect(() => {
    let total = 0;
    
    // Prix de base selon la qualité
    if (formData.qualite && CATEGORY_MAPPING[formData.qualite]) {
      total += CATEGORY_MAPPING[formData.qualite].prix;
    }
    
    // Prix activité optionnelle
    if (formData.activite !== 'none' && ACTIVITY_MAPPING[formData.activite]) {
      total += ACTIVITY_MAPPING[formData.activite].prix;
    }
    
    setTotalAmount(total);
  }, [formData.qualite, formData.activite]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setErrorMessage('');
    
    try {
      // Validation
      if (!formData.name || !formData.prenom || !formData.email || !formData.phone || !formData.club) {
        throw new Error('Veuillez remplir tous les champs obligatoires');
      }

      // Récupérer la catégorie selon la qualité
      const category = CATEGORY_MAPPING[formData.qualite];
      if (!category) {
        throw new Error('Qualité invalide');
      }

      // Calculer le montant total
      let montantTotal = category.prix;
      let activiteInfo = '';
      
      // Ajouter le prix de l'activité si sélectionnée
      if (formData.activite !== 'none' && ACTIVITY_MAPPING[formData.activite]) {
        montantTotal += ACTIVITY_MAPPING[formData.activite].prix;
        activiteInfo = ` + ${formData.activite} (${ACTIVITY_MAPPING[formData.activite].prix.toLocaleString()} F)`;
      }

      // Préparer les données pour l'API
      const ticketData = {
        evenement_id: EVENT_ID,
        categorie_id: category.id,
        prenom: formData.prenom,
        nom: formData.name,
        email: formData.email,
        telephone: formData.phone,
        quantite: 1,
        montant_total: montantTotal,
        activite_optionnelle: formData.activite !== 'none' ? formData.activite : null,
        notes_participant: `Club: ${formData.club}\nHébergement: ${formData.accommodation}\nActivité: ${formData.activite}${activiteInfo}\n${formData.message}`
      };

      console.log('📤 Envoi des données:', ticketData);
      console.log('💰 Montant total:', montantTotal.toLocaleString(), 'F');

      // Appeler l'API de création de billet
      const response = await axios.post(`${API_BASE_URL}/rotary/tickets/create`, ticketData);

      console.log('✅ Réponse API complète:', response.data);

      // Récupérer le bill_id depuis différentes structures possibles
      let billId = response.data.data?.bill_id || 
                   response.data.bill_id || 
                   response.data.e_bill?.bill_id || 
                   response.data.data?.e_bill?.bill_id;
      
      let paymentUrl = response.data.payment_url || response.data.data?.payment_url;
      const referenceBillet = response.data.data?.reference_billet || response.data.reference_billet;

      console.log('🔍 Bill ID trouvé:', billId);
      console.log('🎫 Référence billet:', referenceBillet);
      
      // Construire l'URL de paiement Ebilling
      if (billId) {
        if (!paymentUrl) {
          const returnUrl = `${window.location.origin}/payment-result?ref=${referenceBillet}`;
          paymentUrl = `https://test.billing-easy.net?invoice=${billId}&redirect_url=${encodeURIComponent(returnUrl)}`;
          console.log('🔧 URL de paiement construite:', paymentUrl);
        }
        
        // Rediriger vers la page de paiement Ebilling
        console.log('🔗 Redirection vers Ebilling...');
        console.log('💳 Bill ID:', billId);
        window.location.href = paymentUrl;
      } else {
        console.error('❌ Aucun bill_id trouvé dans la réponse:', response.data);
        throw new Error('Impossible de récupérer le numéro de facture Ebilling');
      }

    } catch (error: any) {
      console.error('❌ Erreur:', error);
      setIsSubmitting(false);
      setSubmitStatus('error');
      setErrorMessage(error.response?.data?.error || error.message || 'Une erreur est survenue');
      
      setTimeout(() => {
        setSubmitStatus('idle');
        setErrorMessage('');
      }, 5000);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const forumInfo = [
    {
      icon: CalendarIcon,
      title: 'Dates du Forum',
      content: '20-22 Février 2026',
      subtitle: '3 jours d\'enrichissement'
    },
    {
      icon: MapPinIcon,
      title: 'Lieu',
      content: 'Canal Olympia, Port-Gentil',
      subtitle: 'Espace vente disponible'
    },
    {
      icon: UsersIcon,
      title: 'Participants',
      content: 'Tous les Clubs Rotary',
      subtitle: 'Membres et invités bienvenus'
    },
    {
      icon: ClockIcon,
      title: 'Programme',
      content: 'Conférences & Ateliers',
      subtitle: 'Excursion à Omboué incluse'
    }
  ];

  const registrationSteps = [
    {
      step: 1,
      title: 'Inscription WhatsApp',
      description: 'Rejoignez notre groupe WhatsApp officiel pour recevoir toutes les informations en temps réel',
      action: 'Rejoindre le Groupe'
    },
    {
      step: 2,
      title: 'Formulaire Complet',
      description: 'Remplissez le formulaire ci-dessous avec toutes vos informations',
      action: 'Remplir le Formulaire'
    },
    {
      step: 3,
      title: 'Confirmation',
      description: 'Nous vous contacterons pour confirmer votre inscription et vous donner les détails pratiques',
      action: 'Attendre la Confirmation'
    }
  ];

  return (
    <div className="w-full">
      {/* Navigation Tabs */}
      <div className="bg-white border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <nav className="flex justify-center space-x-8">
            <button
              onClick={() => setCurrentView('contact')}
              className={`py-4 px-6 border-b-2 font-medium text-lg flex items-center space-x-2 ${
                currentView === 'contact'
                  ? 'border-[#f7a81b] text-[#f7a81b]'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              <ContactIcon className="w-5 h-5" />
              <span>Contact & Inscription</span>
            </button>
            <button
              onClick={() => setCurrentView('droits')}
              className={`py-4 px-6 border-b-2 font-medium text-lg flex items-center space-x-2 ${
                currentView === 'droits'
                  ? 'border-[#f7a81b] text-[#f7a81b]'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`}
            >
              <FileTextIcon className="w-5 h-5" />
              <span>Droits d'Inscription</span>
            </button>
          </nav>
        </div>
      </div>

      {/* Content based on selected view */}
      {(() => {
        switch (currentView) {
          case 'droits':
            return <DroitsInscription />;
          case 'contact':
          default:
            return (
              <>
                {/* Hero Section */}
                <div className="relative bg-gradient-to-br from-[#0277BD] via-black to-black text-white py-20 overflow-hidden">
        <div className="absolute inset-0">
          <img 
            src="/un-etudiant-en-medecine-noir-en-peignoir-fait-des-recherches-et-prend-des-notes-pour-sa-these.jpg"
            alt="Affiche officielle 22ème Forum des Clubs Rotary - Inscription" 
            className="w-full h-full object-cover opacity-20" 
          />
        </div>
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-5xl font-bold mb-6">Inscription Forum 2026</h1>
          <p className="text-xl text-blue-100 mx-auto mb-6">
            Rejoignez-nous pour le 22ème Forum des Clubs Rotary
          </p>
          <div className="text-2xl font-bold text-[#F9A825] italic">
            "Unis pour Faire le Bien et Donner du Bonheur Ensemble et Autrement"
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        {/* Inscription WhatsApp Mise en Avant */}
        

        {/* Étapes d'inscription */}
        <div className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 text-center mb-12">
            Comment S'inscrire en 3 Étapes
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {registrationSteps.map((step, index) => (
              <div key={index} className="relative">
                <div className="bg-white rounded-2xl shadow-xl p-8 text-center h-full">
                  <div className="w-16 h-16 bg-[#F9A825] text-blue-900 rounded-full flex items-center justify-center text-2xl font-bold mx-auto mb-6">
                    {step.step}
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 mb-4">{step.title}</h3>
                  <p className="text-gray-600 mb-6 leading-relaxed">{step.description}</p>
                  <div className="inline-flex items-center text-[#01579B] font-semibold">
                    <CheckCircleIcon className="w-5 h-5 mr-2" />
                    {step.action}
                  </div>
                </div>
                {index < registrationSteps.length - 1 && (
                  <div className="hidden md:block absolute top-1/2 -right-4 transform -translate-y-1/2">
                    <ArrowRightIcon className="w-8 h-8 text-[#F9A825]" />
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-12 mb-16">
          {/* Formulaire d'inscription */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-2xl shadow-xl p-8">
              <h2 className="text-3xl font-bold text-gray-900 mb-6 flex items-center">
                <UserPlusIcon className="w-8 h-8 mr-3 text-[#01579B]" />
                Formulaire d'Inscription
              </h2>
              
              {submitStatus === 'success' && (
                <div className="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                  <p className="text-green-800 font-semibold flex items-center">
                    <CheckCircleIcon className="w-5 h-5 mr-2" />
                    Inscription enregistrée avec succès ! Nous vous contacterons bientôt.
                  </p>
                </div>
              )}

              {submitStatus === 'error' && (
                <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                  <p className="text-red-800 font-semibold flex items-center">
                    <InfoIcon className="w-5 h-5 mr-2" />
                    {errorMessage || 'Une erreur est survenue. Veuillez réessayer.'}
                  </p>
                </div>
              )}

              <form onSubmit={handleSubmit} className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label htmlFor="name" className="block text-sm font-semibold text-gray-700 mb-2">
                      Nom Complet *
                    </label>
                    <input 
                      type="text" 
                      id="name" 
                      name="name" 
                      value={formData.name} 
                      onChange={handleChange} 
                      required 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent" 
                      placeholder="Votre nom complet" 
                    />
                  </div>
                  <div>
                    <label htmlFor="prenom" className="block text-sm font-semibold text-gray-700 mb-2">
                      Prénom *
                    </label>
                    <input 
                      type="text" 
                      id="prenom" 
                      name="prenom" 
                      value={formData.prenom} 
                      onChange={handleChange} 
                      required 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent" 
                      placeholder="Votre prénom" 
                    />
                  </div>
                  <div>
                    <label htmlFor="email" className="block text-sm font-semibold text-gray-700 mb-2">
                      Email *
                    </label>
                    <input 
                      type="email" 
                      id="email" 
                      name="email" 
                      value={formData.email} 
                      onChange={handleChange} 
                      required 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent" 
                      placeholder="votre@email.com" 
                    />
                  </div>
                  <div>
                    <label htmlFor="phone" className="block text-sm font-semibold text-gray-700 mb-2">
                      Téléphone *
                    </label>
                    <input 
                      type="tel" 
                      id="phone" 
                      name="phone" 
                      value={formData.phone} 
                      onChange={handleChange} 
                      required 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent" 
                      placeholder="077679339" 
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label htmlFor="qualite" className="block text-sm font-semibold text-gray-700 mb-2">
                      Qualité *
                    </label>
                    <select 
                      id="qualite" 
                      name="qualite" 
                      value={formData.qualite} 
                      onChange={handleChange} 
                      required
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent"
                    >
                      <option value="rotarien">Rotarien  (40 000 F) </option>
                      <option value="rotaractien">Rotaractien  (30 000 F) </option>
                      <option value="invite">Invité  (35 000 F) </option>
                    </select>
                  </div>
                  <div>
                    <label htmlFor="club" className="block text-sm font-semibold text-gray-700 mb-2">
                      Club *
                    </label>
                    <select 
                      id="club" 
                      name="club" 
                      value={formData.club} 
                      onChange={handleChange} 
                      required 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent"
                    >
                      <option value="">Sélectionnez votre club</option>
                      <optgroup label="ROTARY CLUBS DU GABON">
                        <option value="ROTARY CLUB LIBREVILLE DOYEN">ROTARY CLUB LIBREVILLE DOYEN</option>
                        <option value="ROTARY CLUB PORT-GENTIL">ROTARY CLUB PORT-GENTIL</option>
                        <option value="ROTARY CLUB LIBREVILLE OKOUME">ROTARY CLUB LIBREVILLE OKOUME</option>
                        <option value="ROTARY CLUB PORT-GENTIL OZOURI">ROTARY CLUB PORT-GENTIL OZOURI</option>
                        <option value="ROTARY CLUB LIBREVILLE KOMO">ROTARY CLUB LIBREVILLE KOMO</option>
                        <option value="ROTARY CLUB LIBREVILLE MONDAH">ROTARY CLUB LIBREVILLE MONDAH</option>
                        <option value="ROTARY CLUB LIBREVILLE MONTS DE CRISTAL">ROTARY CLUB LIBREVILLE MONTS DE CRISTAL</option>
                        <option value="ROTARY CLUB LIBREVILLE CENTRE">ROTARY CLUB LIBREVILLE CENTRE</option>
                        <option value="ROTARY CLUB LIBREVILLE AKANDA">ROTARY CLUB LIBREVILLE AKANDA</option>
                        <option value="ROTARY CLUB LIBREVILLE SUD">ROTARY CLUB LIBREVILLE SUD</option>
                        <option value="ROTARY CLUB LIBREVILLE BANTOU">ROTARY CLUB LIBREVILLE BANTOU</option>
                      </optgroup>
                      <optgroup label="ROTARACT CLUBS DU GABON">
                        <option value="ROTARACT CLUB LIBREVILLE DOYEN">ROTARACT CLUB LIBREVILLE DOYEN</option>
                        <option value="ROTARACT CLUB PORT-GENTIL OZOURI">ROTARACT CLUB PORT-GENTIL OZOURI</option>
                        <option value="ROTARACT CLUB PORT-GENTIL">ROTARACT CLUB PORT-GENTIL</option>
                        <option value="ROTARACT CLUB LIBREVILLE MONTS DE CRISTAL">ROTARACT CLUB LIBREVILLE MONTS DE CRISTAL</option>
                        <option value="ROTARACT CLUB LIBREVILLE KOMO">ROTARACT CLUB LIBREVILLE KOMO</option>
                        <option value="ROTARACT CLUB LIBREVILLE AKANDA">ROTARACT CLUB LIBREVILLE AKANDA</option>
                        <option value="ROTARACT CLUB LIBREVILLE SUD">ROTARACT CLUB LIBREVILLE SUD</option>
                        <option value="ROTARACT CLUB LIBREVILLE BANTOU">ROTARACT CLUB LIBREVILLE BANTOU</option>
                      </optgroup>
                      <optgroup label="INTERACT CLUBS DU GABON">
                        <option value="INTERACT CLUB LIBREVILLE DOYEN">INTERACT CLUB LIBREVILLE DOYEN</option>
                      </optgroup>
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  
                  <div>
                    <label htmlFor="accommodation" className="block text-sm font-semibold text-gray-700 mb-2">
                      Hébergement
                    </label>
                    <select 
                      id="accommodation" 
                      name="accommodation" 
                      value={formData.accommodation} 
                      onChange={handleChange} 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent"
                    >
                      <option value="none">Pas d'hébergement</option>
                      <option value="external">Hébergement externe</option>
                      <optgroup label="Hôtels 4 étoiles">
                        <option value="Hôtel TARA-ME">Hôtel TARA-ME </option>
                        <option value="Hôtel MANDJI LOISIRS">Hôtel MANDJI LOISIRS </option>
                        <option value="Hôtel CHEZ JIMMY">Hôtel CHEZ JIMMY </option>
                        <option value="Hôtel HIBISCUS">Hôtel HIBISCUS </option>
                        <option value="Hôtel DU PARC">Hôtel DU PARC </option>
                        <option value="Hôtel MANDJI">Hôtel MANDJI - Ancien Méridien</option>
                        <option value="Hôtel ISIS">Hôtel ISIS </option>
                        <option value="Hôtel LE BOUGAINVILLIER">Hôtel LE BOUGAINVILLIER</option>
                        <option value="RÉSIDENCE YASMANNI">RÉSIDENCE YASMANNI </option>
                      </optgroup>
                      <optgroup label="Hôtels 3 étoiles">
                        <option value="Hôtel OPHELIA LODGE">Hôtel OPHELIA LODGE </option>
                        <option value="Hôtel LE BAMBOU">Hôtel LE BAMBOU </option>
                        <option value="Hôtel LE RANCH">Hôtel LE RANCH</option>
                        <option value="Hôtel SICKA">Hôtel SICKA </option>
                        <option value="LE GUI">LE GUI </option>
                        <option value="LE PRINTEMPS">LE PRINTEMPS </option>
                        <option value="ERING PALACE">ERING PALACE </option>
                      </optgroup>
                      <optgroup label="Hôtels 2 étoiles">
                        <option value="CHEZ OLLA">CHEZ OLLA </option>
                      </optgroup>
                    </select>
                  </div>
                  <div>
                    <label htmlFor="activite" className="block text-sm font-semibold text-gray-700 mb-2">
                      Activité optionnelle
                    </label>
                    <select 
                      id="activite" 
                      name="activite" 
                      value={formData.activite} 
                      onChange={handleChange} 
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent"
                    >
                      <option value="none">Pas d'activité</option>
                      {/* <option value="Excursion Omboué">Excursion Omboué (30 000 F)</option> */}
                      <option value="POG TOUR">POG TOUR (20 000 F)</option>
                    </select>
                  </div>

                </div>

                <div>
                  <label htmlFor="message" className="block text-sm font-semibold text-gray-700 mb-2">
                    Message
                  </label>
                  <textarea 
                    id="message" 
                    name="message" 
                    value={formData.message} 
                    onChange={handleChange} 
                    rows={4} 
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#01579B] focus:border-transparent resize-none" 
                  />
                </div>

                {/* Section Paiement Mobile */}
                <div className="bg-gradient-to-r from-blue-50 to-green-50 rounded-xl p-6 border-2 border-blue-200">
                  <div className="flex flex-col md:flex-row items-center justify-between gap-6">
                    <div className="text-center md:text-left flex-1">
                      <h3 className="text-xl font-bold text-gray-900 mb-2">
                        Paiement Mobile et Numérique
                      </h3>
                      <p className="text-gray-600 mb-3">
                        Options de paiement sécurisées disponibles
                      </p>
                    </div>
                    <div className="flex-shrink-0">
                      <img 
                        src="/ebilling.png" 
                        alt="Paiement mobile et numérique"
                        className="h-20 w-auto object-contain"
                      />
                    </div>
                  </div>
                </div>

                <button 
                  type="submit" 
                  disabled={isSubmitting} 
                  className="w-full px-8 py-4 bg-[#01579B] text-white rounded-lg font-bold text-lg hover:bg-blue-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                >
                  {isSubmitting ? (
                    <>
                      <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                      <span>Inscription en cours...</span>
                    </>
                  ) : (
                    <>
                      <UserPlusIcon className="w-5 h-5" />
                      <span>Confirmation et paiement</span>
                    </>
                  )}
                </button>
                
                <p className="text-center text-sm text-gray-600">
                  🔒 Paiement sécurisé via Ebilling - AirtelMoney, Moov Money acceptés
                </p>
              </form>
            </div>
          </div>

          
        </div>

        {/* CTA Final */}
        <div className="bg-gradient-to-br from-gray-50 to-blue-50 rounded-3xl p-8 md:p-12">
          <div className="max-w-4xl mx-auto">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-center">
              <div className="lg:col-span-2 text-center lg:text-left">
                <h2 className="text-3xl font-bold text-gray-900 mb-4 flex items-center justify-center lg:justify-start">
                  <HeartIcon className="w-8 h-8 text-red-500 mr-3" />
                  Une Expérience Inoubliable Vous Attend
                </h2>
                <p className="text-gray-700 text-lg mb-8">
                  Rejoignez des centaines de Rotariens pour trois jours d'apprentissage, 
                  de partage et de communion fraternelle dans un cadre exceptionnel
                </p>
                <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                  <a 
                    href="https://chat.whatsapp.com/KDs6kOA3qYhEsMHOY7ei0o?mode=wwt"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="px-8 py-4 bg-green-600 text-white rounded-lg font-bold text-lg hover:bg-green-700 transition-colors flex items-center justify-center"
                  >
                    <MessageCircleIcon className="w-5 h-5 mr-2" />
                    Inscription WhatsApp
                  </a>
                  <a 
                    href="/program" 
                    className="px-8 py-4 bg-white text-[#01579B] border-2 border-[#01579B] rounded-lg font-bold text-lg hover:bg-gray-50 transition-colors"
                  >
                    Voir le Programme
                  </a>
                  <a 
                    href="/PROMO-22EME-FORUM-DES-CLUBS-PORT-GENTIL-2026.pdf"
                    download="Programme-Forum-Rotary-2026.pdf"
                    className="px-8 py-4 bg-[#F9A825] text-blue-900 rounded-lg font-bold text-lg hover:bg-[#FBC02D] transition-colors flex items-center justify-center"
                  >
                    <DownloadIcon className="w-5 h-5 mr-2" />
                    Télécharger PDF
                  </a>
                </div>
              </div>
              
              {/* Code QR alternatif */}
              <div className="text-center">
                <div className="bg-white p-6 rounded-2xl shadow-lg">
                  <p className="text-gray-800 font-semibold mb-4">Accès direct aux inscriptions :</p>
                  <img 
                    src={`https://api.qrserver.com/v1/create-qr-code/?size=140x140&data=${encodeURIComponent('https://chat.whatsapp.com/KDs6kOA3qYhEsMHOY7ei0o?mode=wwt')}`}
                    alt="Code QR inscription Forum 2026"
                    className="w-35 h-35 mx-auto"
                  />
                  <p className="text-gray-600 text-sm mt-3">Rejoindre via QR</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
              </>
            );
        }
      })()}
    </div>
  );
}