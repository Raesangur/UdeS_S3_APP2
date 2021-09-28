-- CREATE FUNCTION TABLEAU(debut, fin, categorie)
-- RETURNS @OutputTable TABLE
-- (
-- 	loc_pav,
-- 	date_debut,
-- 	date_fin,
-- 	cip,
-- 	id_reservation,
-- 	description
-- )
-- AS
-- BEGIN
-- 	SELECT	(l.id_local, l.id_pavillon) AS loc_pav,
-- 			r.date_debut,
-- 			r.date_fin,
-- 			r.cip,
-- 			r.id_reservation,
-- 			r.description
-- 	FROM LOCALFONCTION AS lf
-- 
-- 	JOIN LOCAL AS l
-- 		ON (l.id_local, l.id_pavillon) = (lf.id_local, lf.id_pavillon)
-- 	JOIN RESERVATION AS r
-- 		ON (r.id_local, r.id_pavillon) = (l.id_local, l.id_pavillon)
-- 
-- 	WHERE LOCALFONCTION.id_function = categorie
-- 	AND (r.date_fin > debut OR r.date_debut < fin)
-- 	;
-- RETURN
-- END;

-- Query 1: Quantité de locaux dans la catégorie
	-- SELECT id_local, id_pavillon FROM LOCALFONCTION AS lf WHERE LOCALFONCTION.id_function = categorie; 
	-- Query 2: Quantité de tranches de 15min dans la période demandée
	-- DECLARE @total_timediff = SELECT (DATEPART(hour, timediff) * 4 + DATEPART(minutes, timediff) / 15) FROM (SELECT DATEADD(MINUTE, ROUND(DATEDIFF(MINUTE, 0, fin - debut) / 15.0, 0) * 15, 0)) AS timediff);



