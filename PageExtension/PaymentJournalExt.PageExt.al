/// <summary>
/// PageExtension Payment Journal Ext (ID 92961) extends Record Payment Journal.
/// </summary>
pageextension 92961 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addafter(Amount)
        {
            field("Ban Id"; Rec."Ban Id")
            {
                ApplicationArea = all;
                Caption = 'Ban Id on Sub Account';
            }
        }
    }

    actions
    {

        addafter(Reconcile)
        {

            action(CreatePayment)
            {
                Caption = 'create Payment On Fyorin';
                ApplicationArea = All;
                image = Payment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                begin
                    if Rec."Account Type" = Rec."Account Type"::Vendor then
                        ApiInt.CreatePayment(Rec."Account No.", Rec."Currency Code", Rec.Amount, Rec."Document No.");

                end;
            }

        }
    }
}
