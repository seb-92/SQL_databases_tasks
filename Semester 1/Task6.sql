--1
--SELECT nazwisko, placa_pod FROM pracownicy ORDER BY placa_pod DESC FETCH FIRST 3 ROWS ONLY;
--SELECT nazwisko, kwota FROM (SELECT nazwisko, placa_pod AS kwota FROM pracownicy ORDER BY kwota DESC) WHERE ROWNUM <= 3;

--2
--SELECT nazwisko, placa_pod FROM pracownicy ORDER BY placa_pod DESC, nazwisko DESC OFFSET 5 ROWS FETCH FIRST 5 ROWS ONLY;
--SELECT nazwisko, placa_pod FROM (SELECT * FROM pracownicy ORDER BY placa_pod DESC) WHERE ROWNUM <= 10 OFFSET 5 ROWS;

--3
/*WITH srednia AS (SELECT AVG(placa_pod) AS srednia_zesp, id_zesp AS id FROM pracownicy GROUP BY id_zesp)
SELECT p.nazwisko, p.placa_pod, p.placa_pod - s.srednia_zesp AS roznica FROM pracownicy p, srednia s  WHERE s.id = p.id_zesp AND p.placa_pod - s.srednia_zesp > 0 ORDER BY nazwisko;*/

--4
/*WITH year_number AS (SELECT EXTRACT(YEAR FROM zatrudniony) AS rok FROM pracownicy GROUP BY EXTRACT(YEAR FROM zatrudniony))
SELECT rok, COUNT(*) AS liczba FROM year_number, pracownicy WHERE rok=EXTRACT(YEAR FROM zatrudniony) GROUP BY rok ORDER BY liczba DESC;*/

--5
/*WITH year_number AS (SELECT EXTRACT(YEAR FROM zatrudniony) AS rok FROM pracownicy GROUP BY EXTRACT(YEAR FROM zatrudniony))
SELECT rok, COUNT(*) AS liczba FROM year_number, pracownicy WHERE rok=EXTRACT(YEAR FROM zatrudniony) GROUP BY rok ORDER BY liczba DESC FETCH FIRST ROW ONLY;*/

--6
/*WITH asystent AS (SELECT * FROM pracownicy WHERE etat='ASYSTENT'),
       adres_asystent AS (SELECT * FROM zespoly WHERE adres='PIOTROWO 3A')
SELECT asystent.nazwisko, asystent.etat, adres_asystent.nazwa, adres_asystent.adres FROM asystent, adres_asystent WHERE asystent.id_zesp = adres_asystent.id_zesp;*/

--7
WITH srednia_placa AS (SELECT id_zesp AS id, SUM(placa_pod) AS suma FROM pracownicy GROUP BY id_zesp),
     max_placa AS (SELECT MAX(suma) AS max_wartosc FROM srednia_placa),
     zespol AS (SELECT id_zesp, nazwa FROM zespoly)
SELECT nazwa, max_wartosc FROM zespol, max_placa, srednia_placa WHERE suma=max_wartosc AND srednia_placa.id=zespol.id_zesp;

--8
/*WITH podwladni (id_prac, id_szefa, nazwisko, pozycja_w_hierarchii) AS (SELECT id_prac, id_szefa, nazwisko, 1 FROM pracownicy WHERE nazwisko = 'BRZEZINSKI' UNION ALL
SELECT p.id_prac, p.id_szefa, p.nazwisko, pozycja_w_hierarchii+1 FROM podwladni s JOIN pracownicy p ON s.id_prac = p.id_szefa)
SEARCH DEPTH FIRST BY nazwisko SET porzadek_potomkow
SELECT nazwisko, pozycja_w_hierarchii FROM podwladni zad ORDER BY porzadek_potomkow;*/

/*SELECT nazwisko, LEVEL AS pozycja_w_hierarchii
FROM pracownicy
CONNECT BY id_szefa = PRIOR id_prac
START WITH nazwisko = 'BRZEZINSKI'
ORDER SIBLINGS BY nazwisko;*/

--9
/*SELECT concat(rpad(' ', LEVEL - 1, ' '), nazwisko) as "NAZWISKO ", LEVEL AS pozycja_w_hierarchii
FROM pracownicy
CONNECT BY id_szefa = PRIOR id_prac
START WITH nazwisko = 'BRZEZINSKI'
ORDER SIBLINGS BY nazwisko;*/