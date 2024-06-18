-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Альпинист`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Альпинист` (
  `id_Альпиниста` INT NOT NULL,
  `Фамилия` VARCHAR(45) NOT NULL,
  `Имя` VARCHAR(45) NOT NULL,
  `Отчество` VARCHAR(45) NOT NULL,
  `Адрес` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Альпиниста`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Группа`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Группа` (
  `id_Группы` INT NOT NULL,
  `Название` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Группы`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Восхождение`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Восхождение` (
  `id_Восхождения` INT NOT NULL,
  `Дата_начала` DATETIME NOT NULL,
  `Дата_окончания` DATETIME NOT NULL,
  `id_mount` INT NOT NULL,
  `id_Группы` INT NOT NULL,
  PRIMARY KEY (`id_Восхождения`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Гора`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Гора` (
  `id_mount` INT NOT NULL,
  `Название` VARCHAR(45) NOT NULL,
  `Высота` INT NOT NULL,
  `Страна` VARCHAR(45) NOT NULL,
  `Район` VARCHAR(45) NOT NULL,
  `id_Страны` INT NOT NULL,
  PRIMARY KEY (`id_mount`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Страна`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Страна` (
  `id_Страны` INT NOT NULL,
  `Название` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Страны`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Альпинист_Группа`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Альпинист_Группа` (
  `id_Альпиниста` INT NOT NULL,
  `id_Группы` INT NOT NULL,
  PRIMARY KEY (`id_Альпиниста`, `id_Группы`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
