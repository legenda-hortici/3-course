USE DBLabs;

INSERT INTO department VALUES ('Математическое', 1);
INSERT INTO department VALUES ('Программное', 2);
INSERT INTO department VALUES ('Физическое', 3);
INSERT INTO department VALUES ('Инженерное', 4);
INSERT INTO department VALUES ('Лабораторное', 5);
INSERT INTO department VALUES ('Методическое', 6);
INSERT INTO department VALUES ('Проффесорское', 7);
INSERT INTO department VALUES ('Исследовательское', 8);
INSERT INTO department VALUES ('Производственное', 9);
INSERT INTO department VALUES ('Программной инженерии', 10);
INSERT INTO department VALUES ('Экономики', 11);

INSERT INTO discipline VALUES ('Вычислительные методы', 1);
INSERT INTO discipline VALUES ('Математический рассчет', 2);
INSERT INTO discipline VALUES ('Большие данные', 3);
INSERT INTO discipline VALUES ('Физика', 4);
INSERT INTO discipline VALUES ('Сопротивление материалов', 5);
INSERT INTO discipline VALUES ('Основы программирования', 6);
INSERT INTO discipline VALUES ('Программная инженерия', 7);
INSERT INTO discipline VALUES ('Компьютерная графика', 8);
INSERT INTO discipline VALUES ('Базы данных', 9);
INSERT INTO discipline VALUES ('Искусственный интеллект', 10);
INSERT INTO discipline VALUES ('Искусственный интеллект', 10);

INSERT INTO employee (id_employee, NSL_employee, employee_gender, employee_address, employee_birthdate, Department_id_department)
VALUES(1, 'Алексеев Алексей Алексеевич', 'М', 'Алексеевская 1', '1987-02-19', 1),
(2, 'Иванов Иван Иванович', 'М', 'Алексеевская 10', '1973-01-01', 1),
(3, 'Андреев Андрей Андреевич', 'М', 'Алексеевская 5', '1965-05-27', 2),
(4, 'Антонова Антонина Антоновна', 'Ж', 'Производственная 10', '1983-11-05', 3),
(5, 'Викторов Виктор Викторович', 'М', 'Алексеевская 2', '1999-05-01', 4),
(6, 'Антонов Антон Антонович', 'М', 'Производственная 10', '1985-09-12', 6),
(7, 'Олегов Олег Олегович', 'М', 'Алексеевская 19', '1969-07-19', 6),
(8, 'Игорев Игорь Игоревич', 'М', 'Горизонтальная 15', '1992-03-10', 7),
(9, 'Иринова Ирина Антоновна', 'Ж', 'Алексеевская 29', '1982-03-09', 8),
(10, 'Кириллов Кирилл Кириллович', 'М', 'Алексеевская 4', '1972-07-15', 10);
INSERT INTO employee (id_employee, NSL_employee, employee_gender, employee_address, employee_birthdate, Department_id_department)
VALUES(11, 'Олегова Ольга Олеговна', 'М', 'Алексеевская 19', '1972-07-15', 2);

INSERT INTO employee_has_discipline
VALUES(1,7),
(1,1),
(1,2),
(2,3),
(3,3),
(4,4),
(4,5),
(6,1),
(7,6),
(8,7),
(9,9),
(10,10);



/*запрос с Order by*/
SELECT NSL_employee AS 'ФИО', employee_gender AS 'Пол' FROM employee
ORDER BY 'ФИО' ASC;

/*запрос с Order by и Group by*/
SELECT Department_id_department AS 'Номер подразделения', COUNT(NSL_employee) AS 'Количество сотрудников' FROM employee
GROUP BY Department_id_department 
ORDER BY COUNT(NSL_employee) DESC;

/*запрос с DISTINCT*/
SELECT COUNT(DISTINCT Discipline_id_discipline) FROM employee_has_discipline;

