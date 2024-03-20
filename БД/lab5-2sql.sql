USE DBLabs;


/*транзакция с ROLLBACK  - не изменяет таблицу*/
START TRANSACTION;
INSERT INTO discipline 
VALUES('Transaction science', 12);
ROLLBACK;

SELECT * FROM discipline;

/*Транзакция с COMMIT - изменения сохраняются*/
START TRANSACTION;
INSERT INTO discipline 
VALUES('Transaction science', 11);
COMMIT;

SELECT * FROM discipline;




/*для демнстрации uncommited and commited*/

START TRANSACTION;
INSERT INTO discipline
VALUES ('transaction test', 14), ('transaction test', 15);
ROLLBACK;

SELECT * FROM discipline;

/*возможность записи в уже прочитанные данные*/
START TRANSACTION;
INSERT INTO discipline
VALUES ('transaction test', 12), ('transaction test', 13);
COMMIT;

DELETE FROM discipline WHERE id_discipline = 12 OR id_discipline = 13;
COMMIT;