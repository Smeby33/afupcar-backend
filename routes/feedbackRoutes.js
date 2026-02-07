const express = require('express');
const router = express.Router();
const db = require('../db');

// Générer un ID unique pour feedbackId : 2 lettres + 6 chiffres
function generateFeedbackId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
        letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// ➕ Ajouter un feedback
router.post('/add', async (req, res) => {
    const { conducteur, proprietaire, texte, document, objet } = req.body;
    const feedbackId = generateFeedbackId();
    if (!texte) {
        return res.status(400).json({ error: 'texte est requis.' });
    }
    try {
        await db.query(
            'INSERT INTO feedback (feedbackId, objet, conducteur, proprietaire, texte, document, creatAt) VALUES (?, ?, ?, ?, ?, ?, NOW())',
            [feedbackId, objet || null, conducteur || null, proprietaire || null, texte, document || null]
        );
        res.status(201).json({ message: 'Feedback ajouté.', feedbackId });
    } catch (err) {
        res.status(500).json({ error: "Erreur lors de l'ajout du feedback." });
    }
});

// ➕ Ajouter un feedback pour un conducteur
router.post('/addConducteur', async (req, res) => {
    const { conducteur, texte, document, objet } = req.body;
    const feedbackId = generateFeedbackId();
    console.log(`[POST /addConducteur] Tentative d'ajout feedback:`, { feedbackId, conducteur, texte, document, objet });
    if (!conducteur || !texte) {
        console.warn(`[POST /addConducteur] Champs manquants:`, { conducteur, texte });
        return res.status(400).json({ error: 'conducteur et texte sont requis.' });
    }
    try {
        const [result] = await db.query(
            'INSERT INTO feedback (feedbackId, objet, conducteur, texte, document, creatAt) VALUES (?, ?, ?, ?, ?, NOW())',
            [feedbackId, objet || null, conducteur, texte, document || null]
        );
        console.log(`[POST /addConducteur] Feedback ajouté avec succès:`, { feedbackId, result });
        res.status(201).json({ message: 'Feedback conducteur ajouté.', feedbackId });
    } catch (err) {
        console.error(`[POST /addConducteur] Erreur lors de l'ajout:`, err);
        res.status(500).json({ error: "Erreur lors de l'ajout du feedback conducteur." });
    }
});

// ➕ Ajouter un feedback pour un propriétaire
router.post('/addProprietaire', async (req, res) => {
    const { proprietaire, texte, document, objet } = req.body;
    const feedbackId = generateFeedbackId();
    console.log(`[POST /addProprietaire] Tentative d'ajout feedback:`, { feedbackId, proprietaire, texte, document, objet });
    if (!proprietaire || !texte) {
        console.warn(`[POST /addProprietaire] Champs manquants:`, { proprietaire, texte });
        return res.status(400).json({ error: 'proprietaire et texte sont requis.' });
    }
    try {
        const [result] = await db.query(
            'INSERT INTO feedback (feedbackId, objet, proprietaire, texte, document, creatAt) VALUES (?, ?, ?, ?, ?, NOW())',
            [feedbackId, objet || null, proprietaire, texte, document || null]
        );
        console.log(`[POST /addProprietaire] Feedback ajouté avec succès:`, { feedbackId, result });
        res.status(201).json({ message: 'Feedback propriétaire ajouté.', feedbackId });
    } catch (err) {
        console.error(`[POST /addProprietaire] Erreur lors de l'ajout:`, err);
        res.status(500).json({ error: "Erreur lors de l'ajout du feedback propriétaire." });
    }
});

// 🔍 Récupérer tous les feedbacks
router.get('/all', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM feedback');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: 'Erreur lors de la récupération des feedbacks.' });
    }
});

// 🔍 Récupérer les feedbacks d'un conducteur
router.get('/byConducteur/:conducteur', async (req, res) => {
    const { conducteur } = req.params;
    try {
        const [rows] = await db.query('SELECT * FROM feedback WHERE conducteur = ?', [conducteur]);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: 'Erreur lors de la récupération des feedbacks.' });
    }
});

// 🔍 Récupérer les feedbacks d'un propriétaire
router.get('/byProprietaire/:proprietaire', async (req, res) => {
    const { proprietaire } = req.params;
    console.log(`[GET /byProprietaire/:proprietaire] Requête reçue pour proprietaire:`, proprietaire);
    try {
        const [rows] = await db.query('SELECT * FROM feedback WHERE proprietaire = ?', [proprietaire]);
        console.log(`[GET /byProprietaire/:proprietaire] Résultat:`, rows);
        res.json(rows);
    } catch (err) {
        console.error(`[GET /byProprietaire/:proprietaire] Erreur:`, err);
        res.status(500).json({ error: 'Erreur lors de la récupération des feedbacks.' });
    }
});

// 🔍 Récupérer les feedbacks d'un objet
router.get('/byObjet/:objet', async (req, res) => {
    const { objet } = req.params;
    try {
        const [rows] = await db.query('SELECT * FROM feedback WHERE objet = ?', [objet]);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: 'Erreur lors de la récupération des feedbacks.' });
    }
});

// ✏️ Modifier un feedback
router.put('/update/:feedbackId', async (req, res) => {
    const { feedbackId } = req.params;
    const { objet, texte, document } = req.body;
    if (!objet && !texte && !document) {
        return res.status(400).json({ error: 'Aucun champ à mettre à jour.' });
    }
    const updates = [];
    const values = [];
    if (objet) { updates.push('objet = ?'); values.push(objet); }
    if (texte) { updates.push('texte = ?'); values.push(texte); }
    if (document) { updates.push('document = ?'); values.push(document); }
    values.push(feedbackId);
    try {
        const [result] = await db.query(
            `UPDATE feedback SET ${updates.join(', ')} WHERE feedbackId = ?`,
            values
        );
        if (result.affectedRows > 0) {
            res.json({ message: 'Feedback mis à jour.' });
        } else {
            res.status(404).json({ error: 'Feedback non trouvé.' });
        }
    } catch (err) {
        res.status(500).json({ error: 'Erreur lors de la mise à jour du feedback.' });
    }
});

// 🗑️ Supprimer un feedback
router.delete('/delete/:feedbackId', async (req, res) => {
    const { feedbackId } = req.params;
    try {
        const [result] = await db.query('DELETE FROM feedback WHERE feedbackId = ?', [feedbackId]);
        if (result.affectedRows > 0) {
            res.json({ message: 'Feedback supprimé.' });
        } else {
            res.status(404).json({ error: 'Feedback non trouvé.' });
        }
    } catch (err) {
        res.status(500).json({ error: 'Erreur lors de la suppression du feedback.' });
    }
});

module.exports = router;
