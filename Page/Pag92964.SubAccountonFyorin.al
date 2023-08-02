/// <summary>
/// Page Sub Account on Fyorin (ID 92964).
/// </summary>
page 92964 "Sub Account on Fyorin"
{
    ApplicationArea = All;
    Caption = 'Sub Account on Fyorin';
    PageType = List;
    SourceTable = "Sub Account on Fyorin";
    UsageCategory = Lists;
    CardPageId = "Sub Account Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Account; Rec.Account)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account field.';
                }
                field("Bank Holder Name"; Rec."Bank Holder Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Holder Name field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Main Id"; Rec."Main Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Main Id field.';
                }
                field("Ban Id"; Rec."Ban Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ban Id field.';
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Id field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(GetAcct)
            {
                ApplicationArea = All;
                Caption = 'Get Accounts from Fyorin';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                image = Accounts;
                trigger OnAction()
                var
                    ApiInt: Codeunit "Fyorin Integration";
                begin
                    ApiInt.GetSubaccount();
                end;
            }
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