/*запрос с операцией сравнения*/
SELECT NSL_employee AS 'ФИО', employee_gender AS 'Пол', ROUND(employee_age/365,0) AS 'Возраст' FROM employee
WHERE employee_age/365 > 40;

/*запрос для IN*/
SELECT * FROM employee
WHERE Department_id_department IN (1,2,3);

/*запрос для BETWEEN*/
SELECT NSL_employee AS 'ФИО', employee_gender AS 'Пол', ROUND(employee_age/365,0) AS 'Возраст' FROM employee
WHERE  ROUND(employee_age/365,0) BETWEEN 30 AND 50;

/*запрос для LIKE*/
SELECT NSL_employee AS 'ФИО', employee_gender AS 'Пол', ROUND(employee_age/365,0) AS 'Возраст' FROM employee
WHERE  NSL_employee LIKE 'Ан%' OR NSL_employee LIKE 'И%';

/*запрос для IS NULL*/
SELECT * FROM department
WHERE NOT (department_name IS NULL);

/*Запросы с использованием агрегатных функций производящие обобщенную групповую обработку значений полей*/
/*AVG*/
SELECT employee_gender AS 'Пол', AVG(ROUND(employee_age/365,0)) AS 'Средний Возраст' FROM employee
GROUP BY employee_gender
HAVING AVG(ROUND(employee_age/365,0))>30;

/*COUNT*/
SELECT Employee_id_employee AS 'номер сотрудника', COUNT(Discipline_id_discipline) AS 'Преподаваемые предметы'
FROM employee_has_discipline
GROUP BY Employee_id_employee
HAVING COUNT(Discipline_id_discipline) > 1 ;

/*SUM*/
SELECT employee_gender AS 'Пол', SUM(ROUND(employee_age/365,0)) AS 'сумма возраста' FROM employee
GROUP BY employee_gender
HAVING SUM(ROUND(employee_age/365,0))>90;

/*MAX*/
SELECT Department_id_department AS 'Подразделение', MAX(employee_birthdate) AS 'Максимальный возраст' FROM employee
GROUP BY Department_id_department
HAVING MAX(employee_birthdate) < '1990-01-01';

/*MIN*/
SELECT Department_id_department AS 'Подразделение', MIN(employee_birthdate) AS 'Минимальный возраст' FROM employee
GROUP BY Department_id_department
HAVING MIN(employee_birthdate) > '1980-01-01';

/*Запрос на выборку данных из двух связанных таблиц, несколько полей по которым сортируется вывод*/
SELECT Employee_id_employee AS 'Номер сотрудника', NSL_employee AS 'ФИО', Discipline_id_discipline AS 'Номер дисциплины'
FROM employee, employee_has_discipline
WHERE employee_has_discipline.Employee_id_employee = employee.id_employee
ORDER BY NSL_employee, Discipline_id_discipline DESC;

/*многотабличный запрос с испольованием внутреннего и внешнего соединения
inner join*/
SELECT id_department, department_name, NSL_employee, employee_gender, ROUND(employee_age/365,0) 
FROM department INNER JOIN employee
ON id_department = Department_id_department
ORDER BY id_department;

/*LEFT JOIN - левое внешнее*/
SELECT *
FROM employee LEFT JOIN employee_has_discipline
ON id_employee = Employee_id_employee;

/*многотабличный запрос с использованием UNION*/
SELECT Department_id_department AS 'Номер подразделения' FROM employee
WHERE Department_id_department <5
UNION
SELECT id_department FROM department
WHERE id_department > 8;

/*Запрос с применением подзапроса в части WHERE*/
SELECT id_employee AS 'Номер сотрудника', NSL_employee AS 'ФИО', ROUND(employee_age/365,0) AS 'Возраст',
employee_address AS 'Адрес'
FROM employee
WHERE NOT id_employee IN
(SELECT Employee_id_employee
FROM employee_has_discipline);

