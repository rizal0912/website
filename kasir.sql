-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 13, 2024 at 07:47 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kasir`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `idmenu` int(11) NOT NULL,
  `namamenu` varchar(100) DEFAULT NULL,
  `harga` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`idmenu`, `namamenu`, `harga`) VALUES
(4, 'Ayam goreng', 10000),
(5, 'MIE GORENG', 10000),
(9, 'NASI PECEL', 5000),
(12, 'ayam bakar', 8000),
(40, 'MIE REBUS', 10000);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `idpelanggan` int(11) NOT NULL,
  `namapelanggan` varchar(80) DEFAULT NULL,
  `jeniskelamin` tinyint(1) DEFAULT NULL,
  `nohp` varchar(13) DEFAULT NULL,
  `alamat` varchar(95) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`idpelanggan`, `namapelanggan`, `jeniskelamin`, `nohp`, `alamat`) VALUES
(1, 'raga', 1, '085326161', 'lsjdflksjdf'),
(16, 'YUDHA', 1, '85363123', 'NGEMPALAK'),
(17, 'AYUB', 1, '234234234', 'jalan utama gang cipta'),
(18, 'EKA', 1, '192839213', 'jalan utama ganc tip\\\\r\\\\n'),
(19, 'RIZKY', 1, '234234234', 'jalan utama gang cipta'),
(21, 'dika', 1, '078564856', 'ksdhfkshfsd');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `idpesanan` int(11) NOT NULL,
  `kodepesanan` varchar(15) DEFAULT NULL,
  `menu_idmenu` int(11) NOT NULL,
  `pelanggan_idpelanggan` int(11) NOT NULL,
  `user_iduser` int(11) NOT NULL,
  `jumlah` tinyint(1) NOT NULL,
  `dibuat` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`idpesanan`, `kodepesanan`, `menu_idmenu`, `pelanggan_idpelanggan`, `user_iduser`, `jumlah`, `dibuat`) VALUES
(8, 'ABBBAEAF2B4C5A', 5, 16, 2, 2, '2024-07-13'),
(9, 'AABBDFGFAD3AFC', 9, 17, 2, 6, '2024-07-13');

--
-- Triggers `pesanan`
--
DELIMITER $$
CREATE TRIGGER `before_delete_pesanan` BEFORE DELETE ON `pesanan` FOR EACH ROW UPDATE transaksi SET
transaksi.total = transaksi.total - (SELECT menu.harga * old.jumlah FROM menu WHERE menu.idmenu = old.menu_idmenu)
WHERE transaksi.idtransaksi = old.kodepesanan
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_transaksi` AFTER INSERT ON `pesanan` FOR EACH ROW INSERT INTO transaksi SET
transaksi.idtransaksi = new.kodepesanan,
transaksi.total = (SELECT menu.harga * new.jumlah FROM menu WHERE menu.idmenu = new.menu_idmenu)

ON duplicate KEY UPDATE transaksi.total = transaksi.total + (SELECT menu.harga * new.jumlah FROM menu WHERE menu.idmenu = new.menu_idmenu)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `idtransaksi` varchar(15) NOT NULL,
  `total` int(1) DEFAULT NULL,
  `bayar` int(4) DEFAULT 0,
  `kembalian` int(3) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`idtransaksi`, `total`, `bayar`, `kembalian`, `status`) VALUES
('AABBDFGFAD3AFC', 30000, 0, 0, 0),
('ABADEDFDG3C51F', 30000, 32000, 2000, 1),
('ABBBAEAF2B4C5A', 20000, 0, 0, 0),
('ABBCBBFGBCE31F', 3000, 30000, 7000, 1),
('ABCCCFB12DGAF3', -18000, 13000, 1000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `iduser` int(11) NOT NULL,
  `namauser` varchar(80) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `akses` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`iduser`, `namauser`, `password`, `akses`) VALUES
(2, 'admin', '9aee052e0bf75073fdb55bfa82f074da', 1),
(3, 'naruto', 'cf9ee5bcb36b4936dd7064ee9b2f139e', 2),
(4, 'sasuke', '93207db25ad357906be2fd0c3f65f3dc', 3),
(5, 'owner', '72122ce96bfec66e2396d2e25225d70a', 4);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_pesanan`
-- (See below for the actual view)
--
CREATE TABLE `v_pesanan` (
`idpesanan` int(11)
,`kodepesanan` varchar(15)
,`namapelanggan` varchar(80)
,`namamenu` varchar(100)
,`jumlah` tinyint(1)
,`total` bigint(14)
,`dibuat` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_transaksi`
-- (See below for the actual view)
--
CREATE TABLE `v_transaksi` (
`idtransaksi` varchar(15)
,`total` int(1)
,`bayar` int(4)
,`kembalian` int(3)
,`status` tinyint(1)
);

-- --------------------------------------------------------

--
-- Structure for view `v_pesanan`
--
DROP TABLE IF EXISTS `v_pesanan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_pesanan`  AS SELECT `pesanan`.`idpesanan` AS `idpesanan`, `pesanan`.`kodepesanan` AS `kodepesanan`, `pelanggan`.`namapelanggan` AS `namapelanggan`, `menu`.`namamenu` AS `namamenu`, `pesanan`.`jumlah` AS `jumlah`, (select `menu`.`harga` * `pesanan`.`jumlah` from `menu` where `menu`.`idmenu` = `pesanan`.`menu_idmenu`) AS `total`, `pesanan`.`dibuat` AS `dibuat` FROM ((`pesanan` join `pelanggan` on(`pelanggan`.`idpelanggan` = `pesanan`.`pelanggan_idpelanggan`)) join `menu` on(`menu`.`idmenu` = `pesanan`.`menu_idmenu`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_transaksi`
--
DROP TABLE IF EXISTS `v_transaksi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_transaksi`  AS SELECT `transaksi`.`idtransaksi` AS `idtransaksi`, `transaksi`.`total` AS `total`, `transaksi`.`bayar` AS `bayar`, `transaksi`.`kembalian` AS `kembalian`, `transaksi`.`status` AS `status` FROM `transaksi` WHERE `transaksi`.`status` = 0 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`idmenu`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`idpelanggan`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`idpesanan`),
  ADD KEY `fk_pesanan_menu1_idx` (`menu_idmenu`),
  ADD KEY `fk_pesanan_pelanggan1_idx` (`pelanggan_idpelanggan`),
  ADD KEY `user_iduser` (`user_iduser`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`idtransaksi`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `idmenu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `idpelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `idpesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `fk_pesanan_menu1` FOREIGN KEY (`menu_idmenu`) REFERENCES `menu` (`idmenu`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pesanan_pelanggan1` FOREIGN KEY (`pelanggan_idpelanggan`) REFERENCES `pelanggan` (`idpelanggan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
