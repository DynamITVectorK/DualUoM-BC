codeunit 50002 "DUOM Conversion Handler"
{
    Access = Internal;

    var
        DUOMNotEnabledErr: Label 'DUOM is not enabled for this item.';
        ZeroFactorErr: Label 'Conversion factor cannot be zero.';
        NegativeQtyErr: Label 'Quantity cannot be negative.';

    /// <summary>
    /// Converts a quantity expressed in KG to PCS using the given conversion factor.
    /// Formula: PCS = KG / Factor.
    /// Raises an error if DUOM is not enabled, the quantity is negative, or the factor is zero.
    /// </summary>
    procedure ConvertKGToPCS(Item: Record Item; KGQuantity: Decimal; ConversionFactor: Decimal): Decimal
    begin
        ValidateConversionInput(Item, KGQuantity, ConversionFactor);
        exit(KGQuantity / ConversionFactor);
    end;

    /// <summary>
    /// Converts a quantity expressed in PCS to KG using the given conversion factor.
    /// Formula: KG = PCS * Factor.
    /// Raises an error if DUOM is not enabled, the quantity is negative, or the factor is zero.
    /// </summary>
    procedure ConvertPCSToKG(Item: Record Item; PCSQuantity: Decimal; ConversionFactor: Decimal): Decimal
    begin
        ValidateConversionInput(Item, PCSQuantity, ConversionFactor);
        exit(PCSQuantity * ConversionFactor);
    end;

    local procedure ValidateConversionInput(Item: Record Item; Quantity: Decimal; ConversionFactor: Decimal)
    begin
        if not Item."DUOM Enabled" then
            Error(DUOMNotEnabledErr);

        if Quantity < 0 then
            Error(NegativeQtyErr);

        if ConversionFactor = 0 then
            Error(ZeroFactorErr);
    end;
}
