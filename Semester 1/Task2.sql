--1
--SELECT MIN(placa_pod) AS minimum, MAX(placa_pod) AS maximum, MAX(placa_pod)-MIN(placa_pod) AS różnica FROM pracownicy;

--2
--SELECT etat, AVG(placa_pod) FROM pracownicy GROUP BY etat ORDER BY AVG(placa_pod) DESC;

--3
--SELECT COUNT(*) AS profesorowie FROM pracownicy WHERE etat='PROFESOR';

--4
--SELECT id_zesp, SUM(placa_pod)+SUM(placa_dod) AS sumaryczne_place FROM pracownicy GROUP BY id_zesp ORDER BY id_zesp;

--5
--SELECT MAX(SUM(placa_pod)+SUM(placa_dod)) AS maks_sum_placa FROM pracownicy GROUP BY id_zesp;

--6
--SELECT id_szefa, MIN(placa_pod) AS minimalna FROM pracownicy WHERE id_szefa IS NOT NULL GROUP BY id_szefa ORDER BY MIN(placa_pod) DESC;

--7
--SELECT id_zesp, COUNT(*) AS ilu_pracuje FROM pracownicy GROUP BY id_zesp ORDER BY COUNT(*) DESC;

--8
--SELECT id_zesp, COUNT(*) AS ilu_pracuje FROM pracownicy GROUP BY id_zesp HAVING COUNT(*)>3 ORDER BY COUNT(*) DESC;

--9
--SELECT id_prac FROM pracownicy GROUP BY id_prac HAVING COUNT(*)>1;

--10
--SELECT etat, AVG(placa_pod), COUNT(*) FROM pracownicy WHERE zatrudniony < DATE '1990-01-01' GROUP BY etat ORDER BY etat;

--11
--SELECT id_zesp, etat, ROUND(AVG(placa_pod)+AVG(COALESCE(placa_dod, 0)),0) AS srednia, ROUND(MAX(placa_pod+COALESCE(placa_dod, 0)),0) AS maksymalna FROM pracownicy GROUP BY id_zesp, etat HAVING etat='PROFESOR' OR etat='ASYSTENT' ORDER BY id_zesp, etat;

--12
--SELECT TO_CHAR(zatrudniony, 'YYYY') AS rok, COUNT(*) FROM pracownicy GROUP BY TO_CHAR(zatrudniony, 'YYYY') ORDER BY TO_CHAR(zatrudniony, 'YYYY');

--13
--SELECT LENGTH(nazwisko) AS "Ile liter", COUNT(*) AS "W ilu nazwiskach" FROM pracownicy GROUP BY LENGTH(nazwisko) ORDER BY LENGTH(nazwisko);

--14
--SELECT COUNT(*) AS "Ile nazwisk z A" FROM pracownicy WHERE nazwisko LIKE '%A%'OR nazwisko LIKE '%a%';

--15
/*SELECT COUNT(CASE
    WHEN nazwisko LIKE '%A%' OR nazwisko LIKE '%a%' THEN 1
    END)
    AS "Ile nazwisk z A",
    COUNT(CASE
    WHEN nazwisko LIKE '%E%' OR nazwisko LIKE '%e%' THEN 1
    END)
    AS "Ile nazwisk z E" FROM pracownicy;*/
    
--16
--SELECT id_zesp, SUM(placa_pod) AS suma_plac, LISTAGG(nazwisko || ':' || coalesce(TO_CHAR(placa_pod), ''), ';') WITHIN GROUP (ORDER BY nazwisko) AS pracownicy FROM pracownicy GROUP BY id_zesp ORDER BY id_zesp;