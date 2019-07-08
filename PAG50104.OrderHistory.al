page 50104 OrderHistory
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'OrderHistory List';
    SourceTable = OrderHistory;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Moulton Order No."; "Moulton Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Moulton Order No.';
                }
                field("WS Status"; "WS Status")
                {
                    ApplicationArea = All;
                    Caption = 'WS Status';
                }
                field("WS Message"; "WS Message")
                {
                    ApplicationArea = All;
                    Caption = 'WS Message';
                }
                field("Ship Date"; "Ship Date")
                {
                    ApplicationArea = All;
                    Caption = 'Ship Date';
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'Order Date';
                }
                field("Carrier Code"; "Carrier Code")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Code';
                }
                field("Service Code"; "Service Code")
                {
                    ApplicationArea = All;
                    Caption = 'Service Code';
                }
                field("SOAP Request DateTime"; "SOAP Request DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'SOAP Request DateTime';
                }
                field("SOAP Response DateTime"; "SOAP Response DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'SOAP Response DateTime';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            Group("Web Service Action")
            {
                action("Check Order Request")
                {
                    Caption = 'Check Order Request';
                    ToolTip = 'Check Order Request';
                    Image = Check;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ViewRequest();
                    end;
                }
                action("Check Order Response")
                {
                    Caption = 'Check Order Response';
                    ToolTip = 'Check Order Response';
                    Image = Check;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ViewResponse();
                    end;
                }
                action("NoNS Order Response")
                {
                    Caption = 'NoNS Order Response';
                    ToolTip = 'NoNS Order Response';
                    Image = Check;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ViewResponseNoNS();
                    end;
                }
            }
        }
    }
}