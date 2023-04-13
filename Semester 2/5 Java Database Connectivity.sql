--zad1
        public static void main(String[] args) {
        Connection conn = null;
        String connectionString = "jdbc:oracle:thin:@//admlab2.cs.put.poznan.pl:1521/"+ "dblab02_students.cs.put.poznan.pl";
        Properties connectionProps = new Properties();
        connectionProps.put("user", "user");
        connectionProps.put("password", "password");
        try {
            conn = DriverManager.getConnection(connectionString,
            connectionProps);
            System.out.println("Połączono z bazą danych");
        } catch (SQLException ex) {
            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE,
            "Nie udało się połączyć z bazą danych", ex);
            System.exit(-1);
        }
        
        ### Początekczęści edytowanej w następnych zadaniach ###

        try (Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS number_workers " + "FROM pracownicy");){
            if(rs.next()){
                System.out.println("Zatrudniono " + rs.getInt(1) + " pracwoników, w tym:");
                try (ResultSet rs2 = stmt.executeQuery( "SELECT RPAD(nazwisko, 10, ' ') AS nazwisko, RPAD(id_zesp, 10, ' ') AS id_zesp " + "FROM pracownicy");){
                    while (rs2.next()) {
                        System.out.println( rs2.getString(1) + " w zespole " + rs2.getInt(2) + ",");
                    }
                } catch (SQLException ex) {
                    System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
                }
            }
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }

        ### Koniec części edytowanej ###
        
        try {
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("Rozłączono z bazą danych");
    }

--zad2
        try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("SELECT nazwisko, placa_pod+COALESCE(placa_dod, 0) AS zarobki " + "FROM pracownicy WHERE etat='ASYSTENT' ORDER BY zarobki ASC");){
            if(rs.next()){
                System.out.println( rs.getString(1) + " zarabia " + rs.getInt(2) + ",");
            }
            if(rs.relative(2)){
                System.out.println( rs.getString(1) + " zarabia " + rs.getInt(2) + ",");
            }
            if(rs.absolute(-2)){
                System.out.println( rs.getString(1) + " zarabia " + rs.getInt(2) + ",");
            }
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }

--zad3
        Statement stmt = null;
        try {
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        
            int [] zwolnienia={150, 200, 230};
            int wielkosc_zwolnienia = zwolnienia.length;
            String [] zatrudnienia={"Kandefer", "Rygiel", "Boczar"};
            int wielkosc_zatrudnienia = zatrudnienia.length;
            String sql = "select prac_seq.nextval from DUAL";
            
            for (int i = 0; i < wielkosc_zwolnienia; i++) {
                String numer_zwolnienia = Integer.toString(zwolnienia[i]);
               int changes = stmt.executeUpdate("DELETE FROM Pracownicy WHERE id_prac="+numer_zwolnienia);
            }
            
            for (int i = 0; i < wielkosc_zatrudnienia; i++) {
                String zatrudniony = zatrudnienia[i];
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    String nextID_from_seq = Integer.toString(rs.getInt(1));
                    String tekst = "INSERT INTO pracownicy(id_prac,nazwisko) VALUES(" + nextID_from_seq + ",'" + zatrudniony + "')";
                    int changes = stmt.executeUpdate(tekst);
                }
            }
            
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }
        finally {
         if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) { /* kod obsługi */ }
         }
        }

--zad4
        try {
            conn.setAutoCommit(false);
        } catch (SQLException ex) {
            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            ResultSet rs = stmt.executeQuery("SELECT nazwa FROM etaty");
            while(rs.next()){
                System.out.println( rs.getString(1));
            }
            
            System.out.println( "------------");
            String nazwa = "STUDENT";
            String tekst = "INSERT INTO etaty(nazwa) VALUES('" + nazwa + "')";
            int changes = stmt.executeUpdate(tekst);
            
            rs = stmt.executeQuery("SELECT nazwa FROM etaty");
            while(rs.next()){
                System.out.println( rs.getString(1));
            }
            
            System.out.println( "------------");
            conn.rollback();
            
            rs = stmt.executeQuery("SELECT nazwa FROM etaty");
            while(rs.next()){
                System.out.println( rs.getString(1));
            }
            
            System.out.println( "------------");
            changes = stmt.executeUpdate(tekst);
            conn.commit();
            
            rs = stmt.executeQuery("SELECT nazwa FROM etaty");
            while(rs.next()){
                System.out.println( rs.getString(1));
            }
            
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }

