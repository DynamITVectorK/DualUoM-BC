codeunit 50100 "DUOM Test Library"
{
    /// <summary>
    /// Shared helper codeunit for all DUOM test codeunits.
    /// Provides factory procedures that create pre-populated in-memory Item record
    /// variables so individual test codeunits can focus on the scenario under test.
    /// </summary>

    /// <summary>
    /// Initialises an Item record variable with a valid DUOM setup using a Fixed
    /// conversion type.  The record is NOT inserted into the database.
    /// </summary>
    procedure CreateDUOMItemFixed(var Item: Record Item; SecondaryUoMCode: Code[10]; FixedRatio: Decimal)
    begin
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := SecondaryUoMCode;
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Fixed;
        Item."DUOM Fixed Ratio" := FixedRatio;
    end;

    /// <summary>
    /// Initialises an Item record variable with a valid DUOM setup using a Variable
    /// conversion type.  The record is NOT inserted into the database.
    /// </summary>
    procedure CreateDUOMItemVariable(var Item: Record Item; SecondaryUoMCode: Code[10])
    begin
        Item.Init();
        Item."DUOM Enabled" := true;
        Item."DUOM Secondary UoM Code" := SecondaryUoMCode;
        Item."DUOM Conversion Type" := "DUOM Conversion Type"::Variable;
    end;
}
