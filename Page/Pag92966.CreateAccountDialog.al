/// <summary>
/// Page Create Account Dialog (ID 92966).
/// </summary>
page 92966 "Create Account Dialog"
{
    Caption = 'Create Account Dialog';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name; Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(CurrencyCode; CurrencyCode)
                {
                    Caption = 'Currency Code';
                    ApplicationArea = All;
                }
            }
        }
    }
    /// <summary>
    /// GetName.
    /// </summary>
    /// <returns>Return value of type text.</returns>
    procedure GetName(): text
    begin
        exit(Name);
    end;

    Procedure GetCode(): code[20]
    begin
        exit(CurrencyCode)
    end;

    var
        Name: text;
        CurrencyCode: Code[20];
}
