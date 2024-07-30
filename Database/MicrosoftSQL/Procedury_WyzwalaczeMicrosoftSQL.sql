IF OBJECT_ID('dbo.SprawdzCenePrzedDodaniem', 'TR') IS NOT NULL
    DROP TRIGGER SprawdzCenePrzedDodaniem;
GO

IF OBJECT_ID('dbo.LogujZmianePensji', 'TR') IS NOT NULL
    DROP TRIGGER LogujZmianePensji;
GO

IF OBJECT_ID('dbo.DodajKlienta', 'P') IS NOT NULL
    DROP PROCEDURE DodajKlienta;
GO

IF OBJECT_ID('dbo.ZmienPensje', 'P') IS NOT NULL
    DROP PROCEDURE ZmienPensje;
GO

--Dodanie nowego klienta
CREATE PROCEDURE DodajKlienta
@Imie NVARCHAR(20),
@Nazwisko NVARCHAR(20),
@SrednieWydatki MONEY,
@IloscOdwiedzin INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Osoba WHERE Imie = @Imie AND Nazwisko = @Nazwisko)
        BEGIN
            RAISERROR ('Klient o podanym imieniu i nazwisku już istnieje', 16, 1);
        END;

        DECLARE @OsobaID INT;
        SELECT @OsobaID = COALESCE(MAX(ID), 0) + 1 FROM Osoba;

        INSERT INTO Osoba (ID, Imie, Nazwisko)
        VALUES (@OsobaID, @Imie, @Nazwisko);

        INSERT INTO Klienci (Osoba_ID, Srednie_wydatki, Ilosc_odwiedzin_w_tygodniu)
        VALUES (@OsobaID, @SrednieWydatki, @IloscOdwiedzin);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR ('Wystąpił błąd podczas dodawania klienta', 16, 1);
    END CATCH
END;


-- Aktualizacja pensji pracownika
CREATE PROCEDURE ZmienPensje
@PracownikID INT,
@NowaPensja INT
AS
BEGIN
    DECLARE curPracownik CURSOR FOR
        SELECT Osoba_ID FROM Pracownicy WHERE Osoba_ID = @PracownikID;

    OPEN curPracownik;

    DECLARE @AktualneID INT;

    FETCH NEXT FROM curPracownik INTO @AktualneID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Pracownicy SET Pensja = @NowaPensja WHERE Osoba_ID = @AktualneID;

        FETCH NEXT FROM curPracownik INTO @AktualneID;
    END

    CLOSE curPracownik;
    DEALLOCATE curPracownik;

    IF @@FETCH_STATUS <> 0
    BEGIN
        PRINT 'Nie ma pracownika o podanym ID';
    END
END;
GO


-- Sprawdzenie ceny produktu przed dodaniem, jesli jest ujemna, pokaz blad
CREATE TRIGGER SprawdzCenePrzedDodaniem ON Produkty
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Cena <= 0)
    BEGIN
        RAISERROR ('Cena produktu musi być większa od 0', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--Logowanie zmian w tabeli Pracownicy
CREATE TRIGGER LogujZmianePensji ON Pracownicy
FOR UPDATE
AS
BEGIN
    INSERT INTO ZmianyPensjiLog (PracownikID, StaraPensja, NowaPensja, DataZmiany)
    SELECT i.Osoba_ID, d.Pensja, i.Pensja, GETDATE()
    FROM inserted i
    JOIN deleted d ON i.Osoba_ID = d.Osoba_ID
    WHERE i.Pensja != d.Pensja;
END;
