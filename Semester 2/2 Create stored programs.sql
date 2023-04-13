--zad0

CREATE PROCEDURE Podwyzka IS

BEGIN

 UPDATE Pracownicy

 SET placa_pod = placa_pod * 1.1;

END Podwyzka;





--zad1

CREATE OR REPLACE PROCEDURE NowyPracownik 

    (nowy_nazwisko IN Pracownicy.nazwisko%TYPE,

    nowy_nazwa_zespolu IN Zespoly.nazwa%TYPE,

    nazwisko_szefa IN Pracownicy.nazwisko%TYPE,

    nowy_placa_pod IN Pracownicy.placa_pod%TYPE,

    data_zatrudnienia IN Pracownicy.zatrudniony%TYPE DEFAULT CURRENT_DATE,

    nowy_etat IN Pracownicy.etat%TYPE DEFAULT 'STAZYSTA')

    IS

BEGIN

    INSERT INTO Pracownicy (id_prac, nazwisko, etat, id_szefa, zatrudniony, placa_pod, id_zesp) 

    VALUES (prac_seq.nextval, nowy_nazwisko, nowy_etat, (SELECT id_prac FROM Pracownicy WHERE nazwisko=nowy_nazwisko), data_zatrudnienia, nowy_placa_pod, (SELECT id_zesp FROM Zespoly WHERE nazwa=nowy_nazwa_zespolu));

END NowyPracownik;





--zad2

CREATE OR REPLACE FUNCTION PlacaNetto

    (placa_brutto IN FLOAT,

    vat IN FLOAT DEFAULT 20)

    RETURN FLOAT IS vPlacaNetto FLOAT;

BEGIN

    vPlacaNetto := placa_brutto * ((100-vat)/100);

    RETURN vPlacaNetto;

END PlacaNetto;





--zad3

CREATE OR REPLACE FUNCTION Silnia

    (start_value IN NATURAL)

    RETURN NATURAL IS vSilnia NATURAL;

BEGIN

    DECLARE 

    cnt INT:=1;

    f_value INT:=1;

    BEGIN

    WHILE (cnt <= start_value) LOOP

        f_value := f_value * cnt;

        cnt := cnt+1;

        DBMS_OUTPUT.PUT_LINE(f_value);

    END LOOP;

    vSilnia := f_value;

    END;

    RETURN vSilnia;

END Silnia;





--zad4

CREATE OR REPLACE FUNCTION SilniaRek

    (start_value IN NATURAL)

    RETURN NATURAL IS vSilnia NATURAL;

BEGIN

    IF start_value < 2 THEN

        RETURN 1;

    ELSE

        RETURN start_value*SilniaRek(start_value-1);

    END IF;

END SilniaRek;





--zad5

CREATE OR REPLACE FUNCTION IleLat

    (Zatrudniony_prac IN Pracownicy.zatrudniony%TYPE)

    RETURN NATURAL IS vIlelat NATURAL;

BEGIN

    vIlelat := EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM Zatrudniony_prac);

    RETURN vIlelat;

END IleLat;





--zad6

CREATE OR REPLACE PACKAGE Konwersja IS

    FUNCTION Cels_To_Fahr(Temp FLOAT)

        RETURN FLOAT;

    

    FUNCTION Fahr_To_Cels(Temp FLOAT)

        RETURN FLOAT;

END Konwersja;

/   



CREATE OR REPLACE PACKAGE BODY Konwersja IS



    FUNCTION Fahr_To_Cels(Temp FLOAT)

        RETURN FLOAT IS vTemp FLOAT;

    BEGIN

        vTemp := (5/9)*(Temp-32);

        RETURN vTemp;

    END Fahr_To_Cels;

    

    FUNCTION Cels_To_Fahr(Temp FLOAT)

        RETURN FLOAT IS vTemp FLOAT;

    BEGIN

        vTemp := (9/5)*Temp+32;

        RETURN vTemp;

    END Cels_To_Fahr;

    

END Konwersja;





--zad7

CREATE OR REPLACE PACKAGE Zmienne IS

    FUNCTION PokazLicznik RETURN NATURAL;

    PROCEDURE ZwiekszLicznik;

    PROCEDURE ZmniejszLicznik;

END Zmienne;

/

    

