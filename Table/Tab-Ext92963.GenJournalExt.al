/// <summary>
/// TableExtension Gen Journal Ext (ID 92963) extends Record Gen. Journal Line.
/// </summary>
tableextension 92963 "Gen Journal Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(92950; "Ban Id"; Text[250])
        {
            Caption = 'Ban Id';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Account on Fyorin";
        }
    }
}
