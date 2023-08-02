/// <summary>
/// Page Fyorin Setup (ID 92960).
/// </summary>
page 92960 "Fyorin Setup"
{
    Caption = 'Fyorin Setup';
    PageType = Card;
    SourceTable = "Fyorin Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(URL; Rec.URL)
                {
                    ToolTip = 'Specifies the value of the Url field.';
                    ApplicationArea = All;
                }
                field(accessor_owner_email; Rec.accessor_owner_email)
                {
                    ToolTip = 'Specifies the value of the accessor_owner_email field.';
                    ApplicationArea = All;
                }
                field(accessor_owner_password; Rec.accessor_owner_password)
                {
                    ToolTip = 'Specifies the value of the accessor_owner_password field.';
                    ApplicationArea = All;
                }
                field(accessor_api_key_email; Rec.accessor_api_key_email)
                {
                    ToolTip = 'Specifies the value of the accessor_api_key_email field.';
                    ApplicationArea = All;
                }
                field(accessor_api_key_password; Rec.accessor_api_key_password)
                {
                    ToolTip = 'Specifies the value of the accessor_api_key_password field.';
                    ApplicationArea = All;
                }
                field("Api Token"; Rec."Api Token")
                {
                    ToolTip = 'Specifies the value of the Api Token field.';
                    ApplicationArea = All;
                }
                field("Main ID"; Rec."Main ID")
                {
                    ToolTip = 'Specifies the Main account Id';
                    ApplicationArea = All;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(RequestLogin)
            {
                Caption = 'Request Login';
                Image = LaunchWeb;
                ApplicationArea = All;
                Promoted = true;
                Visible = false;
                PromotedIsBig = true;
                RunObject = codeunit "Fyorin Integration";
                //trigger onaction()
                //var
                //apiint: codeunit "Fyorin Integration";

                // begin

                // apiint.HttpRequest();

                //end;
            }
            action(GetMainId)
            {
                Caption = 'Get Main Id';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    FyorinInt: Codeunit "Fyorin Integration";
                begin
                    Rec."Main ID" := FyorinInt.GetMainID();
                    Rec.Modify();
                end;

            }
            /*action(CreateAccount)
            {
                Caption = 'Create Account';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Create;
                trigger OnAction()
                var
                    FyorinInt: Codeunit "Fyorin Integration";
                begin
                    FyorinInt.CreateSubAccount(Rec."Main ID");
                end;
            } */
            action(getContact)
            {
                Caption = 'Get Vendors';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = GetLines;
                Visible = false;
                trigger OnAction()
                var
                    FyorinInt: Codeunit "Fyorin Integration";
                begin
                    FyorinInt.GetContacts();
                end;
            }
            action(RequiredDetails)
            {
                Caption = 'Get Vendor Requirements';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = GetEntries;
                Visible = false;
                trigger OnAction()
                var
                    FyorinInt: Codeunit "Fyorin Integration";
                begin
                    FyorinInt.GetRequiredDetails();
                end;
            }
            action(activateCurrency)
            {
                Caption = 'Activate Currency';
                ApplicationArea = All;
                Image = Currencies;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    apiIntegration: Codeunit "Fyorin Integration";
                    currencydialog: Page "Currency dialog";
                    currCode: Code[20];
                    SubAcct: Code[20];
                begin
                    if Confirm('Activate Currency Code?', false) = false then
                        exit;
                    if currencydialog.RunModal() = Action::OK then
                        currCode := currencydialog.GetCurrCode();
                    SubAcct := currencydialog.GetsubAcct();
                    apiIntegration.ActivateCurrency(currCode, SubAcct);

                end;

            }
        }

    }
}
