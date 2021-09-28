DELETE FROM RESERVATION WHERE RESERVATION.ID_RESERVATION = 76;
UPDATE reservation SET description = 'Bon matinator' WHERE reservation.id_reservation = 8;
--drop function reservation_procedure_update cascade;
create or replace function reservation_procedure_update()
returns trigger as $$
begin

    if count(res.id_reservation) >= 1
    from (select * from RESERVATION
          where RESERVATION.id_reservation = new.id_reservation AND
                (RESERVATION.date_debut != new.date_debut OR
                 RESERVATION.date_fin != new.date_fin) OR
                (RESERVATION.id_local != new.id_local OR
                 RESERVATION.id_pavillon != new.id_pavillon)) as res
    then
        if count(res.id_reservation) >= 1
        from(select * from RESERVATION
            where RESERVATION.id_local = new.id_local AND
                    RESERVATION.id_pavillon = new.id_pavillon AND
                    (new.date_debut, new.date_fin) overlaps (reservation.date_debut, reservation.date_fin) AND
                    RESERVATION.id_reservation != new.id_reservation) as res
        then
            raise exception 'reservation deja en cours';
        else 
                insert into EVENT_LOG(description, date_event, cip, id_reservation) values('update reservation', now(), new.cip, new.id_reservation);

        return new;
        end if;
    else
        insert into EVENT_LOG(description, date_event, cip, id_reservation) values('Update reservation', now(), new.cip, new.id_reservation);

    end if;
end;
$$
language plpgsql;

create or replace function reservation_procedure_delete()
returns trigger as $$
begin
	raise notice 'Bon matin';
    insert into EVENT_LOG(description, date_event, cip, id_reservation) values('Retrait reservation', now(), new.cip, new.id_reservation);
return new;
end;
$$
language plpgsql;

CREATE TRIGGER reservation_trigger_update
    BEFORE UPDATE
    ON reservation
    FOR EACH ROW EXECUTE PROCEDURE reservation_procedure_update();

CREATE TRIGGER reservation_trigger_delete
    BEFORE DELETE
    ON reservation
    FOR EACH ROW EXECUTE PROCEDURE reservation_procedure_delete();
