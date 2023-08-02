/// <summary>
/// PageExtension Bank Account card ext (ID 92951) extends Record Bank Account Card.
/// </summary>
pageextension 92951 "Bank Account card ext" extends "Bank Account Card"
{
    actions
    {
        addafter(Statements)
        {
            action(createacct)
            {
                Caption = 'Create Sub Account on fyorin';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    FyorinInt: Codeunit "Fyorin Integration";
                    FyorinSetup: Record "Fyorin Setup";
                begin
                    FyorinSetup.Get();
                    FyorinInt.CreateSubAccount(FyorinSetup."Main ID", Rec.Name, Rec."Currency Code");
                end;
            }
            action(activateCurrency)
            {
                Caption = 'Activate Currency';
                ApplicationArea = All;
                Image = Currencies;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    apiIntegration: Codeunit "Fyorin Integration";
                    genledgerSetup: Record "General Ledger Setup";
                    currencydialog: Page "Currency dialog";
                    currCode: Code[20];
                    SubAcct: Code[20];
                begin
                    genledgerSetup.get();
                    // if Confirm('Activate Currency Code?', false) = false then
                    //     exit;
                    // if currencydialog.RunModal() = Action::OK then
                    //     currCode := currencydialog.GetCurrCode();
                    // SubAcct := currencydialog.GetsubAcct();
                    IF Rec."Currency Code" = '' then begin
                        if Confirm('Currency Code is blank, Currency Code %1 from General ledger Setup will be used, proceed?', false, genledgerSetup."LCY Code") = false then
                            exit;
                        apiIntegration.ActivateCurrency(genledgerSetup."LCY Code", Rec."No.");
                    end
                    else
                        if Rec."Currency Code" <> '' then
                            apiIntegration.ActivateCurrency(Rec."Currency Code", Rec."No.");
                end;

            }
        }
    }
}
