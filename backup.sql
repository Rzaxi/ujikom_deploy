-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 20, 2025 at 04:41 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `event_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `certificates_issued`
--

CREATE TABLE `certificates_issued` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `certificate_number` varchar(100) NOT NULL,
  `certificate_url` text DEFAULT NULL,
  `issued_date` datetime NOT NULL DEFAULT current_timestamp(),
  `downloaded_at` datetime DEFAULT NULL,
  `download_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `certificates_issued`
--

INSERT INTO `certificates_issued` (`id`, `event_id`, `user_id`, `certificate_number`, `certificate_url`, `issued_date`, `downloaded_at`, `download_count`) VALUES
(9, 171, 72, 'CERT-2025-WEBDEV-001', 'http://localhost:3000/uploads/certificates/cert-webdev-user1.pdf', '2025-12-22 10:00:00', '2025-12-22 11:00:00', 2),
(10, 171, 73, 'CERT-2025-WEBDEV-002', 'http://localhost:3000/uploads/certificates/cert-webdev-user2.pdf', '2025-12-22 10:00:00', '2025-12-22 12:00:00', 1),
(11, 172, 73, 'CERT-2025-UIUX-001', 'http://localhost:3000/uploads/certificates/cert-uiux-user2.pdf', '2025-12-13 14:00:00', '2025-12-13 15:00:00', 1),
(12, 172, 76, 'CERT-2025-UIUX-002', 'http://localhost:3000/uploads/certificates/cert-uiux-user5.pdf', '2025-12-13 14:00:00', NULL, 0),
(13, 173, 72, 'CERT-2025-DIGMAR-001', 'http://localhost:3000/uploads/certificates/cert-digmar-user1.pdf', '2025-12-06 10:00:00', '2025-12-06 11:00:00', 3),
(14, 173, 74, 'CERT-2025-DIGMAR-002', 'http://localhost:3000/uploads/certificates/cert-digmar-user3.pdf', '2025-12-06 10:00:00', '2025-11-19 12:40:24', 3),
(15, 173, 75, 'CERT-2025-DIGMAR-003', 'http://localhost:3000/uploads/certificates/cert-digmar-user4.pdf', '2025-12-06 10:00:00', '2025-12-06 13:00:00', 2),
(16, 173, 76, 'CERT-2025-DIGMAR-004', 'http://localhost:3000/uploads/certificates/cert-digmar-user5.pdf', '2025-12-06 10:00:00', '2025-12-06 14:00:00', 1),
(17, 174, 72, 'CERT-2025-TECHSUM-001', 'http://localhost:3000/uploads/certificates/cert-techsum-user1.pdf', '2025-12-22 16:00:00', '2025-12-22 17:00:00', 1),
(18, 174, 73, 'CERT-2025-TECHSUM-002', 'http://localhost:3000/uploads/certificates/cert-techsum-user2.pdf', '2025-12-22 16:00:00', NULL, 0),
(19, 174, 76, 'CERT-2025-TECHSUM-003', 'http://localhost:3000/uploads/certificates/cert-techsum-user5.pdf', '2025-12-22 16:00:00', '2025-12-22 18:00:00', 2),
(20, 175, 74, 'CERT-2026-PYTHON-001', 'http://localhost:3000/uploads/certificates/cert-python-user3.pdf', '2026-01-15 14:00:00', '2025-11-19 12:40:26', 2),
(21, 178, 77, 'CERT-2025-11-0077', '/certificates/bootcamp-digital-marketing-uiux-ahmad-rizki.pdf', '2025-11-19 18:29:33', '2025-11-19 12:39:39', 1),
(22, 178, 79, 'CERT-2025-11-0079', '/certificates/bootcamp-digital-marketing-uiux-budi-santoso.pdf', '2025-11-19 18:29:33', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `dailyattendances`
--

CREATE TABLE `dailyattendances` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `attendance_date` date NOT NULL COMMENT 'Tanggal kehadiran',
  `status` enum('present','absent','late','excused') NOT NULL DEFAULT 'present' COMMENT 'Status kehadiran',
  `check_in_time` datetime DEFAULT NULL COMMENT 'Waktu check-in (datetime lengkap)',
  `notes` text DEFAULT NULL COMMENT 'Catatan kehadiran',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dailyattendances`
--

INSERT INTO `dailyattendances` (`id`, `event_id`, `user_id`, `attendance_date`, `status`, `check_in_time`, `notes`, `createdAt`, `updatedAt`) VALUES
(108, 171, 72, '2025-12-15', 'present', '2025-12-15 08:45:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(109, 171, 72, '2025-12-16', 'present', '2025-12-16 08:50:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(110, 171, 72, '2025-12-17', 'present', '2025-12-17 08:55:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(111, 171, 72, '2025-12-18', 'present', '2025-12-18 09:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(112, 171, 72, '2025-12-19', 'present', '2025-12-19 08:30:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(113, 171, 72, '2025-12-20', 'present', '2025-12-20 08:40:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(114, 171, 72, '2025-12-21', 'present', '2025-12-21 08:35:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(115, 171, 73, '2025-12-15', 'present', '2025-12-15 09:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(116, 171, 73, '2025-12-16', 'present', '2025-12-16 09:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(117, 171, 73, '2025-12-17', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(118, 171, 73, '2025-12-18', 'present', '2025-12-18 09:10:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(119, 171, 73, '2025-12-19', 'present', '2025-12-19 09:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(120, 171, 73, '2025-12-20', 'present', '2025-12-20 09:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(121, 171, 73, '2025-12-21', 'present', '2025-12-21 09:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(122, 171, 74, '2025-12-15', 'present', '2025-12-15 09:15:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(123, 171, 74, '2025-12-16', 'present', '2025-12-16 09:20:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(124, 171, 74, '2025-12-17', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(125, 171, 74, '2025-12-18', 'present', '2025-12-18 09:25:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(126, 171, 74, '2025-12-19', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(127, 171, 74, '2025-12-20', 'present', '2025-12-20 09:30:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(128, 171, 74, '2025-12-21', 'present', '2025-12-21 09:25:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(129, 172, 73, '2025-12-10', 'present', '2025-12-10 10:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(130, 172, 73, '2025-12-11', 'present', '2025-12-11 10:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(131, 172, 73, '2025-12-12', 'present', '2025-12-12 10:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(132, 172, 75, '2025-12-10', 'present', '2025-12-10 10:10:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(133, 172, 75, '2025-12-11', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(134, 172, 75, '2025-12-12', 'present', '2025-12-12 10:15:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(135, 172, 76, '2025-12-10', 'present', '2025-12-10 10:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(136, 172, 76, '2025-12-11', 'present', '2025-12-11 10:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(137, 172, 76, '2025-12-12', 'present', '2025-12-12 10:10:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(138, 173, 72, '2025-12-05', 'present', '2025-12-05 14:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(139, 173, 74, '2025-12-05', 'present', '2025-12-05 14:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(140, 173, 75, '2025-12-05', 'present', '2025-12-05 14:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(141, 173, 76, '2025-12-05', 'present', '2025-12-05 14:10:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(142, 174, 72, '2025-12-20', 'present', '2025-12-20 08:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(143, 174, 72, '2025-12-21', 'present', '2025-12-21 08:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(144, 174, 73, '2025-12-20', 'present', '2025-12-20 08:10:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(145, 174, 73, '2025-12-21', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(146, 174, 76, '2025-12-20', 'present', '2025-12-20 08:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(147, 174, 76, '2025-12-21', 'present', '2025-12-21 08:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(148, 175, 74, '2026-01-10', 'present', '2026-01-10 09:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(149, 175, 74, '2026-01-11', 'present', '2026-01-11 09:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(150, 175, 74, '2026-01-12', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(151, 175, 74, '2026-01-13', 'present', '2026-01-13 09:00:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(152, 175, 74, '2026-01-14', 'present', '2026-01-14 09:05:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(153, 175, 75, '2026-01-10', 'present', '2026-01-10 09:10:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(154, 175, 75, '2026-01-11', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(155, 175, 75, '2026-01-12', 'present', '2026-01-12 09:15:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(156, 175, 75, '2026-01-13', 'absent', NULL, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(157, 175, 75, '2026-01-14', 'present', '2026-01-14 09:20:00', NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(158, 178, 77, '2025-12-01', 'present', '2025-12-01 08:25:00', 'Hadir tepat waktu, aktif bertanya tentang SEO strategy', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(159, 178, 77, '2025-12-02', 'present', '2025-12-02 08:30:00', 'Presentasi content strategy sangat baik', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(160, 178, 77, '2025-12-03', 'present', '2025-12-03 08:20:00', 'Menguasai Figma dengan cepat, design wireframe bagus', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(161, 178, 77, '2025-12-04', 'present', '2025-12-04 08:35:00', 'Prototype interaktif sangat impresif', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(162, 178, 77, '2025-12-05', 'present', '2025-12-05 08:15:00', 'Final presentation excellent, portfolio siap untuk industri', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(163, 178, 78, '2025-12-01', 'present', '2025-12-01 08:40:00', 'Background design membantu memahami materi dengan cepat', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(164, 178, 78, '2025-12-02', 'excused', NULL, 'Sakit demam, ada surat dokter', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(165, 178, 78, '2025-12-03', 'present', '2025-12-03 08:45:00', 'Sudah recover, sangat antusias dengan materi UI/UX', '2025-11-19 18:29:32', '2025-11-19 18:29:32'),
(166, 178, 78, '2025-12-04', 'late', '2025-12-04 10:30:00', 'Terlambat 2 jam karena macet, tapi mengikuti sesi sore dengan baik', '2025-11-19 18:29:33', '2025-11-19 18:29:33'),
(167, 178, 78, '2025-12-05', 'absent', NULL, 'Keperluan keluarga mendadak, tidak bisa hadir final presentation', '2025-11-19 18:29:33', '2025-11-19 18:29:33'),
(168, 178, 79, '2025-12-01', 'present', '2025-12-01 08:50:00', 'Background programming membantu memahami digital marketing automation', '2025-11-19 18:29:33', '2025-11-19 18:29:33'),
(169, 178, 79, '2025-12-02', 'present', '2025-12-02 08:45:00', 'Sangat tertarik dengan marketing automation tools', '2025-11-19 18:29:33', '2025-11-19 18:29:33'),
(170, 178, 79, '2025-12-03', 'present', '2025-12-03 08:30:00', 'Belajar UI/UX untuk improve aplikasi yang sedang dikembangkan', '2025-11-19 18:29:33', '2025-11-19 18:29:33'),
(171, 178, 79, '2025-12-04', 'present', '2025-12-04 08:40:00', 'Prototype yang dibuat sangat teknis dan fungsional', '2025-11-19 18:29:33', '2025-11-19 18:29:33'),
(172, 178, 79, '2025-12-05', 'excused', NULL, 'Meeting penting dengan klien, tapi sudah submit portfolio via email', '2025-11-19 18:29:33', '2025-11-19 18:29:33');

-- --------------------------------------------------------

--
-- Table structure for table `eventbookmarks`
--

CREATE TABLE `eventbookmarks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `eventregistrations`
--

CREATE TABLE `eventregistrations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `sertifikat_url` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `status` enum('pending','confirmed','cancelled','attended') NOT NULL DEFAULT 'confirmed',
  `attendance_token` varchar(10) DEFAULT NULL COMMENT '10-digit attendance token sent via email during registration',
  `attended_at` datetime DEFAULT NULL COMMENT 'Timestamp when participant attended the event',
  `ticket_category_id` int(11) DEFAULT NULL COMMENT 'ID kategori tiket yang dipilih saat registrasi',
  `payment_id` int(11) DEFAULT NULL COMMENT 'ID pembayaran untuk event berbayar, NULL untuk event gratis'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `eventregistrations`
--

INSERT INTO `eventregistrations` (`id`, `user_id`, `event_id`, `sertifikat_url`, `createdAt`, `updatedAt`, `status`, `attendance_token`, `attended_at`, `ticket_category_id`, `payment_id`) VALUES
(155, 72, 171, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'WEBDEV001', NULL, NULL, NULL),
(156, 73, 171, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'WEBDEV002', NULL, NULL, NULL),
(157, 74, 171, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'WEBDEV003', NULL, NULL, NULL),
(158, 73, 172, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'UIUX001', NULL, NULL, NULL),
(159, 75, 172, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'UIUX002', NULL, NULL, NULL),
(160, 76, 172, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'UIUX003', NULL, NULL, NULL),
(161, 72, 173, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'DIGMAR001', NULL, NULL, NULL),
(162, 74, 173, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'DIGMAR002', NULL, NULL, NULL),
(163, 75, 173, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'DIGMAR003', NULL, NULL, NULL),
(164, 76, 173, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'DIGMAR004', NULL, NULL, NULL),
(165, 72, 174, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'TECHSUM001', NULL, NULL, NULL),
(166, 73, 174, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'TECHSUM002', NULL, NULL, NULL),
(167, 76, 174, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'TECHSUM003', NULL, NULL, NULL),
(168, 74, 175, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'PYTHON001', NULL, NULL, NULL),
(169, 75, 175, NULL, '2025-11-19 11:59:14', '2025-11-19 11:59:14', 'confirmed', 'PYTHON002', NULL, NULL, NULL),
(170, 24, 175, NULL, '2025-11-19 10:23:06', '2025-11-19 10:23:06', 'confirmed', 'CU729OB7DC', NULL, NULL, NULL),
(171, 77, 178, NULL, '2025-11-19 18:29:32', '2025-11-19 18:29:32', 'confirmed', 'AHMAD12345', NULL, NULL, NULL),
(172, 78, 178, NULL, '2025-11-19 18:29:32', '2025-11-19 18:29:32', 'confirmed', 'SITI567890', NULL, NULL, NULL),
(173, 79, 178, NULL, '2025-11-19 18:29:32', '2025-11-19 18:29:32', 'confirmed', 'BUDI098765', NULL, NULL, NULL),
(176, 24, 174, NULL, '2025-11-19 23:18:59', '2025-11-19 23:18:59', 'confirmed', '1129571981', NULL, NULL, NULL),
(177, 24, 171, NULL, '2025-11-19 23:19:34', '2025-11-19 23:19:34', 'confirmed', '7172456939', NULL, NULL, NULL),
(178, 24, 178, NULL, '2025-11-20 06:52:50', '2025-11-20 06:52:50', 'confirmed', '9103775053', NULL, NULL, 43);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `judul` varchar(255) DEFAULT NULL,
  `tanggal` datetime DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `flyer_url` varchar(255) DEFAULT NULL,
  `sertifikat_template` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `kategori` enum('webinar','bootcamp','pelatihan','konser','kompetisi') NOT NULL DEFAULT 'webinar',
  `kapasitas_peserta` int(11) DEFAULT NULL,
  `biaya` decimal(10,2) DEFAULT 0.00,
  `status_event` enum('draft','published','cancelled','completed') NOT NULL DEFAULT 'published',
  `created_by` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `durasi_hari` int(11) NOT NULL DEFAULT 1 COMMENT 'Durasi event dalam hari',
  `minimum_kehadiran` int(11) NOT NULL DEFAULT 1 COMMENT 'Minimum hari kehadiran untuk mendapat sertifikat',
  `memberikan_sertifikat` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Apakah event ini memberikan sertifikat',
  `tanggal_selesai` date DEFAULT NULL COMMENT 'Tanggal selesai event (untuk multi-day events)',
  `waktu_mulai` time DEFAULT NULL COMMENT 'Waktu mulai event',
  `waktu_selesai` time DEFAULT NULL COMMENT 'Waktu selesai event',
  `penyelenggara` varchar(255) DEFAULT NULL COMMENT 'Nama penyelenggara event',
  `sertifikat_elements` text DEFAULT NULL COMMENT 'JSON string of certificate element positions (name, signature, etc)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `judul`, `tanggal`, `lokasi`, `flyer_url`, `sertifikat_template`, `deskripsi`, `kategori`, `kapasitas_peserta`, `biaya`, `status_event`, `created_by`, `createdAt`, `updatedAt`, `durasi_hari`, `minimum_kehadiran`, `memberikan_sertifikat`, `tanggal_selesai`, `waktu_mulai`, `waktu_selesai`, `penyelenggara`, `sertifikat_elements`) VALUES
(171, 'Web Development Bootcamp - Full Stack JavaScript', '2025-12-15 00:00:00', 'Creative Hub Jakarta, Jl. Senopati No. 25, Jakarta Selatan', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&h=600&fit=crop', NULL, 'Bootcamp intensif 7 hari untuk menjadi Full Stack Web Developer. Materi meliputi: HTML, CSS, JavaScript, React.js, Node.js, Express, MongoDB, Git, dan Deployment. Dapatkan sertifikat profesional dan portfolio project untuk karir Anda!', 'bootcamp', 50, 3500000.00, 'published', 24, '2025-11-19 11:59:13', '2025-11-19 11:59:13', 7, 6, 1, '2025-12-21', '09:00:00', '17:00:00', 'Tech Academy Indonesia', NULL),
(172, 'UI/UX Design Workshop - Figma & Design Thinking', '2025-12-10 00:00:00', 'Design Studio, Plaza Indonesia, Jakarta Pusat', 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800&h=600&fit=crop', NULL, 'Workshop 3 hari untuk menguasai UI/UX Design menggunakan Figma. Materi meliputi: Design Thinking, User Research, Wireframing, Prototyping, Usability Testing, dan Design System. Sertifikat profesional tersedia bagi peserta yang lulus.', 'pelatihan', 30, 2500000.00, 'published', 24, '2025-11-19 11:59:13', '2025-11-19 11:59:13', 3, 3, 1, '2025-12-12', '10:00:00', '16:00:00', 'Creative Design Studio', NULL),
(173, 'Digital Marketing Strategy 2025 - Free Webinar', '2025-12-05 00:00:00', 'Online via Zoom', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&h=600&fit=crop', NULL, 'Webinar gratis tentang strategi Digital Marketing terkini untuk tahun 2025. Topik: Social Media Marketing, Google Ads, SEO, Content Strategy, Email Marketing, dan Analytics. Dapatkan e-certificate untuk semua peserta!', 'webinar', 500, 0.00, 'published', 24, '2025-11-19 11:59:13', '2025-11-19 11:59:13', 1, 1, 1, '2025-12-05', '14:00:00', '16:00:00', 'Digital Marketing Indonesia', NULL),
(174, 'Indonesia Tech Summit 2025', '2025-12-20 00:00:00', 'Jakarta Convention Center (JCC), Jakarta Pusat', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop', NULL, 'Konferensi teknologi terbesar di Indonesia. Hadirkan 50+ speakers dari berbagai industri tech. Topik: AI, Cloud Computing, Blockchain, Cybersecurity, IoT, dan Future Tech. Networking session dengan tech leaders dan investor.', 'kompetisi', 1000, 1500000.00, 'published', 24, '2025-11-19 11:59:13', '2025-11-19 11:59:13', 2, 1, 1, '2025-12-21', '08:00:00', '18:00:00', 'Indonesia Tech Community', NULL),
(175, 'Python Programming Bootcamp - Data Science & AI', '2026-01-10 00:00:00', 'Tech Hub Bali, Jl. Sunset Road No. 88, Bali', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&h=600&fit=crop', NULL, 'Bootcamp Python intensif 5 hari fokus Data Science dan AI. Materi: Python Basics, Pandas, NumPy, Matplotlib, Machine Learning dengan Scikit-learn, Deep Learning dengan TensorFlow, dan Real Project. Sertifikat profesional dan job guarantee program!', 'bootcamp', 40, 4000000.00, 'published', 24, '2025-11-19 11:59:13', '2025-11-19 11:59:13', 5, 4, 1, '2026-01-14', '09:00:00', '17:00:00', 'Python Indonesia Academy', NULL),
(178, 'Bootcamp Digital Marketing & UI/UX Design Professional', '2025-12-01 00:00:00', 'Creative Hub Jakarta, Jl. Senopati No. 15, Jakarta Selatan', '/uploads/flyers/bootcamp-digital-marketing-uiux.jpg', NULL, 'Program intensif 5 hari untuk menguasai Digital Marketing dan UI/UX Design. Materi meliputi: Social Media Marketing, Google Ads, SEO, Content Strategy, Figma, Adobe XD, User Research, Prototyping, dan Portfolio Building. Sertifikat profesional tersedia bagi peserta yang lulus.', 'bootcamp', 30, 2500000.00, 'published', 24, '2025-11-19 18:29:32', '2025-11-19 18:29:32', 5, 4, 1, '2025-12-05', '08:30:00', '17:00:00', 'Digital Creative Academy Indonesia', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(255) NOT NULL COMMENT 'Unique invoice number',
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `payment_id` int(11) DEFAULT NULL COMMENT 'NULL for free events',
  `registration_id` int(11) NOT NULL,
  `invoice_type` enum('free','paid') NOT NULL COMMENT 'Type of invoice - free or paid event',
  `amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Invoice amount (0 for free events)',
  `tax_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Tax amount if applicable',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total amount including tax',
  `invoice_status` enum('draft','issued','paid','cancelled') NOT NULL DEFAULT 'issued',
  `issued_date` datetime NOT NULL,
  `due_date` datetime DEFAULT NULL COMMENT 'Due date for paid invoices',
  `paid_date` datetime DEFAULT NULL COMMENT 'Date when invoice was paid',
  `notes` text DEFAULT NULL COMMENT 'Additional notes for the invoice',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `invoice_number`, `user_id`, `event_id`, `payment_id`, `registration_id`, `invoice_type`, `amount`, `tax_amount`, `total_amount`, `invoice_status`, `issued_date`, `due_date`, `paid_date`, `notes`, `createdAt`, `updatedAt`) VALUES
(3, 'INV-1763594339060-CZ04', 24, 174, NULL, 176, 'free', 0.00, 0.00, 0.00, 'paid', '2025-11-19 23:18:59', NULL, '2025-11-19 23:18:59', NULL, '2025-11-19 23:18:59', '2025-11-19 23:18:59'),
(4, 'INV-1763594374771-RUYI', 24, 171, NULL, 177, 'free', 0.00, 0.00, 0.00, 'paid', '2025-11-19 23:19:34', NULL, '2025-11-19 23:19:34', NULL, '2025-11-19 23:19:34', '2025-11-19 23:19:34'),
(5, 'INV-1763621570819-ALFO', 24, 178, 43, 178, 'paid', 2500000.00, 0.00, 0.00, 'issued', '2025-11-20 06:52:50', NULL, NULL, NULL, '2025-11-20 06:52:50', '2025-11-20 06:52:50');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'Type of notification',
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `related_event_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `title`, `message`, `related_event_id`, `is_read`, `read_at`, `createdAt`, `updatedAt`) VALUES
(19, 24, 'event_registered', 'Pendaftaran Berhasil!', 'Anda telah berhasil mendaftar untuk event \"Python Programming Bootcamp - Data Science & AI\". Jangan lupa hadir pada tanggal yang ditentukan!', 175, 1, '2025-11-19 10:23:44', '2025-11-19 10:23:06', '2025-11-19 10:23:44'),
(20, 24, 'event_cancelled', 'Pendaftaran Dibatalkan', 'Anda telah membatalkan pendaftaran untuk event \"Indonesia Tech Summit 2025\".', 174, 0, NULL, '2025-11-19 23:18:13', '2025-11-19 23:18:13'),
(21, 24, 'event_cancelled', 'Pendaftaran Dibatalkan', 'Anda telah membatalkan pendaftaran untuk event \"Web Development Bootcamp - Full Stack JavaScript\".', 171, 0, NULL, '2025-11-19 23:18:35', '2025-11-19 23:18:35');

