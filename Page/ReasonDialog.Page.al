/// <summary>
/// Page Reason Dialog (ID 92951).
/// </summary>
page 92962 "Reason Dialog"
{
    Caption = 'Reason Dialog';
    PageType = StandardDialog;



    layout
    {
        area(content)
        {
            group(general)
            {
                field(Reason; Reason)
                {
                    Caption = 'Reason';
                    ApplicationArea = All;
                }
            }
        }
    }
    /// <summary>
    /// getReason.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure getReason(): Text
    begin
        exit(Reason)
    end;

    var
        Reason: text;
}
