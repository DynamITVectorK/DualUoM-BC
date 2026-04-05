codeunit 50001 "DUOM Item Setup Handler"
{
    Access = Internal;

    /// <summary>
    /// Validates that the DUOM setup on the given Item record is consistent and complete.
    /// Raises an error if required fields are missing or invalid.
    /// </summary>
    procedure ValidateItemSetup(Item: Record Item)
    var
        SecondaryUoMRequiredErr: Label 'DUOM Secondary Unit of Measure Code is required when DUOM is enabled.';
        FixedRatioRequiredErr: Label 'DUOM Fixed Ratio must be greater than zero when Conversion Type is Fixed.';
    begin
        if not Item."DUOM Enabled" then
            exit;

        if Item."DUOM Secondary Unit of Measure Code" = '' then
            Error(SecondaryUoMRequiredErr);

        if Item."DUOM Conversion Type" = "DUOM Conversion Type"::Fixed then
            if Item."DUOM Fixed Ratio" <= 0 then
                Error(FixedRatioRequiredErr);
    end;
}