--zad5
        String [] nazwiska={"Woźniak", "Dąbrowski", "Kozłowski"};
        int ilosc_nazwisk = nazwiska.length;
        int [] place={1300, 1700, 1500};
        String [] etaty={"ASYSTENT", "PROFESOR", "ADIUNKT"};
        
        try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pracownicy(id_prac, nazwisko, placa_pod, etat) VALUES(?, ?, ?, ?)");
            PreparedStatement ps = conn.prepareStatement("SELECT prac_seq.nextval FROM DUAL");
            
            ResultSet rs = stmt.executeQuery("SELECT id_prac, nazwisko, placa_pod, etat FROM pracownicy");
            while(rs.next()){
                System.out.println( rs.getString(1) + " " + rs.getString(2) + " " + rs.getString(4) + " " + rs.getString(3));
            }
            
            for (int i = 0; i < ilosc_nazwisk; i++) {
                ResultSet rs2 = ps.executeQuery();
                if(rs2.next()){
                    String nextID_from_seq = Integer.toString(rs2.getInt(1));
                    pstmt.setString(1, nextID_from_seq);
                    pstmt.setString(2, nazwiska[i]);
                    pstmt.setString(3, Integer.toString(place[i]));
                    pstmt.setString(4, etaty[i]);
                    int changes = pstmt.executeUpdate();
                }
            }
            
            System.out.println( "--------------------");
            rs = stmt.executeQuery("SELECT id_prac, nazwisko, placa_pod, etat FROM pracownicy");
            while(rs.next()){
                System.out.println( rs.getString(1) + " " + rs.getString(2) + " " + rs.getString(4) + " " + rs.getString(3));
            }
            
            
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }

--zad6
        try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pracownicy(id_prac, nazwisko) VALUES(?, ?)");
            PreparedStatement ps = conn.prepareStatement("SELECT prac_seq.nextval FROM DUAL");
            
            long start = System.nanoTime();
            for (int i = 0; i < 2000; i++) {
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    String nextID_from_seq = Integer.toString(rs.getInt(1));
                    int changes = stmt.executeUpdate("INSERT INTO pracownicy(id_prac,nazwisko) VALUES(" + nextID_from_seq + ",'Stefan')");
                }
            }
            long czas1 = System.nanoTime() - start;
            
            start = System.nanoTime();
            for (int i = 0; i < 2000; i++) {
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    String nextID_from_seq = Integer.toString(rs.getInt(1));
                    pstmt.setString(1, nextID_from_seq);
                    pstmt.setString(2, "Maks");
                    pstmt.addBatch();
                }
            }
            pstmt.executeBatch();
            long czas2 = System.nanoTime() - start;
            
            System.out.println(czas1);
            System.out.println(czas2);
            
            
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }

        //35448319900ns czas1
        //16226668800ns czas2 (ponad 2 razy szybciej)

--zad7

Funkcja przetwarzająca nazwisko pracownika o podanym id:

        CREATE OR REPLACE FUNCTION ZmienNazwisko
            (id_value IN Pracownicy.id_prac%TYPE,
            nazwisko_value OUT Pracownicy.nazwisko%TYPE)
            RETURN NATURAL IS vResult NATURAL;
        BEGIN
            DECLARE
            vElement varchar2(20);
            vFirst char(1);
            vElse varchar2(20);
            l_exists natural;
            BEGIN
                SELECT CASE
                    WHEN EXISTS(SELECT nazwisko FROM Pracownicy WHERE id_prac = id_value) THEN 1
                    ELSE 0 END INTO l_exists FROM Dual;
                IF l_exists = 1 THEN
                    SELECT nazwisko INTO vElement FROM Pracownicy WHERE id_prac = id_value;
                    vFirst := UPPER(SUBSTR(vElement, 1, 1));
                    vElse := LOWER(SUBSTR(vElement, 2, LENGTH(vElement)));
                    DBMS_OUTPUT.PUT_LINE(vFirst);
                    DBMS_OUTPUT.PUT_LINE(vElse);
                    nazwisko_value := CONCAT(vFirst, vElse);
                    DBMS_OUTPUT.PUT_LINE(nazwisko_value);
                    RETURN 1;
                ELSE
                    RETURN 0;
                END IF;
            END;
        END ZmienNazwisko;


Kod programu JDBC:

        try (CallableStatement stmt = conn.prepareCall("{? = call ZmienNazwisko(?, ?)}")) {
            
            stmt.setString(2, "100");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.registerOutParameter(3, Types.VARCHAR);
            stmt.execute();
            Integer vWynik = stmt.getInt(1);
            String vNazwisko = stmt.getString(3);
            if (vWynik == 1){
                System.out.println(vNazwisko);
            } else {
                System.out.println("Brak pracownika o podanym id");
            }
            
        } catch (SQLException ex) {
            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());
        }