page 50100 "Soap Test Page"
{
    PageType = Card;
    Caption = 'Soap Test Page';
    actions
    {
        area(processing)
        {
            action("Create Soap Message")
            {
                Caption = 'Create Soap Message';
                ApplicationArea = All;
                Image = XMLFile;
                trigger OnAction()
                var
                    WebSrv: Codeunit WebSrv;
                begin
                    
                    WebSrv.CreateSoapMessage();
                end;
            }
        }
    }
}