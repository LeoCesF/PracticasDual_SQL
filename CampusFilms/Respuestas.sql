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
WHERE MOVIE_RELEASE_DATE >= '2000-01-01'
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

/*SELECT
 	MOVIE_NAME
  FROM
 	MOVIES
  WHERE
 	DIRECTOR_ID IN (
 		SELECT
 			DIRECTOR_ID
 		FROM
 			DIRECTORS
 		WHERE
 			YEAR(DIRECTOR_BIRTH_DATE) > 1900
 		AND
 			DIRECTOR_DEAD_DATE IS NULL); */

/* 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores */
SELECT use.USER_TOWN AS "Ciudad"
	dir.DIRECTOR_NAME
	dir.DIRECTOR_BIRTH_PLACE
FROM USERS use
JOIN DIRECTORS dir
	ON use.USER_TOWN = dir.DIRECTOR_BIRTH_PLACE;

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
ORDER BY ACCESS_DATE DESC 
LIMIT 10;

/* 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años */ 
SELECT COUNT(mov.MOVIE_ID) AS "Numero peliculas antes 41"
FROM MOVIES mov
JOIN DIRECTORS dir
	ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
WHERE mov.DIRECTOR_ID = dir.DIRECTOR_ID
	AND datediff(year, MOVIE_RELEASE_DATE, CURDATE()) < 41
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
SELECT GROUP_CONCAT(mov.MOVIE_NAME) AS "Nombre",
	min(MOVIE_DURATION) AS "Duracion minima"
FROM MOVIES mov
JOIN USER_MOVIE_ACCESS uma
	ON mov.MOVIE_ID = uma.MOVIE_ID
WHERE dateadd(YEAR, -2, date '2019-01-25') < uma.ACCESS_DATE
GROUP BY mov.MOVIE_DURATION
ORDER BY "Duracion minima"
LIMIT 1;

/* 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 
/que contengan la palabra “The” en cualquier parte del título */
SELECT count(MOVIE_ID) AS "Numero peliculas"
FROM MOVIES mov
WHERE YEAR(MOVIE_RELEASE_DATE) >= 1960
	AND YEAR(MOVIE_RELEASE_DATE) < 1990
	AND UPPER(MOVIE_NAME) LIKE '%THE%';

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
SELECT dir.DIRECTOR_NAME AS "Director"
FROM DIRECTORS dir
JOIN MOVIES mov
	ON dir.DIRECTOR_ID = mov.DIRECTOR_ID
JOIN USER_MOVIE_ACCESS uma
	ON mov.MOVIE_ID = uma.MOVIE_ID
GROUP BY DIRECTOR_ID
ORDER BY count(MOVIE_ID) DESC
LIMIT 1;

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
SELECT count(DISTINCT(ACTOR_ID)) AS "nº actores",
	count(DISTINCT(DiRECTOR_ID)) AS "nº directores"
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
SELECT use.USER_NAME AS "Nombre",
	use.USER_TOWN AS "Ciudad",
	use.USER_PHONE AS "Telefono"
FROM USERS use
JOIN USER_MOVIE_ACCESS uma
	ON use.USER_ID = uma.USER_ID
JOIN MOVIES mov
	ON uma.MOVIE_ID = mov.MOVIE_ID
JOIN AWARDS awa
	ON mov.MOVIE_ID = awa.MOVIE_ID
WHERE AWARD_NOMINATION > 150
	AND AWARD_WIN < 50;

/* 33- Comprueba si hay errores en la BD entre las películas y directores 
(un director muerto en el 76 no puede dirigir una película en el 88)*/
SELECT dir.DIRECTOR_ID AS "ID Director",
	dir.DIRECTOR_DEAD_DATE AS "Fecha muerte director",
	mov.MOVIE_RELEASE_DATE AS "Fecha lanzamiento pelicula"
