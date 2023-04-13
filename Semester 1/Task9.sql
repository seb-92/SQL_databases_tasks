--1
/*ALTER TABLE projekty
    MODIFY (
        id_projektu CONSTRAINT pk_projekty PRIMARY KEY,
        opis_projektu CONSTRAINT uk_projekty UNIQUE NOT NULL,
        fundusz CONSTRAINT not_zero CHECK ( fundusz > 0 )
    );

ALTER TABLE projekty ADD CONSTRAINT data_check CHECK ( data_zakonczenia > data_rozpoczecia );*/

/*SELECT user_constraints.constraint_name, constraint_type AS C_TYPE, search_condition, column_name
FROM user_constraints, user_cons_columns
WHERE user_cons_columns.constraint_name = user_constraints.constraint_name AND user_constraints.table_name = 'PROJEKTY'
ORDER BY user_constraints.constraint_name;*/

--2
--INSERT INTO projekty(opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES ('Indeksy bitmapowe', TO_DATE('12/04/2015', 'DD/MM/YYYY'), TO_DATE('30/07/2016', 'DD/MM/YYYY'), 40000);
--Wykonanie polecenia zakończyło się niepowodzeniam, ponieważ wartość musi być unikatowa (zasada nadana w zad1), a my próbujemy ją zduplikować

-- 3
/*CREATE TABLE przedzialy(
    id_projektu NUMBER(4) CONSTRAINT FK_PRZYDZIALY_01 REFERENCES projekty(id_projektu) NOT NULL,
    nr_pracownika NUMBER(6) CONSTRAINT FK_PRZYDZIALY_02 REFERENCES pracownicy(id_prac) NOT NULL,
    od DATE DEFAULT CURRENT_DATE,
    do DATE,
    CONSTRAINT CHK_PRZYDZIALY_DATY CHECK (do>od),
    stawka NUMBER(7,2) CONSTRAINT CHK_PRZYDZIALY_STAWKA CHECK (stawka>0),
    CONSTRAINT PK_PRZYDZIALY PRIMARY KEY (id_projektu, nr_pracownika),
    rola VARCHAR2(20) CONSTRAINT CHK_PRZYDZIALY_ROLA CHECK (rola IN ('KIERUJACY', 'ANALITYK', 'PROGRAMISTA')));*/
    
--4
/*INSERT INTO przedzialy(id_projektu, nr_pracownika, od, do, stawka, rola) VALUES ((SELECT id_projektu FROM projekty WHERE opis_projektu='Indeksy bitmapowe'), 170, TO_DATE('10/04/1999', 'DD/MM/YYYY'), TO_DATE('10/05/1999', 'DD/MM/YYYY'), 1000, 'KIERUJACY');
INSERT INTO przedzialy(id_projektu, nr_pracownika, od, stawka, rola) VALUES ((SELECT id_projektu FROM projekty WHERE opis_projektu='Indeksy bitmapowe'), 140, TO_DATE('01/12/2000', 'DD/MM/YYYY'), 1500, 'ANALITYK');
INSERT INTO przedzialy(id_projektu, nr_pracownika, od, stawka, rola) VALUES ((SELECT id_projektu FROM projekty WHERE opis_projektu= 'Sieci kręgosłupowe'), 140, TO_DATE('14/09/2015', 'DD/MM/YYYY'), 2500, 'KIERUJACY');*/

--SELECT * FROM przedzialy;

--5
--ALTER TABLE przedzialy ADD godziny NUMBER(5) CONSTRAINT max_check(godziny < 9999) NOT NULL;
--Nie udało się, nie można dodawać specyfikacji

--6
/*ALTER TABLE przedzialy ADD godziny NUMBER(5);
UPDATE przedzialy SET godziny=5 WHERE nr_pracownika=140 OR nr_pracownika=170;
ALTER TABLE przedzialy MODIFY godziny NUMBER(5) CONSTRAINT maksymalna CHECK (godziny<9999) NOT NULL;*/

--7
--ALTER TABLE projekty DISABLE CONSTRAINT uk_projekty;

--SELECT constraint_name, status FROM user_constraints WHERE constraint_name='UK_PROJEKTY';

--8
--INSERT INTO projekty(opis_projektu, data_rozpoczecia, data_zakonczenia, fundusz) VALUES ('Indeksy bitmapowe', TO_DATE('12/04/2015', 'DD/MM/YYYY'), To_DATE('30/09/2016', 'DD/MM/YYYY'), 40000);

--SELECT * FROM projekty;

--9
--ALTER TABLE projekty ENABLE CONSTRAINT uk_projekty;
--Polecenie nie powiodło się, ponieważ w tabeli znajduą się zduplikowane elementy

--10
--UPDATE projekty SET opis_projektu='Inne bitmapowe' WHERE id_projektu=5;

--ALTER TABLE projekty ENABLE CONSTRAINT uk_projekty;
--Udało się włączyć ograniczenie

--11
--ALTER TABLE projekty MODIFY opis_projektu VARCHAR2(10);
--Nie możemy zmniejszyć długości, ponieważ niektóre z zawartych już w niej danych są zbyt długie

--12
--DELETE FROM projekty WHERE opis_projektu='Sieci kręgosłupowe';
--Nie powiodło się, ponieważ znaleziono rekord podrzędny

--13
/*ALTER TABLE przedzialy DROP CONSTRAINT FK_PRZYDZIALY_01;
ALTER TABLE przedzialy MODIFY id_projektu NUMBER(4) CONSTRAINT FK_PRZYDZIALY_01 REFERENCES projekty(id_projektu) ON DELETE CASCADE;*/

--DELETE FROM projekty WHERE opis_projektu='Sieci kręgosłupowe';

/*SELECT * FROM projekty;
SELECT * FROM przedzialy;*/

--14
--DROP TABLE projekty CASCADE CONSTRAINTS;

--SELECT constraint_name, constraint_type AS C, search_condition FROM user_constraints;

--15
--DROP TABLE projekty_kopia;
--DROP TABLE przedzialy;

--SELECT table_name FROM user_constraints;