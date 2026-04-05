pageextension 50000 "DUOM Item Card Ext" extends "Item Card"
{
    layout
    {
        addlast(content)
        {
            group(DUOMSetup)
            {
                Caption = 'Dual Unit of Measure';

                field("DUOM Enabled"; Rec."DUOM Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether dual unit of measure tracking is enabled for this item.';
                }
                field("DUOM Secondary Unit of Measure Code"; Rec."DUOM Secondary Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Enabled = Rec."DUOM Enabled";
                    ToolTip = 'Specifies the secondary unit of measure used to track this item in parallel with the base unit.';
                }
                field("DUOM Conversion Type"; Rec."DUOM Conversion Type")
                {
                    ApplicationArea = All;
                    Enabled = Rec."DUOM Enabled";
                    ToolTip = 'Specifies how the conversion factor between primary and secondary unit of measure is determined.';
                }
                field("DUOM Fixed Ratio"; Rec."DUOM Fixed Ratio")
                {
                    ApplicationArea = All;
                    Enabled = Rec."DUOM Enabled" and (Rec."DUOM Conversion Type" = "DUOM Conversion Type"::Fixed);
                    ToolTip = 'Specifies the fixed conversion ratio from the primary to the secondary unit of measure.';
                }
            }
        }
    }
}
