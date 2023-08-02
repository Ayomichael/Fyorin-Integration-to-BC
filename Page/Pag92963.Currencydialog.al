/// <summary>
/// Page Currency dialog (ID 92963).
/// </summary>
page 92963 "Currency dialog"
{
    Caption = 'Currency dialog';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(general)
            {
                field(SubAcct; SubAcct)
                {
                    Caption = 'Bank Account';
                    ApplicationArea = All;
                    TableRelation = "Bank Account"."No.";
                }
                field(CurrencyCode; CurrencyCode)
                {
                    Caption = 'Currency code';
                    TableRelation = Currency.Code;
                    ApplicationArea = All;
                }
            }
        }
    }
    /// <summary>
    /// GetCurrCode.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetCurrCode(): Code[20]
    begin
        exit(CurrencyCode)
    end;

    /// <summary>
    /// GetsubAcct.
    /// </summary>
    /// <returns>Return value of type code[20].</returns>
    procedure GetsubAcct(): code[20]
    begin
        exit(SubAcct)
    end;

    var
        CurrencyCode: Code[20];
        SubAcct: code[20];
}
