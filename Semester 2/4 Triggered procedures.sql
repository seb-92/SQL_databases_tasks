--zad1
CREATE TABLE DziennikOperacji
( operation_data VARCHAR2(30),
  operation_type VARCHAR2(6),
  table_name VARCHAR2(7),
  records_number INTEGER
);
/
create or replace TRIGGER LogujOperacje
 AFTER INSERT OR DELETE OR UPDATE ON Zespoly
BEGIN
 CASE
     WHEN INSERTING THEN
        INSERT INTO DziennikOperacji (operation_data, operation_type, table_name, records_number) VALUES (CURRENT_DATE, 'INSERT', 'ZESPOLY' , (SELECT COUNT(*) FROM Zespoly));
     WHEN DELETING THEN
        INSERT INTO DziennikOperacji (operation_data, operation_type, table_name, records_number) VALUES (CURRENT_DATE, 'DELETE', 'ZESPOLY' , (SELECT COUNT(*) FROM Zespoly));
     WHEN UPDATING THEN
        INSERT INTO DziennikOperacji (operation_data, operation_type, table_name, records_number) VALUES (CURRENT_DATE, 'UPDATE', 'ZESPOLY' , (SELECT COUNT(*) FROM Zespoly));
 END CASE;
END;

--zad2
CREATE OR REPLACE TRIGGER PokazPlace
 BEFORE UPDATE OF placa_pod ON Pracownicy
 FOR EACH ROW
 WHEN (OLD.placa_pod <> NEW.placa_pod OR OLD.placa_pod IS NULL OR NEW.placa_pod IS NULL)
BEGIN
 IF (:OLD.placa_pod IS NOT NULL OR :NEW.placa_pod IS NOT NULL) THEN
     DBMS_OUTPUT.PUT_LINE('Pracownik ' || :OLD.nazwisko);
     IF :OLD.placa_pod IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: NULL');
     ELSE
        DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: ' || :OLD.placa_pod);
     END IF;
     IF :NEW.placa_pod IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: NULL');
     ELSE
        DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: ' || :NEW.placa_pod);
     END IF;
  END IF;
END;

--zad3
CREATE OR REPLACE TRIGGER UzupelnijPlace
 BEFORE INSERT ON Pracownicy
 FOR EACH ROW
 WHEN (NEW.placa_pod IS NULL OR NEW.placa_dod IS NULL)
DECLARE
 vPlacaMin Pracownicy.placa_pod%TYPE;
BEGIN
 IF (:NEW.etat IS NOT NULL) THEN
    IF (:NEW.placa_pod IS NULL) THEN
        SELECT min(placa_pod) INTO vPlacaMin FROM Pracownicy WHERE etat = :NEW.etat;
        :NEW.placa_pod := vPlacaMin;
    END IF;
 END IF;
 
 IF (:NEW.placa_dod IS NULL) THEN
    :NEW.placa_dod := 0;
 END IF;
END;

--zad4
BEGIN
DECLARE
new_id Zespoly.id_zesp%TYPE;
vNumberSeq INTEGER;
    BEGIN
    SELECT MAX(id_zesp)+1 INTO new_id FROM Zespoly;
    SELECT COUNT(*) INTO vNumberSeq FROM user_sequences WHERE sequence_name = 'SEQ_ZESPOLY';
    IF vNumberSeq = 1 THEN
        EXECUTE IMMEDIATE('DROP SEQUENCE SEQ_Zespoly');
    END IF;
    EXECUTE IMMEDIATE('CREATE SEQUENCE SEQ_Zespoly MINVALUE 0 INCREMENT BY 1 START WITH ' ||new_id||' CACHE 20');
    EXECUTE IMMEDIATE('CREATE OR REPLACE TRIGGER UzupelnijID BEFORE INSERT ON Zespoly FOR EACH ROW WHEN (NEW.id_zesp IS NULL) BEGIN :NEW.id_zesp := SEQ_Zespoly.Nextval; END;');
    END;
END;

--zad5
CREATE OR REPLACE VIEW Szefowie
 (SZEF, PRACOWNICY)
 AS
 SELECT p1.nazwisko, COUNT(p2.id_prac)
 FROM Pracownicy p1 INNER JOIN Pracownicy p2 ON p1.id_prac = p2.id_szefa
 GROUP BY p1.nazwisko ORDER BY nazwisko;
