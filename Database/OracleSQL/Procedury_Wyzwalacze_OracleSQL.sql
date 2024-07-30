

BEGIN
   EXECUTE IMMEDIATE 'DROP TRIGGER SprawdzWydatkiOdwiedzin';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -4043 THEN
         RAISE;
      END IF;
END;
BEGIN
   EXECUTE IMMEDIATE 'DROP TRIGGER SprawdzWydatkiOdwiedzin';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -4043 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP TRIGGER SprawdzNumerTelefonu';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -4043 THEN
         RAISE;
      END IF;
END;

BEGIN
   EXECUTE IMMEDIATE 'DROP PROCEDURE RejestrujNowegoKlienta';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -4043 THEN
         RAISE;
      END IF;
END;


BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE Osoba_SEQ';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -4043 THEN
         RAISE;
      END IF;
END;

CREATE SEQUENCE Osoba_SEQ
START WITH 12
INCREMENT BY 1;

--Jesli klient odwiedza piekarnie mniej niz 2 razy w tygodniu, placi wiecej, a jezeli wiecej niz 5 razy to placi mniej
CREATE OR REPLACE TRIGGER SprawdzWydatkiOdwiedzin
BEFORE INSERT ON Klienci
FOR EACH ROW
BEGIN
    IF :NEW.Ilosc_odwiedzin_w_tygodniu < 2 THEN
        :NEW.Srednie_wydatki := :NEW.Srednie_wydatki * 3.0;
    ELSIF :NEW.Ilosc_odwiedzin_w_tygodniu > 5 THEN
        :NEW.Srednie_wydatki := :NEW.Srednie_wydatki * 0.99;
    END IF;
END SprawdzWydatkiOdwiedzin;


--Ta procedura dodaje klienta, pod warunkiem ze wydaje odpowiednia ilosc pieniedzy na zakupy
CREATE OR REPLACE PROCEDURE RejestrujNowegoKlienta(
    imie IN VARCHAR2,
    nazwisko IN VARCHAR2,
    srednieWydatki IN NUMBER,
    iloscOdwiedzin IN NUMBER
) AS
    noweID INTEGER;
    MaxWydatki NUMBER;
    CURSOR c_osoba IS SELECT ID FROM Osoba WHERE Imie = imie AND Nazwisko = nazwisko;
    v_osoba_id Osoba.ID%TYPE;
BEGIN
    MaxWydatki := iloscOdwiedzin * 1000;

    IF srednieWydatki > MaxWydatki THEN
        RAISE_APPLICATION_ERROR(-20001, 'Niemożliwe wydatki w stosunku do odwiedzin');
    END IF;

    OPEN c_osoba;
    FETCH c_osoba INTO v_osoba_id;
    IF c_osoba%FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Osoba o podanym imieniu i nazwisku już istnieje');
    END IF;
    CLOSE c_osoba;

    SELECT Osoba_SEQ.NEXTVAL INTO noweID FROM DUAL;

    INSERT INTO Osoba (ID, Imie, Nazwisko)
    VALUES (noweID, imie, nazwisko);

    INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu)
    VALUES (noweID, srednieWydatki, iloscOdwiedzin);
END RejestrujNowegoKlienta;


--Dodaje produkt ze sprawdzeniem, czy nie znajduje sie juz w bazie
CREATE OR REPLACE TRIGGER SprawdzCzyProduktIstnieje
BEFORE INSERT ON Produkty
FOR EACH ROW
DECLARE
    ProduktIstnieje INT;
BEGIN
    SELECT COUNT(*)
    INTO ProduktIstnieje
    FROM Produkty
    WHERE Kod_produktu = :NEW.Kod_produktu;

    IF ProduktIstnieje > 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Produkt o podanym kodzie już istnieje');
    END IF;
END SprawdzCzyProduktIstnieje;

--Sprawdza, czy numer telefonu pracownika jest prawidłowy przed dodaniem go do bazy danych
CREATE OR REPLACE TRIGGER SprawdzNumerTelefonu
BEFORE INSERT ON Pracownicy
FOR EACH ROW
BEGIN
    IF LENGTH(:new.Numer_telefonu) != 9 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Numer telefonu musi mieć 9 cyfr');
    END IF;
END SprawdzNumerTelefonu;


