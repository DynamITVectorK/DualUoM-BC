codeunit 50003 "DUOM Conversion Facade"
{
    /// <summary>
    /// Public facade for DUOM quantity conversion operations.
    /// Serves as the single public interface consumed by other modules.
    /// Delegates business logic to "DUOM Conversion Handler".
    /// </summary>

    /// <summary>
    /// Converts a quantity expressed in KG to PCS using the given conversion factor.
    /// Raises an error if DUOM is not enabled on the item, the quantity is negative,
    /// or the conversion factor is zero.
    /// </summary>
    procedure ConvertKGToPCS(Item: Record Item; KGQuantity: Decimal; ConversionFactor: Decimal): Decimal
    var
        DUOMConversionHandler: Codeunit "DUOM Conversion Handler";
    begin
        exit(DUOMConversionHandler.ConvertKGToPCS(Item, KGQuantity, ConversionFactor));
    end;

    /// <summary>
    /// Converts a quantity expressed in PCS to KG using the given conversion factor.
    /// Raises an error if DUOM is not enabled on the item, the quantity is negative,
    /// or the conversion factor is zero.
    /// </summary>
    procedure ConvertPCSToKG(Item: Record Item; PCSQuantity: Decimal; ConversionFactor: Decimal): Decimal
    var
        DUOMConversionHandler: Codeunit "DUOM Conversion Handler";
    begin
        exit(DUOMConversionHandler.ConvertPCSToKG(Item, PCSQuantity, ConversionFactor));
    end;
}
