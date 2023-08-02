/// <summary>
/// PageExtension Accountant Role Center Ext (ID 92962) extends Record Accountant Role Center.
/// </summary>
pageextension 92962 "Accountant Role Center Ext" extends "Accountant Role Center"
{
    actions
    {
        addlast(sections)
        {
            group("Fyorin Integration")
            {
                action("Fyorin API Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Fyorin Setup";
                }
                action("Fyorin Sub Accounts")
                {
                    ApplicationArea = All;
                    RunObject = page "Sub Account on Fyorin";
                    Visible = false;
                }
                action("Fyorin Payment History")
                {
                    ApplicationArea = All;
                    RunObject = page "Fyorin Paymenty History";
                }
            }
        }
    }
}