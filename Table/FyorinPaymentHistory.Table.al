/// <summary>
/// Table Fyorin Payment History (ID 92961).
/// </summary>
table 92961 "Fyorin Payment History"
{
    Caption = 'Fyorin Payment History';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payment Id"; text[250])
        {
            Caption = 'Payment Id';
            DataClassification = ToBeClassified;
        }
        field(2; "process Time"; DateTime)
        {
            Caption = 'process Time';
            DataClassification = ToBeClassified;
        }
        field(3; "Approval Expiry Time"; DateTime)
        {
            Caption = 'Approval Expiry Time';
            DataClassification = ToBeClassified;
        }
        field(4; "Beneficiary Id"; Text[250])
        {
            Caption = 'Beneficiary Id';
            DataClassification = ToBeClassified;
        }
        field(5; "Ban Id"; text[250])
        {
            Caption = 'Ban Id';
            DataClassification = ToBeClassified;
        }
        field(6; Currency; Code[20])
        {
            Caption = 'Currency';
            DataClassification = ToBeClassified;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(8; reference; Text[250])
        {
            Caption = 'reference';
            DataClassification = ToBeClassified;
        }
        field(9; "Purpose Code"; Text[250])
        {
            Caption = 'Purpose Code';
            DataClassification = ToBeClassified;
        }
        field(10; State; Text[250])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(11; "Contact Id"; Text[250])
        {
            Caption = 'Contact Id';
            DataClassification = ToBeClassified;
        }
        field(12; "Type"; Integer)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(13; "Beneficiary Type"; Text[250])
        {
            Caption = 'Beneficiary Type';
            DataClassification = ToBeClassified;
        }
        field(14; "Beneficiary Sub Type"; Text[250])
        {
            Caption = 'Beneficiary Sub Type';
            DataClassification = ToBeClassified;
        }
        field(15; "Document No Reference"; Text[250])
        {
            Caption = 'Reference';
            DataClassification = ToBeClassified;
        }
        field(16; "last update Timestamp"; DateTime)
        {
            Caption = 'last update Timestamp';
            DataClassification = ToBeClassified;
        }
        field(17; "Cancel Reason"; text[250])
        {
            Caption = 'Cancel Reason';
        }
        field(18; "Reject Reason"; text[250])
        {
            Caption = 'Reject Reason';
        }
        field(19; "Beneficiary Reference"; Text[250])
        {
            Caption = 'Beneficiary Reference';
        }
        field(20; Status; text[250])
        {
            Caption = 'Status';

        }
    }
    keys
    {
        key(PK; "Payment Id")
        {
            Clustered = true;
        }
    }
}
