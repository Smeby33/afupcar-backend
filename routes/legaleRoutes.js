const express = require('express');
const router = express.Router();
const db = require('../db');

// Générer un ID unique pour legaleId : 2 lettres + 6 chiffres
function generateLegaleId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
        letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// ➕ Ajouter un document légal
router.post('/add', async (req, res) => {
    const { titre, documents } = req.body;
    const legaleId = generateLegaleId();
    console.log('📥 [POST /add] Données reçues :', req.body);
    if (!titre || !documents) {
        console.log('❌ [POST /add] Champs obligatoires manquants');
        return res.status(400).json({ error: 'titre et documents sont requis.' });
    }
    try {
        await db.query(
            'INSERT INTO legale (legaleId, titre, documents, create_at) VALUES (?, ?, ?, NOW())',
            [legaleId, titre, documents]
        );
        console.log('✅ [POST /add] Document légal ajouté :', { legaleId, titre });
        res.status(201).json({ message: 'Document légal ajouté.', legaleId });
    } catch (err) {
        console.error('❌ [POST /add] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de l'ajout du document légal." });
    }
});

// 🔍 Récupérer tous les documents légaux
router.get('/all', async (req, res) => {
    console.log('📥 [GET /all] Demande de tous les documents légaux');
    try {
        const [rows] = await db.query('SELECT * FROM legale');
        console.log('📤 [GET /all] Documents légaux récupérés :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /all] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des documents légaux.' });
    }
});

// 🔍 Récupérer un document légal par ID
router.get('/:legaleId', async (req, res) => {
    const { legaleId } = req.params;
    console.log('📥 [GET /:legaleId] legaleId reçu :', legaleId);
    try {
        const [rows] = await db.query('SELECT * FROM legale WHERE legaleId = ?', [legaleId]);
        if (rows.length > 0) {
            console.log('📤 [GET /:legaleId] Document légal récupéré :', rows[0]);
            res.json(rows[0]);
        } else {
            console.log('❌ [GET /:legaleId] Document légal non trouvé');
            res.status(404).json({ error: 'Document légal non trouvé.' });
        }
    } catch (err) {
        console.error('❌ [GET /:legaleId] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération du document légal.' });
    }
});

// 🔍 Récupérer un document légal par titre
router.get('/byTitre/:titre', async (req, res) => {
    const { titre } = req.params;
    console.log('📥 [GET /byTitre/:titre] titre reçu :', titre);
    try {
        const [rows] = await db.query('SELECT * FROM legale WHERE titre = ?', [titre]);
        if (rows.length > 0) {
            console.log('📤 [GET /byTitre/:titre] Document légal récupéré :', rows[0]);
            res.json(rows[0]);
        } else {
            console.log('❌ [GET /byTitre/:titre] Document légal non trouvé');
            res.status(404).json({ error: 'Document légal non trouvé pour ce titre.' });
        }
    } catch (err) {
        console.error('❌ [GET /byTitre/:titre] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération du document légal.' });
    }
});

// ✏️ Modifier un document légal
router.put('/update/:legaleId', async (req, res) => {
    const { legaleId } = req.params;
    const { titre, documents } = req.body;
    console.log('📥 [PUT /update/:legaleId] legaleId reçu :', legaleId, 'champs reçus :', req.body);
    if (!titre && !documents) {
        console.log('❌ [PUT /update/:legaleId] Aucun champ à mettre à jour');
        return res.status(400).json({ error: 'Aucun champ à mettre à jour.' });
    }
    const updates = [];
    const values = [];
    if (titre) { updates.push('titre = ?'); values.push(titre); }
    if (documents) { updates.push('documents = ?'); values.push(documents); }
    values.push(legaleId);
    try {
        const [result] = await db.query(
            `UPDATE legale SET ${updates.join(', ')} WHERE legaleId = ?`,
            values
        );
        if (result.affectedRows > 0) {
            console.log('✅ [PUT /update/:legaleId] Document légal mis à jour :', { legaleId, titre, documents });
            res.json({ message: 'Document légal mis à jour.' });
        } else {
            console.log('❌ [PUT /update/:legaleId] Document légal non trouvé');
            res.status(404).json({ error: 'Document légal non trouvé.' });
        }
    } catch (err) {
        console.error('❌ [PUT /update/:legaleId] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la mise à jour du document légal.' });
    }
});

// 🗑️ Supprimer un document légal
router.delete('/delete/:legaleId', async (req, res) => {
    const { legaleId } = req.params;
    console.log('📥 [DELETE /delete/:legaleId] legaleId reçu :', legaleId);
    try {
        const [result] = await db.query('DELETE FROM legale WHERE legaleId = ?', [legaleId]);
        if (result.affectedRows > 0) {
            console.log('✅ [DELETE /delete/:legaleId] Document légal supprimé :', legaleId);
            res.json({ message: 'Document légal supprimé.' });
        } else {
            console.log('❌ [DELETE /delete/:legaleId] Document légal non trouvé');
            res.status(404).json({ error: 'Document légal non trouvé.' });
        }
    } catch (err) {
        console.error('❌ [DELETE /delete/:legaleId] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la suppression du document légal.' });
    }
});

// Générer un ID unique pour readId : 2 lettres + 6 chiffres
function generateReadId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
        letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// ➕ Ajouter une lecture de document légal
router.post('/addRead', async (req, res) => {
    const { reader, documents, lu } = req.body;
    const readId = generateReadId();
    console.log('📥 [POST /addRead] Données reçues :', req.body);
    if (!reader || !documents || lu === undefined) {
        console.log('❌ [POST /addRead] Champs obligatoires manquants');
        return res.status(400).json({ error: 'reader, documents et lu sont requis.' });
    }
    try {
        await db.query(
            'INSERT INTO legaleRead (readId, reader, documents, lu, read_at) VALUES (?, ?, ?, ?, NOW())',
            [readId, reader, documents, lu]
        );
        console.log('✅ [POST /addRead] Lecture enregistrée :', { readId, reader, documents, lu });
        res.status(201).json({ message: 'Lecture enregistrée.', readId });
    } catch (err) {
        console.error('❌ [POST /addRead] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de l'enregistrement de la lecture." });
    }
});

// 🔍 Récupérer toutes les lectures
router.get('/allRead', async (req, res) => {
    console.log('📥 [GET /allRead] Demande de toutes les lectures');
    try {
        const [rows] = await db.query('SELECT * FROM legaleRead');
        console.log('📤 [GET /allRead] Lectures récupérées :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /allRead] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des lectures.' });
    }
});

// 🔍 Récupérer les lectures d'un utilisateur
router.get('/readByReader/:reader', async (req, res) => {
    const { reader } = req.params;
    console.log('📥 [GET /readByReader/:reader] reader reçu :', reader);
    try {
        const [rows] = await db.query('SELECT * FROM legaleRead WHERE reader = ?', [reader]);
        console.log('📤 [GET /readByReader/:reader] Lectures récupérées :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /readByReader/:reader] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des lectures.' });
    }
});

// 🔍 Récupérer les lectures d'un document
router.get('/readByDocument/:documents', async (req, res) => {
    const { documents } = req.params;
    console.log('📥 [GET /readByDocument/:documents] documents reçu :', documents);
    try {
        const [rows] = await db.query('SELECT * FROM legaleRead WHERE documents = ?', [documents]);
        console.log('📤 [GET /readByDocument/:documents] Lectures récupérées :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /readByDocument/:documents] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des lectures.' });
    }
});

module.exports = router;