CREATE FUNCTION TABLEAU(debut, fin, categorie)
BEGIN
	-- Création d'un tableau contenant toutes les cases possibles
	CREATE TEMP TABLE horaire
	(
		local_id		int NOT NULL,
		pavillon_id		int NOT NULL,
		heure			datetime,
		id_reservation	int,

		PRIMARY_KEY(id_local, id_pavillon, heure),
		FOREIGN_KEY(id_local) REFERENCES LOCAL(id_local),
		FOREIGN_KEY(pavillon_id) REFERENCES LOCAL(id_pavillon),
		FOREIGN_KEY(id_reservation) REFERENCES RESERVATION(id_reservation)
	);

	CREATE TEMP TABLE lookup
	(
		heure		datetime,
		PRIMARY_KEY(heure)
	);

	INSERT INTO lookup VALUE('1970-01-01 00:00:00');
	INSERT INTO lookup VALUE('1970-01-01 00:15:00');
	INSERT INTO lookup VALUE('1970-01-01 00:30:00');
	INSERT INTO lookup VALUE('1970-01-01 00:45:00');
	INSERT INTO lookup VALUE('1970-01-01 01:00:00');
	INSERT INTO lookup VALUE('1970-01-01 01:15:00');
	INSERT INTO lookup VALUE('1970-01-01 01:30:00');
	INSERT INTO lookup VALUE('1970-01-01 01:45:00');
	INSERT INTO lookup VALUE('1970-01-01 02:00:00');
	INSERT INTO lookup VALUE('1970-01-01 02:15:00');
	INSERT INTO lookup VALUE('1970-01-01 02:30:00');
	INSERT INTO lookup VALUE('1970-01-01 02:45:00');
	INSERT INTO lookup VALUE('1970-01-01 03:00:00');
	INSERT INTO lookup VALUE('1970-01-01 03:15:00');
	INSERT INTO lookup VALUE('1970-01-01 03:30:00');
	INSERT INTO lookup VALUE('1970-01-01 03:45:00');
	INSERT INTO lookup VALUE('1970-01-01 04:00:00');
	INSERT INTO lookup VALUE('1970-01-01 04:15:00');
	INSERT INTO lookup VALUE('1970-01-01 04:30:00');
	INSERT INTO lookup VALUE('1970-01-01 04:45:00');
	INSERT INTO lookup VALUE('1970-01-01 05:00:00');
	INSERT INTO lookup VALUE('1970-01-01 05:15:00');
	INSERT INTO lookup VALUE('1970-01-01 05:30:00');
	INSERT INTO lookup VALUE('1970-01-01 05:45:00');
	INSERT INTO lookup VALUE('1970-01-01 06:00:00');
	INSERT INTO lookup VALUE('1970-01-01 06:15:00');
	INSERT INTO lookup VALUE('1970-01-01 06:30:00');
	INSERT INTO lookup VALUE('1970-01-01 06:45:00');
	INSERT INTO lookup VALUE('1970-01-01 07:00:00');
	INSERT INTO lookup VALUE('1970-01-01 07:15:00');
	INSERT INTO lookup VALUE('1970-01-01 07:30:00');
	INSERT INTO lookup VALUE('1970-01-01 07:45:00');
	INSERT INTO lookup VALUE('1970-01-01 08:00:00');
	INSERT INTO lookup VALUE('1970-01-01 08:15:00');
	INSERT INTO lookup VALUE('1970-01-01 08:30:00');
	INSERT INTO lookup VALUE('1970-01-01 08:45:00');
	INSERT INTO lookup VALUE('1970-01-01 09:00:00');
	INSERT INTO lookup VALUE('1970-01-01 09:15:00');
	INSERT INTO lookup VALUE('1970-01-01 09:30:00');
	INSERT INTO lookup VALUE('1970-01-01 09:45:00');
	INSERT INTO lookup VALUE('1970-01-01 10:00:00');
	INSERT INTO lookup VALUE('1970-01-01 10:15:00');
	INSERT INTO lookup VALUE('1970-01-01 10:30:00');
	INSERT INTO lookup VALUE('1970-01-01 10:45:00');
	INSERT INTO lookup VALUE('1970-01-01 11:00:00');
	INSERT INTO lookup VALUE('1970-01-01 11:15:00');
	INSERT INTO lookup VALUE('1970-01-01 11:30:00');
	INSERT INTO lookup VALUE('1970-01-01 11:45:00');
	INSERT INTO lookup VALUE('1970-01-01 12:00:00');
	INSERT INTO lookup VALUE('1970-01-01 12:15:00');
	INSERT INTO lookup VALUE('1970-01-01 12:30:00');
	INSERT INTO lookup VALUE('1970-01-01 12:45:00');
	INSERT INTO lookup VALUE('1970-01-01 13:00:00');
	INSERT INTO lookup VALUE('1970-01-01 13:15:00');
	INSERT INTO lookup VALUE('1970-01-01 13:30:00');
	INSERT INTO lookup VALUE('1970-01-01 13:45:00');
	INSERT INTO lookup VALUE('1970-01-01 14:00:00');
	INSERT INTO lookup VALUE('1970-01-01 14:15:00');
	INSERT INTO lookup VALUE('1970-01-01 14:30:00');
	INSERT INTO lookup VALUE('1970-01-01 14:45:00');
	INSERT INTO lookup VALUE('1970-01-01 15:00:00');
	INSERT INTO lookup VALUE('1970-01-01 15:15:00');
	INSERT INTO lookup VALUE('1970-01-01 15:30:00');
	INSERT INTO lookup VALUE('1970-01-01 15:45:00');
	INSERT INTO lookup VALUE('1970-01-01 16:00:00');
	INSERT INTO lookup VALUE('1970-01-01 16:15:00');
	INSERT INTO lookup VALUE('1970-01-01 16:30:00');
	INSERT INTO lookup VALUE('1970-01-01 16:45:00');
	INSERT INTO lookup VALUE('1970-01-01 17:00:00');
	INSERT INTO lookup VALUE('1970-01-01 17:15:00');
	INSERT INTO lookup VALUE('1970-01-01 17:30:00');
	INSERT INTO lookup VALUE('1970-01-01 17:45:00');
	INSERT INTO lookup VALUE('1970-01-01 18:00:00');
	INSERT INTO lookup VALUE('1970-01-01 18:15:00');
	INSERT INTO lookup VALUE('1970-01-01 18:30:00');
	INSERT INTO lookup VALUE('1970-01-01 18:45:00');
	INSERT INTO lookup VALUE('1970-01-01 19:00:00');
	INSERT INTO lookup VALUE('1970-01-01 19:15:00');
	INSERT INTO lookup VALUE('1970-01-01 19:30:00');
	INSERT INTO lookup VALUE('1970-01-01 19:45:00');
	INSERT INTO lookup VALUE('1970-01-01 20:00:00');
	INSERT INTO lookup VALUE('1970-01-01 20:15:00');
	INSERT INTO lookup VALUE('1970-01-01 20:30:00');
	INSERT INTO lookup VALUE('1970-01-01 20:45:00');
	INSERT INTO lookup VALUE('1970-01-01 21:00:00');
	INSERT INTO lookup VALUE('1970-01-01 21:15:00');
	INSERT INTO lookup VALUE('1970-01-01 21:30:00');
	INSERT INTO lookup VALUE('1970-01-01 21:45:00');
	INSERT INTO lookup VALUE('1970-01-01 22:00:00');
	INSERT INTO lookup VALUE('1970-01-01 22:15:00');
	INSERT INTO lookup VALUE('1970-01-01 22:30:00');
	INSERT INTO lookup VALUE('1970-01-01 22:45:00');
	INSERT INTO lookup VALUE('1970-01-01 23:00:00');
	INSERT INTO lookup VALUE('1970-01-01 23:15:00');
	INSERT INTO lookup VALUE('1970-01-01 23:30:00');
	INSERT INTO lookup VALUE('1970-01-01 23:45:00');


	SELECT * FROM horaire
	JOIN(SELECT id_local, id_pavillon FROM LOCALFONCTION AS lf
			WHERE lf.id_function = categorie)
			ON lf.local_id = horaire.local_id AND lf.pavillon_id = horaire.pavillion_id
	JOIN lookup ON lookup.heure = horaire.heure
	WHERE lookup.heure >= debut AND lookup.heure <= fin;

	UPDATE horaire
		SET id_reservation = r.id_reservation
		FROM reservation as r
		WHERE
			r.local_id = horaire.local_id AND
			r.pavillon_id = horaire.pavillon_id AND
			(r.date_debut < fin AND r.date_fin > debut);


