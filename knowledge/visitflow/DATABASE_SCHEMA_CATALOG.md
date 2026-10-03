# VisitFlow Database Schema Catalog (`VISITFLOW_MF_PROD`)

> **Last Updated**: 2026-09-24 04:35:57
> **Standard Collation**: `utf8mb4_0900_ai_ci`

> **Usage:** Snapshot metadata, not a live count or proof of the selected runtime schema. `Approx Rows` is an estimate from this snapshot; never use it to answer “total call hari ini”. Read the relevant table keys/types/indexes after tracing code, then verify target metadata when needed. Root [AGENTS.md](AGENTS.md) defines the answer contract. Differences from `DATABASE_SCHEMA.md` must be reported rather than silently merged.

## 1. Base Tables Summary

Total Base Tables: **89**

| No | Table Name | Collation | Approx Rows | Data Size (KB) | Index Size (KB) |
|---|---|---|---|---|---|
| 1 | `approvals` | `utf8mb4_0900_ai_ci` | 167,436 | 507,552.0 | 61,520.0 |
| 2 | `area_recomendation_estimations` | `utf8mb4_0900_ai_ci` | 952 | 144.0 | 240.0 |
| 3 | `areas` | `utf8mb4_0900_ai_ci` | 435 | 64.0 | 80.0 |
| 4 | `attendance_corrections` | `utf8mb4_0900_ai_ci` | 230 | 96.0 | 128.0 |
| 5 | `attendance_deductions` | `utf8mb4_0900_ai_ci` | 48 | 16.0 | 192.0 |
| 6 | `bridging_product_specialists` | `utf8mb4_0900_ai_ci` | 3,965 | 1,552.0 | 560.0 |
| 7 | `calendar_historys` | `utf8mb4_0900_ai_ci` | 730 | 96.0 | 0.0 |
| 8 | `calendars` | `utf8mb4_0900_ai_ci` | 731 | 96.0 | 352.0 |
| 9 | `call_daily_visit_all` | `utf8mb4_0900_ai_ci` | 144,912 | 88,880.0 | 83,360.0 |
| 10 | `call_details` | `utf8mb4_0900_ai_ci` | 260,794 | 152,336.0 | 136,192.0 |
| 11 | `call_targets` | `utf8mb4_0900_ai_ci` | 1,883 | 240.0 | 80.0 |
| 12 | `categories` | `utf8mb4_0900_ai_ci` | 0 | 16.0 | 48.0 |
| 13 | `companies` | `utf8mb4_0900_ai_ci` | 3 | 16.0 | 48.0 |
| 14 | `company_rules` | `utf8mb4_0900_ai_ci` | 15 | 16.0 | 0.0 |
| 15 | `configs` | `utf8mb4_0900_ai_ci` | 292 | 96.0 | 48.0 |
| 16 | `confirmation_statuses` | `utf8mb4_0900_ai_ci` | 28 | 16.0 | 32.0 |
| 17 | `customer_addresses` | `utf8mb4_0900_ai_ci` | 142 | 64.0 | 48.0 |
| 18 | `customer_categories` | `utf8mb4_0900_ai_ci` | 69 | 16.0 | 96.0 |
| 19 | `customer_cluster_histories` | `utf8mb4_0900_ai_ci` | 5,773 | 1,440.0 | 512.0 |
| 20 | `customer_customer_categories` | `utf8mb4_0900_ai_ci` | 91,388 | 7,696.0 | 33,456.0 |
| 21 | `customer_drafts` | `utf8mb4_0900_ai_ci` | 0 | 16.0 | 0.0 |
| 22 | `customer_families` | `utf8mb4_0900_ai_ci` | 9 | 16.0 | 32.0 |
| 23 | `customer_locations` | `utf8mb4_0900_ai_ci` | 171,903 | 38,544.0 | 144,848.0 |
| 24 | `customer_logs` | `utf8mb4_0900_ai_ci` | 22,995 | 2,576.0 | 1,552.0 |
| 25 | `customers` | `utf8mb4_0900_ai_ci` | 51,642 | 7,696.0 | 22,160.0 |
| 26 | `departments` | `utf8mb4_0900_ai_ci` | 0 | 16.0 | 0.0 |
| 27 | `distributors` | `utf8mb4_0900_ai_ci` | 13 | 16.0 | 0.0 |
| 28 | `html_services` | `utf8mb4_0900_ai_ci` | 57,607 | 4,592,656.0 | 22,144.0 |
| 29 | `incentive_recomendations` | `utf8mb4_0900_ai_ci` | 1,202 | 304.0 | 432.0 |
| 30 | `incentive_recommendation_parameters` | `utf8mb4_0900_ai_ci` | 33 | 16.0 | 0.0 |
| 31 | `incentive_users` | `utf8mb4_0900_ai_ci` | 162 | 48.0 | 96.0 |
| 32 | `leave_categories` | `utf8mb4_0900_ai_ci` | 14 | 16.0 | 96.0 |
| 33 | `leave_category_qoutas` | `utf8mb4_0900_ai_ci` | 0 | 16.0 | 112.0 |
| 34 | `leave_periods` | `utf8mb4_0900_ai_ci` | 5 | 16.0 | 32.0 |
| 35 | `leave_qouta_categories` | `utf8mb4_0900_ai_ci` | 8 | 16.0 | 112.0 |
| 36 | `leave_quota` | `utf8mb4_0900_ai_ci` | 6,119 | 1,424.0 | 2,928.0 |
| 37 | `leaves` | `utf8mb4_0900_ai_ci` | 215 | 64.0 | 160.0 |
| 38 | `location_categories` | `utf8mb4_0900_ai_ci` | 42 | 16.0 | 80.0 |
| 39 | `location_groups` | `utf8mb4_0900_ai_ci` | 22 | 16.0 | 96.0 |
| 40 | `location_location_categories` | `utf8mb4_0900_ai_ci` | 80,090 | 5,648.0 | 21,072.0 |
| 41 | `location_logs` | `utf8mb4_0900_ai_ci` | 471 | 64.0 | 64.0 |
| 42 | `location_subs` | `utf8mb4_0900_ai_ci` | 21 | 16.0 | 64.0 |
| 43 | `locations` | `utf8mb4_0900_ai_ci` | 92,217 | 19,008.0 | 41,712.0 |
| 44 | `manual_process_endpoints` | `utf8mb4_0900_ai_ci` | 21 | 16.0 | 0.0 |
| 45 | `master_call_list` | `utf8mb4_0900_ai_ci` | 114,615 | 25,168.0 | 35,744.0 |
| 46 | `materials` | `utf8mb4_0900_ai_ci` | 4 | 16.0 | 16.0 |
| 47 | `mcl_recommendation_plan_amortizations` | `utf8mb4_0900_ai_ci` | 1,302 | 368.0 | 0.0 |
| 48 | `menu_users` | `utf8mb4_0900_ai_ci` | 31 | 16.0 | 16.0 |
| 49 | `menus` | `utf8mb4_0900_ai_ci` | 6 | 16.0 | 16.0 |
| 50 | `office_users` | `utf8mb4_0900_ai_ci` | 2,261 | 176.0 | 464.0 |
| 51 | `offices` | `utf8mb4_0900_ai_ci` | 39 | 16.0 | 80.0 |
| 52 | `outlet_survey_customer_materials` | `utf8mb4_0900_ai_ci` | 77 | 16.0 | 32.0 |
| 53 | `outlet_survey_customer_products` | `utf8mb4_0900_ai_ci` | 113 | 16.0 | 16.0 |
| 54 | `outlet_survey_customers` | `utf8mb4_0900_ai_ci` | 109 | 16.0 | 16.0 |
| 55 | `outlet_survey_questions` | `utf8mb4_0900_ai_ci` | 359 | 80.0 | 48.0 |
| 56 | `outlet_surveys` | `utf8mb4_0900_ai_ci` | 105 | 16.0 | 32.0 |
| 57 | `potential_customer_products` | `utf8mb4_0900_ai_ci` | 59 | 16.0 | 80.0 |
| 58 | `presence_historys` | `utf8mb4_0900_ai_ci` | 116 | 48.0 | 16.0 |
| 59 | `presences` | `utf8mb4_0900_ai_ci` | 57,682 | 22,064.0 | 39,888.0 |
| 60 | `product_categories` | `utf8mb4_0900_ai_ci` | 59 | 16.0 | 0.0 |
| 61 | `product_materials` | `utf8mb4_0900_ai_ci` | 53 | 16.0 | 0.0 |
| 62 | `product_recommendation_estimations` | `utf8mb4_0900_ai_ci` | 11,659 | 1,552.0 | 3,712.0 |
| 63 | `products` | `utf8mb4_0900_ai_ci` | 291 | 1,056.0 | 112.0 |
| 64 | `public_holidays` | `utf8mb4_0900_ai_ci` | 1 | 16.0 | 32.0 |
| 65 | `report_visit_completes` | `utf8mb4_0900_ai_ci` | 4,634 | 1,552.0 | 1,056.0 |
| 66 | `role_menu_permissions` | `utf8mb4_0900_ai_ci` | 674 | 96.0 | 176.0 |
| 67 | `roles` | `utf8mb4_0900_ai_ci` | 19 | 16.0 | 80.0 |
| 68 | `rules` | `utf8mb4_0900_ai_ci` | 15 | 16.0 | 0.0 |
| 69 | `sessions` | `utf8mb4_0900_ai_ci` | 557 | 128.0 | 112.0 |
| 70 | `status_closings` | `utf8mb4_0900_ai_ci` | 85 | 16.0 | 16.0 |
| 71 | `structure_bos` | `utf8mb4_0900_ai_ci` | 297 | 96.0 | 240.0 |
| 72 | `structure_cities` | `utf8mb4_0900_ai_ci` | 1,170 | 192.0 | 752.0 |
| 73 | `structure_code` | `utf8mb4_0900_ai_ci` | 46,893 | 2,576.0 | 0.0 |
| 74 | `structure_historys` | `utf8mb4_0900_ai_ci` | 15 | 16.0 | 0.0 |
| 75 | `structure_locations` | `utf8mb4_0900_ai_ci` | 5,500,931 | 482,304.0 | 2,782,208.0 |
| 76 | `structure_positions` | `utf8mb4_0900_ai_ci` | 12 | 16.0 | 80.0 |
| 77 | `structures` | `utf8mb4_0900_ai_ci` | 11,747 | 1,552.0 | 7,488.0 |
| 78 | `user_late_deductions` | `utf8mb4_0900_ai_ci` | 8 | 16.0 | 48.0 |
| 79 | `user_roles` | `utf8mb4_0900_ai_ci` | 222 | 16.0 | 32.0 |
| 80 | `users` | `utf8mb4_0900_ai_ci` | 1,193 | 3,216.0 | 656.0 |
| 81 | `visit_api_logs` | `utf8mb4_0900_ai_ci` | 0 | 16.0 | 64.0 |
| 82 | `visit_apis` | `utf8mb4_0900_ai_ci` | 1 | 16.0 | 48.0 |
| 83 | `visit_customer_histories` | `utf8mb4_0900_ai_ci` | 32,715 | 6,672.0 | 496.0 |
| 84 | `visit_customers` | `utf8mb4_0900_ai_ci` | 141,845 | 28,256.0 | 255,168.0 |
| 85 | `visit_members` | `utf8mb4_0900_ai_ci` | 219,481 | 33,360.0 | 86,864.0 |
| 86 | `visit_products` | `utf8mb4_0900_ai_ci` | 162,432 | 15,920.0 | 34,368.0 |
| 87 | `visits` | `utf8mb4_0900_ai_ci` | 179,857 | 86,864.0 | 439,280.0 |
| 88 | `work_hour_users` | `utf8mb4_0900_ai_ci` | 158 | 16.0 | 144.0 |
| 89 | `work_hours` | `utf8mb4_0900_ai_ci` | 5 | 16.0 | 160.0 |

