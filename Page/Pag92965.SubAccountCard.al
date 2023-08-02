/// <summary>
/// Page Sub Account Card (ID 92965).
/// </summary>
page 92965 "Sub Account Card"
{
    Caption = 'Sub Account Card';
    PageType = Card;
    SourceTable = "Sub Account on Fyorin";
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Account; Rec.Account)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account field.';
                }
                field("Ban Id"; Rec."Ban Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ban Id field.';
                }
                field("Bank Holder Name"; Rec."Bank Holder Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Holder Name field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Main Id"; Rec."Main Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Main Id field.';
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Id field.';
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status of the Account';
                }
            }
            group(Balances)
            {
                field("Eur Available Balance"; Rec."Eur Available Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eur Available Balance field.';
                }
                field("Eur Credit Limit"; Rec."Eur Credit Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eur Credit Limit field.';
                }
                field("Eur Pending"; Rec."Eur Pending")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eur Pending field.';
                }
                field("Eur Reserved"; Rec."Eur Reserved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eur Reserved field.';
                }
                field("Eur Unreserved Limit"; Rec."Eur Unreserved Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Eur Unreserved Limit field.';
                }
                field("GBP Available Balance"; Rec."GBP Available Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GBP Available Balance field.';
                }
                field("GBP Credit Limit"; Rec."GBP Credit Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GBP Credit Limit field.';
                }
                field("GBP Pending"; Rec."GBP Pending")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GBP Pending field.';
                }
                field("GBP Reserved"; Rec."GBP Reserved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GBP Reserved field.';
                }
                field("GBP Unreserved Limit"; Rec."GBP Unreserved Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GBP Unreserved Limit field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(CreateSubaccount)
            {
                ApplicationArea = All;
                Caption = 'Create Sub Accounts from Fyorin';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                image = Accounts;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                    ApiSetup: Record "Fyorin Setup";
                    SubDialPage: page "Create Account Dialog";
                    Nametxt: text;
                    CurrCode: Code[20];
                begin
                    if Dialog.Confirm('Create Sub Account?', false) = false then
                        exit;
                    if SubDialPage.RunModal() = Action::OK then
                        Nametxt := SubDialPage.GetName();
                    CurrCode := SubDialPage.GetCode();
                    ApiInt.CreateSubAccount(ApiSetup."Main ID", Nametxt, CurrCode);
                end;
            }
        }
    }
}
