-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 18 mai 2025 à 14:20
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `armada`
--

-- --------------------------------------------------------

--
-- Structure de la table `car`


CREATE TABLE `car` (
  `id` varchar(10) NOT NULL,
  `marque` varchar(10) NOT NULL,
  `modele` varchar(10) NOT NULL,
  `type` varchar(10) NOT NULL,
  `description` text DEFAULT NULL,
  `ville` varchar(15) NOT NULL,
  `sunroof` tinyint(1) NOT NULL DEFAULT 0,
  `androidauto` tinyint(1) NOT NULL DEFAULT 0,
  `clime` tinyint(1) NOT NULL DEFAULT 0,
  `bluetooth` tinyint(1) NOT NULL DEFAULT 0,
  `photofront` varchar(200) DEFAULT NULL,
  `photoback` varchar(200) DEFAULT NULL,
  `photoleft` varchar(200) DEFAULT NULL,
  `photorigth` varchar(200) DEFAULT NULL,
  `photoenter` varchar(200) DEFAULT NULL,
  `prix` int(10) NOT NULL,
  `avance` tinyint(1) NOT NULL DEFAULT 0,
  `proprio` varchar(100) NOT NULL,
  `statut` tinyint(4) DEFAULT 0,
  `fuel` varchar(200) DEFAULT NULL,
  `comission` tinyint(10) NOT NULL DEFAULT 0,
  `boiteVitesse` varchar(20) NOT NULL DEFAULT '''Auto'',''Manuel''',
  `prixhorszone` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proprio` (`proprio`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `car`
--
ALTER TABLE `car`
  ADD CONSTRAINT `car_ibfk_1` FOREIGN KEY (`proprio`) REFERENCES `owner` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
