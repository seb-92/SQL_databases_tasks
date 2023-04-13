--1
/*INSERT INTO pracownicy(id_prac, nazwisko)
VALUES ((SELECT max(id_prac) + 10 FROM pracownicy), 'WOLNY'); */

--SELECT pracownicy.nazwisko, pracownicy.id_zesp, zespoly.nazwa FROM pracownicy LEFT OUTER JOIN zespoly ON pracownicy.id_zesp=zespoly.id_zesp ORDER BY nazwisko;

--2
/*SELECT nazwa, zespoly.id_zesp, CASE
WHEN nazwisko IS NULL THEN 'brak pracowników'
ELSE nazwisko
END FROM zespoly LEFT OUTER JOIN pracownicy ON pracownicy.id_zesp=zespoly.id_zesp ORDER BY nazwa, nazwisko;*/

--3
/*SELECT
CASE
    WHEN nazwa IS NULL THEN 'brak zespołu'
    ELSE nazwa
END,
CASE
    WHEN nazwisko IS NULL THEN 'brak pracowników'
    ELSE nazwisko
END
FROM zespoly FULL OUTER JOIN pracownicy ON pracownicy.id_zesp=zespoly.id_zesp ORDER BY nazwa, nazwisko;*/

--4
/*DELETE FROM pracownicy
WHERE nazwisko = 'WOLNY'; */

--SELECT zespoly.nazwa, COUNT(CASE WHEN pracownicy.placa_pod IS NOT NULL THEN 1 END) AS LICZBA, SUM(pracownicy.placa_pod) AS SUMA_PLAC FROM zespoly FULL OUTER JOIN pracownicy ON pracownicy.id_zesp=zespoly.id_zesp GROUP BY zespoly.nazwa ORDER BY nazwa;


--5
--SELECT zespoly.nazwa FROM zespoly LEFT OUTER JOIN pracownicy ON pracownicy.id_zesp=zespoly.id_zesp GROUP BY zespoly.nazwa HAVING COUNT(pracownicy.id_prac)=0

--6
--SELECT p.nazwisko AS pracownik, p.id_prac, s.nazwisko AS szef, p.id_szefa FROM pracownicy p LEFT OUTER JOIN pracownicy s ON p.id_szefa=s.id_prac ORDER BY p.nazwisko;

--7
--SELECT p.nazwisko AS PRACOWNIK, COUNT(s.id_prac) AS LICZBA_PRACOWNIKOW FROM pracownicy p LEFT OUTER JOIN pracownicy s ON p.id_prac=s.id_szefa GROUP BY p.nazwisko ORDER BY p.nazwisko;

--8
--SELECT p.nazwisko, p.etat, p.placa_pod, z.nazwa, s.nazwisko FROM pracownicy p INNER JOIN zespoly z ON p.id_zesp=z.id_zesp LEFT OUTER JOIN pracownicy s ON p.id_szefa=s.id_prac ORDER BY p.nazwisko;

--9
--SELECT nazwisko, nazwa FROM pracownicy, zespoly ORDER BY nazwisko, nazwa

--10
--SELECT COUNT(*) FROM pracownicy, zespoly, etaty

--11
--SELECT etat FROM pracownicy WHERE EXTRACT(YEAR FROM zatrudniony)=1992 INTERSECT SELECT etat FROM pracownicy WHERE EXTRACT(YEAR FROM zatrudniony)=1993 GROUP BY etat

--12
/*SELECT z.id_zesp FROM zespoly z LEFT JOIN pracownicy p ON z.id_zesp=p.id_zesp
MINUS
SELECT z.id_zesp FROM zespoly z INNER JOIN pracownicy p ON z.id_zesp=p.id_zesp;*/

--13
/*SELECT z.id_zesp, z.nazwa FROM zespoly z LEFT JOIN pracownicy p ON z.id_zesp=p.id_zesp
MINUS
SELECT z.id_zesp, z.nazwa FROM zespoly z INNER JOIN pracownicy p ON z.id_zesp=p.id_zesp;*/

--14
/*SELECT nazwisko, placa_pod, 'Poniżej 480 złotych' FROM pracownicy WHERE placa_pod<480
UNION
SELECT nazwisko, placa_pod, 'Dokładnie 480 złotych' FROM pracownicy WHERE placa_pod=480
UNION
SELECT nazwisko, placa_pod, 'Powyżej 480 złotych' FROM pracownicy WHERE placa_pod>480
ORDER BY placa_pod*/