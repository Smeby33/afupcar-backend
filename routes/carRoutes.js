const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();
const db = require('../db');

// 🔠 Générer un ID unique pour une voiture : 2 lettres + 6 chiffres
function generateCarId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
                          letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// 🚗 Ajouter une voiture
router.post('/addCar', async (req, res) => {
    const {
        marque, modele, type, description, ville,
        sunroof, androidauto, clime, bluetooth,
        photofront, photoback, photoleft, photorigth, photoenter,
            prix, avance, proprio, fuel, comission, boiteVitesse, prixhorszone
    } = req.body;

    console.log('📥 [POST /addCar] Données reçues :', req.body);

    // Champs obligatoires (booleans/numbers: vérifier undefined, strings: vérifier vide)
    const missingFields = [];
    if (!marque) missingFields.push('marque');
    if (!modele) missingFields.push('modele');
    if (!type) missingFields.push('type');
    if (!ville) missingFields.push('ville');
    if (!photofront) missingFields.push('photofront');
    if (!photoback) missingFields.push('photoback');
    if (!photoleft) missingFields.push('photoleft');
    if (!photorigth) missingFields.push('photorigth');
    if (!photoenter) missingFields.push('photoenter');
    if (prix === undefined || prix === null) missingFields.push('prix');
    if (!proprio) missingFields.push('proprio');
    if (!fuel) missingFields.push('fuel');
    if (comission === undefined || comission === null) missingFields.push('comission');
    if (!boiteVitesse) missingFields.push('boiteVitesse');

    if (missingFields.length > 0) {
        console.log('❌ [POST /addCar] Champs obligatoires manquants :', missingFields);
        return res.status(400).json({ error: `Certains champs obligatoires sont manquants: ${missingFields.join(', ')}` });
    }

    const id = generateCarId();
    console.log('🆔 [POST /addCar] id généré :', id);

    try {
        const sql = `
            INSERT INTO car (id, marque, modele, type, description, ville, sunroof, androidauto, clime, bluetooth, 
                    photofront, photoback, photoleft, photorigth, photoenter, prix, avance, proprio, fuel, comission, boiteVitesse, prixhorszone)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;
            const values = [id, marque, modele, type, description, ville, sunroof, androidauto, clime, bluetooth,
                photofront, photoback, photoleft, photorigth, photoenter, prix, avance, proprio, fuel, comission, boiteVitesse, prixhorszone];
        console.log('🟢 [POST /addCar] Requête SQL :', sql.trim());
        console.log('🟢 [POST /addCar] Valeurs SQL :', values);

        const [result] = await db.query(sql, values);
        console.log('✅ [POST /addCar] Résultat insertion :', result);
        res.status(201).json({ message: "Voiture ajoutée avec succès", id });
    } catch (err) {
        console.error("❌ [POST /addCar] Erreur SQL :", err);
        res.status(500).json({ error: "Erreur serveur lors de l'ajout de la voiture." });
    }
});

// 🔍 Récupérer une voiture par ID
router.get('/car/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [rows] = await db.query('SELECT * FROM car WHERE id = ?', [id]);
        if (rows.length === 0) return res.status(404).json({ error: "Voiture introuvable." });
        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: "Erreur lors de la récupération." });
    }
});

// 🔍 Récupérer toutes les voitures d’un propriétaire
router.get('/cars/byOwner/:proprio', async (req, res) => {
    const { proprio } = req.params;
    console.log("📥 [GET /cars/byOwner/:proprio] proprio reçu :", proprio);
    try {
        const [rows] = await db.query('SELECT * FROM car WHERE proprio = ?', [proprio]);
        console.log("📦 [GET /cars/byOwner/:proprio] voitures récupérées :", rows);
        res.json(rows);
    } catch (err) {
        console.error("❌ [GET /cars/byOwner/:proprio] Erreur SQL :", err);
        res.status(500).json({ error: "Erreur lors de la récupération des voitures." });
    }
});

// 🔍 Récupérer toutes les voitures
router.get('/allCars', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM car');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: "Erreur lors de la récupération des voitures." });
    }
});

// ✏️ Modifier une voiture (tous les champs explicites, y compris photoenter et photorigth)
router.put('/car/:id', async (req, res) => {
    const { id } = req.params;
    const {
        marque, modele, type, description, ville,
        sunroof, androidauto, clime, bluetooth,
        photofront, photoback, photoleft, photorigth, photoenter,
            prix, avance, proprio, fuel, comission, boiteVitesse, prixhorszone
    } = req.body;

    console.log("🟢 [PUT /car/:id] id reçu :", id);
    console.log("🟢 [PUT /car/:id] champs reçus :", req.body);

    if (Object.keys(req.body).length === 0) {
        console.log("⚠️ Aucun champ fourni pour la mise à jour.");
        return res.status(400).json({ error: "Aucun champ fourni pour la mise à jour." });
    }

    const sql = `
        UPDATE car SET
            marque = ?, modele = ?, type = ?, description = ?, ville = ?,
            sunroof = ?, androidauto = ?, clime = ?, bluetooth = ?,
            photofront = ?, photoback = ?, photoleft = ?, photorigth = ?, photoenter = ?,
            prix = ?, avance = ?, proprio = ?, fuel = ?, comission = ?, boiteVitesse = ?, prixhorszone = ?
        WHERE id = ?
    `;
    const values = [
        marque, modele, type, description, ville,
        sunroof, androidauto, clime, bluetooth,
        photofront, photoback, photoleft, photorigth, photoenter,
        prix, avance, proprio, fuel, comission, boiteVitesse, prixhorszone, id
    ];

    console.log("🟢 [PUT /car/:id] requête SQL :", sql);
    console.log("🟢 [PUT /car/:id] valeurs SQL :", values);

    try {
        const [result] = await db.query(sql, values);
        if (result.affectedRows === 0) {
            console.log("❌ Voiture non trouvée pour l'id :", id);
            return res.status(404).json({ error: "Voiture non trouvée." });
        }
        res.json({ message: "Voiture mise à jour avec succès." });
    } catch (err) {
        console.error("❌ Erreur SQL :", err);
        res.status(500).json({ error: "Erreur serveur." });
    }
});

// 🗑️ Supprimer une voiture
router.delete('/car/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM car WHERE id = ?', [id]);
        if (result.affectedRows === 0) return res.status(404).json({ error: "Voiture non trouvée." });
        res.json({ message: "Voiture supprimée avec succès." });
    } catch (err) {
        res.status(500).json({ error: "Erreur lors de la suppression." });
    }
});

// 🗑️ Supprimer toutes les voitures d’un propriétaire
router.delete('/cars/byOwner/:proprio', async (req, res) => {
    const { proprio } = req.params;
    try {
        const [result] = await db.query('DELETE FROM car WHERE proprio = ?', [proprio]);
        res.json({ message: `Toutes les voitures du propriétaire ${proprio} ont été supprimées.` });
    } catch (err) {
        res.status(500).json({ error: "Erreur lors de la suppression multiple." });
    }
});

// Générer un ID unique pour un modèle : 2 lettres + 6 chiffres
function generateModelId() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters.charAt(Math.floor(Math.random() * letters.length)) +
                          letters.charAt(Math.floor(Math.random() * letters.length));
    const randomDigits = Math.floor(100000 + Math.random() * 900000);
    return randomLetters + randomDigits;
}

// 🚗 Ajouter un modèle
router.post('/addModel', async (req, res) => {
    const { marqueId, modele } = req.body;
    if (!marqueId || !modele) {
        return res.status(400).json({ error: 'Champs obligatoires manquants (marqueId, modele).' });
    }
    const id = generateModelId();
    try {
        const sql = 'INSERT INTO carmodel (id, marqueId, modele, timestamp) VALUES (?, ?, ?, NOW())';
        const [result] = await db.query(sql, [id, marqueId, modele]);
        res.status(201).json({ message: 'Modèle ajouté avec succès', id });
    } catch (err) {
        console.error('[POST /addModel] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur serveur lors de l\'ajout du modèle.' });
    }
});

// ✏️ Modifier un modèle
router.put('/model/:id', async (req, res) => {
    const { id } = req.params;
    const { marqueId, modele } = req.body;
    if (!marqueId && !modele) {
        return res.status(400).json({ error: 'Aucun champ fourni pour la mise à jour.' });
    }
    const updates = [];
    const values = [];
    if (marqueId) { updates.push('marqueId = ?'); values.push(marqueId); }
    if (modele) { updates.push('modele = ?'); values.push(modele); }
    values.push(id);
    try {
        const sql = `UPDATE carmodel SET ${updates.join(', ')} WHERE id = ?`;
        const [result] = await db.query(sql, values);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Modèle non trouvé.' });
        }
        res.json({ message: 'Modèle mis à jour avec succès.' });
    } catch (err) {
        console.error('[PUT /model/:id] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur serveur lors de la mise à jour du modèle.' });
    }
});

// 🔍 Récupérer tous les modèles
router.get('/allModels', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM carmodel');
        res.json(rows);
    } catch (err) {
        console.error('[GET /allModels] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des modèles.' });
    }
});

// 🔍 Récupérer tous les modèles d'une marque
router.get('/models/byMarque/:marqueId', async (req, res) => {
    const { marqueId } = req.params;
    try {
        const [rows] = await db.query('SELECT * FROM carmodel WHERE marqueId = ?', [marqueId]);
        res.json(rows);
    } catch (err) {
        console.error('[GET /models/byMarque/:marqueId] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la récupération des modèles.' });
    }
});

// 🗑️ Supprimer un modèle
router.delete('/model/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM carmodel WHERE id = ?', [id]);
        if (result.affectedRows === 0) return res.status(404).json({ error: 'Modèle non trouvé.' });
        res.json({ message: 'Modèle supprimé avec succès.' });
    } catch (err) {
        console.error('[DELETE /model/:id] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la suppression du modèle.' });
    }
});

// 🗑️ Supprimer tous les modèles d'une marque
router.delete('/models/byMarque/:marqueId', async (req, res) => {
    const { marqueId } = req.params;
    try {
        const [result] = await db.query('DELETE FROM carmodel WHERE marqueId = ?', [marqueId]);
        res.json({ message: `Tous les modèles de la marque ${marqueId} ont été supprimés.` });
    } catch (err) {
        console.error('[DELETE /models/byMarque/:marqueId] Erreur SQL :', err);
        res.status(500).json({ error: 'Erreur lors de la suppression multiple.' });
    }
});

// ➕ Ajouter une marque
router.post('/addMarque', async (req, res) => {
  const { nom } = req.body;
  console.log('📥 [POST /addMarque] Donnée reçue :', nom);
  if (!nom) return res.status(400).json({ error: 'Le nom de la marque est requis.' });
  try {
    await db.query('INSERT INTO marque (nom) VALUES (?)', [nom]);
    console.log('✅ [POST /addMarque] Marque ajoutée :', nom);
    res.status(201).json({ message: 'Marque ajoutée avec succès.' });
  } catch (err) {
    console.error('❌ [POST /addMarque] Erreur SQL :', err);
    res.status(500).json({ error: "Erreur lors de l'ajout de la marque." });
  }
});

// ✏️ Modifier une marque
router.put('/updateMarque/:nom', async (req, res) => {
  const { nom } = req.params;
  const { newNom } = req.body;
  console.log('📥 [PUT /updateMarque/:nom] Ancien nom :', nom, 'Nouveau nom :', newNom);
  if (!newNom) return res.status(400).json({ error: 'Le nouveau nom est requis.' });
  try {
    const [result] = await db.query('UPDATE marque SET nom = ? WHERE nom = ?', [newNom, nom]);
    console.log('✅ [PUT /updateMarque/:nom] Résultat SQL :', result);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Marque non trouvée." });
    }
    res.json({ message: 'Marque modifiée avec succès.' });
  } catch (err) {
    console.error('❌ [PUT /updateMarque/:nom] Erreur SQL :', err);
    res.status(500).json({ error: "Erreur lors de la modification de la marque." });
  }
});

// 🔍 Récupérer toutes les marques
router.get('/allMarques', async (req, res) => {
  console.log('📥 [GET /allMarques] Demande de récupération de toutes les marques');
  try {
    const [rows] = await db.query('SELECT * FROM marque');
    console.log('📤 [GET /allMarques] Marques récupérées :', rows);
    res.json(rows);
  } catch (err) {
    console.error('❌ [GET /allMarques] Erreur SQL :', err);
    res.status(500).json({ error: "Erreur lors de la récupération des marques." });
  }
});

// 🗑️ Supprimer une marque
router.delete('/deleteMarque/:nom', async (req, res) => {
  const { nom } = req.params;
  console.log('📥 [DELETE /deleteMarque/:nom] Nom reçu :', nom);
  try {
    const [result] = await db.query('DELETE FROM marque WHERE nom = ?', [nom]);
    console.log('📤 [DELETE /deleteMarque/:nom] Résultat SQL :', result);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Marque non trouvée." });
    }
    res.json({ message: 'Marque supprimée avec succès.' });
  } catch (err) {
    console.error('❌ [DELETE /deleteMarque/:nom] Erreur SQL :', err);
    res.status(500).json({ error: "Erreur lors de la suppression de la marque." });
  }
});

// 🔍 Récupérer toutes les villes distinctes des voitures
router.get('/allVilles', async (req, res) => {
    console.log('📥 [GET /allVilles] Demande de récupération de toutes les villes distinctes');
    try {
        const [rows] = await db.query('SELECT DISTINCT ville FROM car');
        const villes = rows.map(row => row.ville);
        console.log('📤 [GET /allVilles] Villes récupérées :', villes);
        res.json(villes);
    } catch (err) {
        console.error('❌ [GET /allVilles] Erreur SQL :', err);
        res.status(500).json({ error: "Erreur lors de la récupération des villes." });
    }
});

module.exports = router;