-- --------------------------------------------------------

--
-- Table structure for table `passwordresets`
--

CREATE TABLE `passwordresets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_expiry` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `order_id` varchar(255) NOT NULL COMMENT 'Unique order ID for Midtrans',
  `xendit_invoice_id` varchar(255) DEFAULT NULL,
  `xendit_response` longtext DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL COMMENT 'Midtrans transaction ID',
  `amount` decimal(15,2) NOT NULL COMMENT 'Payment amount',
  `payment_method` varchar(255) DEFAULT NULL COMMENT 'Payment method used (e.g., credit_card, bank_transfer)',
  `payment_status` enum('pending','paid','failed','cancelled','expired') NOT NULL DEFAULT 'pending',
  `paid_at` datetime DEFAULT NULL COMMENT 'Timestamp when payment was completed',
  `expired_at` datetime DEFAULT NULL COMMENT 'Payment expiration time',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `user_id`, `event_id`, `order_id`, `xendit_invoice_id`, `xendit_response`, `transaction_id`, `amount`, `payment_method`, `payment_status`, `paid_at`, `expired_at`, `createdAt`, `updatedAt`) VALUES
(1, 24, 178, 'ORDER-1763596771254-7CXWR2', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-20 23:59:31', '2025-11-19 23:59:31', '2025-11-19 23:59:31'),
(2, 24, 178, 'ORDER-1763596797709-NW6VGQ', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-20 23:59:57', '2025-11-19 23:59:57', '2025-11-19 23:59:57'),
(3, 24, 172, 'ORDER-1763599399411-7HR6YT', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 00:43:19', '2025-11-20 00:43:19', '2025-11-20 00:43:19'),
(4, 24, 172, 'ORDER-1763599402642-GOCJ9S', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 00:43:22', '2025-11-20 00:43:22', '2025-11-20 00:43:22'),
(5, 24, 178, 'ORDER-1763600062002-1PV9TL', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 00:54:22', '2025-11-20 00:54:22', '2025-11-20 00:54:22'),
(6, 24, 172, 'ORDER-1763601629556-27X1TA', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 01:20:29', '2025-11-20 01:20:29', '2025-11-20 01:20:29'),
(7, 24, 178, 'ORDER-1763601890176-D2L46Q', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 01:24:50', '2025-11-20 01:24:50', '2025-11-20 01:24:50'),
(8, 24, 178, 'ORDER-1763602370810-JGYTS0', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 01:32:50', '2025-11-20 01:32:50', '2025-11-20 01:32:50'),
(9, 24, 172, 'ORDER-1763602480852-YEMABU', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 01:34:40', '2025-11-20 01:34:40', '2025-11-20 01:34:40'),
(10, 24, 172, 'ORDER-1763604930108-NTOQEC', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 02:15:30', '2025-11-20 02:15:30', '2025-11-20 02:15:30'),
(11, 24, 178, 'ORDER-1763611200151-DG3WCM', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:00:00', '2025-11-20 04:00:00', '2025-11-20 04:00:00'),
(12, 24, 178, 'ORDER-1763611842230-TQ78AL', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:10:42', '2025-11-20 04:10:42', '2025-11-20 04:10:42'),
(13, 24, 178, 'ORDER-1763612128892-6YJH0G', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:15:28', '2025-11-20 04:15:28', '2025-11-20 04:15:28'),
(14, 24, 178, 'ORDER-1763612374276-GQSB87', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:19:34', '2025-11-20 04:19:34', '2025-11-20 04:19:34'),
(15, 24, 178, 'ORDER-1763612427939-WXHKNY', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:20:27', '2025-11-20 04:20:27', '2025-11-20 04:20:27'),
(16, 24, 178, 'ORDER-1763612454371-RTP6HA', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:20:54', '2025-11-20 04:20:54', '2025-11-20 04:20:54'),
(17, 24, 178, 'ORDER-1763612483103-5UO2QU', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:21:23', '2025-11-20 04:21:23', '2025-11-20 04:21:23'),
(18, 24, 178, 'ORDER-1763612484959-QWYL0S', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:21:24', '2025-11-20 04:21:24', '2025-11-20 04:21:24'),
(19, 24, 178, 'ORDER-1763612486966-8YNJKB', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:21:26', '2025-11-20 04:21:26', '2025-11-20 04:21:26'),
(20, 24, 178, 'ORDER-1763612489746-9Z4VWW', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:21:29', '2025-11-20 04:21:29', '2025-11-20 04:21:29'),
(21, 24, 178, 'ORDER-1763612492104-L8ONJP', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:21:32', '2025-11-20 04:21:32', '2025-11-20 04:21:32'),
(22, 24, 178, 'ORDER-1763612506639-84DVYX', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:21:46', '2025-11-20 04:21:46', '2025-11-20 04:21:46'),
(23, 24, 178, 'ORDER-1763612544904-QZFSLC', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:22:24', '2025-11-20 04:22:24', '2025-11-20 04:22:24'),
(24, 24, 178, 'ORDER-1763612572935-MGGIYT', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:22:52', '2025-11-20 04:22:52', '2025-11-20 04:22:52'),
(25, 24, 178, 'ORDER-1763612592247-HAY390', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:23:12', '2025-11-20 04:23:12', '2025-11-20 04:23:12'),
(26, 24, 178, 'ORDER-1763612819353-ZAQTQG', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:26:59', '2025-11-20 04:26:59', '2025-11-20 04:26:59'),
(27, 24, 178, 'ORDER-1763612892867-OWXP06', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:28:12', '2025-11-20 04:28:12', '2025-11-20 04:28:12'),
(28, 24, 178, 'ORDER-1763612936117-54HEY8', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:28:56', '2025-11-20 04:28:56', '2025-11-20 04:28:56'),
(29, 24, 178, 'ORDER-1763613395228-MW69YH', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:36:35', '2025-11-20 04:36:35', '2025-11-20 04:36:35'),
(30, 24, 178, 'ORDER-1763613441861-1ZTYGZ', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:37:21', '2025-11-20 04:37:21', '2025-11-20 04:37:21'),
(31, 24, 178, 'ORDER-1763613513858-0C1VR4', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:38:33', '2025-11-20 04:38:33', '2025-11-20 04:38:33'),
(32, 24, 178, 'ORDER-1763613756010-672CHJ', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:42:36', '2025-11-20 04:42:36', '2025-11-20 04:42:36'),
(33, 24, 178, 'ORDER-1763613843785-298CIZ', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:44:03', '2025-11-20 04:44:03', '2025-11-20 04:44:03'),
(34, 24, 178, 'ORDER-1763614172343-VA8TPI', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:49:32', '2025-11-20 04:49:32', '2025-11-20 04:49:32'),
(35, 24, 178, 'ORDER-1763614465638-VELLK3', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 04:54:25', '2025-11-20 04:54:25', '2025-11-20 04:54:25'),
(36, 24, 178, 'ORDER-1763614975948-S7AEMU', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 05:02:55', '2025-11-20 05:02:55', '2025-11-20 05:02:55'),
(37, 24, 178, 'ORDER-1763617325531-RW8H6S', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 05:42:05', '2025-11-20 05:42:05', '2025-11-20 05:42:05'),
(38, 24, 178, 'ORDER-1763617695192-Y55D8T', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 05:48:15', '2025-11-20 05:48:15', '2025-11-20 05:48:15'),
(39, 24, 178, 'ORDER-1763617709494-TOCY16', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 05:48:29', '2025-11-20 05:48:29', '2025-11-20 05:48:29'),
(40, 24, 178, 'ORDER-1763618331511-9F73PZ', '691eae1d0e7c112b091ceb49', '{\"id\":\"691eae1d0e7c112b091ceb49\",\"externalId\":\"ORDER-1763618331511-9F73PZ\",\"userId\":\"691e7e3331338a94f6275fcd\",\"payerEmail\":\"sari.pro@gmail.com\",\"description\":\"Pembayaran untuk Bootcamp Digital Marketing & UI/UX Design Professional\",\"status\":\"PENDING\",\"merchantName\":\"mangrpve\",\"merchantProfilePictureUrl\":\"https://du8nwjtfkinx.cloudfront.net/xendit.png\",\"amount\":2500000,\"expiryDate\":\"2025-11-21T05:58:53.843Z\",\"invoiceUrl\":\"https://checkout-staging.xendit.co/web/691eae1d0e7c112b091ceb49\",\"availableBanks\":[{\"bankCode\":\"BSI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BNC\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"MANDIRI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"MUAMALAT\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"PERMATA\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"CIMB\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"SAHABAT_SAMPOERNA\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BNI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BCA\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BJB\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BRI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000}],\"availableRetailOutlets\":[{\"retailOutletName\":\"INDOMARET\"},{\"retailOutletName\":\"ALFAMART\"}],\"availableEwallets\":[{\"ewalletType\":\"SHOPEEPAY\"},{\"ewalletType\":\"ASTRAPAY\"},{\"ewalletType\":\"JENIUSPAY\"},{\"ewalletType\":\"DANA\"},{\"ewalletType\":\"LINKAJA\"},{\"ewalletType\":\"OVO\"},{\"ewalletType\":\"NEXCASH\"},{\"ewalletType\":\"GOPAY\"}],\"availableQrCodes\":[{\"qrCodeType\":\"QRIS\"}],\"availableDirectDebits\":[{\"directDebitType\":\"DD_BRI\"},{\"directDebitType\":\"DD_MANDIRI\"}],\"availablePaylaters\":[{\"paylaterType\":\"KREDIVO\"},{\"paylaterType\":\"AKULAKU\"},{\"paylaterType\":\"ATOME\"}],\"shouldExcludeCreditCard\":false,\"shouldSendEmail\":false,\"created\":\"2025-11-20T05:58:53.984Z\",\"updated\":\"2025-11-20T05:58:53.984Z\",\"successRedirectUrl\":\"http://localhost:3001/payment/success?order_id=ORDER-1763618331511-9F73PZ\",\"failureRedirectUrl\":\"http://localhost:3001/payment/error?order_id=ORDER-1763618331511-9F73PZ\",\"currency\":\"IDR\",\"items\":[{\"name\":\"Bootcamp Digital Marketing & UI/UX Design Professional\",\"price\":2500000,\"quantity\":1,\"category\":\"bootcamp\"}],\"customer\":{\"email\":\"sari.pro@gmail.com\"}}', NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 05:58:51', '2025-11-20 05:58:51', '2025-11-20 05:58:53'),
(41, 24, 178, 'ORDER-1763621392852-J1KA4R', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 06:49:52', '2025-11-20 06:49:52', '2025-11-20 06:49:52'),
(42, 24, 178, 'ORDER-1763621416264-QAKZ1W', NULL, NULL, NULL, 2500000.00, NULL, 'pending', NULL, '2025-11-21 06:50:16', '2025-11-20 06:50:16', '2025-11-20 06:50:16'),
(43, 24, 178, 'ORDER-1763621430267-C253VN', '691eba420e7c112b091cfec6', '{\"id\":\"691eba420e7c112b091cfec6\",\"externalId\":\"ORDER-1763621430267-C253VN\",\"userId\":\"691e7e3331338a94f6275fcd\",\"payerEmail\":\"sari.pro@gmail.com\",\"description\":\"Pembayaran untuk Bootcamp Digital Marketing & UI/UX Design Professional\",\"status\":\"PENDING\",\"merchantName\":\"mangrpve\",\"merchantProfilePictureUrl\":\"https://du8nwjtfkinx.cloudfront.net/xendit.png\",\"amount\":2500000,\"expiryDate\":\"2025-11-21T06:50:43.042Z\",\"invoiceUrl\":\"https://checkout-staging.xendit.co/web/691eba420e7c112b091cfec6\",\"availableBanks\":[{\"bankCode\":\"BNC\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"SAHABAT_SAMPOERNA\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BRI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"CIMB\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BCA\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"MUAMALAT\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BSI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"MANDIRI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BNI\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"PERMATA\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000},{\"bankCode\":\"BJB\",\"collectionType\":\"POOL\",\"bankBranch\":\"Virtual Account\",\"accountHolderName\":\"MANGRPVE\",\"transferAmount\":2500000}],\"availableRetailOutlets\":[{\"retailOutletName\":\"INDOMARET\"},{\"retailOutletName\":\"ALFAMART\"}],\"availableEwallets\":[{\"ewalletType\":\"SHOPEEPAY\"},{\"ewalletType\":\"ASTRAPAY\"},{\"ewalletType\":\"JENIUSPAY\"},{\"ewalletType\":\"DANA\"},{\"ewalletType\":\"LINKAJA\"},{\"ewalletType\":\"OVO\"},{\"ewalletType\":\"NEXCASH\"},{\"ewalletType\":\"GOPAY\"}],\"availableQrCodes\":[{\"qrCodeType\":\"QRIS\"}],\"availableDirectDebits\":[{\"directDebitType\":\"DD_BRI\"},{\"directDebitType\":\"DD_MANDIRI\"}],\"availablePaylaters\":[{\"paylaterType\":\"KREDIVO\"},{\"paylaterType\":\"AKULAKU\"},{\"paylaterType\":\"ATOME\"}],\"shouldExcludeCreditCard\":false,\"shouldSendEmail\":false,\"created\":\"2025-11-20T06:50:43.137Z\",\"updated\":\"2025-11-20T06:50:43.137Z\",\"successRedirectUrl\":\"http://localhost:3001/payment/success?order_id=ORDER-1763621430267-C253VN\",\"failureRedirectUrl\":\"http://localhost:3001/payment/error?order_id=ORDER-1763621430267-C253VN\",\"currency\":\"IDR\",\"items\":[{\"name\":\"Bootcamp Digital Marketing & UI/UX Design Professional\",\"price\":2500000,\"quantity\":1,\"category\":\"bootcamp\"}],\"customer\":{\"email\":\"sari.pro@gmail.com\"}}', NULL, 2500000.00, 'xendit_sandbox_simulation', 'paid', '2025-11-20 06:52:50', '2025-11-21 06:50:30', '2025-11-20 06:50:30', '2025-11-20 06:52:50');

-- --------------------------------------------------------

--
-- Table structure for table `sequelizemeta`
--

CREATE TABLE `sequelizemeta` (
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sequelizemeta`
--

INSERT INTO `sequelizemeta` (`name`) VALUES
('20240903-add-status-to-eventregistrations.js'),
('20241023-drop-tingkat-kesulitan.js'),
('20241023015900-update-user-roles.js'),
('20241026-add-attended-at-field.js'),
('20241111000000-create-ticket-categories.js'),
('20241111000001-add-ticket-category-to-registrations.js'),
('20241117-add-featured-events.js'),
('20241117161200-add-is-featured-to-events.js'),
('20241120-add-payment-id-to-registrations.js'),
('20241120-add-xendit-fields-to-payments.js'),
('20241120-create-invoices.js'),
('20241120-create-payments.js'),
('20250105020000-add-certificate-requirements-to-events.js'),
('20250105020001-create-daily-attendances.js'),
('20250106140000-update-waktu-fields-add-penyelenggara.js'),
('20250819134500-create-user.js'),
('20250819134515-create-event.js'),
('20250819140119-create-event-registration.js'),
('20250819142143-create-password-reset.js'),
('20250823184200-remove-attendance-fields-from-event-registrations.js'),
('20250827205542-create-admin.js'),
('20250902110000-add-category-to-events.js'),
('20250902120000-update-existing-events-with-defaults.js'),
('20250904175601-create-attendances.js'),
('20250904192720-add-certificate-requirements-to-events.js'),
('20250905184100-add-attendance-token-to-eventregistrations.js'),
('20251012210001-drop-attendance-tables.js'),
('20251012223000-create-event-bookmarks.js'),
('20251014160000-create-notifications.js'),
('20251102082226-add-certificate-elements-to-events.js'),
('20251103000000-create-certificates-issued.js'),
('20251105000000-recreate-daily-attendances.js');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_categories`
--

CREATE TABLE `ticket_categories` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Nama kategori tiket (Early Bird, Regular, VIP, dll)',
  `description` text DEFAULT NULL COMMENT 'Deskripsi kategori tiket',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Harga tiket untuk kategori ini',
  `original_price` decimal(10,2) DEFAULT NULL COMMENT 'Harga asli sebelum diskon (untuk Early Bird)',
  `quota` int(11) DEFAULT NULL COMMENT 'Kuota tiket untuk kategori ini',
  `sold_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Jumlah tiket yang sudah terjual',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Status aktif kategori tiket',
  `sale_start_date` datetime DEFAULT NULL COMMENT 'Tanggal mulai penjualan kategori ini',
  `sale_end_date` datetime DEFAULT NULL COMMENT 'Tanggal berakhir penjualan kategori ini',
  `badge_text` varchar(255) DEFAULT NULL COMMENT 'Text badge (HEMAT 20%, LIMITED, dll)',
  `badge_color` enum('green','blue','red','yellow','purple') DEFAULT 'green' COMMENT 'Warna badge',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Urutan tampilan kategori',
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama_lengkap` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `no_handphone` varchar(255) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `pendidikan_terakhir` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT NULL,
  `verification_token` varchar(255) DEFAULT NULL,
  `verification_expiry` datetime DEFAULT NULL,
  `role` enum('admin','user','event_organizer_basic','event_organizer_pro') DEFAULT 'user',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama_lengkap`, `email`, `no_handphone`, `alamat`, `pendidikan_terakhir`, `password_hash`, `is_verified`, `verification_token`, `verification_expiry`, `role`, `createdAt`, `updatedAt`) VALUES
(17, 'rajib', 'rajibfahri.co@gmail.com', '0895613116694', 'jalan arga bhakti', 'SMA', '$2a$12$tGzRLaAs0KP2GClPDlg5neuGj5SUzd8VvKvClPZz.Dcrk2lBq8y8S', 1, NULL, NULL, '', '2025-08-28 15:26:28', '2025-09-06 06:52:12'),
(21, 'rajib', 'rzaxi79@gmail.com', '0895613116694', 'jalan marga bhakti', 'smkn 4', '$2a$12$mLlnNjyG1emloH.pyWQy4.Dym7srad1rWbr.5K6vp.Bbpoo90Ts22', 1, NULL, NULL, '', '2025-09-08 04:02:06', '2025-09-08 04:03:36'),
(22, 'RAJIB', 'razz15890@gmail.com', '0895613116694', 'jalan marga bhakti', 'smk', '$2a$12$gFaxhnAUPnaGdvKpTBnUBuTAlA1gcQbefbrb.ONIgyIkyJgJbVBhK', 1, NULL, NULL, '', '2025-10-11 11:22:39', '2025-10-12 05:19:13'),
(24, 'Sari Event Pro', 'sari.pro@gmail.com', '081234567891', 'Bandung', 'S1 Komunikasi', '$2b$10$3pXl6Lvls6tW8/urOOz9EeNOh799E4HaywoAoQ2qDPtam39PbAiF2', 1, NULL, NULL, 'event_organizer_pro', '2025-10-23 02:23:35', '2025-10-23 02:23:35'),
(29, 'Sari Event Pro', 'sari.pro@gmail.com', '081234567891', 'Bandung', 'S1 Komunikasi', '$2b$10$3xWeMn8BBA2DaF8EKxOTCeBiEq4iUhWv1QUCVK6oL4kdj6p/yEiry', 1, NULL, NULL, 'event_organizer_pro', '2025-10-23 02:25:28', '2025-10-23 02:25:28'),
(34, 'Sari Event Pro', 'sari.pro@gmail.com', '081234567891', 'Bandung', 'S1 Komunikasi', '$2b$10$GXE8HdG7aF/YPNEdWCSCRu0SPO5.kNc7qwz0hKiPfaSfvx23Hirq.', 1, NULL, NULL, 'event_organizer_pro', '2025-10-23 02:30:02', '2025-10-23 02:30:02'),
(72, 'Budi Santoso', 'budi.santoso@test.com', '081234567801', 'Jakarta Selatan', 'S1 Teknik Informatika', '$2a$10$rOZL5.QE3qKq5vZ5F5X5XeF5X5X5X5X5X5X5X5X5X5X5X5X5X5X5', 1, NULL, NULL, 'user', '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(73, 'Siti Nurhaliza', 'siti.nurhaliza@test.com', '081234567802', 'Bandung', 'S1 Desain Grafis', '$2a$10$rOZL5.QE3qKq5vZ5F5X5XeF5X5X5X5X5X5X5X5X5X5X5X5X5X5X5', 1, NULL, NULL, 'user', '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(74, 'Ahmad Rizki', 'ahmad.rizki@test.com', '081234567803', 'Surabaya', 'S1 Sistem Informasi', '$2b$10$3pXl6Lvls6tW8/urOOz9EeNOh799E4HaywoAoQ2qDPtam39PbAiF2', 1, NULL, NULL, 'user', '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(75, 'Dewi Lestari', 'dewi.lestari@test.com', '081234567804', 'Yogyakarta', 'S1 Manajemen', '$2a$10$rOZL5.QE3qKq5vZ5F5X5XeF5X5X5X5X5X5X5X5X5X5X5X5X5X5X5', 1, NULL, NULL, 'user', '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(76, 'Eko Prasetyo', 'eko.prasetyo@test.com', '081234567805', 'Semarang', 'S1 Marketing', '$2a$10$rOZL5.QE3qKq5vZ5F5X5XeF5X5X5X5X5X5X5X5X5X5X5X5X5X5X5', 1, NULL, NULL, 'user', '2025-11-19 11:59:14', '2025-11-19 11:59:14'),
(77, 'Ahmad Rizki Pratama', 'ahmad.rizki@student.ac.id', '081234567891', 'Jl. Sudirman No. 45, Bandung, Jawa Barat', 'S1 Teknik Informatika - Semester 6', '$2b$10$3pXl6Lvls6tW8/urOOz9EeNOh799E4HaywoAoQ2qDPtam39PbAiF2', 1, NULL, NULL, '', '2025-11-19 18:29:31', '2025-11-19 18:29:31'),
(78, 'Siti Nurhaliza Dewi', 'siti.nurhaliza@designer.com', '081234567892', 'Jl. Gatot Subroto No. 88, Jakarta Selatan', 'S1 Desain Komunikasi Visual', '$2b$10$YQiE8Z.QEZx8pJ5M5x6wXuH5J0K3vZ7dGJ8KzF9VxzYqF0pJZ5B4G', 1, NULL, NULL, '', '2025-11-19 18:29:31', '2025-11-19 18:29:31'),
(79, 'Budi Santoso Wijaya', 'budi.santoso@developer.id', '081234567893', 'Jl. Diponegoro No. 77, Yogyakarta', 'S1 Sistem Informasi', '$2b$10$YQiE8Z.QEZx8pJ5M5x6wXuH5J0K3vZ7dGJ8KzF9VxzYqF0pJZ5B4G', 1, NULL, NULL, '', '2025-11-19 18:29:32', '2025-11-19 18:29:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `certificates_issued`
--
ALTER TABLE `certificates_issued`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `certificate_number` (`certificate_number`),
  ADD KEY `certificates_issued_event_id` (`event_id`),
  ADD KEY `certificates_issued_user_id` (`user_id`),
  ADD KEY `certificates_issued_certificate_number` (`certificate_number`);

--
-- Indexes for table `dailyattendances`
--
ALTER TABLE `dailyattendances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_daily_attendance` (`event_id`,`user_id`,`attendance_date`),
  ADD KEY `daily_attendances_event_id` (`event_id`),
  ADD KEY `daily_attendances_user_id` (`user_id`),
  ADD KEY `daily_attendances_attendance_date` (`attendance_date`),
  ADD KEY `daily_attendances_status` (`status`);

--
-- Indexes for table `eventbookmarks`
--
ALTER TABLE `eventbookmarks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_event_bookmark` (`user_id`,`event_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `eventregistrations`
--
ALTER TABLE `eventregistrations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_registrations_ticket_category_id` (`ticket_category_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `registration_id` (`registration_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `related_event_id` (`related_event_id`),
  ADD KEY `idx_user_read_status` (`user_id`,`is_read`),
  ADD KEY `idx_user_created` (`user_id`,`createdAt`);

--
-- Indexes for table `passwordresets`
--
ALTER TABLE `passwordresets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `sequelizemeta`
--
ALTER TABLE `sequelizemeta`
  ADD PRIMARY KEY (`name`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `ticket_categories`
--
ALTER TABLE `ticket_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_categories_event_id` (`event_id`),
  ADD KEY `ticket_categories_event_id_is_active` (`event_id`,`is_active`),
  ADD KEY `ticket_categories_event_id_sort_order` (`event_id`,`sort_order`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `certificates_issued`
--
ALTER TABLE `certificates_issued`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `dailyattendances`
--
ALTER TABLE `dailyattendances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `eventbookmarks`
--
ALTER TABLE `eventbookmarks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `eventregistrations`
--
ALTER TABLE `eventregistrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=179;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=179;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `passwordresets`
--
ALTER TABLE `passwordresets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `ticket_categories`
--
ALTER TABLE `ticket_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `certificates_issued`
--
ALTER TABLE `certificates_issued`
  ADD CONSTRAINT `certificates_issued_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `certificates_issued_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dailyattendances`
--
ALTER TABLE `dailyattendances`
  ADD CONSTRAINT `dailyattendances_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dailyattendances_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eventbookmarks`
--
ALTER TABLE `eventbookmarks`
  ADD CONSTRAINT `eventbookmarks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `eventbookmarks_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eventregistrations`
--
ALTER TABLE `eventregistrations`
  ADD CONSTRAINT `EventRegistrations_ticket_category_id_foreign_idx` FOREIGN KEY (`ticket_category_id`) REFERENCES `ticket_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invoices_ibfk_3` FOREIGN KEY (`registration_id`) REFERENCES `eventregistrations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`related_event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_categories`
--
ALTER TABLE `ticket_categories`
  ADD CONSTRAINT `ticket_categories_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
