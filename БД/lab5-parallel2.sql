USE DBLabs;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM discipline;
COMMIT;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM discipline;
COMMIT;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM discipline;
/*параллельная транзакция меняет что-то с COMMIT */
SELECT * FROM discipline;
COMMIT;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM discipline;
/*параллельная транзакция меняет что-то с COMMIT */
SELECT * FROM discipline;
COMMIT;