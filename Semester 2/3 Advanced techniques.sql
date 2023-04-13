--zad1
DECLARE
 CURSOR cPracownicy(pEtat VARCHAR) IS
 SELECT nazwisko, zatrudniony
 FROM Pracownicy
 WHERE etat = pEtat
 ORDER BY nazwisko;
 
 vNazwisko Pracownicy.nazwisko%TYPE;
 vZatrudniony Pracownicy.zatrudniony%TYPE;
BEGIN

 OPEN cPracownicy('ASYSTENT');
 LOOP
    FETCH cPracownicy INTO vNazwisko, vZatrudniony;
    EXIT WHEN cPracownicy%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(vNazwisko||' pracuje od ' || vZatrudniony);
 END LOOP;
 CLOSE cPracownicy;
END;

--zad2
DECLARE
 CURSOR cPracownicy IS
 SELECT nazwisko
 FROM Pracownicy
 ORDER BY placa_pod+COALESCE(placa_dod, 0) DESC;
 
 vNazwisko Pracownicy.nazwisko%TYPE;
BEGIN

 OPEN cPracownicy;
 LOOP
    FETCH cPracownicy INTO vNazwisko;
    EXIT WHEN cPracownicy%ROWCOUNT=4;
    DBMS_OUTPUT.PUT_LINE(cPracownicy%ROWCOUNT || ' : ' || vNazwisko);
 END LOOP;
 CLOSE cPracownicy;
END;

--zad3
DECLARE
 CURSOR cPracownicy(pDay VARCHAR) IS
 SELECT nazwisko, placa_pod, zatrudniony
 FROM Pracownicy
 WHERE TO_CHAR(zatrudniony, 'D') = 2
 ORDER BY nazwisko
 FOR UPDATE;
 
BEGIN
    FOR vPracownik IN cPracownicy('MONDAY') LOOP
        UPDATE Pracownicy
        SET placa_pod = placa_pod * 1.2
        WHERE CURRENT OF cPracownicy;
    END LOOP;
END;

--zad4
DECLARE
 CURSOR cPracownicy IS
 SELECT *
 FROM Pracownicy p JOIN Zespoly z ON p.id_zesp = z.id_zesp
 ORDER BY nazwisko
 FOR UPDATE;
 
BEGIN
    FOR vPracownik IN cPracownicy LOOP
        IF vPracownik.nazwa = 'ALGORYTMY' THEN
            UPDATE Pracownicy
            SET placa_dod = COALESCE(placa_dod, 0) + 100
            WHERE CURRENT OF cPracownicy;
        ELSIF vPracownik.nazwa = 'ADMINISTRACJA' THEN
            UPDATE Pracownicy
            SET placa_dod = COALESCE(placa_dod, 0) + 150
            WHERE CURRENT OF cPracownicy;
        ELSIF vPracownik.etat = 'STAZYSTA' THEN
            DELETE FROM Pracownicy
            WHERE CURRENT OF cPracownicy;
        END IF;
    END LOOP;
END;

--zad5
CREATE OR REPLACE PROCEDURE PokazPracownikowEtatu(pEtat IN VARCHAR) IS
 
 CURSOR cPokazPracownikowEtatu(cEtat VARCHAR) IS
 SELECT nazwisko, etat
 FROM Pracownicy
 WHERE etat = cEtat
 ORDER BY nazwisko;

BEGIN
    FOR vPracownik IN cPokazPracownikowEtatu(pEtat) LOOP
        DBMS_OUTPUT.PUT_LINE(vPracownik.nazwisko);
    END LOOP;
END PokazPracownikowEtatu;

--zad6
CREATE OR REPLACE PROCEDURE RaportKadrowy IS

 CURSOR cEtaty IS
 SELECT nazwa
 FROM Etaty;
 
 CURSOR cPracownicy(cEtat VARCHAR) IS
 SELECT nazwisko, etat, placa_pod, placa_dod
 FROM Pracownicy
 WHERE etat = cEtat
 ORDER BY nazwisko;
 
 vLiczba NUMBER;
 vPensjaLaczna FLOAT;
 vPensjaPracownik FLOAT;
 vEtat Pracownicy.etat%TYPE;

