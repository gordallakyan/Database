
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Osoba CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;


BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Klienci CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

CREATE TABLE Osoba (
    ID INTEGER PRIMARY KEY,
    Imie VARCHAR(20),
    Nazwisko VARCHAR(20)
);

CREATE TABLE Klienci (
    Osoba_ID INTEGER PRIMARY KEY REFERENCES Osoba(ID),
    Srednie_wydatki VARCHAR(20),
    Ilosc_odwiedzin_w_tygodniu INTEGER
);

CREATE TABLE Skladniki (
    ID INTEGER PRIMARY KEY,
    Nazwa VARCHAR(20),
    Kraj_Pochodzenia VARCHAR(20)
);

CREATE TABLE Pracownicy (
    Osoba_ID INTEGER PRIMARY KEY REFERENCES Osoba(ID),
    Pensja INTEGER,
    Numer_telefonu VARCHAR(9)
);

CREATE TABLE Produkty (
    Kod_produktu VARCHAR(20) PRIMARY KEY,
    Cena INTEGER,
    Vat INTEGER
);
CREATE TABLE Klienci_Produkty (
    Klienci_Osoba_ID INTEGER REFERENCES Klienci(Osoba_ID),
    Produkty_Kod_produktu VARCHAR(20) REFERENCES Produkty(Kod_produktu),
    PRIMARY KEY (Klienci_Osoba_ID, Produkty_Kod_produktu)
);
CREATE TABLE Pracownik_Skladniki (
    Pracownicy_Osoba_ID INTEGER REFERENCES Pracownicy(Osoba_ID),
    Skladniki_ID INTEGER REFERENCES Skladniki(ID),
    PRIMARY KEY (Pracownicy_Osoba_ID, Skladniki_ID)
);

CREATE TABLE Produkty_Skladniki (
    Produkty_Kod_produkt VARCHAR(20) REFERENCES Produkty(Kod_produktu),
    Skladniki_ID INTEGER REFERENCES Skladniki(ID),
    PRIMARY KEY (Produkty_Kod_produkt, Skladniki_ID)
);
CREATE SEQUENCE LogIDSeq
START WITH 1
INCREMENT BY 1;

CREATE TABLE ZmianyPensjiLog (
    PracownikID INTEGER,
    StaraPensja INTEGER,
    NowaPensja INTEGER,
    DataZmiany DATE,
    FOREIGN KEY (PracownikID) REFERENCES Pracownicy(Osoba_ID)
);

INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (1, 'Anna', 'Kowalska');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (2, 'Piotr', 'Nowak');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (3, 'Maria', 'Wiśniewska');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (4, 'Jan', 'Wójcik');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (5, 'Zofia', 'Maj');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (6, 'Krzysztof', 'Kamiński');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (7, 'Aleksandra', 'Lewandowska');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (8, 'Marek', 'Zieliński');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (9, 'Julia', 'Szymańska');
INSERT INTO Osoba (ID, Imie, Nazwisko) VALUES (10, 'Tomasz', 'Dąbrowski');

INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu) VALUES (1, '1000-2000', 3);
INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu) VALUES (2, '1500-2500', 2);
INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu) VALUES (3, '500-1000', 1);
INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu) VALUES (4, '2000-3000', 4);
INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu) VALUES (5, '800-1200', 2);

INSERT INTO Pracownicy (Osoba_ID, Pensja, Numer_telefonu) VALUES (6, 3000, '123456789');
INSERT INTO Pracownicy (Osoba_ID, Pensja, Numer_telefonu) VALUES (7, 3500, '987654321');
INSERT INTO Pracownicy (Osoba_ID, Pensja, Numer_telefonu) VALUES (8, 2500, '567890123');
INSERT INTO Pracownicy (Osoba_ID, Pensja, Numer_telefonu) VALUES (9, 2800, '234567890');
INSERT INTO Pracownicy (Osoba_ID, Pensja, Numer_telefonu) VALUES (10, 3200, '345678901');

INSERT INTO Produkty (Kod_produktu, Cena, Vat) VALUES ('P01', 100, 23);
INSERT INTO Produkty (Kod_produktu, Cena, Vat) VALUES ('P02', 200, 23);
INSERT INTO Produkty (Kod_produktu, Cena, Vat) VALUES ('P03', 300, 23);
INSERT INTO Produkty (Kod_produktu, Cena, Vat) VALUES ('P04', 400, 23);
INSERT INTO Produkty (Kod_produktu, Cena, Vat) VALUES ('P05', 500, 23);

INSERT INTO Skladniki(ID, Nazwa, Kraj_Pochodzenia) VALUES (1,'SER','POLSKA');
INSERT INTO Skladniki(ID, Nazwa, Kraj_Pochodzenia) VALUES (2,'POMIDOR','NIEMCY');
INSERT INTO Skladniki(ID, Nazwa, Kraj_Pochodzenia) VALUES (3,'JAJKO','HOLANDIA');
INSERT INTO Skladniki(ID, Nazwa, Kraj_Pochodzenia) VALUES (4,'KURCZAK','FRANCJA');
INSERT INTO Skladniki(ID, Nazwa, Kraj_Pochodzenia) VALUES (5,'MAKA','STANY ZJEDNOCZONE');

INSERT INTO Klienci_Produkty (Klienci_Osoba_ID, Produkty_Kod_produktu) VALUES (1, 'P01');
INSERT INTO Klienci_Produkty (Klienci_Osoba_ID, Produkty_Kod_produktu) VALUES (2, 'P02');
INSERT INTO Klienci_Produkty (Klienci_Osoba_ID, Produkty_Kod_produktu) VALUES (3, 'P03');
INSERT INTO Klienci_Produkty (Klienci_Osoba_ID, Produkty_Kod_produktu) VALUES (4, 'P04');
INSERT INTO Klienci_Produkty (Klienci_Osoba_ID, Produkty_Kod_produktu) VALUES (5, 'P05');

