--1
--CREATE VIEW asystenci(nazwisko, placa, staz) AS SELECT nazwisko, placa_pod+placa_dod, zatrudniony FROM pracownicy;
--SELECT nazwisko, placa, staz FROM asystenci ORDER BY nazwisko;

--2
--CREATE OR REPLACE VIEW place(id_zesp, srednia, minimum, maximum, fundusz, l_pensji, l_dodatkow) AS SELECT id_zesp, ROUND(AVG(placa_pod+COALESCE(placa_dod, 0)),2), ROUND(MIN(placa_pod+COALESCE(placa_dod, 0)),2), ROUND(MAX(placa_pod+COALESCE(placa_dod, 0)),2), ROUND(SUM(placa_pod+COALESCE(placa_dod, 0)),2), COUNT(CASE WHEN placa_pod IS NOT NULL THEN 1 END), COUNT(CASE WHEN placa_dod IS NOT NULL THEN 1 END) FROM pracownicy GROUP BY id_zesp ORDER BY id_zesp;
--SELECT id_zesp, srednia, minimum, maximum, fundusz, l_pensji, l_dodatkow FROM place ORDER BY id_zesp;

--3
--SELECT pracownicy.nazwisko, pracownicy.placa_pod, place.srednia FROM pracownicy, place WHERE (pracownicy.placa_pod+COALESCE(pracownicy.placa_dod, 0))<place.srednia AND pracownicy.id_zesp=place.id_zesp ORDER BY pracownicy.nazwisko;

--4
--CREATE OR REPLACE VIEW place_minimalne(id_prac, nazwisko, etat, placa_pod) AS SELECT id_prac, nazwisko, etat, placa_pod FROM pracownicy WHERE placa_pod < 700 ORDER BY nazwisko;
--SELECT id_prac, nazwisko, etat, placa_pod FROM place_minimalne ORDER BY nazwisko;

--5
--UPDATE place_minimalne SET placa_pod = 800 WHERE nazwisko = 'HAPKE';

--6
/*CREATE OR REPLACE VIEW prac_szef(id_prac, id_szefa, pracownik, etat, szef) AS SELECT p.id_prac, p.id_szefa, p.nazwisko, p.etat, (SELECT nazwisko FROM pracownicy p1 WHERE p1.id_prac=p.id_szefa) FROM pracownicy p ORDER BY nazwisko;
INSERT INTO prac_szef (id_prac, id_szefa, pracownik, etat) VALUES (280,150, 'MORZY','ASYSTENT');
UPDATE prac_szef SET id_szefa = 130 WHERE id_prac = 280;
DELETE FROM prac_szef WHERE id_prac = 280;*/

--7
/*CREATE OR REPLACE VIEW zarobki(id_prac, nazwisko, etat, placa_pod) AS SELECT p.id_prac, p.nazwisko, p.etat, p.placa_pod FROM pracownicy p WHERE placa_pod <= (SELECT placa_pod FROM pracownicy p1 WHERE p.id_szefa=p1.id_prac) ORDER BY nazwisko WITH CHECK OPTION CONSTRAINT za_wysoka_placa;
UPDATE zarobki SET placa_pod = 2000 WHERE nazwisko = 'MAREK';*/

--8
--SELECT column_name, updatable, insertable, deletable FROM user_updatable_columns WHERE table_name = 'PRAC_SZEF';