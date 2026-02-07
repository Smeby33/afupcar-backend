const express = require('express');
const router = express.Router();
const db = require('../db');

// ➕ Créer une livraison
router.post('/addLivraison', async (req, res) => {
    const { id_reservation, conducteur, voiture, livré, recuperé, verification, etat, etatVoiture, document } = req.body;
    console.log('📥 [POST /addLivraison] Données reçues :', req.body);
    if (!id_reservation || !conducteur || !voiture) {
        console.log('❌ [POST /addLivraison] Champs obligatoires manquants');
        return res.status(400).json({ error: 'id_reservation, conducteur et voiture sont requis.' });
    }
    try {
        const sql = `INSERT INTO livraison (id_reservation, conducteur, voiture, livré, recuperé, verification, etat, etatVoiture, document, timestamp)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())`;
        const [result] = await db.query(sql, [id_reservation, conducteur, voiture, livré || 0, recuperé || 0, verification || 0, etat || 'rien à signaler', etatVoiture || '', document || '']);
        console.log('✅ [POST /addLivraison] Livraison ajoutée :', { id_reservation, conducteur, voiture });
        res.status(201).json({ message: 'Livraison ajoutée avec succès.' });
    } catch (err) {
        console.error('❌ [POST /addLivraison] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de l'ajout de la livraison." });
    }
});

// 🔍 Récupérer une livraison par id_reservation
router.get('/getLivraison/:id_reservation', async (req, res) => {
    const { id_reservation } = req.params;
    console.log('📥 [GET /getLivraison/:id_reservation] id_reservation reçu :', id_reservation);
    try {
        const [rows] = await db.query('SELECT * FROM livraison WHERE id_reservation = ?', [id_reservation]);
        if (rows.length === 0) {
            console.log('❌ [GET /getLivraison/:id_reservation] Livraison non trouvée');
            return res.status(404).json({ error: 'Livraison non trouvée.' });
        }
        console.log('📤 [GET /getLivraison/:id_reservation] Livraison récupérée :', rows[0]);
        res.json(rows[0]);
    } catch (err) {
        console.error('❌ [GET /getLivraison/:id_reservation] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération de la livraison." });
    }
});

// ✏️ Modifier une livraison (tous champs sauf id_reservation)
router.put('/updateLivraison/:id_reservation', async (req, res) => {
    const { id_reservation } = req.params;
    const { conducteur, voiture, livré, recuperé, verification, etat, etatVoiture, document } = req.body;
    console.log('📥 [PUT /updateLivraison/:id_reservation] id_reservation reçu :', id_reservation, 'champs reçus :', req.body);
    if (!conducteur && !voiture && livré === undefined && recuperé === undefined && verification === undefined && !etat && !etatVoiture && !document) {
        return res.status(400).json({ error: 'Aucun champ fourni pour la mise à jour.' });
    }
    const updates = [];
    const values = [];
    if (conducteur) { updates.push('conducteur = ?'); values.push(conducteur); }
    if (voiture) { updates.push('voiture = ?'); values.push(voiture); }
    if (livré !== undefined) { updates.push('livré = ?'); values.push(livré); }
    if (recuperé !== undefined) { updates.push('recuperé = ?'); values.push(recuperé); }
    if (verification !== undefined) { updates.push('verification = ?'); values.push(verification); }
    if (etat) { updates.push('etat = ?'); values.push(etat); }
    if (etatVoiture) { updates.push('etatVoiture = ?'); values.push(etatVoiture); }
    if (document) { updates.push('document = ?'); values.push(document); }
    values.push(id_reservation);
    try {
        const sql = `UPDATE livraison SET ${updates.join(', ')} WHERE id_reservation = ?`;
        const [result] = await db.query(sql, values);
        console.log('✅ [PUT /updateLivraison/:id_reservation] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Livraison non trouvée.' });
        }
        res.json({ message: 'Livraison modifiée avec succès.' });
    } catch (err) {
        console.error('❌ [PUT /updateLivraison/:id_reservation] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la modification de la livraison." });
    }
});

// ✏️ Modifier uniquement l'état d'une livraison
router.put('/updateEtatLivraison/:id_reservation', async (req, res) => {
    const { id_reservation } = req.params;
    const { etat, etatVoiture, document } = req.body;
    console.log('📥 [PUT /updateEtatLivraison/:id_reservation] id_reservation reçu :', id_reservation, 'nouvel état :', etat, 'nouvel étatVoiture :', etatVoiture, 'nouveau document :', document);
    if (!etat && !etatVoiture && !document) {
        return res.status(400).json({ error: 'Le champ etat, etatVoiture ou document est requis.' });
    }
    const updates = [];
    const values = [];
    if (etat) { updates.push('etat = ?'); values.push(etat); }
    if (etatVoiture) { updates.push('etatVoiture = ?'); values.push(etatVoiture); }
    if (document) { updates.push('document = ?'); values.push(document); }
    values.push(id_reservation);
    try {
        const sql = `UPDATE livraison SET ${updates.join(', ')} WHERE id_reservation = ?`;
        const [result] = await db.query(sql, values);
        console.log('✅ [PUT /updateEtatLivraison/:id_reservation] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Livraison non trouvée.' });
        }
        res.json({ message: 'État de la livraison modifié avec succès.' });
    } catch (err) {
        console.error('❌ [PUT /updateEtatLivraison/:id_reservation] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la modification de l'état de la livraison." });
    }
});

// 🗑️ Supprimer une livraison
router.delete('/deleteLivraison/:id_reservation', async (req, res) => {
    const { id_reservation } = req.params;
    console.log('📥 [DELETE /deleteLivraison/:id_reservation] id_reservation reçu :', id_reservation);
    try {
        const [result] = await db.query('DELETE FROM livraison WHERE id_reservation = ?', [id_reservation]);
        console.log('📤 [DELETE /deleteLivraison/:id_reservation] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Livraison non trouvée.' });
        }
        res.json({ message: 'Livraison supprimée avec succès.' });
    } catch (err) {
        console.error('❌ [DELETE /deleteLivraison/:id_reservation] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la suppression de la livraison." });
    }
});

module.exports = router;