INSERT INTO Pracownik_Skladniki(PRACOWNICY_OSOBA_ID, SKLADNIKI_ID) VALUES (6,'PO2');
INSERT INTO Pracownik_Skladniki(PRACOWNICY_OSOBA_ID, SKLADNIKI_ID) VALUES (7,'PO4');
INSERT INTO Pracownik_Skladniki(PRACOWNICY_OSOBA_ID, SKLADNIKI_ID) VALUES (8,'PO1');
INSERT INTO Pracownik_Skladniki(PRACOWNICY_OSOBA_ID, SKLADNIKI_ID) VALUES (9,'PO3');
INSERT INTO Pracownik_Skladniki(PRACOWNICY_OSOBA_ID, SKLADNIKI_ID) VALUES (10,'PO5');

INSERT INTO Produkty_Skladniki(PRODUKTY_KOD_PRODUKT, SKLADNIKI_ID) VALUES ('PO1',3);
INSERT INTO Produkty_Skladniki(PRODUKTY_KOD_PRODUKT, SKLADNIKI_ID) VALUES ('PO2',1);
INSERT INTO Produkty_Skladniki(PRODUKTY_KOD_PRODUKT, SKLADNIKI_ID) VALUES ('PO3',4);
INSERT INTO Produkty_Skladniki(PRODUKTY_KOD_PRODUKT, SKLADNIKI_ID) VALUES ('PO4',2);
INSERT INTO Produkty_Skladniki(PRODUKTY_KOD_PRODUKT, SKLADNIKI_ID) VALUES ('PO5',5);


--Liczba klientów dla każdego produktu
--1
SELECT p.Kod_produktu, COUNT(*) AS liczba_klientow
FROM Produkty p
JOIN Klienci_Produkty kp ON p.Kod_produktu = kp.Produkty_Kod_produktu
GROUP BY p.Kod_produktu;
--Łączna pensja pracowników dla każdego kraju pochodzenia składnika
--2
SELECT s.Kraj_Pochodzenia, SUM(pr.Pensja) AS laczna_pensja
FROM Pracownicy pr
JOIN Pracownik_Skladniki ps ON pr.Osoba_ID = ps.Pracownicy_Osoba_ID
JOIN Skladniki s ON ps.Skladniki_ID = s.ID
GROUP BY s.Kraj_Pochodzenia;
--Lista produktów z ceną wyższą niż średnia
--3
SELECT s.Kraj_Pochodzenia, SUM(pr.Pensja) AS laczna_pensja
FROM Pracownicy pr
JOIN Pracownik_Skladniki ps ON pr.Osoba_ID = ps.Pracownicy_Osoba_ID
JOIN Skladniki s ON ps.Skladniki_ID = s.ID
GROUP BY s.Kraj_Pochodzenia;
--Klienci, którzy odwiedzili więcej niż średnia odwiedzin wszystkich klientów
--4
SELECT *
FROM Klienci
WHERE Ilosc_odwiedzin_w_tygodniu > (SELECT AVG(Ilosc_odwiedzin_w_tygodniu) FROM Klienci);
--Lista klientów i ich ostatnie zmiany pensji
--5
SELECT o.Imie, o.Nazwisko, zpl.NowaPensja, zpl.DataZmiany
FROM Osoba o
JOIN Pracownicy p ON o.ID = p.Osoba_ID
JOIN ZmianyPensjiLog zpl ON p.Osoba_ID = zpl.PracownikID
WHERE zpl.DataZmiany = (SELECT MAX(DataZmiany) FROM ZmianyPensjiLog WHERE PracownikID = p.Osoba_ID);
--Produkty, które zawierają składnik z określonego kraju
--6
SELECT p.*
FROM Produkty p
JOIN Produkty_Skladniki ps ON p.Kod_produktu = ps.Produkty_Kod_produkt
JOIN Skladniki s ON ps.Skladniki_ID = s.ID
WHERE s.Kraj_Pochodzenia = 'Polska';
--Ilość pracowników pracujących z każdym składnikiem
--7
SELECT s.Nazwa, COUNT(*) AS liczba_pracownikow
FROM Skladniki s
JOIN Pracownik_Skladniki ps ON s.ID = ps.Skladniki_ID
JOIN Pracownicy pr ON ps.Pracownicy_Osoba_ID = pr.Osoba_ID
GROUP BY s.Nazwa;
--Klienci, którzy wydają więcej niż średnia ich wydatków
--8
SELECT k.*
FROM Klienci k
WHERE TO_NUMBER(k.Srednie_wydatki) > (SELECT AVG(TO_NUMBER(Srednie_wydatki)) FROM Klienci);
--Lista produktów i ich składników
--9
SELECT p.Kod_produktu, s.Nazwa AS Skladnik
FROM Produkty p
JOIN Produkty_Skladniki ps ON p.Kod_produktu = ps.Produkty_Kod_produkt
JOIN Skladniki s ON ps.Skladniki_ID = s.ID;
--Lista klientów, którzy kupili więcej niż jeden rodzaj produktu
--10
SELECT o.Imie, o.Nazwisko, COUNT(DISTINCT kp.Produkty_Kod_produktu) AS liczba_roznych_produktow
FROM Osoba o
JOIN Klienci k ON o.ID = k.Osoba_ID
JOIN Klienci_Produkty kp ON k.Osoba_ID = kp.Klienci_Osoba_ID
GROUP BY o.Imie, o.Nazwisko
HAVING COUNT(DISTINCT kp.Produkty_Kod_produktu) > 1;
