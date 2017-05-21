ALTER TABLE `gta5_gamemode_essential`.`users` ADD COLUMN `last_vehicle` LONGTEXT NULL;

CREATE TABLE `user_parkings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `zone` varchar(60) NOT NULL,
  `vehicle` longtext,
  PRIMARY KEY (`id`)
);