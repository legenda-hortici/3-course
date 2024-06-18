USE mydb;
-- создание первого представления
create view alpinistView as
select * from Альпинист;

select * from alpinistView;

-- создание второго представления
create view voshView as
select * from Восхождение;

select * from voshView;

-- создание первой процедуры
DELIMITER //
CREATE PROCEDURE GetRelatedRecords()
BEGIN
    SELECT *
    FROM Альпинист JOIN Альпинист_Группа ON Альпинист.id_Альпиниста = Альпинист_Группа.id_Альпиниста;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS GetRelatedRecords;
CALL GetRelatedRecords();

-- создание второй процедуры
DELIMITER // 
CREATE PROCEDURE AGREG1(
	IN agr VARCHAR(3),
	IN table1 VARCHAR(50),
    IN column1 VARCHAR(50)
)
BEGIN
		DECLARE query VARCHAR(1000); 
        DECLARE result decimal(10,2);
        SET @query = concat('select ', agr, '(', column1, ') from ', table1, ' into @result;');
		PREPARE statement FROM @query;
		EXECUTE statement;
		DEALLOCATE PREPARE statement;
        SET result = @result;
        SELECT result;
END//
DELIMITER ;

CALL AGREG1('MAX', 'Гора', 'Высота');

-- Привелегии
-- 1 задание
create user 'test'@'localhost' identified by 'Pass123#';
grant select on alpinistView to 'test'@'localhost';
grant execute on procedure GetRelatedRecords to 'test'@'localhost';
drop user 'test'@'localhost';

-- 2 задание
show grants for 'test'@'localhost';
select * from alpinistView;
call GetRelatedRecords();

-- 3 задание 
select * from Альпинист; -- вызов ошибки
call AGREG1('MAX', 'Гора', 'Высота'); -- вызов ошибки

-- 4 задание
GRANT SELECT, INSERT, UPDATE, DELETE ON Альпинист TO 'test'@'localhost';

-- 5 задание
-- Вставка данных
INSERT INTO Альпинист (id_Альпиниста, Фамилия, Имя, Отчество, Адрес) VALUES (2, 'Иванов', 'Иван', 'Иванович', 'Москва');
-- Обновление данных
UPDATE Альпинист SET Адрес = 'Санкт-Петербург' WHERE id_Альпиниста = 1;
-- Удаление данных
DELETE FROM Альпинист WHERE id_Альпиниста = 2;

-- 6 задание
REVOKE SELECT, INSERT, UPDATE, DELETE ON Альпинист FROM 'test'@'localhost';

-- 7 задание
-- Вставка данных
INSERT INTO Альпинист (id_Альпиниста, Фамилия, Имя, Отчество, Город) VALUES (2, 'Иванов', 'Иван', 'Иванович', 'Москва');
-- Обновление данных
UPDATE Альпинист SET Город = 'Санкт-Петербург' WHERE id_Альпиниста = 1;
-- Удаление данных
DELETE FROM Альпинист WHERE id_Альпиниста = 2;
CALL AGREG1('MAX', 'Гора', 'Высота');


