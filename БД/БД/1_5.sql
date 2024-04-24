USE mydb;

-- 1. Создать триггер:
-- a. запрещающий вставку в таблицу новой строки с заданным параметром;

DELIMITER //

CREATE TRIGGER check_voskhozhdenie_date
BEFORE INSERT ON Восхождение
FOR EACH ROW
BEGIN
    IF NEW.Дата_начала < '2001-10-01' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Нельзя вставить восхождение с датой начала раньше 2001-10-01';
    END IF;
END//

DELIMITER ;

INSERT INTO Восхождение (id_Восхождения, Дата_начала, Дата_окончания, id_mount, id_Группы)
VALUES (1, '2001-09-01', '2001-09-10', 901, 301);

DROP TRIGGER mydb.check_voskhozhdenie_date;

-- b. заполняющий одно из полей таблицы на основе вводимых данных.

DELIMITER //

CREATE TRIGGER set_join_date
BEFORE INSERT ON Альпинист_Группа 
FOR EACH ROW
BEGIN
    SET NEW.id_Альпиниста = CURRENT_DATE();
END//

DELIMITER ;

INSERT INTO Альпинист_Группа (id_Альпиниста, id_Группы)
VALUES (1, 3000);
 
SELECT * FROM Альпинист_Группа;

DROP TRIGGER mydb.set_join_date;

-- 2. Создать триггер ведения аудита изменения записей в таблицах.

CREATE TABLE Audit (
    Идентификатор INT AUTO_INCREMENT PRIMARY KEY,
    Таблица VARCHAR(255),
    Идентификатор_записи INT,
    Действие VARCHAR(50),
    Дата_изменения TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER audit_alpinist
AFTER INSERT ON Альпинист
FOR EACH ROW
BEGIN
    INSERT INTO Audit (Таблица, Идентификатор_записи, Действие)
    VALUES ('Альпинист', NEW.id_Альпиниста, 'Вставка');
END//

CREATE TRIGGER audit_alpinist_update
AFTER UPDATE ON Альпинист
FOR EACH ROW
BEGIN
    INSERT INTO Audit (Таблица, Идентификатор_записи, Действие)
    VALUES ('Альпинист', NEW.id_Альпиниста, 'Обновление');
END//

CREATE TRIGGER audit_alpinist_delete
AFTER DELETE ON Альпинист
FOR EACH ROW
BEGIN
    INSERT INTO Audit (Таблица, Идентификатор_записи, Действие)
    VALUES ('Альпинист', OLD.id_Альпиниста, 'Удаление');
END//

DELIMITER ;

-- Вызов
UPDATE Альпинист SET Фамилия = 'Сидоров' WHERE id_Альпиниста = 2;
SELECT * FROM mydb.Audit;

-- 3. Внести такие изменения в триггеры вставки и изменения записей таблиц,
-- которые не позволят добавить или изменить записи с дублирующими
-- названиями

DELIMITER //

CREATE TRIGGER no_repeat_update_on_alpinist1
BEFORE UPDATE ON Альпинист FOR EACH ROW
BEGIN
    IF EXISTS(SELECT * FROM Альпинист WHERE Фамилия = NEW.Фамилия AND id_Альпиниста <> NEW.id_Альпиниста) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Уже есть альпинист с такой фамилией';
    END IF;
END//

DELIMITER ;

drop trigger mydb.no_repeat_update_on_alpinist1;

UPDATE Альпинист SET Фамилия = 'Смирнова' WHERE id_Альпиниста = 3;

DELIMITER //

CREATE TRIGGER no_repeat_insert_on_alpinist
BEFORE INSERT ON Альпинист FOR EACH ROW
BEGIN
    IF EXISTS(SELECT * FROM Альпинист WHERE Фамилия = NEW.Фамилия) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Уже есть альпинист с такой фамилией';
    END IF;
END//

DELIMITER ;

INSERT INTO Альпинист (id_Альпиниста, Фамилия, Имя, Отчество, Адрес) VALUES (4, 'Лис', 'Анастасия', 'Сергеевна', 'Ялта');


-- JSON
-- 4. Создать новую таблицу или изменить существующую, добавив поле типа JSON,
-- заполнить таблицу данными.

ALTER TABLE Альпинист ADD COLUMN Info JSON;

UPDATE Альпинист
SET Info = '{"mountains_visited": ["Эверест", "Макалу"], "achievements": {"year_of_achievement": "2015", "type": "First Ascent"}}'
WHERE id_Альпиниста = 1;

UPDATE Альпинист
SET Info = '{"mountains_visited": ["К2", "Лхоцзе"], "achievements": {"year_of_achievement": "2018", "type": "Summit"}}'
WHERE id_Альпиниста = 2;

UPDATE Альпинист
SET Info = '{"mountains_visited": ["Аннапурна", "Дхаулагири"], "achievements": {"year_of_achievement": "2020", "type": "Solo Climb"}}'
WHERE id_Альпиниста = 3;

UPDATE Альпинист
SET Info = '{"mountains_visited": ["Нанга Парбат", "Брод Пик"], "achievements": {"year_of_achievement": "2017", "type": "Speed Record"}}'
WHERE id_Альпиниста = 4;

UPDATE Альпинист
SET Info = '{"mountains_visited": ["Манаслу", "Гашербрум I"], "achievements": {"year_of_achievement": "2019", "type": "Multiple 8000ers"}}'
WHERE id_Альпиниста = 5;

-- 5. Выполнить запрос, возвращающий содержимое данной таблицы,
-- соответствующее некоторому условию, проверяющему значение атрибута
-- вложенной структуры.

SELECT 
    id_Альпиниста AS "Порядковый номер",
    Фамилия AS "Фамилия",
    Имя AS "Имя",
    JSON_VALUE(Info, '$.mountains_visited') AS "Посещенные горы"
FROM 
    Альпинист
WHERE 
    JSON_LENGTH(JSON_EXTRACT(Info, '$.mountains_visited')) > 1;
    
-- 6. Выполнить запрос, изменяющий значение по некоторому существующему ключу
-- в заданной строке таблицы.

UPDATE Альпинист 
SET Info = JSON_SET(Info, '$.mountains_visited', '0')
WHERE id_Альпиниста = 1;

SELECT * FROM Альпинист;




