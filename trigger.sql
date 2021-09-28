-- DELETE FROM RESERVATION WHERE RESERVATION.ID_RESERVATION = 76;
-- UPDATE reservation SET description = 'Bon matinator' WHERE reservation.id_reservation = 8;
-- DROP FUNCTION reservation_procedure_update CASCADE;
CREATE OR REPLACE FUNCTION reservation_procedure_update()
RETURNS TRIGGER AS $$
BEGIN
    IF count(res.id_reservation) >= 1
    FROM (SELECT * FROM RESERVATION
          WHERE RESERVATION.id_reservation = new.id_reservation AND
               (RESERVATION.date_debut  != new.date_debut OR
                RESERVATION.date_fin    != new.date_fin) OR
               (RESERVATION.id_local    != new.id_local OR
                RESERVATION.id_pavillon != new.id_pavillon)) AS res
    THEN
        IF count(res.id_reservation) >= 1
        FROM(SELECT * FROM RESERVATION
             WHERE RESERVATION.id_local    = new.id_local AND
                   RESERVATION.id_pavillon = new.id_pavillon AND
                  (new.date_debut, new.date_fin) overlaps (reservation.date_debut, reservation.date_fin) AND
                   RESERVATION.id_reservation != new.id_reservation) AS res
        THEN
            RAISE EXCEPTION 'reservation deja en cours';
        ELSE
            INSERT INTO event_log(description, date_event, cip, id_reservation)
                        VALUES('update reservation', now(), new.cip, new.id_reservation);

        RETURN new;
        END IF;
    ELSE
        INSERT INTO event_log(description, date_event, cip, id_reservation)
                    VALUES('Update reservation', now(), new.cip, new.id_reservation);

    END IF;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reservation_procedure_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO event_log(description, date_event, cip, id_reservation)
                VALUES('Retrait reservation', now(), new.cip, new.id_reservation);
RETURN new;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER reservation_trigger_update
    BEFORE UPDATE
    ON reservation
    FOR EACH ROW EXECUTE PROCEDURE reservation_procedure_update();

CREATE TRIGGER reservation_trigger_delete
    BEFORE DELETE
    ON reservation
    FOR EACH ROW EXECUTE PROCEDURE reservation_procedure_delete();
