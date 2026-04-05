codeunit 50000 "DUOM Item Setup Facade"
{
    /// <summary>
    /// Public facade for DUOM item setup operations.
    /// Serves as the single public interface consumed by table/page extensions and other
    /// modules. Delegates business logic to "DUOM Item Setup Handler".
    /// </summary>

    /// <summary>
    /// Validates that the DUOM setup on the given Item record is consistent and complete.
    /// Raises an error if required fields are missing or invalid.
    /// </summary>
    procedure ValidateItemSetup(Item: Record Item)
    var
        DUOMItemSetupHandler: Codeunit "DUOM Item Setup Handler";
    begin
        DUOMItemSetupHandler.ValidateItemSetup(Item);
    end;
}
