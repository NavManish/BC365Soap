table 50104 OrderHistory
{
    DataClassification = CustomerContent;
    Caption = 'Moulton Order History';

    fields
    {
        field(1; "Moulton Order No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Moulton Order No.';
        }
        field(2; "WS Status"; code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'WS Status';
        }
        field(3; "WS Message"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'WS Message';
        }
        field(4; "File Extension"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'File Extension';
        }
        field(5; "Order Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Date';
        }
        field(6; "Ship Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ship Date';
        }
        field(7; "SOAP Request"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'SOAP Request';
        }
        field(8; "SOAP Response"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'SOAP Response';
        }
        field(9; "SOAP Response DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'SOAP Response DateTime';
        }
        field(10; "SOAP Request DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'SOAP Request DateTime';
        }
        field(11; "Order Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Status';
            OptionMembers = "",Open,Shipped,Cancelled;
            OptionCaption = ' ,Open,Shipped,Cancelled';
        }
        field(12; "SOAP Response without NS"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'SOAP Response without NS';
        }
        field(13; "Carrier Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Carrier Code';
        }
        field(14; "Service Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Code';
        }
        field(15; "Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Code';
        }
    }

    keys
    {
        key(PK; "Moulton Order No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    procedure ViewResponse()
    var
        FileTxt: Text;
        NVInStream: InStream;
    begin
        CALCFIELDS("SOAP Response");
        IF NOT "SOAP Response".HASVALUE() THEN
            EXIT;

        //if UploadIntoStream('Select XML file', '', 'XML files (*.XML)|*.XML|All files (*.*)|*.*', FileTxt, NVInStream) then begin
        FileTxt := "Moulton Order No." + ' Response.xml';
        Clear(NVInStream);
        "SOAP Response".CREATEINSTREAM(NVInStream);
        DOWNLOADFROMSTREAM(NVInStream, '', '', 'XML files (*.XML)|*.XML|All files (*.*)|*.*', FileTxt);
        //end;
    end;

    procedure ViewResponseNoNS()
    var
        FileTxt: Text;
        NVInStream: InStream;
    begin
        CALCFIELDS("SOAP Response without NS");
        IF NOT "SOAP Response without NS".HASVALUE() THEN
            EXIT;

        //if UploadIntoStream('Select XML file', '', 'XML files (*.XML)|*.XML|All files (*.*)|*.*', FileTxt, NVInStream) then begin
        FileTxt := "Moulton Order No." + ' NONSResponse.xml';
        Clear(NVInStream);
        "SOAP Response without NS".CREATEINSTREAM(NVInStream);
        DOWNLOADFROMSTREAM(NVInStream, '', '', 'XML files (*.XML)|*.XML|All files (*.*)|*.*', FileTxt);
        //end;
    end;

    procedure ViewRequest()
    var
        FileTxt: Text;
        NVInStream: InStream;
    begin
        CALCFIELDS("SOAP Request");
        IF NOT "SOAP Request".HASVALUE() THEN
            EXIT;

        //if UploadIntoStream('Select XML file', '', 'XML files (*.XML)|*.XML|All files (*.*)|*.*', FileTxt, NVInStream) then begin
        FileTxt := "Moulton Order No." + ' Request.xml';
        Clear(NVInStream);
        "SOAP Request".CREATEINSTREAM(NVInStream);
        DOWNLOADFROMSTREAM(NVInStream, '', '', 'XML files (*.XML)|*.XML|All files (*.*)|*.*', FileTxt);
        //end;
    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}