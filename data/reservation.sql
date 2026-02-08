-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : dim. 08 fév. 2026 à 14:53
-- Version du serveur : 11.8.3-MariaDB-log
-- Version de PHP : 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `u929681960_afupcar`
--

-- --------------------------------------------------------

--
-- Structure de la table `reservation`
--

CREATE TABLE `reservation` (
  `id` varchar(20) NOT NULL,
  `conducteur` varchar(200) NOT NULL,
  `voiture` varchar(200) NOT NULL,
  `proprietaire` varchar(200) NOT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `avance` int(11) NOT NULL,
  `caution` int(11) NOT NULL,
  `livraison` int(11) NOT NULL,
  `heuredeprise` time NOT NULL,
  `heurederetour` int(11) NOT NULL,
  `totale` int(11) NOT NULL,
  `statut` tinyint(20) NOT NULL DEFAULT 0,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `reservation`
--

INSERT INTO `reservation` (`id`, `conducteur`, `voiture`, `proprietaire`, `date_debut`, `date_fin`, `avance`, `caution`, `livraison`, `heuredeprise`, `heurederetour`, `totale`, `statut`, `latitude`, `longitude`, `created_at`) VALUES
('ET570', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'EO729322', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2026-01-25', '2026-01-27', 0, 0, 0, '09:00:00', 18, 200, 0, '-0.7081795', '8.770889250000002', '2026-01-24 22:30:29'),
('FP622', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'PZ113352', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2026-03-01', '2026-03-03', 0, 0, 2000, '09:00:00', 18, 122000, 0, NULL, NULL, '2026-02-08 12:55:40'),
('II474', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'KW880366', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-07-12', '2025-07-19', 1, 0, 0, '09:00:00', 18, 420000, 0, NULL, NULL, '2025-07-12 21:44:40'),
('IJ970', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'KB167999', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2026-02-25', '2026-02-28', 1, 0, 2000, '09:00:00', 18, 158000, 0, '-0.7082147500000001', '8.770833750000001', '2026-02-06 22:27:49'),
('KZ394', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'PZ113352', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-07-12', '2025-07-16', 0, 0, 1, '09:00:00', 18, 240000, 1, '-0.7082954', '8.770762', '2025-07-12 06:57:34'),
('NX325', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'RG440632', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-06-24', '2025-07-26', 1, 1, 0, '09:00:00', 18, 1120000, 0, NULL, NULL, '2025-06-24 16:36:13'),
('OC564', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'EO729322', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-08-19', '2025-08-20', 0, 0, 0, '09:00:00', 18, 100, 0, '-0.6920129007841036', '8.769795826849816', '2025-08-19 14:01:44'),
('PO377', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'KB167999', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2026-01-25', '2026-01-28', 1, 0, 2000, '09:00:00', 18, 158000, 0, NULL, NULL, '2026-01-25 01:03:52'),
('UI883', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'EO729322', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-07-16', '2025-07-17', 0, 0, 0, '09:00:00', 18, 100, 0, NULL, NULL, '2025-07-16 09:16:05'),
('VY845', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'PZ113352', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-12-19', '2025-12-27', 0, 0, 0, '09:00:00', 18, 480000, 0, NULL, NULL, '2025-12-17 14:22:32');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conducteur` (`conducteur`),
  ADD KEY `voiture` (`voiture`),
  ADD KEY `proprietaire` (`proprietaire`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`conducteur`) REFERENCES `renter` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`voiture`) REFERENCES `car` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`proprietaire`) REFERENCES `owner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
