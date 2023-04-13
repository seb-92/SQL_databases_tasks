--1
/*INSERT INTO pracownicy VALUES (250, 'KOWALSKI', 'ASYSTENT', NULL, '15/01/13', 1500, NULL, 10);
INSERT INTO pracownicy VALUES (260, 'ADAMSKI', 'ASYSTENT', NULL, '14/09/10', 1500, NULL, 10);
INSERT INTO pracownicy VALUES (270, 'NOWAK', 'ADIUNKT', NULL, '99/05/01', 2050, 540, 20);

SELECT * FROM pracownicy WHERE id_prac=250 OR id_prac=260 OR id_prac=270;*/

--2
/*UPDATE pracownicy
SET placa_pod = placa_pod * 1.1,
    placa_dod= COALESCE(placa_dod*1.2, 100)
WHERE id_prac=250 OR id_prac=260 OR id_prac=270;

SELECT * FROM pracownicy WHERE id_prac=250 OR id_prac=260 OR id_prac=270;*/

--3
/*INSERT INTO zespoly VALUES (60, 'BAZY DANYCH', 'PIOTROWO 2');

SELECT * FROM zespoly WHERE id_zesp=60;*/

--4
/*UPDATE pracownicy
SET (id_zesp) = (SELECT id_zesp FROM zespoly WHERE nazwa = 'BAZY DANYCH')
WHERE id_prac=250 OR id_prac=260 OR id_prac=270;

SELECT * FROM pracownicy WHERE id_zesp=60;*/

--5
/*UPDATE pracownicy
SET (id_szefa) = (SELECT id_prac FROM pracownicy WHERE nazwisko = 'MORZY')
WHERE id_prac=250 OR id_prac=260 OR id_prac=270;

SELECT * FROM pracownicy WHERE id_szefa=140;*/

--6
--DELETE FROM zespoly WHERE nazwa='BAZY DANYCH';
--Nie usunelo sie bo ma powiazania (pracownicy przypisani do zespolu)

--7
/*DELETE FROM pracownicy WHERE id_zesp=60;
DELETE FROM zespoly WHERE nazwa='BAZY DANYCH';*/

--8
--SELECT nazwisko, placa_pod, (SELECT AVG(placa_pod)*0.1 FROM pracownicy p WHERE p1.id_zesp=p.id_zesp) AS podwyzka FROM pracownicy p1 ORDER BY nazwisko;

--9
/*UPDATE pracownicy p
SET placa_pod = placa_pod + (SELECT AVG(placa_pod)*0.1 FROM pracownicy WHERE id_zesp=p.id_zesp);

SELECT nazwisko, placa_pod FROM pracownicy ORDER BY nazwisko;*/

--10
--SELECT * FROM pracownicy WHERE placa_pod = (SELECT MIN(placa_pod) FROM pracownicy);

--11
/*UPDATE pracownicy
SET placa_pod = ROUND((SELECT AVG(placa_pod) FROM pracownicy), 2)
WHERE placa_pod = (SELECT MIN(placa_pod) FROM pracownicy);

SELECT * FROM pracownicy WHERE id_prac = 200;*/

--12
/*SELECT nazwisko, placa_dod FROM pracownicy WHERE id_zesp=20 ORDER BY nazwisko;

UPDATE pracownicy
SET placa_dod = (SELECT AVG(placa_pod) FROM pracownicy WHERE id_szefa=(SELECT id_prac FROM pracownicy WHERE nazwisko='MORZY'))
WHERE id_zesp=20;

SELECT nazwisko, placa_dod FROM pracownicy WHERE id_zesp=20 ORDER BY nazwisko;*/

--13
/*SELECT nazwisko, placa_pod FROM pracownicy WHERE id_zesp = (SELECT id_zesp FROM zespoly WHERE nazwa='SYSTEMY ROZPROSZONE') ORDER BY nazwisko;

UPDATE (SELECT placa_pod FROM pracownicy JOIN zespoly USING (id_zesp) WHERE nazwa='SYSTEMY ROZPROSZONE')
SET placa_pod = placa_pod + placa_pod*0.25;*/

--14
/*SELECT nazwisko, 'MORZY' AS SZEF FROM pracownicy WHERE id_szefa=(SELECT id_prac FROM pracownicy WHERE nazwisko='MORZY');

DELETE FROM (SELECT * FROM pracownicy WHERE id_szefa=(SELECT id_prac FROM pracownicy WHERE nazwisko='MORZY'));*/

--15
--SELECT * FROM pracownicy ORDER BY nazwisko;

--16
--CREATE SEQUENCE PRAC_SEQ START WITH 300 INCREMENT BY 10;

--17
/*INSERT INTO pracownicy (id_prac, nazwisko, etat, placa_pod) VALUES (PRAC_SEQ.NEXTVAL, 'TRABCZYNSKI', 'STAZYSTA', 1000);

SELECT * FROM pracownicy WHERE nazwisko='TRABCZYNSKI';*/

--18
/*UPDATE pracownicy
SET placa_dod = PRAC_SEQ.CURRVAL
WHERE nazwisko='TRABCZYNSKI';

SELECT * FROM pracownicy WHERE nazwisko='TRABCZYNSKI';*/

--19
--DELETE FROM pracownicy WHERE  nazwisko='TRABCZYNSKI';

--20
/*CREATE SEQUENCE MALA_SEQ START WITH 8 INCREMENT BY 1 MAXVALUE 10;

SELECT MALA_SEQ.NEXTVAL FROM dual;*/

--21
--DROP SEQUENCE MALA_SEQ;