codeunit 50151 "DUOM Foundation Test"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;

    // Initial test codeunit for the DualUoM extension.
    // Verifies that the test app compiles and the test runner can execute procedures.
    //
    // Future test codeunits added issue-by-issue:
    //   - DUOM Item Setup Test            (item dual-UoM configuration and validation)
    //   - DUOM Conversion Calculator Test  (conversion factor computation)
    //   - DUOM Sales Line Test             (sales document dual-quantity handling)
    //   - DUOM Purchase Line Test          (purchase document dual-quantity handling)
    //   - DUOM Item Ledger Entry Test      (posting and ledger entry dual fields)

    [Test]
    procedure GivenTestApp_WhenLoaded_ThenInfrastructureIsReady()
    begin
        // This test verifies that the DualUoM test app is compiled and runnable.
        // Successful execution confirms the test infrastructure is in place for TDD work.
        Initialize();
    end;

    local procedure Initialize()
    begin
    end;
}
