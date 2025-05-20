/* 1- Devuelve todas las películas */
SELECT * FROM movies;

/* 2- Devuelve todos los géneros existentes */
SELECT * FROM genres;

/* 3- Devuelve la lista de todos los estudios de grabación que estén activos */
SELECT * FROM Studios
WHERE studio_active = 1;

/* 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma */
SELECT * FROM users
ORDER BY user_join_date desc
LIMIT 20;

/* 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor */
SELECT movie_duration, 
COUNT(MOVIE_ID) AS "Numero de veces"
FROM movies
GROUP BY MOVIE_DURATION 
ORDER BY MOVIE_DURATION 
LIMIT 20;

/* 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A. */
SELECT MOVIE_RELEASE_DATE
FROM MOVIES
WHERE MOVIE_RELEASE_DATE > '2000-01-01'
AND MOVIE_NAME LIKE 'A%'
ORDER BY MOVIE_RELEASE_DATE ;

/* 7- Devuelve los actores nacidos un mes de Junio */
SELECT ACTOR_NAME AS "Actores nacidos en Junio"
FROM ACTORS 
WHERE MONTH(ACTOR_BIRTH_DATE) = 6;

/* 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos */
SELECT ACTOR_NAME AS "Actores no nacidos en Junio"
FROM ACTORS 
WHERE MONTH(ACTOR_BIRTH_DATE) != 6
AND ACTOR_DEAD_DATE IS NULL ;

/* 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos */
SELECT DIRECTOR_NAME AS "Nombre",
datediff(year, DIRECTOR_BIRTH_DATE, CURDATE()) AS "Edad"
FROM DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL 
AND datediff(year, DIRECTOR_BIRTH_DATE, CURDATE()) <= 50
ORDER BY "Edad"; 

/* 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido */ 
SELECT ACTOR_NAME AS "Nombre",
datediff(year, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE)
FROM ACTORS
WHERE ACTOR_DEAD_DATE IS NOT NULL 
AND datediff(year, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) < 50
ORDER BY datediff(year, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE); 

/* 11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos */
SELECT DIRECTOR_NAME AS "Nombre",
datediff(year, DIRECTOR_BIRTH_DATE, CURDATE()) AS "Edad"
FROM DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL 
AND datediff(year, DIRECTOR_BIRTH_DATE, CURDATE()) <= 40
ORDER BY "Edad"; 

/* 12- Indica la edad media de los directores vivos */
SELECT avg(datediff(year, DIRECTOR_BIRTH_DATE, CURDATE())) AS "Media edad"
FROM DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL; 

/* 13- Indica la edad media de los actores que han fallecido */
SELECT avg(datediff(year, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE)) AS "Media edad"
FROM ACTORS
WHERE ACTOR_DEAD_DATE IS NOT NULL; 

/* 14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado */ 
SELECT mov.MOVIE_NAME AS "Nombre pelicula",
stu.STUDIO_NAME AS "Nombre estudio"
FROM MOVIES mov
JOIN STUDIOS stu
ON mov.STUDIO_ID = stu.STUDIO_ID;

/* 15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015 */
SELECT DISTINCT(use.USER_NAME) AS "Miemrbros"
FROM USERS use
JOIN USER_MOVIE_ACCESS uma
ON use.USER_ID = uma.USER_ID
WHERE ACCESS_DATE BETWEEN '2010-01-01' AND '2015-12-31';
/* year(uma.ACCESS_DATE >= 2010
 * and (uma.ACCESS_DATE <= 2015) */

/* 16- Devuelve cuantas películas hay de cada país */
SELECT count(MOVIE_ID) AS "Num peliculas x pais",
nat.NATIONALITY_NAME AS "Paises"
FROM MOVIES mov
JOIN NATIONALITIES nat
ON mov.NATIONALITY_ID = nat.NATIONALITY_ID
GROUP BY NATIONALITY_NAME
ORDER BY "Num peliculas x pais";

/* 17- Devuelve todas las películas que hay de género documental */
SELECT mov.MOVIE_NAME AS "Nombre pelicula"
FROM MOVIES mov
JOIN GENRES gen
ON mov.GENRE_ID = gen.GENRE_ID
WHERE GENRE_NAME LIKE 'Documentary';

/* 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos */ 
SELECT mov.MOVIE_NAME AS "Nombre pelicula"
FROM MOVIES mov
JOIN DIRECTORS dir 
ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
WHERE year(DIRECTOR_BIRTH_DATE) >= 1980
AND DIRECTOR_DEAD_DATE IS NULL;

/* 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores */
SELECT use.USER_TOWN AS "Ciudad"
FROM USERS use
JOIN 

/* 20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo*/
SELECT mov.MOVIE_NAME AS "Nombre",
mov.MOVIE_RELEASE_DATE AS "Año"
FROM MOVIES mov
JOIN STUDIOS stu
ON mov.STUDIO_ID = stu.STUDIO_ID
WHERE STUDIO_ACTIVE = 0;

/* 21- Devuelve una lista de las últimas 10 películas a las que se ha accedido */
SELECT mov.MOVIE_NAME AS "Nombre"
FROM MOVIES mov
JOIN USER_MOVIE_ACCESS uma
ON mov.MOVIE_ID = uma.MOVIE_ID
ORDER BY ACCESS_DATE
LIMIT 10;

