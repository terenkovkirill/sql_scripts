/* 1. Выведите суммарное колво пассажиров и колво выживших. 
 * Вычислите долю выживших (в виде десятичной дроби от 0 до 1). */

SELECT count(*) AS count_pass, sum(survived) AS count_surv, sum(survived)::numeric / count(*) AS survival_rate
FROM titanic;


/* 2. Посчитайте по каждому классу билета суммарное колво пассажиров и колво выживших. 
 * Вычислите долю выживших по каждому классу билета (в виде десятичной дроби от 0 до 1). */

SELECT pclass, count(*) AS count_pass, sum(survived) AS count_surv, sum(survived)::numeric / count(*) AS survival_rate
FROM titanic
GROUP BY pclass
ORDER BY pclass;


/* 3. По каждому классу билета и полу пассажира посчитайте: суммарное колво пассажиров, 
 *    колво выживших и долю выживших.*/

SELECT pclass, sex, count(*) AS count_pass, sum(survived) AS count_surv, sum(survived)::numeric / count(*) AS survival_rate
FROM titanic
GROUP BY pclass, sex
ORDER BY pclass, sex;


/* 4. По каждому порту отправления посчитайте колво пассажиров, колво выживших и долю выживших.*/

SELECT embarked, count(*) AS count_pass, sum(survived) AS count_surv, sum(survived)::numeric / count(*) AS survival_rate
FROM titanic
GROUP BY embarked
ORDER BY embarked;


/* 5. Выведите порт отправления с наибольшим колвом пассажиров.*/

SELECT embarked, count(*) AS count_pass
FROM titanic
GROUP BY embarked
ORDER BY count_pass DESC
LIMIT 1;


/* 6. Посчитайте средний возраст пассажиров и средний возраст выживших в группировке по классу билета и полу. */

SELECT pclass, sex, avg(age) AS avg_age_pass, avg(age) FILTER (WHERE survived = 1) AS avg_age_surv
FROM titanic
GROUP BY pclass, sex
ORDER BY pclass, sex;

--или

SELECT pclass, sex, avg(age) AS avg_age_pass, avg(CASE WHEN survived = 1 THEN age end) AS avg_age_surv
FROM titanic
GROUP BY pclass, sex
ORDER BY pclass, sex;

--или 

SELECT pclass, sex, avg(age) AS avg_age_pass
FROM titanic
GROUP BY pclass, sex 
ORDER BY pclass, sex;

SELECT pclass, sex, avg(age) AS avg_age_surv
FROM titanic
WHERE survived = 1
GROUP BY pclass, sex
ORDER by pclass, sex;


/* 7. Выведите первые 10 строк по убыванию стоимости билета. 
 Как Вы считаете, стоимость билета указана на человека?*/

SELECT * FROM titanic
ORDER BY fare DESC LIMIT 10;

--Скорее всего, стоимость билетов указана совместно для пассажиров, которые едут вместе (то есть на рассчитывается на человека)


/* 8. Проверьте, есть ли билеты, для которых цена в разных строках отличается? Выведите их. 
 Аналогично для порта отправления (можно в два запроса).*/

SELECT ticket, count(DISTINCT fare) AS price_variants FROM titanic
GROUP BY ticket 
HAVING count(distinct fare) > 1;

SELECT ticket, count(DISTINCT embarked) AS port_variants FROM titanic
GROUP BY ticket 
HAVING count(DISTINCT embarked) > 1;


/* 9.Для каждого номера билета, класса, цены и порта отправления посчитайте колво строк (колво пассажиров), 
	колво выживших пассажиров.*/

SELECT ticket, pclass, fare, embarked, count(*) AS count_pass, sum(survived) AS count_surv
FROM titanic 
GROUP BY ticket, pclass, fare, embarked;


/* 10. Выведите билеты, для которых колво пассажиров более 1 и все пассажиры выжили.*/

SELECT ticket, count(*) AS count_pass, sum(survived) AS count_surv
FROM titanic
GROUP BY ticket
HAVING count(*) > 1 AND count(*) = sum(survived);


/* 11. Напишите запрос, который посчитает вероятность выжить, если Вас зовут Elizabeth, если Вас зовут Mary 
 * (достаточно посчитать, что такая подстрока должна входить в имя пассажира)*/

SELECT 'Elizabeth', sum(survived)::numeric / count(*) AS survival_rate
FROM titanic
WHERE name ILIKE '%Elizabeth%'

UNION

SELECT 'Mary', sum(survived)::numeric / count(*) AS survival_rate
FROM titanic
WHERE name ILIKE '%Mary%';

--или 

SELECT 
	CASE 
		WHEN name ILIKE '%Elizabeth%' THEN 'Elizabath'
		WHEN name ILIKE '%Mary%' 	  THEN 'Mary'
	END AS person,
	sum(survived)::numeric / count(*) AS survival_rate
FROM titanic
WHERE name ILIKE '%Elizabeth%' OR name ILIKE '%Mary%'
GROUP BY person;
	

/* 12.	* (необязательный пункт) Можно услышать мнение, что наибольшее количество мужчин спаслось из 3его класса, 
 * потому что мужчины с билетом 1ого класса в отличие от обладателей билетов 3его класса имели 
 * определенное воспитание («джентельменство»), которое не позволяло им сесть в лодку до женщин. 
 * В этом пункте Вам предлагается выдвинуть аргументы: поддержать или опровергнуть это мнение 
 * (обратите внимание, что можно опровергать даже не мнение, а факт, который лежит в основе мнения).*/

SELECT pclass, sex, sum(survived) AS count_surv,  avg(survived) AS survival_rate 
FROM titanic
GROUP BY pclass, sex
ORDER BY sex, pclass;

/* Наибольшее количество мужчин дествительно спаслось из 3-го класса, 
 *но процент выживаемости среди мужчин сильно выше в первом. Однако, исходя из выведенных данных,
 *выводы о "джентельсместве" можно сделать, скорее, о мужчинах 2-го класса, так как процент выживаемости среди них
 *низок (15.7 %), а среди женщин 2-го класса высок (92.1 %). */