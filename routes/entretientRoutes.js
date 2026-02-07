const express = require('express');
const router = express.Router();
const db = require('../db');

// Générer un ID unique pour un entretien : 2 lettres aléatoires + 6 chiffres
function generateEntretientId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
        letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// ➕ Ajouter un entretien
router.post('/addEntretient', async (req, res) => {
    const { voiture, typeEntretient, description, date } = req.body;
    const id = generateEntretientId();
    console.log('📥 [POST /addEntretient] Données reçues :', req.body);
    if (!voiture || !typeEntretient || !description || !date) {
        console.log('❌ [POST /addEntretient] Champs manquants');
        return res.status(400).json({ error: 'voiture, typeEntretient, description et date sont requis.' });
    }
    try {
        const sql = "INSERT INTO entretient (id, voiture, typeEntretient, description, date, timestamp) VALUES (?, ?, ?, ?, ?, NOW())";
        const [result] = await db.query(sql, [id, voiture, typeEntretient, description, date]);
        console.log('✅ [POST /addEntretient] Entretien ajouté :', { id, voiture, typeEntretient, description, date });
        res.status(201).json({ message: "Entretien ajouté avec succès", id });
    } catch (err) {
        console.error('❌ [POST /addEntretient] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de l'ajout de l'entretien." });
    }
});

// ✏️ Modifier un entretien
router.put('/entretient/update/:id', async (req, res) => {
    const { id } = req.params;
    const { voiture, typeEntretient, description, date } = req.body;
    console.log('📥 [PUT /entretient/:id] id reçu :', id, 'champs reçus :', req.body);
    if (!voiture && !typeEntretient && !description && !date) {
        return res.status(400).json({ error: 'Aucun champ fourni pour la mise à jour.' });
    }
    const updates = [];
    const values = [];
    if (voiture) { updates.push('voiture = ?'); values.push(voiture); }
    if (typeEntretient) { updates.push('typeEntretient = ?'); values.push(typeEntretient); }
    if (description) { updates.push('description = ?'); values.push(description); }
    if (date) { updates.push('date = ?'); values.push(date); }
    values.push(id);
    try {
        const sql = `UPDATE entretient SET ${updates.join(', ')} WHERE id = ?`;
        const [result] = await db.query(sql, values);
        console.log('✅ [PUT /entretient/:id] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Entretien non trouvé." });
        }
        res.json({ message: "Entretien modifié avec succès." });
    } catch (err) {
        console.error('❌ [PUT /entretient/:id] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la modification de l'entretien." });
    }
});

// 🔍 Récupérer tous les entretiens
router.get('/allEntretients', async (req, res) => {
    console.log('📥 [GET /allEntretients] Demande de récupération de tous les entretiens');
    try {
        const [rows] = await db.query('SELECT * FROM entretient');
        console.log('📤 [GET /allEntretients] Entretiens récupérés :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /allEntretients] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération des entretiens." });
    }
});

// 🔍 Récupérer tous les entretiens d'une voiture
router.get('/entretients/byCar/:voiture', async (req, res) => {
    const { voiture } = req.params;
    console.log('📥 [GET /entretients/byCar/:voiture] voiture reçue :', voiture);
    try {
        const [rows] = await db.query('SELECT * FROM entretient WHERE voiture = ?', [voiture]);
        console.log('📤 [GET /entretients/byCar/:voiture] Entretiens récupérés :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /entretients/byCar/:voiture] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération des entretiens." });
    }
});

// 🗑️ Supprimer un entretien
router.delete('/entretient/delette/:id', async (req, res) => {
    const { id } = req.params;
    console.log('📥 [DELETE /entretient/:id] id reçu :', id);
    try {
        const [result] = await db.query('DELETE FROM entretient WHERE id = ?', [id]);
        console.log('📤 [DELETE /entretient/:id] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Entretien non trouvé." });
        }
        res.json({ message: "Entretien supprimé avec succès." });
    } catch (err) {
        console.error('❌ [DELETE /entretient/:id] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la suppression de l'entretien." });
    }
});

// 🗑️ Supprimer tous les entretiens d'une voiture
router.delete('/entretients/byCar/:voiture', async (req, res) => {
    const { voiture } = req.params;
    console.log('📥 [DELETE /entretients/byCar/:voiture] voiture reçue :', voiture);
    try {
        const [result] = await db.query('DELETE FROM entretient WHERE voiture = ?', [voiture]);
        console.log('📤 [DELETE /entretients/byCar/:voiture] Résultat SQL :', result);
        res.json({ message: `Tous les entretiens de la voiture ${voiture} ont été supprimés.` });
    } catch (err) {
        console.error('❌ [DELETE /entretients/byCar/:voiture] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la suppression multiple." });
    }
});

module.exports = router;
