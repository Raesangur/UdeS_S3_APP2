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
    ),

    FROM horaire

    -- Recuperation des locaux
    RIGHT JOIN(
        SELECT localfonction.id_local, localfonction.
        id_pavillon
        FROM LOCALFONCTION
        WHERE localfonction.id_fonction = categorie) AS lf
    ON lf.id_local = horaire.id_local AND
       lf.id_pavillon = horaire.pavillon_id

    /*-- Locaux parents du local actuel
    RIGHT JOIN(SELECT * FROM LOCAUX) as pl
        ON (SELECT locaux.id_parent_local FROM LOCAUX
            WHERE horaire.id_local = locaux.id_local) = pl.id_local AND
           (SELECT locaux.id_parent_pavillon FROM LOCAUX
            WHERE horaire.id_pavillon = locaux.id_pavillon) = pl.id_pavillon

    -- Locaux enfants du local actuel
    RIGHT JOIN(SELECT * FROM LOCAUX) as cl
        ON horaire.id_local = cl.id_parent_local AND
           horaire.id_pavillon = cl.id_parent_pavillon */

    -- Restriction des heures
    CROSS JOIN lookup
        WHERE lookup.heure >= debut::time AND
            lookup.heure <= fin::time
    ORDER BY lookup.heure, id_local;