FROM DIRECTORS dir
JOIN MOVIES mov
	ON dir.DIRECTOR_ID = mov.DIRECTOR_ID
WHERE DIRECTOR_DEAD_DATE < MOVIE_RELEASE_DATE;
/* 27	1995-05-04	2001-07-21
   27	1995-05-04	2000-11-13
   47	2001-04-08	2009-11-23
   
/* 34- Utilizando la información de la sentencia anterior, 
modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL) */
UPDATE DIRECTORS
SET DIRECTOR_DEAD_DATE = (
	SELECT MAX(DATEADD(YEAR, 1, MOV.MOVIE_RELEASE_DATE))
	FROM MOVIES MOV
	JOIN DIRECTORS DIR
		ON MOV.DIRECTOR_ID = DIR.DIRECTOR_ID
	WHERE dir.DIRECTOR_DEAD_DATE < mov.MOVIE_RELEASE_DATE
)

WHERE DIRECTOR_ID IN (
SELECT movi.DIRECTOR_ID
	FROM MOVIES movi
	JOIN DIRECTOR dire
		ON movi.DIRECTOR_ID = dire.DIRECTOR_ID
	WHERE dire.DIRECTOR_DEAD_DATE < movi.MOVIE_RELEASE_DATE
);

/* 35-Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película */ 
-- PRUEBA PROPIA
SELECT count(MOVIE_ID) AS "nº peliculas", 
	dir.DIRECTOR_NAME,
	gen.GENRE_NAME
FROM MOVIES mov
JOIN DIRECTORS dir
	ON mov.DIRECTOR_ID = dir.DIRECTOR_ID
JOIN GENRES gen
	ON mov.GENRE_ID = gen.GENRE_ID
GROUP BY dir.DIRECTOR_NAME, gen.GENRE_NAME
ORDER BY dir.DIRECTOR_NAME;


-- OPCION FACIL:
WITH GENRE_COUNTS AS (
	SELECT DIR.DIRECTOR_ID,
		DIR.DIRECTOR_NAME ,
		GEN.GENRE_ID ,
		GEN.GENRE_NAME,
		COUNT(GEN.GENRE_NAME) AS NUM_MOVIES
	FROM PUBLIC.MOVIES MOV
	JOIN PUBLIC.GENRES GEN
		ON MOV.GENRE_ID = GEN.GENRE_ID
	JOIN PUBLIC.DIRECTORS DIR
		ON MOV.DIRECTOR_ID = DIR.DIRECTOR_ID 
	GROUP BY GEN.GENRE_ID, DIR.DIRECTOR_ID
),
MAX_GENRE AS (
	SELECT DIRECTOR_ID,
		MAX(NUM_MOVIES)
	FROM GENRE_COUNTS
	GROUP BY DIRECTOR_ID 
)
SELECT 
	GCO.DIRECTOR_NAME,
	GROUP_CONCAT(GCO.GENRE_NAME)
FROM GENRE_COUNTS GCO
JOIN MAX_GENRE MGE
	ON GCO.DIRECTOR_ID = MGE.DIRECTOR_ID
	AND GCO.NUM_MOVIES = MGR.MAX_MOVIES
GROUP BY GCO.DIRECTOR_NAME

-- OTRA OPCION:
WITH count_genero as(
	SELECT d.DIRECTOR_ID AS DIRECTOR,
	g.GENRE_NAME AS GENERO,
	count(g.GENRE_ID) AS SUMA
	FROM PUBLIC.DIRECTORS d
	JOIN PUBLIC.MOVIES m ON m.DIRECTOR_ID = d.DIRECTOR_ID
	JOIN PUBLIC.GENRES g ON g.GENRE_ID = m.GENRE_ID
	GROUP BY d.DIRECTOR_ID, G.GENRE_ID
)
SELECT d.DIRECTOR_NAME AS "Director",
	GROUP_CONCAT(cg.GENERO SEPARATOR ', ')  AS "Genero"
