--zad1
DECLARE
 vLiczba NUMBER(7,3) := 1000.456;
 vTekst VARCHAR(100) := 'Witaj, świecie! ';
BEGIN
 DBMS_OUTPUT.PUT_LINE('Zmienna vTekst: ' || vTekst);
 DBMS_OUTPUT.PUT_LINE('Zmienna vLiczba: ' || vLiczba);
END;

/

--zad2
DECLARE
 vLiczba NUMBER(19,3) := 1000.456;
 vTekst VARCHAR(100) := 'Witaj, świecie! ';
BEGIN
 vLiczba := vLiczba + POWER(10,15);
 vTekst := CONCAT(vTekst, 'Witaj, nowy dniu!');
 DBMS_OUTPUT.PUT_LINE('Zmienna vTekst: ' || vTekst);
 DBMS_OUTPUT.PUT_LINE('Zmienna vLiczba: ' || vLiczba);
END;

/

--zad3
DECLARE
 vLiczba1 NUMBER(20,7) := 10.2356000;
 vLiczba2 vLiczba1%TYPE := 0.0000001;
 vLiczba vLiczba1%TYPE;
BEGIN
 vLiczba := vLiczba1 + vLiczba2;
 DBMS_OUTPUT.PUT_LINE('Wynik dodawania 10,2356000 i 0,0000001: ' || vLiczba);
END;

/

--zad4
DECLARE
 cPI CONSTANT NUMBER(3,2) := 3.14;
 vLiczba NUMBER(5,3);
 vObwod vLiczba%TYPE;
 vPole vLiczba%TYPE;
BEGIN
 vLiczba := 5;
 vObwod := 2*vLiczba*cPI;
 vPole := cPI*POWER(vLIczba,2);
 DBMS_OUTPUT.PUT_LINE('Obwód koła o promieniu równym 5: ' || vObwod);
 DBMS_OUTPUT.PUT_LINE('Pole koła o promieniu równym 5: ' || vPole);
END;

/

--zad5
DECLARE
 vNazwisko Pracownicy.nazwisko%TYPE;
 vEtat Pracownicy.nazwisko%TYPE;
BEGIN
 SELECT nazwisko, etat INTO vNazwisko, vEtat FROM Pracownicy WHERE (placa_pod + COALESCE(placa_dod, 0)) = (SELECT MAX(placa_pod + COALESCE(placa_dod, 0)) FROM Pracownicy);
 DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vNazwisko);
 DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || vEtat);
END;

/

--zad6
DECLARE
 TYPE tDane IS RECORD (
 nazwisko VARCHAR(100),
 etat VARCHAR(50));
 vPracownik tDane;
BEGIN
 SELECT nazwisko, etat INTO vPracownik.nazwisko, vPracownik.etat FROM Pracownicy WHERE (placa_pod + COALESCE(placa_dod, 0)) = (SELECT MAX(placa_pod + COALESCE(placa_dod, 0)) FROM Pracownicy);
 DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vPracownik.nazwisko);
 DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || vPracownik.etat);
END;

/

--zad7
DECLARE
 SUBTYPE tKwota IS NUMBER(7,2);
 vZarobek tKwota;
 vNazwisko Pracownicy.nazwisko%TYPE;
BEGIN
 SELECT nazwisko, (placa_pod + COALESCE(placa_dod, 0)) INTO vNazwisko, vZarobek FROM Pracownicy WHERE nazwisko = 'SLOWINSKI';
 DBMS_OUTPUT.PUT_LINE('Pracownik ' || vNazwisko || 'zarabia rocznie ' || vZarobek*12);
END;

/

--zad8
DECLARE
BEGIN
 WHILE TO_CHAR(SYSDATE, 'ss') != '25' LOOP
    NULL;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Nadeszła 25 sekunda!');
END;

/

--zad9
DECLARE
 vLiczba NATURAL;
 vZmienna NATURAL;
 vWynik NATURAL;
BEGIN
 vLiczba := 10;
 vZmienna := 1;
 vWynik := 1;
 WHILE vZmienna <= vLiczba LOOP
    vWynik := vWynik*vZmienna;
    vZmienna := vZmienna + 1;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Silnia dla n=' || vLiczba || ': ' || vWynik);
END;

/

--zad10
DECLARE
 vDate DATE;
 vDay CHAR(1);
 vDayNumber NUMBER;
 vYear VARCHAR(4);
BEGIN
 vDate := CURRENT_DATE;
 vDay := TO_CHAR(vDate, 'D');
 vDayNumber := TO_CHAR(vDate, 'DD');
 vYear := TO_CHAR(vDate, 'YYYY');
 WHILE vYear <= '2100' LOOP
  IF vDay = '5' AND vDayNumber = 13 THEN
   DBMS_OUTPUT.PUT_LINE(TO_CHAR(vDate, 'DD-MM-YYYY'));
  END IF;
  vDate := vDate + 1;
  vDay := TO_CHAR(vDate, 'D');
  vDayNumber := TO_CHAR(vDate, 'DD');
  vYear := TO_CHAR(vDate, 'YYYY');
 END LOOP;
END;