CREATE OR REPLACE PACKAGE BODY Zmienne IS



    vLicznik NATURAL DEFAULT 0;



    PROCEDURE ZwiekszLicznik IS

    BEGIN

        vLicznik := vLicznik + 1;

        DBMS_OUTPUT.PUT_LINE('Zwiekszono');

    END ZwiekszLicznik;

    

    PROCEDURE ZmniejszLicznik IS

    BEGIN

        vLicznik := vLicznik - 1;

        DBMS_OUTPUT.PUT_LINE('Zmniejszono');

    END ZmniejszLicznik;

    

    FUNCTION PokazLicznik

        RETURN NATURAL IS vLicz NATURAL;

    BEGIN

        vLicz := vLicznik;

        RETURN vLicz;

    END PokazLicznik;

    

BEGIN

        vLicznik := 1;

        DBMS_OUTPUT.PUT_LINE('Zainicjalizowano');

END Zmienne;





--zad8

CREATE OR REPLACE PACKAGE IntZespoly IS

    PROCEDURE DodajZespol(pNazwa VARCHAR, pAdres VARCHAR);

    PROCEDURE UsunZespolId(pId NUMBER);

    PROCEDURE UsunZespolNazwa(pNazwa VARCHAR);

    PROCEDURE Modyfikuj(ZespolId NUMBER, pNazwa VARCHAR, pAdres VARCHAR);

    FUNCTION PokazId(pNazwa VARCHAR) RETURN NATURAL;

    FUNCTION PokazNazwa(pId NUMBER) RETURN VARCHAR2;

    FUNCTION PokazAdres(pId NUMBER) RETURN VARCHAR2;

END IntZespoly;

/

    

CREATE OR REPLACE PACKAGE BODY IntZespoly IS



    PROCEDURE DodajZespol(pNazwa VARCHAR, pAdres VARCHAR) IS

    BEGIN

        INSERT INTO Zespoly(id_zesp, nazwa, adres) VALUES((SELECT MAX(id_zesp)+10 FROM Zespoly), pNazwa, pAdres);

    END DodajZespol;

    

    PROCEDURE UsunZespolId(pId NUMBER) IS

    BEGIN

        DELETE FROM Zespoly WHERE id_zesp = pId;

    END UsunZespolId;

    

    PROCEDURE UsunZespolNazwa(pNazwa VARCHAR) IS

    BEGIN

        DELETE FROM Zespoly WHERE nazwa = pNazwa;

    END UsunZespolNazwa;

    

    PROCEDURE Modyfikuj(ZespolId NUMBER, pNazwa VARCHAR, pAdres VARCHAR) IS

    BEGIN

        UPDATE Zespoly SET nazwa = pNazwa, adres = pAdres WHERE id_zesp = ZespolId;

    END Modyfikuj;

    

    FUNCTION PokazId(pNazwa VARCHAR)

        RETURN NATURAL IS vId NATURAL;

    BEGIN

        SELECT id_zesp INTO vId FROM Zespoly WHERE nazwa = pNazwa;

        RETURN vId;

    END PokazId;

    

    FUNCTION PokazNazwa(pId NUMBER) RETURN VARCHAR2 IS 

        vNazwa VARCHAR2(32767);

    BEGIN

        SELECT nazwa INTO vNazwa FROM Zespoly WHERE id_zesp = pId;

        RETURN vNazwa;

    END PokazNazwa;

    

    FUNCTION PokazAdres(pId NUMBER) RETURN VARCHAR2 IS 

        vAdres VARCHAR2(32767);

    BEGIN

        SELECT adres INTO vAdres FROM Zespoly WHERE id_zesp = pId;

        RETURN vAdres;

    END PokazAdres;

    

END IntZespoly;





--zad9

SELECT object_name, status, object_type FROM User_Objects

WHERE object_type IN ('PACKAGE', 'FUNCTION', 'PROCEDURE')

ORDER BY object_name;

/



SELECT text

FROM User_Source

WHERE name = 'ILELAT'

AND type = 'FUNCTION'

ORDER BY line;





--zad10

DROP FUNCTION Silnia;

DROP FUNCTION SilniaRek;

DROP FUNCTION IleLat;





--zad11

DROP PACKAGE Konwersja;