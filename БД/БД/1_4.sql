USE mydb;

-- Создать хранимую процедуру, которая выполняет арифметическую операцию
-- над полями таблицы по вводимому параметру процедуры
DELIMITER //
CREATE PROCEDURE PerformArithmeticOperationBetweenTables1 (
    IN table1_name VARCHAR(50),  -- название первой таблицы
    IN table1_column VARCHAR(50),  -- название столбца первой таблицы
    IN arithmetic_operator CHAR(1),  -- '+', '-', '*', '/'
    IN table2_name VARCHAR(50),  -- название второй таблицы
    IN table2_column VARCHAR(50)  -- название столбца второй таблицы
)
BEGIN
    DECLARE result DECIMAL(10,2);
    DECLARE query VARCHAR(1000);
    
    SET @query = CONCAT(
        'SELECT (SELECT max(', table1_column, ') FROM ', table1_name, ') ', arithmetic_operator,
        ' (SELECT max(', table2_column, ') FROM ', table2_name, ') INTO @result;'
    );
    PREPARE statement FROM @query;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    SET result = @result;
    SELECT result AS Result_of_Arithmetic_Operation_Between_Tables;
END//
DELIMITER ;

CALL PerformArithmeticOperationBetweenTables1('Гора', 'Высота', '*', 'Восхождение', 'id_mount');

-- Создать хранимую процедуру, которая возвращает связанные записи нескольких
-- таблиц. 
DELIMITER //
-- DROP PROCEDURE IF EXISTS GetRelatedRecords;
CREATE PROCEDURE GetRelatedRecords()
BEGIN
    SELECT *
    FROM Альпинист JOIN Альпинист_Группа ON Альпинист.id_Альпиниста = Альпинист_Группа.id_Альпиниста;
END//
DELIMITER ;

CALL GetRelatedRecords();


-- Создать хранимую процедуру, вычисляющую агрегированные характеристики
-- записей таблицы (например, минимальное, максимальное и среднее значение
-- некоторых полей).
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

-- Создать функцию, использующую конструкцию CASE (например,
-- преобразование номера дня недели в текст), вывести результат выполнения
-- функции в запросе. 
DELIMITER //

CREATE PROCEDURE GetCountryByMountain_1(IN mountain_id INT)
BEGIN
    DECLARE country_name VARCHAR(255);

    CASE mountain_id
        WHEN 901 THEN
            SET country_name = 'Китай';
		WHEN 902 THEN
            SET country_name = 'Франция';
        ELSE
            SET country_name = 'Неизвестно';
    END CASE;

    SELECT country_name AS Country_Name;
END//

DELIMITER ;

CALL GetCountryByMountain_1('901');

-- Создайте курсор для вывода записей из таблицы, удовлетворяющих заданному
-- условию.
DELIMITER //
CREATE PROCEDURE GetMountainsAbove5000Meters()
BEGIN
    DECLARE mountain_name VARCHAR(100);
    DECLARE no_more_rows BOOLEAN DEFAULT FALSE; -- флаг, указывающий на окончание строк

    DECLARE mountain_cursor CURSOR FOR
        SELECT Название FROM Гора WHERE Высота > 5000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET no_more_rows = TRUE;

    OPEN mountain_cursor;
    read_loop: LOOP
        FETCH mountain_cursor INTO mountain_name;
        IF no_more_rows THEN
            LEAVE read_loop;
        END IF;
        SELECT mountain_name AS Mountain_Name;
    END LOOP;
    CLOSE mountain_cursor;
END//
DELIMITER ;

CALL GetMountainsAbove5000Meters();

-- Создать хранимую процедуру, которая записывает в новую таблицу все картежи
-- из существующей таблицы по определенному критерию отбора. Предварительно
-- необходимо создать новую пустую таблицу со структурой, аналогичной
-- структуре существующей таблицы. Хранимая процедура должна использовать
-- курсор, который в цикле читает данные из существующей таблицы и добавляет
-- их в новую таблицу

DELIMITER //
DROP PROCEDURE IF EXISTS NewTableCopy_;
CREATE PROCEDURE NewTableCopy_()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE a INT;
    DECLARE b VARCHAR(45);
    DECLARE c VARCHAR(45);
    DECLARE d VARCHAR(45);
    DECLARE e VARCHAR(45);
    
    DECLARE mycursor cursor for
    select *
    FROM Альпинист
    WHERE Фамилия is not null;
    
    DECLARE continue handler for not found set done = TRUE;
    
    OPEN mycursor;
    read_loop: LOOP
		FETCH mycursor INTO a, b, c, d, e;
		IF done THEN
			LEAVE read_loop;
		END IF;
			SELECT a as 'id_Альпиниста', b as 'Фамилия', c as 'Имя', d as 'Отчество', e as 'Адрес';
		END LOOP;
    CLOSE mycursor;
END//
DELIMITER ;

CALL NewTableCopy_();







