-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 23 jan. 2026 à 20:19
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
-- Structure de la table `admin`
--

CREATE TABLE `admin` (
  `id` varchar(300) NOT NULL,
  `fullname` varchar(20) NOT NULL,
  `phone` int(20) NOT NULL,
  `photo` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL,
  `lastvisite` timestamp NOT NULL,
  `currentvisite` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`id`, `fullname`, `phone`, `photo`, `timestamp`, `lastvisite`, `currentvisite`) VALUES
('kfD018wMleaezvXwhl3cAkF11pp1', 'admin adio', 77679339, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1748983539/armada_admin/hd7imnavp8e45c6ovfh7.jpg', '0000-00-00 00:00:00', '2025-07-12 07:53:19', '2025-07-12 07:53:25'),
('ZY1SyVIh8ZU26A35C3tZDkSZUZD2', 'Dikiel edoh', 77679339, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750455402/armada_admin/m2nw3z2idkkfd9pv16bq.jpg', '0000-00-00 00:00:00', '2025-06-20 21:39:03', '2025-06-20 21:41:14');

-- --------------------------------------------------------

--
-- Structure de la table `car`
--

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
-- Déchargement des données de la table `car`
--

INSERT INTO `car` (`id`, `marque`, `modele`, `type`, `description`, `ville`, `sunroof`, `androidauto`, `clime`, `bluetooth`, `photofront`, `photoback`, `photoleft`, `photorigth`, `photoenter`, `prix`, `avance`, `proprio`, `statut`, `fuel`, `comission`, `boiteVitesse`, `prixhorszone`) VALUES
('EO729322', 'Hyundai', 'Santafe ', 'suv', 'Boîte automatique, essence, ', 'Abidjan', 1, 1, 1, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749553052/armada_auto/vehicles/bpfqzdxafnjzh5ovkc2k.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749553063/armada_auto/vehicles/p65ctpzeghisojoo8b0c.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749553422/armada_auto/vehicles/uiup1lzz7qjuwxvbianc.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749553439/armada_auto/vehicles/e6xcwxxqdtwadd8bkdoo.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750278875/armada_auto/vehicles/pzvhn3ejglutilcrpivw.jpg', 100, 0, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Essence', 0, 'Auto', 145),
('KB167999', 'Honda', 'cr-v', 'minibus', 'cevmlefvej ehcdecno', 'Libreville2', 1, 0, 1, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749482604/armada_auto/vehicles/hgvcq84jlugmpk9ew7eq.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749482622/armada_auto/vehicles/aickob9p0lcx3qsenzwt.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749482654/armada_auto/vehicles/tz2lnt5fw8qmdnu3xi2i.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749482645/armada_auto/vehicles/nf2m0fyqhzrxtncy9ohh.jpg', NULL, 52000, 1, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Essence', 0, 'Manuel', 75400),
('KW880366', 'Toyota', 'fortuner 2', 'minibus', 'cdvdfdqscqsdc', 'Abidjan', 0, 1, 1, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747575098/armada_auto/vehicles/favkdwlwvorlh4i0xz6x.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747575105/armada_auto/vehicles/fju9rltt6g9dripejz1m.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747575113/armada_auto/vehicles/ce14e9lnkm9g5ygyfh4a.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750282094/armada_auto/vehicles/mhy19b56xh2erxxgf6fp.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750282108/armada_auto/vehicles/snrujfdxqw81cxnssafl.jpg', 60000, 1, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Essence', 0, 'Auto', 87000),
('PZ113352', 'Hyundai', 'Stinger', 'berline', 'Grande vitesse', 'Bouaké', 1, 1, 1, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749488977/armada_auto/vehicles/diss7samtl91wpkpu2l8.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749488995/armada_auto/vehicles/tj32nmdabdmwopethyzr.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749489009/armada_auto/vehicles/yblkenjouerdtkpayylx.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1749489020/armada_auto/vehicles/gbgigy7ikb7vmuwqt9w2.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750341455/armada_auto/vehicles/x0x0tmgpk6f662qxjzd6.jpg', 60000, 0, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Essence', 0, 'Auto', 87000),
('RG440632', 'Hyundai', 'I30 ', 'suv', 'egfointihtngrt goir,grtoinrtgr oifrgrtn', 'Abidjan', 0, 1, 1, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747579459/armada_auto/vehicles/rfitkcnwl4o74opsqmal.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747579468/armada_auto/vehicles/uw8xx2j8wlborgrp5hgl.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747579479/armada_auto/vehicles/njlcjotrih1dcfnlxzbi.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747683650/armada_auto/vehicles/zxaubzeforartjj6w', NULL, 35000, 1, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Essence', 1, 'Manuel', 50750),
('VU582011', 'Hyundai', 'tucson 202', 'suv', 'oifeufjefefe', 'Abidjan', 1, 1, 1, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747576112/armada_auto/vehicles/ca3em4u8otxjmxqsklek.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747576121/armada_auto/vehicles/to4p0mskdye5dvsufcvm.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747576129/armada_auto/vehicles/e4glgmriebtdiaw9f8cd.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747576139/armada_auto/vehicles/o6wuhyvceehvkkuso', NULL, 45000, 1, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Gazole', 0, 'Auto', 65250),
('ZK841965', 'Toyota', 'fortuneraz', 'minibus', 'giontribzrbntnbrgbrgsb', 'Abidjan', 1, 0, 0, 1, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747585028/armada_auto/vehicles/ppuxfteywhxlzovkfmsb.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747585034/armada_auto/vehicles/fqm1lzmzi1bh6m0di1yy.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747585046/armada_auto/vehicles/szf6uklkaczlnshnppb8.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747687708/armada_auto/vehicles/ihezm2otmuzzo7izndgt.jpg', NULL, 48520, 1, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 0, 'Essence', 1, 'Manuel', 70354);

-- --------------------------------------------------------

--
-- Structure de la table `carmodel`
--

CREATE TABLE `carmodel` (
  `id` varchar(50) NOT NULL,
  `marqueId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `modele` varchar(50) NOT NULL,
  `timestamp` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `carmodel`
--

INSERT INTO `carmodel` (`id`, `marqueId`, `modele`, `timestamp`) VALUES
('AB194773', 'Mazda', 'Rio', '2025-06-18 17:30:03'),
('AE330683', 'Isuzu', 'Rodeo', '2025-06-18 17:32:50'),
('AG853861', 'Mitsubishi', 'Galant', '2025-06-18 17:48:15'),
('AG986317', 'Hyundai', 'Creta', '2025-06-18 17:21:55'),
('AM991763', 'Suzuki', 'Baleno', '2025-06-18 17:18:38'),
('AT230416', 'Mazda', 'RX-8', '2025-06-18 17:28:57'),
('BE541137', 'Honda', 'Crosstour', '2025-06-18 17:24:28'),
('BL745341', 'Mazda', 'ProCeed', '2025-06-18 17:30:05'),
('BO157389', 'Honda', 'Legend', '2025-06-18 17:24:29'),
('BP268071', 'Honda', 'Insight', '2025-06-18 17:24:27'),
('BX701146', 'Suzuki', 'Wagon R', '2025-06-18 17:18:39'),
('CA206306', 'Mazda', 'Ceed', '2025-06-18 17:30:03'),
('CJ386967', 'Hyundai', 'Getz', '2025-06-18 17:21:55'),
('CQ830391', 'Isuzu', 'Amigo', '2025-06-18 17:32:50'),
('CV675257', 'Mitsubishi', 'Delica', '2025-06-18 17:48:15'),
('CW492451', 'Mitsubishi', 'Montero', '2025-06-18 17:48:15'),
('CX582447', 'Isuzu', 'VehiCROSS', '2025-06-18 17:32:50'),
('DB165304', 'Suzuki', 'Kizashi', '2025-06-18 17:18:39'),
('DD652211', 'Mazda', 'Mohave', '2025-06-18 17:30:05'),
('DK417472', 'Hyundai', 'Terracan', '2025-06-18 17:21:56'),
('DN626162', 'Isuzu', 'Piazza', '2025-06-18 17:32:51'),
('DO268330', 'Hyundai', 'Staria', '2025-06-18 17:21:56'),
('DS400388', 'Suzuki', 'Vitara', '2025-06-18 17:18:38'),
('DT441851', 'Isuzu', 'MU-X', '2025-06-18 17:32:49'),
('EF690427', 'Mazda', 'Biante', '2025-06-18 17:28:57'),
('EO896547', 'Hyundai', 'Venue', '2025-06-18 17:21:55'),
('ER315877', 'Mazda', 'MX-30', '2025-06-18 17:28:56'),
('ER756114', 'Isuzu', 'Panther', '2025-06-18 17:32:51'),
('EU316103', 'Toyota', 'Land Cruiser', '2025-06-18 10:35:02'),
('EY163087', 'Mazda', 'Demio', '2025-06-18 17:28:57'),
('EY259772', 'Suzuki', 'Grand Vitara', '2025-06-18 17:18:39'),
('FC312020', 'Hyundai', 'Azera', '2025-06-18 17:21:56'),
('FG220775', 'Mazda', 'Mazda3', '2025-06-18 17:28:55'),
('FI831251', 'Honda', 'Pilot', '2025-06-18 17:24:27'),
('FM454442', 'Mazda', 'CX-5', '2025-06-18 17:28:56'),
('FQ211625', 'Honda', 'Odyssey', '2025-06-18 17:24:27'),
('FY983040', 'Mitsubishi', 'Endeavor', '2025-06-18 17:48:16'),
('GE302032', 'Isuzu', 'Gemini', '2025-06-18 17:32:51'),
('GV971103', 'Mazda', 'Mazda6', '2025-06-18 17:28:55'),
('HA993587', 'Honda', 'Ridgeline', '2025-06-18 17:24:28'),
('HD816824', 'Mitsubishi', 'Outlander', '2025-06-18 17:48:14'),
('HI872097', 'Isuzu', 'Wizard', '2025-06-18 17:32:51'),
('HJ157144', 'Honda', 'Stream', '2025-06-18 17:24:28'),
('HK192363', 'Mazda', 'Soul', '2025-06-18 17:30:04'),
('HR899955', 'Honda', 'Fit', '2025-06-18 17:24:27'),
('HT193978', 'Isuzu', 'Forward', '2025-06-18 17:32:51'),
('IG455623', 'Toyota', 'RAV4', '2025-06-18 10:32:46'),
('IH214663', 'Honda', 'Civic', '2025-06-18 17:24:26'),
('IR592589', 'Mitsubishi', 'Eclipse Cross', '2025-06-18 17:48:14'),
('IR698634', 'Toyota', 'Hiace', '2025-06-18 12:36:13'),
('IT374067', 'Isuzu', 'Faster', '2025-06-18 17:32:51'),
('IV646270', 'Mazda', 'XCeed', '2025-06-18 17:30:04'),
('IZ989152', 'Mitsubishi', 'Triton', '2025-06-18 17:48:15'),
('JE881467', 'Mazda', 'Carens', '2025-06-18 17:30:05'),
('JI721399', 'Suzuki', 'Jimny', '2025-06-18 17:18:38'),
('JM719367', 'Mitsubishi', 'ASX', '2025-06-18 17:48:14'),
('JY231085', 'Mazda', 'Stonic', '2025-06-18 17:30:04'),
('KN193246', 'Isuzu', 'Axiom', '2025-06-18 17:32:50'),
('KN377456', 'Suzuki', 'Ignis', '2025-06-18 17:18:38'),
('KZ857954', 'Mazda', 'Picanto', '2025-06-18 17:30:03'),
('LC578412', 'Mazda', 'BT-50', '2025-06-18 17:28:56'),
('LJ720594', 'Mitsubishi', 'Pajero', '2025-06-18 17:48:14'),
('LM773308', 'Toyota', 'Yaris', '2025-06-18 12:02:23'),
('LU220164', 'Toyota', 'Hilux', '2025-06-18 10:32:14'),
('LW574478', 'Hyundai', 'i20', '2025-06-18 17:21:54'),
('LZ502796', 'Honda', 'S2000', '2025-06-18 17:24:28'),
('MJ191086', 'Honda', 'Elysion', '2025-06-18 17:24:29'),
('MR247432', 'Hyundai', 'i40', '2025-06-18 17:21:54'),
('NJ366195', 'Mazda', 'Sorento', '2025-06-18 17:30:04'),
('NO171037', 'Toyota', 'Prado', '2025-06-18 12:36:12'),
('NO493992', 'Suzuki', 'Splash', '2025-06-18 17:18:39'),
('NR156237', 'Suzuki', 'SX4', '2025-06-18 17:18:39'),
('NR928268', 'Hyundai', 'Kona', '2025-06-18 17:21:55'),
('OA970545', 'Isuzu', 'D-Max', '2025-06-18 17:32:49'),
('OF380480', 'Hyundai', 'Genesis', '2025-06-18 17:21:56'),
('OK496983', 'Hyundai', 'i30', '2025-06-18 17:21:54'),
('OO971773', 'Honda', 'Accord', '2025-06-18 17:24:26'),
('OR330687', 'Isuzu', 'Elf', '2025-06-18 17:32:50'),
('PA130724', 'Mitsubishi', 'Attrage', '2025-06-18 17:48:14'),
('PP127462', 'Mazda', 'Atenza', '2025-06-18 17:28:57'),
('PP931341', 'Honda', 'CR-V', '2025-06-18 17:24:27'),
('PV160551', 'Mazda', 'CX-8', '2025-06-18 17:28:56'),
('PX690254', 'Isuzu', 'N-Series', '2025-06-18 17:32:50'),
('QB288666', 'Toyota', 'Avensis', '2025-06-18 12:36:12'),
('QE578761', 'Honda', 'HR-V', '2025-06-18 17:24:27'),
('QK290629', 'Mitsubishi', 'Space Star', '2025-06-18 17:48:14'),
('QK955982', 'Hyundai', 'Santa Fe', '2025-06-18 17:21:55'),
('QO361913', 'Honda', 'CR-Z', '2025-06-18 17:24:28'),
('QY307454', 'Mazda', 'Mazda2', '2025-06-18 17:28:55'),
('RB289774', 'Toyota', 'Corolla', '2025-06-18 10:30:57'),
('RN563040', 'Suzuki', 'S-Cross', '2025-06-18 17:18:38'),
('RO143418', 'Mazda', 'K5', '2025-06-18 17:30:05'),
('RO460992', 'Isuzu', 'Giga', '2025-06-18 17:32:50'),
('RQ935356', 'Toyota', 'Yaris', '2025-06-18 12:36:12'),
('RR480129', 'Mazda', 'EV6', '2025-06-18 17:30:05'),
('RX105452', 'Mitsubishi', 'Space Wagon', '2025-06-18 17:48:15'),
('SD727386', 'Isuzu', 'Trooper', '2025-06-18 17:32:49'),
('SF652914', 'Hyundai', 'Elantra', '2025-06-18 17:21:54'),
('SH585718', 'Suzuki', 'Alto', '2025-06-18 17:18:38'),
('SK872342', 'Hyundai', 'i10', '2025-06-18 17:21:54'),
('SL159358', 'Hyundai', 'Veloster', '2025-06-18 17:21:56'),
('SR657546', 'Mazda', 'CX-3', '2025-06-18 17:28:55'),
('SV292822', 'Hyundai', 'Sonata', '2025-06-18 17:21:55'),
('TB359640', 'Mazda', 'Tribute', '2025-06-18 17:28:57'),
('TQ727111', 'Honda', 'Jazz', '2025-06-18 17:24:27'),
('UD741934', 'Mazda', 'Premacy', '2025-06-18 17:28:57'),
('UF138427', 'Mazda', 'Seltos', '2025-06-18 17:30:04'),
('US885790', 'Mitsubishi', 'Diamante', '2025-06-18 17:48:16'),
('UW969633', 'Honda', 'Prelude', '2025-06-18 17:24:28'),
('VF110250', 'Mazda', 'Sportage', '2025-06-18 17:30:04'),
('VF172263', 'Mitsubishi', 'Chariot', '2025-06-18 17:48:16'),
('VI125231', 'Hyundai', 'Tucson', '2025-06-18 17:21:55'),
('VM501998', 'Suzuki', 'Swift', '2025-06-18 17:18:38'),
('VN245259', 'Mitsubishi', 'Mirage', '2025-06-18 17:48:14'),
('VO730793', 'Suzuki', 'APV', '2025-06-18 17:18:39'),
('VP702250', 'Honda', 'Element', '2025-06-18 17:24:28'),
('VT708295', 'Mazda', 'CX-9', '2025-06-18 17:28:56'),
('VU441503', 'Isuzu', 'Hombre', '2025-06-18 17:32:51'),
('VZ771722', 'Suzuki', 'Ertiga', '2025-06-18 17:18:39'),
('WA149222', 'Honda', 'City', '2025-06-18 17:24:27'),
('WC799608', 'Honda', 'Passport', '2025-06-18 17:24:28'),
('WM349791', 'Isuzu', 'Ascender', '2025-06-18 17:32:50'),
('WM524930', 'Mitsubishi', '3000GT', '2025-06-18 17:48:16'),
('WM660694', 'Hyundai', 'Accent', '2025-06-18 17:21:54'),
('WM750356', 'Mazda', 'CX-7', '2025-06-18 17:28:56'),
('WU423797', 'Mazda', 'Cerato', '2025-06-18 17:30:03'),
('WV728415', 'Hyundai', 'Bayon', '2025-06-18 17:21:55'),
('WW418244', 'Mazda', 'Familia', '2025-06-18 17:28:57'),
('XB494170', 'Mitsubishi', 'Grandis', '2025-06-18 17:48:15'),
('XH178815', 'Suzuki', 'Celerio', '2025-06-18 17:18:38'),
('XO730848', 'Mitsubishi', 'Lancer', '2025-06-18 17:48:13'),
('XW112850', 'Mazda', 'K8', '2025-06-18 17:30:05'),
('YB437761', 'Mitsubishi', 'Colt', '2025-06-18 17:48:15'),
('YE746579', 'Mazda', 'CX-30', '2025-06-18 17:28:56'),
('YF914815', 'Isuzu', 'F-Series', '2025-06-18 17:32:50'),
('YP856711', 'Mazda', 'MX-5', '2025-06-18 17:28:56'),
('YY194919', 'Mitsubishi', 'Carisma', '2025-06-18 17:48:15'),
('YY203727', 'Toyota', 'Fortuner', '2025-06-18 12:36:13'),
('ZA359259', 'Mazda', 'Millenia', '2025-06-18 17:28:57'),
('ZC873118', 'Mazda', 'Niro', '2025-06-18 17:30:04'),
('ZD186403', 'Toyota', 'Camry', '2025-06-18 12:36:12'),
('ZJ740585', 'Mazda', 'Stinger', '2025-06-18 17:30:04'),
('ZL711217', 'Mazda', 'Optima', '2025-06-18 17:30:04'),
('ZO369221', 'Hyundai', 'Palisade', '2025-06-18 17:21:56'),
('ZY260303', 'Mazda', 'Carnival', '2025-06-18 17:30:05');

-- --------------------------------------------------------

--
-- Structure de la table `commentaire`
--

CREATE TABLE `commentaire` (
  `id_commentaire` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_conversation` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `auteur` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `auteur-inter` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `message` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `document` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `commentaire`
--

INSERT INTO `commentaire` (`id_commentaire`, `id_conversation`, `auteur`, `auteur-inter`, `message`, `document`, `timestamp`) VALUES
('PU985363', 'KZ394', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'Bonjour, bienvenue à Armada. Voici le document de vérification du véhicule : https://res.cloudinary.com/dubsfeixa/image/upload/v1752303694/wafoj5xugxj5oo2j2qxl.png', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1752303694/wafoj5xugxj5oo2j2qxl.png', '2025-07-12 07:01:45'),
('WZ147979', 'KZ394', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'avez ete satisfait ?', '', '2025-07-12 07:05:26');

-- --------------------------------------------------------

--
-- Structure de la table `dateauto`
--

CREATE TABLE `dateauto` (
  `id` varchar(20) NOT NULL,
  `conducteurId` varchar(255) NOT NULL,
  `dateDebut` date NOT NULL,
  `dateFin` date NOT NULL,
  `createAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `dateauto`
--

INSERT INTO `dateauto` (`id`, `conducteurId`, `dateDebut`, `dateFin`, `createAt`) VALUES
('AZ290228', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('BM589949', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-01', '2025-06-04', '2025-05-31 10:35:28'),
('BZ831728', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 14:30:48'),
('CL718114', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:43'),
('CS504641', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-01', '2025-06-19', '2025-05-31 12:21:05'),
('DI187858', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-15', '2025-06-18', '2025-06-14 16:36:17'),
('DZ547350', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 17:34:13'),
('EG745698', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 17:37:30'),
('EZ704825', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-12', '2025-06-15', '2025-06-12 08:29:07'),
('FJ782874', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-01', '2025-06-07', '2025-05-31 10:51:09'),
('FM360687', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:43'),
('FM796224', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 17:34:12'),
('FV171963', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-30', '2025-05-31', '2025-05-29 11:32:39'),
('FX242992', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:44'),
('GD275501', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-10', '2025-06-10 10:49:38'),
('GG187306', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-30', '2025-05-31', '2025-05-30 13:20:58'),
('GR984358', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-11', '2025-06-10 12:01:43'),
('GV654458', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-16', '2025-06-18', '2025-06-16 04:29:03'),
('HF582371', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-21', '2025-06-30', '2025-06-14 16:57:19'),
('IK821800', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-12', '2025-06-10 13:26:46'),
('IX455254', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-11 08:11:08'),
('IZ109831', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('JV238986', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-17', '2025-06-20', '2025-06-10 13:32:08'),
('KN884221', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-17', '2025-06-20', '2025-06-10 13:30:22'),
('KO366941', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-11', '2025-06-09 19:12:35'),
('LI753436', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-30', '2025-05-31', '2025-05-29 11:17:18'),
('LL155652', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-12', '2025-06-11', '2025-06-10 10:49:14'),
('LT285742', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-15', '2025-06-18', '2025-06-15 07:03:02'),
('LX394964', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-15', '2025-06-18', '2025-06-14 16:36:18'),
('MP377070', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:44'),
('MW211848', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-11 08:11:08'),
('NS329209', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:44'),
('NV906154', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('NW797877', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-20', '2025-06-10 12:01:44'),
('NW847787', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-24', '2025-06-25', '2025-06-16 04:42:39'),
('OA250731', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:43'),
('OC700218', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-11', '2025-06-09 14:09:36'),
('OJ178078', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-20', '2025-06-10 19:22:20'),
('OL298557', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-13', '2025-06-10 13:27:10'),
('ON185640', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-30', '2025-05-31', '2025-05-29 11:14:38'),
('OO142633', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-16', '2025-06-09 14:17:48'),
('OP348521', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-30', '2025-05-31', '2025-05-30 13:20:13'),
('OS387438', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-15', '2025-06-18', '2025-06-14 16:36:18'),
('PD979707', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 14:09:23'),
('PE364453', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-15', '2025-06-13', '2025-06-15 07:02:49'),
('PS473724', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-11 08:08:50'),
('PS668616', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 14:30:48'),
('QF307955', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-14', '2025-06-10 13:31:56'),
('QM804464', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-31', '2025-06-08', '2025-05-30 15:40:31'),
('QR704333', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-01', '2025-06-15', '2025-05-31 11:37:54'),
('QS878705', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-11', '2025-06-09 17:53:28'),
('QT288763', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('RZ252069', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-17', '2025-06-19', '2025-06-10 13:31:34'),
('SU999370', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-14', '2025-06-11 13:31:28'),
('TH752479', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-11', '2025-06-10 12:01:44'),
('TP357880', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-16', '2025-06-24', '2025-06-16 04:39:55'),
('TY123722', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:44'),
('TY821208', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('TZ865936', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-13', '2025-06-10 11:18:37'),
('UL273224', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-16', '2025-06-18', '2025-06-16 04:39:13'),
('UW588267', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-13', '2025-06-10 11:18:36'),
('VK928171', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('VM850146', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 14:09:23'),
('WD831823', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-30', '2025-05-31', '2025-05-29 11:37:41'),
('WO862206', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-16', '2025-06-19', '2025-06-16 04:35:43'),
('XB976787', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-10', '2025-06-18', '2025-06-10 12:01:44'),
('YD748405', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-05-29', '2025-05-30', '2025-05-28 21:53:22'),
('YL586745', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-10 12:01:44'),
('YQ936363', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-09', '2025-06-11', '2025-06-09 17:37:30'),
('ZA953194', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', '2025-06-11', '2025-06-13', '2025-06-11 08:08:50');

-- --------------------------------------------------------

--
-- Structure de la table `entretient`
--

CREATE TABLE `entretient` (
  `id` varchar(50) NOT NULL,
  `voiture` varchar(255) NOT NULL,
  `typeEntretient` enum('Horaire','Journalier') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Horaire',
  `description` text NOT NULL,
  `date` date NOT NULL,
  `timestamp` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `entretient`
--

INSERT INTO `entretient` (`id`, `voiture`, `typeEntretient`, `description`, `date`, `timestamp`) VALUES
('ABCDEFGHIJKLMNOPQRSTUVWXYZ615075', 'KB167999', 'Journalier', 'Vidange', '2025-06-09', '2025-06-19 00:06:57'),
('CO556457', 'EO729322', 'Horaire', 'Freins', '2025-06-23', '2025-06-19 11:40:22'),
('DM120588', 'KB167999', 'Horaire', 'Révision', '2025-07-15', '2025-07-12 18:07:39'),
('IQ335975', 'EO729322', 'Horaire', 'Révision', '2025-06-11', '2025-06-19 05:39:35'),
('SO381886', 'EO729322', 'Horaire', 'Révision', '2025-06-10', '2025-06-19 05:39:08');

-- --------------------------------------------------------

--
-- Structure de la table `factures`
--

CREATE TABLE `factures` (
  `external_reference` varchar(255) NOT NULL,
  `bill_id` varchar(255) NOT NULL,
  `statuspay` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `factures`
--

INSERT INTO `factures` (`external_reference`, `bill_id`, `statuspay`, `created_at`) VALUES
('AD442', '5550055261', 0, '2025-07-12 22:42:38'),
('CE440', '5550055140', 0, '2025-06-29 03:39:54'),
('CM604', '5550055248', 0, '2025-07-11 10:44:08'),
('II474', '5550055262', 0, '2025-07-12 22:44:44'),
('KZ394', '5550055336', 0, '2025-07-16 10:11:18'),
('LD337', '5550055243', 0, '2025-07-11 10:36:34'),
('NX325', '5550055257', 0, '2025-07-12 07:06:07'),
('OC564', '5550055835', 0, '2025-08-19 15:01:49'),
('PW358', '5550055319', 0, '2025-07-15 17:13:18'),
('RR696', '5550055328', 0, '2025-07-16 01:00:17'),
('UI883', '5550055339', 0, '2025-07-16 10:16:10'),
('VY845', '5550057174', 0, '2025-12-17 15:22:40'),
('ZV741', '5550055141', 0, '2025-06-29 04:23:27');

-- --------------------------------------------------------

--
-- Structure de la table `favoris`
--

CREATE TABLE `favoris` (
  `id` varchar(20) NOT NULL,
  `voiture` varchar(255) NOT NULL,
  `chauffeur` varchar(255) NOT NULL,
  `proprio` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `favoris`
--

INSERT INTO `favoris` (`id`, `voiture`, `chauffeur`, `proprio`) VALUES
('AC299028', 'EO729322', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1'),
('FX442160', 'KW880366', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1'),
('TH522526', 'RG440632', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1');

-- --------------------------------------------------------

--
-- Structure de la table `feedback`
--

CREATE TABLE `feedback` (
  `feedbackId` varchar(50) NOT NULL,
  `objet` varchar(20) NOT NULL,
  `conducteur` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `proprietaire` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `texte` varchar(600) NOT NULL,
  `document` varchar(600) DEFAULT NULL,
  `creatAt` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `feedback`
--

INSERT INTO `feedback` (`feedbackId`, `objet`, `conducteur`, `proprietaire`, `texte`, `document`, `creatAt`) VALUES
('AQ940019', 'voiture en panne', NULL, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'la voiture recus n\'etait pas de bonne qualité ', NULL, '2025-07-05 06:53:36'),
('BE835096', 'voiture en panne', NULL, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'c\'est la ', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1751705237/zqjz6txi7ttbisxg0oiv.pdf', '2025-07-05 08:51:34'),
('HP275781', 'voiture en panne', NULL, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'rien a voir\n', NULL, '2025-07-05 12:45:06'),
('LO289735', 'draft', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', NULL, 'clock', NULL, '2025-07-05 12:40:13'),
('UC843436', 'voiture en panne', NULL, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'vous ne m\'avez toujours pas repondu \n', NULL, '2025-07-12 07:10:56'),
('VR761600', 'draft', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', NULL, 'alors ', NULL, '2025-07-12 05:06:17');

-- --------------------------------------------------------

--
-- Structure de la table `legale`
--

CREATE TABLE `legale` (
  `legaleId` varchar(50) NOT NULL,
  `titre` varchar(50) NOT NULL,
  `documents` varchar(600) NOT NULL,
  `create_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `legale`
--

INSERT INTO `legale` (`legaleId`, `titre`, `documents`, `create_at`) VALUES
('BG785777', 'CGU locataires', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1751637273/xmkyjqabtlltx0mu0glr.pdf', '2025-07-04 13:57:50'),
('CF941243', 'CGU proprietaire', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1751637871/syjaetwhunft7ckjc5km.pdf', '2025-07-04 14:05:05'),
('NN235525', 'Politique proprietaire', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1751637942/vkpfcntdufdvxrnsyh33.pdf', '2025-07-04 14:06:26'),
('ZM703842', 'Politique locataire', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1751637774/fc2ryrykite9d9xaw32s.pdf', '2025-07-04 14:03:20');

-- --------------------------------------------------------

--
-- Structure de la table `legaleRead`
--

CREATE TABLE `legaleRead` (
  `readId` varchar(50) NOT NULL,
  `reader` varchar(300) NOT NULL,
  `documents` varchar(300) NOT NULL,
  `lu` tinyint(1) NOT NULL,
  `read_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `legaleRead`
--

INSERT INTO `legaleRead` (`readId`, `reader`, `documents`, `lu`, `read_at`) VALUES
('HZ582661', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'CGU-Proprietaires', 1, '2025-07-04 18:19:15'),
('MS956742', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'CGU-Proprietaires', 1, '2025-07-04 18:39:44'),
('VA388502', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'CGU-Proprietaires', 1, '2025-12-17 13:18:05');

-- --------------------------------------------------------

--
-- Structure de la table `livraison`
--

CREATE TABLE `livraison` (
  `id_reservation` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conducteur` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `voiture` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `livré` tinyint(1) NOT NULL DEFAULT 0,
  `recuperé` tinyint(1) NOT NULL DEFAULT 0,
  `verification` tinyint(1) NOT NULL DEFAULT 0,
  `etat` text NOT NULL DEFAULT 'rien à signaler',
  `etatVoiture` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `document` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `livraison`
--

INSERT INTO `livraison` (`id_reservation`, `conducteur`, `voiture`, `livré`, `recuperé`, `verification`, `etat`, `etatVoiture`, `document`, `timestamp`) VALUES
('KZ394', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'PZ113352', 1, 0, 0, 'terminée', 'vérifiée', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1752303694/wafoj5xugxj5oo2j2qxl.png', '2025-07-12 07:00:17');

-- --------------------------------------------------------

--
-- Structure de la table `marque`
--

CREATE TABLE `marque` (
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `marque`
--

INSERT INTO `marque` (`nom`) VALUES
('BMW'),
('Chery'),
('Chevrolet'),
('Citroën'),
('Daihatsu'),
('Dongfeng'),
('Fiat'),
('Ford'),
('Geely'),
('Great Wall'),
('Haval'),
('Honda'),
('Hyundai'),
('Isuzu'),
('JAC'),
('Kia'),
('Land Rover'),
('Mahindra'),
('Mazda'),
('Mercedes-Benz'),
('Mitsubishi'),
('Nissan'),
('Opel'),
('Peugeot'),
('Renault'),
('Subaru'),
('Suzuki'),
('Tata'),
('Toyota'),
('Volkswagen');

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

CREATE TABLE `notifications` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `userId` varchar(450) DEFAULT NULL,
  `type` varchar(400) NOT NULL,
  `title` varchar(600) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(200) DEFAULT NULL,
  `reading` tinyint(1) DEFAULT 0,
  `createdAt` datetime DEFAULT current_timestamp(),
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `userId`, `type`, `title`, `message`, `link`, `reading`, `createdAt`, `meta`) VALUES
('AK112', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-07-12 au 2025-07-16 a été enregistrée.', '/renter/booking/PZ113352', 1, '2025-07-12 06:57:34', '{\"voiture\":\"PZ113352\",\"dateDebut\":\"2025-07-12\",\"dateFin\":\"2025-07-16\",\"total\":240000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('AK290', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Santafe ) a été réservé du 2025-08-19 au 2025-08-20 par un locataire.', '/owner/reservations/EO729322', 0, '2025-08-19 14:01:45', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-08-19\",\"dateFin\":\"2025-08-20\",\"total\":100,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('DB561', 'admin', 'creation_compte_owner', 'Nouveau compte propriétaire', 'Un nouveau propriétaire a créé un compte: Ney Chino (neysimson@gmail.com)', '/admin/owners/rMqcG9HpCwN3Rkwf71uXkin8S1R2', 0, '2025-07-19 20:38:54', '{\"ownerId\":\"rMqcG9HpCwN3Rkwf71uXkin8S1R2\",\"fullname\":\"Ney Chino\",\"email\":\"neysimson@gmail.com\",\"phone\":\"076455422\"}'),
('EM896', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'favori', 'Votre véhicule a été ajouté aux favoris', 'Votre véhicule (Honda cr-v) a été ajouté aux favoris par un locataire.', '/owner/vehicles/KB167999', 1, '2025-07-12 06:11:52', '{\"voiture\":\"KB167999\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('GZ684', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Stinger) a été réservé du 2025-07-12 au 2025-07-16 par un locataire.', '/owner/reservations/PZ113352', 1, '2025-07-12 06:57:34', '{\"voiture\":\"PZ113352\",\"dateDebut\":\"2025-07-12\",\"dateFin\":\"2025-07-16\",\"total\":240000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('HH940', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Santafe ) a été réservé du 2025-07-15 au 2025-07-16 par un locataire.', '/owner/reservations/EO729322', 1, '2025-07-15 16:13:14', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-15\",\"dateFin\":\"2025-07-16\",\"total\":60000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('IM648', 'admin', 'feedback_proprietaire', 'Nouveau feedback propriétaire', 'Un nouveau feedback a été envoyé par le propriétaire (XE0l49Z5DBaTe1zu8VOBEFlyaww1).', '/admin/feedbacks', 0, '2025-07-12 07:10:57', '{\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\",\"objet\":\"voiture en panne\",\"texte\":\"vous ne m\'avez toujours pas repondu \\n\",\"document\":null}'),
('JO654', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Santafe ) a été annulée par le locataire.', '/owner/reservations/CC505', 1, '2025-07-15 16:12:34', '{\"reservationId\":\"CC505\",\"voiture\":\"EO729322\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-07-15T00:00:00.000Z\",\"date_fin\":\"2025-07-16T00:00:00.000Z\"}'),
('JQ404', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'favori', 'Votre véhicule a été retiré des favoris', 'Votre véhicule (Honda cr-v) a été retiré des favoris par un locataire.', '/owner/vehicles/KB167999', 1, '2025-07-12 06:11:58', '{\"voiture\":\"KB167999\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('KN899', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2026-06-12 au 2026-11-13 a été enregistrée.', '/renter/booking/EO729322', 1, '2025-07-12 05:24:25', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2026-06-12\",\"dateFin\":\"2026-11-13\",\"total\":9240000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('KU920', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai tucson 202) a été réservé du 2025-12-19 au 2025-12-25 par un locataire.', '/owner/reservations/VU582011', 1, '2025-07-12 04:40:38', '{\"voiture\":\"VU582011\",\"dateDebut\":\"2025-12-19\",\"dateFin\":\"2025-12-25\",\"total\":270000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('LT370', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Stinger) a été réservé du 2025-12-19 au 2025-12-27 par un locataire.', '/owner/reservations/PZ113352', 0, '2025-12-17 14:22:33', '{\"voiture\":\"PZ113352\",\"dateDebut\":\"2025-12-19\",\"dateFin\":\"2025-12-27\",\"total\":480000,\"conducteur\":\"WQcyuU0pt5ZlxXiLJflS8wRiBLZ2\"}'),
('NH667', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Santafe ) a été réservé du 2025-07-15 au 2025-07-16 par un locataire.', '/owner/reservations/EO729322', 1, '2025-07-15 16:12:10', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-15\",\"dateFin\":\"2025-07-16\",\"total\":60000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('NM495', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-08-19 au 2025-08-20 a été enregistrée.', '/renter/booking/EO729322', 0, '2025-08-19 14:01:45', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-08-19\",\"dateFin\":\"2025-08-20\",\"total\":100,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('NN106', 'admin', 'modification_profil', 'Modification de profil', 'Le locataire Smeb Edoh (lucas@gmail.com) a modifié son profil.', '/admin/renters/AG3EKUVE8zTGPoqew0jXX2AJlEs1', 0, '2025-07-12 06:30:42', '{\"renterId\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"fullname\":\"Smeb Edoh\",\"email\":\"lucas@gmail.com\",\"phone\":\"077679339\"}'),
('OE545', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Toyota fortuner 2) a été réservé du 2027-01-12 au 2027-01-13 par un locataire.', '/owner/reservations/KW880366', 1, '2025-07-12 05:13:05', '{\"voiture\":\"KW880366\",\"dateDebut\":\"2027-01-12\",\"dateFin\":\"2027-01-13\",\"total\":60000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('PG292', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Santafe ) a été réservé du 2025-07-16 au 2025-07-17 par un locataire.', '/owner/reservations/EO729322', 1, '2025-07-16 09:16:06', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-16\",\"dateFin\":\"2025-07-17\",\"total\":100,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('QH318', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-07-15 au 2025-07-16 a été enregistrée.', '/renter/booking/EO729322', 0, '2025-07-15 16:12:10', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-15\",\"dateFin\":\"2025-07-16\",\"total\":60000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('RO187', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Santafe ) a été réservé du 2026-06-12 au 2026-11-13 par un locataire.', '/owner/reservations/EO729322', 1, '2025-07-12 05:24:25', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2026-06-12\",\"dateFin\":\"2026-11-13\",\"total\":9240000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('SX906', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'message', 'Nouveau message reçu', 'Vous avez reçu un nouveau message de la part d\'un locataire.', '/owner/conversations/GB134', 1, '2025-07-12 04:54:02', '{\"id_conversation\":\"GB134\",\"auteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"message\":\"Alors vous êtes la ? \",\"document\":\"\"}'),
('TF651', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Stinger) a été annulée par le locataire.', '/owner/reservations/CM604', 1, '2025-07-12 06:05:40', '{\"reservationId\":\"CM604\",\"voiture\":\"PZ113352\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-07-10T23:00:00.000Z\",\"date_fin\":\"2025-07-15T23:00:00.000Z\"}'),
('TZ292', 'admin', 'modification_vehicule', 'Modification de véhicule', 'Le véhicule Hyundai Santafe  a été modifié par le propriétaire (XE0l49Z5DBaTe1zu8VOBEFlyaww1).', '/admin/cars/EO729322', 0, '2025-07-16 09:13:57', '{\"carId\":\"EO729322\",\"proprio\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\",\"marque\":\"Hyundai\",\"modele\":\"Santafe \"}'),
('UG611', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-07-18 au 2025-07-31 a été enregistrée.', '/renter/booking/EO729322', 0, '2025-07-16 00:00:11', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-18\",\"dateFin\":\"2025-07-31\",\"total\":780000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('UY581', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2027-01-12 au 2027-01-13 a été enregistrée.', '/renter/booking/KW880366', 1, '2025-07-12 05:13:05', '{\"voiture\":\"KW880366\",\"dateDebut\":\"2027-01-12\",\"dateFin\":\"2027-01-13\",\"total\":60000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('VG721', 'admin', 'feedback', 'Nouveau feedback reçu', 'Vous avez reçu un nouveau feedback de la part d\'un locataire.', '/admin/feedbacks/VR761600', 0, '2025-07-12 05:06:17', '{\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"objet\":\"draft\",\"texte\":\"alors \",\"document\":null}'),
('VL425', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-07-16 au 2025-07-17 a été enregistrée.', '/renter/booking/EO729322', 0, '2025-07-16 09:16:06', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-16\",\"dateFin\":\"2025-07-17\",\"total\":100,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('VO429', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Santafe ) a été annulée par le locataire.', '/owner/reservations/PW358', 1, '2025-07-16 09:15:51', '{\"reservationId\":\"PW358\",\"voiture\":\"EO729322\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-07-15T00:00:00.000Z\",\"date_fin\":\"2025-07-16T00:00:00.000Z\"}'),
('VT404', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-07-15 au 2025-07-16 a été enregistrée.', '/renter/booking/EO729322', 0, '2025-07-15 16:13:14', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-15\",\"dateFin\":\"2025-07-16\",\"total\":60000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('VU316', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Santafe ) a été annulée par le locataire.', '/owner/reservations/CE440', 1, '2025-07-15 16:10:38', '{\"reservationId\":\"CE440\",\"voiture\":\"EO729322\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-08-14T00:00:00.000Z\",\"date_fin\":\"2025-09-19T00:00:00.000Z\"}'),
('WK682', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-12-19 au 2025-12-25 a été enregistrée.', '/renter/booking/VU582011', 1, '2025-07-12 04:40:38', '{\"voiture\":\"VU582011\",\"dateDebut\":\"2025-12-19\",\"dateFin\":\"2025-12-25\",\"total\":270000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('WN830', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-12-19 au 2025-12-27 a été enregistrée.', '/renter/booking/PZ113352', 0, '2025-12-17 14:22:33', '{\"voiture\":\"PZ113352\",\"dateDebut\":\"2025-12-19\",\"dateFin\":\"2025-12-27\",\"total\":480000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('XZ295', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'commentaire', 'Nouveau commentaire reçu', 'Vous avez reçu un nouveau commentaire de la part du propriétaire.', '/renter/conversations/KZ394', 1, '2025-07-12 07:05:26', '{\"conversationId\":\"KZ394\",\"ownerId\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\",\"message\":\"avez ete satisfait ?\",\"document\":\"\"}'),
('YA587', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Santafe ) a été annulée par le locataire.', '/owner/reservations/RR696', 1, '2025-07-16 09:10:24', '{\"reservationId\":\"RR696\",\"voiture\":\"EO729322\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-07-18T00:00:00.000Z\",\"date_fin\":\"2025-07-31T00:00:00.000Z\"}'),
('YF643', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Santafe ) a été annulée par le locataire.', '/owner/reservations/AD442', 1, '2025-07-12 21:43:20', '{\"reservationId\":\"AD442\",\"voiture\":\"EO729322\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-06-24T00:00:00.000Z\",\"date_fin\":\"2025-06-25T00:00:00.000Z\"}'),
('YK328', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Hyundai Santafe ) a été réservé du 2025-07-18 au 2025-07-31 par un locataire.', '/owner/reservations/EO729322', 1, '2025-07-16 00:00:12', '{\"voiture\":\"EO729322\",\"dateDebut\":\"2025-07-18\",\"dateFin\":\"2025-07-31\",\"total\":780000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('YS963', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'reservation', 'Nouvelle réservation', 'Votre réservation du 2025-07-12 au 2025-07-19 a été enregistrée.', '/renter/booking/KW880366', 0, '2025-07-12 21:44:40', '{\"voiture\":\"KW880366\",\"dateDebut\":\"2025-07-12\",\"dateFin\":\"2025-07-19\",\"total\":420000,\"proprietaire\":\"XE0l49Z5DBaTe1zu8VOBEFlyaww1\"}'),
('YW371', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Réservation annulée', 'Une réservation sur votre véhicule (Hyundai Stinger) a été annulée par le locataire.', '/owner/reservations/BF152', 1, '2025-07-15 16:10:44', '{\"reservationId\":\"BF152\",\"voiture\":\"PZ113352\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\",\"date_debut\":\"2025-06-24T00:00:00.000Z\",\"date_fin\":\"2025-06-26T00:00:00.000Z\"}'),
('ZC340', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'reservation', 'Nouvelle réservation sur votre véhicule', 'Votre véhicule (Toyota fortuner 2) a été réservé du 2025-07-12 au 2025-07-19 par un locataire.', '/owner/reservations/KW880366', 1, '2025-07-12 21:44:40', '{\"voiture\":\"KW880366\",\"dateDebut\":\"2025-07-12\",\"dateFin\":\"2025-07-19\",\"total\":420000,\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}'),
('ZO544', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'favori', 'Votre véhicule a été ajouté aux favoris', 'Votre véhicule (Honda cr-v) a été ajouté aux favoris par un locataire.', '/owner/vehicles/KB167999', 1, '2025-07-12 06:10:32', '{\"voiture\":\"KB167999\",\"conducteur\":\"AG3EKUVE8zTGPoqew0jXX2AJlEs1\"}');

-- --------------------------------------------------------

--
-- Structure de la table `owner`
--

CREATE TABLE `owner` (
  `id` varchar(200) NOT NULL,
  `fullname` varchar(200) NOT NULL,
  `email` varchar(20) NOT NULL,
  `phone` int(20) NOT NULL,
  `documentcni` text NOT NULL,
  `companyname` varchar(100) DEFAULT NULL,
  `numeronif` varchar(100) DEFAULT NULL,
  `picture` varchar(200) DEFAULT NULL,
  `adresse` varchar(100) DEFAULT NULL,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `owner`
--

INSERT INTO `owner` (`id`, `fullname`, `email`, `phone`, `documentcni`, `companyname`, `numeronif`, `picture`, `adresse`, `latitude`, `longitude`) VALUES
('DvH0jX5aN6e0hH1uVpsjizgfA2m2', 'alvan mouginguie ', 'alvan@gmail.com', 77679339, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750457025/armada_auto/yp0kgl6snyejkq2p7mor.png', NULL, NULL, NULL, NULL, NULL, NULL),
('n6JcJNJ54yXMeee3Tvgc73tM9Pk2', 'Houessou', 'houessouisaac8@gmail', 77150073, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750590642/armada_auto/w3ry13h5a0gfmils8z11.jpg', NULL, NULL, NULL, NULL, NULL, NULL),
('rMqcG9HpCwN3Rkwf71uXkin8S1R2', 'Ney Chino', 'neysimson@gmail.com', 76455422, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1752957523/armada_auto/qgxuo13o8twjbn11d9zc.jpg', NULL, NULL, NULL, NULL, NULL, NULL),
('XE0l49Z5DBaTe1zu8VOBEFlyaww1', 'anibakmdn', 'smeb@gmail.com', 77679339, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747776636/fb3a9l3k7wkw1rn90ezt.png', 'Armada', 'rip52523', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747509412/kit7des8ulmst7gu8zc3.png', 'avenue balise', '0.3964928', '9.50272'),
('XqPe5qfDW0NJJFUHumrwSvmM4dG3', 'Olivier', 'luriks@gmail.com', 77402452, 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750461253/armada_auto/ihkaglimqhe6quwdk3n4.pdf', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

CREATE TABLE `paiement` (
  `id` varchar(20) NOT NULL,
  `conducteur` varchar(255) NOT NULL DEFAULT '',
  `fullname` varchar(255) NOT NULL,
  `type` varchar(20) NOT NULL,
  `reseau` varchar(20) NOT NULL,
  `numero` int(255) NOT NULL,
  `expire_date` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `paiement`
--

INSERT INTO `paiement` (`id`, `conducteur`, `fullname`, `type`, `reseau`, `numero`, `expire_date`) VALUES
('GP696358', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'Smeb Bred', 'mobile', 'airtel', 77679339, NULL),
('MA283190', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'Emmanuel Lucie', 'visa', 'uba', 1150474507, '23/2025');

-- --------------------------------------------------------

--
-- Structure de la table `rating`
--

CREATE TABLE `rating` (
  `id` varchar(50) NOT NULL,
  `id_reservation` varchar(50) NOT NULL,
  `voiture` varchar(255) NOT NULL,
  `proprietaire` varchar(255) NOT NULL,
  `conducteur` varchar(255) NOT NULL,
  `points` int(11) NOT NULL,
  `commentaire` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `regle`
--

CREATE TABLE `regle` (
  `id` varchar(20) NOT NULL,
  `age` int(10) NOT NULL,
  `livraison` int(10) NOT NULL DEFAULT 0,
  `idproprio` varchar(200) NOT NULL,
  `fumer` tinyint(4) NOT NULL DEFAULT 0,
  `animaux` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `regle`
--

INSERT INTO `regle` (`id`, `age`, `livraison`, `idproprio`, `fumer`, `animaux`) VALUES
('FV536332', 24, 0, 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `renter`
--

CREATE TABLE `renter` (
  `id` varchar(100) NOT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `cni` text DEFAULT NULL,
  `permis` text DEFAULT NULL,
  `photo` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `renter`
--

INSERT INTO `renter` (`id`, `fullname`, `email`, `phone`, `cni`, `permis`, `photo`, `created_at`) VALUES
('5GT2U8rPIcMV9oTppzLjlVccPpt2', 'arni levinda', 'arni@gmail.com', '45121245', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750456418/armada_auto/renters/ercdy1y7m4nymeeonqwp.png', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750456427/armada_auto/renters/bbth2ti21ydez8vwrb1l.png', '', '2025-06-20 21:53:56'),
('AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'Smeb Edoh', 'lucas@gmail.com', '077679339', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747760902/armada_auto/renters/xt1t6sbkdnbozog1fubo.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1747760917/armada_auto/renters/ws5pdoxjhfcgorpkfnpy.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1752301829/kh7ah7hkh8izwaovfeqe.jpg', '2025-05-20 17:09:07'),
('RALAY5knPaT55uteTZFmWHUdvbK2', 'Olivier Blampain', 'olivierblampain7@gmail.com', '077402452', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750341931/armada_auto/renters/jdcj00axpwzruzsmy0ya.pdf', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750341951/armada_auto/renters/ztgeq42o2as2jbwifvpg.pdf', '', '2025-06-19 14:06:08'),
('WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'test1', 'test1@gmail.com', '08322895', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1748965355/armada_auto/renters/zg1guwbemktjmmnpromo.jpg', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1748965364/armada_auto/renters/rqinuz4iwuwbpoftoxfi.jpg', '', '2025-06-03 15:42:49'),
('yBxrlzxVWihS0MizDeVvDIK1XOO2', 'Olivier Blampain', 'Olivier@gmail.com', '077402452', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750460821/armada_auto/renters/txu7x16pwjawybhjckjx.pdf', 'https://res.cloudinary.com/dubsfeixa/image/upload/v1750460837/armada_auto/renters/r7lg9ixnf3qm5qsepqqo.pdf', '', '2025-06-20 23:07:59');

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
('II474', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'KW880366', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-07-12', '2025-07-19', 1, 0, 0, '09:00:00', 18, 420000, 0, NULL, NULL, '2025-07-12 21:44:40'),
('KZ394', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'PZ113352', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-07-12', '2025-07-16', 0, 0, 1, '09:00:00', 18, 240000, 1, '-0.7082954', '8.770762', '2025-07-12 06:57:34'),
('NX325', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'RG440632', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-06-24', '2025-07-26', 1, 1, 0, '09:00:00', 18, 1120000, 0, NULL, NULL, '2025-06-24 16:36:13'),
('OC564', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'EO729322', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-08-19', '2025-08-20', 0, 0, 0, '09:00:00', 18, 100, 0, '-0.6920129007841036', '8.769795826849816', '2025-08-19 14:01:44'),
('UI883', 'AG3EKUVE8zTGPoqew0jXX2AJlEs1', 'EO729322', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-07-16', '2025-07-17', 0, 0, 0, '09:00:00', 18, 100, 0, NULL, NULL, '2025-07-16 09:16:05'),
('VY845', 'WQcyuU0pt5ZlxXiLJflS8wRiBLZ2', 'PZ113352', 'XE0l49Z5DBaTe1zu8VOBEFlyaww1', '2025-12-19', '2025-12-27', 0, 0, 0, '09:00:00', 18, 480000, 0, NULL, NULL, '2025-12-17 14:22:32');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proprio` (`proprio`),
  ADD KEY `marque` (`marque`);

--
-- Index pour la table `carmodel`
--
ALTER TABLE `carmodel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `carmodel_ibfk_1` (`marqueId`);

--
-- Index pour la table `commentaire`
--
ALTER TABLE `commentaire`
  ADD PRIMARY KEY (`id_commentaire`),
  ADD KEY `auteur` (`auteur`),
  ADD KEY `auteur-inter` (`auteur-inter`),
  ADD KEY `commentaire_ibfk_3` (`id_conversation`);

--
-- Index pour la table `dateauto`
--
ALTER TABLE `dateauto`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `entretient`
--
ALTER TABLE `entretient`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `factures`
--
ALTER TABLE `factures`
  ADD PRIMARY KEY (`external_reference`),
  ADD UNIQUE KEY `bill_id` (`bill_id`);

--
-- Index pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chauffeur` (`chauffeur`),
  ADD KEY `proprio` (`proprio`),
  ADD KEY `voiture` (`voiture`);

--
-- Index pour la table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedbackId`),
  ADD KEY `conducteur` (`conducteur`),
  ADD KEY `proprietaire` (`proprietaire`);

--
-- Index pour la table `legale`
--
ALTER TABLE `legale`
  ADD PRIMARY KEY (`legaleId`);

--
-- Index pour la table `legaleRead`
--
ALTER TABLE `legaleRead`
  ADD PRIMARY KEY (`readId`);

--
-- Index pour la table `livraison`
--
ALTER TABLE `livraison`
  ADD PRIMARY KEY (`id_reservation`),
  ADD KEY `conducteur` (`conducteur`),
  ADD KEY `voiture` (`voiture`);

--
-- Index pour la table `marque`
--
ALTER TABLE `marque`
  ADD PRIMARY KEY (`nom`);

--
-- Index pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `owner`
--
ALTER TABLE `owner`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_reservation` (`id_reservation`),
  ADD KEY `proprietaire` (`proprietaire`),
  ADD KEY `conducteur` (`conducteur`),
  ADD KEY `voiture` (`voiture`);

--
-- Index pour la table `regle`
--
ALTER TABLE `regle`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idproprio` (`idproprio`);

--
-- Index pour la table `renter`
--
ALTER TABLE `renter`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

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
-- Contraintes pour la table `car`
--
ALTER TABLE `car`
  ADD CONSTRAINT `car_ibfk_1` FOREIGN KEY (`proprio`) REFERENCES `owner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `car_ibfk_2` FOREIGN KEY (`marque`) REFERENCES `marque` (`nom`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `carmodel`
--
ALTER TABLE `carmodel`
  ADD CONSTRAINT `carmodel_ibfk_1` FOREIGN KEY (`marqueId`) REFERENCES `marque` (`nom`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `commentaire`
--
ALTER TABLE `commentaire`
  ADD CONSTRAINT `commentaire_ibfk_3` FOREIGN KEY (`id_conversation`) REFERENCES `reservation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD CONSTRAINT `favoris_ibfk_1` FOREIGN KEY (`chauffeur`) REFERENCES `renter` (`id`),
  ADD CONSTRAINT `favoris_ibfk_2` FOREIGN KEY (`proprio`) REFERENCES `owner` (`id`),
  ADD CONSTRAINT `favoris_ibfk_3` FOREIGN KEY (`voiture`) REFERENCES `car` (`id`);

--
-- Contraintes pour la table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`conducteur`) REFERENCES `renter` (`id`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`proprietaire`) REFERENCES `owner` (`id`);

--
-- Contraintes pour la table `livraison`
--
ALTER TABLE `livraison`
  ADD CONSTRAINT `livraison_ibfk_1` FOREIGN KEY (`conducteur`) REFERENCES `renter` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `livraison_ibfk_2` FOREIGN KEY (`id_reservation`) REFERENCES `reservation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `livraison_ibfk_3` FOREIGN KEY (`voiture`) REFERENCES `car` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `rating`
--
ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`id_reservation`) REFERENCES `reservation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`proprietaire`) REFERENCES `owner` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rating_ibfk_3` FOREIGN KEY (`conducteur`) REFERENCES `renter` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rating_ibfk_4` FOREIGN KEY (`voiture`) REFERENCES `car` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `regle`
--
ALTER TABLE `regle`
  ADD CONSTRAINT `regle_ibfk_1` FOREIGN KEY (`idproprio`) REFERENCES `owner` (`id`);

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
