/// <summary>
/// PageExtension Vendor Extension (ID 92953) extends Record Vendor Card.
/// </summary>
pageextension 92953 "Vendor Card Ext" extends "Vendor Card"
{
    actions
    {
        addafter("Create Payments")
        {
            action(createContact)
            {
                Caption = 'create Vendor on Fyorin';
                ApplicationArea = All;
                image = CreateXMLFile;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                begin
                    ApiInt.CreatContact_Vendor(Rec."No.");
                end;
            }
            /* action(createPayments)
             {
                 Caption = 'create Payment';
                 ApplicationArea = All;
                 image = Payment;
                 Promoted = true;
                 PromotedIsBig = true;
                 trigger OnAction()
                 var
                     ApiInt: Codeunit "Fyorin Integration";
                 begin
                     ApiInt.CreatePayment(Rec."No.");

                 end;
             } */

        }
    }
}