/* 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años */ 
SELECT COUNT(mov.MOVIE_ID) AS "Numero peliculas antes 41"
FROM MOVIES mov
JOIN DIRECTORS dir
ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
WHERE mov.DIRECTOR_ID = dir.DIRECTOR_ID
AND datediff(year, DIRECTOR_BIRTH_DATE, CURDATE()) < 41
GROUP BY DIRECTOR_ID
ORDER BY "Numero peliculas antes 41";

/* 23- Indica cuál es la media de duración de las películas de cada director */
SELECT dir.DIRECTOR_NAME,
avg(mov.movie_duration) AS "Duracion media"
FROM MOVIES mov
JOIN DIRECTORS dir
ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
GROUP BY DIRECTOR_NAME
ORDER BY "Duracion media";

/* 24- Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los miembros del plataforma 
(La “fecha de ejecución” de esta consulta es el 25-01-2019) */
SELECT mov.MOVIE_NAME AS "Nombre",
min(MOVIE_DURATION) AS "Duracion minima"
FROM MOVIES mov
JOIN USER_MOVIE_ACCESS uma
ON mov.MOVIE_ID = uma.MOVIE_ID
WHERE datediff(YEAR,ACCESS_DATE) <= '2017-01-25'
GROUP BY mov.MOVIE_NAME
ORDER BY "Duracion minima";

/* 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 
/que contengan la palabra “The” en cualquier parte del título */
SELECT count(MOVIE_ID) AS "Numero peliculas"
FROM MOVIES mov
WHERE YEAR(MOVIE_RELEASE_DATE) >= 1960
AND YEAR(MOVIE_RELEASE_DATE) < 1990
AND MOVIE_NAME LIKE '%The%';

SELECT mov.MOVIE_NAME,
mov.MOVIE_RELEASE_DATE,
dir.DIRECTOR_NAME
FROM MOVIES mov
JOIN DIRECTORS dir
ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
WHERE YEAR(MOVIE_RELEASE_DATE) >= 1960
AND YEAR(MOVIE_RELEASE_DATE) < 1990
ORDER BY MOVIE_RELEASE_DATE;


/* 26- Lista nombre, nacionalidad y director de todas las películas */
SELECT mov.MOVIE_NAME AS "Nombre",
nat.NATIONALITY_NAME AS "Nacionalidad",
dir.DIRECTOR_NAME AS "Director"
FROM MOVIES mov
JOIN NATIONALITIES nat
ON mov.NATIONALITY_ID = nat.NATIONALITY_ID
JOIN DIRECTORS dir
ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
ORDER BY MOVIE_NAME;

/* 27- Muestra las películas con los actores que han participado en cada una de ellas */ 
SELECT mov.MOVIE_NAME AS "Nombre",
group_concat(act.ACTOR_NAME) AS "Actores"
FROM MOVIES mov
JOIN MOVIES_ACTORS mai
ON mov.MOVIE_ID = mai.MOVIE_ID
JOIN ACTORS act
ON mai.ACTOR_ID = act.ACTOR_ID
GROUP BY MOVIE_NAME;

/* 28- Indica cual es el nombre del director del que más películas se ha accedido */
SELECT top 1 dir.DIRECTOR_NAME AS "Director"
FROM DIRECTORS dir
JOIN MOVIES mov
ON dir.DIRECTOR_ID = mov.DIRECTOR_ID
JOIN USER_MOVIE_ACCESS uma
ON mov.MOVIE_ID = uma.MOVIE_ID
GROUP BY DIRECTOR_ID
ORDER BY count(MOVIE_ID) desc;

/* 29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado */
SELECT sum(AWARD_WIN) AS "nº Premios ganados",
stu.STUDIO_NAME AS "Estudio"
FROM PUBLIC.AWARDS awa
JOIN PUBLIC.MOVIES mov
ON awa.MOVIE_ID = mov.MOVIE_ID
JOIN PUBLIC.STUDIOS stu
ON mov.STUDIO_ID = stu.STUDIO_ID
GROUP BY stu.STUDIO_NAME
ORDER BY "nº Premios ganados" desc;

/* 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido 
Si una película está nominada a un premio, su actor también lo está) */
SELECT awa.AWARD_ALMOST_WIN AS "Premios nominados",
act.ACTOR_NAME 
FROM PUBLIC.AWARDS awa
JOIN PUBLIC.MOVIES mov
ON awa.MOVIE_ID = mov.MOVIE_ID
JOIN PUBLIC.MOVIES_ACTORS mac 
ON mov.MOVIE_ID = mac.MOVIE_ID
JOIN PUBLIC.ACTORS act 
ON mac.ACTOR_ID = act.ACTOR_ID
WHERE awa.AWARD_ALMOST_WIN > 0
ORDER BY "Premios nominados";

/* 31- Indica cuantos actores y directores hicieron películas para los estudios no activos */
SELECT count(ACTOR_ID) AS "nº actores",
count(DiRECTOR_ID) AS "nº directores"
FROM ACTORS act
JOIN MOVIES_ACTORS mac
ON act.ACTOR_ID = mac.ACTOR_ID
JOIN MOVIES mov
ON mac.MOVIE_ID = mov.MOVIE_ID
JOIN DIRECTORS dir
ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
JOIN STUDIOS stu
ON mov.STUDIO_ID = stu.STUDIO_ID
WHERE stu.STUDIO_ACTIVE = 0;

/* 32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas 
que hayan sido nominadas a más de 150 premios y ganaran menos de 50 */
SELECT USER_NAME AS "Nombre",
USER_TOWN AS "Ciudad",
USER_PHONE AS "Telefono"