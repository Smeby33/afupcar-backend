const express = require('express');
const router = express.Router();
const db = require('../db');

// 🔧 Fonction pour générer un ID court et lisible
function generateNotificationId() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const prefix = letters[Math.floor(Math.random() * 26)] + letters[Math.floor(Math.random() * 26)];
  const numbers = Math.floor(100 + Math.random() * 900); // 3 chiffres
  return prefix + numbers;
}

// ➕ Créer une notification
router.post('/addNotification', async (req, res) => {
  const { userId, type, title, message, link, meta } = req.body;
  const id = generateNotificationId();

  if (!userId || !title || !message) {
    return res.status(400).json({ error: 'userId, title et message sont requis.' });
  }

  try {
    await db.query(
      `INSERT INTO notifications 
        (id, userId, type, title, message, link, reading, createdAt, meta) 
        VALUES (?, ?, ?, ?, ?, ?, 0, NOW(), ?)`,
      [id, userId, type || null, title, message, link || null, JSON.stringify(meta) || null]
    );

    res.status(201).json({
      id, userId, type, title, message,
      link: link || null,
      reading: false,
      createdAt: new Date(),
      meta: meta || null,
    });
  } catch (err) {
    console.error('[POST /notifications] Erreur:', err);
    res.status(500).json({ error: "Erreur lors de la création de la notification." });
  }
});

// 🔍 Récupérer les notifications d'un utilisateur
// Optionnel : ?unread=true
router.get('/getNotifications/:userId', async (req, res) => {
  const { userId } = req.params;
  const { unread } = req.query;

  try {
    const query = unread === 'true'
      ? 'SELECT * FROM notifications WHERE userId = ? AND reading = 0 ORDER BY createdAt DESC'
      : 'SELECT * FROM notifications WHERE userId = ? ORDER BY createdAt DESC';

    const [rows] = await db.query(query, [userId]);
    res.json(rows);
  } catch (err) {
    console.error('[GET /notifications/:userId] Erreur:', err);
    res.status(500).json({ error: "Erreur lors de la récupération des notifications." });
  }
});

// ✅ Marquer une notification comme lue
router.patch('/markAsRead/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [result] = await db.query(
      'UPDATE notifications SET reading = 1 WHERE id = ?',
      [id]
    );

    if (result.affectedRows > 0) {
      res.json({ message: 'Notification marquée comme lue.' });
    } else {
      res.status(404).json({ error: 'Notification non trouvée.' });
    }
  } catch (err) {
    console.error('[PATCH /notifications/:id/read] Erreur:', err);
    res.status(500).json({ error: "Erreur lors de la mise à jour de la notification." });
  }
});

// ✅ Marquer toutes les notifications comme lues
router.patch('/markAllRead/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [result] = await db.query(
      'UPDATE notifications SET reading = 1 WHERE userId = ?',
      [userId]
    );

    res.json({ message: 'Toutes les notifications ont été marquées comme lues.' });
  } catch (err) {
    console.error('[PATCH /notifications/markAllRead/:userId] Erreur:', err);
    res.status(500).json({ error: "Erreur lors de la mise à jour." });
  }
});

// 🗑️ Supprimer une notification
router.delete('/delete/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [result] = await db.query(
      'DELETE FROM notifications WHERE id = ?',
      [id]
    );

    if (result.affectedRows > 0) {
      res.json({ message: 'Notification supprimée.' });
    } else {
      res.status(404).json({ error: 'Notification non trouvée.' });
    }
  } catch (err) {
    console.error('[DELETE /notifications/:id] Erreur:', err);
    res.status(500).json({ error: "Erreur lors de la suppression de la notification." });
  }
});

module.exports = router;