BEGIN

    FOR vEtaty IN cEtaty LOOP
    vEtat := vEtaty.nazwa;
    vLiczba := 0;
    vPensjaLaczna := 0;
    DBMS_OUTPUT.PUT_LINE(vEtat);
    DBMS_OUTPUT.PUT_LINE('------------------------------');
        FOR vPracownik IN cPracownicy(vEtat) LOOP
            vLiczba := vLiczba + 1;
            vPensjaPracownik := vPracownik.placa_pod + COALESCE(vPracownik.placa_dod, 0);
            vPensjaLaczna := vPensjaLaczna + vPensjaPracownik;
            DBMS_OUTPUT.PUT_LINE(vLiczba|| '. ' || vPracownik.nazwisko || ', pensja: ' || vPensjaPracownik);
        END LOOP;
        IF vLiczba = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Brak');
            DBMS_OUTPUT.PUT_LINE(' ');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Liczba pracowników: ' || vLiczba);
            DBMS_OUTPUT.PUT_LINE('Średnia pensja: ' || vPensjaLaczna/vLiczba);
            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
    END LOOP;
END RaportKadrowy;

--zad7
create or replace PACKAGE BODY IntZespoly IS

    PROCEDURE DodajZespol(pNazwa VARCHAR, pAdres VARCHAR) IS
    BEGIN
        INSERT INTO Zespoly(id_zesp, nazwa, adres) VALUES((SELECT MAX(id_zesp)+10 FROM Zespoly), pNazwa, pAdres);
        
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE ('Nie udao sie dodac zespolu');
    END IF;
    END DodajZespol;

    PROCEDURE UsunZespolId(pId NUMBER) IS
    BEGIN
        DELETE FROM Zespoly WHERE id_zesp = pId;
        
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE ('Nie udao sie usunac zespolu po id');
    END IF;
    END UsunZespolId;

    PROCEDURE UsunZespolNazwa(pNazwa VARCHAR) IS
    BEGIN
        DELETE FROM Zespoly WHERE nazwa = pNazwa;
        
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE ('Nie udao sie usunac zespolu po nazwie');
    END IF;
    END UsunZespolNazwa;

    PROCEDURE Modyfikuj(ZespolId NUMBER, pNazwa VARCHAR, pAdres VARCHAR) IS
    BEGIN
        UPDATE Zespoly SET nazwa = pNazwa, adres = pAdres WHERE id_zesp = ZespolId;
    
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE ('Nie udao sie zmodyfikowac zespolu');
    END IF;
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

--zad8
create or replace PACKAGE IntZespoly IS
    PROCEDURE DodajZespol(pId NUMBER, pNazwa VARCHAR, pAdres VARCHAR);
    PROCEDURE UsunZespolId(pId NUMBER);
    PROCEDURE UsunZespolNazwa(pNazwa VARCHAR);
    PROCEDURE Modyfikuj(ZespolId NUMBER, pNazwa VARCHAR, pAdres VARCHAR);
    FUNCTION PokazId(pNazwa VARCHAR) RETURN VARCHAR2;
    FUNCTION PokazNazwa(pId NUMBER) RETURN VARCHAR2;
    FUNCTION PokazAdres(pId NUMBER) RETURN VARCHAR2;
    FUNCTION Counter(pId NUMBER) RETURN BOOLEAN ;
    exNiepoprawnyIdZespolu EXCEPTION;
    exNiepoprawnaNazwaZespolu EXCEPTION;
    exIdZajete EXCEPTION;
    exError EXCEPTION;
