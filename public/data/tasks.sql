-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3307
-- Generation Time: Mar 19, 2019 at 02:38 AM
-- Server version: 5.7.22
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tasks`
--

-- --------------------------------------------------------

--
-- Table structure for table `dwarfs`
--

CREATE TABLE `dwarfs` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `role` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dwarfs`
--

INSERT INTO `dwarfs` (`id`, `name`, `role`) VALUES
(1, 'Doc', 'inspector'),
(2, 'Grumpy', 'digger'),
(3, 'Happy', 'digger'),
(4, 'Sleepy', 'transporter'),
(5, 'Bashful', 'digger'),
(6, 'Sneezy', 'digger'),
(7, 'Dopey', 'sweeper');

-- --------------------------------------------------------

--
-- Table structure for table `flags`
--

CREATE TABLE `flags` (
  `id` int(1) NOT NULL,
  `meaning` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flags`
--

INSERT INTO `flags` (`id`, `meaning`) VALUES
(1, 'Urgent');

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `id` int(1) NOT NULL,
  `name` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`) VALUES
(1, 'house'),
(2, 'school'),
(3, 'work'),
(4, 'family');

-- --------------------------------------------------------

--
-- Table structure for table `priorities`
--

CREATE TABLE `priorities` (
  `id` int(1) NOT NULL,
  `name` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `priorities`
--

INSERT INTO `priorities` (`id`, `name`) VALUES
(1, 'low'),
(2, 'medium'),
(3, 'high');

-- --------------------------------------------------------

--
-- Table structure for table `sizes`
--

CREATE TABLE `sizes` (
  `id` int(1) NOT NULL,
  `name` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sizes`
--

INSERT INTO `sizes` (`id`, `name`) VALUES
(1, 'small'),
(2, 'medium'),
(3, 'large');

-- --------------------------------------------------------

--
-- Table structure for table `statuses`
--

CREATE TABLE `statuses` (
  `id` int(1) NOT NULL,
  `name` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `statuses`
--

INSERT INTO `statuses` (`id`, `name`) VALUES
(1, 'in progress'),
(2, 'complete');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` int(2) NOT NULL,
  `task` varchar(22) DEFAULT NULL,
  `priority` int(1) DEFAULT NULL,
  `size` int(1) DEFAULT NULL,
  `group` int(1) DEFAULT NULL,
  `deadline` varchar(8) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL,
  `flag` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `task`, `priority`, `size`, `group`, `deadline`, `status`, `flag`) VALUES
(1, 'COMP1234 assignment', 3, 2, 2, '20170219', '1', ''),
(2, 'Mow the lawn', 2, 2, 1, '', '2', ''),
(3, 'Wash the car', 2, 2, 1, '', '', ''),
(4, 'Paint the fence', 1, 2, 1, '', '', ''),
(5, 'Study for midterms', 3, 3, 2, '', '', ''),
(6, 'Intramural hockey game', 1, 2, 4, '', '', ''),
(7, 'Canucks hockey game', 3, 3, 4, '20170305', '', ''),
(8, 'Buy steel-toed boots', 2, 1, 3, '', '', ''),
(9, 'Learn French', 1, 3, 3, '20161231', '1', ''),
(10, 'Hit the gym', 2, 1, 4, '', '', ''),
(11, 'Pay bills', 3, 1, 1, '', '', ''),
(12, 'Meet George', 2, 1, 1, '', '', ''),
(13, 'Buy milk & bread', 2, 1, 1, '', '', '1'),
(14, 'Read War & Peace', 1, 3, 1, '', '', ''),
(15, 'Organize the study', 1, 4, 1, '', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dwarfs`
--
ALTER TABLE `dwarfs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `flags`
--
ALTER TABLE `flags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `id_2` (`id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `priorities`
--
ALTER TABLE `priorities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sizes`
--
ALTER TABLE `sizes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `statuses`
--
ALTER TABLE `statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
