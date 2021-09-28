CREATE OR REPLACE FUNCTION TABLEAU(debut timestamp,fin timestamp, categorie int)
RETURNS TABLE
(
     id_local varchar(8),
     id_pavillon varchar(8),
     heure timestamp,
     cip char(8),
     id_reservation int,
     description varchar(64)
)
LANGUAGE plpgsql AS $body$ BEGIN

    -- Creation d'un tableau contenant toutes les cases possibles
    CREATE temp TABLE horaire
    (
        id_local        varchar(8) NOT NULL,
        id_pavillon        varchar(8) NOT NULL,
        heure            timestamp,
        id_reservation    int,

        PRIMARY KEY(id_local, id_pavillon, heure)/*,
        FOREIGN KEY(id_local) REFERENCES locaux(id_local),
        FOREIGN KEY(id_pavillon) REFERENCES locaux(id_pavillon),
        FOREIGN KEY(id_reservation) REFERENCES RESERVATION(id_reservation)*/
    );

/*RETURN QUERY SELECT
    horaire.id_local,
    horaire.id_pavillon,
    horaire.heure,
    horaire.id_reservation.cip,
    horaire.id_reservation.description
FROM horaire;*/

	CREATE TEMP TABLE lookup
	(
		heure		time,
		PRIMARY KEY(heure)
	);

	INSERT INTO lookup VALUES('00:00:00');
	INSERT INTO lookup VALUES('00:15:00');
	INSERT INTO lookup VALUES('00:30:00');
	INSERT INTO lookup VALUES('00:45:00');
	INSERT INTO lookup VALUES('01:00:00');
	INSERT INTO lookup VALUES('01:15:00');
	INSERT INTO lookup VALUES('01:30:00');
	INSERT INTO lookup VALUES('01:45:00');
	INSERT INTO lookup VALUES('02:00:00');
	INSERT INTO lookup VALUES('02:15:00');
	INSERT INTO lookup VALUES('02:30:00');
	INSERT INTO lookup VALUES('02:45:00');
	INSERT INTO lookup VALUES('03:00:00');
	INSERT INTO lookup VALUES('03:15:00');
	INSERT INTO lookup VALUES('03:30:00');
	INSERT INTO lookup VALUES('03:45:00');
	INSERT INTO lookup VALUES('04:00:00');
	INSERT INTO lookup VALUES('04:15:00');
	INSERT INTO lookup VALUES('04:30:00');
	INSERT INTO lookup VALUES('04:45:00');
	INSERT INTO lookup VALUES('05:00:00');
	INSERT INTO lookup VALUES('05:15:00');
	INSERT INTO lookup VALUES('05:30:00');
	INSERT INTO lookup VALUES('05:45:00');
	INSERT INTO lookup VALUES('06:00:00');
	INSERT INTO lookup VALUES('06:15:00');
	INSERT INTO lookup VALUES('06:30:00');
	INSERT INTO lookup VALUES('06:45:00');
	INSERT INTO lookup VALUES('07:00:00');
	INSERT INTO lookup VALUES('07:15:00');
	INSERT INTO lookup VALUES('07:30:00');
	INSERT INTO lookup VALUES('07:45:00');
	INSERT INTO lookup VALUES('08:00:00');
	INSERT INTO lookup VALUES('08:15:00');
	INSERT INTO lookup VALUES('08:30:00');
	INSERT INTO lookup VALUES('08:45:00');
	INSERT INTO lookup VALUES('09:00:00');
	INSERT INTO lookup VALUES('09:15:00');
	INSERT INTO lookup VALUES('09:30:00');
	INSERT INTO lookup VALUES('09:45:00');
	INSERT INTO lookup VALUES('10:00:00');
	INSERT INTO lookup VALUES('10:15:00');
	INSERT INTO lookup VALUES('10:30:00');
	INSERT INTO lookup VALUES('10:45:00');
	INSERT INTO lookup VALUES('11:00:00');
	INSERT INTO lookup VALUES('11:15:00');
	INSERT INTO lookup VALUES('11:30:00');
	INSERT INTO lookup VALUES('11:45:00');
	INSERT INTO lookup VALUES('12:00:00');
	INSERT INTO lookup VALUES('12:15:00');
	INSERT INTO lookup VALUES('12:30:00');
	INSERT INTO lookup VALUES('12:45:00');
	INSERT INTO lookup VALUES('13:00:00');
	INSERT INTO lookup VALUES('13:15:00');
	INSERT INTO lookup VALUES('13:30:00');
	INSERT INTO lookup VALUES('13:45:00');
	INSERT INTO lookup VALUES('14:00:00');
	INSERT INTO lookup VALUES('14:15:00');
	INSERT INTO lookup VALUES('14:30:00');
	INSERT INTO lookup VALUES('14:45:00');
	INSERT INTO lookup VALUES('15:00:00');
	INSERT INTO lookup VALUES('15:15:00');
	INSERT INTO lookup VALUES('15:30:00');
	INSERT INTO lookup VALUES('15:45:00');
	INSERT INTO lookup VALUES('16:00:00');
	INSERT INTO lookup VALUES('16:15:00');
	INSERT INTO lookup VALUES('16:30:00');
	INSERT INTO lookup VALUES('16:45:00');
	INSERT INTO lookup VALUES('17:00:00');
	INSERT INTO lookup VALUES('17:15:00');
	INSERT INTO lookup VALUES('17:30:00');
	INSERT INTO lookup VALUES('17:45:00');
	INSERT INTO lookup VALUES('18:00:00');
	INSERT INTO lookup VALUES('18:15:00');
	INSERT INTO lookup VALUES('18:30:00');
	INSERT INTO lookup VALUES('18:45:00');
	INSERT INTO lookup VALUES('19:00:00');
	INSERT INTO lookup VALUES('19:15:00');
	INSERT INTO lookup VALUES('19:30:00');
	INSERT INTO lookup VALUES('19:45:00');
	INSERT INTO lookup VALUES('20:00:00');
	INSERT INTO lookup VALUES('20:15:00');
	INSERT INTO lookup VALUES('20:30:00');
	INSERT INTO lookup VALUES('20:45:00');
	INSERT INTO lookup VALUES('21:00:00');
	INSERT INTO lookup VALUES('21:15:00');
	INSERT INTO lookup VALUES('21:30:00');
	INSERT INTO lookup VALUES('21:45:00');
	INSERT INTO lookup VALUES('22:00:00');
	INSERT INTO lookup VALUES('22:15:00');
	INSERT INTO lookup VALUES('22:30:00');
	INSERT INTO lookup VALUES('22:45:00');
	INSERT INTO lookup VALUES('23:00:00');
	INSERT INTO lookup VALUES('23:15:00');
	INSERT INTO lookup VALUES('23:30:00');
	INSERT INTO lookup VALUES('23:45:00');

	

	RETURN QUERY SELECT
    lf.id_local,
    lf.id_pavillon,
    lookup.heure + debut::date,
    (
        SELECT reservation.cip FROM reservation
        WHERE  lf.id_local = reservation.id_local AND
               lf.id_pavillon = reservation.id_pavillon
    ),
    (
        SELECT reservation.id_reservation FROM reservation
        WHERE  lf.id_local = reservation.id_local AND
               lf.id_pavillon = reservation.id_pavillon
    ),
    (
        CASE WHEN (SELECT locaux.id_parent_local FROM LOCAUX
                   WHERE horaire.id_local = locaux.id_parent_local) IS NULL
             THEN (SELECT reservation.description FROM reservation
                  WHERE  lf.id_local = reservation.id_local AND
                         lf.id_pavillon = reservation.id_pavillon)
             ELSE 'Reserve'
             END
    )
    FROM horaire
    
    -- Recuperation des locaux
    RIGHT JOIN(
        SELECT localfonction.id_local, localfonction.
        id_pavillon
        FROM LOCALFONCTION
        WHERE localfonction.id_fonction = categorie) AS lf
    ON lf.id_local = horaire.id_local AND
       lf.id_pavillon = horaire.id_pavillon

    -- Locaux parents du local actuel
   /* LEFT JOIN(
        SELECT * FROM LOCAUX) as pl
        ON (SELECT locaux.id_parent_local FROM LOCAUX
            WHERE horaire.id_local = locaux.id_local) = pl.id_local AND
           (SELECT locaux.id_parent_pavillon FROM LOCAUX
            WHERE horaire.id_pavillon = locaux.id_pavillon) = pl.id_pavillon
    -- Locaux enfants du local actuel
    RIGHT JOIN(
        SELECT * FROM LOCAUX) as cl
		ON horaire.id_local = cl.id_parent_local AND
           horaire.id_pavillon = cl.id_parent_pavillon*/

    -- Restriction des heures
    CROSS JOIN lookup
        WHERE lookup.heure >= debut::time AND
            lookup.heure <= fin::time
    ORDER BY lookup.heure, id_local;

	drop table horaire;
	drop table lookup;
END; $body$;


Select * from TABLEAU('2021-09-28 00:00:00','2021-09-28 23:45:00', 0210)