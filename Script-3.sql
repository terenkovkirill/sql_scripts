
--1. Создал таблицу, заполнил данными. Создал Primary Key на 2 поля

--2. Функция CAST
SELECT DISTINCT CAST(data AS date) FROM table1;

--3. ORDER BY
SELECT DISTINCT pokupatel FROM table1
ORDER BY pokupatel;

--4. WHERE
SELECT DISTINCT tovar FROM table1
WHERE price > 10;

--5. WHERE (работа с date)
SELECT DISTINCT pokupatel FROM table1
WHERE '2025-09-15' <= data 
	AND data < '2025-09-22';

--6. Добавление столбца в SELECT
SELECT ndoc, data, pokupatel, tovar, number, price, number * price AS cost FROM table1;

--7. Двойная сордировка
SELECT ndoc, data, pokupatel, tovar, number, price FROM table1 
WHERE DATE_TRUNC('year', CURRENT_DATE) <= data AND data < DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 month' 
	AND (
		pokupatel LIKE 'A%'  
		OR number > 5 AND price < 10
		)
ORDER BY data ASC, price DESC;

--8. LIMIT (TOP)
SELECT DISTINCT pokupatel FROM table1
WHERE EXTRACT(YEAR FROM data) = EXTRACT(YEAR FROM CURRENT_DATE) - 1 
	AND EXTRACT(MONTH FROM data) = 9
ORDER BY pokupatel 
LIMIT 5;

--9. Параметр задаёт значение атрибута
SELECT DISTINCT pokupatel FROM table1
WHERE tovar = :param;

--10.
SELECT ndoc FROM table1 
ORDER BY number * price DESC
LIMIT 1;

--11. GROUP BY
SELECT ndoc, SUM(number * price) AS itogo FROM table1
GROUP BY ndoc;

