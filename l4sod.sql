-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 18, 2025 at 02:21 PM
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
-- Database: `l4sod`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` float DEFAULT 0,
  `user_id` int(11) NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `transaction_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `amount`, `user_id`, `product_id`, `transaction_id`, `created_at`, `updated_at`) VALUES
(2, 30000, 1, 1, 1, '2025-04-17 13:27:31', '2025-04-17 13:27:31'),
(3, 15000, 2, 2, 2, '2025-04-17 13:28:24', '2025-04-17 13:28:24');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(250) NOT NULL,
  `price` float DEFAULT 0,
  `qty` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `qty`, `created_at`, `updated_at`) VALUES
(1, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(2, 'TI-shirt2', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(3, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(4, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(5, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(6, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(7, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(8, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(9, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(10, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(11, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(12, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(13, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(14, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34'),
(15, 'TI-shirt', 15000, 20, '2025-04-16 16:07:34', '2025-04-16 16:07:34');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` float NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('pending','success','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `amount`, `user_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 30000, 1, 'pending', '2025-04-17 13:22:16', '2025-04-17 13:22:16'),
(2, 15000, 2, 'pending', '2025-04-17 13:22:16', '2025-04-17 13:22:16'),
(3, 30000, 1, 'pending', '2025-04-17 13:22:16', '2025-04-17 13:22:16'),
(4, 15000, 3, 'pending', '2025-04-17 13:22:16', '2025-04-17 13:22:16');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(250) NOT NULL,
  `user_name` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `Email` varchar(250) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role` enum('admin','client') DEFAULT 'client'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `password`, `Email`, `created_at`, `updated_at`, `role`) VALUES
(1, 'John', '4312', 'email@example.com', '2025-04-15 14:29:32', '2025-04-16 13:44:32', 'admin'),
(2, 'Jane', '2edwt', 'jane@mu.rw', '2025-04-15 14:52:01', '2025-04-16 13:55:33', 'client'),
(3, 'Mutoni Uwase', '123', 'mutoni@gmail.com', '2025-04-15 14:56:04', '2025-04-16 13:55:33', 'client'),
(4, 'Musemakweri Junior', '123', 'junior@gmail.com', '2025-04-15 14:58:00', '2025-04-15 14:58:00', 'client'),
(5, 'John', 'jmut', 'john@me.cu', '2025-04-15 14:58:00', '2025-04-16 13:55:33', 'client');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `transaction_id` (`transaction_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(250) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
