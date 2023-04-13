/* zad 1 */
/* SELECT * FROM zespoly ORDER BY id_zesp ASC;*/

/* zad 2 */
/* SELECT * FROM pracownicy ORDER BY id_prac ASC;*/

/* zad 3 */
/* SELECT nazwisko, placa_pod*12 AS ROCZNA_PLACA FROM pracownicy ORDER BY nazwisko ASC;*/

/* zad 4 */
/* SELECT nazwisko, etat, placa_pod + COALESCE(placa_dod, 0) AS MIESIECZNE_ZAROBKI FROM pracownicy ORDER BY MIESIECZNE_ZAROBKI DESC;*/

/* zad 5 */
/* SELECT * FROM zespoly ORDER BY nazwa ASC;*/

/* zad 6 */
/* SELECT UNIQUE etat FROM pracownicy ORDER BY etat ASC;*/

/* zad 7 */
/* SELECT * FROM pracownicy where etat = 'ASYSTENT' ORDER BY nazwisko ASC;*/

/* zad 8 */
/* SELECT id_prac, nazwisko, etat, placa_pod, id_zesp FROM pracownicy where id_zesp = 30 OR id_zesp = 40 ORDER BY placa_pod DESC;*/

/* zad 9 */
/* SELECT nazwisko, id_zesp, placa_pod FROM pracownicy WHERE placa_pod BETWEEN AND 800 ORDER BY nazwisko ASC;*/

/* zad 10 */
/* SELECT nazwisko, etat, id_zesp FROM pracownicy WHERE nazwisko LIKE '%SKI';*/

/* zad 11 */
/* SELECT id_prac, id_szefa, nazwisko, placa_pod FROM pracownicy WHERE placa_pod > 1000 AND id_szefa IS NOT NULL;*/

/* zad 12 */
/* SELECT nazwisko, id_zesp FROM pracownicy WHERE id_zesp = 20 AND (nazwisko LIKE 'M%' OR nazwisko LIKE '%SKI') ORDER BY nazwisko ASC;*/

/* zad 13 */
/* SELECT nazwisko, etat, placa_pod/160 AS STAWKA FROM pracownicy WHERE etat != 'ADIUNKT' AND etat != 'ASYSTENT' AND etat != 'STAZYSTA' AND placa_pod < 400 OR placa_pod > 800 ORDER BY stawka ASC;*/

/* zad 14 */
/* SELECT nazwisko, etat, placa_pod, placa_dod FROM pracownicy WHERE placa_pod + COALESCE(placa_dod, 0) > 1000 ORDER BY etat, nazwisko ASC*/

/* zad 15 */
/* SELECT nazwisko || ' PRACUJE OD ' || zatrudniony || ' I ZARABIA ' || placa_pod AS "PROFESOROWIE" FROM pracownicy WHERE etat = 'PROFESOR';*/