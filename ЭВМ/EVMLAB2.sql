USE mydb;
SELECT * FROM ModelsF;
SELECT * FROM furniture;
SELECT * FROM sales;
SELECT * FROM buyers;
SELECT * FROM contract;

/*Запрос с ORDER BY*/
SELECT furniture.name AS "название мебели", furniture.amount AS "Количество", modelsf.modelname AS "Модель мебели"
FROM furniture, modelsf
WHERE furniture.ModelsF_idModelsF = modelsf.idModelsF
ORDER BY furniture.name;

/*запрос с ORDER BY и GROUP BY*/
SELECT modelsf.modelname AS "Модель мебели", SUM(furniture.amount) AS "Количество"
FROM furniture, modelsf
WHERE furniture.ModelsF_idModelsF = modelsf.idModelsF
GROUP BY modelsf.modelname
ORDER BY SUM(furniture.amount);

/*distinct*/
SELECT DISTINCT name FROM furniture;

/*операции сравнения*/
SELECT furniture.name AS "название мебели", furniture.amount AS "Количество", modelsf.modelname AS "Модель мебели"
FROM furniture, modelsf
WHERE furniture.ModelsF_idModelsF = modelsf.idModelsF AND furniture.price < 5000;


/*запрос для предиката IN*/
SELECT modelsf.modelname AS "Модель мебели"
FROM modelsf
WHERE country IN ('Италия','Германия');

/*запрос для предиката BETWEEN*/
SELECT furniture.name AS "название мебели", furniture.amount AS "Количество", modelsf.modelname AS "Модель мебели"
FROM furniture, modelsf
WHERE furniture.ModelsF_idModelsF = modelsf.idModelsF AND furniture.price BETWEEN 5000 AND 10000;

/*запрос для предиката LIKE*/
SELECT modelsf.modelname AS "Модель" FROM modelsf
WHERE modelname LIKE 'СК%';

/*запрос для предиката IS NULL*/
SELECT buyers.name, idcontract FROM buyers, contract
WHERE contract.execution_date IS NULL AND buyers.idbuyers = contract.buyers_idbuyers;

/*запросы с использованием агрегатных функций:*/
/*COUNT*/
SELECT Modelsf_idmodelsf, COUNT(idfurniture)
FROM furniture
GROUP BY Modelsf_idmodelsf
ORDER BY COUNT(idfurniture) DESC;

/*SUM*/
SELECT modelsf.modelname, sales.amount, contract.execution_date, SUM(price * sales.amount)
FROM furniture
JOIN modelsf ON Modelsf_idmodelsf = idmodelsf
JOIN sales ON furniture_idfurniture = idfurniture
JOIN contract ON contract_idcontract = idcontract
WHERE contract.execution_date < '2025-10-10'
GROUP BY modelname,sales.amount,execution_date
ORDER BY modelname ASC;

/*AVG*/
SELECT name, AVG(price)
FROM furniture
GROUP BY name
ORDER BY AVG(price) ASC;

/*MAX*/
SELECT name, MAX(price)
FROM furniture
GROUP BY name;

/*MIN*/
SELECT name, MIN(price)
FROM furniture
GROUP BY name;

/*две связные таблицы, здесь больше*/
SELECT modelsf.modelname, sales.amount AS 'продажа', furniture.amount AS 'Имеется', contract.execution_date
FROM furniture
JOIN sales ON sales.Furniture_idfurniture = furniture.idfurniture
JOIN contract ON sales.contract_idcontract = contract.idcontract
JOIN modelsf ON Modelsf_idmodelsf = modelsf.idmodelsf
WHERE furniture.amount > sales.amount;

/*многотабличный запрос с использованием внутреннего и внешнего соединения*/
SELECT modelsf.modelname, sales.amount AS 'продажа', furniture.amount AS 'Имеется', contract.execution_date
FROM furniture
INNER JOIN sales ON sales.Furniture_idfurniture = furniture.idfurniture
RIGHT JOIN contract ON sales.contract_idcontract = contract.idcontract
LEFT JOIN modelsf ON Modelsf_idmodelsf = modelsf.idmodelsf
WHERE furniture.amount > sales.amount;

/*многотабличный запрос с использованием оператора UNION */
SELECT furniture.name AS "название мебели", furniture.amount AS "Количество", modelsf.modelname AS "Модель мебели"
FROM furniture, modelsf
WHERE furniture.ModelsF_idModelsF = modelsf.idModelsF AND furniture.price<5000
UNION
SELECT furniture.name AS "название мебели", furniture.amount AS "Количество", modelsf.modelname AS "Модель мебели"
FROM furniture, modelsf
WHERE furniture.ModelsF_idModelsF = modelsf.idModelsF AND furniture.price>30000;

/*модификации данных*/
INSERT INTO ModelsF VALUES(16, 'Ш-6', 100, 200, 100, 'Италия');

SELECT * FROM ModelsF;

UPDATE ModelsF
SET width = 90
WHERE idModelsF = 16;

SELECT * FROM ModelsF;

DELETE FROM ModelsF
WHERE idModelsF = 16;

SELECT * FROM ModelsF;

SELECT DISTINCT idmodelsf, modelname, length, height, width, country FROM Modelsf
WHERE idmodelsf IN (SELECT modelsf_idmodelsf FROM furniture) AND country = 'Россия';

SELECT furniture.name, modelname, sales.amount, furniture.price
FROM modelsf JOIN furniture ON modelsf_idmodelsf = idmodelsf
JOIN sales ON furniture_idfurniture = idfurniture
JOIN contract ON contract_idcontract = idcontract
WHERE YEAR(execution_date) = YEAR('2024-01-01');

SELECT COUNT(furniture.name), idcontract
FROM modelsf JOIN furniture ON modelsf_idmodelsf = idmodelsf
JOIN sales ON furniture_idfurniture = idfurniture
JOIN contract ON contract_idcontract = idcontract
WHERE YEAR(execution_date) = YEAR('2024-01-01')
GROUP BY idcontract;

SELECT COUNT(modelname)
FROM modelsf JOIN furniture ON modelsf_idmodelsf = idmodelsf
JOIN sales ON furniture_idfurniture = idfurniture
JOIN contract ON contract_idcontract = idcontract
WHERE YEAR(execution_date) = YEAR('2024-01-01');