END IntZespoly;
/
create or replace PACKAGE BODY IntZespoly IS
    
    FUNCTION Counter(pId NUMBER) RETURN BOOLEAN IS
    vCounter NUMBER;
    BEGIN
        SELECT COUNT(*) INTO vCounter FROM Zespoly WHERE id_zesp=pId;
        IF vCounter > 0 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END Counter;
    
    FUNCTION Counter_name(pName VARCHAR) RETURN BOOLEAN IS
    vCounter_name NUMBER;
    BEGIN
        SELECT COUNT(*) INTO vCounter_name FROM Zespoly WHERE nazwa=pName;
        IF vCounter_name > 0 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END Counter_name;


    PROCEDURE DodajZespol(pId NUMBER, pNazwa VARCHAR, pAdres VARCHAR) IS
    BEGIN
        IF Counter(pId) = TRUE THEN
            RAISE exIdZajete;
        ELSE
            INSERT INTO Zespoly(id_zesp, nazwa, adres) VALUES((SELECT MAX(id_zesp)+10 FROM Zespoly), pNazwa, pAdres);
        END IF;

        IF SQL%NOTFOUND THEN
            RAISE exError;
        END IF;

        EXCEPTION
            WHEN exIdZajete THEN DBMS_OUTPUT.PUT_LINE('Id zespolu zajete');
            WHEN exError THEN DBMS_OUTPUT.PUT_LINE ('Nie udalo sie dodac zespolu');
    END DodajZespol;


    PROCEDURE UsunZespolId(pId NUMBER) IS
    BEGIN
        IF Counter(pId) = FALSE THEN
            RAISE exNiepoprawnyIdZespolu;
        ELSE
            DELETE FROM Zespoly WHERE id_zesp = pId;
        END IF;
        
        IF SQL%NOTFOUND THEN
            RAISE exError;
        END IF;

        EXCEPTION
            WHEN exNiepoprawnyIdZespolu THEN DBMS_OUTPUT.PUT_LINE('Nie istnieje zespol o id '|| pId);
            WHEN exError THEN DBMS_OUTPUT.PUT_LINE('Nie udalo sie usunac zespolu o podanym id');
            
    END UsunZespolId;


    PROCEDURE UsunZespolNazwa(pNazwa VARCHAR) IS
    BEGIN
        IF Counter_name(pNazwa) = FALSE THEN
            RAISE exNiepoprawnaNazwaZespolu;
        ELSE
            DELETE FROM Zespoly WHERE nazwa = pNazwa;
        END IF;

        IF SQL%NOTFOUND THEN
            RAISE exError;
        END IF;
    
        EXCEPTION
            WHEN exNiepoprawnaNazwaZespolu THEN DBMS_OUTPUT.PUT_LINE('Nie istnieje zespol o nazwie '|| pNazwa);
            WHEN exError THEN DBMS_OUTPUT.PUT_LINE('Nie udalo sie usunac zespolu o podanej nazwie');
    END UsunZespolNazwa;


    PROCEDURE Modyfikuj(ZespolId NUMBER, pNazwa VARCHAR, pAdres VARCHAR) IS
    BEGIN
        IF Counter(ZespolId) = FALSE THEN
            RAISE exNiepoprawnyIdZespolu;
        ELSE
            UPDATE Zespoly SET nazwa = pNazwa, adres = pAdres WHERE id_zesp = ZespolId;
        END IF;

        IF SQL%NOTFOUND THEN
            RAISE exError;
        END IF;
    
        EXCEPTION
            WHEN exNiepoprawnyIdZespolu THEN DBMS_OUTPUT.PUT_LINE('Nie istnieje zespol o id '|| ZespolId);
            WHEN exError THEN DBMS_OUTPUT.PUT_LINE('Nie udalo sie zmodyfikowac zespolu o podanym id');
    END Modyfikuj;


    FUNCTION PokazId(pNazwa VARCHAR)
        RETURN VARCHAR2 IS vId VARCHAR2(32767);
    BEGIN
        IF Counter_name(pNazwa) = FALSE THEN
            RAISE exNiepoprawnaNazwaZespolu;
        ELSE
            SELECT id_zesp INTO vId FROM Zespoly WHERE nazwa = pNazwa;
            RETURN TO_CHAR(vId);
        END IF;

        EXCEPTION
            WHEN exNiepoprawnaNazwaZespolu THEN DBMS_OUTPUT.PUT_LINE('Nie istnieje zespol o nazwie '|| pNazwa);
            RETURN 'Blad';
            
    END PokazId;


    FUNCTION PokazNazwa(pId NUMBER) RETURN VARCHAR2 IS
        vNazwa VARCHAR2(32767);
    BEGIN
        IF Counter(pId) = FALSE THEN
            RAISE exNiepoprawnyIdZespolu;
        ELSE
            SELECT nazwa INTO vNazwa FROM Zespoly WHERE id_zesp = pId;
            RETURN vNazwa;
        END IF;

        EXCEPTION
            WHEN exNiepoprawnyIdZespolu THEN
                DBMS_OUTPUT.PUT_LINE('Nie istnieje zespol o id '|| pId);
                RETURN 'Blad';
            
    END PokazNazwa;


    FUNCTION PokazAdres(pId NUMBER) RETURN VARCHAR2 IS
        vAdres VARCHAR2(32767);
    BEGIN
        IF Counter(pId) = FALSE THEN
            RAISE exNiepoprawnyIdZespolu;
        ELSE
            SELECT adres INTO vAdres FROM Zespoly WHERE id_zesp = pId;
            RETURN vAdres;
        END IF;

        EXCEPTION
            WHEN exNiepoprawnyIdZespolu THEN
                DBMS_OUTPUT.PUT_LINE('Nie istnieje zespol o id '|| pId);
                RETURN 'Blad';

    END PokazAdres;

END IntZespoly;