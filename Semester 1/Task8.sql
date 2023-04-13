--1
/*CREATE TABLE PROJEKTY(
    id_projektu NUMBER(4) GENERATED ALWAYS AS IDENTITY,
    opis_projektu VARCHAR2(20),
    data_rozpoczecia DATE DEFAULT CURRENT_DATE,
    data_zakonczenia DATE,
    fundusz NUMBER(7,2));*/
    
--2
/*INSERT INTO projekty(opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES ('Indeksy bitmapowe', TO_DATE('02/04/1999', 'DD/MM/YYYY'), TO_DATE('31/08/2001', 'DD/MM/YYYY'), 25000);
INSERT INTO projekty(opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES ('Sieci kręgosłupowe', DEFAULT, NULL, 19000);*/

--3
--SELECT id_projektu, opis_projektu FROM projekty;

--4
--INSERT INTO projekty(id_projektu, opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES (10, 'Indeksy drzewiaste', TO_DATE('24/12/2013', 'DD/MM/YYYY'), TO_DATE('01/01/2014', 'DD/MM/YYYY'), 1200);
--Wykonanie polecenia z podaniem id_projektu zakończyło się niepowodzeniem, bo w deklaracji tabeli użyliśmy "GENERATE ALWAYS AS IDENTITY"

/*INSERT INTO projekty(opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES ('Indeksy drzewiaste', TO_DATE('24/12/2013', 'DD/MM/YYYY'), TO_DATE('01/01/2014', 'DD/MM/YYYY'), 1200);
SELECT id_projektu, opis_projektu FROM projekty;*/

--5
--UPDATE projekty SET id_projektu = 10 WHERE opis_projektu='Indeksy drzewiaste';
--Wykonanie nie powiodło się "A generated always identity column cannot be directly updated."

--6
/*CREATE TABLE PROJEKTY_KOPIA AS SELECT * FROM projekty;
SELECT * FROM projekty_kopia;*/

--7
--INSERT INTO projekty_kopia(id_projektu, opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES (10, 'Sieci lokalne', TO_CHAR(CURRENT_DATE, 'DD/MM/YY'), TO_CHAR(ADD_MONTHS(CURRENT_DATE, 12), 'DD/MM/YY'), 24500);
--Kopiowane są tylko rekordy z relacji projekty, polecenie nie kopiuje ograniczeń integralnościowych

--8
--DELETE projekty WHERE opis_projektu='Indeksy drzewiaste';
--Rekord nie został automatycznie usunięty z relacji PROJEKTY_KOPIA

--9
--SELECT table_name FROM user_tables ORDER BY table_name;