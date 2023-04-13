--1
--SELECT id_zesp, nazwa, adres FROM zespoly WHERE NOT EXISTS (SELECT * FROM pracownicy WHERE zespoly.id_zesp = pracownicy.id_zesp);

--2
--SELECT nazwisko, placa_pod, etat FROM pracownicy p WHERE placa_pod > (SELECT AVG(placa_pod) FROM pracownicy WHERE etat = p.etat) ORDER BY placa_pod DESC;

--3
--SELECT nazwisko, placa_pod FROM pracownicy p WHERE placa_pod >= (SELECT placa_pod FROM pracownicy WHERE p.id_szefa = id_prac)*0.75 ORDER BY nazwisko;

--4
--SELECT p.nazwisko FROM pracownicy p WHERE p.etat='PROFESOR' AND NOT EXISTS (SELECT * FROM pracownicy WHERE (id_szefa = p.id_prac AND etat = 'STAZYSTA')) ORDER BY nazwisko;

--5
--SELECT nazwa, suma FROM(SELECT id_zesp, SUM(placa_pod) AS suma FROM pracownicy GROUP BY id_zesp) p JOIN zespoly z ON z.id_zesp = p.id_zesp FETCH FIRST ROW ONLY;

--6
--SELECT nazwisko, placa_pod FROM pracownicy ORDER BY placa_pod DESC FETCH FIRST 3 ROWS ONLY;

--7
--SELECT TO_CHAR(zatrudniony, 'YYYY') AS "ROK", COUNT(*) AS "LICZBA" FROM pracownicy GROUP BY TO_CHAR(zatrudniony, 'YYYY') ORDER BY COUNT(*) DESC;

--8
--SELECT TO_CHAR(zatrudniony, 'YYYY') AS "ROK", COUNT(*) AS "LICZBA" FROM pracownicy GROUP BY TO_CHAR(zatrudniony, 'YYYY') ORDER BY COUNT(*) DESC FETCH FIRST ROW ONLY;

--9
--SELECT p.nazwisko, p.placa_pod, p.placa_pod-(SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp=p.id_zesp) AS "ROZNICA" FROM pracownicy p ORDER BY nazwisko;

--SELECT nazwisko, placa_pod, placa_pod-srednia_w_zespole AS "ROZNICA" FROM (SELECT id_zesp, AVG(placa_pod) AS srednia_w_zespole
--FROM pracownicy GROUP BY id_zesp) z JOIN pracownicy p ON z.id_zesp = p.id_zesp ORDER BY nazwisko;

--10
--SELECT p.nazwisko, p.placa_pod, p.placa_pod-(SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp=p.id_zesp) AS "ROZNICA" FROM pracownicy p WHERE p.placa_pod-(SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp=p.id_zesp)>0 ORDER BY nazwisko;

--SELECT nazwisko, placa_pod, placa_pod-srednia_w_zespole AS "ROZNICA" FROM (SELECT id_zesp, AVG(placa_pod) AS srednia_w_zespole FROM pracownicy GROUP BY id_zesp) z JOIN pracownicy p ON z.id_zesp = p.id_zesp WHERE placa_pod > srednia_w_zespole ORDER BY nazwisko;

--11
--SELECT nazwisko, (SELECT COUNT(*) FROM pracownicy WHERE p.id_prac = id_szefa) AS "PODWLADNI" FROM pracownicy p WHERE etat='PROFESOR' AND (id_zesp = 10 OR id_zesp = 20) ORDER BY (SELECT COUNT(*) FROM pracownicy WHERE p.id_prac = id_szefa) DESC;

--12
/*SELECT nazwa, (SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp = z.id_zesp) AS srednia_w_zespole, ROUND((SELECT AVG(placa_pod) FROM pracownicy), 2) AS srednia_ogolna,
CASE
WHEN (SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp = z.id_zesp) > ROUND((SELECT AVG(placa_pod) FROM pracownicy), 2) THEN ':)'
WHEN (SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp = z.id_zesp) < ROUND((SELECT AVG(placa_pod) FROM pracownicy), 2) THEN ':('
WHEN (SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp = z.id_zesp) IS NULL THEN '???'
END
FROM zespoly z ORDER BY nazwa;*/

--13
--SELECT nazwa, placa_min, placa_max FROM etaty ORDER BY (SELECT COUNT(*) FROM pracownicy WHERE etat = nazwa) DESC, nazwa;