## 2. Table Definitions & Indexes

### `approvals`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=225307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `area_recomendation_estimations`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1028 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `areas`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `attendance_corrections`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `attendance_deductions`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `bridging_product_specialists`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=4983 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `calendar_historys`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=2226 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `calendars`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=2260 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `call_daily_visit_all`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `call_details`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=7477478 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `call_targets`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `categories`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `companies`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=60005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `company_rules`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `configs`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `confirmation_statuses`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_addresses`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=120004 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_cluster_histories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=21246 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_customer_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1002123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_drafts`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_families`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_locations`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=4145714 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customer_logs`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=23043 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `customers`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `departments`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `distributors`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `html_services`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1584979 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `incentive_recomendations`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=2517 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `incentive_recommendation_parameters`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `incentive_users`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=2044 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `leave_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `leave_category_qoutas`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `leave_periods`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `leave_qouta_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `leave_quota`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=69314 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `leaves`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1157 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `location_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=60003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `location_groups`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=180057 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `location_location_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=549303 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `location_logs`

```sql
CREATE TABLE `location_logs` (
  `location_id` varchar(20) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `is_manual` tinyint(1) DEFAULT '0',
  `created_by_id` int DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  KEY `idx_location_logs_location_id` (`location_id`),
  KEY `idx_location_logs_created_by_id` (`created_by_id`),
  KEY `idx_location_logs_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2762 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `location_subs`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=120008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `locations`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `manual_process_endpoints`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `master_call_list`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=4456685 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `materials`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `mcl_recommendation_plan_amortizations`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `menu_users`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `menus`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `office_users`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=4577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `offices`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `outlet_survey_customer_materials`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `outlet_survey_customer_products`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `outlet_survey_customers`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `outlet_survey_questions`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `outlet_surveys`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `potential_customer_products`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `presence_historys`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `presences`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=684956 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `product_categories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `product_materials`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `product_recommendation_estimations`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=41563 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `products`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `public_holidays`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `report_visit_completes`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `role_menu_permissions`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `roles`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `rules`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `sessions`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=608770 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `status_closings`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=473 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structure_bos`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=223905 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structure_cities`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=39219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structure_code`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=46582 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structure_historys`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structure_locations`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=20711338 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structure_positions`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `structures`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `user_late_deductions`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=60009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `user_roles`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `users`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=99210144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visit_api_logs`

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visit_apis`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=60001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visit_customer_histories`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=56019 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visit_customers`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=463847 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visit_members`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1380302 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visit_products`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=246805 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `visits`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=1343550 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `work_hour_users`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

### `work_hours`

```sql
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```


## 3. Database Views (20)

| No | View Name | Definition |
|---|---|---|
| 1 | `attendance_user` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `attendance_user` AS selec...` |
| 2 | `attendance_user_deduction` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `attendance_user_deduction...` |
| 3 | `leave_quotas` | `CREATE ALGORITHM=UNDEFINED DEFINER=`vneu_umar`@`%` SQL SECURITY DEFINER VIEW `leave_quotas` AS selec...` |
| 4 | `migration_visit_flow_mfdb` | `CREATE ALGORITHM=UNDEFINED DEFINER=`mila`@`%` SQL SECURITY DEFINER VIEW `migration_visit_flow_mfdb` ...` |
| 5 | `vw_attendance_detail` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_attendance_detail` AS ...` |
| 6 | `vw_check_bridging_product_sepecialis_not_spesialis` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_bridging_product...` |
| 7 | `vw_check_sinkron_customer_ski_vf` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_customer...` |
| 8 | `vw_check_sinkron_customer_territory_outlet_ski_vf` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_customer...` |
| 9 | `vw_check_sinkron_marketing_structure_territory_outlet_ski_vf` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_marketin...` |
| 10 | `vw_check_sinkron_outlets_ski_vf` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_sinkron_outlets_...` |
| 11 | `vw_check_users_visit_ski_name` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_users_visit_ski_...` |
| 12 | `vw_check_visit_customer_duplicate_gt_customer` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_visit_customer_d...` |
| 13 | `vw_check_visit_customer_user_id_not_structure` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_check_visit_customer_u...` |
| 14 | `vw_locations_province_city_no_mapping` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_locations_province_cit...` |
| 15 | `vw_presence_migration` | `CREATE ALGORITHM=UNDEFINED DEFINER=`mila`@`%` SQL SECURITY DEFINER VIEW `vw_presence_migration` AS s...` |
| 16 | `vw_presences_now` | `CREATE ALGORITHM=UNDEFINED DEFINER=`ridwan`@`%` SQL SECURITY DEFINER VIEW `vw_presences_now` AS sele...` |
| 17 | `vw_product_survey_test` | `CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_product_survey_test` AS ...` |
| 18 | `vw_products` | `CREATE ALGORITHM=UNDEFINED DEFINER=`vneu_umar`@`%` SQL SECURITY DEFINER VIEW `vw_products` AS select...` |
| 19 | `vw_survey` | `CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_survey` AS select `t1`.`...` |
| 20 | `vw_surveys` | `CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_surveys` AS select `t1`....` |