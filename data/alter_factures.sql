-- Script de migration pour ajouter les colonnes manquantes à la table factures
-- Date: 2026-02-08

-- Ajouter la colonne raw_callback pour stocker le payload complet du webhook Ebilling
ALTER TABLE `factures` 
ADD COLUMN `raw_callback` TEXT NULL AFTER `statuspay`;

-- Note: Cette colonne stocke le JSON complet reçu du webhook Ebilling
-- Elle sert aussi de flag pour empêcher les modifications manuelles via /updateFactureStatus
