const express = require('express');
const router = express.Router();
const db = require('../db');

// Générer un ID unique pour un commentaire : 2 lettres + 6 chiffres
function generateCommentId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
        letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// ➕ Ajouter un commentaire
router.post('/addCommentaire', async (req, res) => {
    const { id_conversation, auteur, 'auteur-inter': auteurInter, message, document } = req.body;
    const id_commentaire = generateCommentId();
    console.log('📥 [POST /addCommentaire] Données reçues :', req.body);
    if (!id_conversation || !auteur || !auteurInter || !message) {
        console.log('❌ [POST /addCommentaire] Champs obligatoires manquants');
        return res.status(400).json({ error: 'id_conversation, auteur, auteur-inter et message sont requis.' });
    }
    try {
        const sql = `INSERT INTO commentaire (id_commentaire, id_conversation, auteur, ` +
            '`auteur-inter`' + `, message, document, timestamp) VALUES (?, ?, ?, ?, ?, ?, NOW())`;
        const [result] = await db.query(sql, [id_commentaire, id_conversation, auteur, auteurInter, message, document || '']);
        console.log('✅ [POST /addCommentaire] Commentaire ajouté :', { id_commentaire, id_conversation, auteur, auteurInter });
        res.status(201).json({ message: 'Commentaire ajouté avec succès.', id_commentaire });
    } catch (err) {
        console.error('❌ [POST /addCommentaire] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de l'ajout du commentaire." });
    }
});

// ➕ Ajouter un commentaire par un auteur-inter
router.post('/addCommentaireInter', async (req, res) => {
    const { id_conversation, auteur, 'auteur-inter': auteurInter, message, document } = req.body;
    const id_commentaire = generateCommentId();
    console.log('📥 [POST /addCommentaireInter] Données reçues :', req.body);
    if (!id_conversation || !auteurInter || !message) {
        console.log('❌ [POST /addCommentaireInter] Champs obligatoires manquants');
        return res.status(400).json({ error: 'id_conversation, auteur-inter et message sont requis.' });
    }
    try {
        const sql = `INSERT INTO commentaire (id_commentaire, id_conversation, auteur, ` +
            '`auteur-inter`' + `, message, document, timestamp) VALUES (?, ?, ?, ?, ?, ?, NOW())`;
        const [result] = await db.query(sql, [id_commentaire, id_conversation, auteur, auteurInter, message, document || '']);
        console.log('✅ [POST /addCommentaireInter] Commentaire ajouté :', { id_commentaire, id_conversation, auteur, auteurInter });
        res.status(201).json({ message: 'Commentaire ajouté avec succès.', id_commentaire });
    } catch (err) {
        console.error('❌ [POST /addCommentaireInter] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de l'ajout du commentaire." });
    }
});

// 🔍 Récupérer un commentaire par id
router.get('/getCommentaire/:id_commentaire', async (req, res) => {
    const { id_commentaire } = req.params;
    console.log('📥 [GET /getCommentaire/:id_commentaire] id_commentaire reçu :', id_commentaire);
    try {
        const [rows] = await db.query('SELECT * FROM commentaire WHERE id_commentaire = ?', [id_commentaire]);
        if (rows.length === 0) {
            console.log('❌ [GET /getCommentaire/:id_commentaire] Commentaire non trouvé');
            return res.status(404).json({ error: 'Commentaire non trouvé.' });
        }
        console.log('📤 [GET /getCommentaire/:id_commentaire] Commentaire récupéré :', rows[0]);
        res.json(rows[0]);
    } catch (err) {
        console.error('❌ [GET /getCommentaire/:id_commentaire] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération du commentaire." });
    }
});

// 🔍 Récupérer tous les commentaires d'une conversation
router.get('/allCommentaires/:id_conversation', async (req, res) => {
    const { id_conversation } = req.params;
    console.log('📥 [GET /allCommentaires/:id_conversation] id_conversation reçu :', id_conversation);
    try {
        const [rows] = await db.query('SELECT * FROM commentaire WHERE id_conversation = ? ORDER BY timestamp ASC', [id_conversation]);
        console.log('📤 [GET /allCommentaires/:id_conversation] Commentaires récupérés :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /allCommentaires/:id_conversation] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération des commentaires." });
    }
});


// ✏️ Modifier un commentaire
router.put('/updateCommentaire/:id_commentaire', async (req, res) => {
    const { id_commentaire } = req.params;
    const { message, document } = req.body;
    console.log('📥 [PUT /updateCommentaire/:id_commentaire] id_commentaire reçu :', id_commentaire, 'champs reçus :', req.body);
    if (!message && !document) {
        return res.status(400).json({ error: 'Aucun champ fourni pour la mise à jour.' });
    }
    const updates = [];
    const values = [];
    if (message) { updates.push('message = ?'); values.push(message); }
    if (document) { updates.push('document = ?'); values.push(document); }
    values.push(id_commentaire);
    try {
        const sql = `UPDATE commentaire SET ${updates.join(', ')} WHERE id_commentaire = ?`;
        const [result] = await db.query(sql, values);
        console.log('✅ [PUT /updateCommentaire/:id_commentaire] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Commentaire non trouvé.' });
        }
        res.json({ message: 'Commentaire modifié avec succès.' });
    } catch (err) {
        console.error('❌ [PUT /updateCommentaire/:id_commentaire] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la modification du commentaire." });
    }
});

// 🗑️ Supprimer un commentaire
router.delete('/deleteCommentaire/:id_commentaire', async (req, res) => {
    const { id_commentaire } = req.params;
    console.log('📥 [DELETE /deleteCommentaire/:id_commentaire] id_commentaire reçu :', id_commentaire);
    try {
        const [result] = await db.query('DELETE FROM commentaire WHERE id_commentaire = ?', [id_commentaire]);
        console.log('📤 [DELETE /deleteCommentaire/:id_commentaire] Résultat SQL :', result);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Commentaire non trouvé.' });
        }
        res.json({ message: 'Commentaire supprimé avec succès.' });
    } catch (err) {
        console.error('❌ [DELETE /deleteCommentaire/:id_commentaire] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la suppression du commentaire." });
    }
});

// 🔍 Récupérer toutes les conversations d'un auteur par son id
router.get('/conversations/byAuteur/:auteur', async (req, res) => {
    const { auteur } = req.params;
    console.log('📥 [GET /conversations/byAuteur/:auteur] auteur reçu :', auteur);
    try {
        const [rows] = await db.query('SELECT DISTINCT id_conversation FROM commentaire WHERE auteur = ? ORDER BY timestamp DESC', [auteur]);
        console.log('📤 [GET /conversations/byAuteur/:auteur] Conversations récupérées :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /conversations/byAuteur/:auteur] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération des conversations." });
    }
});

// 🔍 Récupérer toutes les conversations d'un auteur-inter par son id
router.get('/conversations/byAuteurInter/:auteurInter', async (req, res) => {
    const { auteurInter } = req.params;
    console.log('📥 [GET /conversations/byAuteurInter/:auteurInter] auteurInter reçu :', auteurInter);
    try {
        const [rows] = await db.query('SELECT DISTINCT id_conversation FROM commentaire WHERE `auteur-inter` = ? ORDER BY timestamp DESC', [auteurInter]);
        console.log('📤 [GET /conversations/byAuteurInter/:auteurInter] Conversations récupérées :', rows);
        res.json(rows);
    } catch (err) {
        console.error('❌ [GET /conversations/byAuteurInter/:auteurInter] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération des conversations." });
    }
});

// 🔍 Récupérer le dernier message d'une conversation
router.get('/lastMessage/:id_conversation', async (req, res) => {
    const { id_conversation } = req.params;
    console.log('📥 [GET /lastMessage/:id_conversation] id_conversation reçu :', id_conversation);
    try {
        const [rows] = await db.query('SELECT * FROM commentaire WHERE id_conversation = ? ORDER BY timestamp DESC LIMIT 1', [id_conversation]);
        if (rows.length === 0) {
            console.log('❌ [GET /lastMessage/:id_conversation] Aucun message trouvé');
            return res.status(404).json({ error: 'Aucun message trouvé.' });
        }
        console.log('📤 [GET /lastMessage/:id_conversation] Dernier message :', rows[0]);
        res.json(rows[0]);
    } catch (err) {
        console.error('❌ [GET /lastMessage/:id_conversation] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération du dernier message." });
    }
});

module.exports = router;
