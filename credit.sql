-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 29, 2020 at 12:43 PM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `credit`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add user', 6, 'add_customuser'),
(22, 'Can change user', 6, 'change_customuser'),
(23, 'Can delete user', 6, 'delete_customuser'),
(24, 'Can view user', 6, 'view_customuser'),
(25, 'Can add organization', 7, 'add_organization'),
(26, 'Can change organization', 7, 'change_organization'),
(27, 'Can delete organization', 7, 'delete_organization'),
(28, 'Can view organization', 7, 'view_organization'),
(29, 'Can add loanie', 8, 'add_loanie'),
(30, 'Can change loanie', 8, 'change_loanie'),
(31, 'Can delete loanie', 8, 'delete_loanie'),
(32, 'Can view loanie', 8, 'view_loanie');

-- --------------------------------------------------------

--
-- Table structure for table `CreditHistorySite_customuser`
--

CREATE TABLE `CreditHistorySite_customuser` (
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `publicKey` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CreditHistorySite_customuser`
--

INSERT INTO `CreditHistorySite_customuser` (`password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`, `type`, `publicKey`) VALUES
('', NULL, 0, 'philo', '', '', 'philo@philo.com', 0, 1, '2020-07-06 20:12:54.224020', 0, '3384c927727b8f1893f1698e2f1fcced7470b758'),
('', '2020-07-08 15:49:34.726059', 0, 'BOA', '', '', 'boa@boa.com', 0, 1, '2020-07-08 15:49:32.668770', 1, '45718d18f2cc40900377184fc179c1effe3cbbd1'),
('', '2020-07-08 16:33:50.480609', 0, 'cib', '', '', 'cib@cib.com', 0, 1, '2020-07-06 19:48:06.229946', 1, '6ea141226ea6d5c139554eed9fe4ce42a92822cc'),
('', '2020-07-08 15:51:49.340136', 0, 'andrew', '', '', 'andrew@email.com', 0, 1, '2020-07-08 15:51:47.304961', 0, '93a03c3f7300b1255fa6c401674f663ac28ff667'),
('', '2020-07-08 15:58:36.176496', 0, 'george', '', '', 'george@george.com', 0, 1, '2020-07-08 15:58:34.149876', 0, '95434470f6065fe8594ac59ed5994f711bbd6214'),
('', NULL, 0, 'NBE', '', '', 'nbe@nbe.com', 0, 1, '2020-07-06 20:05:05.393291', 1, 'fcfaf7b72c8c8517647af566d98d58e23cc059e8'),
('', '2020-07-08 17:39:23.641387', 0, 'walied', '', '', 'walied@walied.com', 0, 1, '2020-07-06 19:48:28.209764', 0, 'fe1bab91deddf73bc6db56998699af60ad5b21af');

-- --------------------------------------------------------

--
-- Table structure for table `CreditHistorySite_customuser_groups`
--

CREATE TABLE `CreditHistorySite_customuser_groups` (
  `id` int(11) NOT NULL,
  `customuser_id` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `CreditHistorySite_customuser_user_permissions`
--

CREATE TABLE `CreditHistorySite_customuser_user_permissions` (
  `id` int(11) NOT NULL,
  `customuser_id` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `CreditHistorySite_loanie`
--

CREATE TABLE `CreditHistorySite_loanie` (
  `id` int(11) NOT NULL,
  `keystore` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customUser_id` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CreditHistorySite_loanie`
--

INSERT INTO `CreditHistorySite_loanie` (`id`, `keystore`, `customUser_id`) VALUES
(1, '{\"address\": \"fe1bab91deddf73bc6db56998699af60ad5b21af\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"1480ee15c186b738065d589f4589bad5\"}, \"ciphertext\": \"8cbdbe403616cf01d162aa41d9d1d26f152dfa281fec466e53e4e1c53108d175\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"6ab0422f0b77829229f0a2eac81bb84c\"}, \"mac\": \"61eed36a7526a02fef0108f98a15dea779a77f69eb4097d021bb8aaf3d390429\"}, \"id\": \"80057883-f5a4-4e72-a6b2-4ced83422ecb\", \"version\": 3}', 'fe1bab91deddf73bc6db56998699af60ad5b21af'),
(2, '{\"address\": \"3384c927727b8f1893f1698e2f1fcced7470b758\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"f1c5c2a2d2f15d472fdea3aca5c1b4cd\"}, \"ciphertext\": \"466e27e14e2c2d04f8578b5437b4e5d93fb8809ad3f4afc45addc7414bbc4719\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"b0ae63f5e60decd62d4dda853c20866c\"}, \"mac\": \"b83ae486d502ec83ea38d8d5278068b0acb94e32e1a0df8b7a54c259a639589e\"}, \"id\": \"4ef9823a-34dc-4d15-bef1-c668ca08a673\", \"version\": 3}', '3384c927727b8f1893f1698e2f1fcced7470b758'),
(3, '{\"address\": \"93a03c3f7300b1255fa6c401674f663ac28ff667\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"25d0468f7bddfb49b717b75f76e286d6\"}, \"ciphertext\": \"16bc5e111988c2c5bf50416a48a4a1da935e019125353600295ecb441956d4d7\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"c8b12c0531f4fec76efba067fd8a8fb1\"}, \"mac\": \"50520ed1e08e5433bb8341efd7109b01d6b5becfc13564646e1e22d8616d13ea\"}, \"id\": \"61172a27-ac27-41bf-b9a3-20bcff6d224d\", \"version\": 3}', '93a03c3f7300b1255fa6c401674f663ac28ff667'),
(4, '{\"address\": \"95434470f6065fe8594ac59ed5994f711bbd6214\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"0e61112b81ec0fa0f333b0aa8c8fa75a\"}, \"ciphertext\": \"2205ecb6daafe31b7f269199530fadb5f008fc2c84562c67099cffb8dc4c15de\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"14a42f287d82ecd13126f7b61ee595db\"}, \"mac\": \"0dc2655569de9bf454cb47f89d3ce1154c64e91b424bd6f6aed66574e125d614\"}, \"id\": \"f52fd15f-b8c9-4c45-83e9-ea955179943f\", \"version\": 3}', '95434470f6065fe8594ac59ed5994f711bbd6214');

-- --------------------------------------------------------

--
-- Table structure for table `CreditHistorySite_organization`
--

CREATE TABLE `CreditHistorySite_organization` (
  `id` int(11) NOT NULL,
  `commertialNum` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `keystore` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customUser_id` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CreditHistorySite_organization`
--

INSERT INTO `CreditHistorySite_organization` (`id`, `commertialNum`, `keystore`, `customUser_id`) VALUES
(1, '1239084', '{\"address\": \"6ea141226ea6d5c139554eed9fe4ce42a92822cc\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"7fa44fd74c6b2d88dbee339ca207f605\"}, \"ciphertext\": \"7fa55377f169de83c29cf340238a5bdedb43767aced7998adba026fca87c9833\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"4a85aa93a94b755caadb832e8f035e4b\"}, \"mac\": \"355ccc3e44de3e120754aec27f83837cb603d888e68da9ef9e9cc241a4ec275d\"}, \"id\": \"f600b1af-987f-4f44-a9cd-a7632dc8827f\", \"version\": 3}', '6ea141226ea6d5c139554eed9fe4ce42a92822cc'),
(2, '928374891', '{\"address\": \"fcfaf7b72c8c8517647af566d98d58e23cc059e8\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"3bd19cbd242799809e55a38675f99f2b\"}, \"ciphertext\": \"db83e8ad126bb58eb7b6704834a74df1c47f360ec03d1170a5fef7f527c90f0b\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"4432e7ced599d1f86c69eb8489e5435e\"}, \"mac\": \"32b5677c9ffee197ba3a478b4e2bd86ff45416ce3e75a885f6d74dfb1a3ebb9c\"}, \"id\": \"90846c99-c4f5-4faa-a710-612d4bfe27ac\", \"version\": 3}', 'fcfaf7b72c8c8517647af566d98d58e23cc059e8'),
(3, '32498911', '{\"address\": \"45718d18f2cc40900377184fc179c1effe3cbbd1\", \"crypto\": {\"cipher\": \"aes-128-ctr\", \"cipherparams\": {\"iv\": \"d444a8c7f56390c91dcbeb4db56e163b\"}, \"ciphertext\": \"835b93901b1d9b6adc94626d55fb3d25d4f336743780073c9acbebd335cc5333\", \"kdf\": \"scrypt\", \"kdfparams\": {\"dklen\": 32, \"n\": 262144, \"r\": 1, \"p\": 8, \"salt\": \"f01c3541ec8e467a73ed658b887d2843\"}, \"mac\": \"fd1a750eaf780938e8445226efdac762ab4792f2aa9aaef6c78026d711db0960\"}, \"id\": \"6cf7ab14-8637-4780-89c3-38b37e8fe7df\", \"version\": 3}', '45718d18f2cc40900377184fc179c1effe3cbbd1');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'contenttypes', 'contenttype'),
(6, 'CreditHistorySite', 'customuser'),
(8, 'CreditHistorySite', 'loanie'),
(7, 'CreditHistorySite', 'organization'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2020-07-06 19:46:25.289747'),
(2, 'contenttypes', '0002_remove_content_type_name', '2020-07-06 19:46:25.314417'),
(3, 'auth', '0001_initial', '2020-07-06 19:46:25.347472'),
(4, 'auth', '0002_alter_permission_name_max_length', '2020-07-06 19:46:25.456515'),
(5, 'auth', '0003_alter_user_email_max_length', '2020-07-06 19:46:25.461202'),
(6, 'auth', '0004_alter_user_username_opts', '2020-07-06 19:46:25.465297'),
(7, 'auth', '0005_alter_user_last_login_null', '2020-07-06 19:46:25.469249'),
(8, 'auth', '0006_require_contenttypes_0002', '2020-07-06 19:46:25.470978'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2020-07-06 19:46:25.473841'),
(10, 'auth', '0008_alter_user_username_max_length', '2020-07-06 19:46:25.477732'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2020-07-06 19:46:25.481438'),
(12, 'auth', '0010_alter_group_name_max_length', '2020-07-06 19:46:25.488486'),
(13, 'auth', '0011_update_proxy_permissions', '2020-07-06 19:46:25.492207'),
(14, 'CreditHistorySite', '0001_initial', '2020-07-06 19:46:25.549147'),
(15, 'admin', '0001_initial', '2020-07-06 19:46:25.711259'),
(16, 'admin', '0002_logentry_remove_auto_add', '2020-07-06 19:46:25.771274'),
(17, 'admin', '0003_logentry_add_action_flag_choices', '2020-07-06 19:46:25.777363'),
(18, 'sessions', '0001_initial', '2020-07-06 19:46:25.789173');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('208kx3yrzvocfhcxo3j3b9922vueqymr', 'MDI1ZmU0NDhjNjg2ZWQ0ZDQxYTEwZGU4NjE2ZTJkNmQ3YWM2NGRkZDp7InByaXZhdGVLZXkiOiIweDc2ODhmYWJjZDIwNjJjOTdkNWI5NDExMGRiOGM2ODU2ZGNkNTliOWQwNzUwMDJmMmFmMDgwMTMyM2QzNWU2ZjciLCJfYXV0aF91c2VyX2lkIjoiNmVhMTQxMjI2ZWE2ZDVjMTM5NTU0ZWVkOWZlNGNlNDJhOTI4MjJjYyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6IkNyZWRpdEhpc3RvcnlTaXRlLmJhY2tlbmRzLkFkZHJlc3NCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiODc0ZWNiY2FkMWEwNTExMGM4OWVhZTg1YzE5OTNiZjVhN2FlNmU2YiJ9', '2020-07-20 22:27:54.322893');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `CreditHistorySite_customuser`
--
ALTER TABLE `CreditHistorySite_customuser`
  ADD PRIMARY KEY (`publicKey`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `CreditHistorySite_customuser_groups`
--
ALTER TABLE `CreditHistorySite_customuser_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `CreditHistorySite_custom_customuser_id_group_id_59bfadd2_uniq` (`customuser_id`,`group_id`),
  ADD KEY `CreditHistorySite_cu_group_id_98f6a97e_fk_auth_grou` (`group_id`);

--
-- Indexes for table `CreditHistorySite_customuser_user_permissions`
--
ALTER TABLE `CreditHistorySite_customuser_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `CreditHistorySite_custom_customuser_id_permission_25d35523_uniq` (`customuser_id`,`permission_id`),
  ADD KEY `CreditHistorySite_cu_permission_id_42b2123f_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `CreditHistorySite_loanie`
--
ALTER TABLE `CreditHistorySite_loanie`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customUser_id` (`customUser_id`);

--
-- Indexes for table `CreditHistorySite_organization`
--
ALTER TABLE `CreditHistorySite_organization`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customUser_id` (`customUser_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_CreditHis` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `CreditHistorySite_customuser_groups`
--
ALTER TABLE `CreditHistorySite_customuser_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `CreditHistorySite_customuser_user_permissions`
--
ALTER TABLE `CreditHistorySite_customuser_user_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `CreditHistorySite_loanie`
--
ALTER TABLE `CreditHistorySite_loanie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `CreditHistorySite_organization`
--
ALTER TABLE `CreditHistorySite_organization`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `CreditHistorySite_customuser_groups`
--
ALTER TABLE `CreditHistorySite_customuser_groups`
  ADD CONSTRAINT `CreditHistorySite_cu_customuser_id_ab40e233_fk_CreditHis` FOREIGN KEY (`customuser_id`) REFERENCES `CreditHistorySite_customuser` (`publicKey`),
  ADD CONSTRAINT `CreditHistorySite_cu_group_id_98f6a97e_fk_auth_grou` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `CreditHistorySite_customuser_user_permissions`
--
ALTER TABLE `CreditHistorySite_customuser_user_permissions`
  ADD CONSTRAINT `CreditHistorySite_cu_customuser_id_45b2e017_fk_CreditHis` FOREIGN KEY (`customuser_id`) REFERENCES `CreditHistorySite_customuser` (`publicKey`),
  ADD CONSTRAINT `CreditHistorySite_cu_permission_id_42b2123f_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Constraints for table `CreditHistorySite_loanie`
--
ALTER TABLE `CreditHistorySite_loanie`
  ADD CONSTRAINT `CreditHistorySite_lo_customUser_id_1160a8b1_fk_CreditHis` FOREIGN KEY (`customUser_id`) REFERENCES `CreditHistorySite_customuser` (`publicKey`);

--
-- Constraints for table `CreditHistorySite_organization`
--
ALTER TABLE `CreditHistorySite_organization`
  ADD CONSTRAINT `CreditHistorySite_or_customUser_id_50dd53af_fk_CreditHis` FOREIGN KEY (`customUser_id`) REFERENCES `CreditHistorySite_customuser` (`publicKey`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_CreditHis` FOREIGN KEY (`user_id`) REFERENCES `CreditHistorySite_customuser` (`publicKey`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
