tableextension 50000 "DUOM Item Ext" extends Item
{
    fields
    {
        field(50000; "DUOM Enabled"; Boolean)
        {
            Caption = 'DUOM Enabled';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
            begin
                DUOMItemSetupFacade.ValidateItemSetup(Rec);
            end;
        }
        field(50001; "DUOM Secondary Unit of Measure Code"; Code[10])
        {
            Caption = 'DUOM Secondary Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
            begin
                DUOMItemSetupFacade.ValidateItemSetup(Rec);
            end;
        }
        field(50002; "DUOM Conversion Type"; Enum "DUOM Conversion Type")
        {
            Caption = 'DUOM Conversion Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
            begin
                DUOMItemSetupFacade.ValidateItemSetup(Rec);
            end;
        }
        field(50003; "DUOM Fixed Ratio"; Decimal)
        {
            Caption = 'DUOM Fixed Ratio';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
            begin
                DUOMItemSetupFacade.ValidateItemSetup(Rec);
            end;
        }
    }
}