/*запрос с подзапросом в HAVING*/
SELECT Employee_id_employee AS 'Номер сотрудника', Discipline_id_discipline AS 'Номер предмета'
FROM employee_has_discipline
GROUP BY Employee_id_employee, Discipline_id_discipline
HAVING Employee_id_employee IN 
	(SELECT id_employee FROM employee
    WHERE ROUND(employee_age/365,0) < 50)
ORDER BY Employee_id_employee;

/*запрос с применением подзапроса с операторами ALL EXIST ANY*/
SELECT id_employee AS 'Номер сотрудника', NSL_employee AS 'ФИО'
FROM employee
WHERE id_employee > ALL (SELECT Employee_id_employee FROM employee_has_discipline);

/*EXIST*/
SELECT id_department, department_name
FROM department
WHERE EXISTS (SELECT Department_id_department FROM employee WHERE ROUND(employee_age/365,0) > 50
AND employee.Department_id_department = department.id_department);

/*ANY*/
SELECT id_discipline, name_discipline
FROM discipline
WHERE id_discipline = ANY (
	SELECT Discipline_id_discipline FROM employee_has_discipline, employee
    WHERE Employee_id_employee = id_employee AND ROUND(employee_age/365,0) >40);

    
/*Функции системы:*/


/*Дисциплины, читаемые сотрудниками или определенным сотрудником, здесь - определённым*/
SELECT name_discipline AS 'Дисциплины сотрудника 1', id_discipline AS 'Номер дисциплины'
FROM discipline
JOIN employee_has_discipline
ON Discipline_id_discipline = id_discipline AND Employee_id_employee = 1;

/*список сотрудников по подразделениям или определенному подразделению - здесь по подразделениям*/
SELECT Department_id_department AS 'Номер подразделения', id_employee AS 'Номер сотрудника', NSL_employee AS 'ФИО', ROUND(employee_age/365,0) AS 'Возраст', 
employee_address AS 'Адрес'
FROM employee
JOIN department
ON id_department = Department_id_department
ORDER BY Department_id_department;

/*посчитать количество сотрудников по подразделениям*/
SELECT Department_id_department AS 'Номер подразделения', COUNT(id_employee) AS 'Количество сотрудников'
FROM employee
JOIN department
ON id_department = Department_id_department
GROUP BY Department_id_department;

/*подсчитать средний возраст сотрудников по подразделениям*/
SELECT Department_id_department AS 'Номер подразделения', ROUND(AVG(employee_age)/365,0) AS 'Средний возраст'
FROM employee
JOIN department
ON id_department = Department_id_department
GROUP BY Department_id_department;

/*Выбрать дисциплины, читаемые сотрудниками по подразделениями или определенному подразделению - по определенному*/
SELECT id_discipline AS 'Номер дисциплины', name_discipline AS 'Название дисциплины'
FROM discipline, employee_has_discipline, employee
WHERE id_discipline = Discipline_id_discipline AND id_employee = Employee_id_employee AND (Department_id_department = 1);

/*подсчитать количество дисциплин по подразделениям тут ошибка надо просто несколько джоинов*/

SELECT T1.Department_id_department AS 'Номер подразделения', COUNT(DISTINCT T2.Discipline_id_discipline) AS 'Количество дисцплин'
FROM
(SELECT Department_id_department, id_employee
FROM employee
JOIN employee_has_discipline
ON id_employee = Employee_id_employee) AS T1
JOIN 
(SELECT Discipline_id_discipline, Employee_id_employee
FROM employee_has_discipline
JOIN employee
ON id_employee = Employee_id_employee) AS T2
ON T1.id_employee = T2.Employee_id_employee
GROUP BY T1.Department_id_department;

/*вывести подразделения, сотрудники которых не участвуют в учебном процессе*/
SELECT id_department AS 'Номер подразделения', department_name AS 'Название подразделения'
FROM department
WHERE NOT id_department IN 
	(SELECT Department_id_department
	FROM employee
	JOIN employee_has_discipline
	ON id_employee = Employee_id_employee)