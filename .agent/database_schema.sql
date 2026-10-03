-- ====================================================================
-- VISITFLOW DATABASE SCHEMA & SUPPORTING SAMPLE DATA EXPORT
-- Database: VISITFLOW_MF_PROD
-- Export Date: 2026-09-24 04:35:20
-- Total Base Tables: 89 (with up to 5 sample rows per table)
-- Total Views: 20
-- Total Stored Procedures & Functions: 14
-- Standard Collation: utf8mb4_0900_ai_ci
-- ====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

-- ====================================================================
-- SECTION 1: BASE TABLES & SUPPORTING SAMPLE DATA (5 Rows Max)
-- ====================================================================

-- --------------------------------------------------------------------
-- Table structure for `approvals`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `approvals`;
CREATE TABLE `approvals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `content_id` varchar(50) NOT NULL,
  `body` longtext,
  `submission_id` int unsigned NOT NULL,
  `submission_name` varchar(200) DEFAULT NULL,
  `approved_id` bigint unsigned DEFAULT NULL,
  `approved_name` varchar(200) DEFAULT NULL,
  `approved_fcm` longtext,
  `status` varchar(100) DEFAULT NULL,
  `end_point_approved` varchar(200) DEFAULT NULL,
  `end_point_rejected` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`,`title`,`content_id`,`submission_id`),
  KEY `idx_approvals_deleted_at` (`deleted_at`),
  KEY `idx_approvals_content_id` (`content_id`),
  KEY `idx_approvals_approved_id` (`approved_id`),
  KEY `idx_approvals_status` (`status`),
  KEY `idx_approvals_approved_del_status` (`approved_id`,`deleted_at`,`status`),
  KEY `idx_approvals_submission_del_status` (`submission_id`,`deleted_at`,`status`),
  KEY `idx_approvals_content_del` (`content_id`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=225307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `approvals` (5 rows)
INSERT INTO `approvals` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `title`, `content_id`, `body`, `submission_id`, `submission_name`, `approved_id`, `approved_name`, `approved_fcm`, `status`, `end_point_approved`, `end_point_rejected`) VALUES
  (801, '2025-04-30 09:48:26.195000', '2025-04-30 09:51:13.041000', NULL, 0, 0, NULL, 'Approval Structure City', '37828', '	<p style="text-align: center;">Period</p>	<p style="text-align: center;"><strong>30 April 2025</strong></p>	<hr style="text-align: center;" noshade="noshade" size="1" width="100%" />	<div style="display: flex; justify-content: space-around;">		<div><p style="text-align: center;">Create By</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600;">TRNSPV1</p></div>		<div><p style="text-align: center;">User Name</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600; color: rgb(103, 187, 247);">Mohamad Alfian Hilmi Aziezi</p></div>	</div>	<br>	<p style="text-align: center; color: rgb(247, 76, 76);"><strong>Note</strong></p>	<p>Please follow up on this transaction, you can reject if you don''t want to process this transaction.</p>	', 1230992, 'Mohamad Alfian Hilmi Aziezi', 1182090, 'Andri Indrayana', 'dIVs3xeYSi2auw-ZxmpYKW:APA91bGh4vHLwV0qxQZAKZQ5WeN18Duz5l1ohZieRX0Mzdp_oqgsb3DgAyoLKGWkCPvCJ8p6hecb4q_IZ1cf3xd4HQFUdEIzO4LWHBXWBU1TFb8D4goP-_c', 'approved', '/structure-cities/37828/approved', '/structure-cities/37828/rejected'),
  (802, '2025-04-30 10:03:07.747000', '2025-04-30 10:14:57.657000', NULL, 0, 0, NULL, 'Approval Visit Customer', '447', '	<p style="text-align: center;">Period</p>	<p style="text-align: center;"><strong>30 April 2025</strong></p>	<hr style="text-align: center;" noshade="noshade" size="1" width="100%" />	<div style="display: flex; justify-content: space-around;">		<div><p style="text-align: center;">Create By</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600;">JKTA5S201</p></div>		<div><p style="text-align: center;">User Name</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600; color: rgb(103, 187, 247);">Muhammad Malik Abdul Aziz</p></div>	</div>	<br>	<p style="text-align: center; color: rgb(247, 76, 76);"><strong>Note</strong></p>	<p>Please follow up on this transaction, you can reject if you don''t want to process this transaction.</p>	', 1240902, 'Muhammad Malik Abdul Aziz', 1190452, 'Arif Maulana', '', 'approved', '/visit-customers/447/approved', '/visit-customers/447/rejected'),
  (803, '2025-04-30 10:06:28.672000', '2025-04-30 10:14:59.796000', NULL, 0, 0, NULL, 'Approval Visit Customer', '448', '	<p style="text-align: center;">Period</p>	<p style="text-align: center;"><strong>30 April 2025</strong></p>	<hr style="text-align: center;" noshade="noshade" size="1" width="100%" />	<div style="display: flex; justify-content: space-around;">		<div><p style="text-align: center;">Create By</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600;">JKTA5S201</p></div>		<div><p style="text-align: center;">User Name</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600; color: rgb(103, 187, 247);">Muhammad Malik Abdul Aziz</p></div>	</div>	<br>	<p style="text-align: center; color: rgb(247, 76, 76);"><strong>Note</strong></p>	<p>Please follow up on this transaction, you can reject if you don''t want to process this transaction.</p>	', 1240902, 'Muhammad Malik Abdul Aziz', 1190452, 'Arif Maulana', '', 'approved', '/visit-customers/448/approved', '/visit-customers/448/rejected'),
  (804, '2025-04-30 10:13:45.599000', '2025-04-30 10:15:01.968000', NULL, 0, 0, NULL, 'Approval Visit', '1157503', '	<p style="text-align: center;">Period</p>	<p style="text-align: center;"><strong>30 April 2025</strong></p>	<hr style="text-align: center;" noshade="noshade" size="1" width="100%" />	<div style="display: flex; justify-content: space-around;">		<div><p style="text-align: center;">Create By</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600;">JKTA5S201</p></div>		<div><p style="text-align: center;">User Name</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600; color: rgb(103, 187, 247);">Muhammad Malik Abdul Aziz</p></div>	</div>	<br>	<p style="text-align: center; color: rgb(247, 76, 76);"><strong>Note</strong></p>	<p>Please follow up on this transaction, you can reject if you don''t want to process this transaction.</p>	', 1240902, 'Muhammad Malik Abdul Aziz', 1190452, 'Arif Maulana', '', 'plan-approved', '/visits/1157503/approved', '/visits/1157503/plan-rejected'),
  (805, '2025-04-30 10:16:28.701000', '2025-04-30 10:16:28.701000', NULL, 0, 0, NULL, 'Approval Visit Customer', '449', '	<p style="text-align: center;">Period</p>	<p style="text-align: center;"><strong>30 April 2025</strong></p>	<hr style="text-align: center;" noshade="noshade" size="1" width="100%" />	<div style="display: flex; justify-content: space-around;">		<div><p style="text-align: center;">Create By</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600;">JKTA4S5</p></div>		<div><p style="text-align: center;">User Name</p>		<p style="margin-top: -4px; text-align: center; font-weight: 600; color: rgb(103, 187, 247);">Januar Rino Haqiqi</p></div>	</div>	<br>	<p style="text-align: center; color: rgb(247, 76, 76);"><strong>Note</strong></p>	<p>Please follow up on this transaction, you can reject if you don''t want to process this transaction.</p>	', 1192386, 'Januar Rino Haqiqi', 1190452, 'Arif Maulana', '', 'draft', '/visit-customers/449/approved', '/visit-customers/449/rejected');

-- --------------------------------------------------------------------
-- Table structure for `area_recomendation_estimations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `area_recomendation_estimations`;
CREATE TABLE `area_recomendation_estimations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_id` varchar(20) NOT NULL,
  `qty` double DEFAULT '0',
  `value` double DEFAULT '0',
  `is_input` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_period_structure_product` (`period`,`structure_id`,`product_id`),
  KEY `idx_prescription_estimation_boss_period` (`period`),
  KEY `idx_prescription_estimation_boss_structure_id` (`structure_id`),
  KEY `idx_area_recomendation_estimations_deleted_at` (`deleted_at`),
  KEY `idx_deleted_at_period_structure` (`deleted_at`,`period`,`structure_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1028 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `area_recomendation_estimations` (5 rows)
INSERT INTO `area_recomendation_estimations` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `structure_id`, `product_id`, `qty`, `value`, `is_input`) VALUES
  (1, '2026-07-29 08:19:12', '2026-07-30 10:01:12.909000', NULL, NULL, 12345, NULL, '202607', 'JAPA1', 'ASAM', 50.0, 4950000.0, 1),
  (4, '2026-07-29 10:07:04.646000', '2026-07-29 10:07:38.035000', NULL, NULL, NULL, NULL, '202607', 'BDGA1', 'BIOKSM', 0.0, 0.0, 1),
  (5, '2026-07-29 10:07:04.646000', '2026-07-29 10:07:38.035000', NULL, NULL, NULL, NULL, '202607', 'BDGA1', 'XEZYMT1', 0.0, 0.0, 1),
  (6, '2026-07-29 10:07:04.646000', '2026-07-29 10:07:38.035000', NULL, NULL, NULL, NULL, '202607', 'BDGA1', 'BLODBS10', 0.0, 0.0, 1),
  (7, '2026-07-29 10:07:04.646000', '2026-07-29 10:07:38.035000', NULL, NULL, NULL, NULL, '202607', 'BDGA1', 'QHART', 0.0, 0.0, 1);

-- --------------------------------------------------------------------
-- Table structure for `areas`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `areas`;
CREATE TABLE `areas` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_areas_id` (`id`),
  UNIQUE KEY `idx_areas` (`name`,`company_id`),
  KEY `idx_areas_deleted_at` (`deleted_at`),
  KEY `fk_companies_area` (`company_id`),
  KEY `idx_areas_name` (`name`) USING BTREE,
  CONSTRAINT `fk_companies_area` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `areas` (5 rows)
INSERT INTO `areas` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `company_id`) VALUES
  ('ABW', '2023-09-07 16:14:37.437000', '2023-09-07 16:14:37.437000', NULL, NULL, NULL, NULL, 'AMBARAWA', 1),
  ('ACH', '2023-09-07 16:14:37.437000', '2023-09-07 16:14:37.437000', NULL, NULL, NULL, NULL, 'ACEH', 2),
  ('AGM', '2023-09-07 16:14:37.437000', '2023-09-07 16:14:37.437000', NULL, NULL, NULL, NULL, 'AGAM', 1),
  ('AMB', '2023-09-07 16:14:37.437000', '2023-09-07 16:14:37.437000', NULL, NULL, NULL, NULL, 'AMBON', 1),
  ('AMP', '2023-09-07 16:14:37.437000', '2023-09-07 16:14:37.437000', NULL, NULL, NULL, NULL, 'AMPAH', 1);

-- --------------------------------------------------------------------
-- Table structure for `attendance_corrections`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `attendance_corrections`;
CREATE TABLE `attendance_corrections` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `office_id` varchar(100) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `in_date_time` datetime(3) DEFAULT NULL,
  `in_recognized_name` varchar(100) DEFAULT NULL,
  `out_date_time` datetime(3) DEFAULT NULL,
  `dept` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `note_boss` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `note_hrd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `approval_hrd_at` datetime(3) DEFAULT NULL,
  `approval_hrd_by_id` bigint unsigned DEFAULT NULL,
  `approval_boss_at` datetime(3) DEFAULT NULL,
  `approval_boss_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_presence_corrections` (`user_id`,`in_date_time`),
  KEY `fk_presence_corrections_office` (`office_id`),
  KEY `idx_presence_corrections_deleted_at` (`deleted_at`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_in_date_time` (`in_date_time`),
  KEY `idx_office_user` (`office_id`,`user_id`),
  KEY `idx_presence_corrections_user_date` (`user_id`,`in_date_time`,`deleted_at`),
  KEY `idx_att_corr_user_status_del` (`user_id`,`status`,`deleted_at`),
  CONSTRAINT `fk_presence_corrections_office` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `attendance_corrections` (5 rows)
INSERT INTO `attendance_corrections` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `office_id`, `user_id`, `status`, `in_date_time`, `in_recognized_name`, `out_date_time`, `dept`, `note`, `note_boss`, `note_hrd`, `approval_hrd_at`, `approval_hrd_by_id`, `approval_boss_at`, `approval_boss_by_id`) VALUES
  (30, '2026-02-09 01:36:22.927000', '2026-02-09 04:39:48.308000', NULL, 1901016, 1801008, NULL, 'T1', 1901016, 'approved hrd', '2026-02-03 23:47:00', 'Mila Amelia', '2026-02-04 01:36:00', 'VNEU', 'lupa absen pulang', 'ok', 'siopo', '2026-02-09 04:39:48.300000', 1801008, '2026-02-09 03:31:47.808000', 1801008),
  (37, '2026-03-05 10:12:39.246000', '2026-03-10 00:54:29.870000', NULL, 1801001, 1234, NULL, 'T1', 1801001, 'approved boss', '2026-03-05 10:12:00', 'Nunung Pamungkas', '2026-03-05 10:12:00', 'MKT', 'test
', 'ok', '', NULL, NULL, '2026-03-10 00:54:29.870000', 1234),
  (38, '2026-03-09 01:34:46.189000', '2026-03-09 01:50:48.888000', NULL, 2207004, 123, NULL, 'T1', 2207004, 'approved hrd', '2026-03-09 00:05:00', 'Umar Maruf Mutaqin', '2026-03-09 08:45:00', 'VNEU', 'error absen kemarin pagi', 'ok', 'sip', '2026-03-09 01:50:48.887000', 123, '2026-03-09 01:35:30.631000', 2201001),
  (39, '2026-03-09 04:22:50.159000', '2026-03-09 05:03:24.411000', NULL, 123, 2201001, NULL, 'T2', 123, 'approved hrd', '2026-03-03 00:00:00', 'Umar Maruf Mutaqin Tes Visitflow', '2026-03-03 07:34:00', 'MKT', 'tes', 'Oke sip', 'yeah', '2026-03-09 05:03:24.410000', 2201001, '2026-03-09 05:01:10.611000', 1234),
  (40, '2026-03-10 00:31:23.778000', '2026-03-10 00:38:11.680000', NULL, 2201001, 2201001, NULL, 'T1', 2201001, 'approved hrd', '2026-02-23 00:04:00', 'Abdurrahman Arifin', '2026-02-23 08:40:00', 'VNEU', 'salah office', 'ok', 'ok', '2026-03-10 00:38:11.680000', 2201001, '2026-03-10 00:31:55.281000', 1901016);

-- --------------------------------------------------------------------
-- Table structure for `attendance_deductions`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `attendance_deductions`;
CREATE TABLE `attendance_deductions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) DEFAULT NULL,
  `late_start` double DEFAULT NULL,
  `late_end` double DEFAULT NULL,
  `grace_days` double DEFAULT '0',
  `penalty_amount` double DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  `company_id` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_company_period_time` (`period`,`company_id`,`late_start`,`late_end`),
  KEY `idx_attendance_deductions_company_period` (`company_id`,`period`),
  KEY `idx_attendance_deductions_late_time` (`late_start`,`late_end`),
  KEY `idx_attendance_deductions_late_end` (`late_end`),
  KEY `idx_attendance_deductions_deleted_at` (`deleted_at`),
  KEY `idx_attendance_deductions_period_end` (`period`,`late_end` DESC),
  KEY `idx_attded_period_late` (`period`,`late_start`,`late_end`),
  CONSTRAINT `attendance_deductions_chk_1` CHECK ((`late_start` < `late_end`))
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `attendance_deductions` (5 rows)
INSERT INTO `attendance_deductions` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `late_start`, `late_end`, `grace_days`, `penalty_amount`, `note`, `company_id`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, '202601', 1.0, 15.0, 3.0, 50000.0, 'Potongan berlaku jika telat sudah 4  kali (toleransi 3 hari /grace days) dalam sebulan', '1'),
  (2, NULL, NULL, NULL, NULL, NULL, NULL, '202601', 16.0, 60.0, 0.0, 30000.0, 'Potongan langsung tidak ada toleransi telat dari menit 16 sampai menit 60 /08:16 - 09:00', '1'),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, '202601', 61.0, 120.0, 0.0, 50000.0, 'Potongan langsung tidak ada toleransi telat dari menit 61 sampai menit 120 / 09:01 - 10:00', '1'),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, '202601', 121.0, 600.0, 0.0, 100000.0, 'Potongan langsung tidak ada toleransi telat dari menit 121  / 10:01 -12.00  / diatas 121 menit', '1'),
  (10, NULL, NULL, NULL, NULL, NULL, NULL, '202602', 1.0, 15.0, 3.0, 50000.0, 'Potongan berlaku jika telat sudah 4  kali (toleransi 3 hari /grace days) dalam sebulan', '1');

-- --------------------------------------------------------------------
-- Table structure for `bridging_product_specialists`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `bridging_product_specialists`;
CREATE TABLE `bridging_product_specialists` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `product_id` varchar(20) NOT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `customer_category_id` bigint NOT NULL,
  `customer_category_name` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique` (`product_id`,`customer_category_id`,`company_id`) USING BTREE,
  KEY `idx_bridging_product_specialists_deleted_at` (`deleted_at`),
  KEY `idx_bps_cust_cat_prod` (`customer_category_id`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4983 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `bridging_product_specialists` (5 rows)
INSERT INTO `bridging_product_specialists` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `product_id`, `product_name`, `customer_category_id`, `customer_category_name`, `description`, `company_id`) VALUES
  (2, NULL, NULL, NULL, NULL, NULL, NULL, 'ASPEC500', 'Analspec 500 mg', 1, 'SP.M - SPESIALIS MATA', 'OTHERS', 1),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, 'ASAM', 'Asamnex tablet', 1, 'SP.M - SPESIALIS MATA', 'OTHERS', 1),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, 'BEMET1I1', 'Bevamet 100 mg/4mL', 1, 'SP.M - SPESIALIS MATA', 'MAIN', 1),
  (305, NULL, NULL, NULL, NULL, NULL, NULL, 'BITIS1K1', 'Biometis Kapsul', 1, 'SP.M - SPESIALIS MATA', 'OTHERS', 1),
  (306, NULL, NULL, NULL, NULL, NULL, NULL, 'BINHDT2M', 'Biosan HD.', 1, 'SP.M - SPESIALIS MATA', 'OTHERS', 1);

-- --------------------------------------------------------------------
-- Table structure for `calendar_historys`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `calendar_historys`;
CREATE TABLE `calendar_historys` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `date` varchar(100) NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_mkt` tinyint(1) DEFAULT NULL,
  `is_non_mkt` tinyint(1) DEFAULT '1',
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2226 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `calendar_historys` (5 rows)
INSERT INTO `calendar_historys` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `date`, `title`, `description`, `is_mkt`, `is_non_mkt`, `company_id`) VALUES
  (324, '2024-01-01 00:00:00', '2026-02-24 04:31:41.380000', 2207004, 0, 2207004, '2026-06-01', 'Monday', 'Hari Lahir Pancasila', NULL, 1, 1),
  (401, '2024-01-01 00:00:00', '2026-03-13 07:04:21.623000', 2207004, 0, 123, '2026-08-17', 'Monday', 'Hari Kemerdekaan RI', NULL, 1, 1),
  (507, '2024-01-01 00:00:00', '2026-05-28 04:40:02.749000', 2207004, 0, 2207004, '2026-12-01', 'Tuesday', 'Hari kerja biasa', NULL, 1, 1),
  (508, '2024-01-01 00:00:00', '2026-05-28 04:40:02.768000', 2207004, 0, 2207004, '2026-12-02', 'Wednesday', 'Hari kerja biasa', NULL, 1, 1),
  (509, '2024-01-01 00:00:00', '2026-05-28 04:40:02.781000', 2207004, 0, 2207004, '2026-12-03', 'Thursday', 'Hari kerja biasa', NULL, 1, 1);

-- --------------------------------------------------------------------
-- Table structure for `calendars`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `calendars`;
CREATE TABLE `calendars` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `date` varchar(100) NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_mkt` tinyint(1) DEFAULT '0',
  `is_non_mkt` tinyint(1) DEFAULT '1',
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_calendar` (`date`,`company_id`) USING BTREE,
  KEY `fk_calendars_updated_by` (`updated_by_id`),
  KEY `fk_calendars_created_by` (`created_by_id`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_title` (`title`),
  KEY `idx_cal_date` (`date`),
  KEY `idx_cal_company_date` (`company_id`,`date`),
  CONSTRAINT `fk_calendars_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_calendars_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2260 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `calendars` (5 rows)
INSERT INTO `calendars` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `date`, `title`, `description`, `is_mkt`, `is_non_mkt`, `company_id`) VALUES
  (173, '2024-01-01 00:00:00', NULL, 2207004, NULL, NULL, '2026-01-01', 'Thursday', 'Tahun Baru Masehi', 0, 0, 1),
  (174, '2024-01-01 00:00:00', NULL, 2207004, NULL, NULL, '2026-01-02', 'Friday', 'Hari kerja biasa', 0, 0, 1),
  (175, '2024-01-01 00:00:00', NULL, 2207004, NULL, NULL, '2026-01-03', 'Saturday', 'Hari libur akhir pekan', 0, 0, 1),
  (176, '2024-01-01 00:00:00', NULL, 2207004, NULL, NULL, '2026-01-04', 'Sunday', 'Hari libur akhir pekan', 0, 0, 1),
  (177, '2024-01-01 00:00:00', NULL, 2207004, NULL, NULL, '2026-01-05', 'Monday', 'Hari kerja biasa', 0, 0, 1);

-- --------------------------------------------------------------------
-- Table structure for `call_daily_visit_all`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `call_daily_visit_all`;
CREATE TABLE `call_daily_visit_all` (
  `period` varchar(6) NOT NULL,
  `code_fsm` varchar(20) NOT NULL DEFAULT '',
  `code_asm` varchar(20) NOT NULL DEFAULT '',
  `structure_id` varchar(30) NOT NULL DEFAULT '',
  `position` varchar(5) NOT NULL DEFAULT '',
  `city` varchar(11) NOT NULL DEFAULT '',
  `user_id` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `customer_outlet_id` varchar(20) NOT NULL DEFAULT '',
  `customer_outlet_name` varchar(500) NOT NULL DEFAULT '',
  `specialist` varchar(200) NOT NULL DEFAULT '',
  `customer_position` varchar(100) NOT NULL DEFAULT '',
  `outlet_type_name` varchar(100) NOT NULL DEFAULT '',
  `class_outlet` varchar(30) NOT NULL DEFAULT '',
  `type_call` varchar(30) NOT NULL DEFAULT '',
  `out_of_city` varchar(2) NOT NULL DEFAULT '',
  `type_mcl` varchar(11) NOT NULL DEFAULT '',
  `priority` varchar(100) DEFAULT NULL,
  `cluster` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `T1` int DEFAULT NULL,
  `T2` int DEFAULT NULL,
  `T3` int DEFAULT NULL,
  `T4` int DEFAULT NULL,
  `T5` int DEFAULT NULL,
  `T6` int DEFAULT NULL,
  `T7` int DEFAULT NULL,
  `T8` int DEFAULT NULL,
  `T9` int DEFAULT NULL,
  `T10` int DEFAULT NULL,
  `T11` int DEFAULT NULL,
  `T12` int DEFAULT NULL,
  `T13` int DEFAULT NULL,
  `T14` int DEFAULT NULL,
  `T15` int DEFAULT NULL,
  `T16` int DEFAULT NULL,
  `T17` int DEFAULT NULL,
  `T18` int DEFAULT NULL,
  `T19` int DEFAULT NULL,
  `T20` int DEFAULT NULL,
  `T21` int DEFAULT NULL,
  `T22` int DEFAULT NULL,
  `T23` int DEFAULT NULL,
  `T24` int DEFAULT NULL,
  `T25` int DEFAULT NULL,
  `T26` int DEFAULT NULL,
  `T27` int DEFAULT NULL,
  `T28` int DEFAULT NULL,
  `T29` int DEFAULT NULL,
  `T30` int DEFAULT NULL,
  `T31` int DEFAULT NULL,
  `total_visits` int DEFAULT NULL,
  `S` double DEFAULT NULL,
  `N_MIN1` int DEFAULT NULL,
  `S_MIN1` double DEFAULT NULL,
  `N_MIN2` int DEFAULT NULL,
  `S_MIN2` double DEFAULT NULL,
  `N_MIN3` int DEFAULT NULL,
  `S_MIN3` double DEFAULT NULL,
  `amortization` varchar(50) DEFAULT '',
  PRIMARY KEY (`period`,`structure_id`,`customer_outlet_id`,`type_call`),
  KEY `idx_call_daily_visit_all_structure_id` (`structure_id`),
  KEY `idx_call_daily_visit_all_customer_outlet_id` (`customer_outlet_id`),
  KEY `idx_call_daily_visit_all_period_customer_outlet_id` (`period`,`customer_outlet_id`),
  KEY `idx_call_daily_visit_all_period_type_call` (`period`,`type_call`),
  KEY `idx_call_daily_period_structid_desc` (`period`,`structure_id` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `call_daily_visit_all` (5 rows)
INSERT INTO `call_daily_visit_all` (`period`, `code_fsm`, `code_asm`, `structure_id`, `position`, `city`, `user_id`, `name`, `customer_outlet_id`, `customer_outlet_name`, `specialist`, `customer_position`, `outlet_type_name`, `class_outlet`, `type_call`, `out_of_city`, `type_mcl`, `priority`, `cluster`, `T1`, `T2`, `T3`, `T4`, `T5`, `T6`, `T7`, `T8`, `T9`, `T10`, `T11`, `T12`, `T13`, `T14`, `T15`, `T16`, `T17`, `T18`, `T19`, `T20`, `T21`, `T22`, `T23`, `T24`, `T25`, `T26`, `T27`, `T28`, `T29`, `T30`, `T31`, `total_visits`, `S`, `N_MIN1`, `S_MIN1`, `N_MIN2`, `S_MIN2`, `N_MIN3`, `S_MIN3`, `amortization`) VALUES
  ('202504', 'R1.5', 'BDGA1', 'BDGA1', 'ASM', '', '1220776', 'BENNY SUSANTO', '', '', '', '', '', '', 'CUSTOMER', 'DK', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0'),
  ('202504', 'R1.5', 'BDGA1', 'BDGA1', 'ASM', '', '1220776', 'BENNY SUSANTO', '', '', '', '', '', '', 'OUTLET', 'DK', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0'),
  ('202504', 'R1.5', 'BDGA1', 'BDGA1S1', 'SPV', '', '1220795', 'GINGGANG', '', '', '', '', '', '', 'CUSTOMER', 'DK', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0'),
  ('202504', 'R1.5', 'BDGA1', 'BDGA1S1', 'SPV', '', '1220795', 'GINGGANG', '', '', '', '', '', '', 'OUTLET', 'DK', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0'),
  ('202504', 'R1.5', 'BDGA1', 'BDGA1S102', 'MR', 'KECIL', '1220695', 'ITA HARTATI', '', '', '', '', '', '', 'CUSTOMER', 'DK', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');

-- --------------------------------------------------------------------
-- Table structure for `call_details`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `call_details`;
CREATE TABLE `call_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `period` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `user_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `user_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `position` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `area` varchar(7) DEFAULT '',
  `customer_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `out_of_city` varchar(2) DEFAULT '',
  `type_mcl` varchar(11) DEFAULT '',
  `type_call` varchar(30) DEFAULT '',
  `status` varchar(30) DEFAULT '',
  `spc` longtext,
  `customer_name` varchar(500) DEFAULT '',
  `schedule_datetime` datetime DEFAULT NULL,
  `checkin_time` datetime DEFAULT NULL,
  `checkout_time` datetime DEFAULT NULL,
  `morning` tinyint(1) DEFAULT '0',
  `evening` tinyint(1) DEFAULT '0',
  `durasi_on` time DEFAULT NULL,
  `visit_id` bigint DEFAULT NULL,
  `join_visit` varchar(2) DEFAULT '',
  `product_id` varchar(30) DEFAULT '',
  `product_name` varchar(100) DEFAULT '',
  `note_detailing_product` varchar(500) DEFAULT '',
  `location_id` varchar(20) DEFAULT '',
  `location_name` varchar(500) DEFAULT '',
  `location_address` longtext,
  `location_latitude` double DEFAULT NULL,
  `location_longitude` double DEFAULT NULL,
  `check_in_latitude` double DEFAULT NULL,
  `check_out_latitude` double DEFAULT NULL,
  `check_in_longitude` double DEFAULT NULL,
  `check_out_longitude` double DEFAULT NULL,
  `check_in_radius` double DEFAULT NULL,
  `check_out_radius` double DEFAULT NULL,
  `approved_structure_id` varchar(30) DEFAULT '',
  `approved_time` datetime DEFAULT NULL,
  `approved_note` varchar(500) DEFAULT '',
  `proof_photo` varchar(200) DEFAULT '',
  `proof_signature` varchar(200) DEFAULT '',
  `note_visit` varchar(500) DEFAULT '',
  `priority` varchar(100) DEFAULT NULL,
  `cluster` varchar(50) DEFAULT NULL,
  `amortization` varchar(50) DEFAULT '',
  `deleted_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_call_detail_structure_id` (`structure_id`),
  KEY `idx_call_detail_customer_id` (`customer_id`),
  KEY `idx_call_detail_location_id` (`location_id`),
  KEY `idx_call_detail_period_structure_id` (`period`,`structure_id`),
  KEY `idx_call_detail_period_customer_id` (`period`,`customer_id`),
  KEY `idx_call_detail_period_type_call` (`period`,`type_call`),
  KEY `idx_call_details_period_struct_del` (`period`,`structure_id`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7477478 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `call_details` (5 rows)
INSERT INTO `call_details` (`id`, `period`, `user_id`, `user_name`, `structure_id`, `position`, `area`, `customer_id`, `out_of_city`, `type_mcl`, `type_call`, `status`, `spc`, `customer_name`, `schedule_datetime`, `checkin_time`, `checkout_time`, `morning`, `evening`, `durasi_on`, `visit_id`, `join_visit`, `product_id`, `product_name`, `note_detailing_product`, `location_id`, `location_name`, `location_address`, `location_latitude`, `location_longitude`, `check_in_latitude`, `check_out_latitude`, `check_in_longitude`, `check_out_longitude`, `check_in_radius`, `check_out_radius`, `approved_structure_id`, `approved_time`, `approved_note`, `proof_photo`, `proof_signature`, `note_visit`, `priority`, `cluster`, `amortization`, `deleted_at`) VALUES
  (1, '202505', '2207004', 'Umar Maruf Mutaqin', 'JAPA1S101', 'MR', '', 'JOG17-1201', 'DK', '', 'call', 'plan-approved', '["SP.BS - SPESIALIS BEDAH SARAF","USER"]', 'TOMMY JACK NUMBERI', '2025-05-28 07:11:00', NULL, NULL, 1, 0, NULL, 1168432, '', '', NULL, NULL, 'NON', 'NON LOCATION', 'Jalan Raya Kebayoran Lama, RW 01, Grogol Selatan, Kebayoran Lama, Jakarta Selatan, Daerah Khusus Ibukota Jakarta, Jawa, 12220, Indonesia', -6.235642709021006, 106.7807562276721, 0.0, 0.0, 0.0, 0.0, NULL, NULL, 'JAPA1S1', '2025-08-05 07:28:57', NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL),
  (2, '202506', 'DPKA1S3', '', 'DPKA1S3', 'SPV', 'BGRA1', 'DPK19-0020', 'DK', 'MCL-BAWAHAN', NULL, 'plan-approved', '["SP.OG - SPESIALIS OBSTETRI & GINEKOLOGI (KEBIDANAN DAN KANDUNGAN)","USER"]', 'Afra Fonda Y Tangdiala', '2025-06-01 07:00:00', NULL, NULL, NULL, NULL, NULL, 1157876, 'JV', '', '', '', '', '', '', NULL, NULL, 0.0, 0.0, 0.0, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL),
  (3, '202507', '1190404', 'Rudli Asnaim', 'BKSA1S201', 'MR', 'BKSA1', 'BEK23-0040', 'DK', 'MCL', 'OUTLET', 'realization-approved', '["SP.S - SPESIALIS SARAF","USER"]', 'Gusti Ayu Putu Yunihati', '2025-07-24 04:50:00', '2025-07-24 04:26:59', '2025-07-24 04:46:27', 0, 1, '0:19:28', 1166716, '', 'ANTEN1I1', 'Antiten-A 0.4 ml Injeksi', 'detailing produk ', 'BEK160821', 'BEK-MITRA KELUARGA BEKASI TIMUR (PROTEINDO KARYA SEHAT), RS', 'JL. PENGASINAN, MARGAHAYU', -6.260463746045718, 107.01283670961857, -6.260361096815902, -6.260361096815902, 107.0128058642149, 107.0128058642149, 12.0, 12.0, 'CKRA1S1', '2025-07-24 08:49:58', NULL, NULL, 'proof-signature-824687756472.png', 'upselling xepazym ', NULL, NULL, '0', NULL),
  (4, '202506', 'JKTA3S101', '', 'JKTA3S101', 'MR', 'JKTA3', 'DKI22-0179', 'DK', 'MCL', NULL, 'plan-approved', '["SP.PD - SPESIALIS PENYAKIT DALAM","USER"]', 'Gerald  Abraham Harianja', '2025-05-31 17:00:00', NULL, NULL, NULL, NULL, NULL, 1157974, '', '', '', '', '', '', '', NULL, NULL, 0.0, 0.0, 0.0, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL),
  (5, '202505', '2207004', 'Umar Maruf Mutaqin', 'JAPA1S101', 'MR', '', 'JOG17-1201', 'DK', '', 'call', 'plan-rejected', '["SP.BS - SPESIALIS BEDAH SARAF","USER"]', 'TOMMY JACK NUMBERI', '2025-05-28 07:11:00', NULL, NULL, 1, 0, NULL, 1168496, '', '', NULL, NULL, 'NON', 'NON LOCATION', 'Jalan Raya Kebayoran Lama, RW 01, Grogol Selatan, Kebayoran Lama, Jakarta Selatan, Daerah Khusus Ibukota Jakarta, Jawa, 12220, Indonesia', -6.235642709021006, 106.7807562276721, 0.0, 0.0, 0.0, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'm', NULL, NULL, '0', NULL);

-- --------------------------------------------------------------------
-- Table structure for `call_targets`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `call_targets`;
CREATE TABLE `call_targets` (
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `structure_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `level` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `target` bigint DEFAULT NULL,
  PRIMARY KEY (`structure_id`,`period`),
  KEY `idx_structures_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `call_targets` (5 rows)
INSERT INTO `call_targets` (`created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `structure_id`, `structure_name`, `level`, `type`, `period`, `target`) VALUES
  (NULL, NULL, NULL, NULL, NULL, NULL, 'AMP', 'AMP(SALES-IN PDU AMP)', 'MR', 'REGULAR', '202405', 10),
  ('2024-06-21 07:09:18.338000', '2024-06-21 07:09:18.338000', NULL, 0, 0, 0, 'AMP', 'AMP(SALES-IN PDU AMP)', 'MR', 'REGULAR', '202406', 10),
  ('2024-07-17 08:01:26.819000', '2024-07-17 08:01:26.819000', NULL, 0, 0, 0, 'AMP', 'AMP(SALES-IN PDU AMP)', 'MR', 'REGULAR', '202407', 10),
  ('2024-07-17 08:01:26.819000', '2024-07-17 08:01:26.819000', NULL, 0, 0, 0, 'AMP', 'AMP(SALES-IN PDU AMP)', 'MR', 'REGULAR', '202410', 10),
  ('2024-07-17 08:01:26.819000', '2024-07-17 08:01:26.819000', NULL, 0, 0, 0, 'AMP', 'AMP(SALES-IN PDU AMP)', 'MR', 'REGULAR', '202411', 10);

-- --------------------------------------------------------------------
-- Table structure for `categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `category_code` varchar(20) NOT NULL,
  `name` longtext,
  PRIMARY KEY (`id`),
  KEY `idx_categories_deleted_at` (`deleted_at`),
  KEY `fk_categories_created_by` (`created_by_id`),
  KEY `fk_categories_updated_by` (`updated_by_id`),
  CONSTRAINT `fk_categories_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_categories_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------------------
-- Table structure for `companies`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `mandatory_survey` tinyint(1) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_companies_name` (`name`),
  KEY `idx_companies_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=60005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `companies` (3 rows)
INSERT INTO `companies` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `address`, `mandatory_survey`, `url`) VALUES
  (1, '2023-06-23 11:44:05', '2023-06-23 11:44:07', NULL, 15010001, 15010001, NULL, 'PT. Metiska Farma', 'Jalan Kebayoran Lama No.557', NULL, 'https://ski-compliance-metiska-farma-api.flexurio.com'),
  (2, '2023-07-24 09:14:08', '2023-07-24 09:14:10', NULL, 15010001, 15010001, NULL, 'PT. TEGUHSINDO LESTARITAMA', 'Jl. Pd. Kelapa Raya, RT.1/RW.2, Pd. Kopi, Kec. Duren Sawit, Kota Jakarta Timur', NULL, NULL),
  (3, '2024-10-31 03:38:33.642000', '2024-10-31 03:38:33.642000', NULL, NULL, NULL, NULL, 'PUBLIC', NULL, NULL, NULL);

-- --------------------------------------------------------------------
-- Table structure for `company_rules`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `company_rules`;
CREATE TABLE `company_rules` (
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `value_min` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `value_max` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `rule_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`,`rule_id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `company_rules` (5 rows)
INSERT INTO `company_rules` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `value_min`, `value_max`, `rule_id`, `company_id`) VALUES
  (NULL, NULL, NULL, NULL, NULL, NULL, 'call_dk_mr', '10', '999', 'count_call_dk_mr', '1'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'call_dk_spv', '6', '999', 'count_call_dk_spv', '1'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'call_dk_spv_mandiri', '10', '999', 'count_call_dk_spv_mandiri', '1'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'call_lk_mr', '10', '999', 'count_call_lk_mr', '1'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'call_pribadi_asm', '5', '999', 'count_call_pribadi_asm', '1');

-- --------------------------------------------------------------------
-- Table structure for `configs`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `configs`;
CREATE TABLE `configs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `period_start` varchar(8) DEFAULT NULL,
  `period_end` varchar(8) DEFAULT NULL,
  `level` bigint unsigned DEFAULT NULL,
  `x_lte` bigint unsigned DEFAULT NULL,
  `x_gte` bigint unsigned DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `note` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_configs` (`name`,`period_start`,`period_end`,`level`),
  KEY `idx_configs_company_deleted_at` (`company_id`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `configs` (5 rows)
INSERT INTO `configs` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `name`, `period_start`, `period_end`, `level`, `x_lte`, `x_gte`, `company_id`, `note`) VALUES
  (1, 1240917, '2024-07-26 03:18:26.984000', 1240917, '2024-07-26 07:45:24.200000', NULL, NULL, 'REGULATION MIN MAX CALL PLAN', '20240701', '20300702', 1, 0, 15, 1, 'Regulasi jumlah pembuatan call plan minimal dan maksimal beda hari'),
  (3, 1240917, '2024-07-26 03:18:26.984000', 1240917, '2024-07-26 07:45:24.200000', NULL, NULL, 'REGULATION MCL CREATE', '20240701', '20300702', 1, 0, 90, 1, 'Regulasi pembuatan MCL maksimal 21 di hari yang sama'),
  (4, 1240917, '2024-07-26 03:18:26.984000', 1240917, '2024-07-26 07:45:24.200000', NULL, NULL, 'REGULATION FIND CUSTOMER CALL', '20240701', '20300702', 1, 1, 1, 1, 'Regulasi sumber data call customer dari MCL atau populasi, x_lte ( true 1) x_lte ( 1 true )'),
  (5, 1240917, '2024-07-26 03:18:26.984000', 1240917, '2024-07-26 07:45:24.200000', NULL, NULL, 'REGULATION CALL PLAN EDIT STATUS PLAN DRAFT', '20240701', '20300702', 0, 1, 1, 1, 'Regulasi edit call plan yang statusnya draft, xlte ( location), x_gte (schedule_time)'),
  (6, 1240917, '2024-07-26 03:18:26.984000', 1240917, '2024-07-26 07:45:24.200000', NULL, NULL, 'REGULATION CALL PLAN EDIT STATUS PLAN APPROVE', '20240701', '20300702', 0, 1, 0, 1, 'Regulasi edit call plan yang statusnya approve, xlte ( location true), x_gte (schedule_time false)');

-- --------------------------------------------------------------------
-- Table structure for `confirmation_statuses`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `confirmation_statuses`;
CREATE TABLE `confirmation_statuses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `menu` varchar(200) NOT NULL,
  `status` varchar(100) NOT NULL,
  `step` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`,`menu`,`status`),
  UNIQUE KEY `idx_configs` (`menu`,`status`,`step`),
  KEY `idx_confirmation_statuses_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `confirmation_statuses` (5 rows)
INSERT INTO `confirmation_statuses` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `menu`, `status`, `step`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, 'call', 'draft', 1),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, 'call', 'plan-approved', 2),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, 'area', 'draft', 1),
  (5, NULL, NULL, NULL, NULL, NULL, NULL, 'area', 'confirm 1', 2),
  (7, NULL, NULL, NULL, NULL, NULL, NULL, 'customer-visit', 'draft', 1);

-- --------------------------------------------------------------------
-- Table structure for `customer_addresses`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_addresses`;
CREATE TABLE `customer_addresses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `customer_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `flag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `location_name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `location_address` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_location` (`latitude`,`longitude`),
  KEY `idx_customer_flag` (`customer_id`,`flag`,`deleted_at`) USING BTREE,
  KEY `idx_customer_deleted_at` (`customer_id`,`deleted_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_addresses` (5 rows)
INSERT INTO `customer_addresses` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `customer_id`, `flag`, `location_name`, `location_address`, `latitude`, `longitude`, `is_active`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, '23070029', 'rumah', 'PT. Vneu Teknologi Indonesia', 'Jl. Raya Kby. Lama No.557 C 6, RT.6/RW.1, Grogol Sel., Kec. Kebayoran Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12220', -6.2354184, 106.7780075, NULL),
  (3, '2026-08-05 03:30:04.539000', '2026-08-05 03:30:04.539000', NULL, 1251051, 1251051, NULL, 'CRB17-0511', 'praktek', 'Rumah Sakit Jasa Kartini', 'Jl. Otto Iskandardinata No.15, Empangsari, Kec. Tawang, Kab. Tasikmalaya, Jawa Barat 46131, Indonesia', -7.326248499999999, 108.2227604, 1),
  (4, '2026-08-05 03:30:46.581000', '2026-08-05 03:30:46.581000', NULL, 1251051, 1251051, NULL, 'CRB19-0029', 'praktek', 'Rumah Sakit Jasa Kartini', 'Jl. Otto Iskandardinata No.15, Empangsari, Kec. Tawang, Kab. Tasikmalaya, Jawa Barat 46131, Indonesia', -7.326248499999999, 108.2227604, 1),
  (5, '2026-08-05 03:51:49.813000', '2026-08-05 03:51:49.813000', NULL, 1151752, 1151752, NULL, '25080434', 'praktek', 'RSUD dr. Mohamad Saleh', 'Jl. D.I. Panjaitan No.65, Sukabumi, Kec. Mayangan, Kota Probolinggo, Jawa Timur 67219, Indonesia', -7.745126000000001, 113.2105756, 1),
  (6, '2026-08-05 04:01:46.962000', '2026-08-05 04:01:46.962000', NULL, 1151752, 1151752, NULL, 'PRB20-0016', 'praktek', 'RSUD dr. Mohamad Saleh', 'Jl. D.I. Panjaitan No.65, Sukabumi, Kec. Mayangan, Kota Probolinggo, Jawa Timur 67219, Indonesia', -7.745126000000001, 113.2105756, 1);

-- --------------------------------------------------------------------
-- Table structure for `customer_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_categories`;
CREATE TABLE `customer_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  `group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_survey` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_customer_categories_id` (`id`) USING BTREE,
  UNIQUE KEY `idx_customer_categorys` (`name`,`company_id`),
  KEY `idx_customer_categories_deleted_at` (`deleted_at`),
  KEY `idx_customer_categories_name` (`name`) USING BTREE,
  KEY `idx_customer_categories_company_id` (`company_id`) USING BTREE,
  KEY `idx_customer_categories_company_deleted` (`company_id`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=120004 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_categories` (5 rows)
INSERT INTO `customer_categories` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `company_id`, `group`, `code`, `is_survey`) VALUES
  (1, '2023-07-08 04:33:44.886000', '2023-07-08 04:33:44.886000', NULL, 1, 1, NULL, 'SP.M - SPESIALIS MATA', 1, NULL, NULL, NULL),
  (2, '2023-07-24 01:56:04.761000', '2023-07-24 01:56:04.761000', NULL, 8, 8, NULL, 'SP.JP - SPESIALIS JANTUNG & PEMBULUH DARAH', 1, NULL, NULL, NULL),
  (3, '2023-07-24 01:56:16.477000', '2023-07-24 01:56:16.477000', NULL, 8, 8, NULL, 'SP.P - SPESIALIS PARU (PULMONOLOGI)', 1, NULL, NULL, NULL),
  (4, '2023-07-24 01:56:19.626000', '2023-07-24 01:56:19.626000', NULL, 8, 8, NULL, 'SP.THT-KL - SPESIALIS TELINGA HIDUNG TENGGOROK-BEDAH KEPALA LEHER', 1, NULL, NULL, NULL),
  (5, '2023-07-24 01:56:22.470000', '2023-07-24 01:56:22.470000', NULL, 8, 8, NULL, 'SP.A - SPESIALIS ANAK', 1, NULL, NULL, NULL);

-- --------------------------------------------------------------------
-- Table structure for `customer_cluster_histories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_cluster_histories`;
CREATE TABLE `customer_cluster_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) NOT NULL,
  `customer_id` varchar(100) NOT NULL,
  `cluster` varchar(50) NOT NULL,
  `amortization` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_period` (`period`),
  KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21246 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_cluster_histories` (5 rows)
INSERT INTO `customer_cluster_histories` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `customer_id`, `cluster`, `amortization`) VALUES
  (5782, '2026-07-22 08:26:35.407000', '2026-07-22 08:26:35.407000', NULL, 1501001, 1501001, NULL, '202507', '23060014', 'Recapture A', ''),
  (5783, '2026-07-22 08:26:35.407000', '2026-07-22 08:26:35.407000', NULL, 1501001, 1501001, NULL, '202507', '23060044', 'Upsell C', ''),
  (5784, '2026-07-22 08:26:35.407000', '2026-07-22 08:26:35.407000', NULL, 1501001, 1501001, NULL, '202507', '23060052', 'Recapture A', ''),
  (5785, '2026-07-22 08:26:35.407000', '2026-07-22 08:26:35.407000', NULL, 1501001, 1501001, NULL, '202507', '23070033', 'Recapture A', ''),
  (5786, '2026-07-22 08:26:35.407000', '2026-07-22 08:26:35.407000', NULL, 1501001, 1501001, NULL, '202507', '23070060', 'Upsell C', '');

-- --------------------------------------------------------------------
-- Table structure for `customer_customer_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_customer_categories`;
CREATE TABLE `customer_customer_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `customer_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_category_id` bigint unsigned DEFAULT NULL,
  `customer_position_id` bigint unsigned DEFAULT NULL,
  `company_id` bigint NOT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_customer_customer_categories` (`customer_id`,`customer_category_id`,`company_id`),
  KEY `idx_customer_customer_categories_deleted_at` (`deleted_at`),
  KEY `fk_customer_categories_customer_customer_category` (`customer_category_id`),
  KEY `idx_customer_customer_categories_customer_id` (`customer_id`) USING BTREE,
  KEY `idx_customer_customer_categories_company_id` (`company_id`) USING BTREE,
  KEY `customer_position_id` (`customer_position_id`),
  KEY `idx_ccc_cust_cat_deleted` (`customer_id`,`customer_category_id`,`deleted_at`),
  CONSTRAINT `customer_customer_categories_ibfk_1` FOREIGN KEY (`customer_position_id`) REFERENCES `customer_categories` (`id`),
  CONSTRAINT `fk_customer_categories_customer_customer_category` FOREIGN KEY (`customer_category_id`) REFERENCES `customer_categories` (`id`),
  CONSTRAINT `fk_customer_customer_categories_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1002123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_customer_categories` (5 rows)
INSERT INTO `customer_customer_categories` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `customer_id`, `customer_category_id`, `customer_position_id`, `company_id`) VALUES
  (865333, '2026-05-12 16:22:35', '2026-05-12 16:22:35', NULL, NULL, NULL, NULL, '23060015', 43, 87, 1),
  (865335, '2026-05-12 16:22:35', '2026-05-12 16:22:35', NULL, NULL, NULL, NULL, '23060017', 40, 87, 1),
  (865336, '2026-05-12 16:22:35', '2026-05-12 16:22:35', NULL, NULL, NULL, NULL, '23060018', 77, 87, 1),
  (865337, '2026-05-12 16:22:35', '2026-05-12 16:22:35', NULL, NULL, NULL, NULL, '23060019', 68, 87, 1),
  (865338, '2026-05-12 16:22:35', '2026-05-12 16:22:35', NULL, NULL, NULL, NULL, '23060021', 6, 87, 1);

-- --------------------------------------------------------------------
-- Table structure for `customer_drafts`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_drafts`;
CREATE TABLE `customer_drafts` (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `gender` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  `customer_api` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `image_customer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `image_ktp` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ks` tinyint(1) DEFAULT NULL,
  `image_name_card` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `website` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `province` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `city` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `district` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sub_district` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `customer_id_by_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `specialist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `note` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------------------
-- Table structure for `customer_families`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_families`;
CREATE TABLE `customer_families` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `customer_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `relationship_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `date_of_birthday` datetime(3) DEFAULT NULL,
  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_customer_relationship_type` (`customer_id`,`relationship_type`) USING BTREE,
  KEY `idx_customer_deleted_at` (`customer_id`,`deleted_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_families` (5 rows)
INSERT INTO `customer_families` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `customer_id`, `relationship_type`, `name`, `date_of_birthday`, `gender`, `is_active`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, '23070029', 'ayah', 'Hartono', '2026-03-26 19:43:14', 'male', NULL),
  (4, '2026-04-01 04:46:54.349000', '2026-04-01 04:46:54.349000', NULL, 2207004, 2207004, NULL, 'MND17-0258', 'suami', 'Andrew', '1981-03-03 00:00:00', 'male', NULL),
  (5, '2026-04-01 04:46:54.357000', '2026-04-01 04:46:54.357000', NULL, 2207004, 2207004, NULL, 'MND17-0258', 'anak', 'Sude', '2020-03-03 00:00:00', 'male', NULL),
  (10, '2026-04-01 04:49:10.712000', '2026-04-01 04:49:10.712000', NULL, 2207004, 2207004, NULL, 'MND17-0258', 'suami', 'Andrew', NULL, 'male', NULL),
  (11, '2026-04-01 04:49:10.728000', '2026-04-01 04:49:10.728000', NULL, 2207004, 2207004, NULL, 'MND17-0258', 'anak', 'Sude', '2020-03-03 00:00:00', 'male', NULL);

-- --------------------------------------------------------------------
-- Table structure for `customer_locations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_locations`;
CREATE TABLE `customer_locations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `customer_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `start_period` varchar(191) DEFAULT NULL,
  `end_period` varchar(191) DEFAULT NULL,
  `best_hours` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `work_hours` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` varchar(191) DEFAULT NULL,
  `reject_reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` bigint NOT NULL,
  `user_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `customer_name` varchar(191) DEFAULT NULL,
  `customer_phone` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`id`,`customer_id`,`location_id`,`company_id`),
  KEY `idx_customer_locations_deleted_at` (`deleted_at`),
  KEY `fk_customer_locations_created_by` (`created_by_id`),
  KEY `fk_customer_locations_location` (`location_id`),
  KEY `idx_customer_locations_status` (`status`),
  KEY `idx_customer_locations_customer_name` (`customer_name`),
  KEY `idx_customer_locations_start_period` (`start_period`(10)) USING BTREE,
  KEY `idx_customer_locations_end_period` (`end_period`(10)) USING BTREE,
  KEY `idx_cl_company_status_location_period` (`company_id`,`status`,`location_id`,`start_period`,`end_period`),
  KEY `idx_cl_main` (`company_id`,`status`,`start_period`,`end_period`,`location_id`,`customer_id`),
  KEY `idx_cl_cust_status_period` (`customer_id`,`status`,`start_period`,`end_period`,`location_id`),
  KEY `idx_cl_cust_status_del_period` (`customer_id`,`status`,`deleted_at`,`start_period`,`end_period`,`location_id`),
  CONSTRAINT `fk_customer_locations_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_locations_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  CONSTRAINT `fk_customers_customer_location` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4145714 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_locations` (5 rows)
INSERT INTO `customer_locations` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `customer_id`, `start_period`, `end_period`, `best_hours`, `work_hours`, `status`, `reject_reason`, `location_id`, `company_id`, `user_name`, `location_name`, `location_address`, `customer_name`, `customer_phone`) VALUES
  (3848830, NULL, '2024-10-23 03:50:07.732000', NULL, NULL, 7000001, NULL, 'SRI17-0814', '201812', '999999', '', '', 'approve', '', 'BPN160210', 1, '', 'BPN-KIMIA FARMA SUMBER REJO, APT', 'JL. DI. PANJAITAN NO. 21 RT. 8', 'SUDIYANA HASYIM', ''),
  (3848831, NULL, '2025-11-11 08:58:30.044000', NULL, NULL, 1251095, NULL, 'BEK18-0019', '202201', '999999', '', '', 'approve', '', 'DKI172221', 1, '', 'DKI-RAWA LUMBU', 'JL.DASA DARMA KAV 20-23 RAWA LUMBU', 'AGNI BONENDASI GULTOM', '081367369639'),
  (3848832, NULL, '2024-10-18 07:59:44.939000', NULL, NULL, 1240917, NULL, 'DKI19-0366', '201901', '999999', '', '', 'approve', '', 'DKI180022', 1, '', 'DKI-WE CARE ( JAYA MANDIRI #DKI-SEL ), APT', 'JL. BUKIT HIJAU I NO.5 A, RT.1/RW.13, PD. PINANG, KBY. LAMA, KOTA JAKARTA SELATAN, DAERAH KHUSUS IBUKOTA JAKARTA 12310', 'ASEP SAEFUL ROHMAT', ''),
  (3848833, NULL, '2026-02-05 04:02:59.474000', NULL, NULL, 1230893, NULL, 'MES19-0014', '201901', '999999', '', '', 'approve', '', 'MES161003', 1, '', 'MES-K-24 HM.YAMIN, APT', 'JL. PROF. HM. YAMIN SH. NO.216 C RT/RW 00/00 SEI KERA HILIR II MEDAN PERJUANGAN MEDAN SUMATERA UTARA', 'Edward Muljadi', '08126402715'),
  (3848834, NULL, '2026-02-11 12:45:22.685000', NULL, NULL, 1251092, NULL, 'TKG21-0007', '202107', '999999', '', '', 'approve', '', 'TKG210033', 1, '', 'TKG-UWAIS, APT', 'JL HASANUDIN NO. 165 RT/RW 022/008, YOSOMULYO METRO PUSAT, KOTA METRO', 'Windi Pertiwi', '085658819670');

-- --------------------------------------------------------------------
-- Table structure for `customer_logs`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customer_logs`;
CREATE TABLE `customer_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `flag` varchar(30) DEFAULT NULL,
  `customer_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `log` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_customer_flag` (`user_id`,`customer_id`,`flag`)
) ENGINE=InnoDB AUTO_INCREMENT=23043 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customer_logs` (5 rows)
INSERT INTO `customer_logs` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `user_id`, `flag`, `customer_id`, `log`) VALUES
  (1, 0, '2026-04-02 06:49:54.451000', 2207004, '2026-04-02 06:49:23.046000', NULL, NULL, 2207004, 'CUSTOMER PROFILE', '24010147', 1),
  (2, 0, '2026-04-02 06:50:41.135000', 2207004, '2026-04-02 07:03:14.046000', NULL, NULL, 2207004, 'CUSTOMER LOCATION', '24010147', 2),
  (3, 0, '2026-04-02 06:53:57.159000', 2207004, '2026-04-02 07:04:34.278000', NULL, NULL, 2207004, 'CUSTOMER FAMILY', '24010147', 2),
  (4, 0, '2026-04-07 05:56:08.166000', 1251092, '2026-04-21 05:57:43.358000', NULL, NULL, 1251092, '', 'TKG17-0540', 4),
  (5, 0, '2026-04-07 05:59:54.330000', 1251061, '2026-04-07 05:59:54.293000', NULL, NULL, 1251061, '', '25090097', 1);

-- --------------------------------------------------------------------
-- Table structure for `customers`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `gender` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  `customer_api` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `image_customer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `image_ktp` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ks` tinyint(1) DEFAULT NULL,
  `image_name_card` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `website` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `province` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `city` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `district` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sub_district` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `customer_id_by_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `hobby` varchar(500) DEFAULT NULL,
  `date_of_birth` datetime(3) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `facebook` varchar(100) DEFAULT NULL,
  `x` varchar(100) DEFAULT NULL,
  `tiktok` varchar(100) DEFAULT NULL,
  `cluster` varchar(50) DEFAULT NULL,
  `amortization` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_customers_id` (`id`),
  UNIQUE KEY `idx_customers` (`id`,`name`,`phone`,`gender`,`company_id`),
  KEY `idx_customers_status` (`status`(191)) USING BTREE,
  KEY `idx_customers_phone` (`phone`) USING BTREE,
  KEY `idx_customers_name` (`name`) USING BTREE,
  KEY `idx_customers_gender` (`gender`) USING BTREE,
  KEY `idx_customers_email` (`email`) USING BTREE,
  KEY `idx_customers_customer_id_by_company` (`customer_id_by_company`) USING BTREE,
  KEY `idx_customers_company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `customers` (5 rows)
INSERT INTO `customers` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `name`, `phone`, `email`, `address`, `gender`, `company_id`, `customer_api`, `image_customer`, `image_ktp`, `ks`, `image_name_card`, `website`, `province`, `city`, `district`, `sub_district`, `customer_id_by_company`, `status`, `hobby`, `date_of_birth`, `instagram`, `facebook`, `x`, `tiktok`, `cluster`, `amortization`) VALUES
  (1251051, '2026-05-20 10:06:57.788000', 1251051, '2026-09-01 06:25:12.086000', NULL, NULL, '1779271617', 'Wahyu Ani Mukaromah', '', '', 'Jl. Mohamad Hatta No.155, RT.01/RW.020, Sukamanah, Kec. Cipedes, Kab. Tasikmalaya, Jawa Barat 46131', 'male', 1, '', '', '', 0, '', '', 'Jawa Barat', 'Kota Tasikmalaya', 'Tawang', 'Tawangsari', 'new', 'draft', '', NULL, '', '', '', '', NULL, ''),
  (0, '2023-06-20 07:37:40', 1090568, '2026-09-01 06:25:12.086000', NULL, NULL, '23060014', 'MUHAMMAD IQBAL SORBA DARMANIK', '+628111111111', '', '-', 'male', 1, '', '', '', 0, '', '', NULL, NULL, NULL, NULL, '23060014', 'approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''),
  (NULL, '2023-06-20 07:45:56', 1182178, '2026-09-01 06:25:12.086000', NULL, NULL, '23060015', 'LUTHFI MAHFUZH', '+628111111111', 'luthfi@gmail.com', 'DUSUN IV A-PALEM KENCANA BLOK-XM NO.16 RT/RW 015/008 KEL.MULIO REJO KEC. SUNGGAL', 'male', 1, '', '', '', 0, '', '', '', '', '', '', '23060015', 'approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''),
  (NULL, '2023-06-20 07:53:43', 1261153, '2026-09-01 06:25:12.086000', NULL, NULL, '23060016', 'Barlian Rahmat Parulian Sitompul', '628179169032', 'barlian@gmail.com', '-', 'male', 1, '', '', '', 1, '', '', 'Banten', 'Kota Serang', 'Serang', 'Cipare', '23060016', 'approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''),
  (NULL, '2023-06-20 08:29:15', 1240969, '2026-09-01 06:25:12.086000', NULL, NULL, '23060017', 'David Ralph Lienhardt Ringoringo', '622153424447', 'davidralph@gmail.com', '-', 'male', 1, '', '', '', 1, '', '', 'Kalimantan Selatan', 'Kota Banjarbaru', 'Banjarbaru Selatan', 'Laktabat Selatan', '23060017', 'approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');

-- --------------------------------------------------------------------
-- Table structure for `departments`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `email` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by_id` int DEFAULT NULL,
  `closed_by_id` int DEFAULT NULL,
  `updated_by_id` int DEFAULT NULL,
  `deleted_by_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------------------
-- Table structure for `distributors`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `distributors`;
CREATE TABLE `distributors` (
  `created_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `state` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `website` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `notes` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `distributors` (5 rows)
INSERT INTO `distributors` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `company_id`, `name`, `phone`, `email`, `address`, `city`, `state`, `zip_code`, `website`, `notes`) VALUES
  (NULL, '2023-09-07 18:42:29.090000', NULL, '2023-09-07 18:42:29.090000', NULL, NULL, 'AMS', '2', 'AMS', NULL, NULL, '-', NULL, NULL, NULL, NULL, NULL),
  (NULL, '2023-09-07 18:42:29.090000', NULL, '2023-09-07 18:42:29.090000', NULL, NULL, 'CMA', '2', 'CV. MITRA ABADI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
  (NULL, '2023-09-07 18:42:29.090000', NULL, '2023-09-07 18:42:29.090000', NULL, NULL, 'COMBI', '1', 'PT. COMBI PUTRA', NULL, NULL, '-', NULL, NULL, NULL, NULL, NULL),
  (NULL, '2023-09-07 18:42:29.090000', NULL, '2023-09-07 18:42:29.090000', NULL, NULL, 'DAD', '1', 'PT. DAYA ANUGERAH DEWATASAKTI', NULL, NULL, '-', NULL, NULL, NULL, NULL, NULL),
  (NULL, '2023-09-07 18:42:29.090000', NULL, '2023-09-07 18:42:29.090000', NULL, NULL, 'DM', '2', 'DIGITAL MARKETING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------------------
-- Table structure for `html_services`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `html_services`;
CREATE TABLE `html_services` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) DEFAULT NULL,
  `structure_id` varchar(30) DEFAULT NULL,
  `flag` varchar(50) DEFAULT NULL,
  `indicator` varchar(50) DEFAULT NULL,
  `html` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_html_services_unique` (`user_id`,`period`,`flag`,`indicator`) USING BTREE,
  KEY `idx_html_service` (`period`,`user_id`,`flag`) USING BTREE,
  KEY `idx_html_services_indicator_user` (`indicator`,`user_id`,`period`),
  KEY `idx_html_services_flag` (`flag`)
) ENGINE=InnoDB AUTO_INCREMENT=1584979 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `html_services` (5 rows)
INSERT INTO `html_services` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `user_id`, `period`, `structure_id`, `flag`, `indicator`, `html`) VALUES
  (63490, 0, '2026-08-05 02:13:11.813000', 0, '2026-08-05 02:13:11.813000', NULL, NULL, 1261155, '202608', 'MLGA1S303', 'CUSTOMER LOCATION', 'SUB17-0737', '<!DOCTYPE html>
<html lang="id">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Informasi Lokasi Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
    rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      -webkit-tap-highlight-color: transparent
    }

    body {
      min-height: 100vh;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      background: #f0f7ff;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px 60px;
      position: relative;
      overflow-x: hidden
    }

    .bg {
      position: fixed;
      inset: 0;
      z-index: 0;
      pointer-events: none
    }

    .b1 {
      position: absolute;
      width: 500px;
      height: 500px;
      top: -15%;
      left: -10%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #bae6fd, #e0f2fe)
    }

    .b2 {
      position: absolute;
      width: 450px;
      height: 450px;
      bottom: -10%;
      right: -8%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #c7d2fe, #ddd6fe)
    }

    .b3 {
      position: absolute;
      width: 350px;
      height: 350px;
      top: 40%;
      left: 35%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .35;
      background: radial-gradient(circle, #a7f3d0, #d1fae5)
    }

    .card {
      position: relative;
      z-index: 1;
      background: rgba(255, 255, 255, .62);
      backdrop-filter: blur(24px);
      border: 1.5px solid rgba(255, 255, 255, .92);
      border-radius: 28px;
      padding: 36px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(15, 23, 42, .09), 0 4px 16px rgba(15, 23, 42, .05)
    }

    .head {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 24px
    }

    .head-icon {
      width: 44px;
      height: 44px;
      border-radius: 13px;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 14px rgba(6, 182, 212, .35);
      flex-shrink: 0
    }

    .head-txt h2 {
      font-size: 16px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -.3px
    }

    .head-txt p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px
    }

    .prog-bar {
      height: 4px;
      background: rgba(15, 23, 42, .07);
      border-radius: 99px;
      overflow: hidden;
      margin-bottom: 6px
    }

    .prog-fill {
      height: 100%;
      border-radius: 99px;
      background: linear-gradient(90deg, #06b6d4, #3b82f6);
      width: 0%;
      transition: width .35s ease
    }

    .prog-label {
      display: flex;
      justify-content: space-between;
      font-size: 10px;
      color: #94a3b8;
      font-weight: 600;
      margin-bottom: 24px
    }

    .sec-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
      margin-top: 4px
    }

    .sec-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .8px;
      text-transform: uppercase
    }

    .sec-title::before {
      content: '''';
      width: 20px;
      height: 1px;
      background: rgba(148, 163, 184, .25)
    }

    .add-btn {
      display: flex;
      align-items: center;
      gap: 5px;
      background: linear-gradient(135deg, rgba(6, 182, 212, .1), rgba(59, 130, 246, .08));
      border: 1.5px solid rgba(6, 182, 212, .25);
      border-radius: 8px;
      padding: 5px 10px;
      font-size: 10px;
      font-weight: 700;
      color: #0891b2;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .add-btn:hover {
      background: linear-gradient(135deg, rgba(6, 182, 212, .18), rgba(59, 130, 246, .14))
    }

    .fields {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 24px
    }

    .entry-list {
      display: flex;
      flex-direction: column;
      gap: 10px
    }

    .entry {
      background: rgba(248, 250, 252, .6);
      border: 1.5px solid rgba(226, 232, 240, .8);
      border-radius: 14px;
      padding: 14px;
      transition: border-color .18s
    }

    .entry:focus-within {
      border-color: rgba(6, 182, 212, .3);
      background: rgba(255, 255, 255, .8)
    }

    /* Header & Toggle Actions */
    .entry-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
      user-select: none;
    }

    .entry-num {
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .5px;
      text-transform: uppercase;
      transition: color .2s;
    }

    .actions-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .entry-del {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(220, 38, 38, .08);
      border: 1px solid rgba(220, 38, 38, .15);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      color: #dc2626;
      opacity: .6;
      transition: opacity .15s;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      line-height: 1
    }

    .entry-del:hover {
      opacity: 1
    }

    .entry-toggle {
      width: 24px;
      height: 24px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      border: 1px solid rgba(6, 182, 212, .2);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #0891b2;
      transition: background .15s;
    }

    .entry-toggle:hover {
      background: rgba(6, 182, 212, .2);
    }

    .entry-toggle svg {
      transition: transform .3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .entry.is-collapsed .entry-toggle svg {
      transform: rotate(180deg);
    }

    /* Content Body */
    .entry-inner {
      display: flex;
      flex-direction: column;
      gap: 8px
    }

    .entry.is-collapsed .entry-inner {
      display: none !important;
    }

    .entry.is-collapsed .entry-head {
      margin-bottom: 0;
    }

    /* State Disabled (Data dari Database) */
    .entry.is-disabled {
      background: rgba(241, 245, 249, 0.7);
      border-color: rgba(203, 213, 225, 0.5);
      opacity: 0.9;
    }

    .entry.is-disabled .entry-inner {
      pointer-events: none;
      /* Mematikan klik form */
    }

    .entry.is-disabled .sf-inp,
    .entry.is-disabled .entry-ta {
      background: transparent;
      box-shadow: none;
      border-color: rgba(226, 232, 240, 0.6);
      color: #64748b;
      font-weight: 600;
    }

    .entry.is-disabled .sf-clr,
    .entry.is-disabled .chip-x {
      display: none !important;
    }

    /* ------------------------------------- */

    .sf-wrap {
      position: relative
    }

    .sf-ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .sf-inp {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 32px 10px 34px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s
    }

    .sf-inp::placeholder {
      color: #94a3b8
    }

    .sf-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    /* Switch Toggle Styles */
    .switch-wrap {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 14px;
      background: rgba(255, 255, 255, .4);
      border: 1px solid rgba(226, 232, 240, .8);
      border-radius: 12px;
      margin-top: 5px
    }

    .switch-lbl {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      display: flex;
      align-items: center;
      gap: 6px
    }

    .switch {
      position: relative;
      display: inline-block;
      width: 38px;
      height: 22px
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #cbd5e1;
      transition: .3s;
      border-radius: 22px
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 2px;
      bottom: 2px;
      background-color: white;
      transition: .3s;
      border-radius: 50%;
      box-shadow: 0 2px 4px rgba(0, 0, 0, .1)
    }

    input:checked+.slider {
      background: linear-gradient(135deg, #06b6d4, #3b82f6)
    }

    input:checked+.slider:before {
      transform: translateX(16px)
    }

    .sf-clr {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      border-radius: 5px;
      background: rgba(148, 163, 184, .12);
      border: none;
      cursor: pointer;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: #94a3b8;
      z-index: 1;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .sf-clr.show {
      display: flex
    }

    .sf-drop {
      position: absolute;
      top: calc(100% + 4px);
      left: 0;
      right: 0;
      background: #fff;
      border: 1.5px solid rgba(6, 182, 212, .2);
      border-radius: 10px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, .12);
      z-index: 600;
      max-height: 200px;
      overflow-y: auto;
      display: none
    }

    .sf-drop.open {
      display: block
    }

    .sf-drop::-webkit-scrollbar {
      width: 3px
    }

    .sf-drop::-webkit-scrollbar-thumb {
      background: rgba(148, 163, 184, .3);
      border-radius: 99px
    }

    .sf-opt {
      display: flex;
      align-items: flex-start;
      gap: 8px;
      padding: 10px 12px;
      cursor: pointer;
      border-bottom: 1px solid rgba(226, 232, 240, .3);
      transition: background .1s;
      font-size: 12px
    }

    .sf-opt:last-child {
      border-bottom: none
    }

    .sf-opt:hover {
      background: rgba(6, 182, 212, .06)
    }

    .sf-opt-pin {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-top: 1px
    }

    .sf-opt-txt {
      flex: 1;
      min-width: 0
    }

    .sf-opt-name {
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis
    }

    .sf-opt-addr {
      font-size: 10px;
      color: #64748b;
      margin-top: 1px;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden
    }

    .sf-msg {
      padding: 12px;
      text-align: center;
      font-size: 11px;
      color: #94a3b8
    }

    .entry-chip {
      display: none;
      align-items: center;
      gap: 7px;
      background: rgba(6, 182, 212, .06);
      border: 1px solid rgba(6, 182, 212, .2);
      border-radius: 8px;
      padding: 7px 10px
    }

    .entry-chip.show {
      display: flex
    }

    .chip-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      flex-shrink: 0
    }

    .chip-name {
      flex: 1;
      font-size: 11px;
      font-weight: 600;
      color: #0891b2;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap
    }

    .chip-coord {
      font-size: 10px;
      color: #64748b;
      white-space: nowrap;
      flex-shrink: 0
    }

    .chip-x {
      width: 18px;
      height: 18px;
      border-radius: 4px;
      background: rgba(8, 145, 178, .1);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      color: #0891b2;
      flex-shrink: 0;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .entry-ta {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      resize: none;
      line-height: 1.6;
      min-height: 60px
    }

    .entry-ta::placeholder {
      color: #94a3b8
    }

    .entry-ta:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px
    }

    .lbl-sm {
      font-size: 9.5px;
      font-weight: 700;
      color: #475569;
      letter-spacing: .4px;
      text-transform: uppercase;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px
    }

    .badge {
      font-size: 9px;
      padding: 1px 6px;
      border-radius: 4px;
      font-weight: 600;
      text-transform: none;
      letter-spacing: 0;
      background: rgba(224, 242, 254, .7);
      color: #0891b2;
      border: 1px solid rgba(8, 145, 178, .2)
    }

    .inp-wrap {
      position: relative
    }

    .inp-wrap .ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .coord-inp {
      width: 100%;
      background: rgba(248, 250, 252, .85);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px 10px 32px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      appearance: none;
      -webkit-appearance: none
    }

    .coord-inp::placeholder {
      color: #94a3b8
    }

    .coord-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-inp::-webkit-inner-spin-button,
    .coord-inp::-webkit-outer-spin-button {
      -webkit-appearance: none
    }

    .map-sec-label {
      font-size: 9.5px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .6px;
      text-transform: uppercase;
      margin-bottom: 8px
    }

    .map-container {
      border-radius: 14px;
      overflow: hidden;
      border: 1.5px solid rgba(6, 182, 212, .2);
      box-shadow: 0 4px 16px rgba(6, 182, 212, .08);
      position: relative
    }

    #map {
      height: 220px;
      width: 100%
    }

    .map-hint {
      position: absolute;
      bottom: 10px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(15, 23, 42, .65);
      backdrop-filter: blur(8px);
      color: #fff;
      font-size: 10px;
      font-weight: 600;
      padding: 5px 12px;
      border-radius: 99px;
      white-space: nowrap;
      pointer-events: none;
      z-index: 10
    }

    .actions {
      display: flex;
      gap: 10px
    }

    .btn-save {
      flex: 1;
      position: relative;
      overflow: hidden;
      background: linear-gradient(120deg, #22d3ee, #3b82f6 55%, #6366f1);
      color: #fff;
      border: none;
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 14px;
      font-weight: 800;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 4px 0 rgba(0, 0, 0, .14), 0 8px 20px rgba(34, 211, 238, .25);
      transition: transform .14s, box-shadow .14s
    }

    .btn-save::before {
      content: '''';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 45%;
      background: linear-gradient(180deg, rgba(255, 255, 255, .15), transparent);
      pointer-events: none
    }

    .btn-save:hover {
      transform: translateY(-2px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 6px 0 rgba(0, 0, 0, .14), 0 12px 28px rgba(34, 211, 238, .32)
    }

    .btn-save:active {
      transform: translateY(2px)
    }

    .btn-save:disabled {
      opacity: .6;
      cursor: not-allowed;
      transform: none
    }

    .ico-circle {
      width: 22px;
      height: 22px;
      border-radius: 7px;
      background: rgba(255, 255, 255, .2);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .btn-skip {
      background: rgba(255, 255, 255, .7);
      color: #64748b;
      border: 1.5px solid rgba(203, 213, 225, .8);
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 13px;
      font-weight: 600;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      white-space: nowrap;
      backdrop-filter: blur(8px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .9);
      transition: all .14s
    }

    .btn-skip:hover {
      background: rgba(255, 255, 255, .9);
      color: #475569;
      transform: translateY(-1px)
    }

    .btn-skip:active {
      transform: translateY(1px)
    }

    .btn-skip:disabled {
      opacity: .5;
      cursor: not-allowed;
      transform: none
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 9999;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(15, 23, 42, .42);
      backdrop-filter: blur(7px);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease
    }

    .overlay.show {
      opacity: 1;
      pointer-events: all
    }

    .ov-box {
      background: rgba(255, 255, 255, .9);
      backdrop-filter: blur(20px);
      border: 1.5px solid rgba(255, 255, 255, .98);
      border-radius: 24px;
      padding: 38px 44px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
      min-width: 210px;
      box-shadow: 0 28px 64px rgba(15, 23, 42, .16);
      transform: scale(.86) translateY(14px);
      opacity: 0;
      transition: transform .32s cubic-bezier(.34, 1.56, .64, 1), opacity .22s ease
    }

    .overlay.show .ov-box {
      transform: scale(1) translateY(0);
      opacity: 1
    }

    .spin-wrap {
      width: 54px;
      height: 54px;
      position: relative;
      flex-shrink: 0
    }

    .spin-wrap svg {
      position: absolute;
      inset: 0;
      animation: ovSpin .85s linear infinite
    }

    @keyframes ovSpin {
      to {
        transform: rotate(360deg)
      }
    }

    .ok-wrap {
      width: 54px;
      height: 54px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 6px 22px rgba(6, 182, 212, .38);
      transform: scale(0);
      transition: transform .36s cubic-bezier(.34, 1.56, .64, 1);
      flex-shrink: 0
    }

    .ok-wrap.pop {
      transform: scale(1)
    }

    .ok-wrap svg path {
      stroke-dasharray: 22;
      stroke-dashoffset: 22;
      transition: stroke-dashoffset .38s ease .18s
    }

    .ok-wrap.pop svg path {
      stroke-dashoffset: 0
    }

    .ov-title {
      font-size: 15px;
      font-weight: 800;
      color: #0f172a;
      text-align: center
    }

    .ov-sub {
      font-size: 11.5px;
      color: #64748b;
      text-align: center;
      margin-top: -4px
    }

    .ov-dots {
      display: flex;
      gap: 5px;
      align-items: center;
      margin-top: 2px
    }

    .ov-dots span {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      animation: ovDot 1s infinite both
    }

    .ov-dots span:nth-child(2) {
      animation-delay: .18s
    }

    .ov-dots span:nth-child(3) {
      animation-delay: .36s
    }

    @keyframes ovDot {

      0%,
      80%,
      100% {
        opacity: .2;
        transform: scale(.75)
      }

      40% {
        opacity: 1;
        transform: scale(1)
      }
    }

    .toast-err {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(20px);
      z-index: 99999;
      background: #fef2f2;
      border: 1.5px solid rgba(220, 38, 38, .25);
      border-radius: 14px;
      padding: 12px 18px;
      display: flex;
      align-items: center;
      gap: 10px;
      box-shadow: 0 8px 24px rgba(220, 38, 38, .15);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease, transform .22s ease;
      white-space: nowrap
    }

    .toast-err.show {
      opacity: 1;
      pointer-events: all;
      transform: translateX(-50%) translateY(0)
    }

    .toast-err-ico {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: #fee2e2;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .toast-err-txt {
      font-size: 12px;
      font-weight: 700;
      color: #dc2626
    }

    /* ---- MEDIA QUERIES ---- */
    @media(max-width:560px) {
      body {
        min-height: 100vh;
        min-height: 100dvh;
        padding: 0;
        align-items: flex-start;
        /* Konten dimulai dari atas */
      }

      .card {
        max-width: 100%;
        padding: 24px 20px 80px;
        /* Padding bawah untuk area scroll */
        border-radius: 0;
        /* Menghilangkan sudut melengkung */
        border: none;
        /* Menghilangkan garis border card */
        box-shadow: none;
        /* Menghilangkan bayangan */
        background: transparent;
        /* Latar belakang card tembus pandang */
        backdrop-filter: none;
        /* Menghilangkan efek glassmorphism pada card */
        min-height: 100vh;
      }

      #map {
        height: 190px
      }

      .actions {
        display: flex;
        flex-direction: column-reverse; /* Reverse button order on mobile */
      }

      .btn-save,
      .btn-skip {
        width: 100%;
        padding: 16px
      }
    }

    @media(max-width:360px) {
      .card {
        padding: 20px 16px 80px
      }
    }
  </style>
</head>

<body>
  <div class="bg">
    <div class="b1"></div>
    <div class="b2"></div>
    <div class="b3"></div>
  </div>
  <div class="overlay" id="overlay">
    <div class="ov-box" id="ovBox"></div>
  </div>
  <div class="toast-err" id="toastErr">
    <div class="toast-err-ico"><svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#dc2626"
        stroke-width="2" stroke-linecap="round">
        <path d="M6 2v4M6 9.5v.5" />
      </svg></div>
    <span class="toast-err-txt" id="toastErrMsg">Isi minimal 1 data sebelum menyimpan</span>
  </div>

  <div class="card">
    <div class="head">
      <div class="head-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="#fff" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round">
          <path d="M10 2C6.686 2 4 4.686 4 8c0 4.5 6 10 6 10s6-5.5 6-10c0-3.314-2.686-6-6-6z" />
          <circle cx="10" cy="8" r="2" />
        </svg>
      </div>
      <div class="head-txt">
        <h2>Informasi Lokasi</h2>
        <p>Cari atau klik peta untuk pilih lokasi</p>
      </div>
    </div>

    <div class="prog-bar">
      <div class="prog-fill" id="pf"></div>
    </div>
    <div class="prog-label"><span id="pt">0 entri diisi</span><span id="pp">0%</span></div>

    <div class="fields">
      <div>
        <div class="sec-header">
          <div class="sec-title">Alamat Rumah</div>
          <button class="add-btn" onclick="window.addEntry(''home'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Alamat
          </button>
        </div>
        <div class="entry-list" id="list-home"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Tempat Praktek</div>
          <button class="add-btn" onclick="window.addEntry(''practice'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Praktek
          </button>
        </div>
        <div class="entry-list" id="list-practice"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Koordinat Aktif</div>
        </div>
        <div class="coord-row">
          <div>
            <div class="lbl-sm">Latitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M7 1v12M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="latitude" placeholder="-6.200000" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
          <div>
            <div class="lbl-sm">Longitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="longitude" placeholder="106.816666" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
        </div>
      </div>
      <div>
        <div class="map-sec-label">Peta Lokasi — Klik untuk pilih koordinat</div>
        <div class="map-container">
          <div id="map"></div>
          <div class="map-hint">Klik peta untuk pilih lokasi</div>
        </div>
      </div>
    </div>

    <!-- Tombol ditukar posisinya -->
    <div class="actions">
      <button class="btn-skip" id="btn-skip" onclick="doSkip()">Lewati</button>
      <button class="btn-save" id="btn-save" onclick="doSave()">
        <div class="ico-circle">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#fff" stroke-width="2.2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M1.5 6h9M7 2l4 4-4 4" />
          </svg>
        </div>
        Simpan Data
      </button>
    </div>
  </div>

  <script>
    // Variabel Peta Global
    var map;
    var marker;

    // --- GOOGLE MAPS INIT ---
    function initMap() {
      var initialPos = { lat: -2.5, lng: 118 };

      map = new google.maps.Map(document.getElementById(''map''), {
        zoom: 5,
        center: initialPos,
        disableDefaultUI: true, // UI bersih
        zoomControl: true,
      });

      // FIX: Menggunakan viewBox yang lebih luas (-1 -1 30 45) agar bentuk path (max Y=42)
      // TIDAK terpotong sedikitpun di ujung jarum bawahnya.
      var svgIcon = {
        url: ''data:image/svg+xml;charset=UTF-8,'' + encodeURIComponent(''<svg width="30" height="45" viewBox="-1 -1 30 45" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M14 0C6.27 0 0 6.27 0 14c0 9.9 14 28 14 28S28 23.9 28 14C28 6.27 21.73 0 14 0z" fill="#ef4444"/><circle cx="14" cy="14" r="6" fill="white"/></svg>''),
        scaledSize: new google.maps.Size(30, 45),
        anchor: new google.maps.Point(15, 43)
      };

      marker = new google.maps.Marker({
        position: initialPos,
        map: map,
        draggable: true,
        icon: svgIcon
      });

      marker.setVisible(false); // Sembunyikan sampai user klik

      map.addListener(''click'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.placeMarker(lat, lng);
        window.reverseGeocode(lat, lng);
      });

      marker.addListener(''dragend'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.setCoords(lat, lng);
        window.reverseGeocode(lat, lng);
      });
    }

    (function () {
      var counters = window.__locationCounters || { home: 0, practice: 0 }, timers = {}, coordTimer = null;
      window.__locationCounters = counters;
      var entries = { home: [], practice: [] };
      var activeEntryId = null;

      // --- CONFIG ---
      var PROXY = ''https://visit-flow-api.flexurio.com/google-maps'';
      var CUSTOMER_ID = (function () {
        try {
          if (window.customerId) return window.customerId;
        } catch (e) { }
        var m = location.search.match(/[?&]id=([^&]+)/);
        return m ? m[1] : null;
      })();

      // ---- FUNGSI UPDATE PETA ----
      window.placeMarker = function (lat, lng) {
        var pos = { lat: parseFloat(lat), lng: parseFloat(lng) };
        if (marker) {
          marker.setPosition(pos);
          marker.setVisible(true);
        }
        if (map) {
          map.panTo(pos);
          map.setZoom(16);
        }
        window.setCoords(lat, lng);
      }

      window.setCoords = function (lat, lng) {
        document.getElementById(''latitude'').value = parseFloat(lat).toFixed(6);
        document.getElementById(''longitude'').value = parseFloat(lng).toFixed(6);
      }

      // ---- REVERSE GEOCODE ----
      window.reverseGeocode = function (lat, lng) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + lat + '','' + lng)
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (d.status === ''OK'' && d.results && d.results.length) {
              var r = d.results[0];
              var full = r.formatted_address || '''';
              var short = r.address_components && r.address_components[0] ? r.address_components[0].long_name : full.split('','')[0];
              applyReverseResult(short, full, lat, lng);
            } else {
              nominatimReverse(lat, lng);
            }
          })
          .catch(function () { nominatimReverse(lat, lng); });
      }
      function nominatimReverse(lat, lng) {
        fetch(''https://nominatim.openstreetmap.org/reverse?format=json&lat='' + lat + ''&lon='' + lng + ''&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (d) {
            var full = d.display_name || '''';
            var short = full.split('','')[0];
            applyReverseResult(short, full, lat, lng);
          })
          .catch(function () { });
      }
      function applyReverseResult(short, full, lat, lng) {
        var id = activeEntryId;
        if (!id) { var all = entries.home.concat(entries.practice); if (all.length) id = all[all.length - 1]; }
        if (!id) return;
        var entry = document.getElementById(''entry-'' + id); if (!entry) return;
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        var sfw = document.getElementById(''sfw-'' + id);
        if (sfw) {
          var type = id.split(''-'')[0];
          if (type === ''home'') {
            sfw.querySelector(''.sf-inp'').value = short;
            sfw.querySelector(''.sf-clr'').classList.add(''show'');
            document.getElementById(''cn-'' + id).textContent = short;
          }
        }
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entryData = entryStore[id];
        if (entryData) { entryData.lat = parseFloat(lat); entryData.lng = parseFloat(lng); }
        updProg();
      }

      // ---- SEARCH ----
      function doSearch(q, id, drop) {
        fetch(PROXY + ''/places/autocomplete?input='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (data) {
            if (data.status === ''OK'' && data.predictions && data.predictions.length) {
              renderGoogleResults(data.predictions, id, drop);
            } else {
              fallbackNominatim(q, id, drop);
            }
          })
          .catch(function () { fallbackNominatim(q, id, drop); });
      }
      function renderGoogleResults(preds, id, drop) {
        drop.innerHTML = '''';
        preds.forEach(function (pred) {
          var el = document.createElement(''div'');
          el.className = ''sf-opt'';
          var main = pred.structured_formatting.main_text;
          var sec = pred.structured_formatting.secondary_text || '''';
          el.innerHTML =
            ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
            ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + main + ''</div><div class="sf-opt-addr">'' + sec + ''</div></div>'';
          el.addEventListener(''click'', function () {
            drop.classList.remove(''open'');
            fetch(PROXY + ''/places/details?place_id='' + encodeURIComponent(pred.place_id))
              .then(function (r) { return r.json(); })
              .then(function (d) {
                if (!d.result) return;
                var lat = d.result.geometry.location.lat;
                var lng = d.result.geometry.location.lng;
                var name = d.result.name || main;
                var full = d.result.formatted_address || main + '', '' + sec;
                selectPlace(id, name, full, lat, lng);
              })
              .catch(function () { geocodeText(main + '' '' + sec, id); });
          });
          drop.appendChild(el);
        });
      }
      function fallbackNominatim(q, id, drop) {
        fetch(''https://nominatim.openstreetmap.org/search?format=json&q='' + encodeURIComponent(q) + ''&limit=6&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (res) {
            if (!res.length) { drop.innerHTML = ''<div class="sf-msg">Tidak ditemukan</div>''; return; }
            drop.innerHTML = '''';
            res.forEach(function (item) {
              var el = document.createElement(''div'');
              el.className = ''sf-opt'';
              var short = item.display_name.split('','')[0];
              el.innerHTML =
                ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
                ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + short + ''</div><div class="sf-opt-addr">'' + item.display_name + ''</div></div>'';
              el.addEventListener(''click'', function () {
                drop.classList.remove(''open'');
                var lat = parseFloat(item.lat), lng = parseFloat(item.lon);
                selectPlace(id, short, item.display_name, lat, lng);
              });
              drop.appendChild(el);
            });
          })
          .catch(function () { drop.innerHTML = ''<div class="sf-msg">Gagal mencari</div>''; });
      }
      function geocodeText(q, id) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (!d.results || !d.results.length) return;
            var r = d.results[0];
            var lat = r.geometry.location.lat, lng = r.geometry.location.lng;
            var name = r.address_components[0].long_name;
            selectPlace(id, name, r.formatted_address, lat, lng);
          });
      }

      var entryStore = {};

      function selectPlace(id, name, full, lat, lng) {
        window.placeMarker(lat, lng);
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = name;
        sfw.querySelector(''.sf-clr'').classList.add(''show'');
        document.getElementById(''cn-'' + id).textContent = name;
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        if (!entryStore[id]) entryStore[id] = {};
        entryStore[id].location_name = name;
        entryStore[id].lat = lat;
        entryStore[id].lng = lng;
        updProg();
      }

      // ---- ADD ENTRY (Sudah support Initial Data) ----
      function addEntry(type, initialData) {
        var num = ++counters[type];
        var id = type + ''-'' + num;
        var isHome = type === ''home'';
        var isPrefilled = !!initialData && Object.keys(initialData).length > 0;

        var el = document.createElement(''div'');
        // Jika data lama, otomatis tambahkan class .is-collapsed dan .is-disabled
        el.className = ''entry'' + (isPrefilled ? '' is-disabled is-collapsed'' : '''');
        el.id = ''entry-'' + id;

        var ph = isHome ? ''Cari alamat rumah...'' : ''Cari klinik, RS, puskesmas...'';
        var taph = isHome ? ''Jl. Contoh No. 123, RT/RW, Kelurahan...'' : ''Alamat lengkap tempat praktek...'';

        // Set nilai dari DB
        var locId = isPrefilled ? initialData.id : null;
        var locName = isPrefilled ? (initialData.location_name || '''') : '''';
        var locAddr = isPrefilled ? (initialData.location_address || '''') : '''';
        var lat = (isPrefilled && initialData.latitude != null) ? initialData.latitude : null;
        var lng = (isPrefilled && initialData.longitude != null) ? initialData.longitude : null;
        var isActive = (initialData && initialData.hasOwnProperty(''is_active'')) ? initialData.is_active : true;

        var chipName = locName || (locAddr.split('','')[0]) || ''Lokasi'';
        var chipCoord = (lat != null && lng != null) ? parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4) : '''';
        var showChip = isPrefilled ? '' show'' : '''';

        // Tombol X hapus tidak ditampilkan jika prefilled dari DB
        var delBtnHtml = !isPrefilled ? ''<button class="entry-del" onclick="delEntry(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' : '''';

        // Nama custom header jika prefilled
        var titleName = isPrefilled && locName ? '' - '' + locName : '''';

        el.innerHTML =
          ''<div class="entry-head" style="cursor:pointer;" title="Klik untuk Expand/Minimize">'' +
          ''<div class="entry-num">'' + (isHome ? ''Rumah'' : ''Praktek'') + '' #'' + num + titleName + ''</div>'' +
          ''<div class="actions-group">'' +
          delBtnHtml +
          ''<button class="entry-toggle" type="button"><svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M2 8L6 4L10 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg></button>'' +
          ''</div>'' +
          ''</div>'' +
          ''<div class="entry-inner">'' +
          ''<div class="sf-wrap" id="sfw-'' + id + ''">'' +
          ''<svg class="sf-ico" viewBox="0 0 15 15" fill="none" stroke="#94a3b8" stroke-width="1.4" stroke-linecap="round"><circle cx="6.5" cy="6.5" r="4"/><path d="M10 10l3 3"/></svg>'' +
          ''<input class="sf-inp" type="text" placeholder="'' + ph + ''" autocomplete="off" value="'' + locName + ''"'' +
          '' oninput="onSF(this,\\'''' + id + ''\\'')"'' +
          '' onfocus="setActive(\\'''' + id + ''\\'');openDrop(\\'''' + id + ''\\'')">'' +
          ''<button class="sf-clr'' + (isPrefilled ? '' show'' : '''') + ''" onclick="clearSF(\\'''' + id + ''\\'')">×</button>'' +
          ''<div class="sf-drop" id="drop-'' + id + ''"></div>'' +
          ''</div>'' +
          ''<div class="entry-chip'' + showChip + ''" id="chip-'' + id + ''">'' +
          ''<div class="chip-dot"></div>'' +
          ''<div class="chip-name" id="cn-'' + id + ''">'' + chipName + ''</div>'' +
          ''<div class="chip-coord" id="cc-'' + id + ''">'' + chipCoord + ''</div>'' +
          ''<button class="chip-x" onclick="clearChip(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' +
          ''</div>'' +
          ''<textarea class="entry-ta" placeholder="'' + taph + ''" oninput="updProg()">'' + locAddr + ''</textarea>'' +
          ''<div class="field">'' +
          ''<div class="switch-wrap">'' +
          ''<div class="switch-lbl"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 12L11 14L15 10" stroke-linecap="round" stroke-linejoin="round"/></svg>Status Aktif</div>'' +
          ''<label class="switch"><input type="checkbox" class="act-check"'' + (isActive ? '' checked'' : '''') + ''><span class="slider"></span></label>'' +
          ''</div>'' +
          ''</div>'' +
          ''</div>'';

        document.getElementById(''list-'' + type).appendChild(el);

        entries[type].push(id);
        entryStore[id] = {
          id: locId,
          location_name: locName,
          lat: lat,
          lng: lng,
          is_active: isActive,
          isNew: !isPrefilled // Tracking agar data lama tidak di-submit ulang
        };

        var activeInp = el.querySelector(''.act-check'');
        activeInp.addEventListener(''change'', function () {
          entryStore[id].is_active = activeInp.checked;
          updProg();
        });

        // Tetap izinkan switch status aktif diubah untuk data lama
        if (isPrefilled) {
          el.querySelector(''.switch-wrap'').style.pointerEvents = ''auto'';
        }

        // Toggle Expand/Minimize Listener
        el.querySelector(''.entry-head'').addEventListener(''click'', function (e) {
          if (e.target.closest(''.entry-del'')) return;
          el.classList.toggle(''is-collapsed'');
        });

        updProg();
      }
      // EKSPOS FUNGSI AGAR BISA DIPANGGIL GOLANG
      window.addEntry = addEntry;

      function delEntry(id, type) {
        var el = document.getElementById(''entry-'' + id); if (el) el.remove();
        entries[type] = entries[type].filter(function (e) { return e !== id; });
        delete entryStore[id];
        if (activeEntryId === id) activeEntryId = null;
        updProg();
      }
      window.delEntry = delEntry;

      function onSF(inp, id) {
        var q = inp.value.trim();
        inp.nextElementSibling.classList.toggle(''show'', q.length > 0);
        clearTimeout(timers[id]);
        var drop = document.getElementById(''drop-'' + id);
        if (q.length < 2) { drop.classList.remove(''open''); return; }
        drop.classList.add(''open'');
        drop.innerHTML = ''<div class="sf-msg">Mencari...</div>'';
        timers[id] = setTimeout(function () { doSearch(q, id, drop); }, 500);
      }
      window.onSF = onSF;

      function openDrop(id) {
        var inp = document.getElementById(''sfw-'' + id).querySelector(''.sf-inp'');
        if (inp.value.trim().length >= 2) document.getElementById(''drop-'' + id).classList.add(''open'');
      }
      window.openDrop = openDrop;

      function setActive(id) { activeEntryId = id; }
      window.setActive = setActive;

      function clearSF(id) {
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = '''';
        sfw.querySelector(''.sf-clr'').classList.remove(''show'');
        document.getElementById(''drop-'' + id).classList.remove(''open'');
      }
      window.clearSF = clearSF;

      function clearChip(id, type) {
        document.getElementById(''chip-'' + id).classList.remove(''show'');
        clearSF(id);
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = '''';
        if (entryStore[id]) entryStore[id] = {};
        updProg();
      }
      window.clearChip = clearChip;

      document.addEventListener(''click'', function (e) {
        document.querySelectorAll(''.sf-drop.open'').forEach(function (d) {
          if (!d.closest(''.sf-wrap'').contains(e.target)) d.classList.remove(''open'');
        });
      });

      function onCoordInput() {
        clearTimeout(coordTimer);
        coordTimer = setTimeout(function () {
          var lat = parseFloat(document.getElementById(''latitude'').value);
          var lng = parseFloat(document.getElementById(''longitude'').value);
          if (!isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            var pos = { lat: lat, lng: lng };
            if (marker && map) {
              marker.setPosition(pos);
              marker.setVisible(true);
              map.panTo(pos);
              map.setZoom(16);
            }
          }
        }, 800);
      }
      window.onCoordInput = onCoordInput;

      function updProg() {
        var total = 0, filled = 0;
        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            total++;
            var ta = entry.querySelector(''.entry-ta'');
            if (ta && ta.value.trim()) filled++;
          });
        });
        var pct = total > 0 ? Math.round(filled / total * 100) : 0;
        document.getElementById(''pf'').style.width = pct + ''%'';
        document.getElementById(''pt'').textContent = filled + '' dari '' + total + '' entri diisi'';
        document.getElementById(''pp'').textContent = pct + ''%'';
      }
      window.updProg = updProg;

      var overlay = document.getElementById(''overlay''), ovBox = document.getElementById(''ovBox'');
      function showLoading(msg) {
        ovBox.innerHTML = ''<div class="spin-wrap"><svg width="54" height="54" viewBox="0 0 54 54" fill="none"><circle cx="27" cy="27" r="22" stroke="rgba(6,182,212,.14)" stroke-width="4.5"/><circle cx="27" cy="27" r="22" stroke="url(#g1)" stroke-width="4.5" stroke-linecap="round" stroke-dasharray="94 46"/><defs><linearGradient id="g1" x1="0" y1="0" x2="54" y2="0"><stop offset="0%" stop-color="#06b6d4"/><stop offset="100%" stop-color="#3b82f6"/></linearGradient></defs></svg></div><div class="ov-title">'' + (msg || ''Menyimpan...'') + ''</div><div class="ov-dots"><span></span><span></span><span></span></div>'';
        overlay.classList.add(''show'');
      }
      function showSuccess(title, sub) {
        ovBox.innerHTML = ''<div class="ok-wrap" id="okWrap"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12l5.5 5.5L20 7"/></svg></div><div class="ov-title">'' + (title || ''Tersimpan!'') + ''</div><div class="ov-sub">'' + (sub || '''') + ''</div>'';
        requestAnimationFrame(function () { requestAnimationFrame(function () { var w = document.getElementById(''okWrap''); if (w) w.classList.add(''pop''); }); });
      }
      function hideOverlay() { overlay.classList.remove(''show''); }
      function setBtns(d) { document.getElementById(''btn-save'').disabled = d; document.getElementById(''btn-skip'').disabled = d; }

      var toastErr = document.getElementById(''toastErr''), toastTimer = null;
      function showToastErr(msg) {
        document.getElementById(''toastErrMsg'').textContent = msg || ''Isi minimal 1 data sebelum menyimpan'';
        toastErr.classList.add(''show'');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toastErr.classList.remove(''show''); }, 2800);
      }

      function doSave() {
        var payload = [];
        var adaDataLama = false;

        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var store = entryStore[id] || {};

            // Skip data dari DB agar tidak disubmit ulang
            // Hanya skip jika isNew=false DAN is_active=true (tidak ada perubahan status)
            // Namun agar lebih aman dan simple sesuai request, kita kirimkan jika isNew=true ATAU (bukan isNew tapi is_active diubah)
            // Agar backend bisa handle update status nonaktif, kita kirim semua yang ada.
            
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            var ta = entry.querySelector(''.entry-ta'');
            var location_address = (ta && ta.value.trim()) || null;
            var location_name = store.location_name || null;
            var latitude = store.lat !== undefined ? store.lat : null;
            var longitude = store.lng !== undefined ? store.lng : null;
            var is_active = store.is_active;

            if (!location_address && !location_name && latitude === null && !store.id) return;

            payload.push({
              id: store.id || null,
              flag: type === ''home'' ? ''rumah'' : ''praktek'',
              location_name: location_name,
              location_address: location_address,
              latitude: latitude,
              longitude: longitude,
              is_active: is_active
            });
          });
        });

        if (payload.length === 0) {
          showToastErr(adaDataLama ? ''Tambahkan minimal 1 data baru untuk disimpan'' : ''Isi minimal 1 data lokasi sebelum menyimpan'');
          var btn = document.getElementById(''btn-save'');
          btn.style.transition = ''transform .08s ease'';
          var s = [-6, 6, -5, 5, -3, 3, 0], i = 0;
          (function shake() { if (i < s.length) { btn.style.transform = ''translateX('' + s[i++] + ''px)''; setTimeout(shake, 60); } else { btn.style.transform = ''''; btn.style.transition = ''''; } }());
          return;
        }

        setBtns(true);
        showLoading(''Menyimpan data...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SUBMIT_LOCATION'', input_value: payload });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSave]'', msg); }
          showSuccess(''Data Tersimpan!'', ''Lokasi berhasil disimpan'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1800);
        }, 900);
      }
      window.doSave = doSave;

      function doSkip() {
        setBtns(true);
        showLoading(''Melewati langkah ini...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SKIP_LOCATION'', input_value: null });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSkip]'', msg); }
          showSuccess(''Langkah Dilewati'', ''Kamu bisa melengkapi lokasi nanti'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1600);
        }, 700);
      }
      window.doSkip = doSkip;
    })();
  </script>
  <!-- SCRIPT GOOGLE MAPS API -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKHM_SHT0BmNh3fRwVrbtZDUFmtqobYXI&callback=initMap"
    async defer></script>
</body>

</html>'),
  (63491, 0, '2026-08-05 02:13:11.842000', 0, '2026-08-05 02:13:11.842000', NULL, NULL, 1220776, '202608', 'BDGA1', 'CUSTOMER LOCATION', '24010141', '<!DOCTYPE html>
<html lang="id">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Informasi Lokasi Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
    rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      -webkit-tap-highlight-color: transparent
    }

    body {
      min-height: 100vh;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      background: #f0f7ff;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px 60px;
      position: relative;
      overflow-x: hidden
    }

    .bg {
      position: fixed;
      inset: 0;
      z-index: 0;
      pointer-events: none
    }

    .b1 {
      position: absolute;
      width: 500px;
      height: 500px;
      top: -15%;
      left: -10%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #bae6fd, #e0f2fe)
    }

    .b2 {
      position: absolute;
      width: 450px;
      height: 450px;
      bottom: -10%;
      right: -8%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #c7d2fe, #ddd6fe)
    }

    .b3 {
      position: absolute;
      width: 350px;
      height: 350px;
      top: 40%;
      left: 35%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .35;
      background: radial-gradient(circle, #a7f3d0, #d1fae5)
    }

    .card {
      position: relative;
      z-index: 1;
      background: rgba(255, 255, 255, .62);
      backdrop-filter: blur(24px);
      border: 1.5px solid rgba(255, 255, 255, .92);
      border-radius: 28px;
      padding: 36px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(15, 23, 42, .09), 0 4px 16px rgba(15, 23, 42, .05)
    }

    .head {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 24px
    }

    .head-icon {
      width: 44px;
      height: 44px;
      border-radius: 13px;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 14px rgba(6, 182, 212, .35);
      flex-shrink: 0
    }

    .head-txt h2 {
      font-size: 16px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -.3px
    }

    .head-txt p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px
    }

    .prog-bar {
      height: 4px;
      background: rgba(15, 23, 42, .07);
      border-radius: 99px;
      overflow: hidden;
      margin-bottom: 6px
    }

    .prog-fill {
      height: 100%;
      border-radius: 99px;
      background: linear-gradient(90deg, #06b6d4, #3b82f6);
      width: 0%;
      transition: width .35s ease
    }

    .prog-label {
      display: flex;
      justify-content: space-between;
      font-size: 10px;
      color: #94a3b8;
      font-weight: 600;
      margin-bottom: 24px
    }

    .sec-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
      margin-top: 4px
    }

    .sec-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .8px;
      text-transform: uppercase
    }

    .sec-title::before {
      content: '''';
      width: 20px;
      height: 1px;
      background: rgba(148, 163, 184, .25)
    }

    .add-btn {
      display: flex;
      align-items: center;
      gap: 5px;
      background: linear-gradient(135deg, rgba(6, 182, 212, .1), rgba(59, 130, 246, .08));
      border: 1.5px solid rgba(6, 182, 212, .25);
      border-radius: 8px;
      padding: 5px 10px;
      font-size: 10px;
      font-weight: 700;
      color: #0891b2;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .add-btn:hover {
      background: linear-gradient(135deg, rgba(6, 182, 212, .18), rgba(59, 130, 246, .14))
    }

    .fields {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 24px
    }

    .entry-list {
      display: flex;
      flex-direction: column;
      gap: 10px
    }

    .entry {
      background: rgba(248, 250, 252, .6);
      border: 1.5px solid rgba(226, 232, 240, .8);
      border-radius: 14px;
      padding: 14px;
      transition: border-color .18s
    }

    .entry:focus-within {
      border-color: rgba(6, 182, 212, .3);
      background: rgba(255, 255, 255, .8)
    }

    /* Header & Toggle Actions */
    .entry-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
      user-select: none;
    }

    .entry-num {
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .5px;
      text-transform: uppercase;
      transition: color .2s;
    }

    .actions-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .entry-del {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(220, 38, 38, .08);
      border: 1px solid rgba(220, 38, 38, .15);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      color: #dc2626;
      opacity: .6;
      transition: opacity .15s;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      line-height: 1
    }

    .entry-del:hover {
      opacity: 1
    }

    .entry-toggle {
      width: 24px;
      height: 24px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      border: 1px solid rgba(6, 182, 212, .2);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #0891b2;
      transition: background .15s;
    }

    .entry-toggle:hover {
      background: rgba(6, 182, 212, .2);
    }

    .entry-toggle svg {
      transition: transform .3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .entry.is-collapsed .entry-toggle svg {
      transform: rotate(180deg);
    }

    /* Content Body */
    .entry-inner {
      display: flex;
      flex-direction: column;
      gap: 8px
    }

    .entry.is-collapsed .entry-inner {
      display: none !important;
    }

    .entry.is-collapsed .entry-head {
      margin-bottom: 0;
    }

    /* State Disabled (Data dari Database) */
    .entry.is-disabled {
      background: rgba(241, 245, 249, 0.7);
      border-color: rgba(203, 213, 225, 0.5);
      opacity: 0.9;
    }

    .entry.is-disabled .entry-inner {
      pointer-events: none;
      /* Mematikan klik form */
    }

    .entry.is-disabled .sf-inp,
    .entry.is-disabled .entry-ta {
      background: transparent;
      box-shadow: none;
      border-color: rgba(226, 232, 240, 0.6);
      color: #64748b;
      font-weight: 600;
    }

    .entry.is-disabled .sf-clr,
    .entry.is-disabled .chip-x {
      display: none !important;
    }

    /* ------------------------------------- */

    .sf-wrap {
      position: relative
    }

    .sf-ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .sf-inp {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 32px 10px 34px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s
    }

    .sf-inp::placeholder {
      color: #94a3b8
    }

    .sf-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    /* Switch Toggle Styles */
    .switch-wrap {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 14px;
      background: rgba(255, 255, 255, .4);
      border: 1px solid rgba(226, 232, 240, .8);
      border-radius: 12px;
      margin-top: 5px
    }

    .switch-lbl {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      display: flex;
      align-items: center;
      gap: 6px
    }

    .switch {
      position: relative;
      display: inline-block;
      width: 38px;
      height: 22px
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #cbd5e1;
      transition: .3s;
      border-radius: 22px
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 2px;
      bottom: 2px;
      background-color: white;
      transition: .3s;
      border-radius: 50%;
      box-shadow: 0 2px 4px rgba(0, 0, 0, .1)
    }

    input:checked+.slider {
      background: linear-gradient(135deg, #06b6d4, #3b82f6)
    }

    input:checked+.slider:before {
      transform: translateX(16px)
    }

    .sf-clr {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      border-radius: 5px;
      background: rgba(148, 163, 184, .12);
      border: none;
      cursor: pointer;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: #94a3b8;
      z-index: 1;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .sf-clr.show {
      display: flex
    }

    .sf-drop {
      position: absolute;
      top: calc(100% + 4px);
      left: 0;
      right: 0;
      background: #fff;
      border: 1.5px solid rgba(6, 182, 212, .2);
      border-radius: 10px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, .12);
      z-index: 600;
      max-height: 200px;
      overflow-y: auto;
      display: none
    }

    .sf-drop.open {
      display: block
    }

    .sf-drop::-webkit-scrollbar {
      width: 3px
    }

    .sf-drop::-webkit-scrollbar-thumb {
      background: rgba(148, 163, 184, .3);
      border-radius: 99px
    }

    .sf-opt {
      display: flex;
      align-items: flex-start;
      gap: 8px;
      padding: 10px 12px;
      cursor: pointer;
      border-bottom: 1px solid rgba(226, 232, 240, .3);
      transition: background .1s;
      font-size: 12px
    }

    .sf-opt:last-child {
      border-bottom: none
    }

    .sf-opt:hover {
      background: rgba(6, 182, 212, .06)
    }

    .sf-opt-pin {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-top: 1px
    }

    .sf-opt-txt {
      flex: 1;
      min-width: 0
    }

    .sf-opt-name {
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis
    }

    .sf-opt-addr {
      font-size: 10px;
      color: #64748b;
      margin-top: 1px;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden
    }

    .sf-msg {
      padding: 12px;
      text-align: center;
      font-size: 11px;
      color: #94a3b8
    }

    .entry-chip {
      display: none;
      align-items: center;
      gap: 7px;
      background: rgba(6, 182, 212, .06);
      border: 1px solid rgba(6, 182, 212, .2);
      border-radius: 8px;
      padding: 7px 10px
    }

    .entry-chip.show {
      display: flex
    }

    .chip-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      flex-shrink: 0
    }

    .chip-name {
      flex: 1;
      font-size: 11px;
      font-weight: 600;
      color: #0891b2;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap
    }

    .chip-coord {
      font-size: 10px;
      color: #64748b;
      white-space: nowrap;
      flex-shrink: 0
    }

    .chip-x {
      width: 18px;
      height: 18px;
      border-radius: 4px;
      background: rgba(8, 145, 178, .1);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      color: #0891b2;
      flex-shrink: 0;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .entry-ta {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      resize: none;
      line-height: 1.6;
      min-height: 60px
    }

    .entry-ta::placeholder {
      color: #94a3b8
    }

    .entry-ta:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px
    }

    .lbl-sm {
      font-size: 9.5px;
      font-weight: 700;
      color: #475569;
      letter-spacing: .4px;
      text-transform: uppercase;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px
    }

    .badge {
      font-size: 9px;
      padding: 1px 6px;
      border-radius: 4px;
      font-weight: 600;
      text-transform: none;
      letter-spacing: 0;
      background: rgba(224, 242, 254, .7);
      color: #0891b2;
      border: 1px solid rgba(8, 145, 178, .2)
    }

    .inp-wrap {
      position: relative
    }

    .inp-wrap .ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .coord-inp {
      width: 100%;
      background: rgba(248, 250, 252, .85);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px 10px 32px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      appearance: none;
      -webkit-appearance: none
    }

    .coord-inp::placeholder {
      color: #94a3b8
    }

    .coord-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-inp::-webkit-inner-spin-button,
    .coord-inp::-webkit-outer-spin-button {
      -webkit-appearance: none
    }

    .map-sec-label {
      font-size: 9.5px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .6px;
      text-transform: uppercase;
      margin-bottom: 8px
    }

    .map-container {
      border-radius: 14px;
      overflow: hidden;
      border: 1.5px solid rgba(6, 182, 212, .2);
      box-shadow: 0 4px 16px rgba(6, 182, 212, .08);
      position: relative
    }

    #map {
      height: 220px;
      width: 100%
    }

    .map-hint {
      position: absolute;
      bottom: 10px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(15, 23, 42, .65);
      backdrop-filter: blur(8px);
      color: #fff;
      font-size: 10px;
      font-weight: 600;
      padding: 5px 12px;
      border-radius: 99px;
      white-space: nowrap;
      pointer-events: none;
      z-index: 10
    }

    .actions {
      display: flex;
      gap: 10px
    }

    .btn-save {
      flex: 1;
      position: relative;
      overflow: hidden;
      background: linear-gradient(120deg, #22d3ee, #3b82f6 55%, #6366f1);
      color: #fff;
      border: none;
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 14px;
      font-weight: 800;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 4px 0 rgba(0, 0, 0, .14), 0 8px 20px rgba(34, 211, 238, .25);
      transition: transform .14s, box-shadow .14s
    }

    .btn-save::before {
      content: '''';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 45%;
      background: linear-gradient(180deg, rgba(255, 255, 255, .15), transparent);
      pointer-events: none
    }

    .btn-save:hover {
      transform: translateY(-2px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 6px 0 rgba(0, 0, 0, .14), 0 12px 28px rgba(34, 211, 238, .32)
    }

    .btn-save:active {
      transform: translateY(2px)
    }

    .btn-save:disabled {
      opacity: .6;
      cursor: not-allowed;
      transform: none
    }

    .ico-circle {
      width: 22px;
      height: 22px;
      border-radius: 7px;
      background: rgba(255, 255, 255, .2);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .btn-skip {
      background: rgba(255, 255, 255, .7);
      color: #64748b;
      border: 1.5px solid rgba(203, 213, 225, .8);
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 13px;
      font-weight: 600;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      white-space: nowrap;
      backdrop-filter: blur(8px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .9);
      transition: all .14s
    }

    .btn-skip:hover {
      background: rgba(255, 255, 255, .9);
      color: #475569;
      transform: translateY(-1px)
    }

    .btn-skip:active {
      transform: translateY(1px)
    }

    .btn-skip:disabled {
      opacity: .5;
      cursor: not-allowed;
      transform: none
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 9999;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(15, 23, 42, .42);
      backdrop-filter: blur(7px);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease
    }

    .overlay.show {
      opacity: 1;
      pointer-events: all
    }

    .ov-box {
      background: rgba(255, 255, 255, .9);
      backdrop-filter: blur(20px);
      border: 1.5px solid rgba(255, 255, 255, .98);
      border-radius: 24px;
      padding: 38px 44px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
      min-width: 210px;
      box-shadow: 0 28px 64px rgba(15, 23, 42, .16);
      transform: scale(.86) translateY(14px);
      opacity: 0;
      transition: transform .32s cubic-bezier(.34, 1.56, .64, 1), opacity .22s ease
    }

    .overlay.show .ov-box {
      transform: scale(1) translateY(0);
      opacity: 1
    }

    .spin-wrap {
      width: 54px;
      height: 54px;
      position: relative;
      flex-shrink: 0
    }

    .spin-wrap svg {
      position: absolute;
      inset: 0;
      animation: ovSpin .85s linear infinite
    }

    @keyframes ovSpin {
      to {
        transform: rotate(360deg)
      }
    }

    .ok-wrap {
      width: 54px;
      height: 54px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 6px 22px rgba(6, 182, 212, .38);
      transform: scale(0);
      transition: transform .36s cubic-bezier(.34, 1.56, .64, 1);
      flex-shrink: 0
    }

    .ok-wrap.pop {
      transform: scale(1)
    }

    .ok-wrap svg path {
      stroke-dasharray: 22;
      stroke-dashoffset: 22;
      transition: stroke-dashoffset .38s ease .18s
    }

    .ok-wrap.pop svg path {
      stroke-dashoffset: 0
    }

    .ov-title {
      font-size: 15px;
      font-weight: 800;
      color: #0f172a;
      text-align: center
    }

    .ov-sub {
      font-size: 11.5px;
      color: #64748b;
      text-align: center;
      margin-top: -4px
    }

    .ov-dots {
      display: flex;
      gap: 5px;
      align-items: center;
      margin-top: 2px
    }

    .ov-dots span {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      animation: ovDot 1s infinite both
    }

    .ov-dots span:nth-child(2) {
      animation-delay: .18s
    }

    .ov-dots span:nth-child(3) {
      animation-delay: .36s
    }

    @keyframes ovDot {

      0%,
      80%,
      100% {
        opacity: .2;
        transform: scale(.75)
      }

      40% {
        opacity: 1;
        transform: scale(1)
      }
    }

    .toast-err {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(20px);
      z-index: 99999;
      background: #fef2f2;
      border: 1.5px solid rgba(220, 38, 38, .25);
      border-radius: 14px;
      padding: 12px 18px;
      display: flex;
      align-items: center;
      gap: 10px;
      box-shadow: 0 8px 24px rgba(220, 38, 38, .15);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease, transform .22s ease;
      white-space: nowrap
    }

    .toast-err.show {
      opacity: 1;
      pointer-events: all;
      transform: translateX(-50%) translateY(0)
    }

    .toast-err-ico {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: #fee2e2;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .toast-err-txt {
      font-size: 12px;
      font-weight: 700;
      color: #dc2626
    }

    /* ---- MEDIA QUERIES ---- */
    @media(max-width:560px) {
      body {
        min-height: 100vh;
        min-height: 100dvh;
        padding: 0;
        align-items: flex-start;
        /* Konten dimulai dari atas */
      }

      .card {
        max-width: 100%;
        padding: 24px 20px 80px;
        /* Padding bawah untuk area scroll */
        border-radius: 0;
        /* Menghilangkan sudut melengkung */
        border: none;
        /* Menghilangkan garis border card */
        box-shadow: none;
        /* Menghilangkan bayangan */
        background: transparent;
        /* Latar belakang card tembus pandang */
        backdrop-filter: none;
        /* Menghilangkan efek glassmorphism pada card */
        min-height: 100vh;
      }

      #map {
        height: 190px
      }

      .actions {
        display: flex;
        flex-direction: column-reverse; /* Reverse button order on mobile */
      }

      .btn-save,
      .btn-skip {
        width: 100%;
        padding: 16px
      }
    }

    @media(max-width:360px) {
      .card {
        padding: 20px 16px 80px
      }
    }
  </style>
</head>

<body>
  <div class="bg">
    <div class="b1"></div>
    <div class="b2"></div>
    <div class="b3"></div>
  </div>
  <div class="overlay" id="overlay">
    <div class="ov-box" id="ovBox"></div>
  </div>
  <div class="toast-err" id="toastErr">
    <div class="toast-err-ico"><svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#dc2626"
        stroke-width="2" stroke-linecap="round">
        <path d="M6 2v4M6 9.5v.5" />
      </svg></div>
    <span class="toast-err-txt" id="toastErrMsg">Isi minimal 1 data sebelum menyimpan</span>
  </div>

  <div class="card">
    <div class="head">
      <div class="head-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="#fff" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round">
          <path d="M10 2C6.686 2 4 4.686 4 8c0 4.5 6 10 6 10s6-5.5 6-10c0-3.314-2.686-6-6-6z" />
          <circle cx="10" cy="8" r="2" />
        </svg>
      </div>
      <div class="head-txt">
        <h2>Informasi Lokasi</h2>
        <p>Cari atau klik peta untuk pilih lokasi</p>
      </div>
    </div>

    <div class="prog-bar">
      <div class="prog-fill" id="pf"></div>
    </div>
    <div class="prog-label"><span id="pt">0 entri diisi</span><span id="pp">0%</span></div>

    <div class="fields">
      <div>
        <div class="sec-header">
          <div class="sec-title">Alamat Rumah</div>
          <button class="add-btn" onclick="window.addEntry(''home'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Alamat
          </button>
        </div>
        <div class="entry-list" id="list-home"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Tempat Praktek</div>
          <button class="add-btn" onclick="window.addEntry(''practice'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Praktek
          </button>
        </div>
        <div class="entry-list" id="list-practice"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Koordinat Aktif</div>
        </div>
        <div class="coord-row">
          <div>
            <div class="lbl-sm">Latitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M7 1v12M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="latitude" placeholder="-6.200000" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
          <div>
            <div class="lbl-sm">Longitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="longitude" placeholder="106.816666" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
        </div>
      </div>
      <div>
        <div class="map-sec-label">Peta Lokasi — Klik untuk pilih koordinat</div>
        <div class="map-container">
          <div id="map"></div>
          <div class="map-hint">Klik peta untuk pilih lokasi</div>
        </div>
      </div>
    </div>

    <!-- Tombol ditukar posisinya -->
    <div class="actions">
      <button class="btn-skip" id="btn-skip" onclick="doSkip()">Lewati</button>
      <button class="btn-save" id="btn-save" onclick="doSave()">
        <div class="ico-circle">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#fff" stroke-width="2.2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M1.5 6h9M7 2l4 4-4 4" />
          </svg>
        </div>
        Simpan Data
      </button>
    </div>
  </div>

  <script>
    // Variabel Peta Global
    var map;
    var marker;

    // --- GOOGLE MAPS INIT ---
    function initMap() {
      var initialPos = { lat: -2.5, lng: 118 };

      map = new google.maps.Map(document.getElementById(''map''), {
        zoom: 5,
        center: initialPos,
        disableDefaultUI: true, // UI bersih
        zoomControl: true,
      });

      // FIX: Menggunakan viewBox yang lebih luas (-1 -1 30 45) agar bentuk path (max Y=42)
      // TIDAK terpotong sedikitpun di ujung jarum bawahnya.
      var svgIcon = {
        url: ''data:image/svg+xml;charset=UTF-8,'' + encodeURIComponent(''<svg width="30" height="45" viewBox="-1 -1 30 45" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M14 0C6.27 0 0 6.27 0 14c0 9.9 14 28 14 28S28 23.9 28 14C28 6.27 21.73 0 14 0z" fill="#ef4444"/><circle cx="14" cy="14" r="6" fill="white"/></svg>''),
        scaledSize: new google.maps.Size(30, 45),
        anchor: new google.maps.Point(15, 43)
      };

      marker = new google.maps.Marker({
        position: initialPos,
        map: map,
        draggable: true,
        icon: svgIcon
      });

      marker.setVisible(false); // Sembunyikan sampai user klik

      map.addListener(''click'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.placeMarker(lat, lng);
        window.reverseGeocode(lat, lng);
      });

      marker.addListener(''dragend'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.setCoords(lat, lng);
        window.reverseGeocode(lat, lng);
      });
    }

    (function () {
      var counters = window.__locationCounters || { home: 0, practice: 0 }, timers = {}, coordTimer = null;
      window.__locationCounters = counters;
      var entries = { home: [], practice: [] };
      var activeEntryId = null;

      // --- CONFIG ---
      var PROXY = ''https://visit-flow-api.flexurio.com/google-maps'';
      var CUSTOMER_ID = (function () {
        try {
          if (window.customerId) return window.customerId;
        } catch (e) { }
        var m = location.search.match(/[?&]id=([^&]+)/);
        return m ? m[1] : null;
      })();

      // ---- FUNGSI UPDATE PETA ----
      window.placeMarker = function (lat, lng) {
        var pos = { lat: parseFloat(lat), lng: parseFloat(lng) };
        if (marker) {
          marker.setPosition(pos);
          marker.setVisible(true);
        }
        if (map) {
          map.panTo(pos);
          map.setZoom(16);
        }
        window.setCoords(lat, lng);
      }

      window.setCoords = function (lat, lng) {
        document.getElementById(''latitude'').value = parseFloat(lat).toFixed(6);
        document.getElementById(''longitude'').value = parseFloat(lng).toFixed(6);
      }

      // ---- REVERSE GEOCODE ----
      window.reverseGeocode = function (lat, lng) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + lat + '','' + lng)
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (d.status === ''OK'' && d.results && d.results.length) {
              var r = d.results[0];
              var full = r.formatted_address || '''';
              var short = r.address_components && r.address_components[0] ? r.address_components[0].long_name : full.split('','')[0];
              applyReverseResult(short, full, lat, lng);
            } else {
              nominatimReverse(lat, lng);
            }
          })
          .catch(function () { nominatimReverse(lat, lng); });
      }
      function nominatimReverse(lat, lng) {
        fetch(''https://nominatim.openstreetmap.org/reverse?format=json&lat='' + lat + ''&lon='' + lng + ''&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (d) {
            var full = d.display_name || '''';
            var short = full.split('','')[0];
            applyReverseResult(short, full, lat, lng);
          })
          .catch(function () { });
      }
      function applyReverseResult(short, full, lat, lng) {
        var id = activeEntryId;
        if (!id) { var all = entries.home.concat(entries.practice); if (all.length) id = all[all.length - 1]; }
        if (!id) return;
        var entry = document.getElementById(''entry-'' + id); if (!entry) return;
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        var sfw = document.getElementById(''sfw-'' + id);
        if (sfw) {
          var type = id.split(''-'')[0];
          if (type === ''home'') {
            sfw.querySelector(''.sf-inp'').value = short;
            sfw.querySelector(''.sf-clr'').classList.add(''show'');
            document.getElementById(''cn-'' + id).textContent = short;
          }
        }
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entryData = entryStore[id];
        if (entryData) { entryData.lat = parseFloat(lat); entryData.lng = parseFloat(lng); }
        updProg();
      }

      // ---- SEARCH ----
      function doSearch(q, id, drop) {
        fetch(PROXY + ''/places/autocomplete?input='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (data) {
            if (data.status === ''OK'' && data.predictions && data.predictions.length) {
              renderGoogleResults(data.predictions, id, drop);
            } else {
              fallbackNominatim(q, id, drop);
            }
          })
          .catch(function () { fallbackNominatim(q, id, drop); });
      }
      function renderGoogleResults(preds, id, drop) {
        drop.innerHTML = '''';
        preds.forEach(function (pred) {
          var el = document.createElement(''div'');
          el.className = ''sf-opt'';
          var main = pred.structured_formatting.main_text;
          var sec = pred.structured_formatting.secondary_text || '''';
          el.innerHTML =
            ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
            ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + main + ''</div><div class="sf-opt-addr">'' + sec + ''</div></div>'';
          el.addEventListener(''click'', function () {
            drop.classList.remove(''open'');
            fetch(PROXY + ''/places/details?place_id='' + encodeURIComponent(pred.place_id))
              .then(function (r) { return r.json(); })
              .then(function (d) {
                if (!d.result) return;
                var lat = d.result.geometry.location.lat;
                var lng = d.result.geometry.location.lng;
                var name = d.result.name || main;
                var full = d.result.formatted_address || main + '', '' + sec;
                selectPlace(id, name, full, lat, lng);
              })
              .catch(function () { geocodeText(main + '' '' + sec, id); });
          });
          drop.appendChild(el);
        });
      }
      function fallbackNominatim(q, id, drop) {
        fetch(''https://nominatim.openstreetmap.org/search?format=json&q='' + encodeURIComponent(q) + ''&limit=6&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (res) {
            if (!res.length) { drop.innerHTML = ''<div class="sf-msg">Tidak ditemukan</div>''; return; }
            drop.innerHTML = '''';
            res.forEach(function (item) {
              var el = document.createElement(''div'');
              el.className = ''sf-opt'';
              var short = item.display_name.split('','')[0];
              el.innerHTML =
                ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
                ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + short + ''</div><div class="sf-opt-addr">'' + item.display_name + ''</div></div>'';
              el.addEventListener(''click'', function () {
                drop.classList.remove(''open'');
                var lat = parseFloat(item.lat), lng = parseFloat(item.lon);
                selectPlace(id, short, item.display_name, lat, lng);
              });
              drop.appendChild(el);
            });
          })
          .catch(function () { drop.innerHTML = ''<div class="sf-msg">Gagal mencari</div>''; });
      }
      function geocodeText(q, id) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (!d.results || !d.results.length) return;
            var r = d.results[0];
            var lat = r.geometry.location.lat, lng = r.geometry.location.lng;
            var name = r.address_components[0].long_name;
            selectPlace(id, name, r.formatted_address, lat, lng);
          });
      }

      var entryStore = {};

      function selectPlace(id, name, full, lat, lng) {
        window.placeMarker(lat, lng);
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = name;
        sfw.querySelector(''.sf-clr'').classList.add(''show'');
        document.getElementById(''cn-'' + id).textContent = name;
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        if (!entryStore[id]) entryStore[id] = {};
        entryStore[id].location_name = name;
        entryStore[id].lat = lat;
        entryStore[id].lng = lng;
        updProg();
      }

      // ---- ADD ENTRY (Sudah support Initial Data) ----
      function addEntry(type, initialData) {
        var num = ++counters[type];
        var id = type + ''-'' + num;
        var isHome = type === ''home'';
        var isPrefilled = !!initialData && Object.keys(initialData).length > 0;

        var el = document.createElement(''div'');
        // Jika data lama, otomatis tambahkan class .is-collapsed dan .is-disabled
        el.className = ''entry'' + (isPrefilled ? '' is-disabled is-collapsed'' : '''');
        el.id = ''entry-'' + id;

        var ph = isHome ? ''Cari alamat rumah...'' : ''Cari klinik, RS, puskesmas...'';
        var taph = isHome ? ''Jl. Contoh No. 123, RT/RW, Kelurahan...'' : ''Alamat lengkap tempat praktek...'';

        // Set nilai dari DB
        var locId = isPrefilled ? initialData.id : null;
        var locName = isPrefilled ? (initialData.location_name || '''') : '''';
        var locAddr = isPrefilled ? (initialData.location_address || '''') : '''';
        var lat = (isPrefilled && initialData.latitude != null) ? initialData.latitude : null;
        var lng = (isPrefilled && initialData.longitude != null) ? initialData.longitude : null;
        var isActive = (initialData && initialData.hasOwnProperty(''is_active'')) ? initialData.is_active : true;

        var chipName = locName || (locAddr.split('','')[0]) || ''Lokasi'';
        var chipCoord = (lat != null && lng != null) ? parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4) : '''';
        var showChip = isPrefilled ? '' show'' : '''';

        // Tombol X hapus tidak ditampilkan jika prefilled dari DB
        var delBtnHtml = !isPrefilled ? ''<button class="entry-del" onclick="delEntry(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' : '''';

        // Nama custom header jika prefilled
        var titleName = isPrefilled && locName ? '' - '' + locName : '''';

        el.innerHTML =
          ''<div class="entry-head" style="cursor:pointer;" title="Klik untuk Expand/Minimize">'' +
          ''<div class="entry-num">'' + (isHome ? ''Rumah'' : ''Praktek'') + '' #'' + num + titleName + ''</div>'' +
          ''<div class="actions-group">'' +
          delBtnHtml +
          ''<button class="entry-toggle" type="button"><svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M2 8L6 4L10 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg></button>'' +
          ''</div>'' +
          ''</div>'' +
          ''<div class="entry-inner">'' +
          ''<div class="sf-wrap" id="sfw-'' + id + ''">'' +
          ''<svg class="sf-ico" viewBox="0 0 15 15" fill="none" stroke="#94a3b8" stroke-width="1.4" stroke-linecap="round"><circle cx="6.5" cy="6.5" r="4"/><path d="M10 10l3 3"/></svg>'' +
          ''<input class="sf-inp" type="text" placeholder="'' + ph + ''" autocomplete="off" value="'' + locName + ''"'' +
          '' oninput="onSF(this,\\'''' + id + ''\\'')"'' +
          '' onfocus="setActive(\\'''' + id + ''\\'');openDrop(\\'''' + id + ''\\'')">'' +
          ''<button class="sf-clr'' + (isPrefilled ? '' show'' : '''') + ''" onclick="clearSF(\\'''' + id + ''\\'')">×</button>'' +
          ''<div class="sf-drop" id="drop-'' + id + ''"></div>'' +
          ''</div>'' +
          ''<div class="entry-chip'' + showChip + ''" id="chip-'' + id + ''">'' +
          ''<div class="chip-dot"></div>'' +
          ''<div class="chip-name" id="cn-'' + id + ''">'' + chipName + ''</div>'' +
          ''<div class="chip-coord" id="cc-'' + id + ''">'' + chipCoord + ''</div>'' +
          ''<button class="chip-x" onclick="clearChip(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' +
          ''</div>'' +
          ''<textarea class="entry-ta" placeholder="'' + taph + ''" oninput="updProg()">'' + locAddr + ''</textarea>'' +
          ''<div class="field">'' +
          ''<div class="switch-wrap">'' +
          ''<div class="switch-lbl"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 12L11 14L15 10" stroke-linecap="round" stroke-linejoin="round"/></svg>Status Aktif</div>'' +
          ''<label class="switch"><input type="checkbox" class="act-check"'' + (isActive ? '' checked'' : '''') + ''><span class="slider"></span></label>'' +
          ''</div>'' +
          ''</div>'' +
          ''</div>'';

        document.getElementById(''list-'' + type).appendChild(el);

        entries[type].push(id);
        entryStore[id] = {
          id: locId,
          location_name: locName,
          lat: lat,
          lng: lng,
          is_active: isActive,
          isNew: !isPrefilled // Tracking agar data lama tidak di-submit ulang
        };

        var activeInp = el.querySelector(''.act-check'');
        activeInp.addEventListener(''change'', function () {
          entryStore[id].is_active = activeInp.checked;
          updProg();
        });

        // Tetap izinkan switch status aktif diubah untuk data lama
        if (isPrefilled) {
          el.querySelector(''.switch-wrap'').style.pointerEvents = ''auto'';
        }

        // Toggle Expand/Minimize Listener
        el.querySelector(''.entry-head'').addEventListener(''click'', function (e) {
          if (e.target.closest(''.entry-del'')) return;
          el.classList.toggle(''is-collapsed'');
        });

        updProg();
      }
      // EKSPOS FUNGSI AGAR BISA DIPANGGIL GOLANG
      window.addEntry = addEntry;

      function delEntry(id, type) {
        var el = document.getElementById(''entry-'' + id); if (el) el.remove();
        entries[type] = entries[type].filter(function (e) { return e !== id; });
        delete entryStore[id];
        if (activeEntryId === id) activeEntryId = null;
        updProg();
      }
      window.delEntry = delEntry;

      function onSF(inp, id) {
        var q = inp.value.trim();
        inp.nextElementSibling.classList.toggle(''show'', q.length > 0);
        clearTimeout(timers[id]);
        var drop = document.getElementById(''drop-'' + id);
        if (q.length < 2) { drop.classList.remove(''open''); return; }
        drop.classList.add(''open'');
        drop.innerHTML = ''<div class="sf-msg">Mencari...</div>'';
        timers[id] = setTimeout(function () { doSearch(q, id, drop); }, 500);
      }
      window.onSF = onSF;

      function openDrop(id) {
        var inp = document.getElementById(''sfw-'' + id).querySelector(''.sf-inp'');
        if (inp.value.trim().length >= 2) document.getElementById(''drop-'' + id).classList.add(''open'');
      }
      window.openDrop = openDrop;

      function setActive(id) { activeEntryId = id; }
      window.setActive = setActive;

      function clearSF(id) {
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = '''';
        sfw.querySelector(''.sf-clr'').classList.remove(''show'');
        document.getElementById(''drop-'' + id).classList.remove(''open'');
      }
      window.clearSF = clearSF;

      function clearChip(id, type) {
        document.getElementById(''chip-'' + id).classList.remove(''show'');
        clearSF(id);
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = '''';
        if (entryStore[id]) entryStore[id] = {};
        updProg();
      }
      window.clearChip = clearChip;

      document.addEventListener(''click'', function (e) {
        document.querySelectorAll(''.sf-drop.open'').forEach(function (d) {
          if (!d.closest(''.sf-wrap'').contains(e.target)) d.classList.remove(''open'');
        });
      });

      function onCoordInput() {
        clearTimeout(coordTimer);
        coordTimer = setTimeout(function () {
          var lat = parseFloat(document.getElementById(''latitude'').value);
          var lng = parseFloat(document.getElementById(''longitude'').value);
          if (!isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            var pos = { lat: lat, lng: lng };
            if (marker && map) {
              marker.setPosition(pos);
              marker.setVisible(true);
              map.panTo(pos);
              map.setZoom(16);
            }
          }
        }, 800);
      }
      window.onCoordInput = onCoordInput;

      function updProg() {
        var total = 0, filled = 0;
        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            total++;
            var ta = entry.querySelector(''.entry-ta'');
            if (ta && ta.value.trim()) filled++;
          });
        });
        var pct = total > 0 ? Math.round(filled / total * 100) : 0;
        document.getElementById(''pf'').style.width = pct + ''%'';
        document.getElementById(''pt'').textContent = filled + '' dari '' + total + '' entri diisi'';
        document.getElementById(''pp'').textContent = pct + ''%'';
      }
      window.updProg = updProg;

      var overlay = document.getElementById(''overlay''), ovBox = document.getElementById(''ovBox'');
      function showLoading(msg) {
        ovBox.innerHTML = ''<div class="spin-wrap"><svg width="54" height="54" viewBox="0 0 54 54" fill="none"><circle cx="27" cy="27" r="22" stroke="rgba(6,182,212,.14)" stroke-width="4.5"/><circle cx="27" cy="27" r="22" stroke="url(#g1)" stroke-width="4.5" stroke-linecap="round" stroke-dasharray="94 46"/><defs><linearGradient id="g1" x1="0" y1="0" x2="54" y2="0"><stop offset="0%" stop-color="#06b6d4"/><stop offset="100%" stop-color="#3b82f6"/></linearGradient></defs></svg></div><div class="ov-title">'' + (msg || ''Menyimpan...'') + ''</div><div class="ov-dots"><span></span><span></span><span></span></div>'';
        overlay.classList.add(''show'');
      }
      function showSuccess(title, sub) {
        ovBox.innerHTML = ''<div class="ok-wrap" id="okWrap"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12l5.5 5.5L20 7"/></svg></div><div class="ov-title">'' + (title || ''Tersimpan!'') + ''</div><div class="ov-sub">'' + (sub || '''') + ''</div>'';
        requestAnimationFrame(function () { requestAnimationFrame(function () { var w = document.getElementById(''okWrap''); if (w) w.classList.add(''pop''); }); });
      }
      function hideOverlay() { overlay.classList.remove(''show''); }
      function setBtns(d) { document.getElementById(''btn-save'').disabled = d; document.getElementById(''btn-skip'').disabled = d; }

      var toastErr = document.getElementById(''toastErr''), toastTimer = null;
      function showToastErr(msg) {
        document.getElementById(''toastErrMsg'').textContent = msg || ''Isi minimal 1 data sebelum menyimpan'';
        toastErr.classList.add(''show'');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toastErr.classList.remove(''show''); }, 2800);
      }

      function doSave() {
        var payload = [];
        var adaDataLama = false;

        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var store = entryStore[id] || {};

            // Skip data dari DB agar tidak disubmit ulang
            // Hanya skip jika isNew=false DAN is_active=true (tidak ada perubahan status)
            // Namun agar lebih aman dan simple sesuai request, kita kirimkan jika isNew=true ATAU (bukan isNew tapi is_active diubah)
            // Agar backend bisa handle update status nonaktif, kita kirim semua yang ada.
            
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            var ta = entry.querySelector(''.entry-ta'');
            var location_address = (ta && ta.value.trim()) || null;
            var location_name = store.location_name || null;
            var latitude = store.lat !== undefined ? store.lat : null;
            var longitude = store.lng !== undefined ? store.lng : null;
            var is_active = store.is_active;

            if (!location_address && !location_name && latitude === null && !store.id) return;

            payload.push({
              id: store.id || null,
              flag: type === ''home'' ? ''rumah'' : ''praktek'',
              location_name: location_name,
              location_address: location_address,
              latitude: latitude,
              longitude: longitude,
              is_active: is_active
            });
          });
        });

        if (payload.length === 0) {
          showToastErr(adaDataLama ? ''Tambahkan minimal 1 data baru untuk disimpan'' : ''Isi minimal 1 data lokasi sebelum menyimpan'');
          var btn = document.getElementById(''btn-save'');
          btn.style.transition = ''transform .08s ease'';
          var s = [-6, 6, -5, 5, -3, 3, 0], i = 0;
          (function shake() { if (i < s.length) { btn.style.transform = ''translateX('' + s[i++] + ''px)''; setTimeout(shake, 60); } else { btn.style.transform = ''''; btn.style.transition = ''''; } }());
          return;
        }

        setBtns(true);
        showLoading(''Menyimpan data...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SUBMIT_LOCATION'', input_value: payload });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSave]'', msg); }
          showSuccess(''Data Tersimpan!'', ''Lokasi berhasil disimpan'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1800);
        }, 900);
      }
      window.doSave = doSave;

      function doSkip() {
        setBtns(true);
        showLoading(''Melewati langkah ini...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SKIP_LOCATION'', input_value: null });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSkip]'', msg); }
          showSuccess(''Langkah Dilewati'', ''Kamu bisa melengkapi lokasi nanti'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1600);
        }, 700);
      }
      window.doSkip = doSkip;
    })();
  </script>
  <!-- SCRIPT GOOGLE MAPS API -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKHM_SHT0BmNh3fRwVrbtZDUFmtqobYXI&callback=initMap"
    async defer></script>
</body>

</html>'),
  (63492, 0, '2026-08-05 02:13:11.865000', 0, '2026-08-05 02:13:11.865000', NULL, NULL, 1220695, '202608', 'BDGA1S102', 'CUSTOMER LOCATION', '24010141', '<!DOCTYPE html>
<html lang="id">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Informasi Lokasi Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
    rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      -webkit-tap-highlight-color: transparent
    }

    body {
      min-height: 100vh;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      background: #f0f7ff;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px 60px;
      position: relative;
      overflow-x: hidden
    }

    .bg {
      position: fixed;
      inset: 0;
      z-index: 0;
      pointer-events: none
    }

    .b1 {
      position: absolute;
      width: 500px;
      height: 500px;
      top: -15%;
      left: -10%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #bae6fd, #e0f2fe)
    }

    .b2 {
      position: absolute;
      width: 450px;
      height: 450px;
      bottom: -10%;
      right: -8%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #c7d2fe, #ddd6fe)
    }

    .b3 {
      position: absolute;
      width: 350px;
      height: 350px;
      top: 40%;
      left: 35%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .35;
      background: radial-gradient(circle, #a7f3d0, #d1fae5)
    }

    .card {
      position: relative;
      z-index: 1;
      background: rgba(255, 255, 255, .62);
      backdrop-filter: blur(24px);
      border: 1.5px solid rgba(255, 255, 255, .92);
      border-radius: 28px;
      padding: 36px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(15, 23, 42, .09), 0 4px 16px rgba(15, 23, 42, .05)
    }

    .head {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 24px
    }

    .head-icon {
      width: 44px;
      height: 44px;
      border-radius: 13px;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 14px rgba(6, 182, 212, .35);
      flex-shrink: 0
    }

    .head-txt h2 {
      font-size: 16px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -.3px
    }

    .head-txt p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px
    }

    .prog-bar {
      height: 4px;
      background: rgba(15, 23, 42, .07);
      border-radius: 99px;
      overflow: hidden;
      margin-bottom: 6px
    }

    .prog-fill {
      height: 100%;
      border-radius: 99px;
      background: linear-gradient(90deg, #06b6d4, #3b82f6);
      width: 0%;
      transition: width .35s ease
    }

    .prog-label {
      display: flex;
      justify-content: space-between;
      font-size: 10px;
      color: #94a3b8;
      font-weight: 600;
      margin-bottom: 24px
    }

    .sec-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
      margin-top: 4px
    }

    .sec-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .8px;
      text-transform: uppercase
    }

    .sec-title::before {
      content: '''';
      width: 20px;
      height: 1px;
      background: rgba(148, 163, 184, .25)
    }

    .add-btn {
      display: flex;
      align-items: center;
      gap: 5px;
      background: linear-gradient(135deg, rgba(6, 182, 212, .1), rgba(59, 130, 246, .08));
      border: 1.5px solid rgba(6, 182, 212, .25);
      border-radius: 8px;
      padding: 5px 10px;
      font-size: 10px;
      font-weight: 700;
      color: #0891b2;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .add-btn:hover {
      background: linear-gradient(135deg, rgba(6, 182, 212, .18), rgba(59, 130, 246, .14))
    }

    .fields {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 24px
    }

    .entry-list {
      display: flex;
      flex-direction: column;
      gap: 10px
    }

    .entry {
      background: rgba(248, 250, 252, .6);
      border: 1.5px solid rgba(226, 232, 240, .8);
      border-radius: 14px;
      padding: 14px;
      transition: border-color .18s
    }

    .entry:focus-within {
      border-color: rgba(6, 182, 212, .3);
      background: rgba(255, 255, 255, .8)
    }

    /* Header & Toggle Actions */
    .entry-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
      user-select: none;
    }

    .entry-num {
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .5px;
      text-transform: uppercase;
      transition: color .2s;
    }

    .actions-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .entry-del {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(220, 38, 38, .08);
      border: 1px solid rgba(220, 38, 38, .15);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      color: #dc2626;
      opacity: .6;
      transition: opacity .15s;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      line-height: 1
    }

    .entry-del:hover {
      opacity: 1
    }

    .entry-toggle {
      width: 24px;
      height: 24px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      border: 1px solid rgba(6, 182, 212, .2);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #0891b2;
      transition: background .15s;
    }

    .entry-toggle:hover {
      background: rgba(6, 182, 212, .2);
    }

    .entry-toggle svg {
      transition: transform .3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .entry.is-collapsed .entry-toggle svg {
      transform: rotate(180deg);
    }

    /* Content Body */
    .entry-inner {
      display: flex;
      flex-direction: column;
      gap: 8px
    }

    .entry.is-collapsed .entry-inner {
      display: none !important;
    }

    .entry.is-collapsed .entry-head {
      margin-bottom: 0;
    }

    /* State Disabled (Data dari Database) */
    .entry.is-disabled {
      background: rgba(241, 245, 249, 0.7);
      border-color: rgba(203, 213, 225, 0.5);
      opacity: 0.9;
    }

    .entry.is-disabled .entry-inner {
      pointer-events: none;
      /* Mematikan klik form */
    }

    .entry.is-disabled .sf-inp,
    .entry.is-disabled .entry-ta {
      background: transparent;
      box-shadow: none;
      border-color: rgba(226, 232, 240, 0.6);
      color: #64748b;
      font-weight: 600;
    }

    .entry.is-disabled .sf-clr,
    .entry.is-disabled .chip-x {
      display: none !important;
    }

    /* ------------------------------------- */

    .sf-wrap {
      position: relative
    }

    .sf-ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .sf-inp {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 32px 10px 34px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s
    }

    .sf-inp::placeholder {
      color: #94a3b8
    }

    .sf-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    /* Switch Toggle Styles */
    .switch-wrap {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 14px;
      background: rgba(255, 255, 255, .4);
      border: 1px solid rgba(226, 232, 240, .8);
      border-radius: 12px;
      margin-top: 5px
    }

    .switch-lbl {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      display: flex;
      align-items: center;
      gap: 6px
    }

    .switch {
      position: relative;
      display: inline-block;
      width: 38px;
      height: 22px
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #cbd5e1;
      transition: .3s;
      border-radius: 22px
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 2px;
      bottom: 2px;
      background-color: white;
      transition: .3s;
      border-radius: 50%;
      box-shadow: 0 2px 4px rgba(0, 0, 0, .1)
    }

    input:checked+.slider {
      background: linear-gradient(135deg, #06b6d4, #3b82f6)
    }

    input:checked+.slider:before {
      transform: translateX(16px)
    }

    .sf-clr {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      border-radius: 5px;
      background: rgba(148, 163, 184, .12);
      border: none;
      cursor: pointer;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: #94a3b8;
      z-index: 1;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .sf-clr.show {
      display: flex
    }

    .sf-drop {
      position: absolute;
      top: calc(100% + 4px);
      left: 0;
      right: 0;
      background: #fff;
      border: 1.5px solid rgba(6, 182, 212, .2);
      border-radius: 10px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, .12);
      z-index: 600;
      max-height: 200px;
      overflow-y: auto;
      display: none
    }

    .sf-drop.open {
      display: block
    }

    .sf-drop::-webkit-scrollbar {
      width: 3px
    }

    .sf-drop::-webkit-scrollbar-thumb {
      background: rgba(148, 163, 184, .3);
      border-radius: 99px
    }

    .sf-opt {
      display: flex;
      align-items: flex-start;
      gap: 8px;
      padding: 10px 12px;
      cursor: pointer;
      border-bottom: 1px solid rgba(226, 232, 240, .3);
      transition: background .1s;
      font-size: 12px
    }

    .sf-opt:last-child {
      border-bottom: none
    }

    .sf-opt:hover {
      background: rgba(6, 182, 212, .06)
    }

    .sf-opt-pin {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-top: 1px
    }

    .sf-opt-txt {
      flex: 1;
      min-width: 0
    }

    .sf-opt-name {
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis
    }

    .sf-opt-addr {
      font-size: 10px;
      color: #64748b;
      margin-top: 1px;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden
    }

    .sf-msg {
      padding: 12px;
      text-align: center;
      font-size: 11px;
      color: #94a3b8
    }

    .entry-chip {
      display: none;
      align-items: center;
      gap: 7px;
      background: rgba(6, 182, 212, .06);
      border: 1px solid rgba(6, 182, 212, .2);
      border-radius: 8px;
      padding: 7px 10px
    }

    .entry-chip.show {
      display: flex
    }

    .chip-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      flex-shrink: 0
    }

    .chip-name {
      flex: 1;
      font-size: 11px;
      font-weight: 600;
      color: #0891b2;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap
    }

    .chip-coord {
      font-size: 10px;
      color: #64748b;
      white-space: nowrap;
      flex-shrink: 0
    }

    .chip-x {
      width: 18px;
      height: 18px;
      border-radius: 4px;
      background: rgba(8, 145, 178, .1);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      color: #0891b2;
      flex-shrink: 0;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .entry-ta {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      resize: none;
      line-height: 1.6;
      min-height: 60px
    }

    .entry-ta::placeholder {
      color: #94a3b8
    }

    .entry-ta:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px
    }

    .lbl-sm {
      font-size: 9.5px;
      font-weight: 700;
      color: #475569;
      letter-spacing: .4px;
      text-transform: uppercase;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px
    }

    .badge {
      font-size: 9px;
      padding: 1px 6px;
      border-radius: 4px;
      font-weight: 600;
      text-transform: none;
      letter-spacing: 0;
      background: rgba(224, 242, 254, .7);
      color: #0891b2;
      border: 1px solid rgba(8, 145, 178, .2)
    }

    .inp-wrap {
      position: relative
    }

    .inp-wrap .ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .coord-inp {
      width: 100%;
      background: rgba(248, 250, 252, .85);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px 10px 32px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      appearance: none;
      -webkit-appearance: none
    }

    .coord-inp::placeholder {
      color: #94a3b8
    }

    .coord-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-inp::-webkit-inner-spin-button,
    .coord-inp::-webkit-outer-spin-button {
      -webkit-appearance: none
    }

    .map-sec-label {
      font-size: 9.5px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .6px;
      text-transform: uppercase;
      margin-bottom: 8px
    }

    .map-container {
      border-radius: 14px;
      overflow: hidden;
      border: 1.5px solid rgba(6, 182, 212, .2);
      box-shadow: 0 4px 16px rgba(6, 182, 212, .08);
      position: relative
    }

    #map {
      height: 220px;
      width: 100%
    }

    .map-hint {
      position: absolute;
      bottom: 10px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(15, 23, 42, .65);
      backdrop-filter: blur(8px);
      color: #fff;
      font-size: 10px;
      font-weight: 600;
      padding: 5px 12px;
      border-radius: 99px;
      white-space: nowrap;
      pointer-events: none;
      z-index: 10
    }

    .actions {
      display: flex;
      gap: 10px
    }

    .btn-save {
      flex: 1;
      position: relative;
      overflow: hidden;
      background: linear-gradient(120deg, #22d3ee, #3b82f6 55%, #6366f1);
      color: #fff;
      border: none;
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 14px;
      font-weight: 800;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 4px 0 rgba(0, 0, 0, .14), 0 8px 20px rgba(34, 211, 238, .25);
      transition: transform .14s, box-shadow .14s
    }

    .btn-save::before {
      content: '''';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 45%;
      background: linear-gradient(180deg, rgba(255, 255, 255, .15), transparent);
      pointer-events: none
    }

    .btn-save:hover {
      transform: translateY(-2px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 6px 0 rgba(0, 0, 0, .14), 0 12px 28px rgba(34, 211, 238, .32)
    }

    .btn-save:active {
      transform: translateY(2px)
    }

    .btn-save:disabled {
      opacity: .6;
      cursor: not-allowed;
      transform: none
    }

    .ico-circle {
      width: 22px;
      height: 22px;
      border-radius: 7px;
      background: rgba(255, 255, 255, .2);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .btn-skip {
      background: rgba(255, 255, 255, .7);
      color: #64748b;
      border: 1.5px solid rgba(203, 213, 225, .8);
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 13px;
      font-weight: 600;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      white-space: nowrap;
      backdrop-filter: blur(8px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .9);
      transition: all .14s
    }

    .btn-skip:hover {
      background: rgba(255, 255, 255, .9);
      color: #475569;
      transform: translateY(-1px)
    }

    .btn-skip:active {
      transform: translateY(1px)
    }

    .btn-skip:disabled {
      opacity: .5;
      cursor: not-allowed;
      transform: none
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 9999;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(15, 23, 42, .42);
      backdrop-filter: blur(7px);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease
    }

    .overlay.show {
      opacity: 1;
      pointer-events: all
    }

    .ov-box {
      background: rgba(255, 255, 255, .9);
      backdrop-filter: blur(20px);
      border: 1.5px solid rgba(255, 255, 255, .98);
      border-radius: 24px;
      padding: 38px 44px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
      min-width: 210px;
      box-shadow: 0 28px 64px rgba(15, 23, 42, .16);
      transform: scale(.86) translateY(14px);
      opacity: 0;
      transition: transform .32s cubic-bezier(.34, 1.56, .64, 1), opacity .22s ease
    }

    .overlay.show .ov-box {
      transform: scale(1) translateY(0);
      opacity: 1
    }

    .spin-wrap {
      width: 54px;
      height: 54px;
      position: relative;
      flex-shrink: 0
    }

    .spin-wrap svg {
      position: absolute;
      inset: 0;
      animation: ovSpin .85s linear infinite
    }

    @keyframes ovSpin {
      to {
        transform: rotate(360deg)
      }
    }

    .ok-wrap {
      width: 54px;
      height: 54px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 6px 22px rgba(6, 182, 212, .38);
      transform: scale(0);
      transition: transform .36s cubic-bezier(.34, 1.56, .64, 1);
      flex-shrink: 0
    }

    .ok-wrap.pop {
      transform: scale(1)
    }

    .ok-wrap svg path {
      stroke-dasharray: 22;
      stroke-dashoffset: 22;
      transition: stroke-dashoffset .38s ease .18s
    }

    .ok-wrap.pop svg path {
      stroke-dashoffset: 0
    }

    .ov-title {
      font-size: 15px;
      font-weight: 800;
      color: #0f172a;
      text-align: center
    }

    .ov-sub {
      font-size: 11.5px;
      color: #64748b;
      text-align: center;
      margin-top: -4px
    }

    .ov-dots {
      display: flex;
      gap: 5px;
      align-items: center;
      margin-top: 2px
    }

    .ov-dots span {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      animation: ovDot 1s infinite both
    }

    .ov-dots span:nth-child(2) {
      animation-delay: .18s
    }

    .ov-dots span:nth-child(3) {
      animation-delay: .36s
    }

    @keyframes ovDot {

      0%,
      80%,
      100% {
        opacity: .2;
        transform: scale(.75)
      }

      40% {
        opacity: 1;
        transform: scale(1)
      }
    }

    .toast-err {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(20px);
      z-index: 99999;
      background: #fef2f2;
      border: 1.5px solid rgba(220, 38, 38, .25);
      border-radius: 14px;
      padding: 12px 18px;
      display: flex;
      align-items: center;
      gap: 10px;
      box-shadow: 0 8px 24px rgba(220, 38, 38, .15);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease, transform .22s ease;
      white-space: nowrap
    }

    .toast-err.show {
      opacity: 1;
      pointer-events: all;
      transform: translateX(-50%) translateY(0)
    }

    .toast-err-ico {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: #fee2e2;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .toast-err-txt {
      font-size: 12px;
      font-weight: 700;
      color: #dc2626
    }

    /* ---- MEDIA QUERIES ---- */
    @media(max-width:560px) {
      body {
        min-height: 100vh;
        min-height: 100dvh;
        padding: 0;
        align-items: flex-start;
        /* Konten dimulai dari atas */
      }

      .card {
        max-width: 100%;
        padding: 24px 20px 80px;
        /* Padding bawah untuk area scroll */
        border-radius: 0;
        /* Menghilangkan sudut melengkung */
        border: none;
        /* Menghilangkan garis border card */
        box-shadow: none;
        /* Menghilangkan bayangan */
        background: transparent;
        /* Latar belakang card tembus pandang */
        backdrop-filter: none;
        /* Menghilangkan efek glassmorphism pada card */
        min-height: 100vh;
      }

      #map {
        height: 190px
      }

      .actions {
        display: flex;
        flex-direction: column-reverse; /* Reverse button order on mobile */
      }

      .btn-save,
      .btn-skip {
        width: 100%;
        padding: 16px
      }
    }

    @media(max-width:360px) {
      .card {
        padding: 20px 16px 80px
      }
    }
  </style>
</head>

<body>
  <div class="bg">
    <div class="b1"></div>
    <div class="b2"></div>
    <div class="b3"></div>
  </div>
  <div class="overlay" id="overlay">
    <div class="ov-box" id="ovBox"></div>
  </div>
  <div class="toast-err" id="toastErr">
    <div class="toast-err-ico"><svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#dc2626"
        stroke-width="2" stroke-linecap="round">
        <path d="M6 2v4M6 9.5v.5" />
      </svg></div>
    <span class="toast-err-txt" id="toastErrMsg">Isi minimal 1 data sebelum menyimpan</span>
  </div>

  <div class="card">
    <div class="head">
      <div class="head-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="#fff" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round">
          <path d="M10 2C6.686 2 4 4.686 4 8c0 4.5 6 10 6 10s6-5.5 6-10c0-3.314-2.686-6-6-6z" />
          <circle cx="10" cy="8" r="2" />
        </svg>
      </div>
      <div class="head-txt">
        <h2>Informasi Lokasi</h2>
        <p>Cari atau klik peta untuk pilih lokasi</p>
      </div>
    </div>

    <div class="prog-bar">
      <div class="prog-fill" id="pf"></div>
    </div>
    <div class="prog-label"><span id="pt">0 entri diisi</span><span id="pp">0%</span></div>

    <div class="fields">
      <div>
        <div class="sec-header">
          <div class="sec-title">Alamat Rumah</div>
          <button class="add-btn" onclick="window.addEntry(''home'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Alamat
          </button>
        </div>
        <div class="entry-list" id="list-home"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Tempat Praktek</div>
          <button class="add-btn" onclick="window.addEntry(''practice'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Praktek
          </button>
        </div>
        <div class="entry-list" id="list-practice"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Koordinat Aktif</div>
        </div>
        <div class="coord-row">
          <div>
            <div class="lbl-sm">Latitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M7 1v12M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="latitude" placeholder="-6.200000" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
          <div>
            <div class="lbl-sm">Longitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="longitude" placeholder="106.816666" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
        </div>
      </div>
      <div>
        <div class="map-sec-label">Peta Lokasi — Klik untuk pilih koordinat</div>
        <div class="map-container">
          <div id="map"></div>
          <div class="map-hint">Klik peta untuk pilih lokasi</div>
        </div>
      </div>
    </div>

    <!-- Tombol ditukar posisinya -->
    <div class="actions">
      <button class="btn-skip" id="btn-skip" onclick="doSkip()">Lewati</button>
      <button class="btn-save" id="btn-save" onclick="doSave()">
        <div class="ico-circle">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#fff" stroke-width="2.2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M1.5 6h9M7 2l4 4-4 4" />
          </svg>
        </div>
        Simpan Data
      </button>
    </div>
  </div>

  <script>
    // Variabel Peta Global
    var map;
    var marker;

    // --- GOOGLE MAPS INIT ---
    function initMap() {
      var initialPos = { lat: -2.5, lng: 118 };

      map = new google.maps.Map(document.getElementById(''map''), {
        zoom: 5,
        center: initialPos,
        disableDefaultUI: true, // UI bersih
        zoomControl: true,
      });

      // FIX: Menggunakan viewBox yang lebih luas (-1 -1 30 45) agar bentuk path (max Y=42)
      // TIDAK terpotong sedikitpun di ujung jarum bawahnya.
      var svgIcon = {
        url: ''data:image/svg+xml;charset=UTF-8,'' + encodeURIComponent(''<svg width="30" height="45" viewBox="-1 -1 30 45" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M14 0C6.27 0 0 6.27 0 14c0 9.9 14 28 14 28S28 23.9 28 14C28 6.27 21.73 0 14 0z" fill="#ef4444"/><circle cx="14" cy="14" r="6" fill="white"/></svg>''),
        scaledSize: new google.maps.Size(30, 45),
        anchor: new google.maps.Point(15, 43)
      };

      marker = new google.maps.Marker({
        position: initialPos,
        map: map,
        draggable: true,
        icon: svgIcon
      });

      marker.setVisible(false); // Sembunyikan sampai user klik

      map.addListener(''click'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.placeMarker(lat, lng);
        window.reverseGeocode(lat, lng);
      });

      marker.addListener(''dragend'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.setCoords(lat, lng);
        window.reverseGeocode(lat, lng);
      });
    }

    (function () {
      var counters = window.__locationCounters || { home: 0, practice: 0 }, timers = {}, coordTimer = null;
      window.__locationCounters = counters;
      var entries = { home: [], practice: [] };
      var activeEntryId = null;

      // --- CONFIG ---
      var PROXY = ''https://visit-flow-api.flexurio.com/google-maps'';
      var CUSTOMER_ID = (function () {
        try {
          if (window.customerId) return window.customerId;
        } catch (e) { }
        var m = location.search.match(/[?&]id=([^&]+)/);
        return m ? m[1] : null;
      })();

      // ---- FUNGSI UPDATE PETA ----
      window.placeMarker = function (lat, lng) {
        var pos = { lat: parseFloat(lat), lng: parseFloat(lng) };
        if (marker) {
          marker.setPosition(pos);
          marker.setVisible(true);
        }
        if (map) {
          map.panTo(pos);
          map.setZoom(16);
        }
        window.setCoords(lat, lng);
      }

      window.setCoords = function (lat, lng) {
        document.getElementById(''latitude'').value = parseFloat(lat).toFixed(6);
        document.getElementById(''longitude'').value = parseFloat(lng).toFixed(6);
      }

      // ---- REVERSE GEOCODE ----
      window.reverseGeocode = function (lat, lng) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + lat + '','' + lng)
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (d.status === ''OK'' && d.results && d.results.length) {
              var r = d.results[0];
              var full = r.formatted_address || '''';
              var short = r.address_components && r.address_components[0] ? r.address_components[0].long_name : full.split('','')[0];
              applyReverseResult(short, full, lat, lng);
            } else {
              nominatimReverse(lat, lng);
            }
          })
          .catch(function () { nominatimReverse(lat, lng); });
      }
      function nominatimReverse(lat, lng) {
        fetch(''https://nominatim.openstreetmap.org/reverse?format=json&lat='' + lat + ''&lon='' + lng + ''&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (d) {
            var full = d.display_name || '''';
            var short = full.split('','')[0];
            applyReverseResult(short, full, lat, lng);
          })
          .catch(function () { });
      }
      function applyReverseResult(short, full, lat, lng) {
        var id = activeEntryId;
        if (!id) { var all = entries.home.concat(entries.practice); if (all.length) id = all[all.length - 1]; }
        if (!id) return;
        var entry = document.getElementById(''entry-'' + id); if (!entry) return;
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        var sfw = document.getElementById(''sfw-'' + id);
        if (sfw) {
          var type = id.split(''-'')[0];
          if (type === ''home'') {
            sfw.querySelector(''.sf-inp'').value = short;
            sfw.querySelector(''.sf-clr'').classList.add(''show'');
            document.getElementById(''cn-'' + id).textContent = short;
          }
        }
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entryData = entryStore[id];
        if (entryData) { entryData.lat = parseFloat(lat); entryData.lng = parseFloat(lng); }
        updProg();
      }

      // ---- SEARCH ----
      function doSearch(q, id, drop) {
        fetch(PROXY + ''/places/autocomplete?input='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (data) {
            if (data.status === ''OK'' && data.predictions && data.predictions.length) {
              renderGoogleResults(data.predictions, id, drop);
            } else {
              fallbackNominatim(q, id, drop);
            }
          })
          .catch(function () { fallbackNominatim(q, id, drop); });
      }
      function renderGoogleResults(preds, id, drop) {
        drop.innerHTML = '''';
        preds.forEach(function (pred) {
          var el = document.createElement(''div'');
          el.className = ''sf-opt'';
          var main = pred.structured_formatting.main_text;
          var sec = pred.structured_formatting.secondary_text || '''';
          el.innerHTML =
            ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
            ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + main + ''</div><div class="sf-opt-addr">'' + sec + ''</div></div>'';
          el.addEventListener(''click'', function () {
            drop.classList.remove(''open'');
            fetch(PROXY + ''/places/details?place_id='' + encodeURIComponent(pred.place_id))
              .then(function (r) { return r.json(); })
              .then(function (d) {
                if (!d.result) return;
                var lat = d.result.geometry.location.lat;
                var lng = d.result.geometry.location.lng;
                var name = d.result.name || main;
                var full = d.result.formatted_address || main + '', '' + sec;
                selectPlace(id, name, full, lat, lng);
              })
              .catch(function () { geocodeText(main + '' '' + sec, id); });
          });
          drop.appendChild(el);
        });
      }
      function fallbackNominatim(q, id, drop) {
        fetch(''https://nominatim.openstreetmap.org/search?format=json&q='' + encodeURIComponent(q) + ''&limit=6&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (res) {
            if (!res.length) { drop.innerHTML = ''<div class="sf-msg">Tidak ditemukan</div>''; return; }
            drop.innerHTML = '''';
            res.forEach(function (item) {
              var el = document.createElement(''div'');
              el.className = ''sf-opt'';
              var short = item.display_name.split('','')[0];
              el.innerHTML =
                ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
                ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + short + ''</div><div class="sf-opt-addr">'' + item.display_name + ''</div></div>'';
              el.addEventListener(''click'', function () {
                drop.classList.remove(''open'');
                var lat = parseFloat(item.lat), lng = parseFloat(item.lon);
                selectPlace(id, short, item.display_name, lat, lng);
              });
              drop.appendChild(el);
            });
          })
          .catch(function () { drop.innerHTML = ''<div class="sf-msg">Gagal mencari</div>''; });
      }
      function geocodeText(q, id) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (!d.results || !d.results.length) return;
            var r = d.results[0];
            var lat = r.geometry.location.lat, lng = r.geometry.location.lng;
            var name = r.address_components[0].long_name;
            selectPlace(id, name, r.formatted_address, lat, lng);
          });
      }

      var entryStore = {};

      function selectPlace(id, name, full, lat, lng) {
        window.placeMarker(lat, lng);
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = name;
        sfw.querySelector(''.sf-clr'').classList.add(''show'');
        document.getElementById(''cn-'' + id).textContent = name;
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        if (!entryStore[id]) entryStore[id] = {};
        entryStore[id].location_name = name;
        entryStore[id].lat = lat;
        entryStore[id].lng = lng;
        updProg();
      }

      // ---- ADD ENTRY (Sudah support Initial Data) ----
      function addEntry(type, initialData) {
        var num = ++counters[type];
        var id = type + ''-'' + num;
        var isHome = type === ''home'';
        var isPrefilled = !!initialData && Object.keys(initialData).length > 0;

        var el = document.createElement(''div'');
        // Jika data lama, otomatis tambahkan class .is-collapsed dan .is-disabled
        el.className = ''entry'' + (isPrefilled ? '' is-disabled is-collapsed'' : '''');
        el.id = ''entry-'' + id;

        var ph = isHome ? ''Cari alamat rumah...'' : ''Cari klinik, RS, puskesmas...'';
        var taph = isHome ? ''Jl. Contoh No. 123, RT/RW, Kelurahan...'' : ''Alamat lengkap tempat praktek...'';

        // Set nilai dari DB
        var locId = isPrefilled ? initialData.id : null;
        var locName = isPrefilled ? (initialData.location_name || '''') : '''';
        var locAddr = isPrefilled ? (initialData.location_address || '''') : '''';
        var lat = (isPrefilled && initialData.latitude != null) ? initialData.latitude : null;
        var lng = (isPrefilled && initialData.longitude != null) ? initialData.longitude : null;
        var isActive = (initialData && initialData.hasOwnProperty(''is_active'')) ? initialData.is_active : true;

        var chipName = locName || (locAddr.split('','')[0]) || ''Lokasi'';
        var chipCoord = (lat != null && lng != null) ? parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4) : '''';
        var showChip = isPrefilled ? '' show'' : '''';

        // Tombol X hapus tidak ditampilkan jika prefilled dari DB
        var delBtnHtml = !isPrefilled ? ''<button class="entry-del" onclick="delEntry(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' : '''';

        // Nama custom header jika prefilled
        var titleName = isPrefilled && locName ? '' - '' + locName : '''';

        el.innerHTML =
          ''<div class="entry-head" style="cursor:pointer;" title="Klik untuk Expand/Minimize">'' +
          ''<div class="entry-num">'' + (isHome ? ''Rumah'' : ''Praktek'') + '' #'' + num + titleName + ''</div>'' +
          ''<div class="actions-group">'' +
          delBtnHtml +
          ''<button class="entry-toggle" type="button"><svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M2 8L6 4L10 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg></button>'' +
          ''</div>'' +
          ''</div>'' +
          ''<div class="entry-inner">'' +
          ''<div class="sf-wrap" id="sfw-'' + id + ''">'' +
          ''<svg class="sf-ico" viewBox="0 0 15 15" fill="none" stroke="#94a3b8" stroke-width="1.4" stroke-linecap="round"><circle cx="6.5" cy="6.5" r="4"/><path d="M10 10l3 3"/></svg>'' +
          ''<input class="sf-inp" type="text" placeholder="'' + ph + ''" autocomplete="off" value="'' + locName + ''"'' +
          '' oninput="onSF(this,\\'''' + id + ''\\'')"'' +
          '' onfocus="setActive(\\'''' + id + ''\\'');openDrop(\\'''' + id + ''\\'')">'' +
          ''<button class="sf-clr'' + (isPrefilled ? '' show'' : '''') + ''" onclick="clearSF(\\'''' + id + ''\\'')">×</button>'' +
          ''<div class="sf-drop" id="drop-'' + id + ''"></div>'' +
          ''</div>'' +
          ''<div class="entry-chip'' + showChip + ''" id="chip-'' + id + ''">'' +
          ''<div class="chip-dot"></div>'' +
          ''<div class="chip-name" id="cn-'' + id + ''">'' + chipName + ''</div>'' +
          ''<div class="chip-coord" id="cc-'' + id + ''">'' + chipCoord + ''</div>'' +
          ''<button class="chip-x" onclick="clearChip(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' +
          ''</div>'' +
          ''<textarea class="entry-ta" placeholder="'' + taph + ''" oninput="updProg()">'' + locAddr + ''</textarea>'' +
          ''<div class="field">'' +
          ''<div class="switch-wrap">'' +
          ''<div class="switch-lbl"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 12L11 14L15 10" stroke-linecap="round" stroke-linejoin="round"/></svg>Status Aktif</div>'' +
          ''<label class="switch"><input type="checkbox" class="act-check"'' + (isActive ? '' checked'' : '''') + ''><span class="slider"></span></label>'' +
          ''</div>'' +
          ''</div>'' +
          ''</div>'';

        document.getElementById(''list-'' + type).appendChild(el);

        entries[type].push(id);
        entryStore[id] = {
          id: locId,
          location_name: locName,
          lat: lat,
          lng: lng,
          is_active: isActive,
          isNew: !isPrefilled // Tracking agar data lama tidak di-submit ulang
        };

        var activeInp = el.querySelector(''.act-check'');
        activeInp.addEventListener(''change'', function () {
          entryStore[id].is_active = activeInp.checked;
          updProg();
        });

        // Tetap izinkan switch status aktif diubah untuk data lama
        if (isPrefilled) {
          el.querySelector(''.switch-wrap'').style.pointerEvents = ''auto'';
        }

        // Toggle Expand/Minimize Listener
        el.querySelector(''.entry-head'').addEventListener(''click'', function (e) {
          if (e.target.closest(''.entry-del'')) return;
          el.classList.toggle(''is-collapsed'');
        });

        updProg();
      }
      // EKSPOS FUNGSI AGAR BISA DIPANGGIL GOLANG
      window.addEntry = addEntry;

      function delEntry(id, type) {
        var el = document.getElementById(''entry-'' + id); if (el) el.remove();
        entries[type] = entries[type].filter(function (e) { return e !== id; });
        delete entryStore[id];
        if (activeEntryId === id) activeEntryId = null;
        updProg();
      }
      window.delEntry = delEntry;

      function onSF(inp, id) {
        var q = inp.value.trim();
        inp.nextElementSibling.classList.toggle(''show'', q.length > 0);
        clearTimeout(timers[id]);
        var drop = document.getElementById(''drop-'' + id);
        if (q.length < 2) { drop.classList.remove(''open''); return; }
        drop.classList.add(''open'');
        drop.innerHTML = ''<div class="sf-msg">Mencari...</div>'';
        timers[id] = setTimeout(function () { doSearch(q, id, drop); }, 500);
      }
      window.onSF = onSF;

      function openDrop(id) {
        var inp = document.getElementById(''sfw-'' + id).querySelector(''.sf-inp'');
        if (inp.value.trim().length >= 2) document.getElementById(''drop-'' + id).classList.add(''open'');
      }
      window.openDrop = openDrop;

      function setActive(id) { activeEntryId = id; }
      window.setActive = setActive;

      function clearSF(id) {
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = '''';
        sfw.querySelector(''.sf-clr'').classList.remove(''show'');
        document.getElementById(''drop-'' + id).classList.remove(''open'');
      }
      window.clearSF = clearSF;

      function clearChip(id, type) {
        document.getElementById(''chip-'' + id).classList.remove(''show'');
        clearSF(id);
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = '''';
        if (entryStore[id]) entryStore[id] = {};
        updProg();
      }
      window.clearChip = clearChip;

      document.addEventListener(''click'', function (e) {
        document.querySelectorAll(''.sf-drop.open'').forEach(function (d) {
          if (!d.closest(''.sf-wrap'').contains(e.target)) d.classList.remove(''open'');
        });
      });

      function onCoordInput() {
        clearTimeout(coordTimer);
        coordTimer = setTimeout(function () {
          var lat = parseFloat(document.getElementById(''latitude'').value);
          var lng = parseFloat(document.getElementById(''longitude'').value);
          if (!isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            var pos = { lat: lat, lng: lng };
            if (marker && map) {
              marker.setPosition(pos);
              marker.setVisible(true);
              map.panTo(pos);
              map.setZoom(16);
            }
          }
        }, 800);
      }
      window.onCoordInput = onCoordInput;

      function updProg() {
        var total = 0, filled = 0;
        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            total++;
            var ta = entry.querySelector(''.entry-ta'');
            if (ta && ta.value.trim()) filled++;
          });
        });
        var pct = total > 0 ? Math.round(filled / total * 100) : 0;
        document.getElementById(''pf'').style.width = pct + ''%'';
        document.getElementById(''pt'').textContent = filled + '' dari '' + total + '' entri diisi'';
        document.getElementById(''pp'').textContent = pct + ''%'';
      }
      window.updProg = updProg;

      var overlay = document.getElementById(''overlay''), ovBox = document.getElementById(''ovBox'');
      function showLoading(msg) {
        ovBox.innerHTML = ''<div class="spin-wrap"><svg width="54" height="54" viewBox="0 0 54 54" fill="none"><circle cx="27" cy="27" r="22" stroke="rgba(6,182,212,.14)" stroke-width="4.5"/><circle cx="27" cy="27" r="22" stroke="url(#g1)" stroke-width="4.5" stroke-linecap="round" stroke-dasharray="94 46"/><defs><linearGradient id="g1" x1="0" y1="0" x2="54" y2="0"><stop offset="0%" stop-color="#06b6d4"/><stop offset="100%" stop-color="#3b82f6"/></linearGradient></defs></svg></div><div class="ov-title">'' + (msg || ''Menyimpan...'') + ''</div><div class="ov-dots"><span></span><span></span><span></span></div>'';
        overlay.classList.add(''show'');
      }
      function showSuccess(title, sub) {
        ovBox.innerHTML = ''<div class="ok-wrap" id="okWrap"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12l5.5 5.5L20 7"/></svg></div><div class="ov-title">'' + (title || ''Tersimpan!'') + ''</div><div class="ov-sub">'' + (sub || '''') + ''</div>'';
        requestAnimationFrame(function () { requestAnimationFrame(function () { var w = document.getElementById(''okWrap''); if (w) w.classList.add(''pop''); }); });
      }
      function hideOverlay() { overlay.classList.remove(''show''); }
      function setBtns(d) { document.getElementById(''btn-save'').disabled = d; document.getElementById(''btn-skip'').disabled = d; }

      var toastErr = document.getElementById(''toastErr''), toastTimer = null;
      function showToastErr(msg) {
        document.getElementById(''toastErrMsg'').textContent = msg || ''Isi minimal 1 data sebelum menyimpan'';
        toastErr.classList.add(''show'');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toastErr.classList.remove(''show''); }, 2800);
      }

      function doSave() {
        var payload = [];
        var adaDataLama = false;

        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var store = entryStore[id] || {};

            // Skip data dari DB agar tidak disubmit ulang
            // Hanya skip jika isNew=false DAN is_active=true (tidak ada perubahan status)
            // Namun agar lebih aman dan simple sesuai request, kita kirimkan jika isNew=true ATAU (bukan isNew tapi is_active diubah)
            // Agar backend bisa handle update status nonaktif, kita kirim semua yang ada.
            
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            var ta = entry.querySelector(''.entry-ta'');
            var location_address = (ta && ta.value.trim()) || null;
            var location_name = store.location_name || null;
            var latitude = store.lat !== undefined ? store.lat : null;
            var longitude = store.lng !== undefined ? store.lng : null;
            var is_active = store.is_active;

            if (!location_address && !location_name && latitude === null && !store.id) return;

            payload.push({
              id: store.id || null,
              flag: type === ''home'' ? ''rumah'' : ''praktek'',
              location_name: location_name,
              location_address: location_address,
              latitude: latitude,
              longitude: longitude,
              is_active: is_active
            });
          });
        });

        if (payload.length === 0) {
          showToastErr(adaDataLama ? ''Tambahkan minimal 1 data baru untuk disimpan'' : ''Isi minimal 1 data lokasi sebelum menyimpan'');
          var btn = document.getElementById(''btn-save'');
          btn.style.transition = ''transform .08s ease'';
          var s = [-6, 6, -5, 5, -3, 3, 0], i = 0;
          (function shake() { if (i < s.length) { btn.style.transform = ''translateX('' + s[i++] + ''px)''; setTimeout(shake, 60); } else { btn.style.transform = ''''; btn.style.transition = ''''; } }());
          return;
        }

        setBtns(true);
        showLoading(''Menyimpan data...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SUBMIT_LOCATION'', input_value: payload });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSave]'', msg); }
          showSuccess(''Data Tersimpan!'', ''Lokasi berhasil disimpan'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1800);
        }, 900);
      }
      window.doSave = doSave;

      function doSkip() {
        setBtns(true);
        showLoading(''Melewati langkah ini...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SKIP_LOCATION'', input_value: null });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSkip]'', msg); }
          showSuccess(''Langkah Dilewati'', ''Kamu bisa melengkapi lokasi nanti'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1600);
        }, 700);
      }
      window.doSkip = doSkip;
    })();
  </script>
  <!-- SCRIPT GOOGLE MAPS API -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKHM_SHT0BmNh3fRwVrbtZDUFmtqobYXI&callback=initMap"
    async defer></script>
</body>

</html>'),
  (63493, 0, '2026-08-05 02:13:11.888000', 0, '2026-08-05 02:13:11.888000', NULL, NULL, 1251119, '202608', 'JOGA1S2', 'CUSTOMER LOCATION', '24010141', '<!DOCTYPE html>
<html lang="id">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Informasi Lokasi Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
    rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      -webkit-tap-highlight-color: transparent
    }

    body {
      min-height: 100vh;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      background: #f0f7ff;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px 60px;
      position: relative;
      overflow-x: hidden
    }

    .bg {
      position: fixed;
      inset: 0;
      z-index: 0;
      pointer-events: none
    }

    .b1 {
      position: absolute;
      width: 500px;
      height: 500px;
      top: -15%;
      left: -10%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #bae6fd, #e0f2fe)
    }

    .b2 {
      position: absolute;
      width: 450px;
      height: 450px;
      bottom: -10%;
      right: -8%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #c7d2fe, #ddd6fe)
    }

    .b3 {
      position: absolute;
      width: 350px;
      height: 350px;
      top: 40%;
      left: 35%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .35;
      background: radial-gradient(circle, #a7f3d0, #d1fae5)
    }

    .card {
      position: relative;
      z-index: 1;
      background: rgba(255, 255, 255, .62);
      backdrop-filter: blur(24px);
      border: 1.5px solid rgba(255, 255, 255, .92);
      border-radius: 28px;
      padding: 36px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(15, 23, 42, .09), 0 4px 16px rgba(15, 23, 42, .05)
    }

    .head {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 24px
    }

    .head-icon {
      width: 44px;
      height: 44px;
      border-radius: 13px;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 14px rgba(6, 182, 212, .35);
      flex-shrink: 0
    }

    .head-txt h2 {
      font-size: 16px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -.3px
    }

    .head-txt p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px
    }

    .prog-bar {
      height: 4px;
      background: rgba(15, 23, 42, .07);
      border-radius: 99px;
      overflow: hidden;
      margin-bottom: 6px
    }

    .prog-fill {
      height: 100%;
      border-radius: 99px;
      background: linear-gradient(90deg, #06b6d4, #3b82f6);
      width: 0%;
      transition: width .35s ease
    }

    .prog-label {
      display: flex;
      justify-content: space-between;
      font-size: 10px;
      color: #94a3b8;
      font-weight: 600;
      margin-bottom: 24px
    }

    .sec-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
      margin-top: 4px
    }

    .sec-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .8px;
      text-transform: uppercase
    }

    .sec-title::before {
      content: '''';
      width: 20px;
      height: 1px;
      background: rgba(148, 163, 184, .25)
    }

    .add-btn {
      display: flex;
      align-items: center;
      gap: 5px;
      background: linear-gradient(135deg, rgba(6, 182, 212, .1), rgba(59, 130, 246, .08));
      border: 1.5px solid rgba(6, 182, 212, .25);
      border-radius: 8px;
      padding: 5px 10px;
      font-size: 10px;
      font-weight: 700;
      color: #0891b2;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .add-btn:hover {
      background: linear-gradient(135deg, rgba(6, 182, 212, .18), rgba(59, 130, 246, .14))
    }

    .fields {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 24px
    }

    .entry-list {
      display: flex;
      flex-direction: column;
      gap: 10px
    }

    .entry {
      background: rgba(248, 250, 252, .6);
      border: 1.5px solid rgba(226, 232, 240, .8);
      border-radius: 14px;
      padding: 14px;
      transition: border-color .18s
    }

    .entry:focus-within {
      border-color: rgba(6, 182, 212, .3);
      background: rgba(255, 255, 255, .8)
    }

    /* Header & Toggle Actions */
    .entry-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
      user-select: none;
    }

    .entry-num {
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .5px;
      text-transform: uppercase;
      transition: color .2s;
    }

    .actions-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .entry-del {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(220, 38, 38, .08);
      border: 1px solid rgba(220, 38, 38, .15);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      color: #dc2626;
      opacity: .6;
      transition: opacity .15s;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      line-height: 1
    }

    .entry-del:hover {
      opacity: 1
    }

    .entry-toggle {
      width: 24px;
      height: 24px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      border: 1px solid rgba(6, 182, 212, .2);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #0891b2;
      transition: background .15s;
    }

    .entry-toggle:hover {
      background: rgba(6, 182, 212, .2);
    }

    .entry-toggle svg {
      transition: transform .3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .entry.is-collapsed .entry-toggle svg {
      transform: rotate(180deg);
    }

    /* Content Body */
    .entry-inner {
      display: flex;
      flex-direction: column;
      gap: 8px
    }

    .entry.is-collapsed .entry-inner {
      display: none !important;
    }

    .entry.is-collapsed .entry-head {
      margin-bottom: 0;
    }

    /* State Disabled (Data dari Database) */
    .entry.is-disabled {
      background: rgba(241, 245, 249, 0.7);
      border-color: rgba(203, 213, 225, 0.5);
      opacity: 0.9;
    }

    .entry.is-disabled .entry-inner {
      pointer-events: none;
      /* Mematikan klik form */
    }

    .entry.is-disabled .sf-inp,
    .entry.is-disabled .entry-ta {
      background: transparent;
      box-shadow: none;
      border-color: rgba(226, 232, 240, 0.6);
      color: #64748b;
      font-weight: 600;
    }

    .entry.is-disabled .sf-clr,
    .entry.is-disabled .chip-x {
      display: none !important;
    }

    /* ------------------------------------- */

    .sf-wrap {
      position: relative
    }

    .sf-ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .sf-inp {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 32px 10px 34px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s
    }

    .sf-inp::placeholder {
      color: #94a3b8
    }

    .sf-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    /* Switch Toggle Styles */
    .switch-wrap {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 14px;
      background: rgba(255, 255, 255, .4);
      border: 1px solid rgba(226, 232, 240, .8);
      border-radius: 12px;
      margin-top: 5px
    }

    .switch-lbl {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      display: flex;
      align-items: center;
      gap: 6px
    }

    .switch {
      position: relative;
      display: inline-block;
      width: 38px;
      height: 22px
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #cbd5e1;
      transition: .3s;
      border-radius: 22px
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 2px;
      bottom: 2px;
      background-color: white;
      transition: .3s;
      border-radius: 50%;
      box-shadow: 0 2px 4px rgba(0, 0, 0, .1)
    }

    input:checked+.slider {
      background: linear-gradient(135deg, #06b6d4, #3b82f6)
    }

    input:checked+.slider:before {
      transform: translateX(16px)
    }

    .sf-clr {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      border-radius: 5px;
      background: rgba(148, 163, 184, .12);
      border: none;
      cursor: pointer;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: #94a3b8;
      z-index: 1;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .sf-clr.show {
      display: flex
    }

    .sf-drop {
      position: absolute;
      top: calc(100% + 4px);
      left: 0;
      right: 0;
      background: #fff;
      border: 1.5px solid rgba(6, 182, 212, .2);
      border-radius: 10px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, .12);
      z-index: 600;
      max-height: 200px;
      overflow-y: auto;
      display: none
    }

    .sf-drop.open {
      display: block
    }

    .sf-drop::-webkit-scrollbar {
      width: 3px
    }

    .sf-drop::-webkit-scrollbar-thumb {
      background: rgba(148, 163, 184, .3);
      border-radius: 99px
    }

    .sf-opt {
      display: flex;
      align-items: flex-start;
      gap: 8px;
      padding: 10px 12px;
      cursor: pointer;
      border-bottom: 1px solid rgba(226, 232, 240, .3);
      transition: background .1s;
      font-size: 12px
    }

    .sf-opt:last-child {
      border-bottom: none
    }

    .sf-opt:hover {
      background: rgba(6, 182, 212, .06)
    }

    .sf-opt-pin {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-top: 1px
    }

    .sf-opt-txt {
      flex: 1;
      min-width: 0
    }

    .sf-opt-name {
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis
    }

    .sf-opt-addr {
      font-size: 10px;
      color: #64748b;
      margin-top: 1px;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden
    }

    .sf-msg {
      padding: 12px;
      text-align: center;
      font-size: 11px;
      color: #94a3b8
    }

    .entry-chip {
      display: none;
      align-items: center;
      gap: 7px;
      background: rgba(6, 182, 212, .06);
      border: 1px solid rgba(6, 182, 212, .2);
      border-radius: 8px;
      padding: 7px 10px
    }

    .entry-chip.show {
      display: flex
    }

    .chip-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      flex-shrink: 0
    }

    .chip-name {
      flex: 1;
      font-size: 11px;
      font-weight: 600;
      color: #0891b2;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap
    }

    .chip-coord {
      font-size: 10px;
      color: #64748b;
      white-space: nowrap;
      flex-shrink: 0
    }

    .chip-x {
      width: 18px;
      height: 18px;
      border-radius: 4px;
      background: rgba(8, 145, 178, .1);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      color: #0891b2;
      flex-shrink: 0;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .entry-ta {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      resize: none;
      line-height: 1.6;
      min-height: 60px
    }

    .entry-ta::placeholder {
      color: #94a3b8
    }

    .entry-ta:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px
    }

    .lbl-sm {
      font-size: 9.5px;
      font-weight: 700;
      color: #475569;
      letter-spacing: .4px;
      text-transform: uppercase;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px
    }

    .badge {
      font-size: 9px;
      padding: 1px 6px;
      border-radius: 4px;
      font-weight: 600;
      text-transform: none;
      letter-spacing: 0;
      background: rgba(224, 242, 254, .7);
      color: #0891b2;
      border: 1px solid rgba(8, 145, 178, .2)
    }

    .inp-wrap {
      position: relative
    }

    .inp-wrap .ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .coord-inp {
      width: 100%;
      background: rgba(248, 250, 252, .85);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px 10px 32px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      appearance: none;
      -webkit-appearance: none
    }

    .coord-inp::placeholder {
      color: #94a3b8
    }

    .coord-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-inp::-webkit-inner-spin-button,
    .coord-inp::-webkit-outer-spin-button {
      -webkit-appearance: none
    }

    .map-sec-label {
      font-size: 9.5px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .6px;
      text-transform: uppercase;
      margin-bottom: 8px
    }

    .map-container {
      border-radius: 14px;
      overflow: hidden;
      border: 1.5px solid rgba(6, 182, 212, .2);
      box-shadow: 0 4px 16px rgba(6, 182, 212, .08);
      position: relative
    }

    #map {
      height: 220px;
      width: 100%
    }

    .map-hint {
      position: absolute;
      bottom: 10px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(15, 23, 42, .65);
      backdrop-filter: blur(8px);
      color: #fff;
      font-size: 10px;
      font-weight: 600;
      padding: 5px 12px;
      border-radius: 99px;
      white-space: nowrap;
      pointer-events: none;
      z-index: 10
    }

    .actions {
      display: flex;
      gap: 10px
    }

    .btn-save {
      flex: 1;
      position: relative;
      overflow: hidden;
      background: linear-gradient(120deg, #22d3ee, #3b82f6 55%, #6366f1);
      color: #fff;
      border: none;
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 14px;
      font-weight: 800;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 4px 0 rgba(0, 0, 0, .14), 0 8px 20px rgba(34, 211, 238, .25);
      transition: transform .14s, box-shadow .14s
    }

    .btn-save::before {
      content: '''';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 45%;
      background: linear-gradient(180deg, rgba(255, 255, 255, .15), transparent);
      pointer-events: none
    }

    .btn-save:hover {
      transform: translateY(-2px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 6px 0 rgba(0, 0, 0, .14), 0 12px 28px rgba(34, 211, 238, .32)
    }

    .btn-save:active {
      transform: translateY(2px)
    }

    .btn-save:disabled {
      opacity: .6;
      cursor: not-allowed;
      transform: none
    }

    .ico-circle {
      width: 22px;
      height: 22px;
      border-radius: 7px;
      background: rgba(255, 255, 255, .2);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .btn-skip {
      background: rgba(255, 255, 255, .7);
      color: #64748b;
      border: 1.5px solid rgba(203, 213, 225, .8);
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 13px;
      font-weight: 600;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      white-space: nowrap;
      backdrop-filter: blur(8px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .9);
      transition: all .14s
    }

    .btn-skip:hover {
      background: rgba(255, 255, 255, .9);
      color: #475569;
      transform: translateY(-1px)
    }

    .btn-skip:active {
      transform: translateY(1px)
    }

    .btn-skip:disabled {
      opacity: .5;
      cursor: not-allowed;
      transform: none
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 9999;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(15, 23, 42, .42);
      backdrop-filter: blur(7px);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease
    }

    .overlay.show {
      opacity: 1;
      pointer-events: all
    }

    .ov-box {
      background: rgba(255, 255, 255, .9);
      backdrop-filter: blur(20px);
      border: 1.5px solid rgba(255, 255, 255, .98);
      border-radius: 24px;
      padding: 38px 44px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
      min-width: 210px;
      box-shadow: 0 28px 64px rgba(15, 23, 42, .16);
      transform: scale(.86) translateY(14px);
      opacity: 0;
      transition: transform .32s cubic-bezier(.34, 1.56, .64, 1), opacity .22s ease
    }

    .overlay.show .ov-box {
      transform: scale(1) translateY(0);
      opacity: 1
    }

    .spin-wrap {
      width: 54px;
      height: 54px;
      position: relative;
      flex-shrink: 0
    }

    .spin-wrap svg {
      position: absolute;
      inset: 0;
      animation: ovSpin .85s linear infinite
    }

    @keyframes ovSpin {
      to {
        transform: rotate(360deg)
      }
    }

    .ok-wrap {
      width: 54px;
      height: 54px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 6px 22px rgba(6, 182, 212, .38);
      transform: scale(0);
      transition: transform .36s cubic-bezier(.34, 1.56, .64, 1);
      flex-shrink: 0
    }

    .ok-wrap.pop {
      transform: scale(1)
    }

    .ok-wrap svg path {
      stroke-dasharray: 22;
      stroke-dashoffset: 22;
      transition: stroke-dashoffset .38s ease .18s
    }

    .ok-wrap.pop svg path {
      stroke-dashoffset: 0
    }

    .ov-title {
      font-size: 15px;
      font-weight: 800;
      color: #0f172a;
      text-align: center
    }

    .ov-sub {
      font-size: 11.5px;
      color: #64748b;
      text-align: center;
      margin-top: -4px
    }

    .ov-dots {
      display: flex;
      gap: 5px;
      align-items: center;
      margin-top: 2px
    }

    .ov-dots span {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      animation: ovDot 1s infinite both
    }

    .ov-dots span:nth-child(2) {
      animation-delay: .18s
    }

    .ov-dots span:nth-child(3) {
      animation-delay: .36s
    }

    @keyframes ovDot {

      0%,
      80%,
      100% {
        opacity: .2;
        transform: scale(.75)
      }

      40% {
        opacity: 1;
        transform: scale(1)
      }
    }

    .toast-err {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(20px);
      z-index: 99999;
      background: #fef2f2;
      border: 1.5px solid rgba(220, 38, 38, .25);
      border-radius: 14px;
      padding: 12px 18px;
      display: flex;
      align-items: center;
      gap: 10px;
      box-shadow: 0 8px 24px rgba(220, 38, 38, .15);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease, transform .22s ease;
      white-space: nowrap
    }

    .toast-err.show {
      opacity: 1;
      pointer-events: all;
      transform: translateX(-50%) translateY(0)
    }

    .toast-err-ico {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: #fee2e2;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .toast-err-txt {
      font-size: 12px;
      font-weight: 700;
      color: #dc2626
    }

    /* ---- MEDIA QUERIES ---- */
    @media(max-width:560px) {
      body {
        min-height: 100vh;
        min-height: 100dvh;
        padding: 0;
        align-items: flex-start;
        /* Konten dimulai dari atas */
      }

      .card {
        max-width: 100%;
        padding: 24px 20px 80px;
        /* Padding bawah untuk area scroll */
        border-radius: 0;
        /* Menghilangkan sudut melengkung */
        border: none;
        /* Menghilangkan garis border card */
        box-shadow: none;
        /* Menghilangkan bayangan */
        background: transparent;
        /* Latar belakang card tembus pandang */
        backdrop-filter: none;
        /* Menghilangkan efek glassmorphism pada card */
        min-height: 100vh;
      }

      #map {
        height: 190px
      }

      .actions {
        display: flex;
        flex-direction: column-reverse; /* Reverse button order on mobile */
      }

      .btn-save,
      .btn-skip {
        width: 100%;
        padding: 16px
      }
    }

    @media(max-width:360px) {
      .card {
        padding: 20px 16px 80px
      }
    }
  </style>
</head>

<body>
  <div class="bg">
    <div class="b1"></div>
    <div class="b2"></div>
    <div class="b3"></div>
  </div>
  <div class="overlay" id="overlay">
    <div class="ov-box" id="ovBox"></div>
  </div>
  <div class="toast-err" id="toastErr">
    <div class="toast-err-ico"><svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#dc2626"
        stroke-width="2" stroke-linecap="round">
        <path d="M6 2v4M6 9.5v.5" />
      </svg></div>
    <span class="toast-err-txt" id="toastErrMsg">Isi minimal 1 data sebelum menyimpan</span>
  </div>

  <div class="card">
    <div class="head">
      <div class="head-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="#fff" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round">
          <path d="M10 2C6.686 2 4 4.686 4 8c0 4.5 6 10 6 10s6-5.5 6-10c0-3.314-2.686-6-6-6z" />
          <circle cx="10" cy="8" r="2" />
        </svg>
      </div>
      <div class="head-txt">
        <h2>Informasi Lokasi</h2>
        <p>Cari atau klik peta untuk pilih lokasi</p>
      </div>
    </div>

    <div class="prog-bar">
      <div class="prog-fill" id="pf"></div>
    </div>
    <div class="prog-label"><span id="pt">0 entri diisi</span><span id="pp">0%</span></div>

    <div class="fields">
      <div>
        <div class="sec-header">
          <div class="sec-title">Alamat Rumah</div>
          <button class="add-btn" onclick="window.addEntry(''home'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Alamat
          </button>
        </div>
        <div class="entry-list" id="list-home"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Tempat Praktek</div>
          <button class="add-btn" onclick="window.addEntry(''practice'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Praktek
          </button>
        </div>
        <div class="entry-list" id="list-practice"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Koordinat Aktif</div>
        </div>
        <div class="coord-row">
          <div>
            <div class="lbl-sm">Latitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M7 1v12M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="latitude" placeholder="-6.200000" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
          <div>
            <div class="lbl-sm">Longitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="longitude" placeholder="106.816666" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
        </div>
      </div>
      <div>
        <div class="map-sec-label">Peta Lokasi — Klik untuk pilih koordinat</div>
        <div class="map-container">
          <div id="map"></div>
          <div class="map-hint">Klik peta untuk pilih lokasi</div>
        </div>
      </div>
    </div>

    <!-- Tombol ditukar posisinya -->
    <div class="actions">
      <button class="btn-skip" id="btn-skip" onclick="doSkip()">Lewati</button>
      <button class="btn-save" id="btn-save" onclick="doSave()">
        <div class="ico-circle">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#fff" stroke-width="2.2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M1.5 6h9M7 2l4 4-4 4" />
          </svg>
        </div>
        Simpan Data
      </button>
    </div>
  </div>

  <script>
    // Variabel Peta Global
    var map;
    var marker;

    // --- GOOGLE MAPS INIT ---
    function initMap() {
      var initialPos = { lat: -2.5, lng: 118 };

      map = new google.maps.Map(document.getElementById(''map''), {
        zoom: 5,
        center: initialPos,
        disableDefaultUI: true, // UI bersih
        zoomControl: true,
      });

      // FIX: Menggunakan viewBox yang lebih luas (-1 -1 30 45) agar bentuk path (max Y=42)
      // TIDAK terpotong sedikitpun di ujung jarum bawahnya.
      var svgIcon = {
        url: ''data:image/svg+xml;charset=UTF-8,'' + encodeURIComponent(''<svg width="30" height="45" viewBox="-1 -1 30 45" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M14 0C6.27 0 0 6.27 0 14c0 9.9 14 28 14 28S28 23.9 28 14C28 6.27 21.73 0 14 0z" fill="#ef4444"/><circle cx="14" cy="14" r="6" fill="white"/></svg>''),
        scaledSize: new google.maps.Size(30, 45),
        anchor: new google.maps.Point(15, 43)
      };

      marker = new google.maps.Marker({
        position: initialPos,
        map: map,
        draggable: true,
        icon: svgIcon
      });

      marker.setVisible(false); // Sembunyikan sampai user klik

      map.addListener(''click'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.placeMarker(lat, lng);
        window.reverseGeocode(lat, lng);
      });

      marker.addListener(''dragend'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.setCoords(lat, lng);
        window.reverseGeocode(lat, lng);
      });
    }

    (function () {
      var counters = window.__locationCounters || { home: 0, practice: 0 }, timers = {}, coordTimer = null;
      window.__locationCounters = counters;
      var entries = { home: [], practice: [] };
      var activeEntryId = null;

      // --- CONFIG ---
      var PROXY = ''https://visit-flow-api.flexurio.com/google-maps'';
      var CUSTOMER_ID = (function () {
        try {
          if (window.customerId) return window.customerId;
        } catch (e) { }
        var m = location.search.match(/[?&]id=([^&]+)/);
        return m ? m[1] : null;
      })();

      // ---- FUNGSI UPDATE PETA ----
      window.placeMarker = function (lat, lng) {
        var pos = { lat: parseFloat(lat), lng: parseFloat(lng) };
        if (marker) {
          marker.setPosition(pos);
          marker.setVisible(true);
        }
        if (map) {
          map.panTo(pos);
          map.setZoom(16);
        }
        window.setCoords(lat, lng);
      }

      window.setCoords = function (lat, lng) {
        document.getElementById(''latitude'').value = parseFloat(lat).toFixed(6);
        document.getElementById(''longitude'').value = parseFloat(lng).toFixed(6);
      }

      // ---- REVERSE GEOCODE ----
      window.reverseGeocode = function (lat, lng) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + lat + '','' + lng)
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (d.status === ''OK'' && d.results && d.results.length) {
              var r = d.results[0];
              var full = r.formatted_address || '''';
              var short = r.address_components && r.address_components[0] ? r.address_components[0].long_name : full.split('','')[0];
              applyReverseResult(short, full, lat, lng);
            } else {
              nominatimReverse(lat, lng);
            }
          })
          .catch(function () { nominatimReverse(lat, lng); });
      }
      function nominatimReverse(lat, lng) {
        fetch(''https://nominatim.openstreetmap.org/reverse?format=json&lat='' + lat + ''&lon='' + lng + ''&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (d) {
            var full = d.display_name || '''';
            var short = full.split('','')[0];
            applyReverseResult(short, full, lat, lng);
          })
          .catch(function () { });
      }
      function applyReverseResult(short, full, lat, lng) {
        var id = activeEntryId;
        if (!id) { var all = entries.home.concat(entries.practice); if (all.length) id = all[all.length - 1]; }
        if (!id) return;
        var entry = document.getElementById(''entry-'' + id); if (!entry) return;
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        var sfw = document.getElementById(''sfw-'' + id);
        if (sfw) {
          var type = id.split(''-'')[0];
          if (type === ''home'') {
            sfw.querySelector(''.sf-inp'').value = short;
            sfw.querySelector(''.sf-clr'').classList.add(''show'');
            document.getElementById(''cn-'' + id).textContent = short;
          }
        }
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entryData = entryStore[id];
        if (entryData) { entryData.lat = parseFloat(lat); entryData.lng = parseFloat(lng); }
        updProg();
      }

      // ---- SEARCH ----
      function doSearch(q, id, drop) {
        fetch(PROXY + ''/places/autocomplete?input='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (data) {
            if (data.status === ''OK'' && data.predictions && data.predictions.length) {
              renderGoogleResults(data.predictions, id, drop);
            } else {
              fallbackNominatim(q, id, drop);
            }
          })
          .catch(function () { fallbackNominatim(q, id, drop); });
      }
      function renderGoogleResults(preds, id, drop) {
        drop.innerHTML = '''';
        preds.forEach(function (pred) {
          var el = document.createElement(''div'');
          el.className = ''sf-opt'';
          var main = pred.structured_formatting.main_text;
          var sec = pred.structured_formatting.secondary_text || '''';
          el.innerHTML =
            ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
            ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + main + ''</div><div class="sf-opt-addr">'' + sec + ''</div></div>'';
          el.addEventListener(''click'', function () {
            drop.classList.remove(''open'');
            fetch(PROXY + ''/places/details?place_id='' + encodeURIComponent(pred.place_id))
              .then(function (r) { return r.json(); })
              .then(function (d) {
                if (!d.result) return;
                var lat = d.result.geometry.location.lat;
                var lng = d.result.geometry.location.lng;
                var name = d.result.name || main;
                var full = d.result.formatted_address || main + '', '' + sec;
                selectPlace(id, name, full, lat, lng);
              })
              .catch(function () { geocodeText(main + '' '' + sec, id); });
          });
          drop.appendChild(el);
        });
      }
      function fallbackNominatim(q, id, drop) {
        fetch(''https://nominatim.openstreetmap.org/search?format=json&q='' + encodeURIComponent(q) + ''&limit=6&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (res) {
            if (!res.length) { drop.innerHTML = ''<div class="sf-msg">Tidak ditemukan</div>''; return; }
            drop.innerHTML = '''';
            res.forEach(function (item) {
              var el = document.createElement(''div'');
              el.className = ''sf-opt'';
              var short = item.display_name.split('','')[0];
              el.innerHTML =
                ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
                ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + short + ''</div><div class="sf-opt-addr">'' + item.display_name + ''</div></div>'';
              el.addEventListener(''click'', function () {
                drop.classList.remove(''open'');
                var lat = parseFloat(item.lat), lng = parseFloat(item.lon);
                selectPlace(id, short, item.display_name, lat, lng);
              });
              drop.appendChild(el);
            });
          })
          .catch(function () { drop.innerHTML = ''<div class="sf-msg">Gagal mencari</div>''; });
      }
      function geocodeText(q, id) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (!d.results || !d.results.length) return;
            var r = d.results[0];
            var lat = r.geometry.location.lat, lng = r.geometry.location.lng;
            var name = r.address_components[0].long_name;
            selectPlace(id, name, r.formatted_address, lat, lng);
          });
      }

      var entryStore = {};

      function selectPlace(id, name, full, lat, lng) {
        window.placeMarker(lat, lng);
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = name;
        sfw.querySelector(''.sf-clr'').classList.add(''show'');
        document.getElementById(''cn-'' + id).textContent = name;
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        if (!entryStore[id]) entryStore[id] = {};
        entryStore[id].location_name = name;
        entryStore[id].lat = lat;
        entryStore[id].lng = lng;
        updProg();
      }

      // ---- ADD ENTRY (Sudah support Initial Data) ----
      function addEntry(type, initialData) {
        var num = ++counters[type];
        var id = type + ''-'' + num;
        var isHome = type === ''home'';
        var isPrefilled = !!initialData && Object.keys(initialData).length > 0;

        var el = document.createElement(''div'');
        // Jika data lama, otomatis tambahkan class .is-collapsed dan .is-disabled
        el.className = ''entry'' + (isPrefilled ? '' is-disabled is-collapsed'' : '''');
        el.id = ''entry-'' + id;

        var ph = isHome ? ''Cari alamat rumah...'' : ''Cari klinik, RS, puskesmas...'';
        var taph = isHome ? ''Jl. Contoh No. 123, RT/RW, Kelurahan...'' : ''Alamat lengkap tempat praktek...'';

        // Set nilai dari DB
        var locId = isPrefilled ? initialData.id : null;
        var locName = isPrefilled ? (initialData.location_name || '''') : '''';
        var locAddr = isPrefilled ? (initialData.location_address || '''') : '''';
        var lat = (isPrefilled && initialData.latitude != null) ? initialData.latitude : null;
        var lng = (isPrefilled && initialData.longitude != null) ? initialData.longitude : null;
        var isActive = (initialData && initialData.hasOwnProperty(''is_active'')) ? initialData.is_active : true;

        var chipName = locName || (locAddr.split('','')[0]) || ''Lokasi'';
        var chipCoord = (lat != null && lng != null) ? parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4) : '''';
        var showChip = isPrefilled ? '' show'' : '''';

        // Tombol X hapus tidak ditampilkan jika prefilled dari DB
        var delBtnHtml = !isPrefilled ? ''<button class="entry-del" onclick="delEntry(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' : '''';

        // Nama custom header jika prefilled
        var titleName = isPrefilled && locName ? '' - '' + locName : '''';

        el.innerHTML =
          ''<div class="entry-head" style="cursor:pointer;" title="Klik untuk Expand/Minimize">'' +
          ''<div class="entry-num">'' + (isHome ? ''Rumah'' : ''Praktek'') + '' #'' + num + titleName + ''</div>'' +
          ''<div class="actions-group">'' +
          delBtnHtml +
          ''<button class="entry-toggle" type="button"><svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M2 8L6 4L10 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg></button>'' +
          ''</div>'' +
          ''</div>'' +
          ''<div class="entry-inner">'' +
          ''<div class="sf-wrap" id="sfw-'' + id + ''">'' +
          ''<svg class="sf-ico" viewBox="0 0 15 15" fill="none" stroke="#94a3b8" stroke-width="1.4" stroke-linecap="round"><circle cx="6.5" cy="6.5" r="4"/><path d="M10 10l3 3"/></svg>'' +
          ''<input class="sf-inp" type="text" placeholder="'' + ph + ''" autocomplete="off" value="'' + locName + ''"'' +
          '' oninput="onSF(this,\\'''' + id + ''\\'')"'' +
          '' onfocus="setActive(\\'''' + id + ''\\'');openDrop(\\'''' + id + ''\\'')">'' +
          ''<button class="sf-clr'' + (isPrefilled ? '' show'' : '''') + ''" onclick="clearSF(\\'''' + id + ''\\'')">×</button>'' +
          ''<div class="sf-drop" id="drop-'' + id + ''"></div>'' +
          ''</div>'' +
          ''<div class="entry-chip'' + showChip + ''" id="chip-'' + id + ''">'' +
          ''<div class="chip-dot"></div>'' +
          ''<div class="chip-name" id="cn-'' + id + ''">'' + chipName + ''</div>'' +
          ''<div class="chip-coord" id="cc-'' + id + ''">'' + chipCoord + ''</div>'' +
          ''<button class="chip-x" onclick="clearChip(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' +
          ''</div>'' +
          ''<textarea class="entry-ta" placeholder="'' + taph + ''" oninput="updProg()">'' + locAddr + ''</textarea>'' +
          ''<div class="field">'' +
          ''<div class="switch-wrap">'' +
          ''<div class="switch-lbl"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 12L11 14L15 10" stroke-linecap="round" stroke-linejoin="round"/></svg>Status Aktif</div>'' +
          ''<label class="switch"><input type="checkbox" class="act-check"'' + (isActive ? '' checked'' : '''') + ''><span class="slider"></span></label>'' +
          ''</div>'' +
          ''</div>'' +
          ''</div>'';

        document.getElementById(''list-'' + type).appendChild(el);

        entries[type].push(id);
        entryStore[id] = {
          id: locId,
          location_name: locName,
          lat: lat,
          lng: lng,
          is_active: isActive,
          isNew: !isPrefilled // Tracking agar data lama tidak di-submit ulang
        };

        var activeInp = el.querySelector(''.act-check'');
        activeInp.addEventListener(''change'', function () {
          entryStore[id].is_active = activeInp.checked;
          updProg();
        });

        // Tetap izinkan switch status aktif diubah untuk data lama
        if (isPrefilled) {
          el.querySelector(''.switch-wrap'').style.pointerEvents = ''auto'';
        }

        // Toggle Expand/Minimize Listener
        el.querySelector(''.entry-head'').addEventListener(''click'', function (e) {
          if (e.target.closest(''.entry-del'')) return;
          el.classList.toggle(''is-collapsed'');
        });

        updProg();
      }
      // EKSPOS FUNGSI AGAR BISA DIPANGGIL GOLANG
      window.addEntry = addEntry;

      function delEntry(id, type) {
        var el = document.getElementById(''entry-'' + id); if (el) el.remove();
        entries[type] = entries[type].filter(function (e) { return e !== id; });
        delete entryStore[id];
        if (activeEntryId === id) activeEntryId = null;
        updProg();
      }
      window.delEntry = delEntry;

      function onSF(inp, id) {
        var q = inp.value.trim();
        inp.nextElementSibling.classList.toggle(''show'', q.length > 0);
        clearTimeout(timers[id]);
        var drop = document.getElementById(''drop-'' + id);
        if (q.length < 2) { drop.classList.remove(''open''); return; }
        drop.classList.add(''open'');
        drop.innerHTML = ''<div class="sf-msg">Mencari...</div>'';
        timers[id] = setTimeout(function () { doSearch(q, id, drop); }, 500);
      }
      window.onSF = onSF;

      function openDrop(id) {
        var inp = document.getElementById(''sfw-'' + id).querySelector(''.sf-inp'');
        if (inp.value.trim().length >= 2) document.getElementById(''drop-'' + id).classList.add(''open'');
      }
      window.openDrop = openDrop;

      function setActive(id) { activeEntryId = id; }
      window.setActive = setActive;

      function clearSF(id) {
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = '''';
        sfw.querySelector(''.sf-clr'').classList.remove(''show'');
        document.getElementById(''drop-'' + id).classList.remove(''open'');
      }
      window.clearSF = clearSF;

      function clearChip(id, type) {
        document.getElementById(''chip-'' + id).classList.remove(''show'');
        clearSF(id);
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = '''';
        if (entryStore[id]) entryStore[id] = {};
        updProg();
      }
      window.clearChip = clearChip;

      document.addEventListener(''click'', function (e) {
        document.querySelectorAll(''.sf-drop.open'').forEach(function (d) {
          if (!d.closest(''.sf-wrap'').contains(e.target)) d.classList.remove(''open'');
        });
      });

      function onCoordInput() {
        clearTimeout(coordTimer);
        coordTimer = setTimeout(function () {
          var lat = parseFloat(document.getElementById(''latitude'').value);
          var lng = parseFloat(document.getElementById(''longitude'').value);
          if (!isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            var pos = { lat: lat, lng: lng };
            if (marker && map) {
              marker.setPosition(pos);
              marker.setVisible(true);
              map.panTo(pos);
              map.setZoom(16);
            }
          }
        }, 800);
      }
      window.onCoordInput = onCoordInput;

      function updProg() {
        var total = 0, filled = 0;
        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            total++;
            var ta = entry.querySelector(''.entry-ta'');
            if (ta && ta.value.trim()) filled++;
          });
        });
        var pct = total > 0 ? Math.round(filled / total * 100) : 0;
        document.getElementById(''pf'').style.width = pct + ''%'';
        document.getElementById(''pt'').textContent = filled + '' dari '' + total + '' entri diisi'';
        document.getElementById(''pp'').textContent = pct + ''%'';
      }
      window.updProg = updProg;

      var overlay = document.getElementById(''overlay''), ovBox = document.getElementById(''ovBox'');
      function showLoading(msg) {
        ovBox.innerHTML = ''<div class="spin-wrap"><svg width="54" height="54" viewBox="0 0 54 54" fill="none"><circle cx="27" cy="27" r="22" stroke="rgba(6,182,212,.14)" stroke-width="4.5"/><circle cx="27" cy="27" r="22" stroke="url(#g1)" stroke-width="4.5" stroke-linecap="round" stroke-dasharray="94 46"/><defs><linearGradient id="g1" x1="0" y1="0" x2="54" y2="0"><stop offset="0%" stop-color="#06b6d4"/><stop offset="100%" stop-color="#3b82f6"/></linearGradient></defs></svg></div><div class="ov-title">'' + (msg || ''Menyimpan...'') + ''</div><div class="ov-dots"><span></span><span></span><span></span></div>'';
        overlay.classList.add(''show'');
      }
      function showSuccess(title, sub) {
        ovBox.innerHTML = ''<div class="ok-wrap" id="okWrap"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12l5.5 5.5L20 7"/></svg></div><div class="ov-title">'' + (title || ''Tersimpan!'') + ''</div><div class="ov-sub">'' + (sub || '''') + ''</div>'';
        requestAnimationFrame(function () { requestAnimationFrame(function () { var w = document.getElementById(''okWrap''); if (w) w.classList.add(''pop''); }); });
      }
      function hideOverlay() { overlay.classList.remove(''show''); }
      function setBtns(d) { document.getElementById(''btn-save'').disabled = d; document.getElementById(''btn-skip'').disabled = d; }

      var toastErr = document.getElementById(''toastErr''), toastTimer = null;
      function showToastErr(msg) {
        document.getElementById(''toastErrMsg'').textContent = msg || ''Isi minimal 1 data sebelum menyimpan'';
        toastErr.classList.add(''show'');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toastErr.classList.remove(''show''); }, 2800);
      }

      function doSave() {
        var payload = [];
        var adaDataLama = false;

        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var store = entryStore[id] || {};

            // Skip data dari DB agar tidak disubmit ulang
            // Hanya skip jika isNew=false DAN is_active=true (tidak ada perubahan status)
            // Namun agar lebih aman dan simple sesuai request, kita kirimkan jika isNew=true ATAU (bukan isNew tapi is_active diubah)
            // Agar backend bisa handle update status nonaktif, kita kirim semua yang ada.
            
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            var ta = entry.querySelector(''.entry-ta'');
            var location_address = (ta && ta.value.trim()) || null;
            var location_name = store.location_name || null;
            var latitude = store.lat !== undefined ? store.lat : null;
            var longitude = store.lng !== undefined ? store.lng : null;
            var is_active = store.is_active;

            if (!location_address && !location_name && latitude === null && !store.id) return;

            payload.push({
              id: store.id || null,
              flag: type === ''home'' ? ''rumah'' : ''praktek'',
              location_name: location_name,
              location_address: location_address,
              latitude: latitude,
              longitude: longitude,
              is_active: is_active
            });
          });
        });

        if (payload.length === 0) {
          showToastErr(adaDataLama ? ''Tambahkan minimal 1 data baru untuk disimpan'' : ''Isi minimal 1 data lokasi sebelum menyimpan'');
          var btn = document.getElementById(''btn-save'');
          btn.style.transition = ''transform .08s ease'';
          var s = [-6, 6, -5, 5, -3, 3, 0], i = 0;
          (function shake() { if (i < s.length) { btn.style.transform = ''translateX('' + s[i++] + ''px)''; setTimeout(shake, 60); } else { btn.style.transform = ''''; btn.style.transition = ''''; } }());
          return;
        }

        setBtns(true);
        showLoading(''Menyimpan data...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SUBMIT_LOCATION'', input_value: payload });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSave]'', msg); }
          showSuccess(''Data Tersimpan!'', ''Lokasi berhasil disimpan'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1800);
        }, 900);
      }
      window.doSave = doSave;

      function doSkip() {
        setBtns(true);
        showLoading(''Melewati langkah ini...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SKIP_LOCATION'', input_value: null });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSkip]'', msg); }
          showSuccess(''Langkah Dilewati'', ''Kamu bisa melengkapi lokasi nanti'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1600);
        }, 700);
      }
      window.doSkip = doSkip;
    })();
  </script>
  <!-- SCRIPT GOOGLE MAPS API -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKHM_SHT0BmNh3fRwVrbtZDUFmtqobYXI&callback=initMap"
    async defer></script>
</body>

</html>'),
  (63494, 0, '2026-08-05 02:13:11.908000', 0, '2026-08-05 02:13:11.908000', NULL, NULL, 1220776, '202608', 'BDGA1', 'CUSTOMER LOCATION', '24120031', '<!DOCTYPE html>
<html lang="id">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Informasi Lokasi Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
    rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      -webkit-tap-highlight-color: transparent
    }

    body {
      min-height: 100vh;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      background: #f0f7ff;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px 60px;
      position: relative;
      overflow-x: hidden
    }

    .bg {
      position: fixed;
      inset: 0;
      z-index: 0;
      pointer-events: none
    }

    .b1 {
      position: absolute;
      width: 500px;
      height: 500px;
      top: -15%;
      left: -10%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #bae6fd, #e0f2fe)
    }

    .b2 {
      position: absolute;
      width: 450px;
      height: 450px;
      bottom: -10%;
      right: -8%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .55;
      background: radial-gradient(circle, #c7d2fe, #ddd6fe)
    }

    .b3 {
      position: absolute;
      width: 350px;
      height: 350px;
      top: 40%;
      left: 35%;
      border-radius: 50%;
      filter: blur(80px);
      opacity: .35;
      background: radial-gradient(circle, #a7f3d0, #d1fae5)
    }

    .card {
      position: relative;
      z-index: 1;
      background: rgba(255, 255, 255, .62);
      backdrop-filter: blur(24px);
      border: 1.5px solid rgba(255, 255, 255, .92);
      border-radius: 28px;
      padding: 36px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(15, 23, 42, .09), 0 4px 16px rgba(15, 23, 42, .05)
    }

    .head {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 24px
    }

    .head-icon {
      width: 44px;
      height: 44px;
      border-radius: 13px;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 14px rgba(6, 182, 212, .35);
      flex-shrink: 0
    }

    .head-txt h2 {
      font-size: 16px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -.3px
    }

    .head-txt p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px
    }

    .prog-bar {
      height: 4px;
      background: rgba(15, 23, 42, .07);
      border-radius: 99px;
      overflow: hidden;
      margin-bottom: 6px
    }

    .prog-fill {
      height: 100%;
      border-radius: 99px;
      background: linear-gradient(90deg, #06b6d4, #3b82f6);
      width: 0%;
      transition: width .35s ease
    }

    .prog-label {
      display: flex;
      justify-content: space-between;
      font-size: 10px;
      color: #94a3b8;
      font-weight: 600;
      margin-bottom: 24px
    }

    .sec-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 12px;
      margin-top: 4px
    }

    .sec-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .8px;
      text-transform: uppercase
    }

    .sec-title::before {
      content: '''';
      width: 20px;
      height: 1px;
      background: rgba(148, 163, 184, .25)
    }

    .add-btn {
      display: flex;
      align-items: center;
      gap: 5px;
      background: linear-gradient(135deg, rgba(6, 182, 212, .1), rgba(59, 130, 246, .08));
      border: 1.5px solid rgba(6, 182, 212, .25);
      border-radius: 8px;
      padding: 5px 10px;
      font-size: 10px;
      font-weight: 700;
      color: #0891b2;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .add-btn:hover {
      background: linear-gradient(135deg, rgba(6, 182, 212, .18), rgba(59, 130, 246, .14))
    }

    .fields {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 24px
    }

    .entry-list {
      display: flex;
      flex-direction: column;
      gap: 10px
    }

    .entry {
      background: rgba(248, 250, 252, .6);
      border: 1.5px solid rgba(226, 232, 240, .8);
      border-radius: 14px;
      padding: 14px;
      transition: border-color .18s
    }

    .entry:focus-within {
      border-color: rgba(6, 182, 212, .3);
      background: rgba(255, 255, 255, .8)
    }

    /* Header & Toggle Actions */
    .entry-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
      user-select: none;
    }

    .entry-num {
      font-size: 10px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .5px;
      text-transform: uppercase;
      transition: color .2s;
    }

    .actions-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .entry-del {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(220, 38, 38, .08);
      border: 1px solid rgba(220, 38, 38, .15);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      color: #dc2626;
      opacity: .6;
      transition: opacity .15s;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      line-height: 1
    }

    .entry-del:hover {
      opacity: 1
    }

    .entry-toggle {
      width: 24px;
      height: 24px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      border: 1px solid rgba(6, 182, 212, .2);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #0891b2;
      transition: background .15s;
    }

    .entry-toggle:hover {
      background: rgba(6, 182, 212, .2);
    }

    .entry-toggle svg {
      transition: transform .3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .entry.is-collapsed .entry-toggle svg {
      transform: rotate(180deg);
    }

    /* Content Body */
    .entry-inner {
      display: flex;
      flex-direction: column;
      gap: 8px
    }

    .entry.is-collapsed .entry-inner {
      display: none !important;
    }

    .entry.is-collapsed .entry-head {
      margin-bottom: 0;
    }

    /* State Disabled (Data dari Database) */
    .entry.is-disabled {
      background: rgba(241, 245, 249, 0.7);
      border-color: rgba(203, 213, 225, 0.5);
      opacity: 0.9;
    }

    .entry.is-disabled .entry-inner {
      pointer-events: none;
      /* Mematikan klik form */
    }

    .entry.is-disabled .sf-inp,
    .entry.is-disabled .entry-ta {
      background: transparent;
      box-shadow: none;
      border-color: rgba(226, 232, 240, 0.6);
      color: #64748b;
      font-weight: 600;
    }

    .entry.is-disabled .sf-clr,
    .entry.is-disabled .chip-x {
      display: none !important;
    }

    /* ------------------------------------- */

    .sf-wrap {
      position: relative
    }

    .sf-ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .sf-inp {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 32px 10px 34px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s
    }

    .sf-inp::placeholder {
      color: #94a3b8
    }

    .sf-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    /* Switch Toggle Styles */
    .switch-wrap {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 14px;
      background: rgba(255, 255, 255, .4);
      border: 1px solid rgba(226, 232, 240, .8);
      border-radius: 12px;
      margin-top: 5px
    }

    .switch-lbl {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      display: flex;
      align-items: center;
      gap: 6px
    }

    .switch {
      position: relative;
      display: inline-block;
      width: 38px;
      height: 22px
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #cbd5e1;
      transition: .3s;
      border-radius: 22px
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 2px;
      bottom: 2px;
      background-color: white;
      transition: .3s;
      border-radius: 50%;
      box-shadow: 0 2px 4px rgba(0, 0, 0, .1)
    }

    input:checked+.slider {
      background: linear-gradient(135deg, #06b6d4, #3b82f6)
    }

    input:checked+.slider:before {
      transform: translateX(16px)
    }

    .sf-clr {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      border-radius: 5px;
      background: rgba(148, 163, 184, .12);
      border: none;
      cursor: pointer;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: #94a3b8;
      z-index: 1;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .sf-clr.show {
      display: flex
    }

    .sf-drop {
      position: absolute;
      top: calc(100% + 4px);
      left: 0;
      right: 0;
      background: #fff;
      border: 1.5px solid rgba(6, 182, 212, .2);
      border-radius: 10px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, .12);
      z-index: 600;
      max-height: 200px;
      overflow-y: auto;
      display: none
    }

    .sf-drop.open {
      display: block
    }

    .sf-drop::-webkit-scrollbar {
      width: 3px
    }

    .sf-drop::-webkit-scrollbar-thumb {
      background: rgba(148, 163, 184, .3);
      border-radius: 99px
    }

    .sf-opt {
      display: flex;
      align-items: flex-start;
      gap: 8px;
      padding: 10px 12px;
      cursor: pointer;
      border-bottom: 1px solid rgba(226, 232, 240, .3);
      transition: background .1s;
      font-size: 12px
    }

    .sf-opt:last-child {
      border-bottom: none
    }

    .sf-opt:hover {
      background: rgba(6, 182, 212, .06)
    }

    .sf-opt-pin {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: rgba(6, 182, 212, .1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-top: 1px
    }

    .sf-opt-txt {
      flex: 1;
      min-width: 0
    }

    .sf-opt-name {
      font-weight: 700;
      color: #0f172a;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis
    }

    .sf-opt-addr {
      font-size: 10px;
      color: #64748b;
      margin-top: 1px;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden
    }

    .sf-msg {
      padding: 12px;
      text-align: center;
      font-size: 11px;
      color: #94a3b8
    }

    .entry-chip {
      display: none;
      align-items: center;
      gap: 7px;
      background: rgba(6, 182, 212, .06);
      border: 1px solid rgba(6, 182, 212, .2);
      border-radius: 8px;
      padding: 7px 10px
    }

    .entry-chip.show {
      display: flex
    }

    .chip-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      flex-shrink: 0
    }

    .chip-name {
      flex: 1;
      font-size: 11px;
      font-weight: 600;
      color: #0891b2;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap
    }

    .chip-coord {
      font-size: 10px;
      color: #64748b;
      white-space: nowrap;
      flex-shrink: 0
    }

    .chip-x {
      width: 18px;
      height: 18px;
      border-radius: 4px;
      background: rgba(8, 145, 178, .1);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      color: #0891b2;
      flex-shrink: 0;
      line-height: 1;
      font-family: ''Plus Jakarta Sans'', sans-serif
    }

    .entry-ta {
      width: 100%;
      background: rgba(255, 255, 255, .8);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      resize: none;
      line-height: 1.6;
      min-height: 60px
    }

    .entry-ta::placeholder {
      color: #94a3b8
    }

    .entry-ta:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px
    }

    .lbl-sm {
      font-size: 9.5px;
      font-weight: 700;
      color: #475569;
      letter-spacing: .4px;
      text-transform: uppercase;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px
    }

    .badge {
      font-size: 9px;
      padding: 1px 6px;
      border-radius: 4px;
      font-weight: 600;
      text-transform: none;
      letter-spacing: 0;
      background: rgba(224, 242, 254, .7);
      color: #0891b2;
      border: 1px solid rgba(8, 145, 178, .2)
    }

    .inp-wrap {
      position: relative
    }

    .inp-wrap .ico {
      position: absolute;
      left: 11px;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: .35;
      pointer-events: none;
      z-index: 1
    }

    .coord-inp {
      width: 100%;
      background: rgba(248, 250, 252, .85);
      border: 1.5px solid rgba(226, 232, 240, .9);
      border-radius: 10px;
      padding: 10px 12px 10px 32px;
      font-size: 13px;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color .18s, box-shadow .18s;
      appearance: none;
      -webkit-appearance: none
    }

    .coord-inp::placeholder {
      color: #94a3b8
    }

    .coord-inp:focus {
      border-color: rgba(6, 182, 212, .5);
      box-shadow: 0 0 0 3px rgba(6, 182, 212, .08);
      background: #fff
    }

    .coord-inp::-webkit-inner-spin-button,
    .coord-inp::-webkit-outer-spin-button {
      -webkit-appearance: none
    }

    .map-sec-label {
      font-size: 9.5px;
      font-weight: 700;
      color: #94a3b8;
      letter-spacing: .6px;
      text-transform: uppercase;
      margin-bottom: 8px
    }

    .map-container {
      border-radius: 14px;
      overflow: hidden;
      border: 1.5px solid rgba(6, 182, 212, .2);
      box-shadow: 0 4px 16px rgba(6, 182, 212, .08);
      position: relative
    }

    #map {
      height: 220px;
      width: 100%
    }

    .map-hint {
      position: absolute;
      bottom: 10px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(15, 23, 42, .65);
      backdrop-filter: blur(8px);
      color: #fff;
      font-size: 10px;
      font-weight: 600;
      padding: 5px 12px;
      border-radius: 99px;
      white-space: nowrap;
      pointer-events: none;
      z-index: 10
    }

    .actions {
      display: flex;
      gap: 10px
    }

    .btn-save {
      flex: 1;
      position: relative;
      overflow: hidden;
      background: linear-gradient(120deg, #22d3ee, #3b82f6 55%, #6366f1);
      color: #fff;
      border: none;
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 14px;
      font-weight: 800;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 4px 0 rgba(0, 0, 0, .14), 0 8px 20px rgba(34, 211, 238, .25);
      transition: transform .14s, box-shadow .14s
    }

    .btn-save::before {
      content: '''';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 45%;
      background: linear-gradient(180deg, rgba(255, 255, 255, .15), transparent);
      pointer-events: none
    }

    .btn-save:hover {
      transform: translateY(-2px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 6px 0 rgba(0, 0, 0, .14), 0 12px 28px rgba(34, 211, 238, .32)
    }

    .btn-save:active {
      transform: translateY(2px)
    }

    .btn-save:disabled {
      opacity: .6;
      cursor: not-allowed;
      transform: none
    }

    .ico-circle {
      width: 22px;
      height: 22px;
      border-radius: 7px;
      background: rgba(255, 255, 255, .2);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .btn-skip {
      background: rgba(255, 255, 255, .7);
      color: #64748b;
      border: 1.5px solid rgba(203, 213, 225, .8);
      border-radius: 14px;
      padding: 15px 20px;
      font-size: 13px;
      font-weight: 600;
      font-family: ''Plus Jakarta Sans'', sans-serif;
      cursor: pointer;
      white-space: nowrap;
      backdrop-filter: blur(8px);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, .9);
      transition: all .14s
    }

    .btn-skip:hover {
      background: rgba(255, 255, 255, .9);
      color: #475569;
      transform: translateY(-1px)
    }

    .btn-skip:active {
      transform: translateY(1px)
    }

    .btn-skip:disabled {
      opacity: .5;
      cursor: not-allowed;
      transform: none
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 9999;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(15, 23, 42, .42);
      backdrop-filter: blur(7px);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease
    }

    .overlay.show {
      opacity: 1;
      pointer-events: all
    }

    .ov-box {
      background: rgba(255, 255, 255, .9);
      backdrop-filter: blur(20px);
      border: 1.5px solid rgba(255, 255, 255, .98);
      border-radius: 24px;
      padding: 38px 44px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
      min-width: 210px;
      box-shadow: 0 28px 64px rgba(15, 23, 42, .16);
      transform: scale(.86) translateY(14px);
      opacity: 0;
      transition: transform .32s cubic-bezier(.34, 1.56, .64, 1), opacity .22s ease
    }

    .overlay.show .ov-box {
      transform: scale(1) translateY(0);
      opacity: 1
    }

    .spin-wrap {
      width: 54px;
      height: 54px;
      position: relative;
      flex-shrink: 0
    }

    .spin-wrap svg {
      position: absolute;
      inset: 0;
      animation: ovSpin .85s linear infinite
    }

    @keyframes ovSpin {
      to {
        transform: rotate(360deg)
      }
    }

    .ok-wrap {
      width: 54px;
      height: 54px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 6px 22px rgba(6, 182, 212, .38);
      transform: scale(0);
      transition: transform .36s cubic-bezier(.34, 1.56, .64, 1);
      flex-shrink: 0
    }

    .ok-wrap.pop {
      transform: scale(1)
    }

    .ok-wrap svg path {
      stroke-dasharray: 22;
      stroke-dashoffset: 22;
      transition: stroke-dashoffset .38s ease .18s
    }

    .ok-wrap.pop svg path {
      stroke-dashoffset: 0
    }

    .ov-title {
      font-size: 15px;
      font-weight: 800;
      color: #0f172a;
      text-align: center
    }

    .ov-sub {
      font-size: 11.5px;
      color: #64748b;
      text-align: center;
      margin-top: -4px
    }

    .ov-dots {
      display: flex;
      gap: 5px;
      align-items: center;
      margin-top: 2px
    }

    .ov-dots span {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: linear-gradient(135deg, #06b6d4, #3b82f6);
      animation: ovDot 1s infinite both
    }

    .ov-dots span:nth-child(2) {
      animation-delay: .18s
    }

    .ov-dots span:nth-child(3) {
      animation-delay: .36s
    }

    @keyframes ovDot {

      0%,
      80%,
      100% {
        opacity: .2;
        transform: scale(.75)
      }

      40% {
        opacity: 1;
        transform: scale(1)
      }
    }

    .toast-err {
      position: fixed;
      bottom: 24px;
      left: 50%;
      transform: translateX(-50%) translateY(20px);
      z-index: 99999;
      background: #fef2f2;
      border: 1.5px solid rgba(220, 38, 38, .25);
      border-radius: 14px;
      padding: 12px 18px;
      display: flex;
      align-items: center;
      gap: 10px;
      box-shadow: 0 8px 24px rgba(220, 38, 38, .15);
      opacity: 0;
      pointer-events: none;
      transition: opacity .22s ease, transform .22s ease;
      white-space: nowrap
    }

    .toast-err.show {
      opacity: 1;
      pointer-events: all;
      transform: translateX(-50%) translateY(0)
    }

    .toast-err-ico {
      width: 22px;
      height: 22px;
      border-radius: 6px;
      background: #fee2e2;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0
    }

    .toast-err-txt {
      font-size: 12px;
      font-weight: 700;
      color: #dc2626
    }

    /* ---- MEDIA QUERIES ---- */
    @media(max-width:560px) {
      body {
        min-height: 100vh;
        min-height: 100dvh;
        padding: 0;
        align-items: flex-start;
        /* Konten dimulai dari atas */
      }

      .card {
        max-width: 100%;
        padding: 24px 20px 80px;
        /* Padding bawah untuk area scroll */
        border-radius: 0;
        /* Menghilangkan sudut melengkung */
        border: none;
        /* Menghilangkan garis border card */
        box-shadow: none;
        /* Menghilangkan bayangan */
        background: transparent;
        /* Latar belakang card tembus pandang */
        backdrop-filter: none;
        /* Menghilangkan efek glassmorphism pada card */
        min-height: 100vh;
      }

      #map {
        height: 190px
      }

      .actions {
        display: flex;
        flex-direction: column-reverse; /* Reverse button order on mobile */
      }

      .btn-save,
      .btn-skip {
        width: 100%;
        padding: 16px
      }
    }

    @media(max-width:360px) {
      .card {
        padding: 20px 16px 80px
      }
    }
  </style>
</head>

<body>
  <div class="bg">
    <div class="b1"></div>
    <div class="b2"></div>
    <div class="b3"></div>
  </div>
  <div class="overlay" id="overlay">
    <div class="ov-box" id="ovBox"></div>
  </div>
  <div class="toast-err" id="toastErr">
    <div class="toast-err-ico"><svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#dc2626"
        stroke-width="2" stroke-linecap="round">
        <path d="M6 2v4M6 9.5v.5" />
      </svg></div>
    <span class="toast-err-txt" id="toastErrMsg">Isi minimal 1 data sebelum menyimpan</span>
  </div>

  <div class="card">
    <div class="head">
      <div class="head-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="#fff" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round">
          <path d="M10 2C6.686 2 4 4.686 4 8c0 4.5 6 10 6 10s6-5.5 6-10c0-3.314-2.686-6-6-6z" />
          <circle cx="10" cy="8" r="2" />
        </svg>
      </div>
      <div class="head-txt">
        <h2>Informasi Lokasi</h2>
        <p>Cari atau klik peta untuk pilih lokasi</p>
      </div>
    </div>

    <div class="prog-bar">
      <div class="prog-fill" id="pf"></div>
    </div>
    <div class="prog-label"><span id="pt">0 entri diisi</span><span id="pp">0%</span></div>

    <div class="fields">
      <div>
        <div class="sec-header">
          <div class="sec-title">Alamat Rumah</div>
          <button class="add-btn" onclick="window.addEntry(''home'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Alamat
          </button>
        </div>
        <div class="entry-list" id="list-home"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Tempat Praktek</div>
          <button class="add-btn" onclick="window.addEntry(''practice'')">
            <svg width="11" height="11" viewBox="0 0 11 11" fill="none" stroke="#0891b2" stroke-width="2"
              stroke-linecap="round">
              <path d="M5.5 1v9M1 5.5h9" />
            </svg>
            Tambah Praktek
          </button>
        </div>
        <div class="entry-list" id="list-practice"></div>
      </div>
      <div>
        <div class="sec-header">
          <div class="sec-title">Koordinat Aktif</div>
        </div>
        <div class="coord-row">
          <div>
            <div class="lbl-sm">Latitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M7 1v12M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="latitude" placeholder="-6.200000" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
          <div>
            <div class="lbl-sm">Longitude <span class="badge">Opsional</span></div>
            <div class="inp-wrap">
              <svg class="ico" viewBox="0 0 14 14" fill="none" stroke="#94a3b8" stroke-width="1.4"
                stroke-linecap="round">
                <path d="M1 7h12" />
              </svg>
              <input class="coord-inp" type="number" id="longitude" placeholder="106.816666" step="any"
                oninput="onCoordInput()">
            </div>
          </div>
        </div>
      </div>
      <div>
        <div class="map-sec-label">Peta Lokasi — Klik untuk pilih koordinat</div>
        <div class="map-container">
          <div id="map"></div>
          <div class="map-hint">Klik peta untuk pilih lokasi</div>
        </div>
      </div>
    </div>

    <!-- Tombol ditukar posisinya -->
    <div class="actions">
      <button class="btn-skip" id="btn-skip" onclick="doSkip()">Lewati</button>
      <button class="btn-save" id="btn-save" onclick="doSave()">
        <div class="ico-circle">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="#fff" stroke-width="2.2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M1.5 6h9M7 2l4 4-4 4" />
          </svg>
        </div>
        Simpan Data
      </button>
    </div>
  </div>

  <script>
    // Variabel Peta Global
    var map;
    var marker;

    // --- GOOGLE MAPS INIT ---
    function initMap() {
      var initialPos = { lat: -2.5, lng: 118 };

      map = new google.maps.Map(document.getElementById(''map''), {
        zoom: 5,
        center: initialPos,
        disableDefaultUI: true, // UI bersih
        zoomControl: true,
      });

      // FIX: Menggunakan viewBox yang lebih luas (-1 -1 30 45) agar bentuk path (max Y=42)
      // TIDAK terpotong sedikitpun di ujung jarum bawahnya.
      var svgIcon = {
        url: ''data:image/svg+xml;charset=UTF-8,'' + encodeURIComponent(''<svg width="30" height="45" viewBox="-1 -1 30 45" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M14 0C6.27 0 0 6.27 0 14c0 9.9 14 28 14 28S28 23.9 28 14C28 6.27 21.73 0 14 0z" fill="#ef4444"/><circle cx="14" cy="14" r="6" fill="white"/></svg>''),
        scaledSize: new google.maps.Size(30, 45),
        anchor: new google.maps.Point(15, 43)
      };

      marker = new google.maps.Marker({
        position: initialPos,
        map: map,
        draggable: true,
        icon: svgIcon
      });

      marker.setVisible(false); // Sembunyikan sampai user klik

      map.addListener(''click'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.placeMarker(lat, lng);
        window.reverseGeocode(lat, lng);
      });

      marker.addListener(''dragend'', function (e) {
        var lat = e.latLng.lat();
        var lng = e.latLng.lng();
        window.setCoords(lat, lng);
        window.reverseGeocode(lat, lng);
      });
    }

    (function () {
      var counters = window.__locationCounters || { home: 0, practice: 0 }, timers = {}, coordTimer = null;
      window.__locationCounters = counters;
      var entries = { home: [], practice: [] };
      var activeEntryId = null;

      // --- CONFIG ---
      var PROXY = ''https://visit-flow-api.flexurio.com/google-maps'';
      var CUSTOMER_ID = (function () {
        try {
          if (window.customerId) return window.customerId;
        } catch (e) { }
        var m = location.search.match(/[?&]id=([^&]+)/);
        return m ? m[1] : null;
      })();

      // ---- FUNGSI UPDATE PETA ----
      window.placeMarker = function (lat, lng) {
        var pos = { lat: parseFloat(lat), lng: parseFloat(lng) };
        if (marker) {
          marker.setPosition(pos);
          marker.setVisible(true);
        }
        if (map) {
          map.panTo(pos);
          map.setZoom(16);
        }
        window.setCoords(lat, lng);
      }

      window.setCoords = function (lat, lng) {
        document.getElementById(''latitude'').value = parseFloat(lat).toFixed(6);
        document.getElementById(''longitude'').value = parseFloat(lng).toFixed(6);
      }

      // ---- REVERSE GEOCODE ----
      window.reverseGeocode = function (lat, lng) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + lat + '','' + lng)
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (d.status === ''OK'' && d.results && d.results.length) {
              var r = d.results[0];
              var full = r.formatted_address || '''';
              var short = r.address_components && r.address_components[0] ? r.address_components[0].long_name : full.split('','')[0];
              applyReverseResult(short, full, lat, lng);
            } else {
              nominatimReverse(lat, lng);
            }
          })
          .catch(function () { nominatimReverse(lat, lng); });
      }
      function nominatimReverse(lat, lng) {
        fetch(''https://nominatim.openstreetmap.org/reverse?format=json&lat='' + lat + ''&lon='' + lng + ''&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (d) {
            var full = d.display_name || '''';
            var short = full.split('','')[0];
            applyReverseResult(short, full, lat, lng);
          })
          .catch(function () { });
      }
      function applyReverseResult(short, full, lat, lng) {
        var id = activeEntryId;
        if (!id) { var all = entries.home.concat(entries.practice); if (all.length) id = all[all.length - 1]; }
        if (!id) return;
        var entry = document.getElementById(''entry-'' + id); if (!entry) return;
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        var sfw = document.getElementById(''sfw-'' + id);
        if (sfw) {
          var type = id.split(''-'')[0];
          if (type === ''home'') {
            sfw.querySelector(''.sf-inp'').value = short;
            sfw.querySelector(''.sf-clr'').classList.add(''show'');
            document.getElementById(''cn-'' + id).textContent = short;
          }
        }
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entryData = entryStore[id];
        if (entryData) { entryData.lat = parseFloat(lat); entryData.lng = parseFloat(lng); }
        updProg();
      }

      // ---- SEARCH ----
      function doSearch(q, id, drop) {
        fetch(PROXY + ''/places/autocomplete?input='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (data) {
            if (data.status === ''OK'' && data.predictions && data.predictions.length) {
              renderGoogleResults(data.predictions, id, drop);
            } else {
              fallbackNominatim(q, id, drop);
            }
          })
          .catch(function () { fallbackNominatim(q, id, drop); });
      }
      function renderGoogleResults(preds, id, drop) {
        drop.innerHTML = '''';
        preds.forEach(function (pred) {
          var el = document.createElement(''div'');
          el.className = ''sf-opt'';
          var main = pred.structured_formatting.main_text;
          var sec = pred.structured_formatting.secondary_text || '''';
          el.innerHTML =
            ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
            ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + main + ''</div><div class="sf-opt-addr">'' + sec + ''</div></div>'';
          el.addEventListener(''click'', function () {
            drop.classList.remove(''open'');
            fetch(PROXY + ''/places/details?place_id='' + encodeURIComponent(pred.place_id))
              .then(function (r) { return r.json(); })
              .then(function (d) {
                if (!d.result) return;
                var lat = d.result.geometry.location.lat;
                var lng = d.result.geometry.location.lng;
                var name = d.result.name || main;
                var full = d.result.formatted_address || main + '', '' + sec;
                selectPlace(id, name, full, lat, lng);
              })
              .catch(function () { geocodeText(main + '' '' + sec, id); });
          });
          drop.appendChild(el);
        });
      }
      function fallbackNominatim(q, id, drop) {
        fetch(''https://nominatim.openstreetmap.org/search?format=json&q='' + encodeURIComponent(q) + ''&limit=6&accept-language=id'')
          .then(function (r) { return r.json(); })
          .then(function (res) {
            if (!res.length) { drop.innerHTML = ''<div class="sf-msg">Tidak ditemukan</div>''; return; }
            drop.innerHTML = '''';
            res.forEach(function (item) {
              var el = document.createElement(''div'');
              el.className = ''sf-opt'';
              var short = item.display_name.split('','')[0];
              el.innerHTML =
                ''<div class="sf-opt-pin"><svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 0C3 0 1.5 1.5 1.5 3.5c0 2.5 3.5 6.5 3.5 6.5s3.5-4 3.5-6.5C8.5 1.5 7 0 5 0z" stroke="#0891b2" stroke-width="1.2" fill="none"/><circle cx="5" cy="3.5" r="1" fill="#0891b2"/></svg></div>'' +
                ''<div class="sf-opt-txt"><div class="sf-opt-name">'' + short + ''</div><div class="sf-opt-addr">'' + item.display_name + ''</div></div>'';
              el.addEventListener(''click'', function () {
                drop.classList.remove(''open'');
                var lat = parseFloat(item.lat), lng = parseFloat(item.lon);
                selectPlace(id, short, item.display_name, lat, lng);
              });
              drop.appendChild(el);
            });
          })
          .catch(function () { drop.innerHTML = ''<div class="sf-msg">Gagal mencari</div>''; });
      }
      function geocodeText(q, id) {
        fetch(PROXY + ''/geocode/reverse?latlng='' + encodeURIComponent(q))
          .then(function (r) { return r.json(); })
          .then(function (d) {
            if (!d.results || !d.results.length) return;
            var r = d.results[0];
            var lat = r.geometry.location.lat, lng = r.geometry.location.lng;
            var name = r.address_components[0].long_name;
            selectPlace(id, name, r.formatted_address, lat, lng);
          });
      }

      var entryStore = {};

      function selectPlace(id, name, full, lat, lng) {
        window.placeMarker(lat, lng);
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = name;
        sfw.querySelector(''.sf-clr'').classList.add(''show'');
        document.getElementById(''cn-'' + id).textContent = name;
        document.getElementById(''cc-'' + id).textContent = parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4);
        document.getElementById(''chip-'' + id).classList.add(''show'');
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = full;
        if (!entryStore[id]) entryStore[id] = {};
        entryStore[id].location_name = name;
        entryStore[id].lat = lat;
        entryStore[id].lng = lng;
        updProg();
      }

      // ---- ADD ENTRY (Sudah support Initial Data) ----
      function addEntry(type, initialData) {
        var num = ++counters[type];
        var id = type + ''-'' + num;
        var isHome = type === ''home'';
        var isPrefilled = !!initialData && Object.keys(initialData).length > 0;

        var el = document.createElement(''div'');
        // Jika data lama, otomatis tambahkan class .is-collapsed dan .is-disabled
        el.className = ''entry'' + (isPrefilled ? '' is-disabled is-collapsed'' : '''');
        el.id = ''entry-'' + id;

        var ph = isHome ? ''Cari alamat rumah...'' : ''Cari klinik, RS, puskesmas...'';
        var taph = isHome ? ''Jl. Contoh No. 123, RT/RW, Kelurahan...'' : ''Alamat lengkap tempat praktek...'';

        // Set nilai dari DB
        var locId = isPrefilled ? initialData.id : null;
        var locName = isPrefilled ? (initialData.location_name || '''') : '''';
        var locAddr = isPrefilled ? (initialData.location_address || '''') : '''';
        var lat = (isPrefilled && initialData.latitude != null) ? initialData.latitude : null;
        var lng = (isPrefilled && initialData.longitude != null) ? initialData.longitude : null;
        var isActive = (initialData && initialData.hasOwnProperty(''is_active'')) ? initialData.is_active : true;

        var chipName = locName || (locAddr.split('','')[0]) || ''Lokasi'';
        var chipCoord = (lat != null && lng != null) ? parseFloat(lat).toFixed(4) + '', '' + parseFloat(lng).toFixed(4) : '''';
        var showChip = isPrefilled ? '' show'' : '''';

        // Tombol X hapus tidak ditampilkan jika prefilled dari DB
        var delBtnHtml = !isPrefilled ? ''<button class="entry-del" onclick="delEntry(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' : '''';

        // Nama custom header jika prefilled
        var titleName = isPrefilled && locName ? '' - '' + locName : '''';

        el.innerHTML =
          ''<div class="entry-head" style="cursor:pointer;" title="Klik untuk Expand/Minimize">'' +
          ''<div class="entry-num">'' + (isHome ? ''Rumah'' : ''Praktek'') + '' #'' + num + titleName + ''</div>'' +
          ''<div class="actions-group">'' +
          delBtnHtml +
          ''<button class="entry-toggle" type="button"><svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M2 8L6 4L10 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg></button>'' +
          ''</div>'' +
          ''</div>'' +
          ''<div class="entry-inner">'' +
          ''<div class="sf-wrap" id="sfw-'' + id + ''">'' +
          ''<svg class="sf-ico" viewBox="0 0 15 15" fill="none" stroke="#94a3b8" stroke-width="1.4" stroke-linecap="round"><circle cx="6.5" cy="6.5" r="4"/><path d="M10 10l3 3"/></svg>'' +
          ''<input class="sf-inp" type="text" placeholder="'' + ph + ''" autocomplete="off" value="'' + locName + ''"'' +
          '' oninput="onSF(this,\\'''' + id + ''\\'')"'' +
          '' onfocus="setActive(\\'''' + id + ''\\'');openDrop(\\'''' + id + ''\\'')">'' +
          ''<button class="sf-clr'' + (isPrefilled ? '' show'' : '''') + ''" onclick="clearSF(\\'''' + id + ''\\'')">×</button>'' +
          ''<div class="sf-drop" id="drop-'' + id + ''"></div>'' +
          ''</div>'' +
          ''<div class="entry-chip'' + showChip + ''" id="chip-'' + id + ''">'' +
          ''<div class="chip-dot"></div>'' +
          ''<div class="chip-name" id="cn-'' + id + ''">'' + chipName + ''</div>'' +
          ''<div class="chip-coord" id="cc-'' + id + ''">'' + chipCoord + ''</div>'' +
          ''<button class="chip-x" onclick="clearChip(\\'''' + id + ''\\'',\\'''' + type + ''\\'')">×</button>'' +
          ''</div>'' +
          ''<textarea class="entry-ta" placeholder="'' + taph + ''" oninput="updProg()">'' + locAddr + ''</textarea>'' +
          ''<div class="field">'' +
          ''<div class="switch-wrap">'' +
          ''<div class="switch-lbl"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2"><path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke-linecap="round" stroke-linejoin="round"/><path d="M9 12L11 14L15 10" stroke-linecap="round" stroke-linejoin="round"/></svg>Status Aktif</div>'' +
          ''<label class="switch"><input type="checkbox" class="act-check"'' + (isActive ? '' checked'' : '''') + ''><span class="slider"></span></label>'' +
          ''</div>'' +
          ''</div>'' +
          ''</div>'';

        document.getElementById(''list-'' + type).appendChild(el);

        entries[type].push(id);
        entryStore[id] = {
          id: locId,
          location_name: locName,
          lat: lat,
          lng: lng,
          is_active: isActive,
          isNew: !isPrefilled // Tracking agar data lama tidak di-submit ulang
        };

        var activeInp = el.querySelector(''.act-check'');
        activeInp.addEventListener(''change'', function () {
          entryStore[id].is_active = activeInp.checked;
          updProg();
        });

        // Tetap izinkan switch status aktif diubah untuk data lama
        if (isPrefilled) {
          el.querySelector(''.switch-wrap'').style.pointerEvents = ''auto'';
        }

        // Toggle Expand/Minimize Listener
        el.querySelector(''.entry-head'').addEventListener(''click'', function (e) {
          if (e.target.closest(''.entry-del'')) return;
          el.classList.toggle(''is-collapsed'');
        });

        updProg();
      }
      // EKSPOS FUNGSI AGAR BISA DIPANGGIL GOLANG
      window.addEntry = addEntry;

      function delEntry(id, type) {
        var el = document.getElementById(''entry-'' + id); if (el) el.remove();
        entries[type] = entries[type].filter(function (e) { return e !== id; });
        delete entryStore[id];
        if (activeEntryId === id) activeEntryId = null;
        updProg();
      }
      window.delEntry = delEntry;

      function onSF(inp, id) {
        var q = inp.value.trim();
        inp.nextElementSibling.classList.toggle(''show'', q.length > 0);
        clearTimeout(timers[id]);
        var drop = document.getElementById(''drop-'' + id);
        if (q.length < 2) { drop.classList.remove(''open''); return; }
        drop.classList.add(''open'');
        drop.innerHTML = ''<div class="sf-msg">Mencari...</div>'';
        timers[id] = setTimeout(function () { doSearch(q, id, drop); }, 500);
      }
      window.onSF = onSF;

      function openDrop(id) {
        var inp = document.getElementById(''sfw-'' + id).querySelector(''.sf-inp'');
        if (inp.value.trim().length >= 2) document.getElementById(''drop-'' + id).classList.add(''open'');
      }
      window.openDrop = openDrop;

      function setActive(id) { activeEntryId = id; }
      window.setActive = setActive;

      function clearSF(id) {
        var sfw = document.getElementById(''sfw-'' + id);
        sfw.querySelector(''.sf-inp'').value = '''';
        sfw.querySelector(''.sf-clr'').classList.remove(''show'');
        document.getElementById(''drop-'' + id).classList.remove(''open'');
      }
      window.clearSF = clearSF;

      function clearChip(id, type) {
        document.getElementById(''chip-'' + id).classList.remove(''show'');
        clearSF(id);
        var entry = document.getElementById(''entry-'' + id);
        var ta = entry.querySelector(''.entry-ta''); if (ta) ta.value = '''';
        if (entryStore[id]) entryStore[id] = {};
        updProg();
      }
      window.clearChip = clearChip;

      document.addEventListener(''click'', function (e) {
        document.querySelectorAll(''.sf-drop.open'').forEach(function (d) {
          if (!d.closest(''.sf-wrap'').contains(e.target)) d.classList.remove(''open'');
        });
      });

      function onCoordInput() {
        clearTimeout(coordTimer);
        coordTimer = setTimeout(function () {
          var lat = parseFloat(document.getElementById(''latitude'').value);
          var lng = parseFloat(document.getElementById(''longitude'').value);
          if (!isNaN(lat) && !isNaN(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            var pos = { lat: lat, lng: lng };
            if (marker && map) {
              marker.setPosition(pos);
              marker.setVisible(true);
              map.panTo(pos);
              map.setZoom(16);
            }
          }
        }, 800);
      }
      window.onCoordInput = onCoordInput;

      function updProg() {
        var total = 0, filled = 0;
        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            total++;
            var ta = entry.querySelector(''.entry-ta'');
            if (ta && ta.value.trim()) filled++;
          });
        });
        var pct = total > 0 ? Math.round(filled / total * 100) : 0;
        document.getElementById(''pf'').style.width = pct + ''%'';
        document.getElementById(''pt'').textContent = filled + '' dari '' + total + '' entri diisi'';
        document.getElementById(''pp'').textContent = pct + ''%'';
      }
      window.updProg = updProg;

      var overlay = document.getElementById(''overlay''), ovBox = document.getElementById(''ovBox'');
      function showLoading(msg) {
        ovBox.innerHTML = ''<div class="spin-wrap"><svg width="54" height="54" viewBox="0 0 54 54" fill="none"><circle cx="27" cy="27" r="22" stroke="rgba(6,182,212,.14)" stroke-width="4.5"/><circle cx="27" cy="27" r="22" stroke="url(#g1)" stroke-width="4.5" stroke-linecap="round" stroke-dasharray="94 46"/><defs><linearGradient id="g1" x1="0" y1="0" x2="54" y2="0"><stop offset="0%" stop-color="#06b6d4"/><stop offset="100%" stop-color="#3b82f6"/></linearGradient></defs></svg></div><div class="ov-title">'' + (msg || ''Menyimpan...'') + ''</div><div class="ov-dots"><span></span><span></span><span></span></div>'';
        overlay.classList.add(''show'');
      }
      function showSuccess(title, sub) {
        ovBox.innerHTML = ''<div class="ok-wrap" id="okWrap"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12l5.5 5.5L20 7"/></svg></div><div class="ov-title">'' + (title || ''Tersimpan!'') + ''</div><div class="ov-sub">'' + (sub || '''') + ''</div>'';
        requestAnimationFrame(function () { requestAnimationFrame(function () { var w = document.getElementById(''okWrap''); if (w) w.classList.add(''pop''); }); });
      }
      function hideOverlay() { overlay.classList.remove(''show''); }
      function setBtns(d) { document.getElementById(''btn-save'').disabled = d; document.getElementById(''btn-skip'').disabled = d; }

      var toastErr = document.getElementById(''toastErr''), toastTimer = null;
      function showToastErr(msg) {
        document.getElementById(''toastErrMsg'').textContent = msg || ''Isi minimal 1 data sebelum menyimpan'';
        toastErr.classList.add(''show'');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toastErr.classList.remove(''show''); }, 2800);
      }

      function doSave() {
        var payload = [];
        var adaDataLama = false;

        [''home'', ''practice''].forEach(function (type) {
          entries[type].forEach(function (id) {
            var store = entryStore[id] || {};

            // Skip data dari DB agar tidak disubmit ulang
            // Hanya skip jika isNew=false DAN is_active=true (tidak ada perubahan status)
            // Namun agar lebih aman dan simple sesuai request, kita kirimkan jika isNew=true ATAU (bukan isNew tapi is_active diubah)
            // Agar backend bisa handle update status nonaktif, kita kirim semua yang ada.
            
            var entry = document.getElementById(''entry-'' + id); if (!entry) return;
            var ta = entry.querySelector(''.entry-ta'');
            var location_address = (ta && ta.value.trim()) || null;
            var location_name = store.location_name || null;
            var latitude = store.lat !== undefined ? store.lat : null;
            var longitude = store.lng !== undefined ? store.lng : null;
            var is_active = store.is_active;

            if (!location_address && !location_name && latitude === null && !store.id) return;

            payload.push({
              id: store.id || null,
              flag: type === ''home'' ? ''rumah'' : ''praktek'',
              location_name: location_name,
              location_address: location_address,
              latitude: latitude,
              longitude: longitude,
              is_active: is_active
            });
          });
        });

        if (payload.length === 0) {
          showToastErr(adaDataLama ? ''Tambahkan minimal 1 data baru untuk disimpan'' : ''Isi minimal 1 data lokasi sebelum menyimpan'');
          var btn = document.getElementById(''btn-save'');
          btn.style.transition = ''transform .08s ease'';
          var s = [-6, 6, -5, 5, -3, 3, 0], i = 0;
          (function shake() { if (i < s.length) { btn.style.transform = ''translateX('' + s[i++] + ''px)''; setTimeout(shake, 60); } else { btn.style.transform = ''''; btn.style.transition = ''''; } }());
          return;
        }

        setBtns(true);
        showLoading(''Menyimpan data...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SUBMIT_LOCATION'', input_value: payload });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSave]'', msg); }
          showSuccess(''Data Tersimpan!'', ''Lokasi berhasil disimpan'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1800);
        }, 900);
      }
      window.doSave = doSave;

      function doSkip() {
        setBtns(true);
        showLoading(''Melewati langkah ini...'');
        setTimeout(function () {
          var msg = JSON.stringify({ action: ''SKIP_LOCATION'', input_value: null });
          if (window.FormChannel) { window.FormChannel.postMessage(msg); }
          else { console.log(''[doSkip]'', msg); }
          showSuccess(''Langkah Dilewati'', ''Kamu bisa melengkapi lokasi nanti'');
          setTimeout(function () { hideOverlay(); setBtns(false); }, 1600);
        }, 700);
      }
      window.doSkip = doSkip;
    })();
  </script>
  <!-- SCRIPT GOOGLE MAPS API -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDKHM_SHT0BmNh3fRwVrbtZDUFmtqobYXI&callback=initMap"
    async defer></script>
</body>

</html>');

-- --------------------------------------------------------------------
-- Table structure for `incentive_recomendations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `incentive_recomendations`;
CREATE TABLE `incentive_recomendations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) NOT NULL,
  `schema_name` varchar(50) DEFAULT NULL,
  `schema_detail` varchar(200) DEFAULT NULL,
  `schema_detail_sub` varchar(200) DEFAULT NULL,
  `structure_id` varchar(20) NOT NULL,
  `position` varchar(10) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `value` double DEFAULT '0',
  `value_incentive` double DEFAULT '0',
  `max` double DEFAULT '0',
  `max_incentive` double DEFAULT '0',
  `remaining` double DEFAULT '0',
  `category_value` varchar(10) DEFAULT NULL,
  `note_header` varchar(100) DEFAULT NULL,
  `note_detail` varchar(500) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_id` (`period`,`user_id`,`schema_name`,`schema_detail`,`schema_detail_sub`) USING BTREE,
  KEY `idx_incentive_recomendations_period` (`period`),
  KEY `idx_incentive_recomendations_user_id` (`user_id`),
  KEY `idx_incentive_recomendations_schema` (`schema_name`),
  KEY `idx_incentive_recomendations_schema_detail` (`schema_detail`),
  KEY `idx_incentive_recomendations_period_user_id` (`period`,`user_id`),
  KEY `idx_incentive_recomendations_period_user_id_schema` (`period`,`user_id`,`schema_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2517 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `incentive_recomendations` (5 rows)
INSERT INTO `incentive_recomendations` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `user_id`, `period`, `schema_name`, `schema_detail`, `schema_detail_sub`, `structure_id`, `position`, `user_name`, `value`, `value_incentive`, `max`, `max_incentive`, `remaining`, `category_value`, `note_header`, `note_detail`, `icon`) VALUES
  (3, NULL, '2026-03-13 09:46:01', NULL, '2026-03-13 09:46:01', NULL, NULL, 1220776, '202511', 'Reguler', 'New User', NULL, 'BDGA1', 'ASM', 'BENNY SUSANTO', 0.0, 0.0, 150000000.0, 10000000.0, 50000000.0, 'Rp', '<b>Semangat</b', '<r>Semangat</r>', '🚀'),
  (4, NULL, '2026-03-13 09:46:01', NULL, '2026-03-13 09:46:01', NULL, NULL, 1251093, '202511', 'Reguler', 'New User', NULL, 'BDGA1S1', 'SPV', 'GINA LISDANIA', 0.0, 0.0, 150000000.0, 10000000.0, 50000000.0, 'Rp', '<b>Semangat</b', '<r>Semangat</r>', '🚀'),
  (5, NULL, '2026-03-13 09:46:01', NULL, '2026-03-13 09:46:01', NULL, NULL, 1220695, '202511', 'Reguler', 'New User', NULL, 'BDGA1S102', 'MR', 'ITA HARTATI', 0.0, 0.0, 150000000.0, 10000000.0, 50000000.0, 'Rp', '<b>Semangat</b', '<r>Semangat</r>', '🚀'),
  (6, NULL, '2026-03-13 09:46:01', NULL, '2026-03-13 09:46:01', NULL, NULL, 1220809, '202511', 'Reguler', 'New User', NULL, 'BDGA1S201', 'MR', 'GERRY JANUAR SADELI', 0.0, 0.0, 150000000.0, 10000000.0, 50000000.0, 'Rp', '<b>Semangat</b', '<r>Semangat</r>', '🚀'),
  (7, NULL, '2026-03-13 09:46:01', NULL, '2026-03-13 09:46:01', NULL, NULL, 1220724, '202511', 'Reguler', 'New User', NULL, 'BDGA1S3', 'SPV', 'REGINA PESTA', 0.0, 0.0, 150000000.0, 10000000.0, 50000000.0, 'Rp', '<b>Semangat</b', '<r>Semangat</r>', '🚀');

-- --------------------------------------------------------------------
-- Table structure for `incentive_recommendation_parameters`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `incentive_recommendation_parameters`;
CREATE TABLE `incentive_recommendation_parameters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `period` varchar(6) NOT NULL,
  `schema_header` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `schema_detail` varchar(200) DEFAULT NULL,
  `schema_detail_sub` varchar(200) DEFAULT NULL,
  `position` varchar(10) DEFAULT NULL,
  `parameter` double DEFAULT '0',
  `value_incentive` double DEFAULT '0',
  `category_parameter` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `incentive_recommendation_parameters` (5 rows)
INSERT INTO `incentive_recommendation_parameters` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `period`, `schema_header`, `schema_detail`, `schema_detail_sub`, `position`, `parameter`, `value_incentive`, `category_parameter`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, '202604', 'Reguler', 'Call Mcl', 'User', 'MR', 90.0, 100000.0, 'Qty'),
  (2, NULL, NULL, NULL, NULL, NULL, NULL, '202604', 'Reguler', 'Call Mcl', 'Outlet Dan KPDM', 'MR', 100.0, 75000.0, 'Qty'),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, '202604', 'Reguler', 'New User', 'New User', 'MR', 1.0, 200000.0, 'Qty'),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, '202604', 'Reguler', 'New User', 'New User', 'MR', 2.0, 250000.0, 'Qty'),
  (5, NULL, NULL, NULL, NULL, NULL, NULL, '202604', 'Reguler', 'Additional Product', 'Additional Product', 'MR', 1.0, 150000.0, 'Qty');

-- --------------------------------------------------------------------
-- Table structure for `incentive_users`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `incentive_users`;
CREATE TABLE `incentive_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `period` varchar(6) NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `schema_name` varchar(50) DEFAULT NULL,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` varchar(10) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `value` double DEFAULT '0',
  `value_max` double DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_id` (`period`,`user_id`,`schema_name`),
  KEY `idx_incentive_users_period` (`period`),
  KEY `idx_incentive_users_user_id` (`user_id`),
  KEY `idx_incentive_users_schema` (`schema_name`),
  KEY `idx_incentive_users_period_user_id` (`period`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2044 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `incentive_users` (5 rows)
INSERT INTO `incentive_users` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `period`, `user_id`, `schema_name`, `structure_id`, `position`, `user_name`, `value`, `value_max`) VALUES
  (1021, NULL, NULL, NULL, NULL, NULL, NULL, '202603', 2207004, 'Reguler', 'VNJKT2207004', 'MR', 'Umar Maruf mutaqin', 1300000.0, 50000000.0),
  (1787, NULL, '2026-03-12 14:15:30', NULL, '2026-03-12 14:15:30', NULL, NULL, '202511', 1220776, 'Reguler', 'BDGA1', 'ASM', 'BENNY SUSANTO', 791265.0, 100000000.0),
  (1788, NULL, '2026-03-12 14:15:30', NULL, '2026-03-12 14:15:30', NULL, NULL, '202511', 1251093, 'Reguler', 'BDGA1S1', 'SPV', 'GINA LISDANIA', 0.0, 100000000.0),
  (1789, NULL, '2026-03-12 14:15:30', NULL, '2026-03-12 14:15:30', NULL, NULL, '202511', 1220695, 'Reguler', 'BDGA1S102', 'MR', 'ITA HARTATI', 0.0, 100000000.0),
  (1790, NULL, '2026-03-12 14:15:30', NULL, '2026-03-12 14:15:30', NULL, NULL, '202511', 1220809, 'Reguler', 'BDGA1S201', 'MR', 'GERRY JANUAR SADELI', 0.0, 100000000.0);

-- --------------------------------------------------------------------
-- Table structure for `leave_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `leave_categories`;
CREATE TABLE `leave_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('paid','unpaid') DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_leave_category` (`name`,`type`,`company_id`),
  KEY `fk_leave_categories_created_by` (`created_by_id`),
  KEY `fk_leave_categories_updated_by` (`updated_by_id`),
  KEY `idx_name` (`name`),
  KEY `idx_type` (`type`),
  KEY `idx_company_id` (`company_id`),
  CONSTRAINT `fk_leave_categories_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leave_categories_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `leave_categories` (5 rows)
INSERT INTO `leave_categories` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `type`, `company_id`) VALUES
  (1, '2024-07-12 01:28:12.169000', '2024-07-12 01:28:12.169000', 2207004, 2207004, NULL, 'Cuti Tahunan', 'paid', 1),
  (2, '2024-07-12 01:28:12.169000', '2024-07-12 01:28:12.169000', 2207004, 2207004, NULL, 'Izin Sakit', 'paid', 1),
  (3, '2024-07-12 01:28:12.169000', '2024-07-12 01:28:12.169000', 2207004, 2207004, NULL, 'Cuti Bersama', 'paid', 1),
  (4, '2024-07-12 01:28:12.169000', '2024-07-12 01:28:12.169000', 2207004, 2207004, NULL, 'Izin / Dinas', 'paid', 1),
  (6, '2024-07-12 01:28:12.169000', '2024-07-12 01:28:12.169000', 2207004, 2207004, NULL, 'Istri Karyawan Melahirkan / Keguguran', 'paid', 1);

-- --------------------------------------------------------------------
-- Table structure for `leave_category_qoutas`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `leave_category_qoutas`;
CREATE TABLE `leave_category_qoutas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `qouta` int NOT NULL,
  `leave_category_id` bigint unsigned NOT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_leave_category_qouta` (`qouta`,`leave_category_id`,`company_id`),
  KEY `fk_leave_category_qoutas_created_by` (`created_by_id`),
  KEY `fk_leave_category_qoutas_updated_by` (`updated_by_id`),
  KEY `idx_qouta` (`qouta`),
  KEY `idx_company_id` (`company_id`),
  KEY `fk_leave_category_qoutas_leave_category` (`leave_category_id`) USING BTREE,
  CONSTRAINT `fk_leave_category_qoutas_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leave_category_qoutas_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `leave_category_qoutas_ibfk_1` FOREIGN KEY (`leave_category_id`) REFERENCES `location_categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------------------
-- Table structure for `leave_periods`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `leave_periods`;
CREATE TABLE `leave_periods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `start_date` datetime(3) DEFAULT NULL,
  `end_date` datetime(3) DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_leave_periods_deleted_at` (`deleted_at`),
  KEY `idx_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `leave_periods` (5 rows)
INSERT INTO `leave_periods` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `start_date`, `end_date`, `company_id`) VALUES
  (1, '2025-11-13 00:34:44.198000', '2025-11-13 00:34:44.198000', NULL, 2207004, 0, NULL, '2026-01-01 00:00:00', '2026-12-31 17:00:00', 1),
  (2, '2025-11-13 00:34:44.198000', '2025-11-13 00:34:44.198000', NULL, 2207004, 0, NULL, '2027-01-01 00:00:00', '2030-12-31 17:00:00', 1),
  (3, '2025-11-13 00:34:44.198000', '2025-11-13 00:34:44.198000', NULL, 2207004, 0, NULL, '2028-01-01 00:00:00', '2030-12-31 17:00:00', 1),
  (4, '2025-11-13 00:34:44.198000', '2025-11-13 00:34:44.198000', NULL, 2207004, 0, NULL, '2029-01-01 00:00:00', '2030-12-31 17:00:00', 1),
  (5, '2025-11-13 00:34:44.198000', '2025-11-13 00:34:44.198000', NULL, 2207004, 0, NULL, '2030-01-01 00:00:00', '2030-12-31 17:00:00', 1);

-- --------------------------------------------------------------------
-- Table structure for `leave_qouta_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `leave_qouta_categories`;
CREATE TABLE `leave_qouta_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `qouta` int NOT NULL,
  `leave_category_id` bigint unsigned NOT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `maximum_usage` int DEFAULT NULL,
  `minimum_joining` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_leave_category_qouta` (`qouta`,`leave_category_id`,`company_id`),
  KEY `idx_qouta` (`qouta`),
  KEY `idx_company_id` (`company_id`),
  KEY `fk_leave_qouta_categories_updated_by` (`updated_by_id`) USING BTREE,
  KEY `fk_leave_qouta_categories_created_by` (`created_by_id`) USING BTREE,
  KEY `fk_leave_qouta_categories_leave_category` (`leave_category_id`) USING BTREE,
  CONSTRAINT `fk_leave_qouta_categories_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leave_qouta_categories_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leave_qouta_category_leave_category` FOREIGN KEY (`leave_category_id`) REFERENCES `leave_categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `leave_qouta_categories` (5 rows)
INSERT INTO `leave_qouta_categories` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `qouta`, `leave_category_id`, `company_id`, `maximum_usage`, `minimum_joining`) VALUES
  (18, '2026-05-07 06:06:45.279000', '2026-05-07 06:15:35.870000', 1901016, 1901016, NULL, 2, 9, 1, NULL, NULL),
  (22, '2026-05-12 07:12:22.608000', '2026-05-12 07:12:22.609000', 1901016, 1901016, NULL, 2, 11, 1, NULL, NULL),
  (23, '2026-05-12 07:12:46.208000', '2026-05-12 07:12:46.208000', 1901016, 1901016, NULL, 3, 8, 1, NULL, NULL),
  (24, '2026-05-12 07:13:10.565000', '2026-05-12 07:13:10.565000', 1901016, 1901016, NULL, 2, 6, 1, NULL, NULL),
  (25, '2026-05-12 07:13:47.355000', '2026-05-12 07:13:47.355000', 1901016, 1901016, NULL, 2, 10, 1, NULL, NULL);

-- --------------------------------------------------------------------
-- Table structure for `leave_quota`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `leave_quota`;
CREATE TABLE `leave_quota` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `days` double DEFAULT NULL,
  `day_remaining` double DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `start_date` datetime(3) DEFAULT NULL,
  `end_date` datetime(3) DEFAULT NULL,
  `leave_category_id` bigint unsigned DEFAULT NULL,
  `leave_period_id` bigint unsigned DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `period` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_leave_quota` (`is_active`,`start_date`,`end_date`,`user_id`,`leave_category_id`,`company_id`) USING BTREE,
  KEY `fk_leave_quota_created_by` (`created_by_id`),
  KEY `fk_leave_quota_updated_by` (`updated_by_id`),
  KEY `fk_leave_quota_user` (`user_id`),
  KEY `fk_leave_quota_leave_category` (`leave_category_id`),
  KEY `idx_days` (`days`),
  KEY `idx_company_id` (`company_id`),
  CONSTRAINT `fk_leave_quota_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leave_quota_leave_category` FOREIGN KEY (`leave_category_id`) REFERENCES `leave_categories` (`id`),
  CONSTRAINT `fk_leave_quota_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leave_quota_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69314 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `leave_quota` (5 rows)
INSERT INTO `leave_quota` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `days`, `day_remaining`, `user_id`, `start_date`, `end_date`, `leave_category_id`, `leave_period_id`, `company_id`, `is_active`, `period`) VALUES
  (12349, '2026-02-13 15:48:29', '2026-02-13 15:48:29', 1801001, 1801001, NULL, 999.0, 999.0, 1, '2026-01-01 00:00:00', '2026-12-31 00:00:00', 3, NULL, 1, 1, '2026'),
  (12350, '2026-02-13 15:48:29', '2026-02-13 15:48:29', 1801001, 1801001, NULL, 999.0, 999.0, 2, '2026-01-01 00:00:00', '2026-12-31 00:00:00', 3, NULL, 1, 1, '2026'),
  (12351, '2026-02-13 15:48:29', '2026-02-13 15:48:29', 1801001, 1801001, NULL, 999.0, 999.0, 3, '2026-01-01 00:00:00', '2026-12-31 00:00:00', 3, NULL, 1, 1, '2026'),
  (12352, '2026-02-13 15:48:29', '2026-02-13 15:48:29', 1801001, 1801001, NULL, 999.0, 999.0, 4, '2026-01-01 00:00:00', '2026-12-31 00:00:00', 3, NULL, 1, 1, '2026'),
  (12353, '2026-02-13 15:48:29', '2026-02-13 15:48:29', 1801001, 1801001, NULL, 999.0, 999.0, 5, '2026-01-01 00:00:00', '2026-12-31 00:00:00', 3, NULL, 1, 1, '2026');

-- --------------------------------------------------------------------
-- Table structure for `leaves`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `leaves`;
CREATE TABLE `leaves` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `start_date` datetime(3) DEFAULT NULL,
  `end_date` datetime(3) DEFAULT NULL,
  `days` double DEFAULT NULL,
  `period` varchar(20) DEFAULT NULL,
  `leave_time` varchar(20) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `approved_manager_by_id` bigint unsigned DEFAULT NULL,
  `approved_manager_at` datetime(3) DEFAULT NULL,
  `rejected_manager_by_id` bigint unsigned DEFAULT NULL,
  `rejected_manager_at` datetime(3) DEFAULT NULL,
  `approved_hrd_by_id` bigint unsigned DEFAULT NULL,
  `approved_hrd_at` datetime(3) DEFAULT NULL,
  `rejected_hrd_by_id` bigint unsigned DEFAULT NULL,
  `rejected_hrd_at` datetime(3) DEFAULT NULL,
  `rejected_reason` longtext,
  `file` longtext,
  `flag` varchar(100) DEFAULT NULL,
  `security_exit_at` datetime(3) DEFAULT NULL,
  `security_entry_at` datetime(3) DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `leave_category_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_leave` (`start_date`,`end_date`,`company_id`,`user_id`,`leave_category_id`) USING BTREE,
  KEY `fk_leaves_created_by` (`created_by_id`),
  KEY `fk_leaves_updated_by` (`updated_by_id`),
  KEY `fk_leaves_leave_category` (`leave_category_id`),
  KEY `idx_end_date` (`end_date`),
  KEY `idx_status` (`status`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_leaves_uid_status_dates` (`user_id`,`status`,`start_date`,`end_date`),
  KEY `idx_leaves_user_date` (`user_id`,`start_date`,`end_date`),
  KEY `idx_leaves_user_status_del_dates` (`user_id`,`status`,`deleted_at`,`start_date`,`end_date`),
  CONSTRAINT `fk_leaves_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leaves_leave_category` FOREIGN KEY (`leave_category_id`) REFERENCES `leave_categories` (`id`),
  CONSTRAINT `fk_leaves_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_leaves_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1157 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `leaves` (5 rows)
INSERT INTO `leaves` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `start_date`, `end_date`, `days`, `period`, `leave_time`, `status`, `note`, `approved_manager_by_id`, `approved_manager_at`, `rejected_manager_by_id`, `rejected_manager_at`, `approved_hrd_by_id`, `approved_hrd_at`, `rejected_hrd_by_id`, `rejected_hrd_at`, `rejected_reason`, `file`, `flag`, `security_exit_at`, `security_entry_at`, `company_id`, `user_id`, `leave_category_id`, `deleted_at`) VALUES
  (707, '2026-02-02 00:19:38.711000', '2026-02-02 00:20:25.353000', 2207004, 1901016, NULL, '2026-01-28 17:00:00', '2026-01-29 16:59:59.999000', 1.0, '2026', 'morning', 'approved hrd', 'Ada keperluan ke kampus', 2201001, '2026-02-02 00:19:58.998000', NULL, NULL, 1901016, '2026-02-02 00:20:25.353000', NULL, NULL, '', '', 'paid', NULL, NULL, 1, 2207004, 1, NULL),
  (709, '2026-02-10 23:19:54.338000', '2026-02-11 01:08:44.574000', 2207004, 1901016, NULL, '2026-02-10 17:00:00', '2026-02-11 16:59:59.999000', 1.0, '2026', 'morning', 'approved hrd', 'Sakit', 2201001, '2026-02-11 00:35:56.982000', NULL, NULL, 1901016, '2026-02-11 01:08:44.574000', NULL, NULL, '', '', 'paid', NULL, NULL, 1, 2207004, 1, NULL),
  (710, '2026-02-11 01:10:20.671000', '2026-02-12 06:32:38.215000', 1901016, 1801008, NULL, '2026-02-15 17:00:00', '2026-02-16 16:59:59.999000', 1.0, '2026', 'morning', 'approved hrd', 'Acara lamaran ditempat sodara', 1801008, '2026-02-12 06:32:28.225000', NULL, NULL, 1801008, '2026-02-12 06:32:38.215000', NULL, NULL, '', '', 'paid', NULL, NULL, 1, 1901016, 1, NULL),
  (711, '2026-02-11 05:14:13.974000', '2026-02-11 07:14:20.224000', 1801005, 1901016, NULL, '2026-01-01 17:00:00', '2026-01-02 16:59:59.999000', 1.0, '2026', 'morning', 'approved hrd', 'cuti', 1901016, '2026-02-11 05:15:16.852000', NULL, NULL, 1901016, '2026-02-11 07:14:20.224000', NULL, NULL, '', '', 'paid', NULL, NULL, 1, 1801005, 1, NULL),
  (712, '2026-02-11 23:07:15.766000', '2026-02-12 06:30:26.292000', 1901016, 1801008, NULL, '2026-02-02 17:00:00', '2026-02-03 16:59:59.999000', 1.0, '2026', 'morning', 'approved hrd', 'sakit karna batuk dan demam', 1801008, '2026-02-12 04:55:07.475000', NULL, NULL, 1801008, '2026-02-12 06:30:26.291000', NULL, NULL, '', '1901016-1770851235.png', 'paid', NULL, NULL, 1, 1901016, 2, NULL);

-- --------------------------------------------------------------------
-- Table structure for `location_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `location_categories`;
CREATE TABLE `location_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_location_categories_id` (`id`),
  UNIQUE KEY `idx_location_categories` (`name`,`company_id`),
  KEY `idx_location_categories_deleted_at` (`deleted_at`),
  KEY `idx_location_categories_name` (`name`) USING BTREE,
  KEY `fk_companies_location_category` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=60003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `location_categories` (5 rows)
INSERT INTO `location_categories` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `company_id`) VALUES
  (9, '2023-07-10 15:30:47.691000', '2023-07-10 15:30:47.691000', NULL, 8, 8, NULL, 'Apotek', 1),
  (11, '2023-06-19 01:27:07.770000', NULL, NULL, 15010001, 15010001, NULL, 'Rumah Sakit Pemerintah', 1),
  (14, '2023-06-19 01:27:07.770000', NULL, NULL, 15010001, 15010001, NULL, 'Intitusi', 1),
  (15, '2023-06-19 01:27:07.770000', NULL, NULL, 15010001, 15010001, NULL, 'Klinik/Poliklinik', 1),
  (16, '2023-06-19 01:27:07.770000', NULL, NULL, 15010001, 15010001, NULL, 'Lain-Lain', 1);

-- --------------------------------------------------------------------
-- Table structure for `location_groups`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `location_groups`;
CREATE TABLE `location_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `area_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_location_groups` (`name`,`latitude`,`longitude`,`company_id`),
  KEY `idx_location_groups_deleted_at` (`deleted_at`),
  KEY `idx_location_groups_name` (`name`) USING BTREE,
  KEY `idx_location_groups_longitude` (`longitude`) USING BTREE,
  KEY `idx_location_groups_latitude` (`latitude`) USING BTREE,
  KEY `idx_location_groups_company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=180057 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `location_groups` (5 rows)
INSERT INTO `location_groups` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `address`, `latitude`, `longitude`, `area_id`, `company_id`, `image`) VALUES
  (1, '2023-08-11 07:16:19.233000', '2023-08-11 07:16:19.233000', NULL, 4220973, 4220973, NULL, 'Non Outlet Category', 'Jakarta ', NULL, NULL, '-', 2, NULL),
  (2, '2023-08-11 07:16:19.233000', '2023-08-11 07:16:19.233000', NULL, 4220973, 4220973, NULL, 'Non Outlet Category', 'Jakarta ', NULL, NULL, '-', 1, NULL),
  (180011, '2024-07-02 02:53:15.236000', '2024-07-02 02:53:15.236000', NULL, 1240917, 1240917, NULL, 'Test Group Location', 'Jakarta', -6.235418736416629, 106.78102042526007, NULL, 1, ''),
  (180015, '2024-07-17 05:26:08.460000', '2024-07-17 05:26:08.460000', NULL, 1240917, 1240917, NULL, 'Siloam kebun jeruk', 'Siloam kebun jeruk', -6.190568965924321, 106.76370173692703, NULL, 1, ''),
  (180016, '2024-07-17 05:29:03.034000', '2024-07-17 05:29:03.034000', NULL, 1240917, 1240917, NULL, 'Poli Penyakit Dalam  RS Siloam Kebon Jeruk ', 'jl kebon jeruk ', -6.1910502812873665, 106.76455266773701, NULL, 1, 'Poli Penyakit Dalam  RS Siloam Kebon Jeruk -1721194143.png');

-- --------------------------------------------------------------------
-- Table structure for `location_location_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `location_location_categories`;
CREATE TABLE `location_location_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `location_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `location_category_id` bigint unsigned DEFAULT NULL,
  `company_id` bigint NOT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_location_location_categories` (`location_id`,`location_category_id`,`company_id`),
  KEY `idx_location_location_categories_deleted_at` (`deleted_at`),
  KEY `fk_location_categories_location_location_category` (`location_category_id`),
  KEY `idx_location_location_categories_location_id` (`location_id`) USING BTREE,
  KEY `idx_location_location_categories_company_id` (`company_id`) USING BTREE,
  CONSTRAINT `fk_locations_location_location_category` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  CONSTRAINT `location_location_categories_ibfk_1` FOREIGN KEY (`location_category_id`) REFERENCES `location_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=549303 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `location_location_categories` (5 rows)
INSERT INTO `location_location_categories` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `location_id`, `location_category_id`, `company_id`) VALUES
  (452691, '2024-10-07 10:20:56.007000', '2025-09-09 13:33:56', NULL, NULL, NULL, NULL, 'ABW160001', 9, 1),
  (452692, '2024-10-07 10:20:56.007000', '2025-09-09 13:33:56', NULL, NULL, NULL, NULL, 'ABW160002', 9, 1),
  (452694, '2024-10-07 10:20:56.007000', '2025-09-09 13:33:56', NULL, NULL, NULL, NULL, 'ABW160005', 9, 1),
  (452695, '2024-10-07 10:20:56.007000', '2025-09-09 13:33:56', NULL, NULL, NULL, NULL, 'ABW160006', 20, 1),
  (452696, '2024-10-07 10:20:56.007000', '2025-09-09 13:33:56', NULL, NULL, NULL, NULL, 'ABW160007', 22, 1);

-- --------------------------------------------------------------------
-- Table structure for `location_logs`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `location_logs`;
CREATE TABLE `location_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `location_id` varchar(20) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `is_manual` tinyint(1) DEFAULT '0',
  `created_by_id` int DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_location_logs_location_id` (`location_id`),
  KEY `idx_location_logs_created_by_id` (`created_by_id`),
  KEY `idx_location_logs_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2762 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `location_logs` (5 rows)
INSERT INTO `location_logs` (`id`, `location_id`, `latitude`, `longitude`, `is_manual`, `created_by_id`, `created_at`) VALUES
  (1, 'PRB160047', -7.753927399999999, 113.2163262, 0, 1151752, '2026-04-15 01:49:35'),
  (2, 'MGT160059', -7.6516340373949445, 111.3212264701724, 0, 1261133, '2026-04-15 02:37:16'),
  (3, 'ASM160001', -6.235670039004869, 106.78058657795191, 0, 123, '2026-04-15 02:50:40'),
  (4, 'PBL257003', -7.745126000000001, 113.2105756, 0, 1151752, '2026-04-15 02:57:06'),
  (5, 'MAD160007', -7.620648800000001, 111.5242875, 0, 1261132, '2026-04-15 02:58:50');

-- --------------------------------------------------------------------
-- Table structure for `location_subs`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `location_subs`;
CREATE TABLE `location_subs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_location_subs` (`name`,`company_id`),
  KEY `idx_location_subs_deleted_at` (`deleted_at`),
  KEY `idx_location_subs_name` (`name`) USING BTREE,
  KEY `idx_location_subs_company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=120008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `location_subs` (5 rows)
INSERT INTO `location_subs` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `company_id`) VALUES
  (2, '2023-07-08 04:39:16.772000', '2023-07-08 04:39:16.772000', NULL, 1, 1, NULL, 'Cathlab', 1),
  (3, '2023-07-08 04:41:14.341000', '2023-07-08 04:41:14.341000', NULL, 1, 1, NULL, 'Ruang Kemoterapi', 1),
  (4, '2023-07-08 04:41:26.087000', '2023-07-08 04:41:26.087000', NULL, 1, 1, NULL, 'Ruang Haemodialis', 1),
  (5, '2023-07-08 04:41:58.238000', '2023-07-08 04:41:58.238000', NULL, 1, 1, NULL, 'Gudang Farmasi', 1),
  (6, '2023-07-08 04:42:09.385000', '2023-07-08 04:42:09.385000', NULL, 1, 1, NULL, 'Apotek PICU NICU', 1);

-- --------------------------------------------------------------------
-- Table structure for `locations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations` (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `no_location_by_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `location_api` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `area_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint unsigned NOT NULL,
  `image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `province` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `city` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `district` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sub_district` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_group_id` bigint DEFAULT NULL,
  `location_sub_id` bigint DEFAULT NULL,
  `area_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `class` varchar(50) DEFAULT NULL,
  `manual_counter` int DEFAULT '0',
  `is_manual` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_locations_id` (`id`),
  UNIQUE KEY `idx_locations` (`name`,`area_id`,`company_id`,`id`),
  KEY `idx_locations_deleted_at` (`deleted_at`),
  KEY `fk_areas_location` (`area_id`),
  KEY `fk_companies_location` (`company_id`),
  KEY `idx_locations_status` (`status`(191)) USING BTREE,
  KEY `idx_locations_no_location_by_company` (`no_location_by_company`) USING BTREE,
  KEY `idx_locations_name` (`name`) USING BTREE,
  KEY `idx_locations_city` (`city`(191)) USING BTREE,
  CONSTRAINT `fk_areas_location` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`),
  CONSTRAINT `fk_companies_location` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `locations` (5 rows)
INSERT INTO `locations` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `latitude`, `longitude`, `address`, `no_location_by_company`, `location_api`, `area_id`, `company_id`, `image`, `province`, `city`, `district`, `sub_district`, `location_group_id`, `location_sub_id`, `area_name`, `status`, `location_tag`, `class`, `manual_counter`, `is_manual`) VALUES
  ('1729473495', '2024-10-21 01:18:15.767000', '2024-10-21 01:18:15.767000', NULL, 1240917, 1240917, NULL, 'group 10 2024-Ruang Kemoterapi', 0.0, 0.0, 'Jalan Raya Kebayoran Lama, RW 01, Grogol Selatan, Kebayoran Lama, Jakarta Selatan, Daerah Khusus Ibukota Jakarta, Jawa, 12220, Indonesia', 'new', ' ', 'DKI', 1, 'group 10 2024-Ruang Kemoterapi-1729473495.png', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'Kebayoran Lama', 'Grogol Selatan', 180036, 3, 'DKI JAKARTA', 'draft', NULL, NULL, 0, 0),
  ('1729479940', '2024-10-21 03:05:40.500000', '2024-10-21 03:12:15.490000', NULL, 1240974, 1220776, NULL, 'JKT group102024-Apotek PICU NICU', 0.0, 0.0, 'Jalan Raya Kebayoran Lama, RW 01, Grogol Selatan, Kebayoran Lama, Jakarta Selatan, Daerah Khusus Ibukota Jakarta, Jawa, 12220, Indonesia', 'new', ' ', 'DKI', 1, '', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'Kebayoran Lama', 'Grogol Selatan', 180038, 6, 'DKI JAKARTA', 'approve', NULL, NULL, 0, 0),
  ('1729481948', '2024-10-21 03:39:08.481000', '2024-10-21 03:53:28.431000', NULL, 1240974, 1220776, NULL, 'JKT group102024-Apotek Rawat Inap Poli Penyakit Dalam', 0.0, 0.0, 'Jalan KPBD, RW 01, Sukabumi Selatan, Kebon Jeruk, Jakarta Barat, Daerah Khusus Ibukota Jakarta, Jawa, 11560, Indonesia', 'new', ' ', 'DKI', 1, '', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'Kebayoran Lama', 'Grogol Selatan', 180038, 13, 'DKI JAKARTA', 'approve', NULL, NULL, 0, 0),
  ('1729584693', '2024-10-22 08:11:33.874000', '2024-10-24 12:17:59.908000', NULL, 1240974, 1220776, NULL, 'JKT group102024-Apotek Rawat Inap Poli Penyakit Dalam', 0.0, 0.0, 'Jalan Raya Kebayoran Lama, RW 01, Grogol Selatan, Kebayoran Lama, Jakarta Selatan, Daerah Khusus Ibukota Jakarta, Jawa, 12220, Indonesia', 'new', ' ', 'DKI', 1, '', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'Kebayoran Lama', 'Grogol Selatan', 180038, 13, 'DKI JAKARTA', 'approve', NULL, NULL, 0, 0),
  ('1729761446', '2024-10-24 09:17:26.572000', '2024-10-24 11:55:07.125000', NULL, 1240974, 1220776, NULL, 'group 10 2024-Ruang Kemoterapi', 0.0, 0.0, 'Jalan Raya Kebayoran Lama, RW 01, Grogol Selatan, Kebayoran Lama, Jakarta Selatan, Daerah Khusus Ibukota Jakarta, Jawa, 12220, Indonesia', 'new', ' ', 'DKI', 1, '', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'Kebayoran Lama', 'Grogol Selatan', 180036, 3, 'DKI JAKARTA', 'approve', NULL, NULL, 0, 0);

-- --------------------------------------------------------------------
-- Table structure for `manual_process_endpoints`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `manual_process_endpoints`;
CREATE TABLE `manual_process_endpoints` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by_id` int DEFAULT NULL,
  `updated_by_id` int DEFAULT NULL,
  `deleted_by_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `is_auth` tinyint(1) DEFAULT '0',
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `manual_process_endpoints` (5 rows)
INSERT INTO `manual_process_endpoints` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `description`, `is_auth`, `method`, `url`) VALUES
  (1, '2025-09-03 08:52:08', '2025-09-03 08:52:08', NULL, 2207004, 2207004, NULL, 'Visit Daily Call', 'Process Report Visit Daily Call', 1, 'POST', 'https://visit-flow-api.flexurio.com/process/visits/daily-calls/??????'),
  (2, '2025-09-03 08:52:08', '2025-09-03 08:52:08', NULL, 2207004, 2207004, NULL, 'Target Sector Structure', 'Process Target Sector Structure', 0, 'PATCH', 'https://mf-marketing-api-v2.flexurio.com/target_sector_structures?period.eq=??????'),
  (3, '2025-09-03 08:52:08', '2025-09-03 08:52:08', NULL, 2207004, 2207004, NULL, 'Visit Call Detail', 'Process Report Visit Call Detail', 1, 'POST', 'https://visit-flow-api.flexurio.com/process/visits/call-details/??????'),
  (4, '2025-09-03 08:52:08', '2025-09-03 08:52:08', NULL, 2207004, 2207004, NULL, 'Outlet Summary', 'Process Outlet Summary', 0, 'PATCH', 'https://mf-marketing-api-v2.flexurio.com/outlet_summarys?period.eq=??????'),
  (5, '2025-09-03 08:52:08', '2025-09-03 08:52:08', NULL, 2207004, 2207004, NULL, 'Outlet Summary Cross Selling', 'Process Outlet Summary Cross Selling', 0, 'PATCH', 'https://mf-marketing-api-v2.flexurio.com/outlet_summary_cross_sellings?period.eq=??????');

-- --------------------------------------------------------------------
-- Table structure for `master_call_list`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `master_call_list`;
CREATE TABLE `master_call_list` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) NOT NULL,
  `structure_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `position` varchar(30) DEFAULT NULL,
  `city` varchar(5) NOT NULL DEFAULT '',
  `user_id` bigint unsigned DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `spv` varchar(20) DEFAULT NULL,
  `asm` varchar(20) DEFAULT NULL,
  `fsm` varchar(20) DEFAULT NULL,
  `type_call` varchar(20) NOT NULL DEFAULT '',
  `code` varchar(100) DEFAULT NULL,
  `name` varchar(500) DEFAULT NULL,
  `customer_position_or_sector` varchar(150) DEFAULT NULL,
  `sps_or_class` varchar(250) DEFAULT NULL,
  `dk_lk` varchar(2) NOT NULL DEFAULT '',
  `status` varchar(20) DEFAULT NULL,
  `note_reject` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `priority` varchar(100) DEFAULT NULL,
  `cluster` varchar(50) DEFAULT NULL,
  `amortization` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_master_call_list_period_structur_id_code` (`period`,`structure_id`,`code`),
  KEY `idx_master_call_list_deleted_at` (`deleted_at`),
  KEY `idx_master_call_list_period` (`period`),
  KEY `idx_master_call_list_structur_id` (`structure_id`),
  KEY `idx_master_call_list_code` (`code`),
  KEY `idx_master_call_list_deleted_period_structur_id_code` (`deleted_at`,`period`,`structure_id`,`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4456685 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `master_call_list` (5 rows)
INSERT INTO `master_call_list` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `structure_id`, `position`, `city`, `user_id`, `user_name`, `spv`, `asm`, `fsm`, `type_call`, `code`, `name`, `customer_position_or_sector`, `sps_or_class`, `dk_lk`, `status`, `note_reject`, `priority`, `cluster`, `amortization`) VALUES
  (12286, NULL, NULL, NULL, NULL, NULL, NULL, '202509', 'AMP', 'MR', 'KECIL', NULL, 'AMP(SALES-IN PDU AMP)', 'AMP2', 'AMP3', 'AMP4', '', NULL, NULL, '', '', '', NULL, '', NULL, NULL, '0'),
  (12287, NULL, NULL, NULL, NULL, NULL, NULL, '202509', 'AMP2', 'SPV', '', NULL, 'AMP(SALES-IN PDU AMP)', 'AMP2', 'AMP3', 'AMP4', '', NULL, NULL, '', '', '', NULL, '', NULL, NULL, '0'),
  (12288, NULL, NULL, NULL, NULL, NULL, NULL, '202509', 'AMP3', 'ASM', '', NULL, 'AMP(SALES-IN PDU AMP)', '', 'AMP3', 'AMP4', '', NULL, NULL, '', '', '', NULL, '', NULL, NULL, '0'),
  (12289, NULL, NULL, NULL, NULL, NULL, NULL, '202509', 'AMP4', 'FSM', '', NULL, 'AMP(SALES-IN PDU AMP)', '', '', 'AMP4', '', NULL, NULL, '', '', '', NULL, '', NULL, NULL, '0'),
  (12290, NULL, NULL, NULL, NULL, NULL, NULL, '202509', 'AMP5', 'GM', '', NULL, 'AMP(SALES-IN PDU AMP)', '', '', '', '', NULL, NULL, '', '', '', NULL, '', NULL, NULL, '0');

-- --------------------------------------------------------------------
-- Table structure for `materials`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `materials`;
CREATE TABLE `materials` (
  `created_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_materials_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `materials` (4 rows)
INSERT INTO `materials` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `company_id`, `name`) VALUES
  ('1212', '2023-06-28 03:05:41.896000', '1212', '2023-06-28 03:05:41.896000', NULL, NULL, 'Aluminium Foil', '1', 'Aluminium Foil'),
  ('1212', '2023-06-28 03:05:41.896000', '1212', '2023-06-28 03:05:41.896000', NULL, NULL, 'Batu', '1', 'Keramat'),
  ('1212', '2023-06-28 03:05:41.896000', '1212', '2023-06-28 03:05:41.896000', NULL, NULL, 'Batu2', '2', 'Keramat'),
  ('1212', '2023-06-28 03:05:41.896000', '1212', '2023-06-28 03:05:41.896000', NULL, NULL, 'Plastik', '1', 'Plastik');

-- --------------------------------------------------------------------
-- Table structure for `mcl_recommendation_plan_amortizations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `mcl_recommendation_plan_amortizations`;
CREATE TABLE `mcl_recommendation_plan_amortizations` (
  `fsm_code` varchar(20) DEFAULT NULL,
  `fsm_name` varchar(100) DEFAULT NULL,
  `asm_code` varchar(20) DEFAULT NULL,
  `asm_name` varchar(100) DEFAULT NULL,
  `spv_code` varchar(20) DEFAULT NULL,
  `spv_name` varchar(100) DEFAULT NULL,
  `mr_code` varchar(20) DEFAULT NULL,
  `mr_name` varchar(100) DEFAULT NULL,
  `customer_code` varchar(50) DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `sps` varchar(100) DEFAULT NULL,
  `is_new_user` varchar(1) DEFAULT NULL,
  `is_existing` varchar(1) DEFAULT NULL,
  `is_up_selling` varchar(1) DEFAULT NULL,
  `is_cross_selling` varchar(1) DEFAULT NULL,
  `histori_avg_spc_jan_nmin2` double DEFAULT NULL,
  `estimasi_spc_month` double DEFAULT NULL,
  `period_start` varchar(6) DEFAULT NULL,
  `period_end` varchar(6) DEFAULT NULL,
  `total_months` int DEFAULT NULL,
  `value_ski_amor` double DEFAULT NULL,
  `total_est_sales` double DEFAULT NULL,
  `fkp` varchar(5) DEFAULT NULL,
  `no_spc_amor` varchar(20) DEFAULT NULL,
  `t` varchar(1) DEFAULT NULL,
  `upload_data` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `mcl_recommendation_plan_amortizations` (5 rows)
INSERT INTO `mcl_recommendation_plan_amortizations` (`fsm_code`, `fsm_name`, `asm_code`, `asm_name`, `spv_code`, `spv_name`, `mr_code`, `mr_name`, `customer_code`, `customer_name`, `sps`, `is_new_user`, `is_existing`, `is_up_selling`, `is_cross_selling`, `histori_avg_spc_jan_nmin2`, `estimasi_spc_month`, `period_start`, `period_end`, `total_months`, `value_ski_amor`, `total_est_sales`, `fkp`, `no_spc_amor`, `t`, `upload_data`) VALUES
  ('R1.4', 'Idris Firdaus', 'JKTA6', 'Arif Maulana', 'JKTA4S5', 'Bayu Saputra', 'JKTA1S103', 'Wita Pasha', 'DKI19-0125', 'HERY EMRIA', 'SP.PD K(GEH) - SPESIALIS PENYAKIT DALAM - KONSULTAN GASTROENTEROHEPATOLOGI', NULL, '✓', '✓', NULL, 2546400.0, 5046400.0, '202607', '202609', 3, 1135440.0, 15139200.0, NULL, NULL, 'y', '2026-07-29 15:23:30'),
  ('R1.4', 'Idris Firdaus', 'JKTA6', 'Arif Maulana', 'JKTA4S5', 'Bayu Saputra', 'JKTA1S103', 'Wita Pasha', 'DKI20-0039', 'AIDA RIYANTI', 'SP.OG-KFER - SPESIALIS OBSTETRI & GINEKOLOGI - KONSULTAN FERTILITAS', NULL, '✓', NULL, NULL, 6168000.0, 8668000.0, '202607', '202609', 3, 2600400.0, 26004000.0, NULL, NULL, 'y', '2026-07-29 15:23:30'),
  ('R1.4', 'Idris Firdaus', 'JKTA6', 'Arif Maulana', 'JKTA4S5', 'Bayu Saputra', 'JKTA1S103', 'Wita Pasha', '23070158', 'CIPUTRA LINARDY', 'SP.B - SPESIALIS BEDAH', NULL, '✓', NULL, NULL, 5940000.0, 8440000.0, '202607', '202609', 3, 2532000.0, 25320000.0, NULL, NULL, 'y', '2026-07-29 15:23:30'),
  ('R1.4', 'Idris Firdaus', 'JKTA6', 'Arif Maulana', 'JKTA4S5', 'Bayu Saputra', 'JKTA1S103', 'Wita Pasha', '26020121', 'SARDITO PHAN', 'SP.A - SPESIALIS ANAK', NULL, '✓', NULL, NULL, 210000.0, 2710000.0, '202607', '202609', 3, 1056900.0, 8130000.0, NULL, NULL, 'y', '2026-07-29 15:23:30'),
  ('R1.4', 'Idris Firdaus', 'JKTA6', 'Arif Maulana', 'JKTA4S5', 'Bayu Saputra', 'JKTA1S103', 'Wita Pasha', 'DKI17-1727', 'NUGROHO SETIAWAN', 'SP.AND - SPESIALIS ANDROLOGI', NULL, '✓', NULL, NULL, 0.0, 2500000.0, '202607', '202609', 3, 1125000.0, 7500000.0, NULL, NULL, 'y', '2026-07-29 15:23:30');

-- --------------------------------------------------------------------
-- Table structure for `menu_users`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `menu_users`;
CREATE TABLE `menu_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  `access` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by_id` int DEFAULT NULL,
  `closed_by_id` int DEFAULT NULL,
  `updated_by_id` int DEFAULT NULL,
  `deleted_by_id` int DEFAULT NULL,
  `name` varchar(255) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_menu_user` (`menu_id`,`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `menu_users` (5 rows)
INSERT INTO `menu_users` (`id`, `user_id`, `menu_id`, `access`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `closed_by_id`, `updated_by_id`, `deleted_by_id`, `name`) VALUES
  (1, 2207004, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0'),
  (2, 2207004, 2, 1, '2025-03-13 01:17:47', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL, '0'),
  (3, 1220776, 3, 1, '2025-03-13 01:17:47', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL, '0'),
  (4, 1220776, 4, 1, '2025-03-13 01:17:47', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL, '0'),
  (5, 1182118, 3, 1, '2025-03-13 01:17:47', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL, '0');

-- --------------------------------------------------------------------
-- Table structure for `menus`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `entity` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by_id` int DEFAULT NULL,
  `closed_by_id` int DEFAULT NULL,
  `updated_by_id` int DEFAULT NULL,
  `deleted_by_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_period_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `menus` (5 rows)
INSERT INTO `menus` (`id`, `name`, `url`, `entity`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `closed_by_id`, `updated_by_id`, `deleted_by_id`) VALUES
  (1, 'CUSTOMER', 'https://ski-compliance-metiska-farma-api.flexurio.com/discount-proposals/over-budget', 'customer', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
  (2, 'STRUCTURE', 'https://ski-compliance-metiska-farma-api.flexurio.com/discount-proposals/over-budget', 'structure', '2025-03-13 01:13:17', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL),
  (3, 'BUDGET', 'http://103.245.16.157:3010/discount_proposal_budgets', 'budget', '2025-03-13 01:13:17', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL),
  (4, 'OVER BUDGET', 'https://ski-compliance-metiska-farma-api.flexurio.com/discount-proposals/over-budget', 'over_budget', '2025-03-13 01:13:17', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL),
  (5, 'POA', 'https://ski-compliance-metiska-farma-api.flexurio.com/discount-proposals/over-budget', 'poa', '2025-03-13 01:13:17', '2024-02-01 00:00:00', NULL, 2207004, NULL, 2207004, NULL);

-- --------------------------------------------------------------------
-- Table structure for `office_users`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `office_users`;
CREATE TABLE `office_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `office_id` varchar(20) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_office_user` (`office_id`,`user_id`),
  KEY `idx_office_users_deleted_at` (`deleted_at`),
  KEY `idx_office_id` (`office_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_deleted_office` (`user_id`,`deleted_at`,`office_id`),
  CONSTRAINT `fk_offices_office_users` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `office_users` (5 rows)
INSERT INTO `office_users` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `office_id`, `user_id`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, 'T1', 1240917),
  (2, NULL, NULL, NULL, NULL, NULL, NULL, 'BKSA1', 1172063),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, 'BKSA1', 1190404),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, 'BKSA1', 1200505),
  (5, NULL, NULL, NULL, NULL, NULL, NULL, 'BKSA1', 1200547);

-- --------------------------------------------------------------------
-- Table structure for `offices`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `offices`;
CREATE TABLE `offices` (
  `id` varchar(20) NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `radius` float NOT NULL,
  `description` varchar(300) NOT NULL,
  `address` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_offices_name` (`name`),
  UNIQUE KEY `idx_office_coordinate` (`latitude`,`longitude`),
  KEY `idx_offices_deleted_at` (`deleted_at`),
  KEY `idx_offices_id_deleted` (`id`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `offices` (5 rows)
INSERT INTO `offices` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `latitude`, `longitude`, `radius`, `description`, `address`) VALUES
  ('BDGA1', NULL, '2026-04-20 09:28:49.387000', NULL, NULL, 1210952, NULL, 'Bandung', -6.9092028, 107.5703402, 50.0, 'Office Area', 'Jl. Maleber Barat No.8, Maleber, Kec. Andir, Kota Bandung, Jawa Barat 40184'),
  ('BDLA2', NULL, NULL, NULL, NULL, NULL, NULL, 'Bandar Lampung', -5.4108972, 105.2892589, 80.0, 'Office Area', 'Jl. HRM Mangundirpojo No.45 Kedamaian , Bandar Lampung'),
  ('BGRA1', NULL, '2025-05-28 09:30:54.484000', NULL, NULL, 1230992, NULL, 'Bogor', -6.51941003731569, 106.81217868764394, 50.0, 'Office Area', 'Jl Bumi Karadenan Permai ,Perum Puri Karadenan Blok C No 09 RT 001/017 Karadenan-Bogor'),
  ('BJMA1', NULL, NULL, NULL, NULL, NULL, NULL, 'Banjarmasin', -3.323035, 114.573224, 50.0, 'Office Area', 'Jl. Soetoyo S Ruko Penta Valent No. 9, 10, 11 Kel. Telaga Biru Kec. Banjarmasin Barat'),
  ('BKSA1', NULL, '2026-09-15 01:37:04.203000', NULL, NULL, 1090568, NULL, 'Bekasi', -6.244569, 106.9811439, 50.0, 'Office Area', 'Jl. Letnan Arsyad Raya No.12, RT.001/RW.025, Bekasi Kota, 17144, Jawa Barat, ID
(Kontrak rumah)');

-- --------------------------------------------------------------------
-- Table structure for `outlet_survey_customer_materials`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `outlet_survey_customer_materials`;
CREATE TABLE `outlet_survey_customer_materials` (
  `created_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `deleted_at` datetime(3) DEFAULT NULL,
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `outlet_survey_customer_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `material_id` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`question`,`outlet_survey_customer_id`,`material_id`,`company_id`),
  KEY `fk_outlet_survey_customers_outlet_survey_customer_material` (`outlet_survey_customer_id`),
  KEY `fk_materials_outlet_survey_customer_material` (`material_id`),
  CONSTRAINT `fk_materials_outlet_survey_customer_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `outlet_survey_customer_materials` (5 rows)
INSERT INTO `outlet_survey_customer_materials` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `question`, `outlet_survey_customer_id`, `material_id`, `company_id`, `value`) VALUES
  ('1212', '2023-09-29 08:08:17.166000', '1212', '2023-09-29 08:15:52.453000', '2023-10-02 03:42:16.920', NULL, 'Hobi', '20230929-333-23070002', 'SURVEY-OTC', '1', 'ffafaf'),
  ('1212', '2023-09-29 08:08:17.719000', '1212', '2023-09-29 08:14:47.958000', '2023-10-02 03:42:16.920', NULL, 'Hobi', '20230929-333-23070010', 'SURVEY-OTC', '1', '20-30'),
  ('1212', '2023-09-29 08:15:52.495000', '1212', '2023-09-29 08:15:52.591000', '2023-10-02 03:42:16.920', NULL, 'Hobi', '20230929-333-23070011', 'SURVEY-OTC', '1', 'hhahaha'),
  ('1212', '2023-09-29 08:20:04.337000', '1212', '2023-09-29 08:20:04.664000', '2023-10-02 03:42:16.920', NULL, 'Hobi', '20230929-333-23070053', 'SURVEY-OTC', '1', 'dasdad'),
  ('1212', '2023-09-29 08:20:03.133000', '1212', '2023-09-29 08:20:04.272000', '2023-10-02 03:42:16.920', NULL, 'Hobi', '20230929-333-23070056', 'SURVEY-OTC', '1', 'dadada');

-- --------------------------------------------------------------------
-- Table structure for `outlet_survey_customer_products`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `outlet_survey_customer_products`;
CREATE TABLE `outlet_survey_customer_products` (
  `created_by_id` longtext,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext,
  `deleted_at` datetime(3) DEFAULT NULL,
  `question` varchar(500) NOT NULL,
  `outlet_survey_customer_id` varchar(191) NOT NULL,
  `product_id` varchar(20) NOT NULL,
  `company_id` varchar(10) NOT NULL,
  `value` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`question`,`outlet_survey_customer_id`,`product_id`,`company_id`),
  KEY `fk_outlet_survey_customer_products_product` (`product_id`),
  CONSTRAINT `fk_outlet_survey_customer_products_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `outlet_survey_customer_products` (5 rows)
INSERT INTO `outlet_survey_customer_products` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `question`, `outlet_survey_customer_id`, `product_id`, `company_id`, `value`) VALUES
  ('1212', '2023-09-29 08:08:17.166000', '1212', '2023-09-29 08:15:52.453000', '2023-10-02 03:42:16.920', NULL, 'Hobi', '20230929-333-23070002', '1', '1', 'ffafaf'),
  ('1182262', '2024-06-27 08:40:02.430000', '1182262', '2024-06-27 08:40:02.430000', NULL, NULL, 'Jumlah R/Hari', '20240627-DKI230114-23060038', '1', '1', ''),
  ('1182262', '2024-06-27 08:42:22.857000', '1182262', '2024-06-27 08:42:22.857000', NULL, NULL, 'Jumlah R/Hari', '20240627-DKI230114-23060038', '5', '1', ''),
  ('1182262', '2024-06-27 08:45:39.955000', '1182262', '2024-06-27 11:23:48.664000', NULL, NULL, 'Jumlah R/Hari', '20240627-DKI230114-23060044', '5', '1', '100'),
  ('1182262', '2024-06-27 10:47:31.525000', '1182262', '2024-06-27 10:47:31.525000', NULL, NULL, 'Jumlah R/Hari', '20240627-DKI230114-23060044', '8', '1', '99');

-- --------------------------------------------------------------------
-- Table structure for `outlet_survey_customers`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `outlet_survey_customers`;
CREATE TABLE `outlet_survey_customers` (
  `created_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `outlet_survey_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`,`customer_id`,`outlet_survey_id`),
  KEY `fk_outlet_surveys_outlet_survey_customer` (`outlet_survey_id`),
  CONSTRAINT `fk_outlet_surveys_outlet_survey_customer` FOREIGN KEY (`outlet_survey_id`) REFERENCES `outlet_surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `outlet_survey_customers` (5 rows)
INSERT INTO `outlet_survey_customers` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `company_id`, `customer_id`, `outlet_survey_id`) VALUES
  ('1212', '2023-09-29 03:11:18.031000', '1212', '2023-09-29 03:11:18.031000', '2023-09-29 03:11:18.031', NULL, '20230929-20230928-333-1691503231', '1', '1691503231', '20230928-333'),
  ('1212', '2023-09-29 08:14:48.080000', '1212', '2023-09-29 08:14:48.080000', '2023-09-29 03:11:18.031', NULL, '20230929-20230929-333-23070002', '1', '23070002', '20230929-333'),
  ('1212', '2023-09-29 08:14:48.307000', '1212', '2023-09-29 08:14:48.307000', '2023-09-29 03:11:18.031', NULL, '20230929-20230929-333-23070010', '1', '23070010', '20230929-333'),
  ('1212', '2023-09-29 08:15:52.652000', '1212', '2023-09-29 08:15:52.652000', '2023-09-29 03:11:18.031', NULL, '20230929-20230929-333-23070011', '1', '23070011', '20230929-333'),
  ('1212', '2023-09-29 08:20:04.969000', '1212', '2023-09-29 08:20:04.969000', '2023-09-29 03:11:18.031', NULL, '20230929-20230929-333-23070053', '1', '23070053', '20230929-333');

-- --------------------------------------------------------------------
-- Table structure for `outlet_survey_questions`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `outlet_survey_questions`;
CREATE TABLE `outlet_survey_questions` (
  `created_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `deleted_at` datetime(3) DEFAULT NULL,
  `outlet_survey_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`outlet_survey_id`,`question`,`company_id`),
  KEY `idx_osq_survey_del` (`outlet_survey_id`,`deleted_at`),
  CONSTRAINT `fk_outlet_surveys_outlet_survey_question` FOREIGN KEY (`outlet_survey_id`) REFERENCES `outlet_surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `outlet_survey_questions` (5 rows)
INSERT INTO `outlet_survey_questions` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `outlet_survey_id`, `question`, `company_id`, `value`) VALUES
  ('1212', '2023-09-29 08:08:16.912000', '1212', '2023-09-29 08:08:16.912000', '2023-10-02 08:02:52.182', NULL, '20230929-333', 'Nama outlet', '1', 'asdadad'),
  ('1212', '2023-10-02 03:42:16.035000', '1212', '2023-10-02 03:42:16.035000', '2023-10-02 08:02:52.182', NULL, '20231002-333', 'Nama outlet', '1', 'Outlet Sehati'),
  ('4170702', '2023-10-02 08:02:52.182000', '4170702', '2023-10-02 08:02:52.182000', '2023-10-02 08:02:52.182', NULL, '20231002-4170702', 'Nama outlet', '2', 'Outlet Sahari'),
  ('4170702', '2023-10-03 04:33:47.985000', '4170702', '2023-10-03 04:33:47.985000', '2023-10-02 08:02:52.182', NULL, '20231003-4170702', 'Nama outlet', '2', 'Mentari'),
  ('1220809', '2023-10-06 07:35:56.104000', '1220809', '2023-10-06 07:35:56.104000', '2023-10-02 08:02:52.182', NULL, '20231006-1220809', 'Jumlah Karyawan Apotek', '1', '25');

-- --------------------------------------------------------------------
-- Table structure for `outlet_surveys`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `outlet_surveys`;
CREATE TABLE `outlet_surveys` (
  `created_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `period` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `outlet_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `distributor_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `visit_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `uidx_outlet_surveys_id` (`id`),
  KEY `fk_distributors_outlet_survey` (`distributor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `outlet_surveys` (5 rows)
INSERT INTO `outlet_surveys` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `company_id`, `period`, `outlet_id`, `distributor_id`, `visit_id`) VALUES
  ('1212', '2023-09-29 08:08:16.863000', '1212', '2023-09-29 08:20:02.324000', '2023-10-06 08:31:16.340', NULL, '20230929-333', '1', '20230929', '333', 'AMP,ENGGAL,KF', 111),
  ('1212', '2023-10-02 03:42:15.955000', '1212', '2023-10-02 03:42:15.955000', '2023-10-06 08:31:16.340', NULL, '20231002-333', '1', '20231002', '333', 'AMP,CASH', 111),
  ('4170702', '2023-10-02 08:02:51.560000', '4170702', '2023-10-02 08:02:51.560000', '2023-10-06 08:31:16.340', NULL, '20231002-4170702', '2', '20231002', '4170702', 'CMA', 900365),
  ('4170702', '2023-10-03 04:33:47.812000', '4170702', '2023-10-03 04:33:47.812000', '2023-10-06 08:31:16.340', NULL, '20231003-4170702', '2', '20231003', '4170702', 'CMA,PVBL', 900431),
  ('1220809', '2023-10-06 07:35:55.354000', '1220809', '2023-10-06 08:31:16.340000', '2023-10-06 08:31:16.340', NULL, '20231006-1220809', '1', '20231006', '1220809', 'MPI', 900435);

-- --------------------------------------------------------------------
-- Table structure for `potential_customer_products`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `potential_customer_products`;
CREATE TABLE `potential_customer_products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(8) DEFAULT NULL,
  `structure_id` varchar(20) DEFAULT NULL,
  `customer_id` varchar(20) DEFAULT NULL,
  `product_id` varchar(20) DEFAULT NULL,
  `product_name` varchar(500) DEFAULT NULL,
  `qty` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_period_structure_customer_product` (`period`,`structure_id`,`customer_id`,`product_id`) USING BTREE,
  KEY `idx_structure` (`structure_id`) USING BTREE,
  KEY `idx_customer` (`customer_id`) USING BTREE,
  KEY `idx_product` (`product_id`) USING BTREE,
  KEY `idx_period` (`period`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `potential_customer_products` (5 rows)
INSERT INTO `potential_customer_products` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `structure_id`, `customer_id`, `product_id`, `product_name`, `qty`) VALUES
  (1, '2025-02-19 02:58:21.025000', '2025-02-19 09:58:20.157000', '2025-02-19 03:20:17.501000', 1090568, 1240974, NULL, '202502', 'BDGA2S101', '24100071', 'PANTO', 'Pantomet 40 mg', '11'),
  (3, '2025-02-17 08:11:08', '2025-02-17 08:11:08', '2025-02-19 03:23:45.939000', 1090568, 1090568, NULL, '202502', 'BDGA2S101', '24100071', 'XEZYMT1', 'Xepazym', '10'),
  (4, '2025-02-17 08:11:08', '2025-02-17 08:11:08', '2025-02-19 03:23:51.311000', 1090568, 1090568, NULL, '202502', 'BDGA2S101', '24100071', 'XERIMSUS', 'Xepaprim Suspensi', '34'),
  (5, '2025-02-17 08:11:08', '2025-02-17 08:11:08', '2025-02-19 03:24:59.171000', 1090568, 1090568, NULL, '202502', 'BDGA2S101', '24100071', 'REVO', 'Rilevo', '40'),
  (6, '2025-02-17 08:11:08', '2025-02-17 08:11:08', '2025-02-19 03:27:21.245000', 1090568, 1090568, NULL, '202502', 'BDGA2S101', '24100071', 'QHART', 'Q-hart', '75');

-- --------------------------------------------------------------------
-- Table structure for `presence_historys`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `presence_historys`;
CREATE TABLE `presence_historys` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `office_id` varchar(100) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `in_longitude` double DEFAULT NULL,
  `in_latitude` double DEFAULT NULL,
  `in_altitude` float DEFAULT NULL,
  `in_accuracy` float DEFAULT NULL,
  `in_radius_from_office` double DEFAULT NULL,
  `in_date_time` datetime(3) DEFAULT NULL,
  `in_recognized_name` varchar(100) DEFAULT NULL,
  `in_recognized_user_id` bigint unsigned DEFAULT NULL,
  `in_recognized_confidence` float DEFAULT NULL,
  `in_face_path` varchar(200) DEFAULT NULL,
  `out_longitude` double DEFAULT NULL,
  `out_latitude` double DEFAULT NULL,
  `out_altitude` float DEFAULT NULL,
  `out_accuracy` float DEFAULT NULL,
  `out_radius_from_office` double DEFAULT NULL,
  `out_date_time` datetime(3) DEFAULT NULL,
  `out_recognized_name` varchar(100) DEFAULT NULL,
  `out_recognized_user_id` bigint unsigned DEFAULT NULL,
  `out_recognized_confidence` float DEFAULT NULL,
  `out_face_path` varchar(200) DEFAULT NULL,
  `work_hour_in` datetime(3) DEFAULT NULL,
  `work_hour_out` datetime(3) DEFAULT NULL,
  `work_hour_name` longtext,
  `dept` longtext,
  `app_name` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_presence_historys_deleted_at` (`deleted_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `presence_historys` (5 rows)
INSERT INTO `presence_historys` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `office_id`, `user_id`, `in_longitude`, `in_latitude`, `in_altitude`, `in_accuracy`, `in_radius_from_office`, `in_date_time`, `in_recognized_name`, `in_recognized_user_id`, `in_recognized_confidence`, `in_face_path`, `out_longitude`, `out_latitude`, `out_altitude`, `out_accuracy`, `out_radius_from_office`, `out_date_time`, `out_recognized_name`, `out_recognized_user_id`, `out_recognized_confidence`, `out_face_path`, `work_hour_in`, `work_hour_out`, `work_hour_name`, `dept`, `app_name`) VALUES
  (1, '2026-03-09 00:16:06.165000', '2026-03-09 01:49:22.534000', NULL, 2207004, 123, NULL, 'T1', 2207004, 106.78066986570984, -6.235615825411177, 27.005, 14.246, 23.633474906056566, '2026-03-09 00:05:00', 'Umar Maruf Mutaqin', 2207004, 0.0, '', NULL, NULL, NULL, NULL, NULL, '2026-03-09 08:45:00', 'Umar Maruf Mutaqin', NULL, NULL, NULL, NULL, NULL, NULL, 'VNEU', NULL),
  (2, '2026-03-03 01:10:47.453000', '2026-03-05 02:06:16.128000', NULL, 123, 12345, NULL, 'NON', 123, 106.7806034, -6.2356533, 52.5, 37.067, 0.0, '2026-03-03 00:00:00', 'Umar Maruf Mutaqin', 123, 0.0, '', 106.7806272, -6.2356591, 52.5, 17.249, 0.0, '2026-03-03 09:32:00', 'Umar Maruf Mutaqin', 123, 0.0, '', NULL, NULL, NULL, 'MKT', NULL),
  (3, '2026-03-09 01:05:38.805000', '2026-03-09 09:13:59.798000', NULL, 2201001, 2201001, NULL, 'T1', 2201001, 106.7807693, -6.2356834, 52.3, 9.997, 32.87880673437954, '2026-03-09 01:05:38.767000', 'Abdurrahman Arifin', 2201001, 0.0, '', 106.7806703, -6.2356092, 52.3, 14.8, 22.89600778343692, '2026-03-09 09:13:59.758000', 'Abdurrahman Arifin', 2201001, 0.0, '', NULL, NULL, NULL, 'VNEU', NULL),
  (4, '2026-02-26 00:38:25.929000', '2026-02-26 09:51:53.142000', NULL, 2201001, 2201001, NULL, 'WFATGR', 2201001, 106.6473186, -6.0791098, 25.0, 12.109, 17985.196955842024, '2026-02-26 00:38:25.894000', 'Abdurrahman Arifin', 2201001, 0.0, '', 106.647282, -6.0790918, 23.042, 13.158, 17983.117257750047, '2026-02-26 09:51:53.101000', 'Abdurrahman Arifin', 2201001, 0.0, '', NULL, NULL, NULL, 'VNEU', NULL),
  (5, '2026-02-25 00:46:10.355000', '2026-02-25 08:54:02.481000', NULL, 2201001, 2201001, NULL, 'WFATGR', 2201001, 106.7806355, -6.2354725, 0.0, 0.0, 0.0, '2026-02-24 23:55:43.890000', 'Abdurrahman Arifin', 0, 0.0, '', 106.7806209, -6.2356434, 55.7, 20.0, 19.915285925176665, '2026-02-25 08:54:02.440000', 'Abdurrahman Arifin', 2201001, 0.0, '', NULL, NULL, NULL, 'VNEU', NULL);

-- --------------------------------------------------------------------
-- Table structure for `presences`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `presences`;
CREATE TABLE `presences` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `office_id` varchar(100) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `in_longitude` double DEFAULT NULL,
  `in_latitude` double DEFAULT NULL,
  `in_altitude` float DEFAULT NULL,
  `in_accuracy` float DEFAULT NULL,
  `in_radius_from_office` double DEFAULT NULL,
  `in_date_time` datetime(3) DEFAULT NULL,
  `in_recognized_name` varchar(100) DEFAULT NULL,
  `in_recognized_user_id` bigint unsigned DEFAULT NULL,
  `in_recognized_confidence` float DEFAULT NULL,
  `in_face_path` varchar(200) DEFAULT NULL,
  `out_longitude` double DEFAULT NULL,
  `out_latitude` double DEFAULT NULL,
  `out_altitude` float DEFAULT NULL,
  `out_accuracy` float DEFAULT NULL,
  `out_radius_from_office` double DEFAULT NULL,
  `out_date_time` datetime(3) DEFAULT NULL,
  `out_recognized_name` varchar(100) DEFAULT NULL,
  `out_recognized_user_id` bigint unsigned DEFAULT NULL,
  `out_recognized_confidence` float DEFAULT NULL,
  `out_face_path` varchar(200) DEFAULT NULL,
  `work_hour_in` datetime(3) DEFAULT NULL,
  `work_hour_out` datetime(3) DEFAULT NULL,
  `work_hour_name` longtext,
  `dept` longtext,
  `app_name` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_presence` (`user_id`,`in_date_time`),
  KEY `idx_presences_deleted_at` (`deleted_at`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_office_user` (`office_id`,`user_id`),
  KEY `idx_presences_datetime_user` (`in_date_time`,`user_id`,`deleted_at`),
  KEY `idx_presences_user_date_full` (`user_id`,`in_date_time`,`out_date_time`),
  KEY `idx_presences_uid_indt_del` (`user_id`,`in_date_time`,`deleted_at`),
  KEY `idx_presences_uid_del_indatetime` (`user_id`,`deleted_at`,`in_date_time` DESC),
  CONSTRAINT `fk_presences_office` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=684956 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `presences` (5 rows)
INSERT INTO `presences` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `office_id`, `user_id`, `in_longitude`, `in_latitude`, `in_altitude`, `in_accuracy`, `in_radius_from_office`, `in_date_time`, `in_recognized_name`, `in_recognized_user_id`, `in_recognized_confidence`, `in_face_path`, `out_longitude`, `out_latitude`, `out_altitude`, `out_accuracy`, `out_radius_from_office`, `out_date_time`, `out_recognized_name`, `out_recognized_user_id`, `out_recognized_confidence`, `out_face_path`, `work_hour_in`, `work_hour_out`, `work_hour_name`, `dept`, `app_name`) VALUES
  (1, '2024-07-04 08:34:36.333000', '2024-07-04 09:56:33.244000', NULL, 1240917, 1240917, NULL, 'T1', 1240917, 106.7806203, -6.2356701, 41.598, 20.0, 22.884892226977424, '2024-07-04 08:34:36.330000', 'Abdul Fajar Ferdiansyah', 1240917, 0.0, '', 106.7805504, -6.2356761, 42.1, 4.9, 24.91191352408177, '2024-07-04 09:56:33.238000', 'Abdul Fajar Ferdiansyah', 1240917, 0.0, '', NULL, NULL, NULL, 'MKT', NULL),
  (2, '2024-07-05 07:17:11.735000', '2024-07-05 07:17:18.448000', NULL, 1240917, 1240917, NULL, 'T1', 1240917, 106.7806269, -6.2356341, 42.1, 5.218, 18.881191959851748, '2024-07-05 07:17:11.730000', 'Abdul Fajar Ferdiansyah', 1240917, 0.0, '', 106.7806401, -6.2356362, 49.2, 4.695, 19.19520326185228, '2024-07-05 07:17:18.441000', 'Abdul Fajar Ferdiansyah', 1240917, 0.0, '', NULL, NULL, NULL, 'MKT', NULL),
  (3, '2024-07-15 02:31:27.588000', '2024-07-15 03:34:28.744000', NULL, 1240917, 1240917, NULL, 'T1', 1240917, 106.7806366, -6.2356641, 48.7, 20.0, 22.25826421202759, '2024-07-15 02:31:27.584000', 'Abdul Fajar Ferdiansyah', 1240917, 0.0, '', 106.7806771, -6.2356536, 42.1, 13.669, 21.851705650446437, '2024-07-15 03:34:28.737000', 'Abdul Fajar Ferdiansyah', 1240917, 0.0, '', NULL, NULL, NULL, 'MKT', NULL),
  (4, '2024-07-17 07:18:27.260000', '2024-07-17 07:18:27.260000', NULL, 1230884, 1230884, NULL, 'JKTA1', 1230884, 106.764494, -6.1908827, 28.2, 20.0, 42.636542856172966, '2024-07-17 07:18:27.254000', 'Dandi Yanwar Fadillah', 1230884, 0.0, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Dandi Yanwar Fadillah', NULL, NULL, NULL, NULL, NULL, NULL, 'MKT', NULL),
  (5, '2024-07-18 02:05:12.558000', '2024-07-18 02:05:12.558000', NULL, 1230848, 1230848, NULL, 'TGRA1', 1230848, 106.7003743, -6.2084841, 33.4, 20.0, 0.9689914457695296, '2024-07-18 02:05:12.553000', 'Zulfa Sholihatin Nissa', 1230848, 0.0, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Zulfa Sholihatin Nissa', NULL, NULL, NULL, NULL, NULL, NULL, 'MKT', NULL);

-- --------------------------------------------------------------------
-- Table structure for `product_categories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `product_categories`;
CREATE TABLE `product_categories` (
  `created_by_id` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_by_id` varchar(20) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `deleted_by_id` varchar(20) DEFAULT NULL,
  `deleted_at` datetime(6) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(200) DEFAULT NULL,
  `key` varchar(500) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  `update_data` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `product_categories` (5 rows)
INSERT INTO `product_categories` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `group_name`, `key`, `note`, `update_data`) VALUES
  (NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Antagonis Calcium', 'Migran', 'Terapi migrain, Vertigo, dan pusing.', '2024-06-27 10:00:19'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 2, 'Anti Jamur', 'Sariawan', 'Pengobatan kandidiasis (infeksi jamur) pada rongga mulut seperti sariawan', '2024-06-27 10:00:19'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 3, 'Anti Nyeri', 'H2 Bloker', 'Terapi hiperasiditas golongan histamin', '2024-06-27 10:00:19'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Anti nyeri', 'Nyeri', 'meredakan nyeri dan gejala inflamasi', '2024-06-27 10:00:19'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 5, 'Anti Nyeri', 'Nyeri', 'Terapi nyeri level sedang s/d berat ', '2024-06-27 10:00:19');

-- --------------------------------------------------------------------
-- Table structure for `product_materials`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `product_materials`;
CREATE TABLE `product_materials` (
  `created_by_id` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_by_id` varchar(20) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `deleted_by_id` varchar(20) DEFAULT NULL,
  `deleted_at` datetime(6) DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `product_materials` (5 rows)
INSERT INTO `product_materials` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `name`) VALUES
  (NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Allopurinol 100 mg'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 2, 'Allopurinol 300 mg'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 3, 'Amoxillin 250 mg , Asam Klavulanat 62.5 mg'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Amoxycillin 500 mg'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 5, 'Bevacizumab');

-- --------------------------------------------------------------------
-- Table structure for `product_recommendation_estimations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `product_recommendation_estimations`;
CREATE TABLE `product_recommendation_estimations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `customer_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `qty_rx_per_day` double NOT NULL DEFAULT '0',
  `qty_tablet_per_rx` double NOT NULL DEFAULT '0',
  `qty_practice_per_month` double NOT NULL DEFAULT '0',
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_period_product_customer_structure` (`period`,`product_id`,`customer_id`,`structure_id`),
  KEY `idx_pre_cust_period_struct_prod` (`customer_id`,`period`,`structure_id`,`product_id`,`deleted_at`),
  KEY `idx_pre_del_id` (`deleted_at`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41563 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `product_recommendation_estimations` (5 rows)
INSERT INTO `product_recommendation_estimations` (`id`, `period`, `product_id`, `customer_id`, `structure_id`, `qty_rx_per_day`, `qty_tablet_per_rx`, `qty_practice_per_month`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`) VALUES
  (2637, '202608', 'XEZYM1T1', '23060018', 'JAPA1S101', 6.0, 8.0, 5.0, '2026-07-20 23:53:22.534000', '2026-07-28 16:31:56.622000', NULL, 1501001, 123, NULL),
  (7912, '202608', '1XELET1T', '23060041', 'JAPA1S101', 111.0, 222.0, 0.0, '2026-07-20 23:53:22.534000', '2026-07-23 06:11:27.354000', NULL, 1501001, 123, NULL),
  (7914, '202608', 'PEMIN', '24010147', 'JAPA1S101', 333.0, 222.0, 0.0, '2026-07-21 02:25:44.921000', '2026-07-23 06:11:27.752000', NULL, 1501001, 123, NULL),
  (7915, '202608', 'XANDSM', '24070152', 'JAPA1S101', 6666.0, 8888.0, 0.0, '2026-07-21 02:25:44.921000', '2026-07-23 06:11:27.865000', NULL, 1501001, 123, NULL),
  (7916, '202608', 'XEDROP', '23060037', 'JAPA1S101', 10.0, 5.0, 2.0, '2026-07-21 02:25:44.921000', '2026-07-31 05:01:39.198000', NULL, 1501001, 123, NULL);

-- --------------------------------------------------------------------
-- Table structure for `products`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `principal` varchar(150) NOT NULL,
  `product_material_id` bigint NOT NULL,
  `product_category_id` bigint NOT NULL,
  `description` longtext,
  `image` varchar(100) DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `update_data` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_products_deleted_at` (`deleted_at`),
  KEY `idx_products_name` (`name`),
  KEY `idx_products_product_category_id` (`product_category_id`),
  KEY `idx_products_company_deleted_principal` (`company_id`,`deleted_at`,`principal`),
  KEY `idx_products_principal_deleted_id` (`principal`,`deleted_at`,`id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `products` (5 rows)
INSERT INTO `products` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `name`, `principal`, `product_material_id`, `product_category_id`, `description`, `image`, `company_id`, `update_data`) VALUES
  (NULL, NULL, NULL, NULL, NULL, NULL, '1', 'Sanmol ', 'PT. Sanbe Farma', 36, 17, NULL, NULL, 1, '2024-06-27 03:04:50'),
  (NULL, NULL, NULL, NULL, NULL, NULL, '10', 'Kalnex', 'PT. Kalbe', 45, 27, NULL, NULL, 1, '2024-06-27 03:04:50'),
  (NULL, NULL, NULL, NULL, NULL, NULL, '100', 'Baquinor ', 'PT. Sanbe', 14, 10, NULL, NULL, 1, '2024-06-27 03:04:50'),
  (NULL, NULL, NULL, NULL, NULL, NULL, '101', 'Lapiflox', 'PT. Lap', 14, 10, NULL, NULL, 1, '2024-06-27 03:04:50'),
  (NULL, NULL, NULL, NULL, NULL, NULL, '102', 'Miraflox', 'PT. Sampharindo', 14, 10, NULL, NULL, 1, '2024-06-27 03:04:50');

-- --------------------------------------------------------------------
-- Table structure for `public_holidays`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `public_holidays`;
CREATE TABLE `public_holidays` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` varchar(50) DEFAULT NULL,
  `updated_by_id` varchar(50) DEFAULT NULL,
  `deleted_by_id` varchar(50) DEFAULT NULL,
  `period` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `day` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_yearly` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_public_holidays` (`period`,`name`) USING BTREE,
  KEY `idx_public_holidays_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `public_holidays` (1 rows)
INSERT INTO `public_holidays` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `name`, `day`, `is_yearly`) VALUES
  (3, '2025-11-17 04:39:41', '2025-11-17 06:42:56', NULL, '', '', NULL, '20250320', 'Hari Raya Buruh Sedunia', '0.5', 1);

-- --------------------------------------------------------------------
-- Table structure for `report_visit_completes`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `report_visit_completes`;
CREATE TABLE `report_visit_completes` (
  `period` varchar(6) NOT NULL,
  `structure_id` varchar(30) NOT NULL,
  `boss_code` varchar(30) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `position` varchar(50) DEFAULT NULL,
  `population` bigint unsigned DEFAULT NULL,
  `mcl_count` bigint unsigned DEFAULT NULL,
  `call_plan` bigint unsigned DEFAULT NULL,
  `visit_customer_count` bigint unsigned DEFAULT NULL,
  `visit_plan_count` bigint unsigned DEFAULT NULL,
  `visit_unplan_count` bigint unsigned DEFAULT NULL,
  `visit_location_count` bigint unsigned DEFAULT NULL,
  `survey_count` bigint unsigned DEFAULT NULL,
  `visit_non_location_count` bigint unsigned DEFAULT NULL,
  `survey_complete` float DEFAULT NULL,
  `survey_incomplete` float DEFAULT NULL,
  `visit_count` bigint unsigned DEFAULT NULL,
  `target_count` bigint unsigned DEFAULT NULL,
  `target` float DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`period`,`structure_id`),
  UNIQUE KEY `idx_report_visit_complete` (`period`,`structure_id`,`position`),
  KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_period` (`period`) USING BTREE,
  KEY `idx_structure` (`structure_id`) USING BTREE,
  KEY `idx_boss_code` (`boss_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `report_visit_completes` (5 rows)
INSERT INTO `report_visit_completes` (`period`, `structure_id`, `boss_code`, `name`, `position`, `population`, `mcl_count`, `call_plan`, `visit_customer_count`, `visit_plan_count`, `visit_unplan_count`, `visit_location_count`, `survey_count`, `visit_non_location_count`, `survey_complete`, `survey_incomplete`, `visit_count`, `target_count`, `target`, `company_id`) VALUES
  ('202406', 'JKTA1S302', 'JKTA3S2', 'Abdul Fajar Ferdiansyah', 'MR', 9, 0, 33, 4, 1, 3, 4, 3, 0, 75.0, -25.0, 4, 10, 40.0, 1),
  ('202407', 'ADMIN01', 'MD', 'ADMINISTRATOR', 'MR', 10919, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0, 0, 0.0, 1),
  ('202407', 'AMP', 'AMP2', 'VACANT-AMP', 'MR', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0, 10, 0.0, 1),
  ('202407', 'AMP2', 'AMP3', 'VACANT-AMP2', 'SPV', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0, 6, 0.0, 1),
  ('202407', 'AMP3', 'AMP4', 'VACANT-AMP3', 'ASM', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0, 4, 0.0, 1);

-- --------------------------------------------------------------------
-- Table structure for `role_menu_permissions`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `role_menu_permissions`;
CREATE TABLE `role_menu_permissions` (
  `deleted_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `role_id` bigint unsigned NOT NULL,
  `permission_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_role_menu_permissions_deleted_at` (`deleted_at`),
  KEY `idx_role` (`role_id`),
  KEY `idx_permission` (`permission_id`),
  CONSTRAINT `fk_roles_role_menu_permission` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `role_menu_permissions` (5 rows)
INSERT INTO `role_menu_permissions` (`deleted_at`, `deleted_by_id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `role_id`, `permission_id`) VALUES
  (NULL, NULL, '2026-08-11 07:58:33.045000', '2026-08-11 07:58:33.045000', 12345, 12345, 1, 'customer_location_view_menu'),
  (NULL, NULL, '2026-08-11 07:58:25.462000', '2026-08-11 07:58:25.462000', 12345, 12345, 1, 'customer_plan_edit_out_of_city'),
  (NULL, NULL, '2026-08-11 07:58:22.218000', '2026-08-11 07:58:22.218000', 12345, 12345, 1, 'customer_plan_export_excel'),
  (NULL, NULL, '2026-08-11 07:58:18.920000', '2026-08-11 07:58:18.920000', 12345, 12345, 1, 'customer_plan_view_menu'),
  (NULL, NULL, '2026-08-11 07:58:31.683000', '2026-08-11 07:58:31.683000', 12345, 12345, 1, 'customer_view_menu');

-- --------------------------------------------------------------------
-- Table structure for `roles`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_roles_deleted_at` (`deleted_at`),
  KEY `idx_description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `roles` (5 rows)
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `deleted_at`, `deleted_by_id`, `created_by_id`, `updated_by_id`, `name`, `description`) VALUES
  (1, '2025-08-15 02:21:58.718000', '2025-08-15 02:23:59.316000', NULL, NULL, 2201001, 2201001, 'Marketing Area', 'Permission Marketing Area'),
  (2, '2025-08-15 02:25:42.213000', '2025-08-15 02:25:56.589000', '2025-08-15 02:25:56.712000', 2, 2201001, 2201001, 'TESSTING', 'Permission marketing area'),
  (3, '2025-08-15 03:52:15.327000', '2025-08-15 03:54:30.367000', '2025-08-15 03:54:30.516000', 3, 2201001, 2201001, 'App Developer', 'Application Developer'),
  (4, '2025-08-15 03:55:10.813000', '2025-08-15 03:55:10.813000', NULL, NULL, 2201001, 2201001, 'IT Developer', 'Application Developer'),
  (5, '2025-08-26 08:19:21.907000', '2025-08-26 08:20:05.161000', NULL, NULL, 1090568, 1090568, 'Marketing control', 'Permission Marketing Control');

-- --------------------------------------------------------------------
-- Table structure for `rules`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `rules`;
CREATE TABLE `rules` (
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `event` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `rules` (5 rows)
INSERT INTO `rules` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `id`, `name`, `description`, `event`) VALUES
  (NULL, NULL, NULL, NULL, NULL, NULL, 'check_in_visit_radius', 'Test', 'Test', 'on_approve_check_in_visit_radius'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'count_call_dk_asm', 'ASM DALAM KOTA', 'CALL ASM DALAM KOTA', 'on_approve_call'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'count_call_dk_mr', 'MR DALAM KOTA', 'CALL MR DALAM KOTA', 'on_approve_call'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'count_call_dk_spv', 'SPV DALAM KOTA', 'CALL SPV DALAM KOTA', 'on_approve_call'),
  (NULL, NULL, NULL, NULL, NULL, NULL, 'count_call_dk_spv_mandiri', 'SPV MANDIRI DALAM KOTA', 'CALL SPV MANDIRI DALAM KOTA', 'on_approve_call');

-- --------------------------------------------------------------------
-- Table structure for `sessions`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `refresh_uuid` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `user_agent` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `remote_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expired` datetime(3) NOT NULL,
  `check_point_visit_realization` tinyint(1) NOT NULL DEFAULT '0',
  `check_point_visit_schedule` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `refresh_uuid` (`refresh_uuid`),
  KEY `idx_sessions_deleted_at` (`deleted_at`),
  KEY `idx_sessions_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=608770 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `sessions` (5 rows)
INSERT INTO `sessions` (`id`, `created_at`, `updated_at`, `deleted_at`, `refresh_uuid`, `user_id`, `user_agent`, `remote_address`, `expired`, `check_point_visit_realization`, `check_point_visit_schedule`) VALUES
  (598134, '2026-08-03 05:57:01.145000', '2026-08-03 05:57:01.145000', NULL, '47717362-a38c-496c-9c63-93cbf3a928e5', 1251067, 'Dart/3.11 (dart:io)', '172.26.0.1:56394', '2026-08-14 05:57:01', 0, 0),
  (598448, '2026-08-03 12:43:09.997000', '2026-08-03 12:43:09.997000', NULL, '0df5d080-0730-4355-abf1-ae868a29250c', 1251058, 'Dart/3.11 (dart:io)', '172.26.0.1:60354', '2026-08-14 12:43:09', 0, 0),
  (598502, '2026-08-04 01:47:08.471000', '2026-08-04 01:47:08.471000', NULL, '4c050365-46bf-4208-9674-a3e33c21d059', 2261062, 'Dart/3.11 (dart:io)', '172.26.0.1:51550', '2026-08-15 01:47:08', 0, 0),
  (598543, '2026-08-04 02:56:40.514000', '2026-08-04 02:56:40.514000', NULL, 'c3d5b617-ae01-4cd4-a5cb-1a6dcc0f1d4f', 2130599, 'Dart/3.11 (dart:io)', '172.26.0.1:50828', '2026-08-15 02:56:40', 0, 0),
  (598677, '2026-08-04 08:49:05.823000', '2026-08-04 08:49:05.823000', NULL, 'bd8943ff-1640-4eaf-bd17-a5ce6c493972', 99210030, 'Dart/3.12 (dart:io)', '172.26.0.1:57174', '2026-08-15 08:49:05', 0, 0);

-- --------------------------------------------------------------------
-- Table structure for `status_closings`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `status_closings`;
CREATE TABLE `status_closings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `period` varchar(8) DEFAULT NULL,
  `name` varchar(500) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by_id` int DEFAULT NULL,
  `closed_by_id` int DEFAULT NULL,
  `updated_by_id` int DEFAULT NULL,
  `deleted_by_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_period_name` (`period`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=473 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `status_closings` (5 rows)
INSERT INTO `status_closings` (`id`, `period`, `name`, `closed`, `closed_at`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `closed_by_id`, `updated_by_id`, `deleted_by_id`) VALUES
  (1, '202401', 'sales_ff', 1, '2024-01-01 00:00:00', '2024-01-01 00:00:00', '2024-01-01 00:00:00', NULL, 2207004, 2207004, 2207004, NULL),
  (2, '202402', 'sales_ff', 1, '2024-02-01 00:00:00', '2024-02-01 00:00:00', '2024-02-01 00:00:00', NULL, 2207004, 2207004, 2207004, NULL),
  (3, '202403', 'sales_ff', 1, '2024-03-01 00:00:00', '2024-03-01 00:00:00', '2024-03-01 00:00:00', NULL, 2207004, 2207004, 2207004, NULL),
  (4, '202404', 'sales_ff', 1, '2024-04-01 00:00:00', '2024-04-01 00:00:00', '2024-04-01 00:00:00', NULL, 2207004, 2207004, 2207004, NULL),
  (5, '202405', 'sales_ff', 1, '2024-05-01 00:00:00', '2024-05-01 00:00:00', '2024-05-01 00:00:00', NULL, 2207004, 2207004, 2207004, NULL);

-- --------------------------------------------------------------------
-- Table structure for `structure_bos`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structure_bos`;
CREATE TABLE `structure_bos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `structure_id` varchar(30) NOT NULL,
  `user_id` bigint NOT NULL,
  `level` bigint DEFAULT NULL,
  `structure_bos` longtext,
  `user_id_bos` bigint unsigned DEFAULT NULL,
  `level_bos` bigint DEFAULT NULL,
  PRIMARY KEY (`id`,`structure_id`,`user_id`),
  UNIQUE KEY `idx_structures` (`structure_id`,`user_id`),
  UNIQUE KEY `idx_structure_id` (`structure_id`),
  KEY `idx_structure_bos_deleted_at` (`deleted_at`),
  KEY `idx_structure_bos_level` (`level`),
  KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=223905 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structure_bos` (5 rows)
INSERT INTO `structure_bos` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `structure_id`, `user_id`, `level`, `structure_bos`, `user_id_bos`, `level_bos`) VALUES
  (223608, '2026-09-23 19:20:02.735000', '2026-09-23 19:20:02.735000', NULL, 0, 0, NULL, 'BDGA1S102', 0, 1, 'BDGA1S3', 1220724, 2),
  (223609, '2026-09-23 19:20:02.735000', '2026-09-23 19:20:02.735000', NULL, 0, 0, NULL, 'BDGA1S201', 1261184, 1, 'BDGA1S3', 1220724, 2),
  (223610, '2026-09-23 19:20:02.735000', '2026-09-23 19:20:02.735000', NULL, 0, 0, NULL, 'BDGA2S101', 1261183, 1, 'BDGA1S1', 1251093, 2),
  (223611, '2026-09-23 19:20:02.735000', '2026-09-23 19:20:02.735000', NULL, 0, 0, NULL, 'BDGA2S201', 1251049, 1, 'BDGA1S3', 1220724, 2),
  (223612, '2026-09-23 19:20:02.735000', '2026-09-23 19:20:02.735000', NULL, 0, 0, NULL, 'BDGA2S202', 1220759, 1, 'BDGA1S1', 1251093, 2);

-- --------------------------------------------------------------------
-- Table structure for `structure_cities`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structure_cities`;
CREATE TABLE `structure_cities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `structure_id` varchar(30) NOT NULL,
  `province` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `company_id` bigint NOT NULL,
  PRIMARY KEY (`id`,`structure_id`,`province`,`city`,`company_id`),
  UNIQUE KEY `idx_structure_cities` (`structure_id`,`province`,`city`,`company_id`),
  KEY `idx_structure_cities_structure_id` (`structure_id`) USING BTREE,
  KEY `idx_structure_cities_province` (`province`) USING BTREE,
  KEY `idx_structure_cities_company_id` (`company_id`) USING BTREE,
  KEY `idx_structure_cities_city` (`city`) USING BTREE,
  KEY `idx_structure_cities_company_status_structure` (`company_id`,`status`,`structure_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structure_cities` (5 rows)
INSERT INTO `structure_cities` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `structure_id`, `province`, `city`, `status`, `company_id`) VALUES
  (36246, 2207004, '2025-04-10 08:20:56', 2207004, '2025-04-10 08:20:56', NULL, NULL, 'BDGA2S102', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'approved', 1),
  (36253, 2207004, '2025-04-10 09:02:09', 2207004, '2025-04-10 09:02:09', NULL, NULL, 'PBLA1S101', 'Jawa Timur', 'Kota Probolinggo', 'approved', 1),
  (36255, 2207004, '2025-04-10 08:20:56', 2207004, '2025-04-10 08:20:56', NULL, NULL, 'BDGA2S102', 'Banten', 'Kabupaten Tangerang', 'approved', 1),
  (36256, 2207004, '2025-04-10 09:02:09', 2207004, '2025-04-10 09:02:09', NULL, NULL, 'JOGA2S301', 'Daerah Istimewa Yogyakarta', 'Kota Yogyakarta', 'approved', 1),
  (36257, 2207004, '2025-04-10 08:20:56', 2207004, '2025-04-10 08:20:56', NULL, NULL, 'BKSA1S101', 'D K I Jakarta', 'Kota Administrasi Jakarta Selatan', 'approved', 1);

-- --------------------------------------------------------------------
-- Table structure for `structure_code`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structure_code`;
CREATE TABLE `structure_code` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `marketing_structure_id` varchar(30) NOT NULL,
  `outlet_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`,`marketing_structure_id`,`outlet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46582 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structure_code` (5 rows)
INSERT INTO `structure_code` (`id`, `created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `marketing_structure_id`, `outlet_id`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, 'BDGA1S401', 'SBG210004'),
  (2, NULL, NULL, NULL, NULL, NULL, NULL, 'SMGA2S101', 'ABW160001'),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, 'SMGA2S101', 'ABW160006'),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, 'SMGA2S101', 'ABW160008'),
  (5, NULL, NULL, NULL, NULL, NULL, NULL, 'TGRA2S102', 'ABW160009');

-- --------------------------------------------------------------------
-- Table structure for `structure_historys`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structure_historys`;
CREATE TABLE `structure_historys` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `area_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `boss_code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `level` bigint DEFAULT NULL,
  `is_mkt` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structure_historys` (5 rows)
INSERT INTO `structure_historys` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `user_id`, `area_id`, `company_id`, `boss_code`, `level`, `is_mkt`) VALUES
  ('AMP', '2026-02-25 06:01:42.338000', '2026-02-25 06:01:42.338000', NULL, 0, 0, NULL, '202603', 0, '', 1, 'AMP2', 1, 0),
  ('MDNA3S104', '2026-07-07 10:25:17', '2026-07-13 02:58:49.775000', NULL, 15010001, 1160784, NULL, '202608', 1261164, '', 1, 'MDNA3S1', 1, 0),
  ('AMP', '2026-07-14 04:40:14.171000', '2026-07-14 04:40:14.171000', NULL, 0, 0, NULL, '202608', 0, '', 1, 'AMP2', 1, 0),
  ('AMP', '2026-07-14 04:47:17.141000', '2026-07-14 04:47:17.141000', NULL, 0, 0, NULL, '202608', 0, '', 1, 'AMP2', 1, 0),
  ('AMP', '2026-07-14 04:49:46.415000', '2026-07-14 04:49:46.415000', NULL, 0, 0, NULL, '202608', 0, '', 1, 'AMP2', 1, 0);

-- --------------------------------------------------------------------
-- Table structure for `structure_locations`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structure_locations`;
CREATE TABLE `structure_locations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `location_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `company_id` bigint unsigned NOT NULL,
  `out_of_city` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`,`period`,`structure_id`,`company_id`),
  UNIQUE KEY `idx_structure_locations` (`period`,`location_id`,`structure_id`,`company_id`),
  KEY `idx_structure_locations_deleted_at` (`deleted_at`),
  KEY `idx_sl_structure_period_company_location` (`structure_id`,`period`,`company_id`,`location_id`),
  KEY `idx_sl_main` (`company_id`,`period`,`structure_id`,`location_id`),
  KEY `idx_sl_period_struct_loc` (`period`,`structure_id`,`location_id`),
  KEY `idx_sl_loc_period_struct_del` (`location_id`,`period`,`structure_id`,`deleted_at`,`out_of_city`),
  KEY `idx_sl_structure_company_location` (`structure_id`,`company_id`,`location_id`),
  CONSTRAINT `fk_companies_structure_location` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20711338 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structure_locations` (5 rows)
INSERT INTO `structure_locations` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `location_id`, `structure_id`, `company_id`, `out_of_city`) VALUES
  (6097485, '2023-10-07 05:08:04.053000', '2023-10-07 05:08:04.053000', NULL, NULL, NULL, NULL, '202308', 'SBA200636', 'SBASPO04', 2, NULL),
  (6097486, '2023-10-07 05:08:04.053000', '2023-10-07 05:08:04.053000', NULL, NULL, NULL, NULL, '202304', 'BGR200435', 'BGRSPO02', 2, NULL),
  (6097487, '2023-10-07 05:08:04.053000', '2023-10-07 05:08:04.053000', NULL, NULL, NULL, NULL, '202302', 'PKB200261', 'PKBSPO02', 2, NULL),
  (6097488, '2023-10-07 05:08:04.053000', '2023-10-07 05:08:04.053000', NULL, NULL, NULL, NULL, '202304', 'BJM220060', 'BJMSPO03', 2, NULL),
  (6097489, '2023-10-07 05:08:04.053000', '2023-10-07 05:08:04.053000', NULL, NULL, NULL, NULL, '202306', 'BGR210038', 'BGRSPO03', 2, NULL);

-- --------------------------------------------------------------------
-- Table structure for `structure_positions`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structure_positions`;
CREATE TABLE `structure_positions` (
  `created_by_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `level` bigint NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `check_point_visit_schedule` tinyint(1) DEFAULT NULL,
  `check_point_visit_realization` tinyint(1) DEFAULT NULL,
  `company_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`level`,`name`,`company_id`),
  KEY `fk_companies_structure_position` (`company_id`),
  KEY `idx_structure_positions_name` (`name`) USING BTREE,
  KEY `idx_structure_positions_level` (`level`) USING BTREE,
  KEY `idx_sp_company_level_deleted` (`company_id`,`level`,`deleted_at`),
  CONSTRAINT `fk_companies_structure_position` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structure_positions` (5 rows)
INSERT INTO `structure_positions` (`created_by_id`, `created_at`, `updated_by_id`, `updated_at`, `deleted_by_id`, `deleted_at`, `level`, `name`, `check_point_visit_schedule`, `check_point_visit_realization`, `company_id`) VALUES
  (1, '2023-07-05 02:11:28.619000', NULL, NULL, NULL, NULL, 1, 'MR', 1, 1, 1),
  (1, '2023-07-05 02:11:28.619000', NULL, NULL, NULL, NULL, 1, 'SPO', 1, 1, 2),
  (1, '2023-07-05 02:11:28.619000', NULL, NULL, NULL, NULL, 2, 'SPS', 1, 1, 2),
  (1, '2023-07-05 02:11:28.619000', NULL, NULL, NULL, NULL, 2, 'SPV', 1, 1, 1),
  (1, '2023-07-05 02:11:28.619000', NULL, NULL, NULL, NULL, 3, 'ASM', 1, 1, 1);

-- --------------------------------------------------------------------
-- Table structure for `structures`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `structures`;
CREATE TABLE `structures` (
  `id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `area_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `boss_code` varchar(30) DEFAULT NULL,
  `level` bigint DEFAULT NULL,
  `is_mkt` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`,`period`),
  KEY `fk_areas_structure` (`area_id`),
  KEY `fk_companies_structure` (`company_id`),
  KEY `idx_structures_user_id` (`user_id`) USING BTREE,
  KEY `idx_structures_level` (`level`) USING BTREE,
  KEY `idx_structures_deleted_at` (`deleted_at`) USING BTREE,
  KEY `idx_structures_id` (`id`) USING BTREE,
  KEY `idx_period_is_mkt` (`period`) USING BTREE,
  KEY `idx_structures_period_boss_deleted` (`period`,`boss_code`,`deleted_at`),
  KEY `idx_structures_period_boss` (`period`,`boss_code`),
  KEY `idx_structures_boss_code` (`boss_code`),
  KEY `idx_structures_report` (`period`,`deleted_at`),
  KEY `idx_period_user` (`period`,`user_id`),
  CONSTRAINT `fk_companies_structure` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `structures` (5 rows)
INSERT INTO `structures` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `user_id`, `area_id`, `company_id`, `boss_code`, `level`, `is_mkt`) VALUES
  ('1130253', '2025-11-13 10:15:53', '2025-11-13 10:15:53', NULL, 15010001, 15010001, NULL, '202512', 1130253, '', 1, '3231004', 3, 1),
  ('3110427', '2025-11-13 10:15:53', '2025-11-13 10:15:53', NULL, 15010001, 15010001, NULL, '202512', 3110427, '', 1, '2201001', 1, 1),
  ('3230995', '2025-11-13 10:15:53', '2025-11-13 10:15:53', NULL, 15010001, 15010001, NULL, '202512', 3230995, '', 1, '1130253', 4, 1),
  ('3231004', '2025-11-13 10:15:53', '2025-11-13 10:15:53', NULL, 15010001, 15010001, NULL, '202512', 3231004, '', 1, '3110427', 2, 1),
  ('3251037', '2025-11-13 10:15:53', '2025-11-13 10:15:53', NULL, 15010001, 15010001, NULL, '202512', 3251037, '', 1, '1130253', 4, 1);

-- --------------------------------------------------------------------
-- Table structure for `user_late_deductions`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `user_late_deductions`;
CREATE TABLE `user_late_deductions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` double DEFAULT NULL,
  `x_30` double DEFAULT NULL,
  `x_15` double DEFAULT NULL,
  `late_15` double DEFAULT NULL,
  `late_30` double DEFAULT NULL,
  `company_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_companies_name` (`period`,`company_id`),
  KEY `idx_companies_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=60009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `user_late_deductions` (5 rows)
INSERT INTO `user_late_deductions` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `x_30`, `x_15`, `late_15`, `late_30`, `company_id`) VALUES
  (1, NULL, NULL, NULL, NULL, NULL, NULL, 202510.0, 1.0, 4.0, 50000.0, 30000.0, '1'),
  (2, NULL, NULL, NULL, NULL, NULL, NULL, 202511.0, 1.0, 4.0, 50000.0, 30000.0, '1'),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, 202512.0, 1.0, 4.0, 50000.0, 30000.0, '1'),
  (4, NULL, NULL, NULL, NULL, NULL, NULL, 202601.0, 1.0, 4.0, 50000.0, 30000.0, '1'),
  (60005, NULL, NULL, NULL, NULL, NULL, NULL, 202602.0, 1.0, 4.0, 50000.0, 30000.0, '1');

-- --------------------------------------------------------------------
-- Table structure for `user_roles`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `deleted_by_id` bigint DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `role_id` bigint unsigned NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`,`user_id`),
  KEY `idx_role` (`role_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_roles_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `user_roles` (5 rows)
INSERT INTO `user_roles` (`deleted_by_id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `role_id`, `user_id`) VALUES
  (NULL, '2025-08-26 08:34:01.978000', '2025-08-26 08:34:01.978000', 1090568, 1090568, 1, 1020068),
  (NULL, '2025-08-26 08:33:32.962000', '2025-08-26 08:33:32.962000', 1090568, 1090568, 1, 1050131),
  (NULL, '2025-08-26 08:33:27.048000', '2025-08-26 08:33:27.048000', 1090568, 1090568, 1, 1161854),
  (NULL, '2025-08-26 08:33:32.962000', '2025-08-26 08:33:32.962000', 1090568, 1090568, 1, 1182090),
  (NULL, '2025-08-28 09:00:51.037000', '2025-08-28 09:00:51.037000', 1090568, 1090568, 1, 1182118);

-- --------------------------------------------------------------------
-- Table structure for `users`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `gender` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dept` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `company_id` bigint unsigned NOT NULL,
  `image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `device_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `access_token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `refresh_token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `token_firebase` varchar(191) DEFAULT NULL,
  `nip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '-',
  `role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '-',
  `join_date` varchar(191) DEFAULT NULL,
  `resign_date` varchar(191) DEFAULT NULL,
  `phone` longtext,
  `telegram_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`,`company_id`),
  UNIQUE KEY `idx_users_id` (`id`),
  KEY `idx_users_deleted_at` (`deleted_at`),
  KEY `users_resign_date_index` (`resign_date`),
  KEY `users_email_index` (`email`),
  KEY `idx_users_id_dept` (`id`,`dept`),
  KEY `idx_users_company_dept` (`company_id`,`dept`),
  KEY `idx_users_dept_del_id` (`dept`,`deleted_at`,`id`),
  KEY `idx_users` (`user_name`,`email`,`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=99210144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `users` (5 rows)
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `user_name`, `password`, `email`, `name`, `gender`, `dept`, `religion`, `company_id`, `image`, `device_id`, `access_token`, `refresh_token`, `token_firebase`, `nip`, `role`, `join_date`, `resign_date`, `phone`, `telegram_id`) VALUES
  (1, NULL, '2026-02-16 06:47:21.637000', NULL, NULL, 1, NULL, 'AMP', '$2a$12$C56yajTj2W4OWlqP/vCnUeflVZK3IPxQeNFBiCD64lXktmLoMX0eq', NULL, 'Amp', '', 'DIREKSI', NULL, 1, NULL, '-', '-', '-', '', '1', '-', NULL, NULL, '-', 0),
  (2, NULL, NULL, NULL, NULL, NULL, NULL, 'AMP2', '$2a$12$C56yajTj2W4OWlqP/vCnUeflVZK3IPxQeNFBiCD64lXktmLoMX0eq', NULL, 'AMP2', '', 'DIREKSI', NULL, 1, NULL, NULL, NULL, NULL, NULL, '2', '-', NULL, NULL, '-', 6747019440),
  (3, NULL, NULL, NULL, NULL, NULL, NULL, 'AMP3', '$2a$12$C56yajTj2W4OWlqP/vCnUeflVZK3IPxQeNFBiCD64lXktmLoMX0eq', NULL, 'AMP3', '', 'MKT', NULL, 1, NULL, NULL, NULL, NULL, NULL, '3', '-', NULL, NULL, '-', 0),
  (4, NULL, '2025-09-16 09:29:53.087000', NULL, NULL, NULL, NULL, 'AMP4', '$2a$12$C56yajTj2W4OWlqP/vCnUeflVZK3IPxQeNFBiCD64lXktmLoMX0eq', NULL, 'AMP4', '', 'MKT', NULL, 1, NULL, '8ea486546878ef86723998c0d1f9df978ab514051ade92477903ce6d2734342e', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NfdXVpZCI6ImZkN2RiYTg5LWU3YzgtNDJiYy1iZmNlLTI1NmU4NmRmOTk2ZCIsImF1dGhvcml6ZWQiOnRydWUsImNoZWNrX3BvaW50X3Zpc2l0X3JlYWxpemF0aW9uIjp0cnVlLCJjaGVja19wb2ludF92aXNpdF9zY2hlZHVsZSI6dHJ1ZSwiY29tcGFueV9pZCI6MSwiY29tcGFueV9uYW1lIjoiUFQuIE1ldGlza2EgRmFybWEiLCJlbWFpbCI6IiIsImV4cCI6MTc1ODg3ODk5MywiaWQiOjQsImxldmVsIjo0LCJtYW5kYXRvcnlfc3VydmV5IjpmYWxzZSwibmFtZSI6IkFtcDQiLCJzdHJ1Y3R1cmVfaWQiOiJBTVA0Iiwic3RydWN0dXJlX3N1Ym9yZGluYXRlcyI6IkFNUDMsQU1QMixBTVAiLCJzdHJ1Y3R1cmVfc3Vib3JkaW5hdGVzX21yIjoiQU1QIiwidXJsIjoiaHR0cHM6Ly9za2ktY29tcGxpYW5jZS1tZXRpc2thLWZhcm1hLWFwaS5mbGV4dXJpby5jb20iLCJ1c2VyX25hbWUiOiJBbXA0In0.wtKrxApTGTwgJSabNb6n2L_qEqEqcUpL3cY7ZSEPlLY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTg5NjUzOTMsImlkIjo0LCJyZWZyZXNoX3V1aWQiOiI3NzZhZmIyMi1kOTZjLTRiMTItYTI4My05ZWYzOTdjMWE5NTQiLCJzdHJ1Y3R1cmVfaWQiOiJBTVA0In0.oCR40UJfR15jnOryF2ViwwT_PPdcRL2iL85imRSncIw', NULL, '4', '-', NULL, NULL, '-', 0),
  (5, NULL, NULL, NULL, NULL, NULL, NULL, 'AMP5', '$2a$12$C56yajTj2W4OWlqP/vCnUeflVZK3IPxQeNFBiCD64lXktmLoMX0eq', NULL, 'AMP5', '', 'MKT', NULL, 1, NULL, NULL, NULL, NULL, NULL, '5', '-', NULL, NULL, '-', 0);

-- --------------------------------------------------------------------
-- Table structure for `visit_api_logs`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visit_api_logs`;
CREATE TABLE `visit_api_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `status_visit` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `request_method` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `response_status_code` bigint DEFAULT NULL,
  `visit_id` bigint unsigned DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_visit_status` (`status_visit`),
  UNIQUE KEY `idx_visit_api_log` (`visit_id`),
  KEY `idx_visit_api_logs_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_visits_visit_api_log` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------------------
-- Table structure for `visit_apis`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visit_apis`;
CREATE TABLE `visit_apis` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `status_visit` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `request_method` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `order` bigint DEFAULT NULL,
  `company` bigint DEFAULT NULL,
  `company_id` bigint DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_visit_status` (`status_visit`),
  UNIQUE KEY `idx_visit_api` (`order`,`company`),
  KEY `idx_visit_apis_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=60001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `visit_apis` (1 rows)
INSERT INTO `visit_apis` (`id`, `created_at`, `updated_at`, `deleted_at`, `status_visit`, `request_type`, `request_url`, `request_method`, `order`, `company`, `company_id`, `created_by_id`, `updated_by_id`, `deleted_by_id`) VALUES
  (1, '2023-07-05 02:14:05.418000', '2023-07-05 02:14:05.418000', NULL, '', 'hit_api', 'https://api.visitflow.app/visit-apis', 'PUT', 1, NULL, 1, 1, 1, NULL);

-- --------------------------------------------------------------------
-- Table structure for `visit_customer_histories`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visit_customer_histories`;
CREATE TABLE `visit_customer_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `visit_customer_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) DEFAULT NULL,
  `structure_id` varchar(20) DEFAULT NULL,
  `customer_id` varchar(100) DEFAULT NULL,
  `company_id` bigint DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `customer_phone` varchar(100) DEFAULT NULL,
  `priority` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `level` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `approved_structure_id` varchar(30) DEFAULT NULL,
  `approved_time` datetime(3) DEFAULT NULL,
  `rejected_structure_id` varchar(30) DEFAULT NULL,
  `rejected_time` datetime(3) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_visit_customer_histories_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=56019 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `visit_customer_histories` (5 rows)
INSERT INTO `visit_customer_histories` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `visit_customer_id`, `period`, `structure_id`, `customer_id`, `company_id`, `customer_name`, `customer_phone`, `priority`, `type`, `status`, `level`, `user_id`, `user_name`, `approved_structure_id`, `approved_time`, `rejected_structure_id`, `rejected_time`, `note`) VALUES
  (1, '2024-08-01 09:19:05.977000', '2024-08-01 09:19:05.977000', NULL, 0, 0, NULL, 124, '202408', 'JKTA3S2', '24070174', 1, 'WULAN PUJIHASTUTI (APT) KL PRATAMA PUTRA BAHAGIA SEJAHTERA', '+62085715490335', '', '', 'draft', 2, 1220687, 'Tomas Ari Wibowo', '', NULL, '', NULL, NULL),
  (8, '2024-08-02 02:00:23.267000', '2024-08-02 02:00:23.267000', NULL, 0, 0, NULL, 23, '202407', 'JKTA1S302', '24070061', 1, 'CLG-GAMA 1 CILEGON, APT (DPF)', '+62', '', '7', 'rejected', 1, 1240917, '', '', NULL, 'JKTA3S2', '2024-08-02 02:00:18.818000', 'Data tidak sesuai, tolong perbaiki testing 1'),
  (9, '2024-08-02 02:21:32.467000', '2024-08-02 02:21:32.467000', NULL, 0, 0, NULL, 124, '202408', 'JKTA3S2', '24070174', 1, 'WULAN PUJIHASTUTI (APT) KL PRATAMA PUTRA BAHAGIA SEJAHTERA', '+62085715490335', '', '', 'draft', 2, 1220687, 'Tomas Ari Wibowo', '', NULL, '', NULL, NULL),
  (10, '2024-08-02 02:45:04.249000', '2024-08-02 02:45:04.249000', NULL, 0, 0, NULL, 23, '202407', 'JKTA1S302', '24070061', 1, 'CLG-GAMA 1 CILEGON, APT (DPF)', '+62', '', '7', 'deleted', 1, 1240917, '', '', NULL, 'JKTA3S2', '2024-08-02 02:00:18.818000', 'Data tidak sesuai, tolong perbaiki testing 1'),
  (11, '2024-08-02 04:32:19.345000', '2024-08-02 04:32:19.345000', NULL, 0, 0, NULL, 125, '202408', 'JKTA1S302', 'DKI22-0126', 1, 'ALEXANDRA  MARIA DARMASEPUTRA', '0858180856', '', '6', 'draft', 1, 1240917, 'Abdul Fajar Ferdiansyah', '', NULL, '', NULL, NULL);

-- --------------------------------------------------------------------
-- Table structure for `visit_customers`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visit_customers`;
CREATE TABLE `visit_customers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `customer_phone` varchar(100) DEFAULT NULL,
  `priority` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `level` bigint unsigned DEFAULT NULL,
  `approved_structure_id` varchar(30) DEFAULT NULL,
  `approved_time` datetime(3) DEFAULT NULL,
  `structure_id` varchar(30) NOT NULL,
  `out_of_city` tinyint(1) DEFAULT '0',
  `user_id` bigint unsigned DEFAULT NULL,
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_id` varchar(20) DEFAULT NULL,
  `location_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  `rejected_structure_id` varchar(30) DEFAULT NULL,
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `rejected_time` datetime(3) DEFAULT NULL,
  `cluster` varchar(50) DEFAULT NULL,
  `amortization` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`,`period`,`company_id`),
  UNIQUE KEY `idx_visit_customer` (`period`,`structure_id`,`customer_id`,`company_id`,`location_id`) USING BTREE,
  UNIQUE KEY `uk_period_structure_customer_location` (`period`,`structure_id`,`customer_id`,`location_id`),
  KEY `idx_visit_customers_company_id` (`company_id`) USING BTREE,
  KEY `idx_visit_customer_filter` (`structure_id`,`company_id`,`period`,`deleted_at`,`customer_id`,`location_id`) USING BTREE,
  KEY `idx_vc_structure_period_company` (`structure_id`,`period`,`company_id`),
  KEY `idx_vc_deleted_at` (`deleted_at`),
  KEY `idx_vc_customer` (`customer_id`),
  KEY `idx_vc_location` (`location_id`),
  KEY `idx_visit_customers_period_status_loc_del` (`period`,`status`,`deleted_at`,`location_id`,`structure_id`,`customer_id`),
  KEY `idx_vc_period_company_del_cust_loc` (`period`,`company_id`,`deleted_at`,`customer_id`,`location_id`,`structure_id`),
  KEY `idx_vc_period_structure_customer_user_cluster` (`period`,`structure_id`,`customer_id`,`user_id`,`cluster`),
  KEY `idx_vc_period_structure_customer_user` (`period`,`structure_id`,`customer_id`,`user_id`),
  KEY `idx_vc_report_coverage` (`period`,`structure_id`,`status`,`deleted_at`,`customer_id`,`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=463847 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `visit_customers` (5 rows)
INSERT INTO `visit_customers` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `period`, `customer_name`, `customer_phone`, `priority`, `type`, `status`, `level`, `approved_structure_id`, `approved_time`, `structure_id`, `out_of_city`, `user_id`, `user_name`, `customer_id`, `location_id`, `company_id`, `rejected_structure_id`, `note`, `rejected_time`, `cluster`, `amortization`) VALUES
  (454, '2025-05-05 01:57:47.802000', '2025-05-05 02:36:59.915000', NULL, 1190460, 1190460, NULL, '202505', ' PUTU DIANISA ROSARI DEWI', '6281237049994', '', '5', 'approved', 2, 'TRNFSM1', '2025-05-05 02:36:59.852000', 'TRNSPV2', 0, 1241026, 'Maya Insani', '23060037', '', 1, '', NULL, NULL, '', ''),
  (456, '2025-05-05 02:33:35.903000', '2025-05-05 02:37:02.285000', NULL, 1190460, 1190460, NULL, '202505', 'ahmad dhani', '', '', '44,45', 'approved', 2, 'TRNFSM1', '2025-05-05 02:37:02.223000', 'TRNSPV2', 0, 1241026, 'Maya Insani', '1729473904', '', 1, '', NULL, NULL, '', ''),
  (457, '2025-05-05 02:39:32.895000', '2025-05-05 02:40:38.145000', NULL, 1190460, 1190460, NULL, '202505', 'DINA NILASARI', '+628111111111', '', '', 'approved', 2, 'TRNFSM1', '2025-05-05 02:40:38.080000', 'TRNSPV2', 0, 1241026, 'Maya Insani', '23110046', '', 1, '', NULL, NULL, '', ''),
  (458, '2025-05-05 02:39:42.814000', '2025-05-14 03:10:34.561000', NULL, 1190460, 1190460, NULL, '202505', 'ANTONIUS AGUNG PURNAMA', '', '', '15', 'approved', 2, 'TRNFSM1', '2025-05-14 03:10:34.501000', 'TRNSPV2', 0, 1241026, 'Maya Insani', 'DKI19-0311', '', 1, '', NULL, NULL, '', ''),
  (460, '2025-05-06 09:40:20.632000', '2025-05-06 09:41:12.398000', NULL, 1190460, 1190460, NULL, '202505', 'MAIZUL ANWAR', '', '', '15', 'approved', 2, 'TRNFSM1', '2025-05-06 09:41:12.316000', 'TRNSPV2', 0, 1241026, 'Maya Insani', 'DKI18-0108', '', 1, '', NULL, NULL, '', '');

-- --------------------------------------------------------------------
-- Table structure for `visit_members`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visit_members`;
CREATE TABLE `visit_members` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `visit_id` bigint unsigned DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company` bigint DEFAULT NULL,
  `company_id` bigint DEFAULT NULL,
  `check_in_latitude` double DEFAULT NULL,
  `check_in_longitude` double DEFAULT NULL,
  `checkin_time` datetime DEFAULT NULL,
  `check_out_latitude` double DEFAULT NULL,
  `check_out_longitude` double DEFAULT NULL,
  `checkout_time` datetime DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_visit_member` (`structure_id`,`visit_id`,`period`,`company`),
  KEY `idx_visit_members_deleted_at` (`deleted_at`),
  KEY `fk_visits_visit_member` (`visit_id`),
  KEY `idx_visit_members_structure_id` (`structure_id`) USING BTREE,
  KEY `idx_visit_members_period` (`period`) USING BTREE,
  KEY `idx_visit_members_company_id` (`company_id`) USING BTREE,
  KEY `idx_visit_members_filter` (`period`,`structure_id`,`deleted_at`,`visit_id`),
  KEY `idx_visit_members_main` (`period`,`structure_id`,`visit_id`,`deleted_at`),
  KEY `idx_visit_members_period_del_visitid` (`period`,`deleted_at`,`visit_id`,`structure_id`),
  CONSTRAINT `fk_visits_visit_member` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1380302 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `visit_members` (5 rows)
INSERT INTO `visit_members` (`id`, `created_at`, `updated_at`, `deleted_at`, `structure_id`, `user_id`, `visit_id`, `period`, `company`, `company_id`, `check_in_latitude`, `check_in_longitude`, `checkin_time`, `check_out_latitude`, `check_out_longitude`, `checkout_time`, `created_by_id`, `updated_by_id`, `deleted_by_id`) VALUES
  (1159255, '2025-05-14 02:34:11.981000', '2025-05-14 02:34:11.981000', NULL, 'TRNFSM1', NULL, 1157522, '202505', NULL, 1, 0.0, 0.0, NULL, 0.0, 0.0, NULL, 0, 0, NULL),
  (1159256, '2025-05-14 02:35:07.653000', '2025-05-14 02:35:07.653000', NULL, 'TRNFSM1', NULL, 1157523, '202505', NULL, 1, 0.0, 0.0, NULL, 0.0, 0.0, NULL, 0, 0, NULL),
  (1159257, '2025-05-14 02:36:47.018000', '2025-05-14 02:36:47.018000', NULL, 'TRNFSM1', NULL, 1157524, '202505', NULL, 1, 0.0, 0.0, NULL, 0.0, 0.0, NULL, 0, 0, NULL),
  (1159258, '2025-05-14 02:42:57.926000', '2025-05-14 02:48:41.119000', NULL, 'TRNFSM1', NULL, 1157525, '202505', NULL, 1, -6.1908672, 106.7644877, '2025-05-14 09:46:29', -6.1908613, 106.7644858, '2025-05-14 02:48:41', 0, 1190460, NULL),
  (1159259, '2025-05-20 08:44:48.819000', '2025-05-20 08:44:48.819000', NULL, 'TRNFSM1', NULL, 1157526, '202505', NULL, 1, 0.0, 0.0, NULL, 0.0, 0.0, NULL, 0, 0, NULL);

-- --------------------------------------------------------------------
-- Table structure for `visit_products`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visit_products`;
CREATE TABLE `visit_products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `product_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `visit_id` bigint unsigned DEFAULT NULL,
  `is_detail` tinyint(1) DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `qty_rx_per_day` double DEFAULT NULL,
  `qty_tablet_per_rx` double DEFAULT NULL,
  `qty_practice_per_month` double DEFAULT NULL,
  `note` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_visit_Product` (`product_id`,`visit_id`),
  KEY `idx_visit_products_deleted_at` (`deleted_at`),
  KEY `fk_visit_products_visit` (`visit_id`) USING BTREE,
  KEY `idx_visit_products_product_id` (`product_id`) USING BTREE,
  CONSTRAINT `fk_visit_products_visit` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=246805 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `visit_products` (5 rows)
INSERT INTO `visit_products` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `product_id`, `visit_id`, `is_detail`, `qty`, `qty_rx_per_day`, `qty_tablet_per_rx`, `qty_practice_per_month`, `note`) VALUES
  (220, '2025-05-22 02:39:31.792000', '2025-05-22 02:39:31.792000', NULL, 1220811, 1220811, NULL, 'BINHDT2M', 1157541, 1, NULL, NULL, NULL, NULL, 'test'),
  (221, '2025-05-22 02:39:31.895000', '2025-05-22 02:39:31.895000', NULL, 1220811, 1220811, NULL, 'BIOKSM', 1157541, 1, NULL, NULL, NULL, NULL, 'tes'),
  (222, '2025-05-22 02:46:39.478000', '2025-05-22 02:46:39.478000', NULL, 1220811, 1220811, NULL, 'ASAM', 1157552, 1, NULL, NULL, NULL, NULL, 'test'),
  (223, '2025-05-22 03:03:54.127000', '2025-05-22 03:03:54.127000', NULL, 1190434, 1190434, NULL, 'ASPEC500', 1157562, 1, NULL, NULL, NULL, NULL, 'test'),
  (224, '2025-05-22 03:05:42.125000', '2025-05-22 03:05:42.125000', NULL, 1220811, 1220811, NULL, 'ASPEC500', 1157563, 1, NULL, NULL, NULL, NULL, 'test');

-- --------------------------------------------------------------------
-- Table structure for `visits`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `visits`;
CREATE TABLE `visits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `structure_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `customer_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'USER',
  `customer_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type_visit` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '-',
  `checkin_time` datetime(3) DEFAULT NULL,
  `checkout_time` datetime(3) DEFAULT NULL,
  `schedule_datetime` datetime(3) DEFAULT NULL,
  `schedule_end` datetime(6) DEFAULT NULL,
  `check_in_radius` double DEFAULT NULL,
  `location_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `check_out_radius` double DEFAULT NULL,
  `approved_structure_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `approved_time` datetime(3) DEFAULT NULL,
  `approved_note` varchar(500) DEFAULT NULL,
  `closed_structure_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `closed_time` datetime(3) DEFAULT NULL,
  `proof_photo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `proof_signature` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` bigint NOT NULL,
  `checkin_latitude` double DEFAULT NULL,
  `checkout_latitude` double DEFAULT NULL,
  `checkin_longitude` double DEFAULT NULL,
  `checkout_longitude` double DEFAULT NULL,
  `location_latitude` double DEFAULT NULL,
  `location_longitude` double DEFAULT NULL,
  `customer_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `customer_phone` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `user_name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `location_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `accuracy` double DEFAULT NULL,
  `is_survey` tinyint(1) DEFAULT NULL,
  `is_mandatory` tinyint(1) DEFAULT NULL,
  `out_of_city` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`,`period`,`customer_id`,`location_id`,`company_id`),
  UNIQUE KEY `idx_visit_id` (`id`),
  UNIQUE KEY `idx_visit` (`structure_id`,`period`,`customer_id`,`checkin_time`,`location_id`,`company_id`),
  KEY `idx_visits_deleted_at` (`deleted_at`),
  KEY `fk_visits_created_by` (`created_by_id`),
  KEY `fk_locations_visit` (`location_id`),
  KEY `idx_visits_status` (`status`) USING BTREE,
  KEY `idx_visits_company_id` (`company_id`) USING BTREE,
  KEY `idx_schedule_datetime` (`schedule_datetime`) USING BTREE,
  KEY `idx_visits_filter` (`structure_id`,`customer_id`,`location_id`,`company_id`,`period`,`deleted_at`,`status`),
  KEY `idx_visits_join` (`structure_id`,`customer_id`,`location_id`,`period`,`company_id`,`type`,`status`,`deleted_at`),
  KEY `idx_visits_customer_del` (`customer_id`,`deleted_at`,`status`),
  KEY `idx_visits_call` (`structure_id`,`company_id`,`period`,`customer_id`,`type`,`deleted_at`),
  KEY `idx_visits_heavy` (`structure_id`,`company_id`,`period`,`type`,`deleted_at`,`customer_id`,`location_id`,`status`),
  KEY `idx_visits_count` (`structure_id`,`company_id`,`period`,`deleted_at`,`id`),
  KEY `idx_visits_period_type_status_del` (`period`,`type`,`status`,`deleted_at`),
  KEY `idx_visits_id_period` (`id`,`period`),
  KEY `idx_visits_coverage` (`period`,`structure_id`,`customer_id`,`status`,`deleted_at`),
  KEY `idx_visits_period_cust_struct` (`period`,`customer_id`,`structure_id`),
  KEY `idx_visits_coverage_customer` (`period`,`structure_id`,`customer_id`,`type`,`deleted_at`,`status`),
  KEY `idx_visits_coverage_location` (`period`,`structure_id`,`location_id`,`type`,`deleted_at`,`status`),
  KEY `idx_visits_period_struct_del_checkin` (`period`,`structure_id`,`deleted_at`,`checkin_time` DESC),
  KEY `idx_visits_history_period_deleted_checkout` (`period`,`deleted_at`,`checkout_time` DESC),
  CONSTRAINT `fk_customers_visit` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_locations_visit` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  CONSTRAINT `fk_visits_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1343550 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `visits` (5 rows)
INSERT INTO `visits` (`id`, `created_at`, `updated_at`, `deleted_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `status`, `type`, `title`, `structure_id`, `period`, `customer_category`, `customer_id`, `type_visit`, `checkin_time`, `checkout_time`, `schedule_datetime`, `schedule_end`, `check_in_radius`, `location_id`, `check_out_radius`, `approved_structure_id`, `approved_time`, `approved_note`, `closed_structure_id`, `closed_time`, `proof_photo`, `proof_signature`, `note`, `company_id`, `checkin_latitude`, `checkout_latitude`, `checkin_longitude`, `checkout_longitude`, `location_latitude`, `location_longitude`, `customer_name`, `customer_phone`, `location_name`, `user_name`, `location_address`, `accuracy`, `is_survey`, `is_mandatory`, `out_of_city`) VALUES
  (1157451, '2025-03-10 06:41:26.398000', '2025-08-22 06:13:36.928000', NULL, 2100324, 1230851, NULL, 'plan-approved', 'call', '', 'TRNMR', '202503', '', 'DKI18-0050', '-', NULL, NULL, '2025-03-01 03:41:00', NULL, NULL, 'DKI160559', NULL, 'TRNSPV', '2025-03-10 07:10:45.221000', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0.0, NULL, 0.0, NULL, -6.195110778890106, 106.8366115540266, 'Intan Permatasari (Apth) Rs Bunda Jakarta', '081344586697', 'DKI-BUNDA JAKARTA (RSIA BUNDA/BUNDA GLOBAL PHARMA/MORULA IVF)', 'Rizki Agustian ', 'JL. SUTAN SYAHRIR NO.3 GONDANGDIA MENTENG  JAKARTA PUSAT / JL.TEUKU CIK DITIRO NO.28 MENTENG,JAKARTA PUSAT ', 0.0, 0, 0, 0),
  (1157478, '2025-03-23 03:19:11.317000', '2025-08-13 08:12:20.741000', NULL, 1050131, 1210651, NULL, 'plan-approved', 'call', '', 'MD1', '202503', '', 'DKI19-0395', '-', NULL, NULL, '2025-03-01 10:30:00', NULL, NULL, 'NON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0.0, NULL, 0.0, NULL, -6.150768937579743, 106.89219731837511, 'Silvia Werdhy Lestari', '62859595012', 'NON LOCATION', 'SRI PURWO NUGROHO', 'Mall of Indonesia, Jalan Boulevard Barat, RW 19, Kelapa Gading Barat, Kelapa Gading, Jakarta Utara, Daerah Khusus Ibukota Jakarta, Jawa, 14240, Indonesia', 0.0, 0, 0, 0),
  (1157479, '2025-03-23 03:24:08.595000', '2025-08-13 08:12:20.741000', NULL, 1050131, 1210651, NULL, 'realization-approved', 'call', '', 'MD1', '202503', '', 'DKI19-0395', '-', '2025-03-23 17:23:05.694000', '2025-03-23 11:56:00.488000', '2025-03-23 10:23:00', NULL, 10.0, 'NON', 77.0, NULL, NULL, NULL, NULL, NULL, 'proof-photo-824651335176.png', 'proof-signature-824651335176.png', 'tes', 1, -6.150841611099034, -6.151404426178375, 106.89225587297162, 106.89191946938199, -6.150769937617966, 106.89219698309898, 'Silvia Werdhy Lestari', '62859595012', 'NON LOCATION', 'SRI PURWO NUGROHO', 'Mall of Indonesia, Jalan Tol Sunter–Pulo Gebang, RW 19, Kelapa Gading Barat, Kelapa Gading, Jakarta Utara, Daerah Khusus Ibukota Jakarta, Jawa, 14240, Indonesia', 56.7798043056202, 0, 0, 0),
  (1157492, '2025-03-25 08:04:11.240000', '2025-08-04 11:57:47.505000', NULL, 1050131, 1190475, NULL, 'plan-approved', 'call', '', 'MD1', '202503', '', 'TGR17-0814', '-', NULL, NULL, '2025-03-25 08:03:00', NULL, NULL, 'NON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0.0, NULL, 0.0, NULL, -6.190913619767637, 106.76438704133034, 'Heru Harsojo Oentoeng', '62811161171', 'NON LOCATION', 'SRI PURWO NUGROHO', 'Rumah Sakit Siloam, Gang Cempaka, RW 10, Kebon Jeruk, Jakarta Barat, Daerah Khusus Ibukota Jakarta, Jawa, 11530, Indonesia', 0.0, 0, 0, 0),
  (1157493, '2025-03-25 11:47:34.001000', '2025-08-13 13:47:39.428000', NULL, 1190460, 1240977, NULL, 'draft', 'call', '', 'TRNASM', '202503', '', 'TGR19-0107', '-', NULL, NULL, '2025-03-25 11:45:00', NULL, NULL, 'TGR160880', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0.0, NULL, 0.0, NULL, -6.226758722351026, 106.61689471453428, 'Miswidia  (Apth) Rs Alia', '+6228136749', 'TGR-QADR, RS.', 'Urip Wahyudi', 'JL. RAYA ISLAMIC VILLAGE TANGERANG', 0.0, 0, 0, 0);

-- --------------------------------------------------------------------
-- Table structure for `work_hour_users`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `work_hour_users`;
CREATE TABLE `work_hour_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `work_hour_id` bigint unsigned DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_work_hour_user` (`user_id`,`work_hour_id`,`company_id`),
  KEY `fk_work_hour_users_created_by` (`created_by_id`),
  KEY `fk_work_hour_users_updated_by` (`updated_by_id`),
  KEY `fk_work_hour_users_work_hour` (`work_hour_id`),
  KEY `idx_company_id` (`company_id`),
  CONSTRAINT `fk_work_hour_users_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_work_hour_users_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_work_hour_users_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_work_hour_users_work_hour` FOREIGN KEY (`work_hour_id`) REFERENCES `work_hours` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `work_hour_users` (5 rows)
INSERT INTO `work_hour_users` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `user_id`, `work_hour_id`, `company_id`) VALUES
  (47, NULL, NULL, NULL, NULL, NULL, 1200579, 1, 1),
  (48, NULL, NULL, NULL, NULL, NULL, 1220753, 1, 1),
  (49, NULL, NULL, NULL, NULL, NULL, 1220814, 1, 1),
  (50, NULL, NULL, NULL, NULL, NULL, 1230832, 1, 1),
  (51, NULL, NULL, NULL, NULL, NULL, 1230826, 1, 1);

-- --------------------------------------------------------------------
-- Table structure for `work_hours`
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `work_hours`;
CREATE TABLE `work_hours` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  `deleted_by_id` bigint unsigned DEFAULT NULL,
  `name` varchar(500) NOT NULL,
  `start_date` datetime(3) DEFAULT NULL,
  `end_date` datetime(3) DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `day1_in` varchar(100) DEFAULT NULL,
  `day1_out` varchar(100) DEFAULT NULL,
  `day2_in` varchar(100) DEFAULT NULL,
  `day2_out` varchar(100) DEFAULT NULL,
  `day3_in` varchar(100) DEFAULT NULL,
  `day3_out` varchar(100) DEFAULT NULL,
  `day4_in` varchar(100) DEFAULT NULL,
  `day4_out` varchar(100) DEFAULT NULL,
  `day5_in` varchar(100) DEFAULT NULL,
  `day5_out` varchar(100) DEFAULT NULL,
  `day6_in` varchar(100) DEFAULT NULL,
  `day6_out` varchar(100) DEFAULT NULL,
  `day7_in` varchar(100) DEFAULT NULL,
  `day7_out` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_work_hour` (`name`,`start_date`,`end_date`,`company_id`),
  KEY `fk_work_hours_created_by` (`created_by_id`),
  KEY `fk_work_hours_updated_by` (`updated_by_id`),
  KEY `idx_end_date` (`end_date`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_workhours_start_end_id` (`start_date`,`end_date`,`id`),
  CONSTRAINT `fk_work_hours_created_by` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_work_hours_updated_by` FOREIGN KEY (`updated_by_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Supporting sample data for `work_hours` (5 rows)
INSERT INTO `work_hours` (`id`, `created_at`, `updated_at`, `created_by_id`, `updated_by_id`, `deleted_by_id`, `name`, `start_date`, `end_date`, `company_id`, `day1_in`, `day1_out`, `day2_in`, `day2_out`, `day3_in`, `day3_out`, `day4_in`, `day4_out`, `day5_in`, `day5_out`, `day6_in`, `day6_out`, `day7_in`, `day7_out`) VALUES
  (1, '2025-08-18 09:01:12.411000', '2026-01-15 04:08:43.750000', 2207004, 2201001, NULL, 'PT. Metiska Farma HO', '2026-01-01 17:00:00', '2026-12-30 16:59:59.999000', 1, '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', NULL, NULL, NULL, NULL),
  (2, '2026-02-10 08:11:41', '2026-02-10 08:11:41', 2207004, 2201001, NULL, 'PT. Vneu Teknologi Indonesia', '2026-01-01 17:00:00', '2026-12-30 16:59:59.999000', 1, '07:00', '16:00', '07:00', '16:00', '07:00', '16:00', '07:00', '16:00', '07:00', '16:00', '', '', '', ''),
  (3, '2026-02-10 08:11:41', '2026-02-10 08:11:41', 2207004, 2201001, NULL, 'PT. Voltunes', '2026-01-01 17:00:00', '2026-12-30 16:59:59.999000', 1, '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '', '', '', ''),
  (7, '2026-05-26 03:27:28.232000', '2026-05-26 03:27:28.232000', 1901016, 1901016, NULL, 'Test', '2026-05-25 17:00:00', '2026-05-30 16:59:59.999000', 1, '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
  (10, '2026-08-07 03:38:13.302000', '2026-08-07 03:39:00.484000', 1901016, 1901016, NULL, 'PT. Rismawan Pratama Bersinar', '2025-12-31 17:00:00', '2026-12-31 16:59:59.999000', 1, '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '08:00', '17:00', '', '', '', '');

-- ====================================================================
-- SECTION 2: DATABASE VIEWS
-- ====================================================================

-- --------------------------------------------------------------------
-- View structure for `attendance_user`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `attendance_user`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `attendance_user` AS select `u`.`id` AS `user_id`,max(`p`.`in_recognized_name`) AS `recognized_name`,max(`p`.`dept`) AS `department`,`c`.`date` AS `date`,concat((case dayofweek(`c`.`date`) when 1 then `wh`.`day7_in` when 2 then `wh`.`day1_in` when 3 then `wh`.`day2_in` when 4 then `wh`.`day3_in` when 5 then `wh`.`day4_in` when 6 then `wh`.`day5_in` when 7 then `wh`.`day6_in` end),'-',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_out` when 2 then `wh`.`day1_out` when 3 then `wh`.`day2_out` when 4 then `wh`.`day3_out` when 5 then `wh`.`day4_out` when 6 then `wh`.`day5_out` when 7 then `wh`.`day6_out` end)) AS `work_hours`,date_format((`p`.`in_date_time` + interval 7 hour),'%H') AS `checkin_hour`,date_format((`p`.`in_date_time` + interval 7 hour),'%i') AS `checkin_minute`,date_format((`p`.`out_date_time` + interval 7 hour),'%H') AS `checkout_hour`,date_format((`p`.`out_date_time` + interval 7 hour),'%i') AS `checkout_minute`,(greatest(timestampdiff(MINUTE,str_to_date(concat(`c`.`date`,' ',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_in` when 2 then `wh`.`day1_in` when 3 then `wh`.`day2_in` when 4 then `wh`.`day3_in` when 5 then `wh`.`day4_in` when 6 then `wh`.`day5_in` when 7 then `wh`.`day6_in` end)),'%Y-%m-%d %H:%i'),(`p`.`in_date_time` + interval 7 hour)),0) DIV 60) AS `late_hours`,(greatest(timestampdiff(MINUTE,str_to_date(concat(`c`.`date`,' ',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_in` when 2 then `wh`.`day1_in` when 3 then `wh`.`day2_in` when 4 then `wh`.`day3_in` when 5 then `wh`.`day4_in` when 6 then `wh`.`day5_in` when 7 then `wh`.`day6_in` end)),'%Y-%m-%d %H:%i'),(`p`.`in_date_time` + interval 7 hour)),0) % 60) AS `late_minutes`,(greatest(timestampdiff(MINUTE,str_to_date(concat(`c`.`date`,' ',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_out` when 2 then `wh`.`day1_out` when 3 then `wh`.`day2_out` when 4 then `wh`.`day3_out` when 5 then `wh`.`day4_out` when 6 then `wh`.`day5_out` when 7 then `wh`.`day6_out` end)),'%Y-%m-%d %H:%i'),(`p`.`out_date_time` + interval 7 hour)),0) DIV 60) AS `overtime_hours`,(greatest(timestampdiff(MINUTE,str_to_date(concat(`c`.`date`,' ',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_out` when 2 then `wh`.`day1_out` when 3 then `wh`.`day2_out` when 4 then `wh`.`day3_out` when 5 then `wh`.`day4_out` when 6 then `wh`.`day5_out` when 7 then `wh`.`day6_out` end)),'%Y-%m-%d %H:%i'),(`p`.`out_date_time` + interval 7 hour)),0) % 60) AS `overtime_minutes`,(greatest(timestampdiff(MINUTE,(`p`.`out_date_time` + interval 7 hour),str_to_date(concat(`c`.`date`,' ',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_out` when 2 then `wh`.`day1_out` when 3 then `wh`.`day2_out` when 4 then `wh`.`day3_out` when 5 then `wh`.`day4_out` when 6 then `wh`.`day5_out` when 7 then `wh`.`day6_out` end)),'%Y-%m-%d %H:%i')),0) DIV 60) AS `early_checkout_hours`,(greatest(timestampdiff(MINUTE,(`p`.`out_date_time` + interval 7 hour),str_to_date(concat(`c`.`date`,' ',(case dayofweek(`c`.`date`) when 1 then `wh`.`day7_out` when 2 then `wh`.`day1_out` when 3 then `wh`.`day2_out` when 4 then `wh`.`day3_out` when 5 then `wh`.`day4_out` when 6 then `wh`.`day5_out` when 7 then `wh`.`day6_out` end)),'%Y-%m-%d %H:%i')),0) % 60) AS `early_checkout_minutes`,floor((timestampdiff(MINUTE,(`p`.`in_date_time` + interval 7 hour),(`p`.`out_date_time` + interval 7 hour)) / 60)) AS `total_work_hours`,(timestampdiff(MINUTE,(`p`.`in_date_time` + interval 7 hour),(`p`.`out_date_time` + interval 7 hour)) % 60) AS `total_work_minutes`,`l`.`note` AS `note`,(case when ((trim(ifnull(`c`.`description`,'')) <> '') and (`c`.`description` <> 'Hari kerja biasa')) then upper(`c`.`description`) when (dayofweek(`c`.`date`) in (1,7)) then 'OFF' when ((case dayofweek(`c`.`date`) when 1 then `wh`.`day7_in` when 2 then `wh`.`day1_in` when 3 then `wh`.`day2_in` when 4 then `wh`.`day3_in` when 5 then `wh`.`day4_in` when 6 then `wh`.`day5_in` when 7 then `wh`.`day6_in` end) is null) then 'OFF' when (`l`.`id` is not null) then upper(`lc`.`name`) when (`p`.`id` is not null) then 'FACE' when (`c`.`date` > curdate()) then NULL else 'ALPHA' end) AS `description` from ((((((`calendars` `c` join `users` `u` on((`u`.`company_id` = `c`.`company_id`))) left join `presences` `p` on(((`p`.`user_id` = `u`.`id`) and (cast((`p`.`in_date_time` + interval 7 hour) as date) = `c`.`date`)))) left join `work_hour_users` `whu` on((`whu`.`user_id` = `u`.`id`))) left join `work_hours` `wh` on((`wh`.`id` = `whu`.`work_hour_id`))) left join `leaves` `l` on(((`l`.`user_id` = `u`.`id`) and (`l`.`status` = 'approved hrd') and (`c`.`date` between cast((`l`.`start_date` + interval 7 hour) as date) and cast((`l`.`end_date` + interval 7 hour) as date))))) left join `leave_categories` `lc` on((`lc`.`id` = `l`.`leave_category_id`))) where (`c`.`company_id` = 1) group by `u`.`id`,`c`.`date`;

-- --------------------------------------------------------------------
-- View structure for `attendance_user_deduction`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `attendance_user_deduction`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `attendance_user_deduction` AS with `base` as (select `u`.`id` AS `user_id`,max(`p`.`in_recognized_name`) AS `recognized_name`,max(`p`.`dept`) AS `department`,`c`.`date` AS `date`,date_format(`c`.`date`,'%Y%m') AS `period`,`wh`.`day1_in` AS `day1_in`,`wh`.`day1_out` AS `day1_out`,`wh`.`day2_in` AS `day2_in`,`wh`.`day2_out` AS `day2_out`,`wh`.`day3_in` AS `day3_in`,`wh`.`day3_out` AS `day3_out`,`wh`.`day4_in` AS `day4_in`,`wh`.`day4_out` AS `day4_out`,`wh`.`day5_in` AS `day5_in`,`wh`.`day5_out` AS `day5_out`,`wh`.`day6_in` AS `day6_in`,`wh`.`day6_out` AS `day6_out`,`wh`.`day7_in` AS `day7_in`,`wh`.`day7_out` AS `day7_out`,`p`.`in_date_time` AS `in_date_time`,`p`.`out_date_time` AS `out_date_time`,`l`.`note` AS `note` from (((((`calendars` `c` join `users` `u` on((`u`.`company_id` = `c`.`company_id`))) left join `presences` `p` on(((`p`.`user_id` = `u`.`id`) and (cast((`p`.`in_date_time` + interval 7 hour) as date) = `c`.`date`)))) left join `work_hour_users` `whu` on((`whu`.`user_id` = `u`.`id`))) left join `work_hours` `wh` on((`wh`.`id` = `whu`.`work_hour_id`))) left join `leaves` `l` on(((`l`.`user_id` = `u`.`id`) and (`l`.`status` = 'approved hrd') and (`c`.`date` between cast((`l`.`start_date` + interval 7 hour) as date) and cast((`l`.`end_date` + interval 7 hour) as date))))) where (`c`.`company_id` = 1) group by `u`.`id`,`c`.`date`), `calc` as (select `b`.`user_id` AS `user_id`,`b`.`recognized_name` AS `recognized_name`,`b`.`department` AS `department`,`b`.`date` AS `date`,`b`.`period` AS `period`,`b`.`day1_in` AS `day1_in`,`b`.`day1_out` AS `day1_out`,`b`.`day2_in` AS `day2_in`,`b`.`day2_out` AS `day2_out`,`b`.`day3_in` AS `day3_in`,`b`.`day3_out` AS `day3_out`,`b`.`day4_in` AS `day4_in`,`b`.`day4_out` AS `day4_out`,`b`.`day5_in` AS `day5_in`,`b`.`day5_out` AS `day5_out`,`b`.`day6_in` AS `day6_in`,`b`.`day6_out` AS `day6_out`,`b`.`day7_in` AS `day7_in`,`b`.`day7_out` AS `day7_out`,`b`.`in_date_time` AS `in_date_time`,`b`.`out_date_time` AS `out_date_time`,`b`.`note` AS `note`,(case dayofweek(`b`.`date`) when 1 then `b`.`day7_in` when 2 then `b`.`day1_in` when 3 then `b`.`day2_in` when 4 then `b`.`day3_in` when 5 then `b`.`day4_in` when 6 then `b`.`day5_in` when 7 then `b`.`day6_in` end) AS `shift_in`,(case dayofweek(`b`.`date`) when 1 then `b`.`day7_out` when 2 then `b`.`day1_out` when 3 then `b`.`day2_out` when 4 then `b`.`day3_out` when 5 then `b`.`day4_out` when 6 then `b`.`day5_out` when 7 then `b`.`day6_out` end) AS `shift_out` from `base` `b`), `time_calc` as (select `c`.`user_id` AS `user_id`,`c`.`recognized_name` AS `recognized_name`,`c`.`department` AS `department`,`c`.`date` AS `date`,`c`.`period` AS `period`,`c`.`day1_in` AS `day1_in`,`c`.`day1_out` AS `day1_out`,`c`.`day2_in` AS `day2_in`,`c`.`day2_out` AS `day2_out`,`c`.`day3_in` AS `day3_in`,`c`.`day3_out` AS `day3_out`,`c`.`day4_in` AS `day4_in`,`c`.`day4_out` AS `day4_out`,`c`.`day5_in` AS `day5_in`,`c`.`day5_out` AS `day5_out`,`c`.`day6_in` AS `day6_in`,`c`.`day6_out` AS `day6_out`,`c`.`day7_in` AS `day7_in`,`c`.`day7_out` AS `day7_out`,`c`.`in_date_time` AS `in_date_time`,`c`.`out_date_time` AS `out_date_time`,`c`.`note` AS `note`,`c`.`shift_in` AS `shift_in`,`c`.`shift_out` AS `shift_out`,(`c`.`in_date_time` + interval 7 hour) AS `checkin`,(`c`.`out_date_time` + interval 7 hour) AS `checkout`,greatest(timestampdiff(MINUTE,str_to_date(concat(`c`.`date`,' ',`c`.`shift_in`),'%Y-%m-%d %H:%i'),(`c`.`in_date_time` + interval 7 hour)),0) AS `total_late_minutes`,greatest(timestampdiff(MINUTE,str_to_date(concat(`c`.`date`,' ',`c`.`shift_out`),'%Y-%m-%d %H:%i'),(`c`.`out_date_time` + interval 7 hour)),0) AS `total_overtime_minutes`,greatest(timestampdiff(MINUTE,(`c`.`out_date_time` + interval 7 hour),str_to_date(concat(`c`.`date`,' ',`c`.`shift_out`),'%Y-%m-%d %H:%i')),0) AS `total_early_minutes`,timestampdiff(MINUTE,(`c`.`in_date_time` + interval 7 hour),(`c`.`out_date_time` + interval 7 hour)) AS `total_work_minutes_raw` from `calc` `c`), `rule_match` as (select `t`.`user_id` AS `user_id`,`t`.`recognized_name` AS `recognized_name`,`t`.`department` AS `department`,`t`.`date` AS `date`,`t`.`period` AS `period`,`t`.`day1_in` AS `day1_in`,`t`.`day1_out` AS `day1_out`,`t`.`day2_in` AS `day2_in`,`t`.`day2_out` AS `day2_out`,`t`.`day3_in` AS `day3_in`,`t`.`day3_out` AS `day3_out`,`t`.`day4_in` AS `day4_in`,`t`.`day4_out` AS `day4_out`,`t`.`day5_in` AS `day5_in`,`t`.`day5_out` AS `day5_out`,`t`.`day6_in` AS `day6_in`,`t`.`day6_out` AS `day6_out`,`t`.`day7_in` AS `day7_in`,`t`.`day7_out` AS `day7_out`,`t`.`in_date_time` AS `in_date_time`,`t`.`out_date_time` AS `out_date_time`,`t`.`note` AS `note`,`t`.`shift_in` AS `shift_in`,`t`.`shift_out` AS `shift_out`,`t`.`checkin` AS `checkin`,`t`.`checkout` AS `checkout`,`t`.`total_late_minutes` AS `total_late_minutes`,`t`.`total_overtime_minutes` AS `total_overtime_minutes`,`t`.`total_early_minutes` AS `total_early_minutes`,`t`.`total_work_minutes_raw` AS `total_work_minutes_raw`,`ad`.`late_start` AS `late_start`,`ad`.`late_end` AS `late_end`,`ad`.`grace_days` AS `grace_days`,`ad`.`penalty_amount` AS `penalty_amount`,count(0) OVER (PARTITION BY `t`.`user_id`,`t`.`period`,`ad`.`id` ORDER BY `t`.`date` )  AS `late_count` from (`time_calc` `t` left join `attendance_deductions` `ad` on(((`ad`.`company_id` = 1) and (`ad`.`period` = `t`.`period`) and (`t`.`total_late_minutes` between `ad`.`late_start` and `ad`.`late_end`))))) select `rule_match`.`user_id` AS `user_id`,`rule_match`.`recognized_name` AS `recognized_name`,`rule_match`.`department` AS `department`,`rule_match`.`date` AS `date`,concat(`rule_match`.`shift_in`,'-',`rule_match`.`shift_out`) AS `work_hours`,date_format(`rule_match`.`checkin`,'%H') AS `checkin_hour`,date_format(`rule_match`.`checkin`,'%i') AS `checkin_minute`,date_format(`rule_match`.`checkout`,'%H') AS `checkout_hour`,date_format(`rule_match`.`checkout`,'%i') AS `checkout_minute`,floor((`rule_match`.`total_late_minutes` / 60)) AS `late_hours`,(`rule_match`.`total_late_minutes` % 60) AS `late_minutes`,floor((`rule_match`.`total_overtime_minutes` / 60)) AS `overtime_hours`,(`rule_match`.`total_overtime_minutes` % 60) AS `overtime_minutes`,floor((`rule_match`.`total_early_minutes` / 60)) AS `early_checkout_hours`,(`rule_match`.`total_early_minutes` % 60) AS `early_checkout_minutes`,floor((`rule_match`.`total_work_minutes_raw` / 60)) AS `total_work_hours`,(`rule_match`.`total_work_minutes_raw` % 60) AS `total_work_minutes`,`rule_match`.`note` AS `note`,(case when (`rule_match`.`late_start` = 1) then 1 else 0 end) AS `late_1_15`,(case when (`rule_match`.`late_start` = 16) then 1 else 0 end) AS `late_16_60`,(case when (`rule_match`.`late_start` = 61) then 1 else 0 end) AS `late_61_120`,(case when (`rule_match`.`late_start` = 121) then 1 else 0 end) AS `late_121_240`,(case when (`rule_match`.`total_late_minutes` = 0) then 0 when ((`rule_match`.`grace_days` > 0) and (`rule_match`.`late_count` <= `rule_match`.`grace_days`)) then 0 else `rule_match`.`penalty_amount` end) AS `total_deduction` from `rule_match`;

-- --------------------------------------------------------------------
-- View structure for `leave_quotas`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `leave_quotas`;
CREATE ALGORITHM=UNDEFINED DEFINER=`vneu_umar`@`%` SQL SECURITY DEFINER VIEW `leave_quotas` AS select `leave_quota`.`id` AS `id`,`leave_quota`.`created_at` AS `created_at`,`leave_quota`.`updated_at` AS `updated_at`,`leave_quota`.`created_by_id` AS `created_by_id`,`leave_quota`.`updated_by_id` AS `updated_by_id`,`leave_quota`.`deleted_by_id` AS `deleted_by_id`,`leave_quota`.`days` AS `days`,`leave_quota`.`day_remaining` AS `day_remaining`,`leave_quota`.`user_id` AS `user_id`,`leave_quota`.`start_date` AS `start_date`,`leave_quota`.`end_date` AS `end_date`,`leave_quota`.`leave_category_id` AS `leave_category_id`,`leave_quota`.`leave_period_id` AS `leave_period_id`,`leave_quota`.`company_id` AS `company_id`,`leave_quota`.`is_active` AS `is_active`,`leave_quota`.`period` AS `period` from `leave_quota`;

-- --------------------------------------------------------------------
-- View structure for `migration_visit_flow_mfdb`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `migration_visit_flow_mfdb`;
CREATE ALGORITHM=UNDEFINED DEFINER=`mila`@`%` SQL SECURITY DEFINER VIEW `migration_visit_flow_mfdb` AS select `presences`.`user_id` AS `TA_NIP`,(`presences`.`in_date_time` + interval 7 hour) AS `TA_Date`,1 AS `TA_Verifikasi`,0 AS `TA_Status`,'Masuk' AS `TA_Keterangan`,(`presences`.`in_date_time` + interval 7 hour) AS `TA_CreatedDatetime`,`presences`.`in_longitude` AS `TA_Longitude`,`presences`.`in_latitude` AS `TA_Latitude`,'VISIT FLOW' AS `app_name`,`presences`.`user_id` AS `user_id`,`presences`.`dept` AS `dept` from `presences` where (`presences`.`dept` <> 'VNEU') union all select `presences`.`user_id` AS `TA_NIP`,(`presences`.`out_date_time` + interval 7 hour) AS `TA_Date`,1 AS `TA_Verifikasi`,1 AS `TA_Status`,'Pulang' AS `TA_Keterangan`,(`presences`.`out_date_time` + interval 7 hour) AS `TA_CreatedDatetime`,`presences`.`out_longitude` AS `TA_Longitude`,`presences`.`out_latitude` AS `TA_Latitude`,'VISIT FLOW' AS `app_name`,`presences`.`user_id` AS `user_id`,`presences`.`dept` AS `dept` from `presences` where (`presences`.`dept` <> 'VNEU') order by `TA_Date`;

-- --------------------------------------------------------------------
-- View structure for `vw_attendance_detail`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_attendance_detail`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_attendance_detail` AS select `rm`.`user_id` AS `user_id`,`rm`.`recognized_name` AS `recognized_name`,`rm`.`department` AS `department`,`rm`.`date` AS `date`,concat(`rm`.`shift_in`,'-',`rm`.`shift_out`) AS `work_hours`,date_format(`rm`.`checkin`,'%H') AS `checkin_hour`,date_format(`rm`.`checkin`,'%i') AS `checkin_minute`,date_format(`rm`.`checkout`,'%H') AS `checkout_hour`,date_format(`rm`.`checkout`,'%i') AS `checkout_minute`,floor((`rm`.`total_late_minutes` / 60)) AS `late_hours`,(`rm`.`total_late_minutes` % 60) AS `late_minutes`,floor((`rm`.`total_overtime_minutes` / 60)) AS `overtime_hours`,(`rm`.`total_overtime_minutes` % 60) AS `overtime_minutes`,floor((`rm`.`total_early_minutes` / 60)) AS `early_checkout_hours`,(`rm`.`total_early_minutes` % 60) AS `early_checkout_minutes`,floor((`rm`.`total_work_minutes_raw` / 60)) AS `total_work_hours`,(`rm`.`total_work_minutes_raw` % 60) AS `total_work_minutes`,`rm`.`note` AS `note`,(case when (`rm`.`late_start` = 1) then 1 else 0 end) AS `late_1_15`,(case when (`rm`.`late_start` = 16) then 1 else 0 end) AS `late_16_60`,(case when (`rm`.`late_start` = 61) then 1 else 0 end) AS `late_61_120`,(case when (`rm`.`late_start` = 121) then 1 else 0 end) AS `late_121_240`,(case when (`rm`.`total_late_minutes` = 0) then 0 when (`rm`.`grace_days` = 0) then ifnull(`rm`.`penalty_amount`,0) when ((`rm`.`grace_days` > 0) and (`rm`.`late_count` <= `rm`.`grace_days`)) then 0 when ((`rm`.`grace_days` > 0) and (`rm`.`late_count` = (`rm`.`grace_days` + 1))) then ifnull(`rm`.`penalty_amount`,0) else 0 end) AS `total_deduction` from (select `tc`.`user_id` AS `user_id`,`tc`.`recognized_name` AS `recognized_name`,`tc`.`department` AS `department`,`tc`.`date` AS `date`,`tc`.`period` AS `period`,`tc`.`shift_in` AS `shift_in`,`tc`.`shift_out` AS `shift_out`,`tc`.`checkin` AS `checkin`,`tc`.`checkout` AS `checkout`,`tc`.`note` AS `note`,`tc`.`total_late_minutes` AS `total_late_minutes`,`tc`.`total_overtime_minutes` AS `total_overtime_minutes`,`tc`.`total_early_minutes` AS `total_early_minutes`,`tc`.`total_work_minutes_raw` AS `total_work_minutes_raw`,`ad`.`id` AS `rule_id`,`ad`.`late_start` AS `late_start`,`ad`.`late_end` AS `late_end`,`ad`.`grace_days` AS `grace_days`,`ad`.`penalty_amount` AS `penalty_amount`,count(0) OVER (PARTITION BY `tc`.`user_id`,`tc`.`period`,`ad`.`id` ORDER BY `tc`.`date` )  AS `late_count` from ((select `b`.`user_id` AS `user_id`,`b`.`recognized_name` AS `recognized_name`,`b`.`department` AS `department`,`b`.`date` AS `date`,`b`.`period` AS `period`,`b`.`shift_in` AS `shift_in`,`b`.`shift_out` AS `shift_out`,(`b`.`in_date_time` + interval 7 hour) AS `checkin`,(`b`.`out_date_time` + interval 7 hour) AS `checkout`,`b`.`note` AS `note`,greatest(timestampdiff(MINUTE,str_to_date(concat(`b`.`date`,' ',`b`.`shift_in`),'%Y-%m-%d %H:%i'),(`b`.`in_date_time` + interval 7 hour)),0) AS `total_late_minutes`,greatest(timestampdiff(MINUTE,str_to_date(concat(`b`.`date`,' ',`b`.`shift_out`),'%Y-%m-%d %H:%i'),(`b`.`out_date_time` + interval 7 hour)),0) AS `total_overtime_minutes`,greatest(timestampdiff(MINUTE,(`b`.`out_date_time` + interval 7 hour),str_to_date(concat(`b`.`date`,' ',`b`.`shift_out`),'%Y-%m-%d %H:%i')),0) AS `total_early_minutes`,timestampdiff(MINUTE,(`b`.`in_date_time` + interval 7 hour),(`b`.`out_date_time` + interval 7 hour)) AS `total_work_minutes_raw` from (select `u`.`id` AS `user_id`,coalesce(max(`p`.`in_recognized_name`),`u`.`name`) AS `recognized_name`,coalesce(max(`p`.`dept`),`u`.`dept`) AS `department`,`c`.`date` AS `date`,date_format(`c`.`date`,'%Y%m') AS `period`,(case dayofweek(`c`.`date`) when 1 then max(`wh`.`day7_in`) when 2 then max(`wh`.`day1_in`) when 3 then max(`wh`.`day2_in`) when 4 then max(`wh`.`day3_in`) when 5 then max(`wh`.`day4_in`) when 6 then max(`wh`.`day5_in`) when 7 then max(`wh`.`day6_in`) end) AS `shift_in`,(case dayofweek(`c`.`date`) when 1 then max(`wh`.`day7_out`) when 2 then max(`wh`.`day1_out`) when 3 then max(`wh`.`day2_out`) when 4 then max(`wh`.`day3_out`) when 5 then max(`wh`.`day4_out`) when 6 then max(`wh`.`day5_out`) when 7 then max(`wh`.`day6_out`) end) AS `shift_out`,min(`p`.`in_date_time`) AS `in_date_time`,max(`p`.`out_date_time`) AS `out_date_time`,max(`l`.`note`) AS `note` from (((((`calendars` `c` join `users` `u` on(((`u`.`company_id` = `c`.`company_id`) and (`u`.`deleted_at` is null)))) left join `work_hour_users` `whu` on(((`whu`.`user_id` = `u`.`id`) and (`whu`.`work_hour_id` = (select max(`whu2`.`work_hour_id`) from (`work_hour_users` `whu2` join `work_hours` `wh2` on((`wh2`.`id` = `whu2`.`work_hour_id`))) where (`whu2`.`user_id` = `u`.`id`)))))) left join `work_hours` `wh` on((`wh`.`id` = `whu`.`work_hour_id`))) left join `presences` `p` on(((`p`.`user_id` = `u`.`id`) and (`p`.`deleted_at` is null) and (cast((`p`.`in_date_time` + interval 7 hour) as date) = `c`.`date`)))) left join `leaves` `l` on(((`l`.`user_id` = `u`.`id`) and (`l`.`status` = 'approved hrd') and (`c`.`date` between cast((`l`.`start_date` + interval 7 hour) as date) and cast((`l`.`end_date` + interval 7 hour) as date))))) where (`c`.`company_id` = 1) group by `u`.`id`,`u`.`name`,`u`.`dept`,`c`.`date`) `b`) `tc` left join `attendance_deductions` `ad` on(((`ad`.`company_id` = 1) and (`ad`.`period` = `tc`.`period`) and (`tc`.`total_late_minutes` between `ad`.`late_start` and `ad`.`late_end`))))) `rm`;

-- --------------------------------------------------------------------
-- View structure for `vw_check_bridging_product_sepecialis_not_spesialis`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_bridging_product_sepecialis_not_spesialis`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_bridging_product_sepecialis_not_spesialis` AS select `a`.`id` AS `id`,`b`.`customer_category_id` AS `customer_category_id`,`a`.`name` AS `name` from (`customer_categories` `a` left join (select distinct `bridging_product_specialists`.`customer_category_id` AS `customer_category_id` from `bridging_product_specialists`) `b` on((`a`.`id` = `b`.`customer_category_id`))) where (ifnull(`a`.`id`,'') <> ifnull(`b`.`customer_category_id`,''));

-- --------------------------------------------------------------------
-- View structure for `vw_check_sinkron_customer_ski_vf`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_sinkron_customer_ski_vf`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_customer_ski_vf` AS select `A`.`created_by_id` AS `created_by_id`,`A`.`created_at` AS `created_at`,`A`.`updated_by_id` AS `updated_by_id`,`A`.`updated_at` AS `updated_at`,`A`.`deleted_by_id` AS `deleted_by_id`,`A`.`deleted_at` AS `deleted_at`,`A`.`id` AS `id`,`A`.`name` AS `name`,`A`.`phone` AS `phone`,`A`.`email` AS `email`,`A`.`address` AS `address`,(case when (`A`.`gender` = 'Male') then 'male' when (`A`.`gender` = 'Female') then 'female' end) AS `gender`,'1' AS `company_id`,'' AS `customer_api`,'' AS `image_customer`,'' AS `image_ktp`,0 AS `ks`,'' AS `image_name_card`,'' AS `website`,'' AS `province`,'' AS `city`,'' AS `district`,'' AS `sub_district`,`A`.`id` AS `customer_id_by_company`,'approve' AS `status`,'SKI_VISITFLOW' AS `KET`,`A`.`customer_specialist_id` AS `customer_specialist_id`,`A`.`customer_position_id` AS `customer_position_id` from (`SKI_MF_PROD`.`customers` `A` left join `customers` `B` on((`A`.`id` = `B`.`id`))) where ((`B`.`id` is null) and (`A`.`deleted_at` is null));

-- --------------------------------------------------------------------
-- View structure for `vw_check_sinkron_customer_territory_outlet_ski_vf`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_sinkron_customer_territory_outlet_ski_vf`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_customer_territory_outlet_ski_vf` AS select `A`.`created_at` AS `created_at`,`A`.`updated_at` AS `updated_at`,`A`.`deleted_at` AS `deleted_at`,`A`.`created_by_id` AS `created_by_id`,`A`.`updated_by_id` AS `updated_by_id`,`A`.`deleted_by_id` AS `deleted_by_id`,`A`.`customer_id` AS `customer_id`,date_format(now(),'%Y%m') AS `start_period`,'999999' AS `end_period`,'' AS `best_hours`,'' AS `work_hours`,'approve' AS `status`,'' AS `reject_reason`,`A`.`outlet_id` AS `location_id`,'1' AS `company_id`,'' AS `user_name`,`C`.`name` AS `location_name`,`C`.`address` AS `location_address`,`D`.`name` AS `customer_name`,`D`.`phone` AS `customer_phone` from (((`SKI_MF_PROD`.`customer_territory_outlets` `A` left join `customer_locations` `B` on(((`A`.`customer_id` = `B`.`customer_id`) and (`A`.`outlet_id` = `B`.`location_id`) and (`B`.`deleted_at` is null) and (`A`.`period` between `B`.`start_period` and `B`.`end_period`)))) left join `SKI_MF_PROD`.`outlets` `C` on((`A`.`outlet_id` = `C`.`id`))) left join `SKI_MF_PROD`.`customers` `D` on((`A`.`customer_id` = `D`.`id`))) where ((`A`.`deleted_at` is null) and (`B`.`id` is null) and (`A`.`period` = date_format(now(),'%Y%m')));

-- --------------------------------------------------------------------
-- View structure for `vw_check_sinkron_marketing_structure_territory_outlet_ski_vf`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_sinkron_marketing_structure_territory_outlet_ski_vf`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_marketing_structure_territory_outlet_ski_vf` AS select `A`.`created_at` AS `created_at`,`A`.`updated_at` AS `updated_at`,`A`.`deleted_at` AS `deleted_at`,`A`.`created_by_id` AS `created_by_id`,`A`.`updated_by_id` AS `updated_by_id`,`A`.`deleted_by_id` AS `deleted_by_id`,`A`.`period` AS `period`,`A`.`outlet_id` AS `location_id`,`A`.`marketing_structure_id` AS `structure_id`,'1' AS `company_id`,0 AS `out_of_city` from (`SKI_MF_PROD`.`marketing_structure_territory_outlets` `A` left join `structure_locations` `B` on(((`A`.`outlet_id` = `B`.`location_id`) and (`A`.`period` = `B`.`period`) and (`A`.`marketing_structure_id` = `B`.`structure_id`) and (`B`.`deleted_at` is null)))) where ((`A`.`deleted_at` is null) and (`B`.`id` is null) and (`A`.`period` >= 202512));

-- --------------------------------------------------------------------
-- View structure for `vw_check_sinkron_outlets_ski_vf`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_sinkron_outlets_ski_vf`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_outlets_ski_vf` AS select `A`.`id` AS `id`,`A`.`created_at` AS `created_at`,`A`.`updated_at` AS `updated_at`,`A`.`deleted_at` AS `deleted_at`,`A`.`created_by_id` AS `created_by_id`,`A`.`updated_by_id` AS `updated_by_id`,`A`.`deleted_by_id` AS `deleted_by_id`,`A`.`name` AS `name`,`A`.`latitude` AS `latitude`,`A`.`longitude` AS `longitude`,`A`.`address` AS `address`,`A`.`id` AS `no_location_by_company`,'' AS `location_api`,`A`.`city_id` AS `area_id`,'1' AS `company_id`,'' AS `image`,'' AS `province`,'' AS `city`,'' AS `district`,'' AS `sub_district`,0 AS `location_group_id`,NULL AS `location_sub_id`,'' AS `area_name`,'approve' AS `status`,'' AS `location_tag`,`A`.`class` AS `class` from (`SKI_MF_PROD`.`outlets` `A` left join `locations` `B` on((`A`.`id` = `B`.`no_location_by_company`))) where ((`A`.`deleted_at` is null) and (`B`.`id` is null));

-- --------------------------------------------------------------------
-- View structure for `vw_check_users_visit_ski_name`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_users_visit_ski_name`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_users_visit_ski_name` AS select `A`.`id` AS `id_ski`,`A`.`name` AS `name_ski`,`B`.`name` AS `name_vf`,`B`.`user_name` AS `user_name` from (`SKI_MF_PROD`.`users` `A` left join `users` `B` on((`A`.`id` = `B`.`id`))) where ((`A`.`name` <> `B`.`name`) <> `B`.`user_name`);

-- --------------------------------------------------------------------
-- View structure for `vw_check_visit_customer_duplicate_gt_customer`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_visit_customer_duplicate_gt_customer`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_visit_customer_duplicate_gt_customer` AS select `visit_customers`.`period` AS `period`,`visit_customers`.`structure_id` AS `structure_id`,`visit_customers`.`customer_id` AS `customer_id`,count(0) AS `count(*)` from `visit_customers` where (`visit_customers`.`customer_id` <> 'NON') group by `visit_customers`.`period`,`visit_customers`.`structure_id`,`visit_customers`.`customer_id` having (count(0) > 1);

-- --------------------------------------------------------------------
-- View structure for `vw_check_visit_customer_user_id_not_structure`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_check_visit_customer_user_id_not_structure`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_visit_customer_user_id_not_structure` AS select distinct `A`.`period` AS `period`,`A`.`structure_id` AS `structure_id`,`A`.`user_id` AS `user_id`,`A`.`user_name` AS `user_name`,`B`.`user_id` AS `nip` from (`visit_customers` `A` left join `structures` `B` on(((`A`.`structure_id` = `B`.`id`) and (`A`.`period` = `B`.`period`) and (`B`.`deleted_at` is null)))) where (ifnull(`A`.`user_id`,'') <> ifnull(`B`.`user_id`,''));

-- --------------------------------------------------------------------
-- View structure for `vw_locations_province_city_no_mapping`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_locations_province_city_no_mapping`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_locations_province_city_no_mapping` AS select `locations`.`id` AS `id`,`locations`.`no_location_by_company` AS `no_location_by_company`,`locations`.`name` AS `name`,`locations`.`latitude` AS `latitude`,`locations`.`longitude` AS `longitude`,`locations`.`address` AS `address`,`locations`.`area_id` AS `area_id`,`locations`.`province` AS `province`,`locations`.`city` AS `city`,`locations`.`district` AS `district`,`locations`.`sub_district` AS `sub_district`,`locations`.`class` AS `class` from `locations` where ((`locations`.`deleted_at` is null) and ((ifnull(`locations`.`province`,'') = '') or (ifnull(`locations`.`city`,'') = '')) and (`locations`.`company_id` = 1) and (`locations`.`status` = 'approve') and (`locations`.`no_location_by_company` not in ('1','new')));

-- --------------------------------------------------------------------
-- View structure for `vw_presence_migration`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_presence_migration`;
CREATE ALGORITHM=UNDEFINED DEFINER=`mila`@`%` SQL SECURITY DEFINER VIEW `vw_presence_migration` AS select `presences`.`created_at` AS `created_at`,`presences`.`updated_at` AS `updated_at`,`presences`.`deleted_at` AS `deleted_at`,`presences`.`created_by_id` AS `created_by_id`,`presences`.`updated_by_id` AS `updated_by_id`,`presences`.`deleted_by_id` AS `deleted_by_id`,(case when (`presences`.`office_id` = 'T1') then 1 when (`presences`.`office_id` = 'T2') then 150003 when (`presences`.`office_id` = 'V2') then 60001 when (`presences`.`office_id` = 'OTCBKS') then 150004 when (`presences`.`office_id` = 'RPB') then 150007 when (`presences`.`office_id` = 'WFATGR') then 150005 when (`presences`.`office_id` = 'WFADPK') then 150006 else `presences`.`office_id` end) AS `office_id`,`presences`.`user_id` AS `user_id`,`presences`.`in_longitude` AS `in_longitude`,`presences`.`in_latitude` AS `in_latitude`,`presences`.`in_altitude` AS `in_altitude`,`presences`.`in_accuracy` AS `in_accuracy`,`presences`.`in_radius_from_office` AS `in_radius_from_office`,`presences`.`in_date_time` AS `in_date_time`,`presences`.`out_longitude` AS `out_longitude`,`presences`.`out_latitude` AS `out_latitude`,`presences`.`out_altitude` AS `out_altitude`,`presences`.`out_accuracy` AS `out_accuracy`,`presences`.`out_radius_from_office` AS `out_radius_from_office`,`presences`.`out_date_time` AS `out_date_time`,`presences`.`in_recognized_confidence` AS `in_recognized_confidence`,`presences`.`in_recognized_user_id` AS `in_recognized_user_id`,`presences`.`in_recognized_name` AS `in_recognized_name`,`presences`.`in_face_path` AS `in_face_path`,`presences`.`out_recognized_confidence` AS `out_recognized_confidence`,`presences`.`out_recognized_user_id` AS `out_recognized_user_id`,`presences`.`out_recognized_name` AS `out_recognized_name`,`presences`.`out_face_path` AS `out_face_path`,`presences`.`app_name` AS `app_name` from `presences`;

-- --------------------------------------------------------------------
-- View structure for `vw_presences_now`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_presences_now`;
CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_presences_now` AS select `calendars`.`date` AS `date`,dayname(`calendars`.`date`) AS `DAY`,`presences`.`user_id` AS `user_id`,`users`.`name` AS `user_name`,`offices`.`name` AS `office_name`,`offices`.`description` AS `office_description`,time_format((`presences`.`in_date_time` + interval 7 hour),'%H:%i') AS `time_in`,time_format((`presences`.`out_date_time` + interval 7 hour),'%H:%i') AS `time_out`,(case when (time_to_sec(time_format((`presences`.`in_date_time` + interval 7 hour),'%H:%i')) > time_to_sec('08:00')) then time_format(sec_to_time(greatest((time_to_sec(time_format((`presences`.`in_date_time` + interval 7 hour),'%H:%i')) - time_to_sec('08:00')),0)),'%H:%i') else '00:00' end) AS `late` from (((`calendars` left join `presences` on((cast(`presences`.`in_date_time` as date) = `calendars`.`date`))) left join `offices` on((`presences`.`office_id` = `offices`.`id`))) left join `users` on(((`users`.`id` = `presences`.`user_id`) and (`users`.`deleted_at` is null)))) where (date_format(`calendars`.`date`,'%Y%m') = date_format(now(),'%Y%m'));

-- --------------------------------------------------------------------
-- View structure for `vw_product_survey_test`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_product_survey_test`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_product_survey_test` AS select `t1`.`id` AS `id`,`t1`.`name` AS `name`,`t1`.`company_id` AS `company_id`,`t1`.`company_name` AS `company_name`,ifnull(`t4`.`material_id`,'999') AS `material_id`,ifnull(`t5`.`name`,'Others') AS `material_name`,ifnull(`t2`.`product_category_id`,'999') AS `product_category_id`,ifnull(`t3`.`name`,'Others') AS `product_category_name`,ifnull(`t3`.`tags`,'Others') AS `product_category_key`,ifnull(`t3`.`notes`,'Others') AS `product_category_note` from ((((`products_test` `t1` left join `product_product_category_test` `t2` on((`t2`.`product_id` = `t1`.`id`))) left join `product_categories_test` `t3` on((`t3`.`id` = `t2`.`product_category_id`))) left join `product_materials_test` `t4` on((`t4`.`product_id` = `t1`.`id`))) left join `materials_test` `t5` on((`t5`.`id` = `t4`.`material_id`)));

-- --------------------------------------------------------------------
-- View structure for `vw_products`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_products`;
CREATE ALGORITHM=UNDEFINED DEFINER=`vneu_umar`@`%` SQL SECURITY DEFINER VIEW `vw_products` AS select `t1`.`id` AS `id`,`t1`.`deleted_at` AS `deleted_at`,`t1`.`name` AS `name`,`t1`.`principal` AS `principal`,`t2`.`id` AS `product_category_id`,`t2`.`group_name` AS `product_category_group`,`t2`.`key` AS `product_category_key`,`t2`.`note` AS `product_category_note`,`t3`.`id` AS `material_id`,`t3`.`name` AS `material_name` from ((`products` `t1` left join `product_categories` `t2` on((`t2`.`id` = `t1`.`product_category_id`))) left join `product_materials` `t3` on((`t3`.`id` = `t1`.`product_material_id`)));

-- --------------------------------------------------------------------
-- View structure for `vw_survey`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_survey`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_survey` AS select `t1`.`id` AS `id_product`,`t1`.`name` AS `name_product`,`t2`.`id` AS `id_product_category`,`t2`.`group_name` AS `group_name`,`t2`.`key` AS `key_product`,`t2`.`note` AS `note`,`t3`.`id` AS `material_id`,`t3`.`name` AS `material_name` from ((`products` `t1` left join `product_categories` `t2` on((`t1`.`product_category_id` = `t2`.`id`))) left join `product_materials` `t3` on((`t1`.`product_material_id` = `t1`.`id`)));

-- --------------------------------------------------------------------
-- View structure for `vw_surveys`
-- --------------------------------------------------------------------
DROP VIEW IF EXISTS `vw_surveys`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_surveys` AS select `t1`.`id` AS `id_product`,`t1`.`name` AS `name_product`,`t2`.`id` AS `id_product_category`,`t2`.`group_name` AS `group_name`,`t2`.`key` AS `key_product`,`t2`.`note` AS `note`,`t3`.`id` AS `material_id`,`t3`.`name` AS `material_name` from ((`products` `t1` left join `product_categories` `t2` on((`t1`.`product_category_id` = `t2`.`id`))) left join `product_materials` `t3` on((`t1`.`product_material_id` = `t1`.`id`)));

-- ====================================================================
-- SECTION 3: STORED PROCEDURES & FUNCTIONS
-- ====================================================================

-- --------------------------------------------------------------------
-- Routine structure for `sp_incentive_recommendations` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_incentive_recommendations`;
DELIMITER ;;
-- Error fetching routine `sp_incentive_recommendations`: unsupported operand type(s) for +: 'NoneType' and 'str'
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_late_user_deduction` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_late_user_deduction`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_late_user_deduction`(
    IN PeriodProses VARCHAR(20),
    IN userId       VARCHAR(20),
    IN limitData    INT(20),
    IN pageData     INT(20)
)
BEGIN

    DECLARE offsetData INT;
    SET offsetData = (pageData - 1) * limitData;

    -- =========================================================
    -- CTE BASE: ambil users, calendars, jam kerja, presensi
    -- work_hours dipilih berdasarkan start_date <= c.date <= end_date
    -- Jika ada lebih dari satu work_hour yang overlap pada tanggal
    -- yang sama, diambil yang MAX(wh.id) sebagai tie-breaker.
    -- =========================================================
    WITH base AS (
        SELECT
            u.id                            AS user_id,
            u.name                          AS recognized_name,
            u.dept,
            c.date,
            c.description,
            DATE_FORMAT(c.date, '%Y%m')     AS period,

            wh.day1_in,  wh.day1_out,
            wh.day2_in,  wh.day2_out,
            wh.day3_in,  wh.day3_out,
            wh.day4_in,  wh.day4_out,
            wh.day5_in,  wh.day5_out,
            wh.day6_in,  wh.day6_out,
            wh.day7_in,  wh.day7_out,

            MIN(p.in_date_time)             AS in_date_time,
            MAX(p.out_date_time)            AS out_date_time

        FROM VISITFLOW_MF_PROD.calendars c
        JOIN VISITFLOW_MF_PROD.users u
            ON u.company_id = c.company_id

        LEFT JOIN VISITFLOW_MF_PROD.presences p
            ON  p.user_id = u.id
            AND DATE(p.in_date_time + INTERVAL 7 HOUR) = c.date
            AND p.deleted_at IS NULL

        -- -------------------------------------------------------
        -- Ambil work_hour yang berlaku pada c.date:
        --   1. Cari work_hours milik user tsb via work_hour_users
        --   2. Filter: DATE(start_date) <= c.date <= DATE(end_date)
        --   3. Jika lebih dari satu overlap, ambil MAX(wh.id)
        -- -------------------------------------------------------
        LEFT JOIN VISITFLOW_MF_PROD.work_hour_users whu
            ON whu.user_id = u.id
            AND whu.work_hour_id = (
                SELECT wh2.id
                FROM VISITFLOW_MF_PROD.work_hours wh2
                INNER JOIN VISITFLOW_MF_PROD.work_hour_users whu2
                    ON  whu2.work_hour_id = wh2.id
                    AND whu2.user_id      = u.id
                WHERE DATE(wh2.start_date) <= c.date
                  AND DATE(wh2.end_date)   >= c.date
                  AND wh2.company_id        = 1
                ORDER BY wh2.id DESC
                LIMIT 1
            )

        LEFT JOIN VISITFLOW_MF_PROD.work_hours wh
            ON wh.id = whu.work_hour_id

        WHERE
            c.company_id = 1
            AND DATE_FORMAT(c.date, '%Y-%m') = DATE_FORMAT(PeriodProses, '%Y-%m')
            AND (userId IS NULL OR u.id = userId)

        GROUP BY
            u.id, c.date, c.description,
            wh.day1_in,  wh.day1_out,
            wh.day2_in,  wh.day2_out,
            wh.day3_in,  wh.day3_out,
            wh.day4_in,  wh.day4_out,
            wh.day5_in,  wh.day5_out,
            wh.day6_in,  wh.day6_out,
            wh.day7_in,  wh.day7_out
    ),

    -- =========================================================
    -- CTE SHIFT_CALC: tentukan shift_in / shift_out sesuai hari
    -- =========================================================
    shift_calc AS (
        SELECT
            b.*,
            CASE DAYOFWEEK(b.date)
                WHEN 1 THEN b.day7_in
                WHEN 2 THEN b.day1_in
                WHEN 3 THEN b.day2_in
                WHEN 4 THEN b.day3_in
                WHEN 5 THEN b.day4_in
                WHEN 6 THEN b.day5_in
                WHEN 7 THEN b.day6_in
            END AS work_hour_in,
            CASE DAYOFWEEK(b.date)
                WHEN 1 THEN b.day7_out
                WHEN 2 THEN b.day1_out
                WHEN 3 THEN b.day2_out
                WHEN 4 THEN b.day3_out
                WHEN 5 THEN b.day4_out
                WHEN 6 THEN b.day5_out
                WHEN 7 THEN b.day6_out
            END AS work_hour_out
        FROM base b
    ),

    -- =========================================================
    -- CTE TIME_CALC: hitung late_minutes, format waktu, nama hari
    -- =========================================================
    time_calc AS (
        SELECT
            s.*,
            (s.in_date_time  + INTERVAL 7 HOUR) AS presence_check_in,
            (s.out_date_time + INTERVAL 7 HOUR) AS presence_check_out,
            CASE DAYOFWEEK(s.date)
                WHEN 1 THEN 'Minggu'
                WHEN 2 THEN 'Senin'
                WHEN 3 THEN 'Selasa'
                WHEN 4 THEN 'Rabu'
                WHEN 5 THEN 'Kamis'
                WHEN 6 THEN 'Jumat'
                WHEN 7 THEN 'Sabtu'
            END AS day_name,
            GREATEST(
                TIMESTAMPDIFF(
                    MINUTE,
                    STR_TO_DATE(CONCAT(s.date, ' ', s.work_hour_in), '%Y-%m-%d %H:%i'),
                    (s.in_date_time + INTERVAL 7 HOUR)
                ),
                0
            ) AS late_minutes
        FROM shift_calc s
    ),

    -- =========================================================
    -- CTE RULE_MATCH: hitung penalty dengan grace_days
    -- =========================================================
    rule_match AS (
        SELECT
            t.*,
            ad.penalty_amount,
            ad.grace_days,
            COUNT(*) OVER (
                PARTITION BY t.user_id, t.period, ad.id
                ORDER BY t.date
            ) AS late_count
        FROM time_calc t
        LEFT JOIN VISITFLOW_MF_PROD.attendance_deductions ad
            ON  ad.company_id = 1
            AND ad.period     = t.period
            AND t.late_minutes BETWEEN ad.late_start AND ad.late_end
    )

    -- =========================================================
    -- SELECT FINAL
    -- =========================================================
    SELECT
        r.day_name,
        r.date,
        DATE_FORMAT(r.presence_check_in,  '%Y-%m-%d %H:%i:%s') AS presence_check_in,
        DATE_FORMAT(r.presence_check_out, '%Y-%m-%d %H:%i:%s') AS presence_check_out,
        r.work_hour_in,
        r.work_hour_out,
        r.late_minutes,
        CASE
            WHEN r.work_hour_in IS NULL
              OR r.description <> 'Hari Kerja Biasa' THEN 'Libur'
            WHEN r.presence_check_in IS NULL          THEN 'Absen Kosong'
            WHEN r.late_minutes > 0                   THEN 'Telat'
            ELSE 'Tepat Waktu'
        END AS status,
        CASE
            WHEN r.late_minutes = 0                                              THEN 0
            -- grace_days = 0 : langsung kena setiap telat
            WHEN r.grace_days = 0                                                THEN IFNULL(r.penalty_amount, 0)
            -- grace_days > 0 : masih dalam toleransi
            WHEN r.grace_days > 0 AND r.late_count <= r.grace_days              THEN 0
            -- grace_days > 0 : tepat di pelanggaran ke-(grace+1), kena SEKALI
            WHEN r.grace_days > 0 AND r.late_count = r.grace_days + 1           THEN IFNULL(r.penalty_amount, 0)
            -- grace_days > 0 : setelah pelanggaran ke-(grace+1), tidak kena lagi
            ELSE 0
        END AS penalty_amount
    FROM rule_match r
    ORDER BY r.user_id, r.date
    LIMIT limitData OFFSET offsetData;

END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_late_user_deduction_summary` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_late_user_deduction_summary`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_late_user_deduction_summary`(
    IN PeriodProses VARCHAR(20),
    IN PeriodStart  VARCHAR(20),
    IN PeriodEnd    VARCHAR(20),
    IN userId       VARCHAR(100),
    IN deptUser     VARCHAR(100),
    IN is_having    VARCHAR(20),
    IN limitData    INT,
    IN pageData     INT
)
BEGIN

    IF userId = 'NULL' OR userId = '' THEN SET userId = NULL; END IF;
    IF deptUser = 'NULL' OR deptUser = '' THEN SET deptUser = NULL; END IF;
    IF PeriodStart = 'NULL' OR PeriodStart = '' THEN
        SET PeriodStart = DATE_FORMAT(PeriodProses, '%Y-%m-01');
    END IF;
    IF PeriodEnd = 'NULL' OR PeriodEnd = '' THEN
        SET PeriodEnd = LAST_DAY(PeriodProses);
    END IF;
    IF limitData = 0 THEN SET limitData = 10; END IF;
IF pageData <= 1 THEN 
    SET pageData = 0;
ELSE 
    SET pageData = limitData * (pageData - 1);  -- ✅ BENAR
END IF;

    WITH RECURSIVE dates AS (
        SELECT DATE(PeriodStart) AS tanggal
        UNION ALL
        SELECT tanggal + INTERVAL 1 DAY
        FROM dates WHERE tanggal < DATE(PeriodEnd)
    ),

    -- =========================================================
    -- STEP 1: Ambil user dulu dengan LIMIT + OFFSET
    -- Query berat di bawah hanya jalan untuk N user ini
    -- =========================================================
    paged_users AS (
        SELECT id, name, dept, company_id
        FROM VISITFLOW_MF_PROD.users
        WHERE deleted_at IS NULL
          AND (id   = userId   OR userId   IS NULL)
          AND (dept = deptUser OR deptUser IS NULL)
        ORDER BY id
        LIMIT limitData OFFSET pageData
    ),

    presences_daily AS (
        SELECT
            p.user_id,
            DATE(DATE_ADD(p.in_date_time, INTERVAL 7 HOUR)) AS tanggal,
            MIN(p.in_date_time) AS in_date_time
        FROM VISITFLOW_MF_PROD.presences p
        -- Hanya ambil presences untuk user yang ada di paged_users
        WHERE p.deleted_at IS NULL
          AND p.user_id IN (SELECT id FROM paged_users)
          AND p.in_date_time >= DATE_SUB(DATE(PeriodStart), INTERVAL 7 HOUR)
          AND p.in_date_time <  DATE_ADD(DATE(PeriodEnd), INTERVAL 17 HOUR)
        GROUP BY p.user_id,
                 DATE(DATE_ADD(p.in_date_time, INTERVAL 7 HOUR))
    ),

    -- Work hour: resolve sekali per user, hanya 3 record
    user_workhour AS (
        SELECT
            whu.user_id,
            wh.id AS wh_id,
            wh.day1_in, wh.day2_in, wh.day3_in, wh.day4_in,
            wh.day5_in, wh.day6_in, wh.day7_in
        FROM VISITFLOW_MF_PROD.work_hour_users whu
        JOIN VISITFLOW_MF_PROD.work_hours wh
            ON  wh.id         = whu.work_hour_id
            AND wh.start_date <= DATE(PeriodEnd)
            AND wh.end_date   >= DATE(PeriodStart)
        WHERE whu.user_id IN (SELECT id FROM paged_users)
          AND whu.work_hour_id = (
              SELECT MAX(whu2.work_hour_id)
              FROM VISITFLOW_MF_PROD.work_hour_users whu2
              JOIN VISITFLOW_MF_PROD.work_hours wh2
                  ON  wh2.id         = whu2.work_hour_id
                  AND wh2.start_date <= DATE(PeriodEnd)
                  AND wh2.end_date   >= DATE(PeriodStart)
              WHERE whu2.user_id = whu.user_id
          )
    ),

    attendance AS (
        SELECT
            u.id   AS user_id,
            u.name,
            u.dept,
            d.tanggal,
            DATE_FORMAT(d.tanggal, '%Y%m') AS period,
            cal.description                AS cal_description,
            pd.in_date_time                AS raw_in,
            DATE_ADD(pd.in_date_time, INTERVAL 7 HOUR) AS check_in,

            CASE DAYOFWEEK(d.tanggal)
                WHEN 1 THEN uw.day7_in WHEN 2 THEN uw.day1_in
                WHEN 3 THEN uw.day2_in WHEN 4 THEN uw.day3_in
                WHEN 5 THEN uw.day4_in WHEN 6 THEN uw.day5_in
                WHEN 7 THEN uw.day6_in
            END AS work_hour_in,

            CASE
                WHEN d.tanggal > CURDATE()                    THEN 0
                WHEN l.id IS NOT NULL                         THEN 0
                WHEN cal.description IS NULL
                  OR cal.description <> 'Hari Kerja Biasa'    THEN 0
                WHEN uw.wh_id IS NULL                         THEN 0
                WHEN CASE DAYOFWEEK(d.tanggal)
                        WHEN 1 THEN uw.day7_in WHEN 2 THEN uw.day1_in
                        WHEN 3 THEN uw.day2_in WHEN 4 THEN uw.day3_in
                        WHEN 5 THEN uw.day4_in WHEN 6 THEN uw.day5_in
                        WHEN 7 THEN uw.day6_in
                     END IS NULL
                  OR CASE DAYOFWEEK(d.tanggal)
                        WHEN 1 THEN uw.day7_in WHEN 2 THEN uw.day1_in
                        WHEN 3 THEN uw.day2_in WHEN 4 THEN uw.day3_in
                        WHEN 5 THEN uw.day4_in WHEN 6 THEN uw.day5_in
                        WHEN 7 THEN uw.day6_in
                     END = ''                                 THEN 0
                WHEN pd.in_date_time IS NULL                  THEN 0
                ELSE GREATEST(
                    TIMESTAMPDIFF(
                        MINUTE,
                        CONCAT(d.tanggal, ' ',
                            CASE DAYOFWEEK(d.tanggal)
                                WHEN 1 THEN uw.day7_in WHEN 2 THEN uw.day1_in
                                WHEN 3 THEN uw.day2_in WHEN 4 THEN uw.day3_in
                                WHEN 5 THEN uw.day4_in WHEN 6 THEN uw.day5_in
                                WHEN 7 THEN uw.day6_in
                            END
                        ),
                        DATE_ADD(pd.in_date_time, INTERVAL 7 HOUR)
                    ), 0
                )
            END AS late_minutes

        FROM dates d

        -- Hanya join ke paged_users, bukan seluruh tabel users
        JOIN paged_users u ON 1=1

        LEFT JOIN VISITFLOW_MF_PROD.calendars cal
            ON  cal.company_id = u.company_id
            AND cal.date       = d.tanggal

        LEFT JOIN user_workhour uw
            ON  uw.user_id = u.id

        LEFT JOIN presences_daily pd
            ON  pd.user_id = u.id
            AND pd.tanggal = d.tanggal

        LEFT JOIN VISITFLOW_MF_PROD.leaves l
            ON  l.user_id = u.id
            AND l.status  = 'approved hrd'
            AND d.tanggal BETWEEN
                DATE(DATE_ADD(l.start_date, INTERVAL 7 HOUR))
                AND DATE(DATE_ADD(l.end_date, INTERVAL 7 HOUR))
    ),

    -- Window function hanya jalan di baris telat saja
    late_only AS (
        SELECT * FROM attendance WHERE late_minutes > 0
    ),

    attendance_rule AS (
        SELECT
            lo.*,
            ad.id             AS rule_id,
            ad.grace_days,
            ad.penalty_amount,
            COUNT(*) OVER (
                PARTITION BY lo.user_id, lo.period, ad.id
                ORDER BY lo.tanggal
            ) AS late_count
        FROM late_only lo
        JOIN VISITFLOW_MF_PROD.attendance_deductions ad
            ON  ad.period       = lo.period
            AND lo.late_minutes BETWEEN ad.late_start AND ad.late_end
    ),

    deduction_summary AS (
        SELECT
            ar.user_id,
            SUM(
                CASE
                    WHEN ar.grace_days = 0
                        THEN IFNULL(ar.penalty_amount, 0)
                    WHEN ar.grace_days > 0
                     AND ar.late_count <= ar.grace_days
                        THEN 0
                    WHEN ar.grace_days > 0
                     AND ar.late_count = ar.grace_days + 1
                        THEN IFNULL(ar.penalty_amount, 0)
                    ELSE 0
                END
            ) AS total_deduction
        FROM attendance_rule ar
        GROUP BY ar.user_id
    )

    -- =========================================================
    -- SELECT FINAL: dari paged_users → semua 10 user muncul
    -- LEFT JOIN deduction → user tanpa telat tetap muncul (0)
    -- Tidak perlu LIMIT/OFFSET lagi karena sudah di paged_users
    -- =========================================================
    SELECT
        u.id                          AS user_id,
        u.name                        AS recognized_name,
        u.dept                        AS department,
        IFNULL(ds.total_deduction, 0) AS total_deduction
    FROM paged_users u
    LEFT JOIN deduction_summary ds ON ds.user_id = u.id

    HAVING (is_having IS NULL OR is_having = '' OR total_deduction > 0)

    ORDER BY u.id;

END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_call_detail` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_call_detail`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_call_detail`(IN PeriodProcess varchar(6))
BEGIN

# SELECT
#     TABLE_NAME,
#     COLUMN_NAME,
#     CHARACTER_SET_NAME,
#     COLLATION_NAME,
#     DATA_TYPE
# FROM information_schema.COLUMNS
# WHERE TABLE_SCHEMA = 'VISITFLOW_MF_PROD'
#   AND TABLE_NAME IN ('visits', 'visit_members', 'visit_customers','customers','customer_customer_categories','customer_categories')
#   AND COLUMN_NAME IN ('customer_id', 'period', 'structure_id','deleted_at','status');


# COLLATE utf8mb4_0900_ai_ci
# COLLATE utf8mb4_bin
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.call_flag_jv;
# DELETE FROM VISITFLOW_MFTEMP_PROD.call_flag_jv WHERE period = '202609;
# DELETE FROM VISITFLOW_MFTEMP_PROD.call_flag_jv WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.call_flag_jv
CREATE TABLE VISITFLOW_MFTEMP_PROD.call_flag_jv
SELECT visit_id, COUNT(visit_id) AS flag_jv
FROM VISITFLOW_MF_PROD.visit_members
WHERE period = PeriodProcess
  AND deleted_at IS NULL
GROUP BY visit_id;

# COLLATE utf8mb4_0900_ai_ci
# COLLATE utf8mb4_bin
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.call_flag_area;
# DELETE FROM VISITFLOW_MFTEMP_PROD.call_flag_area WHERE period = '202609;
# DELETE FROM VISITFLOW_MFTEMP_PROD.call_flag_area WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.call_flag_area
CREATE TABLE VISITFLOW_MFTEMP_PROD.call_flag_area
SELECT DISTINCT lv6_code, lv4_code AS area, lv6_marketing_position_id AS position
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProcess
UNION ALL
SELECT DISTINCT lv5_code, lv4_code AS area, lv5_marketing_position_id AS position
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProcess
UNION ALL
SELECT DISTINCT lv4_code, lv4_code AS area, lv4_marketing_position_id AS position
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProcess
UNION ALL
SELECT DISTINCT lv3_code, '' AS area, lv3_marketing_position_id AS position
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProcess
UNION ALL
SELECT DISTINCT lv2_code, '' AS area, lv2_marketing_position_id AS position
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProcess
UNION ALL
SELECT DISTINCT lv1_code, '' AS area, lv1_marketing_position_id AS position
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProcess;
# COLLATE utf8mb4_0900_ai_ci
# COLLATE utf8mb4_bin
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.call_flag_customers;
# DELETE FROM VISITFLOW_MFTEMP_PROD.call_flag_customers WHERE period = '202609;
# DELETE FROM VISITFLOW_MFTEMP_PROD.call_flag_customers WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.call_flag_customers
CREATE TABLE VISITFLOW_MFTEMP_PROD.call_flag_customers
SELECT customers.id, customers.name,
     CONCAT('[',GROUP_CONCAT(DISTINCT CONCAT('"', customer_categories.name, '"')ORDER BY customer_categories.name SEPARATOR ','),']') AS spc
FROM VISITFLOW_MF_PROD.visits
JOIN VISITFLOW_MF_PROD.customers ON visits.customer_id = customers.id AND customers.deleted_at IS NULL
  AND customers.company_id = 1 AND customers.status ='approve'
LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories ON customer_customer_categories.customer_id = customers.id
     AND customer_customer_categories.deleted_at IS NULL
LEFT JOIN VISITFLOW_MF_PROD.customer_categories ON customer_customer_categories.customer_category_id = customer_categories.id
WHERE visits.period = PeriodProcess
GROUP BY customers.id, customers.name;

# COLLATE utf8mb4_0900_ai_ci
# COLLATE utf8mb4_bin
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl;
# DELETE FROM VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl WHERE period = '202609;
# DELETE FROM VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl
CREATE TABLE VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl
SELECT
    -- visits
    visits.id                    AS vs_id,
    visits.status                AS vs_status,
    visits.type                  AS vs_type,
    visits.title                 AS vs_title,
    visits.structure_id          AS vs_structure_id,
    visits.period                AS vs_period,
    visits.customer_category     AS vs_customer_category,
    visits.customer_id           AS vs_customer_id,
    visits.type_visit            AS vs_type_visit,
    visits.checkin_time          AS vs_checkin_time,
    visits.checkout_time         AS vs_checkout_time,
    visits.schedule_datetime     AS vs_schedule_datetime,
    visits.schedule_end          AS vs_schedule_end,
    visits.check_in_radius       AS vs_check_in_radius,
    visits.location_id           AS vs_location_id,
    visits.check_out_radius      AS vs_check_out_radius,
    visits.approved_structure_id AS vs_approved_structure_id,
    visits.approved_time         AS vs_approved_time,
    visits.approved_note         AS vs_approved_note,
    visits.closed_structure_id   AS vs_closed_structure_id,
    visits.closed_time           AS vs_closed_time,
    visits.proof_photo           AS vs_proof_photo,
    visits.proof_signature       AS vs_proof_signature,
    visits.note                  AS vs_note,
    visits.company_id            AS vs_company_id,
    visits.checkin_latitude      AS vs_checkin_latitude,
    visits.checkout_latitude     AS vs_checkout_latitude,
    visits.checkin_longitude     AS vs_checkin_longitude,
    visits.checkout_longitude    AS vs_checkout_longitude,
    visits.location_latitude     AS vs_location_latitude,
    visits.location_longitude    AS vs_location_longitude,
    visits.customer_name         AS vs_customer_name,
    visits.customer_phone        AS vs_customer_phone,
    visits.location_name         AS vs_location_name,
    visits.user_name             AS vs_user_name,
    visits.location_address      AS vs_location_address,
    visits.accuracy              AS vs_accuracy,
    visits.is_survey             AS vs_is_survey,
    visits.is_mandatory          AS vs_is_mandatory,
    visits.out_of_city           AS vs_out_of_city,
    -- visit_members
    visit_members.id                     AS vm_id,
    visit_members.structure_id           AS vm_structure_id,
    visit_members.user_id                AS vm_user_id,
    visit_members.visit_id               AS vm_visit_id,
    visit_members.period                 AS vm_period,
    visit_members.company                AS vm_company,
    visit_members.company_id             AS vm_company_id,
    visit_members.check_in_latitude      AS vm_check_in_latitude,
    visit_members.check_in_longitude     AS vm_check_in_longitude,
    visit_members.checkin_time           AS vm_checkin_time,
    visit_members.check_out_latitude     AS vm_check_out_latitude,
    visit_members.check_out_longitude    AS vm_check_out_longitude,
    visit_members.checkout_time          AS vm_checkout_time,

    -- visit_customers
    visit_customers.id                    AS vc_id,
    visit_customers.period                AS vc_period,
    visit_customers.customer_name         AS vc_customer_name,
    visit_customers.customer_phone        AS vc_customer_phone,
    visit_customers.priority              AS vc_priority,
    visit_customers.type                  AS vc_type,
    visit_customers.status                AS vc_status,
    visit_customers.level                 AS vc_level,
    visit_customers.approved_structure_id AS vc_approved_structure_id,
    visit_customers.approved_time         AS vc_approved_time,
    visit_customers.structure_id          AS vc_structure_id,
    visit_customers.out_of_city           AS vc_out_of_city,
    visit_customers.user_id               AS vc_user_id,
    visit_customers.user_name             AS vc_user_name,
    visit_customers.customer_id           AS vc_customer_id,
    visit_customers.location_id           AS vc_location_id,
    visit_customers.company_id            AS vc_company_id,
    visit_customers.rejected_structure_id AS vc_rejected_structure_id,
    visit_customers.note                  AS vc_note,
    visit_customers.rejected_time         AS vc_rejected_time,
    visit_customers.cluster               AS vc_cluster,
    visit_customers.amortization          AS vc_amortization
FROM visits
JOIN visit_members ON visits.id = visit_members.visit_id AND visit_members.deleted_at IS NULL
LEFT JOIN visit_customers ON visits.customer_id = visit_customers.customer_id COLLATE utf8mb4_0900_ai_ci
               AND visits.period = visit_customers.period COLLATE utf8mb4_0900_ai_ci
               AND visit_members.structure_id = visit_customers.structure_id COLLATE utf8mb4_0900_ai_ci
               AND visit_customers.deleted_at IS NULL
               AND visit_customers.status = 'approved'
               AND visit_customers.period = PeriodProcess COLLATE utf8mb4_0900_ai_ci
WHERE visits.period= PeriodProcess
  AND visits.deleted_at IS NULL
  AND visits.company_id = 1 ;

# DROP TABLE IF EXISTS VISITFLOW_MF_PROD.call_details;
DELETE FROM VISITFLOW_MF_PROD.call_details WHERE period = PeriodProcess;
# DELETE FROM VISITFLOW_MF_PROD.call_details WHERE period = '202609;
# SELECT * FROM VISITFLOW_MF_PROD.call_details
# CREATE TABLE VISITFLOW_MF_PROD.call_details
# CREATE TABLE VISITFLOW_MF_PROD.call_details
# (
#     period                 varchar(30) DEFAULT '' NOT NULL,
#     user_id                varchar(30) DEFAULT '' NOT NULL,
#     user_name              varchar(200) DEFAULT '' NOT NULL,
#     structure_id           varchar(30) DEFAULT '' NOT NULL,
#     position               varchar(7)  DEFAULT '' NOT NULL,
#     area                   varchar(7)  DEFAULT '' NULL,
#     customer_id            varchar(20) DEFAULT '' NOT NULL,
#     out_of_city            varchar(2) DEFAULT ''  NULL,
#     type_mcl               varchar(11) DEFAULT '' NULL,
#     type_call              varchar(30) DEFAULT '' NULL,
#     status                 varchar(30) DEFAULT '' NULL,
#     spc                    longtext NULL,
#     customer_name          varchar(500) DEFAULT '' NULL,
#     schedule_datetime      datetime NULL,
#     checkin_time           datetime NULL,
#     checkout_time          datetime NULL,
#     morning                int  DEFAULT 0 NULL,
#     evening                int  DEFAULT 0 NULL,
#     durasi_on              time  NULL,
#     visit_id
#     join_visit             varchar(2) DEFAULT '' NULL,
#     product_id             varchar(30) DEFAULT '' NULL,
#     product_name           varchar(100) DEFAULT '' NULL,
#     note_detailing_product varchar(500) DEFAULT '' NULL,
#     location_id            varchar(20) DEFAULT '' NULL,
#     location_name          varchar(500) DEFAULT '' NULL,
#     location_address       longtext NULL,
#     location_latitude      double NULL,
#     location_longitude     double NULL,
#     check_in_latitude      double NULL,
#     check_out_latitude     double NULL,
#     check_in_longitude     double NULL,
#     check_out_longitude    double NULL,
#     check_in_radius        double NULL,
#     check_out_radius       double NULL,
#     approved_structure_id  varchar(30) DEFAULT '' NULL,
#     approved_time          datetime NULL,
#     approved_note          varchar(500) DEFAULT '' NULL,
#     proof_photo            varchar(200) DEFAULT '' NULL,
#     proof_signature        varchar(200) DEFAULT '' NULL,
#     note_visit             varchar(500) DEFAULT '' NULL,
# #    primary key (period, structure_id, customer_id, location_id, product_id, schedule_datetime),
#    index idx_call_detail_period (period),
#    index idx_call_detail_structure_id (structure_id),
#    index idx_call_detail_customer_id (customer_id),
#    index idx_call_detail_location_id (location_id),
#    index idx_call_detail_period_structure_id (period, structure_id),
#    index idx_call_detail_period_location_name (period, location_name),
#    index idx_call_detail_period_customer_name (period, customer_name),
#    index idx_call_detail_period_customer_id (period, customer_id),
#    index idx_call_detail_period_type_call (period,type_call)
# );
# SELECT *
# FROM visits
# WHERE visits.period='202507' AND visits.structure_id ='BKSA1' AND visits.customer_id ='BEK18-0013' AND visits.location_id ='BEK160784'
# SELECT * FROM visit_members WHERE visit_id IN ('1167390','1167396')
# SELECT * FROM visit_products WHERE visit_id IN ('1167390','1167396')
-- CEK CALL 1 CUSTOMER DALAM 1 HARI > 1
# SELECT COUNT(*),period, structure_id, customer_id, location_id, schedule_datetime
# FROM visits
# GROUP BY period, structure_id, customer_id, location_id, schedule_datetime
# HAVING COUNT(*) > 1

# -- cek mcl/mcl bawahan,jv :
# --  jika customer kosong tapi gt mr = mcl lain
# --  jika customer kosong tapi gt > mr = mcl bawahan
# --  jika customer tidak kosong = mcl
# --  jika struktur visit tidak sama dengan struktur visit member berarti jv, tapi diri sendiri belum ke jv perlu tambahan query visit id > dari 1
#  SELECT A.id,A.structure_id, A.customer_id, B.structure_id , C.customer_id
#  FROM visits A
#  JOIN visit_members B ON A.id = B.visit_id AND B.deleted_at IS NULL
#  LEFT JOIN visit_customers C ON B.structure_id = C.structure_id AND A.customer_id = C.customer_id AND A.period = C.period
#  WHERE A.period ='202508'
#     AND IFNULL(A.structure_id,'') <> IFNULL(B.structure_id,'')
# -- query id visit >1
# CREATE TABLE VISITFLOW_MFTEMP_PROD.call_flag_jv
# SELECT visit_id, COUNT(visit_id) AS flag_jv
# FROM visit_members
# WHERE period = '202609
#   AND deleted_at IS NULL
# GROUP BY visit_id;
# -- cek detail
# SELECT * FROM visits WHERE ID IN (1163262)
# SELECT * FROM visits WHERE period ='202507' AND structure_id IN ('TGRA2S101'  )  AND customer_id ='TGR22-0021'
# SELECT * FROM visit_members WHERE period ='202507' AND visit_id IN ('1163262')
# SELECT * FROM visit_customers WHERE period ='202507'  AND customer_id ='24090126' and structure_id in ('TGRA2S202','TGRA1')
# SELECT * FROM VISITFLOW_MF_PROD.call_details WHERE visit_id IN ('1163262','1163314')


# COLLATE utf8mb4_0900_ai_ci
# COLLATE utf8mb4_bin
# PeriodProcess
-- ============================================================
-- 2. TAMBAHKAN INDEX PADA TEMPORARY TABLES (KUNCI UTAMA!)
-- ============================================================
ALTER TABLE VISITFLOW_MFTEMP_PROD.call_flag_jv ADD PRIMARY KEY (visit_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.call_flag_customers ADD PRIMARY KEY (id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.call_flag_area ADD INDEX idx_lv6 (lv6_code);
ALTER TABLE VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl
    ADD INDEX idx_vs_id (vs_id),
    ADD INDEX idx_cust_id (vs_customer_id),
    ADD INDEX idx_vm_structure (vm_structure_id);

SET autocommit = 0;
SET unique_checks = 0;
SET foreign_key_checks = 0;
-- 2. Jalankan INSERT
INSERT INTO VISITFLOW_MF_PROD.call_details
(period, user_id, user_name, structure_id, position, area, customer_id, out_of_city, type_mcl, type_call, status, spc, customer_name,
 schedule_datetime, checkin_time, checkout_time, morning, evening, durasi_on, visit_id, join_visit, product_id, product_name,
 note_detailing_product, location_id, location_name, location_address, location_latitude, location_longitude, check_in_latitude,
 check_out_latitude, check_in_longitude, check_out_longitude, check_in_radius, check_out_radius, approved_structure_id, approved_time,
 approved_note, proof_photo, proof_signature, note_visit,cluster,priority,amortization)

SELECT visits.vs_period, CASE WHEN visits.vm_user_id IS NULL THEN visits.vm_structure_id ELSE visits.vm_user_id END AS user_id,
       IFNULL(users.user_name,'') AS user_name, IFNULL(visits.vm_structure_id,'') AS structure_id, IFNULL(call_flag_area.position,'') AS position,
       CASE WHEN call_flag_area.area IS NULL THEN '' ELSE call_flag_area.area END AS area, IFNULL(visits.vs_customer_id,'') AS customer_id ,
       CASE WHEN IFNULL(visits.vc_out_of_city,0) = 0 THEN 'DK' ELSE 'LK' END AS out_of_city,
       CASE WHEN visits.vc_customer_id IS NOT NULL THEN 'MCL'
            WHEN visits.vc_customer_id IS NULL AND call_flag_area.position <> 'MR' THEN 'MCL-BAWAHAN' ELSE 'MCL-LAIN' END AS type_mcl,
        CASE WHEN visits.vs_type ='call' AND visits.vs_customer_category ='USER' THEN 'CUSTOMER'
             WHEN visits.vs_type ='call' AND visits.vs_customer_category ='KPDM' THEN 'KPDM'
             WHEN visits.vs_type ='call outlet' THEN 'OUTLET' END AS type_call,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE visits.vs_status END AS status,
       call_flag_customers.spc AS spc,
       customers.name AS customer_name, visits.vs_schedule_datetime AS schedule_datetime, visits.vm_checkin_time AS checkin_time,
       visits.vm_checkout_time AS checkout_time,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE IF(HOUR(DATE_ADD(visits.vs_schedule_datetime, INTERVAL 7 HOUR)) < 12,false,true) END AS morning,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE IF(HOUR(DATE_ADD(visits.vs_schedule_datetime, INTERVAL 7 HOUR)) > 12,false,true) END AS evening,
       CASE WHEN visits.vm_checkout_time IS NULL THEN NULL ELSE SEC_TO_TIME(TIMESTAMPDIFF(SECOND, visits.vm_checkin_time, visits.vm_checkout_time))END AS durasi_on,
       visits.vs_id AS visit_id,
       CASE WHEN visits.vs_structure_id <> visits.vm_structure_id THEN 'JV'
            WHEN call_flag_jv.flag_jv > 1 THEN 'JV' ELSE '' END AS join_visit,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE IFNULL(visit_products.product_id,'') END AS product_id,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE IFNULL(products.name,'') END AS product_name,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE visit_products.note END AS note_detailing_product,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE IFNULL(visits.vs_location_id,'') END AS location_id,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE IFNULL(visits.vs_location_name,'') END AS location_name,
       CASE WHEN visits.vm_checkin_time IS NULL THEN '' ELSE visits.vs_location_address END AS location_address,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_location_latitude END AS location_latitude,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_location_longitude END AS location_longitude,
       visits.vm_check_in_latitude, visits.vm_check_out_latitude, visits.vm_check_in_longitude, visits.vm_check_out_longitude,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_check_in_radius END AS check_in_radius,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_check_out_radius END AS check_out_radius,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_approved_structure_id END AS approved_structure_id,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_approved_time END AS approved_time,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_approved_note END AS approved_note,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_proof_photo END AS proof_photo,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_proof_signature END AS proof_signature,
       CASE WHEN visits.vm_checkin_time IS NULL THEN NULL ELSE visits.vs_note END AS note_visit,
       visits.vc_cluster,
       visits.vc_priority,
       visits.vc_amortization
FROM VISITFLOW_MFTEMP_PROD.visit_visit_members_mcl visits
# FROM visits
# JOIN visit_members ON visits.id = visit_members.visit_id AND visit_members.deleted_at IS NULL
LEFT JOIN VISITFLOW_MF_PROD.users ON visits.vm_user_id = users.id
LEFT JOIN VISITFLOW_MF_PROD.visit_products ON visits.vs_id = visit_products.visit_id
                                AND visit_products.deleted_at IS NULL
# LEFT JOIN structures ON visit_members.structure_id = structures.id AND structures.period = '202609
#     AND structures.deleted_at IS NULL AND structures.company_id = 1
# LEFT JOIN structure_positions ON structures.level = structure_positions.level AND structure_positions.company_id =1
#    AND structures.company_id = structure_positions.company_id
#    AND structure_positions.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.products ON visit_products.product_id = products.id
                                      AND products.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customers ON visits.vs_customer_id = customers.id
                                       AND customers.deleted_at IS NULL
# LEFT JOIN customer_customer_categories ON customer_customer_categories.customer_id = visits.customer_id
#      -- AND customer_customer_categories.customer_category_id NOT IN(87, 88)
#      AND customer_customer_categories.deleted_at IS NULL
# LEFT JOIN customer_categories ON customer_customer_categories.customer_category_id = customer_categories.id
LEFT JOIN VISITFLOW_MFTEMP_PROD.call_flag_customers ON visits.vs_customer_id = call_flag_customers.id
# LEFT JOIN visit_customers ON visits.vs_customer_id = visit_customers.customer_id AND visits.period = visit_customers.period
#                AND visit_members.structure_id = visit_customers.structure_id AND visit_customers.deleted_at IS NULL
#                AND visit_customers.status = 'approved'
#                AND visit_customers.period = '202609'
LEFT JOIN VISITFLOW_MFTEMP_PROD.call_flag_jv ON visits.vs_id = call_flag_jv.visit_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.call_flag_area ON visits.vm_structure_id = call_flag_area.lv6_code
ORDER BY visits.vs_period, visits.vm_structure_id; -- <<< KUNCI OPTIMASI PENULISAN INDEX;

COMMIT;
-- 4. Kembalikan setting
SET unique_checks = 1;
SET foreign_key_checks = 1;
SET autocommit = 1;

end ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_call_visit_daily` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_call_visit_daily`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_call_visit_daily`(IN PeriodProcess varchar(6))
BEGIN

# SELECT
#     TABLE_NAME,
#     COLUMN_NAME,
#     CHARACTER_SET_NAME,
#     COLLATION_NAME,
#     DATA_TYPE
# FROM information_schema.COLUMNS
# WHERE TABLE_SCHEMA = 'VISITFLOW_MF_PROD'
#   AND TABLE_NAME IN ('visits', 'visit_members', 'visit_customers','customers','customer_customer_categories','customer_categories')
#   AND COLUMN_NAME IN ('customer_id', 'period', 'structure_id','deleted_at','status');


# COLLATE utf8mb4_0900_ai_ci
# COLLATE utf8mb4_bin
-- customer
-- insert data dari visit
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit
SELECT period, structure_id, A.customer_id, CASE WHEN D.name IS NULL THEN A.customer_name ELSE D.name END AS customer_name,
       CASE WHEN D.customer_position_id = 7 THEN 'USER'
            WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'USER' END AS customer_category,
       G.description AS specialist, MIN(IFNULL(out_of_city,0)) AS out_of_city, E.name AS customer_position,
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 1 THEN 1 ELSE 0 END ) as 'T1',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 2 THEN 1 ELSE 0 END ) as 'T2',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 3 THEN 1 ELSE 0 END ) as 'T3',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 4 THEN 1 ELSE 0 END ) as 'T4',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 5 THEN 1 ELSE 0 END ) as 'T5',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 6 THEN 1 ELSE 0 END ) as 'T6',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 7 THEN 1 ELSE 0 END ) as 'T7',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 8 THEN 1 ELSE 0 END ) as 'T8',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 9 THEN 1 ELSE 0 END ) as 'T9',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 10 THEN 1 ELSE 0 END) as 'T10',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 11 THEN 1 ELSE 0 END) as 'T11',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 12 THEN 1 ELSE 0 END) as 'T12',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 13 THEN 1 ELSE 0 END) as 'T13',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 14 THEN 1 ELSE 0 END) as 'T14',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 15 THEN 1 ELSE 0 END) as 'T15',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 16 THEN 1 ELSE 0 END) as 'T16',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 17 THEN 1 ELSE 0 END) as 'T17',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 18 THEN 1 ELSE 0 END) as 'T18',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 19 THEN 1 ELSE 0 END) as 'T19',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 20 THEN 1 ELSE 0 END) as 'T20',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 21 THEN 1 ELSE 0 END) as 'T21',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 22 THEN 1 ELSE 0 END) as 'T22',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 23 THEN 1 ELSE 0 END) as 'T23',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 24 THEN 1 ELSE 0 END) as 'T24',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 25 THEN 1 ELSE 0 END) as 'T25',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 26 THEN 1 ELSE 0 END) as 'T26',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 27 THEN 1 ELSE 0 END) as 'T27',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 28 THEN 1 ELSE 0 END) as 'T28',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 29 THEN 1 ELSE 0 END) as 'T29',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 30 THEN 1 ELSE 0 END) as 'T30',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 31 THEN 1 ELSE 0 END) as 'T31'
FROM VISITFLOW_MF_PROD.visits A
# LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories B ON A.customer_id = B.customer_id AND B.deleted_at IS NULL
# LEFT JOIN VISITFLOW_MF_PROD.customer_categories C ON B.customer_category_id = C.id AND C.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
WHERE A.period= PeriodProcess
  AND A.deleted_at IS NULL
  AND A.type ='call'
  AND A.status ='realization-approved'
GROUP BY period, structure_id, A.customer_id, CASE WHEN D.name IS NULL THEN A.customer_name ELSE D.name END,
         CASE WHEN D.customer_position_id = 7 THEN 'USER'
            WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'USER' END, G.description, E.name;
-- insert data dari visit_member (krn data jv tidak ada di visit)
-- insert data dari visit
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member
SELECT A.period, A.structure_id, B.customer_id, CASE WHEN E.name IS NULL THEN B.customer_name ELSE E.name END AS customer_name,
       CASE WHEN E.customer_position_id = 7 THEN 'USER'
            WHEN E.customer_position_id <> 7 THEN 'KPDM' ELSE 'USER' END AS customer_category,
       G.description AS specialist, MIN(IFNULL(out_of_city,0)) AS out_of_city, F.name AS customer_position,
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 1 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T1',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 2 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T2',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 3 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T3',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 4 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T4',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 5 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T5',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 6 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T6',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 7 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T7',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 8 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T8',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 9 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T9',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 10 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T10',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 11 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T11',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 12 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T12',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 13 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T13',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 14 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T14',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 15 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T15',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 16 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T16',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 17 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T17',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 18 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T18',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 19 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T19',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 20 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T20',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 21 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T21',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 22 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T22',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 23 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T23',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 24 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T24',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 25 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T25',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 26 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T26',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 27 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T27',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 28 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T28',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 29 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T29',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 30 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T30',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 31 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T31'
FROM VISITFLOW_MF_PROD.visit_members A
JOIN VISITFLOW_MF_PROD.visits B On A.visit_id = B.id AND A.period = B.period AND B.deleted_at IS NULL AND B.type ='call'
                                                  AND B.status ='realization-approved' AND A.structure_id <> B.structure_id
# LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories C ON B.customer_id = C.customer_id AND C.deleted_at IS NULL
# LEFT JOIN VISITFLOW_MF_PROD.customer_categories D ON C.customer_category_id = D.id AND D.deleted_at IS NULL

LEFT JOIN SKI_MF_PROD.customers E ON B.customer_id = E.id AND E.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_positions F ON E.customer_position_id = F.id AND F.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_specialists G ON E.customer_specialist_id = G.id AND G.deleted_at IS NULL
WHERE A.period= PeriodProcess AND A.deleted_at IS NULL
GROUP BY A.period, A.structure_id, B.customer_id, CASE WHEN E.name IS NULL THEN B.customer_name ELSE E.name END,
        CASE WHEN E.customer_position_id = 7 THEN 'USER'
            WHEN E.customer_position_id <> 7 THEN 'KPDM' ELSE 'USER' END, G.description, F.name;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all
SELECT A.period, A.structure_id, A.customer_id, A.customer_name, A.specialist, out_of_city, customer_position, customer_category,
       SUM(A.T1) T1, SUM(A.T2) T2, SUM(A.T3) T3, SUM(A.T4) T4, SUM(A.T5) T5, SUM(A.T6) T6, SUM(A.T7) T7, SUM(A.T8) T8, SUM(A.T9) T9,
       SUM(A.T10) T10, SUM(A.T11) T11, SUM(A.T12) T12, SUM(A.T13) T13, SUM(A.T14) T14, SUM(A.T15) T15, SUM(A.T16) T16,
       SUM(A.T17) T17, SUM(A.T18) T18, SUM(A.T19) T19, SUM(A.T20) T20, SUM(A.T21) T21, SUM(A.T22) T22, SUM(A.T23) T23,
       SUM(A.T24) T24, SUM(A.T25) T25, SUM(A.T26) T26, SUM(A.T27)T27, SUM(A.T28) T28, SUM(A.T29) T29, SUM(A.T30) T30, SUM(A.T31) T31,
          (
            SUM(A.T1) + SUM(A.T2) + SUM(A.T3) + SUM(A.T4) + SUM(A.T5) +
            SUM(A.T6) + SUM(A.T7) + SUM(A.T8) + SUM(A.T9) + SUM(A.T10) +
            SUM(A.T11) + SUM(A.T12) + SUM(A.T13) + SUM(A.T14) + SUM(A.T15) +
            SUM(A.T16) + SUM(A.T17) + SUM(A.T18) + SUM(A.T19) + SUM(A.T20) +
            SUM(A.T21) + SUM(A.T22) + SUM(A.T23) + SUM(A.T24) + SUM(A.T25) +
            SUM(A.T26) + SUM(A.T27) + SUM(A.T28) + SUM(A.T29) + SUM(A.T30) + SUM(A.T31)
          ) AS total_visits

FROM (
SELECT period, structure_id, customer_id, customer_name, specialist, out_of_city, customer_position, customer_category,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit A
UNION ALL
SELECT period, structure_id, customer_id, customer_name, specialist, out_of_city, customer_position, customer_category,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member A
)A
GROUP BY A.period, A.structure_id, A.customer_id, A.customer_name, customer_category,A.specialist, A.out_of_city, customer_position;

# UPDATE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all
# SET  T1 = CASE WHEN T1 > 1 THEN  1 ELSE T1 END, T2 = CASE WHEN T2 > 1 THEN  1 ELSE T2 END, T3 = CASE WHEN T3 > 1 THEN  1 ELSE T3 END,
#      T4 = CASE WHEN T4 > 1 THEN  1 ELSE T4 END, T5 = CASE WHEN T5 > 1 THEN  1 ELSE T5 END, T6 = CASE WHEN T6 > 1 THEN  1 ELSE T6 END,
#      T7 = CASE WHEN T7 > 1 THEN  1 ELSE T7 END, T8 = CASE WHEN T8 > 1 THEN  1 ELSE T8 END, T9 = CASE WHEN T9 > 1 THEN  1 ELSE T9 END,
#     T10 = CASE WHEN T10 > 1 THEN  1 ELSE T10 END, T11 = CASE WHEN T11 > 1 THEN  1 ELSE T11 END, T12 = CASE WHEN T12 > 1 THEN  1 ELSE T12 END,
#     T13 = CASE WHEN T13 > 1 THEN  1 ELSE T13 END, T14 = CASE WHEN T14 > 1 THEN  1 ELSE T14 END, T15 = CASE WHEN T15 > 1 THEN  1 ELSE T15 END,
#     T16 = CASE WHEN T16 > 1 THEN  1 ELSE T16 END, T17 = CASE WHEN T17 > 1 THEN  1 ELSE T17 END, T18 = CASE WHEN T18 > 1 THEN  1 ELSE T18 END,
#     T19 = CASE WHEN T19 > 1 THEN  1 ELSE T19 END, T20 = CASE WHEN T20 > 1 THEN  1 ELSE T20 END, T21 = CASE WHEN T21 > 1 THEN  1 ELSE T21 END,
#     T22 = CASE WHEN T22 > 1 THEN  1 ELSE T22 END, T23 = CASE WHEN T23 > 1 THEN  1 ELSE T23 END, T24 = CASE WHEN T24 > 1 THEN  1 ELSE T24 END,
#     T25 = CASE WHEN T25 > 1 THEN  1 ELSE T25 END, T26 = CASE WHEN T26 > 1 THEN  1 ELSE T26 END, T27 = CASE WHEN T27 > 1 THEN  1 ELSE T27 END,
#     T28 = CASE WHEN T28 > 1 THEN  1 ELSE T28 END, T29 = CASE WHEN T29 > 1 THEN  1 ELSE T29 END, T30 = CASE WHEN T30 > 1 THEN  1 ELSE T30 END,
#     T31 = CASE WHEN T31 > 1 THEN  1 ELSE T31 END
# WHERE period ='202609;
#
# UPDATE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all
# SET  total_visits = T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8 + T9 + T10 + T11 + T12 + T13 + T14 + T15 + T16 + T17 +
#                     T18 + T19 + T20 + T21 + T22 + T23 + T24 + T25 + T26 + T27 + T28 + T29 + T30 + T31
# WHERE period ='202609;
#


-- outlet
-- insert dari visit
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet
# VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet
SELECT period, structure_id, A.location_id, CASE WHEN D.name IS NULL THEN A.location_name ELSE D.name END AS location_name,
       E.name AS outlet_type_name, MIN(IFNULL(out_of_city,0)) AS out_of_city, D.class AS class,
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 1 THEN 1 ELSE 0 END ) as 'T1',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 2 THEN 1 ELSE 0 END ) as 'T2',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 3 THEN 1 ELSE 0 END ) as 'T3',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 4 THEN 1 ELSE 0 END ) as 'T4',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 5 THEN 1 ELSE 0 END ) as 'T5',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 6 THEN 1 ELSE 0 END ) as 'T6',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 7 THEN 1 ELSE 0 END ) as 'T7',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 8 THEN 1 ELSE 0 END ) as 'T8',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 9 THEN 1 ELSE 0 END ) as 'T9',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 10 THEN 1 ELSE 0 END) as 'T10',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 11 THEN 1 ELSE 0 END) as 'T11',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 12 THEN 1 ELSE 0 END) as 'T12',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 13 THEN 1 ELSE 0 END) as 'T13',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 14 THEN 1 ELSE 0 END) as 'T14',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 15 THEN 1 ELSE 0 END) as 'T15',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 16 THEN 1 ELSE 0 END) as 'T16',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 17 THEN 1 ELSE 0 END) as 'T17',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 18 THEN 1 ELSE 0 END) as 'T18',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 19 THEN 1 ELSE 0 END) as 'T19',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 20 THEN 1 ELSE 0 END) as 'T20',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 21 THEN 1 ELSE 0 END) as 'T21',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 22 THEN 1 ELSE 0 END) as 'T22',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 23 THEN 1 ELSE 0 END) as 'T23',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 24 THEN 1 ELSE 0 END) as 'T24',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 25 THEN 1 ELSE 0 END) as 'T25',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 26 THEN 1 ELSE 0 END) as 'T26',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 27 THEN 1 ELSE 0 END) as 'T27',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 28 THEN 1 ELSE 0 END) as 'T28',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 29 THEN 1 ELSE 0 END) as 'T29',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 30 THEN 1 ELSE 0 END) as 'T30',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 31 THEN 1 ELSE 0 END) as 'T31'
FROM (SELECT period, structure_id ,location_id,location_name,  -- CONCAT(DATE(schedule_datetime), ' 00:00:00') AS schedule_datetime,
             schedule_datetime,
             MIN(IFNULL(out_of_city,0)) AS out_of_city
      FROM VISITFLOW_MF_PROD.visits A
      WHERE A.period= PeriodProcess
          AND A.deleted_at IS NULL
          AND A.type ='call outlet'
          AND A.status ='realization-approved'
     GROUP BY  period, structure_id, location_id, location_name, schedule_datetime)A
# LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories B ON A.customer_id = B.customer_id AND B.deleted_at IS NULL
# LEFT JOIN VISITFLOW_MF_PROD.customer_categories C ON B.customer_category_id = C.id AND C.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
WHERE A.period= PeriodProcess
#   AND A.deleted_at IS NULL
#   AND A.type ='call outlet'
#   AND A.status ='realization-approved'
GROUP BY period, structure_id, A.location_id, CASE WHEN D.name IS NULL THEN A.location_name ELSE D.name END, E.name, D.class;
-- insert data dari visit_member (krn data jv tidak ada di visit)
-- insert data dari visit

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet
SELECT A.period, A.structure_id, B.location_id, CASE WHEN E.name IS NULL THEN B.location_name ELSE E.name END AS location_name,
       F.name AS outlet_type_name, MIN(IFNULL(out_of_city,0)) AS out_of_city, E.class AS class,
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 1 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T1',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 2 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T2',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 3 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T3',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 4 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T4',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 5 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T5',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 6 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T6',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 7 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T7',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 8 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T8',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 9 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END ) as 'T9',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 10 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T10',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 11 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T11',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 12 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T12',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 13 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T13',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 14 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T14',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 15 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T15',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 16 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T16',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 17 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T17',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 18 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T18',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 19 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T19',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 20 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T20',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 21 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T21',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 22 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T22',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 23 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T23',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 24 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T24',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 25 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T25',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 26 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T26',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 27 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T27',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 28 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T28',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 29 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T29',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 30 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T30',
           SUM(CASE WHEN  DAY(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))  = 31 AND A.checkin_time IS NOT NULL THEN 1 ELSE 0 END) as 'T31'
FROM VISITFLOW_MF_PROD.visit_members A
JOIN (SELECT MIN(id) AS id, period, structure_id ,location_id,location_name, -- CONCAT(DATE(schedule_datetime), ' 00:00:00') AS schedule_datetime,
             schedule_datetime,MIN(IFNULL(out_of_city,0)) AS out_of_city
      FROM VISITFLOW_MF_PROD.visits A
      WHERE A.period= PeriodProcess
          AND A.deleted_at IS NULL
          AND A.type ='call outlet'
          AND A.status ='realization-approved'
     GROUP BY  period, structure_id, location_id, location_name, schedule_datetime)B
    On A.visit_id = B.id AND A.period = B.period -- AND B.deleted_at IS NULL AND B.type ='call outlet' AND B.status ='realization-approved'
          AND A.structure_id <> B.structure_id
# LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories C ON B.customer_id = C.customer_id AND C.deleted_at IS NULL
# LEFT JOIN VISITFLOW_MF_PROD.customer_categories D ON C.customer_category_id = D.id AND D.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlets E ON B.location_id = E.id AND E.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlet_types F ON E.outlet_type_id = F.id AND F.deleted_at IS NULL
WHERE A.period= PeriodProcess AND A.deleted_at IS NULL
GROUP BY A.period, A.structure_id, B.location_id, CASE WHEN E.name IS NULL THEN B.location_name ELSE E.name END, F.name, E.class;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet
SELECT A.period, A.structure_id, A.location_id, A.location_name, A.outlet_type_name, out_of_city, class,
       SUM(A.T1) T1, SUM(A.T2) T2, SUM(A.T3) T3, SUM(A.T4) T4, SUM(A.T5) T5, SUM(A.T6) T6, SUM(A.T7) T7, SUM(A.T8) T8, SUM(A.T9) T9,
       SUM(A.T10) T10, SUM(A.T11) T11, SUM(A.T12) T12, SUM(A.T13) T13, SUM(A.T14) T14, SUM(A.T15) T15, SUM(A.T16) T16,
       SUM(A.T17) T17, SUM(A.T18) T18, SUM(A.T19) T19, SUM(A.T20) T20, SUM(A.T21) T21, SUM(A.T22) T22, SUM(A.T23) T23,
       SUM(A.T24) T24, SUM(A.T25) T25, SUM(A.T26) T26, SUM(A.T27)T27, SUM(A.T28) T28, SUM(A.T29) T29, SUM(A.T30) T30, SUM(A.T31) T31,
          (
            SUM(A.T1) + SUM(A.T2) + SUM(A.T3) + SUM(A.T4) + SUM(A.T5) +
            SUM(A.T6) + SUM(A.T7) + SUM(A.T8) + SUM(A.T9) + SUM(A.T10) +
            SUM(A.T11) + SUM(A.T12) + SUM(A.T13) + SUM(A.T14) + SUM(A.T15) +
            SUM(A.T16) + SUM(A.T17) + SUM(A.T18) + SUM(A.T19) + SUM(A.T20) +
            SUM(A.T21) + SUM(A.T22) + SUM(A.T23) + SUM(A.T24) + SUM(A.T25) +
            SUM(A.T26) + SUM(A.T27) + SUM(A.T28) + SUM(A.T29) + SUM(A.T30) + SUM(A.T31)
          ) AS total_visits

FROM (
SELECT period, structure_id, location_id, location_name, outlet_type_name , out_of_city, class,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet A
UNION ALL
SELECT period, structure_id, location_id, location_name, outlet_type_name , out_of_city, class,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet A
)A
GROUP BY A.period, A.structure_id, A.location_id, A.location_name, A.outlet_type_name, out_of_city, class;

#
# UPDATE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet
# SET  T1 = CASE WHEN T1 > 1 THEN  1 ELSE T1 END, T2 = CASE WHEN T2 > 1 THEN  1 ELSE T2 END, T3 = CASE WHEN T3 > 1 THEN  1 ELSE T3 END,
#      T4 = CASE WHEN T4 > 1 THEN  1 ELSE T4 END, T5 = CASE WHEN T5 > 1 THEN  1 ELSE T5 END, T6 = CASE WHEN T6 > 1 THEN  1 ELSE T6 END,
#      T7 = CASE WHEN T7 > 1 THEN  1 ELSE T7 END, T8 = CASE WHEN T8 > 1 THEN  1 ELSE T8 END, T9 = CASE WHEN T9 > 1 THEN  1 ELSE T9 END,
#     T10 = CASE WHEN T10 > 1 THEN  1 ELSE T10 END, T11 = CASE WHEN T11 > 1 THEN  1 ELSE T11 END, T12 = CASE WHEN T12 > 1 THEN  1 ELSE T12 END,
#     T13 = CASE WHEN T13 > 1 THEN  1 ELSE T13 END, T14 = CASE WHEN T14 > 1 THEN  1 ELSE T14 END, T15 = CASE WHEN T15 > 1 THEN  1 ELSE T15 END,
#     T16 = CASE WHEN T16 > 1 THEN  1 ELSE T16 END, T17 = CASE WHEN T17 > 1 THEN  1 ELSE T17 END, T18 = CASE WHEN T18 > 1 THEN  1 ELSE T18 END,
#     T19 = CASE WHEN T19 > 1 THEN  1 ELSE T19 END, T20 = CASE WHEN T20 > 1 THEN  1 ELSE T20 END, T21 = CASE WHEN T21 > 1 THEN  1 ELSE T21 END,
#     T22 = CASE WHEN T22 > 1 THEN  1 ELSE T22 END, T23 = CASE WHEN T23 > 1 THEN  1 ELSE T23 END, T24 = CASE WHEN T24 > 1 THEN  1 ELSE T24 END,
#     T25 = CASE WHEN T25 > 1 THEN  1 ELSE T25 END, T26 = CASE WHEN T26 > 1 THEN  1 ELSE T26 END, T27 = CASE WHEN T27 > 1 THEN  1 ELSE T27 END,
#     T28 = CASE WHEN T28 > 1 THEN  1 ELSE T28 END, T29 = CASE WHEN T29 > 1 THEN  1 ELSE T29 END, T30 = CASE WHEN T30 > 1 THEN  1 ELSE T30 END,
#     T31 = CASE WHEN T31 > 1 THEN  1 ELSE T31 END
# WHERE period ='202609;
#
# UPDATE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet
# SET  total_visits = T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8 + T9 + T10 + T11 + T12 + T13 + T14 + T15 + T16 + T17 +
#                     T18 + T19 + T20 + T21 + T22 + T23 + T24 + T25 + T26 + T27 + T28 + T29 + T30 + T31
# WHERE period ='202609;


-- CUSTOMER HISTORI NMIN3
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3 WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3
SELECT A.structure_id,A.customer_id,
       SUM(CASE WHEN A.period = PeriodProcess THEN 1 ELSE 0 END) AS n,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin1,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 2 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin2,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin3
FROM VISITFLOW_MF_PROD.visits A
WHERE A.period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
  AND A.deleted_at IS NULL
  AND A.type ='call'
  AND A.status ='realization-approved'
GROUP BY A.structure_id, A.customer_id;
-- CUSTOMER HISTORI NMIN3
-- insert data dari visit_member (krn data jv tidak ada di visit)
-- insert data dari visit

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_customer_nmin3;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_membercustomer_nmin3 WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_customer_nmin3
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_customer_nmin3
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_customer_nmin3
SELECT A.structure_id, B.customer_id,
       SUM(CASE WHEN A.period = PeriodProcess THEN 1 ELSE 0 END) AS n,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin1,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 2 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin2,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin3
FROM VISITFLOW_MF_PROD.visit_members A
JOIN VISITFLOW_MF_PROD.visits B On A.visit_id = B.id AND A.period = B.period AND B.deleted_at IS NULL AND B.type ='call'
                                                  AND B.status ='realization-approved' AND A.structure_id <> B.structure_id
WHERE A.period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
GROUP BY A.structure_id, B.customer_id;

-- oultet nmin3
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3
SELECT A.structure_id, A.customer_id,
       SUM(A.n) AS n, SUM(A.nmin1) AS nmin1, SUM(A.nmin2) AS nmin2, SUM(A.nmin3) AS nmin3
FROM (
SELECT structure_id, customer_id, n, nmin1, nmin2, nmin3
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3 A
UNION ALL
SELECT structure_id, customer_id, n, nmin1, nmin2, nmin3
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_customer_nmin3 A
)A
GROUP BY A.structure_id, A.customer_id;
-- outlet
-- insert dari visit
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3 WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3
# VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3
SELECT structure_id, A.location_id,
       SUM(CASE WHEN A.period = PeriodProcess THEN 1 ELSE 0 END) AS n,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin1,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 2 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin2,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin3
FROM (SELECT period, structure_id ,location_id,  CONCAT(DATE(schedule_datetime), ' 00:00:00') AS schedule_datetime
      FROM VISITFLOW_MF_PROD.visits A
      WHERE A.period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
          AND A.deleted_at IS NULL
          AND A.type ='call outlet'
          AND A.status ='realization-approved'
     GROUP BY  period, structure_id, location_id, CONCAT(DATE(schedule_datetime), ' 00:00:00'))A
WHERE A.period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
#   AND A.deleted_at IS NULL
#   AND A.type ='call outlet'
#   AND A.status ='realization-approved'
GROUP BY structure_id, A.location_id;

-- insert data dari visit_member (krn data jv tidak ada di visit)
-- insert data dari visit
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3 WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3
SELECT A.structure_id, B.location_id,
       SUM(CASE WHEN A.period = PeriodProcess THEN 1 ELSE 0 END) AS n,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin1,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 2 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin2,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') THEN  1 ELSE 0 END) AS nmin3
FROM VISITFLOW_MF_PROD.visit_members A
JOIN (SELECT MIN(id) AS id, period, structure_id ,location_id,location_name,
             CONCAT(DATE(schedule_datetime), ' 00:00:00') AS schedule_datetime,
             MIN(IFNULL(out_of_city,0)) AS out_of_city
      FROM VISITFLOW_MF_PROD.visits A
      WHERE A.period= PeriodProcess
          AND A.deleted_at IS NULL
          AND A.type ='call outlet'
          AND A.status ='realization-approved'
     GROUP BY  period, structure_id, location_id, location_name, CONCAT(DATE(schedule_datetime), ' 00:00:00'))B
        On A.visit_id = B.id AND A.period = B.period -- AND B.deleted_at IS NULL AND B.type ='call outlet' AND B.status ='realization-approved'
        AND A.structure_id <> B.structure_id
WHERE A.period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
    AND A.deleted_at IS NULL
GROUP BY A.structure_id, B.location_id;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3
SELECT A.structure_id, A.location_id,
       SUM(A.n) AS n, SUM(A.nmin1) AS nmin1, SUM(A.nmin2) AS nmin2, SUM(A.nmin3) AS nmin3
FROM (
SELECT A.structure_id, location_id, n, nmin1, nmin2, nmin3
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3 A
UNION ALL
SELECT A.structure_id, location_id, n, nmin1, nmin2, nmin3
FROM VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3 A
)A
GROUP BY A.structure_id, A.location_id;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_sales_customer;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_sales_customer WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_sales_customer
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_sales_customer
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_sales_customer
SELECT customer_id,
       SUM(CASE WHEN A.period = PeriodProcess THEN A.qty * B.price ELSE 0 END) AS s,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m') THEN  A.qty * B.price ELSE 0 END) AS smin1,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 2 MONTH),'%Y%m') THEN  A.qty * B.price ELSE 0 END) AS smin2,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') THEN  A.qty * B.price ELSE 0 END) AS smin3
FROM SKI_MF_PROD.credit_notes A
LEFT JOIN SKI_MF_PROD.product_prices B ON A.product_id = B.product_id AND A.period BETWEEN LEFT(B.period_start,6) AND LEFT(B.period_end,6) AND B.deleted_at IS NULL
WHERE A.deleted_at IS NULL AND period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
GROUP BY customer_id;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet WHERE period = '202609;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet
SELECT outlet_id AS location_id,
       SUM(CASE WHEN A.period = PeriodProcess THEN value_sales_final ELSE 0 END) AS s,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m') THEN  value_sales_final ELSE 0 END) AS smin1,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 2 MONTH),'%Y%m') THEN  value_sales_final ELSE 0 END) AS smin2,
       SUM(CASE WHEN A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') THEN  value_sales_final ELSE 0 END) AS smin3
FROM SKI_MF_PROD.sales_ffs A
WHERE period BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProcess,'01'), '%Y%m%d'), INTERVAL 3 MONTH),'%Y%m') AND PeriodProcess
GROUP BY outlet_id ;

# DROP TABLE IF EXISTS VISITFLOW_MF_PROD.call_daily_visit_all;

DELETE FROM VISITFLOW_MF_PROD.call_daily_visit_all WHERE period = PeriodProcess;
# SELECT * FROM VISITFLOW_MF_PROD.call_daily_visit_all
# CREATE TABLE VISITFLOW_MF_PROD.call_daily_visit_all
# INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
# CREATE TABLE VISITFLOW_MF_PROD.call_daily_visit_all
# (
#     period varchar (6) NOT NULL,
#     code_fsm          varchar(20) DEFAULT '' NOT NULL,
#     code_asm          varchar(20) DEFAULT '' NOT NULL,
#     structure_id      varchar(30) DEFAULT '' NOT NULL,
#     position          varchar(5)  DEFAULT '' NOT NULL,
#     city              varchar(11) DEFAULT '' NOT NULL,
#     user_id           varchar(30) DEFAULT '' NOT NULL,
#     name              varchar(200) DEFAULT '' NOT NULL,
#     customer_outlet_id varchar(20) DEFAULT '' NOT NULL,
#     customer_outlet_name varchar(500) DEFAULT '' NOT NULL,
#     specialist        varchar(200) DEFAULT '' NOT NULL,
#     customer_position varchar(100) DEFAULT '' NOT NULL,
#     outlet_type_name  varchar(100) DEFAULT '' NOT NULL,
#     class_outlet      varchar(30) DEFAULT '' NOT NULL,
#     type_call         varchar(30) DEFAULT '' NOT NULL,
#     out_of_city       varchar(2) DEFAULT '' NOT NULL,
#     type_mcl          varchar(11) DEFAULT '' NOT NULL,
#     priority          varchar(100) NULL,
#     cluster           varchar(50) NULL,
#     amortization      tinyint(1) NOT NULL DEFAULT '0',
#     T1                INT                                NULL,
#     T2                INT                                NULL,
#     T3                INT                                NULL,
#     T4                INT                                NULL,
#     T5                INT                                NULL,
#     T6                INT                                NULL,
#     T7                INT                                NULL,
#     T8                INT                                NULL,
#     T9                INT                                NULL,
#     T10               INT                                NULL,
#     T11               INT                                NULL,
#     T12               INT                                NULL,
#     T13               INT                                NULL,
#     T14               INT                                NULL,
#     T15               INT                                NULL,
#     T16               INT                                NULL,
#     T17               INT                                NULL,
#     T18               INT                                NULL,
#     T19               INT                                NULL,
#     T20               INT                                NULL,
#     T21               INT                                NULL,
#     T22               INT                                NULL,
#     T23               INT                                NULL,
#     T24               INT                                NULL,
#     T25               INT                                NULL,
#     T26               INT                                NULL,
#     T27               INT                                NULL,
#     T28               INT                                NULL,
#     T29               INT                                NULL,
#     T30               INT                                NULL,
#     T31               INT                                NULL,
#     total_visits      INT                                null,
#     S                 DOUBLE                             NULL,
#     N_MIN1            INT                                null,
#     S_MIN1            DOUBLE                             NULL,
#     N_MIN2            INT                                null,
#     S_MIN2            DOUBLE                             NULL,
#     N_MIN3            INT                                null,
#     S_MIN3            DOUBLE                             NULL,
#    primary key (period, structure_id, customer_outlet_id),
#    index idx_call_daily_visit_all_period (period),
#    index idx_call_daily_visit_all_structure_id (structure_id),
#    index idx_call_daily_visit_all_customer_outlet_id (customer_outlet_id),
#    index idx_call_daily_visit_all_period_structure_id (period, structure_id),
#    index idx_call_daily_visit_all_period_customer_outlet_id (period, customer_outlet_id),
#    index idx_call_daily_visit_all_period_type_call (period,type_call)
# );
-- ============================================================
-- 2. TAMBAHKAN INDEX PADA TEMPORARY TABLES (KUNCI UTAMA!)
-- ============================================================
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit ADD INDEX idx_structure_id (structure_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member ADD INDEX idx_structure_id (structure_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_customer_id (customer_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_location_id (location_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_location_id (location_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_location_id (location_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_customer_nmin3 ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_customer_id (customer_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_customer_nmin3 ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_customer_id (customer_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_customer_id (customer_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_outlet_nmi3 ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_location_id (location_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_member_outlet_nmin3 ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_location_id (location_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 ADD INDEX idx_structure_id (structure_id), ADD INDEX idx_location_id (location_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_sales_customer ADD INDEX idx_customer_id (customer_id);
ALTER TABLE VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet ADD INDEX idx_location_id (location_id);
# PeriodProcess

SET autocommit = 0;
SET unique_checks = 0;
SET foreign_key_checks = 0;


-- INSERT MR customer
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name, customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, C.lv3_code AS code_fsm, C.lv4_code AS code_asm, A.code AS structure_id, A.marketing_position_id AS position,
       CASE WHEN IFNULL(A.is_big_city,0) = 1 THEN 'BESAR' ELSE 'KECIL' END AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv6_name AS name,
        IFNULL(IFNULL(G.customer_id,B.customer_id),''), IFNULL(IFNULL(G.customer_name,B.customer_name),''), IFNULL(IFNULL(G.specialist ,B.specialist),''),
       IFNULL(IFNULL(G.customer_position ,B.customer_position),''), '' AS outlet_type_name, '' AS class_outlet,
        IFNULL(G.customer_category,'CUSTOMER')  AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
       CASE WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') <> '' THEN 'MCL BAWAHAN'
             WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT DISTINCT A.structure_id, IFNULL(A.customer_id,'') AS customer_id, IFNULL(D.name,'') AS customer_name,
                           IFNULL(E.name,'') AS customer_position, IFNULL(G.description,'') AS specialist, out_of_city,
                           A.priority AS priority, A.cluster AS cluster,
                           A.amortization AS amortization,
                           CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END AS customer_category
          FROM VISITFLOW_MF_PROD.visit_customers A
          LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id =''
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all B ON G.structure_id = B.structure_id AND G.customer_id = B.customer_id
# LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels C ON A.period = C.periode AND A.id = C.lv6_code AND C.periode ='202609
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels C ON A.period = C.periode AND A.code = C.lv6_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.customer_id = D.customer_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_customer E ON B.customer_id = E.customer_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 F ON B.structure_id = F.structure_id AND B.customer_id = F.customer_id
WHERE A.period = PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
  AND A.deleted_at IS NULL
#   AND A.level = 1
  AND A.marketing_position_id ='MR';

-- INSERT SPV
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, C.lv3_code AS code_fsm, C.lv4_code AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv5_name AS name,
        IFNULL(IFNULL(G.customer_id,B.customer_id),''), IFNULL(IFNULL(G.customer_name,B.customer_name),''), IFNULL(IFNULL(G.specialist ,B.specialist),''),
       IFNULL(IFNULL(G.customer_position ,B.customer_position),''), '' AS outlet_type_name, '' AS class_outlet,
        IFNULL(G.customer_category,'CUSTOMER') AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN IFNULL(G.out_of_city,0) = 0 AND IFNULL(B.customer_id,'') <> '' THEN 'DK'
#              WHEN IFNULL(G.out_of_city,0) = 0 AND IFNULL(B.customer_id,'') = '' THEN ''
#              WHEN IFNULL(G.out_of_city,0) = 1 AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'LK' END AS out_of_city,
#        CASE WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv5_code IS NULL THEN A.structure_id ELSE H.lv5_code END AS structure_id,
                           IFNULL(A.customer_id,'') AS customer_id, IFNULL(D.name,'') AS customer_name,
                           IFNULL(E.name,'') AS customer_position, IFNULL(G.description,'') AS specialist,
                           MIN(CASE WHEN H.lv5_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                              max(IFNULL(CASE WHEN marketing_position_id ='SPV' THEN out_of_city END,0)) AS out_of_city,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'SPV' THEN A.priority END), MAX(A.priority)) AS priority,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'SPV' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'SPV' THEN A.amortization END), MAX(A.amortization), 0) AS amortization,
                           CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END AS customer_category
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','SPV')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id =''
          GROUP BY CASE WHEN H.lv5_code IS NULL THEN A.structure_id ELSE H.lv5_code END, IFNULL(A.customer_id,''), IFNULL(D.name,''), IFNULL(E.name,''),
                   IFNULL(G.description,''),
#                    IFNULL(CASE WHEN marketing_position_id ='SPV' THEN out_of_city END,0),
                    CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                          WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END

)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all B ON G.structure_id = B.structure_id AND G.customer_id = B.customer_id
LEFT JOIN (SELECT DISTINCT  lv5_code, lv5_name, lv4_code, lv3_code
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON A.code = C.lv5_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.customer_id = D.customer_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_customer E ON B.customer_id = E.customer_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 F ON B.structure_id = F.structure_id AND B.customer_id = F.customer_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 2
  AND A.deleted_at IS NULL
  AND A.marketing_position_id ='SPV';

-- INSERT ASM
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  DISTINCT  A.period, C.lv3_code AS code_fsm, C.lv4_code AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv4_name AS name,
        IFNULL(IFNULL(G.customer_id,B.customer_id),''), IFNULL(IFNULL(G.customer_name,B.customer_name),''), IFNULL(IFNULL(G.specialist ,B.specialist),''),
       IFNULL(IFNULL(G.customer_position ,B.customer_position),''), '' AS outlet_type_name, '' AS class_outlet,
        IFNULL(G.customer_category,'CUSTOMER') AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv4_code IS NULL THEN A.structure_id ELSE H.lv4_code END AS structure_id,
                           IFNULL(A.customer_id,'') AS customer_id, IFNULL(D.name,'') AS customer_name,
                          IFNULL(E.name,'') AS customer_position, IFNULL(G.description,'') AS specialist,
                           MIN(CASE WHEN H.lv4_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                                max(IFNULL(CASE WHEN marketing_position_id ='ASM' THEN out_of_city END,0)) AS out_of_city,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'ASM' THEN A.priority END), MAX(A.priority)) AS priority,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'ASM' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'ASM' THEN A.amortization END), MAX(A.amortization), 0) AS amortization,
                          CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END AS customer_category
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','ASM')
                                                AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id =''
          GROUP BY CASE WHEN H.lv4_code IS NULL THEN A.structure_id ELSE H.lv4_code END,  IFNULL(A.customer_id,''), IFNULL(D.name,''), IFNULL(E.name,''),
                   IFNULL(G.description,''), -- IFNULL(CASE WHEN marketing_position_id ='ASM' THEN out_of_city END,0),
                          CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END

)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all B ON G.structure_id = B.structure_id AND G.customer_id = B.customer_id
LEFT JOIN (SELECT DISTINCT  lv4_code, LV4_name ,lv3_code
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON A.code = C.lv4_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.customer_id = D.customer_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_customer E ON B.customer_id = E.customer_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 F ON B.structure_id = F.structure_id AND B.customer_id = F.customer_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 3
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='ASM';

-- INSERT FSM
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, IFNULL(C.lv3_code,'') AS code_fsm, '' AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv3_name AS name,
       IFNULL(IFNULL(G.customer_id,B.customer_id),''), IFNULL(IFNULL(G.customer_name,B.customer_name),''), IFNULL(IFNULL(G.specialist ,B.specialist),''),
       IFNULL(IFNULL(G.customer_position ,B.customer_position),''), '' AS outlet_type_name, '' AS class_outlet,
        IFNULL(G.customer_category,'CUSTOMER') AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv3_code IS NULL THEN A.structure_id ELSE H.lv3_code END AS structure_id,
                           IFNULL(A.customer_id,'') AS customer_id, IFNULL(D.name,'') AS customer_name,
                           IFNULL(E.name,'') AS customer_position, IFNULL(G.description,'') AS specialist,
                           MIN(CASE WHEN H.lv3_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                   IFNULL(CASE WHEN marketing_position_id ='FSM' THEN out_of_city END,0) AS out_of_city,
                         COALESCE(MAX(CASE WHEN I.marketing_position_id = 'FSM' THEN A.priority END), MAX(A.priority)) AS priority,
                         COALESCE(MAX(CASE WHEN I.marketing_position_id = 'FSM' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                         COALESCE(MAX(CASE WHEN I.marketing_position_id = 'FSM' THEN A.amortization END), MAX(A.amortization), 0) AS amortization,
                         CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END AS customer_category
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','FSM')
                                                          AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id =''
          GROUP BY CASE WHEN H.lv3_code IS NULL THEN A.structure_id ELSE H.lv3_code END, IFNULL(A.customer_id,''), IFNULL(D.name,''), IFNULL(E.name,''),
                   IFNULL(G.description,''),    IFNULL(CASE WHEN marketing_position_id ='FSM' THEN out_of_city END,0) ,
                               CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all B ON G.structure_id = B.structure_id AND G.customer_id = B.customer_id
LEFT JOIN (SELECT DISTINCT  lv3_code, lv3_name
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON  A.code = C.lv3_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.customer_id = D.customer_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_customer E ON B.customer_id = E.customer_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 F ON B.structure_id = F.structure_id AND B.customer_id = F.customer_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 4
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='FSM';

-- INSERT GM
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT DISTINCT A.period, '' AS code_fsm, '' AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv2_name AS name,
       IFNULL(IFNULL(G.customer_id,B.customer_id),''), IFNULL(IFNULL(G.customer_name,B.customer_name),''), IFNULL(IFNULL(G.specialist ,B.specialist),''),
       IFNULL(IFNULL(G.customer_position ,B.customer_position),''), '' AS outlet_type_name, '' AS class_outlet,
        IFNULL(G.customer_category,'CUSTOMER') AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv2_code IS NULL THEN A.structure_id ELSE H.lv2_code END AS structure_id,
                           IFNULL(A.customer_id,'') AS customer_id, IFNULL(D.name,'') AS customer_name,
                           IFNULL(E.name,'') AS customer_position, IFNULL(G.description,'') AS specialist,
                           MIN(CASE WHEN H.lv2_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                                IFNULL(CASE WHEN marketing_position_id ='GM' THEN out_of_city END,0) AS out_of_city,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'GM' THEN A.priority END), MAX(A.priority)) AS priority,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'GM' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'GM' THEN A.amortization END), MAX(A.amortization), 0) AS amortization,
                           CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END AS customer_category
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','GM')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id =''
          GROUP BY CASE WHEN H.lv2_code IS NULL THEN A.structure_id ELSE H.lv2_code END,IFNULL(A.customer_id,''), IFNULL(D.name,''), IFNULL(E.name,''),
                   IFNULL(G.description,''),    IFNULL(CASE WHEN marketing_position_id ='GM' THEN out_of_city END,0) ,
                                              CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all B ON G.structure_id = B.structure_id AND G.customer_id = B.customer_id
LEFT JOIN (SELECT DISTINCT  lv2_code, lv2_name
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON  A.code = C.lv2_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.customer_id = D.customer_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_customer E ON B.customer_id = E.customer_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 F ON B.structure_id = F.structure_id AND B.customer_id = F.customer_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 5
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='GM'
UNION ALL
-- INSERT MD
SELECT  A.period, '' AS code_fsm, '' AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv1_name AS name,
        IFNULL(IFNULL(G.customer_id,B.customer_id),''), IFNULL(IFNULL(G.customer_name,B.customer_name),''), IFNULL(IFNULL(G.specialist ,B.specialist),''),
       IFNULL(IFNULL(G.customer_position ,B.customer_position),''), '' AS outlet_type_name, '' AS class_outlet,
        IFNULL(G.customer_category,'CUSTOMER') AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.customer_id IS NULL AND IFNULL(B.customer_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv1_code IS NULL THEN A.structure_id ELSE H.lv1_code END AS structure_id,
                           IFNULL(A.customer_id,'') AS customer_id, IFNULL(D.name,'') AS customer_name,
                           IFNULL(E.name,'') AS customer_position, IFNULL(G.description,'') AS specialist,
                           MIN(CASE WHEN H.lv1_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                               IFNULL(CASE WHEN marketing_position_id ='MD' THEN out_of_city END,0) AS out_of_city,
                             COALESCE(MAX(CASE WHEN I.marketing_position_id = 'MD' THEN A.priority END), MAX(A.priority)) AS priority,
                             COALESCE(MAX(CASE WHEN I.marketing_position_id = 'MD' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                             COALESCE(MAX(CASE WHEN I.marketing_position_id = 'MD' THEN A.amortization END), MAX(A.amortization), 0) AS amortization,
                             CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END AS customer_category
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','MD')
                                                           AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id =''
          GROUP BY CASE WHEN H.lv1_code IS NULL THEN A.structure_id ELSE H.lv1_code END,  IFNULL(A.customer_id,''), IFNULL(D.name,''), IFNULL(E.name,''),
                   IFNULL(G.description,''),    IFNULL(CASE WHEN marketing_position_id ='MD' THEN out_of_city END,0) ,
                             CASE WHEN D.customer_position_id = 7 THEN 'CUSTOMER'
                               WHEN D.customer_position_id <> 7 THEN 'KPDM' ELSE 'CUSTOMER' END
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all B ON G.structure_id = B.structure_id AND G.customer_id = B.customer_id
LEFT JOIN (SELECT DISTINCT  lv1_code, lv1_name
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON  A.code = C.lv1_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.customer_id = D.customer_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_customer E ON B.customer_id = E.customer_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_customer_nmin3 F ON B.structure_id = F.structure_id AND B.customer_id = F.customer_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 6;
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='MD';

--
-- INSERT MR OUTLET
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name, customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31, total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, C.lv3_code AS code_fsm, C.lv4_code AS code_asm, A.code AS structure_id, A.marketing_position_id AS position,
       CASE WHEN IFNULL(A.is_big_city,0) = 1 THEN 'BESAR' ELSE 'KECIL' END AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv6_name AS name,
        IFNULL(IFNULL(G.location_id ,B.location_id),''), IFNULL(IFNULL( G.location_name,B.location_name),''),  '' AS specialist, '' AS customer_position,
        IFNULL(IFNULL(G.outlet_type_name, B.outlet_type_name),'') AS outlet_type_name,
       IFNULL(IFNULL(G.class, B.class),'') AS class_outlet, 'OUTLET' AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
       CASE WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') <> '' THEN 'MCL BAWAHAN'
             WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT DISTINCT A.structure_id, IFNULL(A.location_id,'') AS location_id, IFNULL(D.name,'') AS location_name,
                           IFNULL(E.name,'') AS outlet_type_name, IFNULL(D.class,'') AS class, out_of_city,
                           A.priority AS priority, A.cluster AS cluster,
                           A.amortization AS amortization
          FROM VISITFLOW_MF_PROD.visit_customers A
          LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id <>''
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet B ON G.structure_id = B.structure_id AND G.location_id = B.location_id
# LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels C ON A.period = C.periode AND A.id = C.lv6_code AND C.periode ='202609
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels C ON A.period = C.periode AND A.code = C.lv6_code AND C.periode = PeriodProcess
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.location_id = D.location_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet E ON B.location_id = E.Location_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 F ON B.structure_id = F.structure_id AND B.location_id = F.location_id
WHERE A.period = PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
  AND A.deleted_at IS NULL
#   AND A.level = 1
  AND A.marketing_position_id ='MR';

-- INSERT SPV
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, C.lv3_code AS code_fsm, C.lv4_code AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv5_name AS name,
        IFNULL(IFNULL(G.location_id ,B.location_id),''), IFNULL(IFNULL( G.location_name,B.location_name),''),  '' AS specialist, '' AS customer_position,
        IFNULL(IFNULL(G.outlet_type_name, B.outlet_type_name),'') AS outlet_type_name,
       IFNULL(IFNULL(G.class, B.class),'') AS class_outlet, 'OUTLET' AS type_call,
        CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv5_code IS NULL THEN A.structure_id ELSE H.lv5_code END AS structure_id,
                           IFNULL(A.location_id,'') AS location_id, IFNULL(D.name,'') AS location_name,
                           IFNULL(E.name,'') AS outlet_type_name, IFNULL(D.class,'') AS class,
                           max(IFNULL(CASE WHEN marketing_position_id ='SPV' THEN out_of_city END,0)) AS out_of_city,
                           MIN(CASE WHEN H.lv5_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'SPV' THEN A.priority END), MAX(A.priority)) AS priority,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'SPV' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'SPV' THEN A.amortization END), MAX(A.amortization), 0) AS amortization
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','SPV')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id <>''
          GROUP BY CASE WHEN H.lv5_code IS NULL THEN A.structure_id ELSE H.lv5_code END,IFNULL(A.location_id,''), IFNULL(D.name,''),
                   IFNULL(E.name,''), IFNULL(D.class,'') -- ,IFNULL(CASE WHEN marketing_position_id ='SPV' THEN out_of_city END,0)
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet B ON G.structure_id = B.structure_id AND G.location_id = B.location_id
LEFT JOIN (SELECT DISTINCT  lv5_code, lv5_name, lv4_code, lv3_code
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON A.code = C.lv5_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.location_id = D.location_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet E ON B.location_id = E.location_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 F ON B.structure_id = F.structure_id AND B.location_id = F.location_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 2
  AND A.deleted_at IS NULL
  AND A.marketing_position_id ='SPV';

-- INSERT ASM
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, C.lv3_code AS code_fsm, C.lv4_code AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv4_name AS name,
        IFNULL(IFNULL(G.location_id ,B.location_id),''), IFNULL(IFNULL( G.location_name,B.location_name),''),  '' AS specialist, '' AS customer_position,
        IFNULL(IFNULL(G.outlet_type_name, B.outlet_type_name),'') AS outlet_type_name,
       IFNULL(IFNULL(G.class, B.class),'') AS class_outlet, 'OUTLET' AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv4_code IS NULL THEN A.structure_id ELSE H.lv4_code END AS structure_id,
                           IFNULL(A.location_id,'') AS location_id, IFNULL(D.name,'') AS location_name,
                           IFNULL(E.name,'') AS outlet_type_name, IFNULL(D.class,'') AS class,
                           max(IFNULL(CASE WHEN marketing_position_id ='ASM' THEN out_of_city END,0)) AS out_of_city,
                          MIN(CASE WHEN H.lv4_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'ASM' THEN A.priority END), MAX(A.priority)) AS priority,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'ASM' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'ASM' THEN A.amortization END), MAX(A.amortization), 0) AS amortization
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','ASM')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id <>''
          GROUP BY CASE WHEN H.lv4_code IS NULL THEN A.structure_id ELSE H.lv4_code END, IFNULL(A.location_id,''), IFNULL(D.name,''),
                   IFNULL(E.name,''), IFNULL(D.class,'')-- , IFNULL(CASE WHEN marketing_position_id ='ASM' THEN out_of_city END,0)
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet B ON G.structure_id = B.structure_id AND G.location_id = B.location_id
LEFT JOIN (SELECT DISTINCT  lv4_code, LV4_name ,lv3_code
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON A.code = C.lv4_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.location_id = D.location_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet E ON B.location_id = E.location_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 F ON B.structure_id = F.structure_id AND B.location_id = F.location_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 3
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='ASM';

-- INSERT FSM
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, IFNULL(C.lv3_code,'') AS code_fsm, '' AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv3_name AS name,
        IFNULL(IFNULL(G.location_id ,B.location_id),''), IFNULL(IFNULL( G.location_name,B.location_name),''),  '' AS specialist, '' AS customer_position,
        IFNULL(IFNULL(G.outlet_type_name, B.outlet_type_name),'') AS outlet_type_name,
       IFNULL(IFNULL(G.class, B.class),'') AS class_outlet, 'OUTLET' AS type_call,
        CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv3_code IS NULL THEN A.structure_id ELSE H.lv3_code END AS structure_id,
                           IFNULL(A.location_id,'') AS location_id, IFNULL(D.name,'') AS location_name,
                           IFNULL(E.name,'') AS outlet_type_name, IFNULL(D.class,'') AS class,
                          IFNULL(CASE WHEN marketing_position_id ='FSM' THEN out_of_city END,0) AS out_of_city,
                          MIN(CASE WHEN H.lv3_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'FSM' THEN A.priority END), MAX(A.priority)) AS priority,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'FSM' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                          COALESCE(MAX(CASE WHEN I.marketing_position_id = 'FSM' THEN A.amortization END), MAX(A.amortization), 0) AS amortization
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','FSM')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id <>''
          GROUP BY CASE WHEN H.lv3_code IS NULL THEN A.structure_id ELSE H.lv3_code END, IFNULL(A.location_id,''), IFNULL(D.name,''),
                   IFNULL(E.name,''), IFNULL(D.class,''), IFNULL(CASE WHEN marketing_position_id ='FSM' THEN out_of_city END,0)
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet B ON G.structure_id = B.structure_id AND G.location_id = B.location_id
LEFT JOIN (SELECT DISTINCT  lv3_code, lv3_name
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON  A.code = C.lv3_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.location_id = D.location_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet E ON B.location_id = E.location_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 F ON B.structure_id = F.structure_id AND B.location_id = F.location_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 4
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='FSM';

-- INSERT GM
INSERT INTO VISITFLOW_MF_PROD.call_daily_visit_all
(period, code_fsm, code_asm, structure_id, position, city, user_id, name,
 customer_outlet_id, customer_outlet_name, specialist, customer_position,
 outlet_type_name, class_outlet, type_call, out_of_city, type_mcl, priority, cluster, amortization,
 T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
 T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
 total_visits, S, N_MIN1, S_MIN1, N_MIN2, S_MIN2, N_MIN3, S_MIN3)
SELECT  A.period, '' AS code_fsm, '' AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv2_name AS name,
        IFNULL(IFNULL(G.location_id ,B.location_id),''), IFNULL(IFNULL( G.location_name,B.location_name),''),  '' AS specialist, '' AS customer_position,
        IFNULL(IFNULL(G.outlet_type_name, B.outlet_type_name),'') AS outlet_type_name,
       IFNULL(IFNULL(G.class, B.class),'') AS class_outlet, 'OUTLET' AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
        IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv2_code IS NULL THEN A.structure_id ELSE H.lv2_code END AS structure_id,
                           IFNULL(A.location_id,'') AS location_id, IFNULL(D.name,'') AS location_name,
                           IFNULL(E.name,'') AS outlet_type_name, IFNULL(D.class,'') AS class,
                           IFNULL(CASE WHEN marketing_position_id ='GM' THEN out_of_city END,0) AS out_of_city,
                           MIN(CASE WHEN H.lv2_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'GM' THEN A.priority END), MAX(A.priority)) AS priority,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'GM' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'GM' THEN A.amortization END), MAX(A.amortization), 0) AS amortization
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','GM')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id <>''
          GROUP BY CASE WHEN H.lv2_code IS NULL THEN A.structure_id ELSE H.lv2_code END,  IFNULL(A.location_id,''),
                   IFNULL(D.name,''), IFNULL(E.name,''), IFNULL(D.class,''), IFNULL(CASE WHEN marketing_position_id ='GM' THEN out_of_city END,0)
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet B ON G.structure_id = B.structure_id AND G.location_id = B.location_id
LEFT JOIN (SELECT DISTINCT  lv2_code, lv2_name
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON  A.code = C.lv2_code
LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = PeriodProcess AND B.period = D.period AND B.structure_id = D.structure_id
                       AND B.location_id = D.location_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet E ON B.location_id = E.location_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 F ON B.structure_id = F.structure_id AND B.location_id = F.location_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 5
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='GM'
UNION ALL
-- INSERT MD
SELECT  A.period, '' AS code_fsm, '' AS code_asm, A.code AS structure_id, marketing_position_id AS position,
       '' AS city, IFNULL(A.user_id,A.code) AS user_id, C.lv1_name AS name,
         IFNULL(IFNULL(G.location_id ,B.location_id),''), IFNULL(IFNULL( G.location_name,B.location_name),''),  '' AS specialist, '' AS customer_position,
        IFNULL(IFNULL(G.outlet_type_name, B.outlet_type_name),'') AS outlet_type_name,
       IFNULL(IFNULL(G.class, B.class),'') AS class_outlet, 'OUTLET' AS type_call,
       CASE WHEN IFNULL(G.out_of_city,0) = 1 THEN 'LK' ELSE 'DK' END AS out_of_city,
#        CASE WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') <> '' THEN 'MCL BAWAHAN'
#              WHEN G.location_id IS NULL AND IFNULL(B.location_id,'') = '' THEN '' ELSE 'MCL' END AS mcl,
       IFNULL(G.MCL,''),
       G.priority AS priority, G.cluster AS cluster,
       IFNULL(G.amortization,0) AS amortization,
       T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31,
       total_visits, E.s, F.n , E.smin1, F.nmin2 , E.smin2, F.nmin3, E.smin3
# FROM VISITFLOW_MF_PROD.structures A
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN (SELECT CASE WHEN H.lv1_code IS NULL THEN A.structure_id ELSE H.lv1_code END AS structure_id,
                           IFNULL(A.location_id,'') AS location_id, IFNULL(D.name,'') AS location_name,
                           IFNULL(E.name,'') AS outlet_type_name, IFNULL(D.class,'') AS class,
                         IFNULL(CASE WHEN marketing_position_id ='MD' THEN out_of_city END,0) AS out_of_city,
                           MIN(CASE WHEN H.lv1_code IS NULL THEN 'MCL' ELSE 'MCL_BAWAHAN' END) AS MCL,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'MD' THEN A.priority END), MAX(A.priority)) AS priority,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'MD' THEN A.cluster END), MAX(A.cluster)) AS cluster,
                           COALESCE(MAX(CASE WHEN I.marketing_position_id = 'MD' THEN A.amortization END), MAX(A.amortization), 0) AS amortization
          FROM VISITFLOW_MF_PROD.visit_customers A
          JOIN SKI_MF_PROD.marketing_structures I ON A.structure_id = I.code AND A.period = I.period AND marketing_position_id IN ('MR','MD')
                                                         AND I.deleted_at IS NULL AND I.period = PeriodProcess
          LEFT JOIN SKI_MF_PROD.outlets D ON A.location_id = D.id AND D.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.outlet_types E ON D.outlet_type_id = E.id AND E.deleted_at IS NULL
          LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND A.period = H.periode
                                     AND H.periode = PeriodProcess
          WHERE A.period = PeriodProcess AND A.deleted_at IS NULL
              AND A.status = 'approved' AND A.location_id <>''
          GROUP BY CASE WHEN H.lv1_code IS NULL THEN A.structure_id ELSE H.lv1_code END,  IFNULL(A.location_id,''),
                   IFNULL(D.name,''), IFNULL(E.name,''), IFNULL(D.class,''), IFNULL(CASE WHEN marketing_position_id ='MD' THEN out_of_city END,0)
)G ON A.code = G.structure_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet B ON G.structure_id = B.structure_id AND G.location_id = B.location_id
LEFT JOIN (SELECT DISTINCT  lv1_code, lv1_name
           FROM SKI_MF_PROD.marketing_structure_all_levels
           WHERE periode = PeriodProcess) C ON  A.code = C.lv1_code
# LEFT JOIN VISITFLOW_MF_PROD.visit_customers D ON D.period = '202609 AND B.period = D.period AND B.structure_id = D.structure_id
#                        AND B.location_id = D.location_id AND D.deleted_at IS NULL AND D.status ='approved'
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_sales_outlet E ON B.location_id = E.location_id
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_call_daily_visit_all_outlet_nmin3 F ON B.structure_id = F.structure_id AND B.location_id = F.location_id
WHERE A.period =PeriodProcess AND (A.is_dummy = 0 OR A.is_dummy = 1 AND A.user_id IS NOT NULL)
#   AND A.level = 6;
    AND A.deleted_at IS NULL
    AND A.marketing_position_id ='MD';

DELETE FROM VISITFLOW_MF_PROD.call_daily_visit_all WHERE period = PeriodProcess AND type_mcl ='MCL_BAWAHAN' AND IFNULL(total_visits,0) = 0;

COMMIT;
-- 4. Kembalikan setting
SET unique_checks = 1;
SET foreign_key_checks = 1;
SET autocommit = 1;

END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_mcl` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_mcl`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_mcl`(IN PeriodProses varchar(6))
BEGIN

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv
SELECT DISTINCT periode, lv5_code, lv4_code, lv3_code, lv2_code, lv1_code
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProses ;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm
SELECT DISTINCT periode, lv4_code, lv3_code, lv2_code, lv1_code
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProses ;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm
SELECT DISTINCT periode, lv3_code, lv2_code, lv1_code
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProses ;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal
SELECT DISTINCT A.period, A. structure_id,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv6_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv6_code
            WHEN J.lv5_code IS NOT NULL THEN J.lv6_code
            WHEN K.lv5_code IS NOT NULL THEN K.lv6_code
            WHEN L.lv5_code IS NOT NULL THEN L.lv6_code
            WHEN M.lv5_code IS NOT NULL THEN M.lv6_code END AS structur_mcl_mr,
       A.customer_id
FROM VISITFLOW_MF_PROD.visit_customers A
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND H.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels I ON A.structure_id = I.lv5_code AND I.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels J ON A.structure_id = J.lv4_code AND J.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels K ON A.structure_id = K.lv3_code AND K.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels L ON A.structure_id = L.lv3_code AND L.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels M ON A.structure_id = M.lv3_code AND M.periode = PeriodProses
WHERE A.period = PeriodProses
   AND A.deleted_at IS NULL
   AND A.customer_id <> 'NON' AND IFNULL(A.location_id,'') ='';


DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk
SELECT A.structure_id, A.customer_id , MIN(C.out_of_city) AS out_of_city
FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal A
LEFT JOIN VISITFLOW_MF_PROD.customer_locations B ON A.period BETWEEN B.start_period AND B.end_period AND B.deleted_at IS NULL
                                                        AND A.customer_id= B.customer_id AND B.status ='approve'
LEFT JOIN VISITFLOW_MF_PROD.structure_locations C ON B.location_id = C.location_id AND C.deleted_at IS NULL
                                                      AND C.period = PeriodProses AND A.structur_mcl_mr = C.structure_id
GROUP BY A.structure_id, A.customer_id;


# SELECT * FROM VISITFLOW_MF_PROD.visit_customers A WHERE period ='202510' AND structure_id ='JAPA1'
# SELECT * FROM VISITFLOW_MF_PROD.customer_locations  WHERE  customer_id ='JYP20-0001'
# SELECT * FROM VISITFLOW_MF_PROD.structure_locations WHERE location_id ='JYP190003' AND period ='202510'
# SELECT * FROM VISITFLOW_MF_PROD.master_call_list
# create table VISITFLOW_MF_PROD.master_call_list
# (
#     id            bigint unsigned auto_increment
#         primary key,
#     created_at    datetime(3)      null,
#     updated_at    datetime(3)      null,
#     deleted_at    datetime(3)      null,
#     created_by_id bigint unsigned  null,
#     updated_by_id bigint unsigned  null,
#     deleted_by_id bigint unsigned  null,
#     period varchar (6)  not null,
#     structur_id         varchar(20) not null,
#     position            varchar(30) null,
#     city                varchar(5) default '' not null,
#     user_id                     bigint unsigned null,
#     user_name                   varchar(100) null,
#     spv                         varchar(20)  null,
#     asm                         varchar(20)  null,
#     fsm                         varchar(20)  null,
#     type_call                   varchar(20) default '' not null,
#     code                        varchar(100) null,
#     name                        varchar(500) null,
#     customer_position_or_sector varchar(150) null,
#     sps_or_class                varchar(250) null,
#     dk_lk                       varchar(2) default '' not null,
#     status                      varchar(20) null,
#     note_reject                 longtext null,
#         constraint idx_master_call_list_period_structur_id_code
#         unique (period, structure_id, code),
#    index idx_master_call_list_deleted_at (deleted_at),
#    index idx_master_call_list_period (period),
#    index idx_master_call_list_structur_id (structur_id),
#    index idx_master_call_list_code (code),
#    index idx_master_call_list_deleted_period_structur_id_code (deleted_at,period,structur_id,code)
#
# );
#
DELETE FROM VISITFLOW_MF_PROD.master_call_list WHERE period = PeriodProses;
INSERT VISITFLOW_MF_PROD.master_call_list
(period, structure_id, position, city, user_id, user_name, spv, asm, fsm, type_call, code, name, customer_position_or_sector, sps_or_class, dk_lk, status, note_reject,cluster,priority,amortization)
SELECT A.period, A.code AS structur_id, A.marketing_position_id AS position,
       CASE WHEN IFNULL(A.is_big_city,0) = 1 AND H.lv6_code IS NOT NULL THEN 'BESAR'
            WHEN IFNULL(A.is_big_city,0) = 0 AND H.lv6_code IS NOT NULL THEN 'KECIL' ELSE '' END city, A.user_id, A.name AS user_name,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv5_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv5_code
            ELSE '' END AS spv,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv4_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv4_code
            WHEN J.lv4_code IS NOT NULL THEN J.lv4_code
            ELSE '' END AS asm,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv3_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv3_code
            WHEN J.lv4_code IS NOT NULL THEN J.lv3_code
            WHEN K.lv3_code IS NOT NULL THEN K.lv3_code
            ELSE '' END AS fsm,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' AND IFNULL(D.customer_position_id,0) = 7 THEN 'CUSTOMER'
            WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' AND IFNULL(D.customer_position_id,0) <> 7 THEN 'KPDM'
            WHEN B.customer_id = 'NON' AND IFNULL(location_id,'') <> '' THEN 'OUTLET' ELSE '' END AS type_call,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN B.customer_id ELSE B.location_id END AS code,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN B.customer_name ELSE C.name END AS name,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN E.name
            WHEN B.customer_id = 'NON' AND IFNULL(location_id,'') <> '' THEN CC.name ELSE '' END AS customer_position_or_sector,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN G.description
            WHEN B.customer_id = 'NON' AND IFNULL(location_id,'') <> '' THEN C.class ELSE '' END AS sps_or_class,
       CASE WHEN B.out_of_city = 1 THEN 'LK'
            WHEN B.out_of_city = 0 THEN 'DK' ELSE '' END AS dk_lk,
--       E.name AS customer_position , G.description AS sps, C.class AS outlet_class, CC.name AS outlet_sector,
       B.status, CASE WHEN B.status ='rejected' THEN B.note ELSE '' END AS note_reject,
       B.cluster,
       B.priority,
       B.amortization
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN VISITFLOW_MF_PROD.visit_customers B ON A.code = B.structure_id AND A.period = B.period AND B.deleted_at IS NULL AND B.company_id =1
# JOIN SKI_MF_PROD.marketing_structures B ON A.structure_id = B.code AND A.period = B.period
#                                                          AND B.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlets C ON B.location_id = C.id AND C.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlet_types CC ON C.outlet_type_id = CC.id AND CC.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customers D ON B.customer_id = D.id AND D.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.code = H.lv6_code AND A.period = H.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv I ON A.code = I.lv5_code AND A.period = I.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm J ON A.code = J.lv4_code AND A.period = J.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm K ON A.code = K.lv3_code AND A.period = K.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk L ON B.structure_id = L.structure_id AND B.customer_id = L.customer_id
WHERE A.period = PeriodProses
 AND A.deleted_at IS NULL;
END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_mcl_temp` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_mcl_temp`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_mcl_temp`(IN PeriodProses varchar(6))
BEGIN

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv
SELECT DISTINCT periode, lv5_code, lv4_code, lv3_code, lv2_code, lv1_code
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProses ;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm
SELECT DISTINCT periode, lv4_code, lv3_code, lv2_code, lv1_code
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProses ;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm
SELECT DISTINCT periode, lv3_code, lv2_code, lv1_code
FROM SKI_MF_PROD.marketing_structure_all_levels
WHERE periode = PeriodProses ;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal
SELECT DISTINCT A.period, A. structure_id,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv6_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv6_code
            WHEN J.lv5_code IS NOT NULL THEN J.lv6_code
            WHEN K.lv5_code IS NOT NULL THEN K.lv6_code
            WHEN L.lv5_code IS NOT NULL THEN L.lv6_code
            WHEN M.lv5_code IS NOT NULL THEN M.lv6_code END AS structur_mcl_mr,
       A.customer_id
FROM VISITFLOW_MF_PROD.visit_customers A
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.structure_id = H.lv6_code AND H.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels I ON A.structure_id = I.lv5_code AND I.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels J ON A.structure_id = J.lv4_code AND J.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels K ON A.structure_id = K.lv3_code AND K.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels L ON A.structure_id = L.lv3_code AND L.periode = PeriodProses
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels M ON A.structure_id = M.lv3_code AND M.periode = PeriodProses
WHERE A.period = PeriodProses
   AND A.deleted_at IS NULL
   AND A.customer_id <> 'NON' AND IFNULL(A.location_id,'') ='';


DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk
SELECT A.structure_id, A.customer_id , MIN(C.out_of_city) AS out_of_city
FROM VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk_awal A
LEFT JOIN VISITFLOW_MF_PROD.customer_locations B ON A.period BETWEEN B.start_period AND B.end_period AND B.deleted_at IS NULL
                                                        AND A.customer_id= B.customer_id AND B.status ='approve'
LEFT JOIN VISITFLOW_MF_PROD.structure_locations C ON B.location_id = C.location_id AND C.deleted_at IS NULL
                                                      AND C.period = PeriodProses AND A.structur_mcl_mr = C.structure_id
GROUP BY A.structure_id, A.customer_id;


# SELECT * FROM VISITFLOW_MF_PROD.visit_customers A WHERE period ='202510' AND structure_id ='JAPA1'
# SELECT * FROM VISITFLOW_MF_PROD.customer_locations  WHERE  customer_id ='JYP20-0001'
# SELECT * FROM VISITFLOW_MF_PROD.structure_locations WHERE location_id ='JYP190003' AND period ='202510'
# SELECT * FROM VISITFLOW_MF_PROD.master_call_list
# create table VISITFLOW_MF_PROD.master_call_list
# (
#     id            bigint unsigned auto_increment
#         primary key,
#     created_at    datetime(3)      null,
#     updated_at    datetime(3)      null,
#     deleted_at    datetime(3)      null,
#     created_by_id bigint unsigned  null,
#     updated_by_id bigint unsigned  null,
#     deleted_by_id bigint unsigned  null,
#     period varchar (6)  not null,
#     structur_id         varchar(20) not null,
#     position            varchar(30) null,
#     city                varchar(5) default '' not null,
#     user_id                     bigint unsigned null,
#     user_name                   varchar(100) null,
#     spv                         varchar(20)  null,
#     asm                         varchar(20)  null,
#     fsm                         varchar(20)  null,
#     type_call                   varchar(20) default '' not null,
#     code                        varchar(100) null,
#     name                        varchar(500) null,
#     customer_position_or_sector varchar(150) null,
#     sps_or_class                varchar(250) null,
#     dk_lk                       varchar(2) default '' not null,
#     status                      varchar(20) null,
#     note_reject                 longtext null,
#         constraint idx_master_call_list_period_structur_id_code
#         unique (period, structure_id, code),
#    index idx_master_call_list_deleted_at (deleted_at),
#    index idx_master_call_list_period (period),
#    index idx_master_call_list_structur_id (structur_id),
#    index idx_master_call_list_code (code),
#    index idx_master_call_list_deleted_period_structur_id_code (deleted_at,period,structur_id,code)
#
# );
#
DELETE FROM VISITFLOW_MF_PROD.master_call_list WHERE period = PeriodProses;
INSERT VISITFLOW_MF_PROD.master_call_list
(period, structure_id, position, city, user_id, user_name, spv, asm, fsm, type_call, code, name, customer_position_or_sector, sps_or_class, dk_lk, status, note_reject)
SELECT A.period, A.code AS structur_id, A.marketing_position_id AS position,
       CASE WHEN IFNULL(A.is_big_city,0) = 1 AND H.lv6_code IS NOT NULL THEN 'BESAR'
            WHEN IFNULL(A.is_big_city,0) = 0 AND H.lv6_code IS NOT NULL THEN 'KECIL' ELSE '' END city, A.user_id, A.name AS user_name,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv5_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv5_code
            ELSE '' END AS spv,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv4_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv4_code
            WHEN J.lv4_code IS NOT NULL THEN J.lv4_code
            ELSE '' END AS asm,
       CASE WHEN H.lv5_code IS NOT NULL THEN H.lv3_code
            WHEN I.lv5_code IS NOT NULL THEN I.lv3_code
            WHEN J.lv4_code IS NOT NULL THEN J.lv3_code
            WHEN K.lv3_code IS NOT NULL THEN K.lv3_code
            ELSE '' END AS fsm,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' AND IFNULL(D.customer_position_id,0) = 7 THEN 'CUSTOMER'
            WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' AND IFNULL(D.customer_position_id,0) <> 7 THEN 'KPDM'
            WHEN B.customer_id = 'NON' AND IFNULL(location_id,'') <> '' THEN 'OUTLET' ELSE '' END AS type_call,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN B.customer_id ELSE B.location_id END AS code,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN B.customer_name ELSE C.name END AS name,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN E.name
            WHEN B.customer_id = 'NON' AND IFNULL(location_id,'') <> '' THEN CC.name ELSE '' END AS customer_position_or_sector,
       CASE WHEN B.customer_id <> 'NON' AND IFNULL(location_id,'') ='' THEN G.description
            WHEN B.customer_id = 'NON' AND IFNULL(location_id,'') <> '' THEN C.class ELSE '' END AS sps_or_class,
       CASE WHEN B.out_of_city = 1 THEN 'LK'
            WHEN B.out_of_city = 0 THEN 'DK' ELSE '' END AS dk_lk,
--       E.name AS customer_position , G.description AS sps, C.class AS outlet_class, CC.name AS outlet_sector,
       B.status, CASE WHEN B.status ='rejected' THEN B.note ELSE '' END AS note_reject
FROM SKI_MF_PROD.marketing_structures A
LEFT JOIN VISITFLOW_MF_PROD.visit_customers B ON A.code = B.structure_id AND A.period = B.period AND B.deleted_at IS NULL AND B.company_id =1
# JOIN SKI_MF_PROD.marketing_structures B ON A.structure_id = B.code AND A.period = B.period
#                                                          AND B.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlets C ON B.location_id = C.id AND C.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.outlet_types CC ON C.outlet_type_id = CC.id AND CC.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customers D ON B.customer_id = D.id AND D.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_positions E ON D.customer_position_id = E.id AND E.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.customer_specialists G ON D.customer_specialist_id = G.id AND G.deleted_at IS NULL
LEFT JOIN SKI_MF_PROD.marketing_structure_all_levels H ON A.code = H.lv6_code AND A.period = H.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_structure_spv I ON A.code = I.lv5_code AND A.period = I.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_structure_asm J ON A.code = J.lv4_code AND A.period = J.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_structure_fsm K ON A.code = K.lv3_code AND A.period = K.periode
LEFT JOIN VISITFLOW_MFTEMP_PROD.temp_mcl_dk_lk L ON B.structure_id = L.structure_id AND B.customer_id = L.customer_id
WHERE A.period = PeriodProses
 AND A.deleted_at IS NULL;
END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_sinkron_ski_vf_cust_ot_category_struct_ot_cust_ot` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_sinkron_ski_vf_cust_ot_category_struct_ot_cust_ot`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_sinkron_ski_vf_cust_ot_category_struct_ot_cust_ot`(IN PeriodProses varchar(6))
BEGIN
-- SINKRON CUSTOMER --
DROP TABLE VISITFLOW_MFTEMP_PROD.customer_temp;
CREATE TABLE VISITFLOW_MFTEMP_PROD.customer_temp
-- CREATE VIEW VISITFLOW_MF_PROD.vw_check_sinkron_customer_ski_vf as
# SELECT * FROM VISITFLOW_MF_PROD.vw_check_sinkron_customer_ski_vf
SELECT A.created_by_id, A.created_at,  A.updated_by_id, A.updated_at, A.deleted_by_id, A.deleted_at, A.id, A.name, A.phone, A.email, A.address,
      CASE WHEN A.gender = 'Male' THEN 'male'
           WHEN A.gender = 'Female' THEN 'female' END AS gender, '1' AS company_id, '' AS customer_api, '' AS image_customer, '' AS image_ktp,
       0 AS ks, '' AS image_name_card, '' AS website, '' AS province, '' AS city, '' AS district, '' AS sub_district,
       A.id AS customer_id_by_company, 'approve' AS status, 'SKI_VISITFLOW' AS KET, customer_specialist_id, customer_position_id
FROM SKI_MF_PROD.customers A
LEFT JOIN VISITFLOW_MF_PROD.customers B ON A.id = B.id
WHERE B.id IS NULL AND A.deleted_at IS NULL;
# SELECT * FROM VISITFLOW_MF_PROD.customers WHERE ID IN (''25110038'')
# SELECT * FROM customers WHERE ID IN (''25110038'')
INSERT VISITFLOW_MF_PROD.customers
(created_by_id, created_at, updated_by_id, updated_at, deleted_by_id, deleted_at, id, name, phone, email, address,
 gender, company_id, customer_api, image_customer, image_ktp, ks, image_name_card, website, province, city, district,
 sub_district, customer_id_by_company, status)
SELECT
created_by_id, created_at, updated_by_id, updated_at, deleted_by_id, deleted_at, id, name, phone, email, address,
gender, company_id, customer_api, image_customer, image_ktp, ks, image_name_card, website, province, city, district,
sub_district, customer_id_by_company, status
FROM VISITFLOW_MFTEMP_PROD.customer_temp;

-- SINKRON CUSTOMER CATEGORY--
INSERT VISITFLOW_MF_PROD.customer_customer_categories
 (created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, customer_id, customer_category_id, customer_position_id, company_id)
SELECT
A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, A.id AS customer_id,
A.customer_specialist_id AS customer_category_id, NULL AS  customer_position_id, '1' AS company_id
FROM VISITFLOW_MFTEMP_PROD.customer_temp A
LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories B ON A.id = B.customer_id
WHERE B.customer_id IS NULL
UNION ALL
SELECT
A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, A.id AS customer_id,
CASE WHEN A.customer_position_id <> 7 THEN 88
                   WHEN A.customer_position_id = 7 THEN 87 ELSE 88 END AS customer_category_id,
       NULL AS  customer_position_id, '1' AS company_id
FROM VISITFLOW_MFTEMP_PROD.customer_temp A
LEFT JOIN VISITFLOW_MF_PROD.customer_customer_categories B ON A.id = B.customer_id
WHERE B.customer_id IS NULL;

# SELECT * FROM VISITFLOW_MF_PROD.customer_customer_categories WHERE customer_id IN (SELECT id FROM VISITFLOW_MFTEMP_PROD.customer_temp)

-- SINKRON OUTLET/LOCATION --
DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.location_temp;
CREATE TABLE VISITFLOW_MFTEMP_PROD.location_temp
SELECT
        A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, A.name, A.latitude, A.longitude, A.address,
        A.id AS no_location_by_company, '' AS location_api, A.city_id AS area_id, '1' AS company_id, '' AS image, '' AS province, '' AS city,
        '' AS district, '' AS sub_district, 0 AS location_group_id, NULL AS location_sub_id, '' AS  area_name, 'approve' AS status,
        NULL AS location_tag, A.class
FROM SKI_MF_PROD.outlets A
LEFT JOIN VISITFLOW_MF_PROD.locations B ON A.id = B.no_location_by_company AND B.deleted_at IS NULL
WHERE A.deleted_at IS NULL AND B.id IS NULL ;

INSERT VISITFLOW_MF_PROD.locations
(id,created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, name, latitude, longitude, address,
 no_location_by_company, location_api, area_id, company_id, image, province, city, district, sub_district, location_group_id,
 location_sub_id, area_name, status, location_tag, class)
SELECT
 no_location_by_company,created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, name, latitude, longitude, address,
 no_location_by_company, location_api, area_id, company_id, image, province, city, district, sub_district, location_group_id,
 location_sub_id, area_name, status, location_tag, class
FROM VISITFLOW_MFTEMP_PROD.location_temp;

# SELECT * FROM SKI_MF_PROD.outlets WHERE id IN
# SELECT * FROM VISITFLOW_MF_PROD.locations WHERE
# SELECT * FROM VISITFLOW_MF_PROD.location_categories
# SELECT * FROM VISITFLOW_MF_PROD.location_subs
# SELECT * FROM VISITFLOW_MF_PROD.location_groups
# SELECT * FROM VISITFLOW_MF_PROD.location_location_categories

-- SINKRON LOCATION CATEGORY --
INSERT VISITFLOW_MF_PROD.location_location_categories
(created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, location_id, location_category_id, company_id)
SELECT
 A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, no_location_by_company AS location_id,
       B.outlet_type_id AS location_category_id, company_id
FROM VISITFLOW_MFTEMP_PROD.location_temp A
JOIN SKI_MF_PROD.outlets B ON A.no_location_by_company = B.id ;

-- SINKRON STRUKTUR LOCATION--
INSERT VISITFLOW_MF_PROD.structure_locations
(created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, period, location_id, structure_id, company_id, out_of_city)
SELECT
A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, A.period, A.outlet_id AS location_id,
A.marketing_structure_id AS structure_id, '1' AS company_id, out_of_city
FROM SKI_MF_PROD.marketing_structure_territory_outlets A
LEFT JOIN VISITFLOW_MF_PROD.structure_locations B ON A.period = B.period AND A.outlet_id = B.location_id AND B.deleted_at IS NULL AND B.period = PeriodProses
WHERE A.deleted_at IS NULL AND A.period =PeriodProses AND B.id IS NULL;
-- SELECT * FROM VISITFLOW_MF_PROD.structure_locations WHERE period =''202511'' AND location_id IN
-- SELECT * FROM SKI_MF_PROD.marketing_structure_territory_outlets WHERE period =''202511'' AND

-- SINKRON CUSTOMER LOCATION--
INSERT VISITFLOW_MF_PROD.customer_locations
(created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, customer_id, start_period, end_period,
 best_hours, work_hours, status, reject_reason, location_id, company_id, user_name, location_name, location_address, customer_name, customer_phone)
SELECT  A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, A.customer_id,
       A.period AS start_period, '999999' AS end_period, '' AS best_hours, '' AS work_hours, 'approve' AS status, '' AS reject_reason,
        A.outlet_id AS location_id, '1' AS company_id, '' AS user_name, C.name AS location_name, C.address AS location_address,
       D.name AS customer_name, D.phone AS customer_phone
-- SELECT A.customer_id  ,A.outlet_id, A.period ,B.location_id, B.start_period, B.end_period
FROM SKI_MF_PROD.customer_territory_outlets A
LEFT JOIN VISITFLOW_MF_PROD.customer_locations B ON A.customer_id = B.customer_id AND B.deleted_at IS NULL
                                  AND A.outlet_id = B.location_id AND A.period BETWEEN B.start_period AND B.end_period
JOIN SKI_MF_PROD.outlets C ON A.outlet_id = C.id AND C.deleted_at IS NULL
JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
WHERE  A.period = PeriodProses
 AND A.deleted_at IS NULL AND B.ID IS NULL;
# SELECT * FROM SKI_MF_PROD.customer_territory_outlets WHERE customer_id IN (''24100119'',''23080456'')
# SELECT * FROM VISITFLOW_MF_PROD.customer_locations where ''202511'' BETWEEN  start_period AND end_period

# SELECT * FROM VISITFLOW_MF_PROD.customers WHERE ID IN ()
# SELECT * FROM VISITFLOW_MF_PROD.locations
# SELECT * FROM VISITFLOW_MF_PROD.customer_locations WHERE customer_id IN ()
# SELECT * FROM SKI_MF_PROD.customer_territory_outlets WHERE customer_id IN () AND period =''202511''
# SELECT * FROM VISITFLOW_MF_PROD.structure_locations WHERE period =''202511'' AND location_id IN ()
# SELECT * FROM SKI_MF_PROD.marketing_structure_territory_outlets WHERE period =''202511'' AND outlet_id IN ()
# SELECT * FROM SKI_MF_PROD.marketing_structure_territory_customers where  customer_id IN ()

-- VF-SKI, ADA VF TIDAK ADA SKI
# SELECT  A.created_at, A.updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id, A.customer_id,
#        A.period AS start_period, ''999999' AS end_period, '''' AS best_hours, '''' AS work_hours, ''approve''AS status, '''' AS reject_reason,
#         A.outlet_id AS location_id, '1' AS company_id, '' AS user_name, C.name AS location_name, C.address AS location_address,
#        D.name AS customer_name, D.phone AS customer_phone
# SELECT A.customer_id,A.location_id, A.start_period, A.end_period, B.customer_id  ,B.outlet_id, B.period
# FROM VISITFLOW_MF_PROD.customer_locations A
# LEFT JOIN SKI_MF_PROD.customer_territory_outlets B ON A.customer_id = B.customer_id AND B.deleted_at IS NULL AND B.period ='202511'
# --                                  AND A.outlet_id = B.location_id AND A.period BETWEEN B.start_period AND B.end_period
# # JOIN SKI_MF_PROD.outlets C ON A.outlet_id = C.id AND C.deleted_at IS NULL
# # JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id AND D.deleted_at IS NULL
# WHERE '202511' BETWEEN start_period AND end_period
#  AND A.deleted_at IS NULL AND B.ID IS NULL'
END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_sinkro_ski_vf_mproduct_mcustcategory_bridprodspesialis` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_sinkro_ski_vf_mproduct_mcustcategory_bridprodspesialis`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_sinkro_ski_vf_mproduct_mcustcategory_bridprodspesialis`()
BEGIN

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_product_no_vf;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_product_no_vf WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_product_no_vf
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_product_no_vf
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_product_no_vf
SELECT A.id, B.id AS product_id, 'vf-ski'  AS flag
FROM VISITFLOW_MF_PROD.products A
LEFT JOIN SKI_MF_PROD.products B ON A.ID = B.id AND B.deleted_at IS NULL
WHERE A.principal ='PT. Metiska Farma' AND IFNULL(A.id,'') <> IFNULL(B.id,'')
      AND A.deleted_at IS NULL
union
SELECT A.id, B.id, 'ski-vf' AS flag
FROM SKI_MF_PROD.products A
LEFT JOIN VISITFLOW_MF_PROD.products B ON A.id = B.id
     AND B.principal ='PT. Metiska Farma' AND B.deleted_at IS NULL
WHERE A.deleted_at IS NULL
  AND IFNULL(A.id,'') <> IFNULL(B.id,'');

INSERT VISITFLOW_MF_PROD.products
(created_by_id, created_at, updated_by_id, updated_at, deleted_by_id, deleted_at, id, name, principal, product_material_id,
 product_category_id, description, image, company_id, update_data)
SELECT
'1' AS created_by_id, NOW() AS created_at, '1' AS updated_by_id, NOW() AS updated_at, NULL AS deleted_by_id, NULL AS deleted_at,
A.id, name, 'PT. Metiska Farma' AS principal, '999' AS product_material_id, '999' AS product_category_id, description, image,
'1' AS company_id, NOW() AS update_data
FROM SKI_MF_PROD.products A
JOIN VISITFLOW_MFTEMP_PROD.temp_product_no_vf B ON A.id = B.id AND flag ='ski-vf';

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf
SELECT A.id, B.id AS spesialis_id , 'ski-vf' AS flag
FROM SKI_MF_PROD.customer_specialists A
LEFT JOIN VISITFLOW_MF_PROD.customer_categories B ON A.id = B.id
      AND B.company_id ='1' AND B.id NOT IN (87, 88) AND B.deleted_at IS NULL
WHERE IFNULL(A.id,'') <> IFNULL(B.id,'') AND A.deleted_at IS NULL
UNION
SELECT A.id, B.id, 'vf-ski' AS flag
FROM VISITFLOW_MF_PROD.customer_categories A
LEFT JOIN SKI_MF_PROD.customer_specialists B ON A.id = B.id AND B.deleted_at IS NULL
WHERE A.company_id ='1' AND A.id NOT IN (87, 88) AND A.deleted_at IS NULL
AND IFNULL(A.id,'') <> IFNULL(B.id,'');

INSERT VISITFLOW_MF_PROD.customer_categories
(id,created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, name, company_id, `group`, code, is_survey)
SELECT
A.id, NOW() AS created_at, NOW() AS updated_at, NULL AS deleted_at, '1' AS created_by_id, '1' AS updated_by_id, NULL AS deleted_by_id,
A.description AS name, '1' AS company_id, NULL AS `group`, NULL AS code, NULL AS is_survey
FROM SKI_MF_PROD.customer_specialists A
JOIN VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf B ON A.id = B.id AND B.flag ='ski-vf';

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_no_vf;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_no_vf WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_no_vf
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_no_vf
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_spesialis_no_vf
SELECT DISTINCT A.customer_category_id, B.id, A.customer_category_name, B.name,'spesialis' AS flag
FROM VISITFLOW_MF_PROD.bridging_product_specialists A
LEFT JOIN VISITFLOW_MF_PROD.customer_categories B ON A.customer_category_id = B.id AND B.deleted_at IS NULL
WHERE  IFNULL(A.customer_category_id,'') <> IFNULL(B.id,'') AND A.deleted_at IS NULL
UNION
SELECT DISTINCT A.id, B.customer_category_id, A.name, B.customer_category_name,'spesialis' AS flag
FROM VISITFLOW_MF_PROD.customer_categories A
LEFT JOIN VISITFLOW_MF_PROD.bridging_product_specialists B ON B.customer_category_id = A.id
     AND B.deleted_at IS NULL
WHERE  IFNULL(A.id,'') <> IFNULL(B.customer_category_id,'') AND A.deleted_at IS NULL
  AND A.company_id =1 AND A.id NOT IN ('87','88');

INSERT VISITFLOW_MF_PROD.bridging_product_specialists
(created_by_id, created_at, updated_by_id, updated_at, deleted_by_id, deleted_at, product_id, product_name, customer_category_id, customer_category_name, description, company_id)
SELECT
'1' AS created_by_id, NULL AS created_at, '1' AS updated_by_id, NULL AS updated_at, NULL AS deleted_by_id, NULL AS deleted_at,
C.id AS product_id, C.name AS product_name, A.id AS customer_category_id, A.name AS customer_category_name, 'OTHERS' AS description, '1' AS company_id
FROM VISITFLOW_MF_PROD.customer_categories A
JOIN VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_no_vf B ON A.id = B.customer_category_id
JOIN VISITFLOW_MF_PROD.products C ON C.principal ='PT. Metiska Farma' AND C.deleted_at IS NULL
WHERE  A.deleted_at IS NULL;

DROP TABLE IF EXISTS VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_product_no_vf;
# DELETE FROM VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_product_no_vf WHERE period = PeriodProses;
# SELECT * FROM VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_product_no_vf
CREATE TABLE VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_product_no_vf
# INSERT INTO VISITFLOW_MFTEMP_PROD.temp_spesialis_product_no_vf
SELECT DISTINCT A.customer_category_id, A.customer_category_name, A.product_id,A.product_name, B.id, 'spesialis_product' AS flag
FROM VISITFLOW_MF_PROD.bridging_product_specialists A
LEFT JOIN VISITFLOW_MF_PROD.products B ON A.product_id = B.id AND B.deleted_at IS NULL
    AND A.company_id = B.company_id AND B.principal ='PT. Metiska Farma'
WHERE  IFNULL(A.product_id,'') <> IFNULL(B.id,'') AND A.deleted_at IS NULL
     AND A.company_id =1
UNION
SELECT DISTINCT B.id, B.name, A.id, A.name AS product_name, C.product_id, 'spesialis_product' AS flag
FROM VISITFLOW_MF_PROD.products A
JOIN VISITFLOW_MF_PROD.customer_categories B ON B.deleted_at IS NULL AND B.company_id ='1' AND B.id NOT IN ('87','88')
LEFT JOIN VISITFLOW_MF_PROD.bridging_product_specialists C ON A.id = C.product_id AND C.deleted_at IS NULL
           AND C.company_id = C.company_id AND B.id = C.customer_category_id
WHERE IFNULL(A.id,'') <> IFNULL(C.product_id,'') AND A.deleted_at IS NULL
   AND A.company_id =1 AND A.principal ='PT. Metiska Farma';


INSERT VISITFLOW_MF_PROD.bridging_product_specialists
(created_by_id, created_at, updated_by_id, updated_at, deleted_by_id, deleted_at, product_id, product_name, customer_category_id, customer_category_name, description, company_id)
SELECT
'1' AS created_by_id, NULL AS created_at, '1' AS updated_by_id, NULL AS updated_at, NULL AS deleted_by_id, NULL AS deleted_at,
A.product_id AS product_id, A.product_name AS product_name, A.customer_category_id AS customer_category_id, A.customer_category_name AS customer_category_name,
    'OTHERS' AS description, '1' AS company_id
FROM VISITFLOW_MFTEMP_PROD.temp_bridging_product_spesialis_product_no_vf A
JOIN (SELECT DISTINCT product_id
      FROM SKI_MF_PROD.sales_ffs
      WHERE period >='202505'
) B ON A.product_id = B.product_id;

END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_proses_vf_next_structurlocation_visit_customer_office_user` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_proses_vf_next_structurlocation_visit_customer_office_user`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_proses_vf_next_structurlocation_visit_customer_office_user`(IN PeriodProses varchar(6))
BEGIN
  -- Semua deklarasi variable lebih dulu
  DECLARE _error BOOL DEFAULT FALSE;
  DECLARE _pesan VARCHAR(255) DEFAULT '';

  -- Deklarasi handler global
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 'Terjadi error pada proses. Transaksi dibatalkan.' AS pesan;
  END;

  START TRANSACTION;
  -- sebelum proses sp ini proses sp struktur dlu dari ski_compliance sp_proses_structure_ski_vf_structurbos_structurlocationnon
    CALL  SKI_MF_PROD.sp_proses_structure_ski_vf_structurbos_structurlocationnon (PeriodProses);
#     SELECT  * FROM VISITFLOW_MF_PROD.structures WHERE period ='202511'
#     SELECT  * FROM VISITFLOW_MF_PROD.structure_locations WHERE period ='202511'
#     SELECT  *  FROM VISITFLOW_MF_PROD.visit_customers WHERE period ='202511'
#     CALL sp_proses_vf_next_structurlocation_visit_customer_office_user ('202511')

  proses1: BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET _error = TRUE;

    -- insert struktur location non location
    INSERT VISITFLOW_MF_PROD.structure_locations
    (created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, period, location_id, structure_id, company_id, out_of_city)
    SELECT
    NOW() AS created_at, NOW() AS updated_at, NULL AS deleted_at, NULL AS created_by_id, NULL AS updated_by_id, NULL AS deleted_by_id,
    PeriodProses AS period, A.location_id, A.structure_id AS structure_id, 1 AS company_id,  A.out_of_city
    FROM VISITFLOW_MF_PROD.structure_locations A
    JOIN VISITFLOW_MF_PROD.structures B ON A.structure_id = B.id AND B.deleted_at IS NULL AND B.period = PeriodProses
    LEFT JOIN VISITFLOW_MF_PROD.structure_locations C ON C.period = PeriodProses AND A.structure_id = C.structure_id
                                       AND A.location_id = C.location_id
    WHERE A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProses,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m')
         AND A.deleted_at IS NULL
         AND C.location_id IS NULL;

    IF _error THEN
      SET _pesan = 'Gagal pada proses 1: INSERT VISITFLOW_MF_PROD.structure_locations NEXT';
      ROLLBACK;
      SELECT _pesan AS pesan;
      LEAVE proses1;
    END IF;
  END proses1;

  -- Reset error
  SET _error = FALSE;

  -- ========================
  -- PROSES 2

  proses2: BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET _error = TRUE;

    -- INSERT VISIT CUSTOMER
    INSERT VISITFLOW_MF_PROD.visit_customers
    (created_at, updated_at, deleted_at, created_by_id, updated_by_id, deleted_by_id, period, customer_name,
     customer_phone, priority, type, status, level, approved_structure_id, approved_time, structure_id, user_id,
     user_name, customer_id, location_id, company_id, rejected_structure_id, note, rejected_time)
    SELECT
     NOW() AS created_at, NOW() AS updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id,
     PeriodProses AS period, CASE WHEN D.name IS NOT NULL THEN D.name ELSE A.customer_name END AS customer_name, 
     A.customer_phone, A.priority, A.type, A.status, A.level, A.approved_structure_id,
     A.approved_time, A.structure_id, A.user_id, A.user_name, A.customer_id, A.location_id, A.company_id, A.rejected_structure_id,
     NULL AS note, A.rejected_time
     FROM VISITFLOW_MF_PROD.visit_customers A
     JOIN VISITFLOW_MF_PROD.structures B ON A.structure_id = B.id AND B.deleted_at IS NULL AND B.period = PeriodProses
     LEFT JOIN VISITFLOW_MF_PROD.visit_customers C ON C.period = PeriodProses AND A.structure_id = C.structure_id
                                      AND C.location_id = '' AND A.customer_id = C.customer_id AND C.deleted_at IS NULL
     LEFT JOIN SKI_MF_PROD.customers D ON A.customer_id = D.id  
     WHERE A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProses,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m')
     AND A.deleted_at IS NULL
     AND A.status = 'approved'
     AND A.location_id = ''
     AND C.customer_id IS NULL
    UNION ALL
    SELECT
     NOW() AS created_at, NOW() AS updated_at, A.deleted_at, A.created_by_id, A.updated_by_id, A.deleted_by_id,
     PeriodProses AS period, A.customer_name, A.customer_phone, A.priority, A.type, A.status, A.level, A.approved_structure_id,
     A.approved_time, A.structure_id, A.user_id, A.user_name, A.customer_id, A.location_id, A.company_id, A.rejected_structure_id,
     NULL AS note, A.rejected_time
     FROM VISITFLOW_MF_PROD.visit_customers A
     JOIN VISITFLOW_MF_PROD.structures B ON A.structure_id = B.id AND B.deleted_at IS NULL AND B.period = PeriodProses
     LEFT JOIN VISITFLOW_MF_PROD.visit_customers C ON C.period = PeriodProses AND A.structure_id = C.structure_id
                                      AND C.location_id <> '' AND A.location_id = C.location_id AND C.deleted_at IS NULL
     WHERE A.period = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT(PeriodProses,'01'), '%Y%m%d'), INTERVAL 1 MONTH),'%Y%m')
     AND A.deleted_at IS NULL
     AND A.status = 'approved'
     AND A.location_id <> ''
     AND C.location_id IS NULL;

    IF _error THEN
      SET _pesan = 'Gagal pada proses 2: INSERT VISITFLOW_MF_PROD.visit_customers NEXT';
      ROLLBACK;
      SELECT _pesan AS pesan;
      LEAVE proses2;
    END IF;
   END proses2;
  --  Reset error
    SET _error = FALSE;

  -- ========================
  -- PROSES 3
  proses3: BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET _error = TRUE;

    SELECT A.user_id, A.id, B.user_id, C.name
    FROM VISITFLOW_MF_PROD.structures A
    LEFT JOIN VISITFLOW_MF_PROD.office_users B ON A.user_id = B.user_id AND B.deleted_at IS NULL
    LEFT JOIN VISITFLOW_MF_PROD.users C ON A.user_id = C.id
    WHERE A.period=PeriodProses
       AND A.deleted_at IS NULL
       AND A.user_id IS NOT NULL
       AND B.user_id IS NULL;

    IF _error THEN
      SET _pesan = 'Gagal pada proses 3: LIST FROM VISITFLOW_MF_PROD.office_user BELUM ADA';
      ROLLBACK;
      SELECT _pesan AS pesan;
      LEAVE proses3;
    END IF;
  END proses3;
  --  Reset error
    SET _error = FALSE;

  -- ========================
  -- PROSES 4
  proses4: BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET _error = TRUE;

    UPDATE VISITFLOW_MF_PROD.customer_locations A
    JOIN SKI_MF_PROD.customers B ON A.customer_id = B.id
    SET A.customer_name = B.name;
    
    UPDATE VISITFLOW_MF_PROD.customer_locations A
    JOIN SKI_MF_PROD.outlets B ON A.location_id = B.id
    SET A.location_name = B.name;

    UPDATE VISITFLOW_MF_PROD.visit_customers A
    JOIN SKI_MF_PROD.customers B ON A.customer_id = B.id
    SET A.customer_name = B.name
    WHERE A.period = PeriodProses; 
    
    UPDATE VISITFLOW_MF_PROD.visits A
    JOIN SKI_MF_PROD.customers B ON A.customer_id = B.id
    SET A.customer_name = B.name
    WHERE A.period = PeriodProses; 

    UPDATE VISITFLOW_MF_PROD.visits A
    JOIN SKI_MF_PROD.outlets B ON A.location_id = B.id
    SET A.location_name = B.name
    WHERE A.period = PeriodProses; 
    
    IF _error THEN
      SET _pesan = 'Gagal pada proses 4: UPDATE CUSTOMER NAME AND LOCATION NAME';
      ROLLBACK;
      SELECT _pesan AS pesan;
      LEAVE proses4;
    END IF;
  END proses4;

  COMMIT;
# select * from VISITFLOW_MF_PROD.structures where period ='202512'
# select * from VISITFLOW_MF_PROD.structure_bos
# select * from VISITFLOW_MF_PROD.structure_locations where period ='202512'
# select * from delete from VISITFLOW_MF_PROD.structure_locations where period ='202512'
# select * from VISITFLOW_MF_PROD.visit_customers where period ='202512'
# select * from VISITFLOW_MF_PROD.visits where period ='202512'
# select a.structure_id, a.customer_id, a.location_id,b.customer_id,b.structure_id, b.location_id
# from VISITFLOW_MF_PROD.visits a
# left join VISITFLOW_MF_PROD.visit_customers b on a.period = b.period and a.structure_id= b.structure_id and a.customer_id =b.customer_id
# where a.period ='202512'


  -- Jika sampai sini, berarti semua sukses
  SELECT 'Semua proses berhasil, insert structure_locations, insert visit_customers,  update customer_locations, visit_customer, visit ' AS pesan;



END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_regenerate_calendar` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_regenerate_calendar`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_regenerate_calendar`(IN p_year INT, IN p_company_id BIGINT, IN p_user_id BIGINT)
BEGIN DECLARE v_start_date DATE;

DECLARE v_end_date DATE;

SET
	v_start_date = STR_TO_DATE(CONCAT(p_year, '-01-01'), '%Y-%m-%d');

SET
	v_end_date = STR_TO_DATE(CONCAT(p_year, '-12-31'), '%Y-%m-%d');

START TRANSACTION;

INSERT INTO
	calendar_historys (id, created_at, updated_at, created_by_id, updated_by_id, deleted_by_id, DATE, title, description, is_mkt, is_non_mkt, company_id)
SELECT
	id,
	NOW(),
	updated_at,
	created_by_id,
	updated_by_id,
	p_user_id,
	DATE,
	title,
	description,
	is_mkt,
	is_non_mkt,
	company_id
FROM
	calendars
WHERE
	company_id = p_company_id
	AND DATE BETWEEN v_start_date AND v_end_date;

DELETE FROM calendars
WHERE
	company_id = p_company_id
	AND DATE BETWEEN v_start_date AND v_end_date;

INSERT INTO
	calendars (created_at, updated_at, created_by_id, updated_by_id, deleted_by_id, DATE, title, description, is_mkt, is_non_mkt, company_id)
WITH RECURSIVE
	date_series AS (
		SELECT
			v_start_date AS dt
		UNION ALL
		SELECT
			DATE_ADD(dt, INTERVAL 1 DAY)
		FROM
			date_series
		WHERE
			dt < v_end_date
	)
SELECT
	NOW(),
	NULL,
	p_user_id,
	NULL,
	NULL,
	dt,
	DAYNAME(dt),
	CASE
		WHEN DATE_FORMAT(dt, '%m-%d') = '01-01' THEN 'Tahun Baru Masehi'
		WHEN DATE_FORMAT(dt, '%m-%d') = '06-01' THEN 'Hari Lahir Pancasila'
		WHEN DATE_FORMAT(dt, '%m-%d') = '12-25' THEN 'Hari Raya Natal'
		WHEN DAYOFWEEK(dt) IN (1, 7) THEN 'Hari libur akhir pekan'
		ELSE 'Hari kerja biasa'
	END,
	0,
	0,
	p_company_id
FROM
	date_series;

COMMIT;

END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `sp_report_summary_mcl` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_report_summary_mcl`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `sp_report_summary_mcl`(IN PeriodFilter varchar(6), IN StructureFilter varchar(10),
                                                         IN PositionFilter varchar(6), IN BossFilter varchar(10))
BEGIN

WITH filtered_structures AS (
    SELECT
        s.period,
        s.id AS structure_id,
        s.user_id,
        s.level,
        s.boss_code,
        s.company_id,
        u.user_name AS name,
        sp.name AS position
    FROM structures s
    LEFT JOIN users u
        ON u.id = s.user_id
    INNER JOIN structure_positions sp
        ON sp.level = s.level
        AND sp.company_id = s.company_id
        AND sp.deleted_at IS NULL
    WHERE s.period = PeriodFilter
      AND s.deleted_at IS NULL
) -- SELECT * FROM filtered_structures
,

visit_customer_base AS (
    SELECT
        vc.period,
        vc.structure_id,
        vc.customer_id,
        CASE WHEN vc.customer_id <> 'NON' THEN 1 ELSE 0 END AS is_user,
        MAX( CASE WHEN IFNULL(vc.out_of_city, 0) = 0 THEN 1 ELSE 0 END) AS has_dk,
        MAX( CASE WHEN IFNULL(vc.out_of_city, 0) = 1 THEN 1 ELSE 0 END) AS has_lk,
        MAX( CASE WHEN IFNULL(vc.cluster, '') <> '' THEN 1 ELSE 0 END) AS has_recommendation
    FROM visit_customers vc
    INNER JOIN filtered_structures fs
        ON fs.period = vc.period
        AND fs.structure_id = vc.structure_id
    WHERE vc.period = PeriodFilter
      AND vc.deleted_at IS NULL
      AND vc.status = 'approved'
      AND vc.customer_id IS NOT NULL
    GROUP BY vc.period, vc.structure_id, vc.customer_id
),

customer_coverage AS (
    SELECT vcb.*,
        CASE WHEN EXISTS ( SELECT 1
                           FROM visits v
                           WHERE v.period = vcb.period
                              AND v.structure_id = vcb.structure_id
                              AND v.customer_id = vcb.customer_id
                              AND v.type = 'call'
                              AND v.status IN ('check-out','realization-approved')
                              AND v.deleted_at IS NULL
                          ) THEN 1 ELSE 0 END AS is_covered
    FROM visit_customer_base vcb
),

user_statistics AS (
    SELECT
        period,
        structure_id,

        SUM(is_user) AS mcl_user_all,
        SUM(is_user * has_dk) AS mcl_user_dk_all,
        SUM(is_user * has_lk) AS mcl_user_lk_all,
        SUM(is_user * has_recommendation)
            AS mcl_user_recommendation,

        SUM(is_covered) AS coverage_user_all,
        SUM(is_covered * has_dk) AS coverage_user_dk_all,
        SUM(is_covered * has_lk) AS coverage_user_lk_all,
        SUM(is_covered * has_recommendation)
            AS coverage_user_recommendation,

        SUM(is_user * (1 - is_covered))
            AS uncovered_user_all,

        SUM(is_user * has_dk * (1 - is_covered))
            AS uncovered_user_dk_all,

        SUM(is_user * has_lk * (1 - is_covered))
            AS uncovered_user_lk_all,

        SUM(
            is_user
            * has_recommendation
            * (1 - is_covered)
        ) AS uncovered_user_recommendation
    FROM customer_coverage
    GROUP BY
        period,
        structure_id
),

visit_location_base AS (
    SELECT
        vc.period,
        vc.structure_id,
        vc.location_id,
        MAX(CASE WHEN vc.customer_id = 'NON' THEN 1 ELSE 0 END) AS is_outlet,
        MAX(CASE WHEN vc.customer_id = 'NON' AND IFNULL(vc.out_of_city, 0) = 0 THEN 1 ELSE 0 END ) AS is_outlet_dk,
        MAX(CASE WHEN vc.customer_id = 'NON' AND IFNULL(vc.out_of_city, 0) = 1 THEN 1 ELSE 0 END ) AS is_outlet_lk,
        MAX(CASE WHEN IFNULL(vc.out_of_city, 0) = 0 THEN 1 ELSE 0 END) AS has_dk,
        MAX(CASE WHEN IFNULL(vc.out_of_city, 0) = 1 THEN 1 ELSE 0 END) AS has_lk
    FROM visit_customers vc
    INNER JOIN filtered_structures fs
        ON fs.period = vc.period
        AND fs.structure_id = vc.structure_id
    WHERE vc.period = PeriodFilter
      AND vc.deleted_at IS NULL
      AND vc.status = 'approved'
      AND vc.location_id IS NOT NULL
    GROUP BY
        vc.period,
        vc.structure_id,
        vc.location_id
),

location_coverage AS (
    SELECT
        vlb.*,
        CASE
            WHEN EXISTS ( SELECT 1
                          FROM visits v
                            WHERE v.period = vlb.period
                              AND v.structure_id = vlb.structure_id
                              AND v.location_id = vlb.location_id
                              AND v.type = 'call outlet'
                              AND v.status IN ('check-out','realization-approved')
                              AND v.deleted_at IS NULL
                        ) THEN 1 ELSE 0 END AS is_covered
    FROM visit_location_base vlb
),

outlet_statistics AS (
    SELECT
        period,
        structure_id,

        SUM(is_outlet) AS mcl_outlet_all,
        SUM(is_outlet_dk) AS mcl_outlet_dk_all,
        SUM(is_outlet_lk) AS mcl_outlet_lk_all,

        SUM(is_covered) AS coverage_outlet_all,
        SUM(is_covered * has_dk)
            AS coverage_outlet_dk_all,
        SUM(is_covered * has_lk)
            AS coverage_outlet_lk_all,

        SUM(is_outlet * (1 - is_covered))
            AS uncovered_outlet_all,

        SUM(is_outlet_dk * (1 - is_covered))
            AS uncovered_outlet_dk_all,

        SUM(is_outlet_lk * (1 - is_covered))
            AS uncovered_outlet_lk_all
    FROM location_coverage
    GROUP BY
        period,
        structure_id
)

SELECT
    fs.period,
    fs.structure_id,
    fs.user_id,
    fs.name,
    fs.position,

    CASE
        WHEN fs.level = 1 THEN fs.boss_code
        WHEN fs.level = 2 THEN fs.structure_id
        ELSE ''
    END AS LV2,

    CASE
        WHEN fs.level = 1 THEN s2.boss_code
        WHEN fs.level = 2 THEN s2.id
        WHEN fs.level = 3 THEN fs.structure_id
        ELSE ''
    END AS LV3,

    CASE
        WHEN fs.level = 1 THEN s3.boss_code
        WHEN fs.level = 2 THEN s3.id
        WHEN fs.level = 3 THEN fs.boss_code
        WHEN fs.level = 4 THEN fs.structure_id
        ELSE ''
    END AS LV4,

    IFNULL(us.mcl_user_all, 0)
        AS mcl_user_all,

    IFNULL(us.mcl_user_dk_all, 0)
        AS mcl_user_dk_all,

    IFNULL(us.mcl_user_lk_all, 0)
        AS mcl_user_lk_all,

    IFNULL(us.mcl_user_recommendation, 0)
        AS mcl_user_recommendation,

    IFNULL(os.mcl_outlet_all, 0)
        AS mcl_outlet_all,

    IFNULL(os.mcl_outlet_dk_all, 0)
        AS mcl_outlet_dk_all,

    IFNULL(os.mcl_outlet_lk_all, 0)
        AS mcl_outlet_lk_all,

    IFNULL(us.coverage_user_all, 0)
        AS coverage_user_all,

    IFNULL(us.coverage_user_dk_all, 0)
        AS coverage_user_dk_all,

    IFNULL(us.coverage_user_lk_all, 0)
        AS coverage_user_lk_all,

    IFNULL(us.coverage_user_recommendation, 0)
        AS coverage_user_recommendation,

    IFNULL(os.coverage_outlet_all, 0)
        AS coverage_outlet_all,
IFNULL(os.coverage_outlet_dk_all, 0)
        AS coverage_outlet_dk_all,

    IFNULL(os.coverage_outlet_lk_all, 0)
        AS coverage_outlet_lk_all,

    IFNULL(us.uncovered_user_all, 0)
        AS uncovered_user_all,

    IFNULL(us.uncovered_user_dk_all, 0)
        AS uncovered_user_dk_all,

    IFNULL(us.uncovered_user_lk_all, 0)
        AS uncovered_user_lk_all,

    IFNULL(us.uncovered_user_recommendation, 0)
        AS uncovered_user_recommendation,

    IFNULL(os.uncovered_outlet_all, 0)
        AS uncovered_outlet_all,

    IFNULL(os.uncovered_outlet_dk_all, 0)
        AS uncovered_outlet_dk_all,

    IFNULL(os.uncovered_outlet_lk_all, 0)
        AS uncovered_outlet_lk_all

FROM filtered_structures fs

LEFT JOIN user_statistics us
    ON us.period = fs.period
    AND us.structure_id = fs.structure_id

LEFT JOIN outlet_statistics os
    ON os.period = fs.period
    AND os.structure_id = fs.structure_id

LEFT JOIN structures s2
    ON s2.id = fs.boss_code
    AND s2.period = fs.period
    AND s2.deleted_at IS NULL

LEFT JOIN structures s3
    ON s3.id = s2.boss_code
    AND s3.period = s2.period
    AND s3.deleted_at IS NULL
WHERE fs.period = PeriodFilter
    AND (StructureFilter = '' OR fs.structure_id =StructureFilter )
    AND (PositionFilter = '' OR fs.position = PositionFilter)
    AND (BossFilter = ''
         OR
        CASE WHEN fs.level = 1 THEN fs.boss_code
             WHEN fs.level = 2 THEN fs.structure_id ELSE '' END = BossFilter
        OR
        CASE WHEN fs.level = 1 THEN s2.boss_code
             WHEN fs.level = 2 THEN s2.id
             WHEN fs.level = 3 THEN fs.structure_id ELSE '' END = BossFilter
       OR
       CASE WHEN fs.level = 1 THEN s3.boss_code
             WHEN fs.level = 2 THEN s3.id
             WHEN fs.level = 3 THEN fs.boss_code
             WHEN fs.level = 4 THEN fs.structure_id ELSE '' END = BossFilter);
end ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `temp` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `temp`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `temp`(
    IN PeriodProses DATE,        -- Bisa tanggal spesifik atau awal bulan
    IN userId VARCHAR(50),
    IN limitData INT,
    IN pageData INT,
    IN filter_type VARCHAR(10)   -- 'day' = tanggal spesifik, 'month' = seluruh bulan
)
BEGIN

DECLARE offsetData INT;
SET offsetData = (pageData - 1) * limitData;

-- CTE BASE: ambil users, calendars, jam kerja, presensi
WITH base AS (
    SELECT
        u.id AS user_id,
        u.name AS recognized_name,
        u.department,
        c.date,
        c.description,  -- deskripsi kalender, misal 'Hari Kerja' / 'Libur Nasional'
        DATE_FORMAT(c.date,'%Y%m') AS period,

        wh.day1_in, wh.day1_out,
        wh.day2_in, wh.day2_out,
        wh.day3_in, wh.day3_out,
        wh.day4_in, wh.day4_out,
        wh.day5_in, wh.day5_out,
        wh.day6_in, wh.day6_out,
        wh.day7_in, wh.day7_out,

        MIN(p.in_date_time) AS in_date_time,
        MAX(p.out_date_time) AS out_date_time

    FROM VISITFLOW_MF_PROD.calendars c
    JOIN VISITFLOW_MF_PROD.users u
        ON u.company_id = c.company_id

    LEFT JOIN VISITFLOW_MF_PROD.presences p
        ON p.user_id = u.id
        AND DATE(p.in_date_time + INTERVAL 7 HOUR) = c.date
        AND p.deleted_at IS NULL

    LEFT JOIN (
        SELECT whu1.*
        FROM VISITFLOW_MF_PROD.work_hour_users whu1
        INNER JOIN (
            SELECT user_id, MAX(id) AS max_id
            FROM VISITFLOW_MF_PROD.work_hour_users
            GROUP BY user_id
        ) x ON x.max_id = whu1.id
    ) whu ON whu.user_id = u.id

    LEFT JOIN VISITFLOW_MF_PROD.work_hours wh
        ON wh.id = whu.work_hour_id

    WHERE
        c.company_id = 1
        AND (userId IS NULL OR u.id = userId)
        -- Filter fleksibel: tanggal spesifik atau seluruh bulan
        AND (
            (filter_type = 'month' AND DATE_FORMAT(c.date,'%Y-%m-01') = PeriodProses)
            OR
            (filter_type = 'day' AND c.date = PeriodProses)
        )

    GROUP BY
        u.id, c.date, c.description,
        wh.day1_in, wh.day1_out,
        wh.day2_in, wh.day2_out,
        wh.day3_in, wh.day3_out,
        wh.day4_in, wh.day4_out,
        wh.day5_in, wh.day5_out,
        wh.day6_in, wh.day6_out,
        wh.day7_in, wh.day7_out
),

-- CTE SHIFT_CALC: hitung shift_in / shift_out sesuai hari
shift_calc AS (
    SELECT
        b.*,
        CASE DAYOFWEEK(b.date)
            WHEN 1 THEN b.day7_in
            WHEN 2 THEN b.day1_in
            WHEN 3 THEN b.day2_in
            WHEN 4 THEN b.day3_in
            WHEN 5 THEN b.day4_in
            WHEN 6 THEN b.day5_in
            WHEN 7 THEN b.day6_in
        END AS work_hour_in,
        CASE DAYOFWEEK(b.date)
            WHEN 1 THEN b.day7_out
            WHEN 2 THEN b.day1_out
            WHEN 3 THEN b.day2_out
            WHEN 4 THEN b.day3_out
            WHEN 5 THEN b.day4_out
            WHEN 6 THEN b.day5_out
            WHEN 7 THEN b.day6_out
        END AS work_hour_out
    FROM base b
),

-- CTE TIME_CALC: hitung late_minutes, format checkin/checkout, nama hari bahasa indonesia
time_calc AS (
    SELECT
        s.*,
        (s.in_date_time + INTERVAL 7 HOUR) AS presence_check_in,
        (s.out_date_time + INTERVAL 7 HOUR) AS presence_check_out,
        CASE DAYOFWEEK(s.date)
            WHEN 1 THEN 'Minggu'
            WHEN 2 THEN 'Senin'
            WHEN 3 THEN 'Selasa'
            WHEN 4 THEN 'Rabu'
            WHEN 5 THEN 'Kamis'
            WHEN 6 THEN 'Jumat'
            WHEN 7 THEN 'Sabtu'
        END AS day_name,
        GREATEST(
            TIMESTAMPDIFF(
                MINUTE,
                STR_TO_DATE(CONCAT(s.date,' ',s.work_hour_in),'%Y-%m-%d %H:%i'),
                (s.in_date_time + INTERVAL 7 HOUR)
            ),0
        ) AS late_minutes
    FROM shift_calc s
),

-- CTE RULE_MATCH: hitung penalty dengan grace_days
rule_match AS (
    SELECT
        t.*,
        ad.penalty_amount,
        ad.grace_days,
        COUNT(*) OVER (
            PARTITION BY t.user_id, t.period, ad.id
            ORDER BY t.date
        ) AS late_count
    FROM time_calc t
    LEFT JOIN VISITFLOW_MF_PROD.attendance_deductions ad
        ON ad.company_id = 1
        AND ad.period = t.period
        AND t.late_minutes BETWEEN ad.late_start AND ad.late_end
)

-- SELECT FINAL
SELECT
    r.day_name,
    r.date,
    DATE_FORMAT(r.presence_check_in,'%Y-%m-%d %H:%i:%s') AS presence_check_in,
    DATE_FORMAT(r.presence_check_out,'%Y-%m-%d %H:%i:%s') AS presence_check_out,
    r.work_hour_in,
    r.work_hour_out,
    r.late_minutes,
    CASE
        WHEN r.work_hour_in IS NULL OR r.description <> 'Hari Kerja' THEN 'Libur'
        WHEN r.presence_check_in IS NULL THEN 'Absen Kosong'
        WHEN r.late_minutes > 0 THEN 'Telat'
        ELSE 'Tepat Waktu'
    END AS status,
    CASE
        WHEN r.late_minutes = 0 THEN 0
        WHEN r.grace_days > 0 AND r.late_count <= r.grace_days THEN 0
        ELSE IFNULL(r.penalty_amount,0)
    END AS penalty_amount
FROM rule_match r
ORDER BY r.user_id, r.date
LIMIT limitData OFFSET offsetData;

END ;;
DELIMITER ;

-- --------------------------------------------------------------------
-- Routine structure for `updateNameDeptEmpty` (PROCEDURE)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `updateNameDeptEmpty`;
DELIMITER ;;
CREATE DEFINER=`ridwan`@`%` PROCEDURE `updateNameDeptEmpty`()
BEGIN
UPDATE presences
JOIN users ON presences.user_id = users.id
SET presences.in_recognized_name = users.name
WHERE presences.in_recognized_name IS NULL;

UPDATE presences
JOIN users ON presences.user_id = users.id
SET presences.in_recognized_name = users.name
WHERE presences.in_recognized_name = '';

UPDATE presences
JOIN users ON presences.user_id = users.id
SET presences.out_recognized_name = users.name
WHERE presences.out_recognized_name = '';

UPDATE presences
JOIN users ON presences.user_id = users.id
SET presences.out_recognized_name = users.name
WHERE presences.out_recognized_name IS NULL;

UPDATE presences
JOIN users ON presences.user_id = users.id
SET presences.dept = users.dept
WHERE presences.dept = '';

UPDATE presences
JOIN users ON presences.user_id = users.id
SET presences.dept = users.dept
WHERE presences.dept IS NULL;
END ;;
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;