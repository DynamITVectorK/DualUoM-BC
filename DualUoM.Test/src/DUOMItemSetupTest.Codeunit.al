codeunit 50152 "DUOM Item Setup Test"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;

    // Tests for DUOM item setup validation rules implemented in "DUOM Item Setup Facade"
    // and "DUOM Item Setup Handler".
    //
    // Rules under test:
    //   - DUOM disabled  → no validation required
    //   - DUOM enabled   → Secondary UoM Code is required
    //   - Conversion Type = Fixed → Fixed Ratio must be greater than zero
    //   - Conversion Type = Variable or Always Variable → Fixed Ratio is not required

    [Test]
    procedure GivenDUOMDisabled_WhenValidateItemSetup_ThenNoErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := false;

        // Act + Assert – no error expected
        DUOMItemSetupFacade.ValidateItemSetup(Item);
    end;

    [Test]
    procedure GivenFixedConversionTypeWithPositiveRatio_WhenValidateItemSetup_ThenNoErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := 2.5;

        // Act + Assert – no error expected
        DUOMItemSetupFacade.ValidateItemSetup(Item);
    end;

    [Test]
    procedure GivenVariableConversionType_WhenValidateItemSetup_ThenNoErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Variable;
        Item."DUOM Fixed Ratio" := 0;

        // Act + Assert – no error expected
        DUOMItemSetupFacade.ValidateItemSetup(Item);
    end;

    [Test]
    procedure GivenAlwaysVariableConversionType_WhenValidateItemSetup_ThenNoErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::"Always Variable";
        Item."DUOM Fixed Ratio" := 0;

        // Act + Assert – no error expected
        DUOMItemSetupFacade.ValidateItemSetup(Item);
    end;

    [Test]
    procedure GivenDUOMEnabledWithoutSecondaryUoM_WhenValidateItemSetup_ThenErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := '';

        // Act + Assert – error expected
        asserterror DUOMItemSetupFacade.ValidateItemSetup(Item);
        Assert.IsTrue(
            GetLastErrorText().Contains('DUOM Secondary UoM Code is required when DUOM is enabled.'),
            'Expected error about missing secondary unit of measure.');
    end;

    [Test]
    procedure GivenFixedConversionTypeWithZeroRatio_WhenValidateItemSetup_ThenErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := 0;

        // Act + Assert – error expected
        asserterror DUOMItemSetupFacade.ValidateItemSetup(Item);
        Assert.IsTrue(
            GetLastErrorText().Contains('DUOM Fixed Ratio must be greater than zero when Conversion Type is Fixed.'),
            'Expected error about zero fixed ratio.');
    end;

    [Test]
    procedure GivenFixedConversionTypeWithNegativeRatio_WhenValidateItemSetup_ThenErrorIsRaised()
    var
        Item: Record Item;
        DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
    begin
        // Arrange
        Initialize();
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := -1;

        // Act + Assert – error expected
        asserterror DUOMItemSetupFacade.ValidateItemSetup(Item);
        Assert.IsTrue(
            GetLastErrorText().Contains('DUOM Fixed Ratio must be greater than zero when Conversion Type is Fixed.'),
            'Expected error about negative fixed ratio.');
    end;

    local procedure Initialize()
    begin
    end;
}