FROM PUBLIC.DIRECTORS d
JOIN count_genero cg ON cg.DIRECTOR = d.DIRECTOR_ID
WHERE cg.SUMA = (SELECT MAX(SUMA) FROM count_genero WHERE d.DIRECTOR_ID = DIRECTOR)
GROUP BY d.DIRECTOR_NAME;

/* 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas */
WITH TOTAL_NAT AS (
SELECT STU.STUDIO_ID,
	STU.STUDIO_NAME,
	NAT.NATIONALITY_ID,
	NAT.NATIONALITY_NAME,
	COUNT(NAT.NATIONALITY_ID) AS NUM_MOVIES
FROM MOVIES MOV
JOIN NATIONALITIES NAT
	ON MOV.NATIONALITY_ID = NAT.NATIONALITY_ID
JOIN STUDIOS STU
	ON MOV.STUDIO_ID = STU.STUDIO_ID
GROUP BY STU.STUDIO_ID,
	NAT.NATIONALITY_ID
ORDER BY 
	STU.STUDIO_ID ASC,
	NUM_MOVIES  DESC
),
MAX_NAT AS (
	SELECT STUDIO_ID,
		MAX(NUM_MOVIES) AS MAX_MOVIES
	FROM TOTAL_NAT
	GROUP BY STUDIO_ID
)
SELECT STUDIO_NAME,
	GROUP_CONCAT(NATIONALITY_NAME) AS NATIONALITY_NAME
FROM TOTAL_NAT AS TNA
JOIN MAX_NAT MNA
	ON TNA.STUDIO_ID = MNA.STUDIO_ID
	AND TNA.NUM_MOVIES = MNA.MAX_MOVIES
GROUP BY STUDIO_NAME;  
	
/**/
SELECT
	USER_NAME,
	MOVIE_NAME
FROM
	(
	SELECT
		a.NATIONALITY_ID,
		a.USER_NAME,
		a.USER_ID,
		a.MOVIE_ID,
		a.ACCESS_DATE
	FROM
		(
		SELECT
			NATIONALITY_ID,
			USER_NAME,
			MMR.USER_ID,
			MOVIE_ID,
			ACCESS_DATE
		FROM
			NATIONALITIES N
		INNER JOIN (
			SELECT
				USER_NAME,
				USER_ID,
				SUBSTR(USER_PHONE, LENGTH(USER_PHONE), 1) AS LAST_NUMBER
			FROM
				USERS) M ON
			N.NATIONALITY_ID = M.LAST_NUMBER
		INNER JOIN USER_MOVIE_ACCESS MMR ON
			MMR.USER_ID = M.USER_ID
		ORDER BY
			MMR.USER_ID,
			MMR.ACCESS_DATE ASC) a
	INNER JOIN (
		SELECT
			USER_ID,
			MIN(ACCESS_DATE) AS ACCESS_DATE
		FROM
			(
			SELECT
				NATIONALITY_ID,
				USER_NAME,
				MMR.USER_ID,
				MOVIE_ID,
				ACCESS_DATE
			FROM
				NATIONALITIES N
			INNER JOIN (
				SELECT
					USER_NAME,
					USER_ID,
					SUBSTR(USER_PHONE, LENGTH(USER_PHONE), 1) AS LAST_NUMBER
				FROM
					USERS) M ON
				N.NATIONALITY_ID = M.LAST_NUMBER
			INNER JOIN USER_MOVIE_ACCESS MMR ON
				MMR.USER_ID = M.USER_ID
			ORDER BY
				MMR.USER_ID,
				MMR.ACCESS_DATE ASC)
		GROUP BY
			USER_ID ) b ON
		a.USER_ID = b.USER_ID
		AND a.ACCESS_DATE = b.ACCESS_DATE) MEM
INNER JOIN MOVIES ON
	MEM.MOVIE_ID = MOVIES.MOVIE_ID 
