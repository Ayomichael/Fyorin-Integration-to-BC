/// <summary>
/// Page Fyorin Paymenty History (ID 92961).
/// </summary>
page 92961 "Fyorin Paymenty History"
{
    ApplicationArea = All;
    Caption = 'Fyorin Paymenty History';
    PageType = List;
    SourceTable = "Fyorin Payment History";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Payment Id"; Rec."Payment Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Id field.';
                }
                field("Beneficiary Id"; Rec."Beneficiary Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Beneficiary Id field.';
                }
                field("Ban Id"; Rec."Ban Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ban Id field.';
                }

                field("Contact Reference"; Rec."Beneficiary Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference field.';
                }

                field(reference; Rec.reference)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the reference field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Approval Expiry Time"; Rec."Approval Expiry Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Expiry Time field.';
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency field.';
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purpose Code field.';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                    Visible = false;
                }
                field("last update Timestamp"; Rec."last update Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the last update Timestamp field.';
                }
                field("process Time"; Rec."process Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the process Time field.';
                }
                field("Document No Reference"; Rec."Document No Reference")
                {
                    ApplicationArea = All;

                }
                field("Cancel Reason"; Rec."Cancel Reason")
                {
                    ApplicationArea = All;

                }
                field("Reject Reason"; Rec."Reject Reason")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GetPaymenthistory)
            {
                Caption = 'Update Payment History';
                ApplicationArea = All;
                image = PaymentHistory;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                begin
                    ApiInt.GetPaymentHistory();
                end;
            }
            action(approve)
            {
                Caption = 'Approve Payment';
                ApplicationArea = All;
                image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                begin
                    if Confirm('Approve this Payment?', false) = false then
                        exit;
                    ApiInt.ApprovePayment(Rec."Payment Id");
                end;


            }
            action(reject)
            {
                Caption = 'Reject Payment';
                ApplicationArea = All;
                image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                    Reason: text;
                    ReasonPage: Page "Reason Dialog";
                begin
                    if Dialog.Confirm('Reject Payment?', false) = false then
                        exit;
                    if ReasonPage.RunModal() = Action::OK then
                        Reason := ReasonPage.getReason();
                    ApiInt.RejectPayments(Rec."Payment Id", Reason);
                    //Message('%1', Reason);
                end;
            }
            action(Cancel)
            {
                Caption = 'Cancel Payment';
                ApplicationArea = All;
                image = Cancel;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                    ReasonPage: Page "Reason Dialog";
                    Reason: text;
                begin
                    if Confirm('Cancel Payment?', false) = false then
                        exit;
                    if ReasonPage.RunModal() = Action::OK then
                        Reason := ReasonPage.getReason();
                    ApiInt.RejectPayments(Rec."Payment Id", Reason);

                end;
            }
        }
    }

}
