codeunit 50153 "DUOM Conversion Calc Test"
{
    Subtype = Test;

    var
        LibraryAssert: Codeunit "Library Assert";
        DUOMTestLibrary: Codeunit "DUOM Test Library";

    // Tests for DUOM quantity conversion implemented in "DUOM Conversion Facade"
    // and "DUOM Conversion Handler".
    //
    // Business rules under test:
    //   - KG → PCS: Qty PCS = Qty KG / Factor
    //   - PCS → KG: Qty KG = Qty PCS * Factor
    //   - Factor = 0          → error
    //   - Negative quantity   → error
    //   - DUOM disabled       → error

    [Test]
    procedure GivenValidKGQty_WhenConvertToPCS_ThenCorrectResult()
    var
        Item: Record Item;
        DUOMConversionFacade: Codeunit "DUOM Conversion Facade";
        Result: Decimal;
    begin
        // Arrange
        Initialize();
        DUOMTestLibrary.CreateDUOMItemFixed(Item, 'KG', 2.5);

        // Act
        Result := DUOMConversionFacade.ConvertKGToPCS(Item, 10, 2.5);

        // Assert – 10 KG / 2.5 = 4 PCS
        LibraryAssert.AreEqual(4, Result, 'Expected 10 KG / 2.5 = 4 PCS.');
    end;

    [Test]
    procedure GivenValidPCSQty_WhenConvertToKG_ThenCorrectResult()
    var
        Item: Record Item;
        DUOMConversionFacade: Codeunit "DUOM Conversion Facade";
        Result: Decimal;
    begin
        // Arrange
        Initialize();
        DUOMTestLibrary.CreateDUOMItemFixed(Item, 'KG', 2.5);

        // Act
        Result := DUOMConversionFacade.ConvertPCSToKG(Item, 4, 2.5);

        // Assert – 4 PCS * 2.5 = 10 KG
        LibraryAssert.AreEqual(10, Result, 'Expected 4 PCS * 2.5 = 10 KG.');
    end;

    [Test]
    procedure GivenZeroFactor_WhenConvert_ThenError()
    var
        Item: Record Item;
        DUOMConversionFacade: Codeunit "DUOM Conversion Facade";
    begin
        // Arrange
        Initialize();
        DUOMTestLibrary.CreateDUOMItemFixed(Item, 'KG', 0);

        // Act + Assert – error expected
        asserterror DUOMConversionFacade.ConvertKGToPCS(Item, 10, 0);
        LibraryAssert.IsTrue(
            GetLastErrorText().Contains('Conversion factor cannot be zero.'),
            'Expected error about zero conversion factor.');
    end;

    [Test]
    procedure GivenNegativeQty_WhenConvert_ThenError()
    var
        Item: Record Item;
        DUOMConversionFacade: Codeunit "DUOM Conversion Facade";
    begin
        // Arrange
        Initialize();
        DUOMTestLibrary.CreateDUOMItemFixed(Item, 'KG', 2.5);

        // Act + Assert – error expected
        asserterror DUOMConversionFacade.ConvertKGToPCS(Item, -5, 2.5);
        LibraryAssert.IsTrue(
            GetLastErrorText().Contains('Quantity cannot be negative.'),
            'Expected error about negative quantity.');
    end;

    [Test]
    procedure GivenDUOMDisabled_WhenConvert_ThenError()
    var
        Item: Record Item;
        DUOMConversionFacade: Codeunit "DUOM Conversion Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := false;

        // Act + Assert – error expected
        asserterror DUOMConversionFacade.ConvertKGToPCS(Item, 10, 2.5);
        LibraryAssert.IsTrue(
            GetLastErrorText().Contains('DUOM is not enabled for this item.'),
            'Expected error about DUOM being disabled.');
    end;

    local procedure Initialize()
    begin
    end;
}
