const express = require('express');
const db = require('../db');

const router = express.Router();

// ➕ Ajouter un admin (l'id vient du front, lastvisite géré par MySQL)
router.post('/addAdmin', async (req, res) => {
  const { id, fullname, phone, photo, password } = req.body;
  console.log("📥 [POST /admin] Données reçues :", req.body);

  // Vérification du mot de passe
  if (password !== "Armada2023@") {
    console.log("❌ [POST /admin] Mot de passe incorrect !");
    return res.status(401).json({ message: "Mot de passe incorrect." });
  }

  if (!id || !fullname || !phone || !photo) {
    console.log("❌ [POST /admin] Champs requis manquants :", req.body);
    return res.status(400).json({ message: 'Champs requis manquants.' });
  }

  try {
    await db.query(
      'INSERT INTO admin (id, fullname, phone, photo) VALUES (?, ?, ?, ?)',
      [id, fullname, phone, photo]
    );
    console.log("✅ [POST /admin] Ajouté avec succès, id :", id);
    res.status(201).json({ message: 'Admin ajouté avec succès', id });
  } catch (err) {
    console.error("❌ [POST /admin] Erreur SQL :", err);
    res.status(500).json({ message: 'Erreur serveur', error: err });
  }
});

// 🔍 Récupérer tous les admins
router.get('/getAdmin', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM admin');
    res.json(rows);
  } catch (err) {
    console.error("❌ [GET /admin] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la récupération des admins." });
  }
});

// 🔍 Récupérer un admin par ID
router.get('/getOneAdmin/:id', async (req, res) => {
    const { id } = req.params;
    console.log('📥 [GET /getOneAdmin/:id] Requête reçue pour id :', id);
    try {
        const [rows] = await db.query('SELECT * FROM admin WHERE id = ?', [id]);
        console.log('📤 [GET /getOneAdmin/:id] Résultat SQL :', rows);
        if (rows.length === 0) {
            console.log('❌ [GET /getOneAdmin/:id] Admin non trouvé pour id :', id);
            return res.status(404).json({ error: 'Admin non trouvé.' });
        }
        res.json(rows[0]);
    } catch (err) {
        console.error('❌ [GET /getOneAdmin/:id] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération de l'admin." });
    }
});

// ✏️ Modifier un admin
router.put('/putAdmin/:id', async (req, res) => {
  const { id } = req.params;
  const fields = req.body;

  if (Object.keys(fields).length === 0) {
    return res.status(400).json({ error: "Aucun champ fourni pour la mise à jour." });
  }

  const updates = Object.keys(fields).map(key => `${key} = ?`).join(', ');
  const values = [...Object.values(fields), id];

  try {
    const sql = `UPDATE admin SET ${updates} WHERE id = ?`;
    const [result] = await db.query(sql, values);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Admin non trouvé." });
    }
    res.json({ message: "Admin mis à jour avec succès." });
  } catch (err) {
    console.error("❌ [PUT /admin/:id] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la mise à jour." });
  }
});

// 🗑️ Supprimer un admin
router.delete('/deletteAdmin/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await db.query('DELETE FROM admin WHERE id = ?', [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Admin non trouvé." });
    }
    res.json({ message: "Admin supprimé avec succès." });
  } catch (err) {
    console.error("❌ [DELETE /admin/:id] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la suppression." });
  }
});

// 🔍 Récupérer tous les propriétaires (owners)
router.get('/getAllOwners', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM owner');
    res.json(rows);
  } catch (err) {
    console.error("❌ [GET /getAllOwners] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la récupération des propriétaires." });
  }
});

// 🔍 Récupérer tous les conducteurs (renters)
router.get('/getAllRenters', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM renter');
    res.json(rows);
  } catch (err) {
    console.error("❌ [GET /getAllRenters] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la récupération des conducteurs." });
  }
});

// 🔍 Récupérer toutes les réservations
router.get('/getAllReservations', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM reservation');
    res.json(rows);
  } catch (err) {
    console.error("❌ [GET /getAllReservations] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la récupération des réservations." });
  }
});

// 🔍 Récupérer toutes les voitures
router.get('/getAllCars', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM car');
    res.json(rows);
  } catch (err) {
    console.error("❌ [GET /getAllCars] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la récupération des voitures." });
  }
});

// 🔢 Récupérer le nombre total d'owners, renters, reservations et voitures
router.get('/getCounts', async (req, res) => {
  try {
    const [[{ owners }]] = await db.query('SELECT COUNT(*) AS owners FROM owner');
    const [[{ renters }]] = await db.query('SELECT COUNT(*) AS renters FROM renter');
    const [[{ reservations }]] = await db.query('SELECT COUNT(*) AS reservations FROM reservation');
    const [[{ cars }]] = await db.query('SELECT COUNT(*) AS cars FROM car');

    res.json({ owners, renters, reservations, cars });
  } catch (err) {
    console.error("❌ [GET /getCounts] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors du comptage." });
  }
});

// 🔄 Mettre à jour les visites d'un admin
router.put('/updateVisite/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await db.query(
      'UPDATE admin SET lastvisite = currentvisite, currentvisite = CURRENT_TIMESTAMP WHERE id = ?',
      [id]
    );
    res.json({ message: "Visites mises à jour." });
  } catch (err) {
    console.error("❌ [PUT /updateVisite/:id] Erreur SQL :", err);
    res.status(500).json({ error: "Erreur lors de la mise à jour des visites." });
  }
});

// 🔍 Récupérer tous les admins (ajout de logs détaillés)
router.get('/allAdmins', async (req, res) => {
  console.log('📥 [GET /allAdmins] Requête reçue');
  try {
    const [rows] = await db.query('SELECT * FROM admin');
    console.log('📤 [GET /allAdmins] Admins récupérés :', rows);
    res.json(rows);
  } catch (err) {
    console.error('❌ [GET /allAdmins] Erreur SQL :', err);
    res.status(500).json({ error: "Erreur lors de la récupération des admins." });
  }
});

module.exports = router;