/
CREATE OR REPLACE TRIGGER SzefowieProc
 INSTEAD OF DELETE ON Szefowie
DECLARE
 exError EXCEPTION;
 PRAGMA EXCEPTION_INIT(exError, -20001);
 vNumber INTEGER := 0;
BEGIN
 SELECT SUM(Pracownicy) INTO vNumber FROM Szefowie WHERE Szef in (SELECT nazwisko FROM Pracownicy WHERE id_szefa = (SElECT id_prac FROM Pracownicy WHERE nazwisko = :OLD.Szef));
 IF vNumber IS NULL THEN
    DELETE FROM Pracownicy WHERE nazwisko IN (SELECT nazwisko FROM Pracownicy WHERE id_szefa = (SElECT id_prac FROM Pracownicy WHERE nazwisko = :OLD.SZEF));
    DELETE FROM Pracownicy WHERE nazwisko = :OLD.SZEF;
 ELSE
    RAISE exError;
 END IF;
 
 EXCEPTION WHEN exError THEN DBMS_OUTPUT.PUT_LINE('Jeden z podwładnych usuwanego pracownika jest szefem innych pracowników. Usuwanie anulowane!');
END;

--zad6
CREATE OR REPLACE TRIGGER WyzwalaczLiczbaPrac
 AFTER INSERT OR DELETE OR UPDATE ON Pracownicy
 FOR EACH ROW
DECLARE
 vNewValueAdd INTEGER;
 vNewValueRemove INTEGER;
BEGIN
 CASE
    WHEN INSERTING THEN
      SELECT liczba_pracownikow+1 INTO vNewValueAdd FROM Zespoly WHERE id_zesp = :NEW.id_zesp;
      UPDATE Zespoly SET liczba_pracownikow = vNewValueAdd WHERE id_zesp = :NEW.id_zesp;
    WHEN DELETING THEN
      SELECT liczba_pracownikow-1 INTO vNewValueRemove FROM Zespoly WHERE id_zesp = :OLD.id_zesp;
      UPDATE Zespoly SET liczba_pracownikow = vNewValueRemove WHERE id_zesp = :OLD.id_zesp;
    WHEN UPDATING THEN
      SELECT liczba_pracownikow-1 INTO vNewValueRemove FROM Zespoly WHERE id_zesp = :OLD.id_zesp;
      SELECT liczba_pracownikow+1 INTO vNewValueAdd FROM Zespoly WHERE id_zesp = :NEW.id_zesp;
      UPDATE Zespoly SET liczba_pracownikow = vNewValueRemove WHERE id_zesp = :OLD.id_zesp;
      UPDATE Zespoly SET liczba_pracownikow = vNewValueAdd WHERE id_zesp = :NEW.id_zesp;
 END CASE;  
END;

--zad7
CREATE OR REPLACE TRIGGER Usun_Prac
 BEFORE(AFTER) DELETE ON Pracownicy
 FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE(:OLD.nazwisko);
END;

Wykonując powyższy wyzwalacz z argumentem AFTER, usuwanie pracowników następuję od końca. Najpierw usuwany jest Matysiak i Zakrzewski, a następnie ich szef czyli Morzy.
W drugim przypadku i użyciu argumentu BEFORE, najpierw usuwany jest pracownik Morzy, a dopiero po nim jego podwładni: Matysiak i Zakrzewski.

--zad8
SELECT trigger_name, status FROM User_Triggers WHERE table_name IN ('PRACOWNICY') ORDER BY table_name, trigger_name;
/
ALTER TABLE Pracownicy DISABLE ALL TRIGGERS;
/
SELECT trigger_name, status FROM User_Triggers WHERE table_name IN ('PRACOWNICY') ORDER BY table_name, trigger_name;
/
UPDATE Pracownicy SET placa_pod = 150 WHERE id_prac = 180; --Zablokowany wyzwalacz nie uruchamia się, w tabeli pojawia się wartość NULL, zamiast minimalnej wartości placy_pod dla danego etatu.

--zad9
BEGIN
    FOR i in (SELECT trigger_name FROM User_Triggers WHERE table_name IN ('PRACOWNICY', 'ZESPOLY')) LOOP
        EXECUTE IMMEDIATE ('DROP TRIGGER '||i.trigger_name);
    END LOOP;
END;