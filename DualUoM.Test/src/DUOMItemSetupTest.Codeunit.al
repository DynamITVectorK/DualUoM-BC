codeunit 50102 "DUOM Item Setup Test"
{
    Subtype = Test;

    /// <summary>
    /// Tests for DUOM item setup validation rules implemented in "DUOM Setup Management".
    ///
    /// Rules under test:
    ///   - DUOM disabled  → no validation required
    ///   - DUOM enabled   → Secondary UoM Code is required
    ///   - Conversion Type = Fixed → Fixed Ratio must be greater than zero
    ///   - Conversion Type = Variable or Always Variable → Fixed Ratio is not required
    /// </summary>

    [Test]
    procedure TestValidSetup_DUOMDisabled()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM disabled; other fields empty
        Item.Init();
        Item."DUOM Enabled" := false;

        // Act + Assert – no error expected
        DUOMSetupMgt.ValidateItemSetup(Item);
    end;

    [Test]
    procedure TestValidSetup_FixedConversionType()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM enabled, secondary UoM set, Fixed type with positive ratio
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary Unit of Measure Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := 2.5;

        // Act + Assert – no error expected
        DUOMSetupMgt.ValidateItemSetup(Item);
    end;

    [Test]
    procedure TestValidSetup_VariableConversionType()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM enabled, secondary UoM set, Variable type (no ratio required)
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary Unit of Measure Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Variable;
        Item."DUOM Fixed Ratio" := 0;

        // Act + Assert – no error expected
        DUOMSetupMgt.ValidateItemSetup(Item);
    end;

    [Test]
    procedure TestValidSetup_AlwaysVariableConversionType()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM enabled, secondary UoM set, Always Variable type (no ratio required)
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary Unit of Measure Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::"Always Variable";
        Item."DUOM Fixed Ratio" := 0;

        // Act + Assert – no error expected
        DUOMSetupMgt.ValidateItemSetup(Item);
    end;

    [Test]
    procedure TestInvalidSetup_EnabledWithoutSecondaryUoM()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM enabled but secondary UoM code is missing
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary Unit of Measure Code" := '';

        // Act + Assert – error expected
        asserterror DUOMSetupMgt.ValidateItemSetup(Item);
    end;

    [Test]
    procedure TestInvalidSetup_FixedType_ZeroRatio()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM enabled, Fixed type, ratio = 0
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary Unit of Measure Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := 0;

        // Act + Assert – error expected
        asserterror DUOMSetupMgt.ValidateItemSetup(Item);
    end;

    [Test]
    procedure TestInvalidSetup_FixedType_NegativeRatio()
    var
        Item: Record Item;
        DUOMSetupMgt: Codeunit "DUOM Setup Management";
    begin
        // Arrange – DUOM enabled, Fixed type, negative ratio
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary Unit of Measure Code" := 'KG';
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := -1;

        // Act + Assert – error expected
        asserterror DUOMSetupMgt.ValidateItemSetup(Item);
    end;
}