RETURN QUERY SELECT * from horaire;
END;



--	-- Insertion des valeurs dans le tableau
--	DECLARE @dateCase = debut
--	WHILE @dateCase < fin
--		-- Insertion du local
--		INSERT INTO horaire VALUES
--		(
--			
--			@dateCase,
--			NULL
--		);
--		SET @dateCase = DATEADD(MINUTE, 15, @dateCase)
--	END;
--
--	

-- Ajout des réservations là où il y en a
--	UPDATE horaire
--		SET id_reservation = subquery.id_reservation
--		FROM (SELECT * FROM RESERVATION) AS subquery
--		WHERE
--			subquery.local_id = horaire.local_id AND
--			subquery.pavillon_id = horaire.pavillon_id AND
--			();




--------------------------------------------------------------------------------------
loc_pav,	date_debut,		cip,		id_reservation,		description
C1-3007,	9:30,			abcd1234,	42,					GCI756-01 - Magistral


---------------------------------------------------------------------------------------
local,	date_debut,	cip,		id_reservation,	description
C1-3007 8:30,		null,		null,			null
C1-3007 8:45,		null,		null,			null
C1-3007 9:00,		null,		null,			null
C1-3007 9:15,		null,		null,			null
C1-3007 9:30,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 9:45,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 10:00,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 10:15,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 10:30,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 10:45,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 11:00,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 11:15,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 11:30,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 11:45,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 12:00,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 12:15,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 12:30,		abcd1234,	42,				GCI756-01 - Magistral
C1-3007 12:45,		null,		null,			null
C1-3007 13:00,		null,		null,			null