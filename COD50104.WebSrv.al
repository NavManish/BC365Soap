codeunit 50104 WebSrv
{
    TableNo = 50104;
    trigger OnRun()
    var
        myInt: Integer;
        XMLReq: XmlDocument;
        XMLRes: XmlDocument;
    begin
    end;

    procedure CreateSoapMessage();
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        MyHttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        lXMLText: Text;
        OrdNo: code[8];
        ResponseXMLText: Text;
    begin
        Url := 'https://moultonordervision.com/ws/OrderStatusWebService.asmx';
        CreateEnvelope(lXmlDocument, lEnvolopeXmlNode);
        CreateHeader(lEnvolopeXmlNode, lHeaderXmlNode);
        OrdNo := '03027514';
        CreateBody(lEnvolopeXmlNode, lBodyXmlNode, OrdNo);

        //>> Sending Request to Web Service
        RequestMessage.SetRequestUri(URL);
        RequestMessage.Method('POST');
        lXmlDocument.WriteTo(lXMLText);
        Content.WriteFrom(lXMLText);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'text/xml;charset=utf-8');
        RequestMessage.Content := Content;
        MyHttpClient.Send(RequestMessage, ResponseMessage);
        //<< Sending Request to Web Service

        //InsertXMLReqRes(lXmlDocument, OrdNo);
        //lXmlDocument.WriteTo(lXMLText);
        //Message(lXMLText);

        ResponseMessage.Content().ReadAs(ResponseXMLText);
        InsertXMLReqRes(lXmlDocument, OrdNo, ResponseXMLText);
    end;

    procedure CreateEnvelope(var pXmlDocument: XmlDocument; var pEnvelopeXmlNode: XmlNode);
    begin
        pXmlDocument := XmlDocument.Create();
        With XMLDomMgt do begin
            AddDeclaration(pXmlDocument, '1.0', 'UTF-8', 'Yes');
            AddRootElementWithPrefix(pXmlDocument, 'Envelope', 'soapenv', SOAPNamespaceLbl, pEnvelopeXmlNode);
            AddPrefix(pEnvelopeXmlNode, 'ord', XSDNamespaceLbl);
        end;
    end;

    procedure CreateHeader(var pEnvelopeXmlNode: XmlNode; var pHeaderXmlNode: XmlNode);
    begin
        XMLDOMMgt.AddElement(pEnvelopeXmlNode, 'Header', 'soapenv', SOAPNamespaceLbl, pHeaderXmlNode);
    end;

    procedure CreateBody(var pSoapEnvelope: XmlNode; var pSoapBody: XmlNode; var pOrderNo: code[8]);
    begin
        Clear(StrxmlNodeValue);
        XMLDOMMgt.AddElement(pSoapEnvelope, 'Body', 'soapenv', SOAPNamespaceLbl, pSoapBody);
        XMLDOMMgt.AddElement(pSoapBody, 'OrderStatus', '', XSDNamespaceLbl, OrdStatusNode);
        StrxmlNodeValue := '<dataQuery><username>' + 'ECRK_TST1' + '</username><password>' +
                           'KJ67mtrx6gEC45t9' + '</password><group_code>' + 'TEST' +
                           '</group_code><order_no>' + pOrderNo + '</order_no></dataQuery>';

        xmlcd := XmlCData.Create(StrxmlNodeValue);
        XMLDOMMgt.AddElement(OrdStatusNode, 'strXml', '', XSDNamespaceLbl, strXMLNode);
        XMLDOMMgt.AddElement(strXMLNode, 'strXml2', '', XSDNamespaceLbl, strXMLNodeTemp);
        strXMLNodeTemp.ReplaceWith(xmlcd);
        //strXMLNode.AddAfterSelf(xmlcd);
    end;

    local procedure InsertXMLReqRes(var pXmlDocument: XmlDocument; OrdNo: code[20]; RespnseTxt: Text)
    var
        OrderHis: Record OrderHistory;
        XMLReqOutStrm: OutStream;
        XMLResOutStrm: OutStream;
        lXMLResponse: XmlDocument;
        lXMLResponseText: Text;
        NoNSXMLOStrm: OutStream;
    begin
        clear(XMLResponseNoNS);
        OrderHis.DeleteAll();
        OrderHis.reset();
        OrderHis.Init();
        OrderHis."Moulton Order No." := OrdNo;
        OrderHis."File Extension" := 'XML';
        OrderHis."SOAP Request".CreateOutStream(XMLReqOutStrm);
        pXmlDocument.WriteTo(XMLReqOutStrm);
        OrderHis."SOAP Request DateTime" := CurrentDateTime();
        OrderHis."SOAP Response".CreateOutStream(XMLResOutStrm);
        XmlDocument.ReadFrom(RespnseTxt, lXMLResponse);
        lXMLResponse.WriteTo(XMLResOutStrm);
        OrderHis."SOAP Response DateTime" := CurrentDateTime();
        
        //>> Creating & Saving XMLDocument without Namespace
        lXMLResponseText := XMLDomMgt.RemoveNamespaces(RespnseTxt);
        OrderHis."SOAP Response without NS".CreateOutStream(NoNSXMLOStrm);
        XmlDocument.ReadFrom(lXMLResponseText, XMLResponseNoNS);
        XMLResponseNoNS.WriteTo(NoNSXMLOStrm);
        //<< Creating & Saving XMLDocument without Namespace

        orderhis.Insert();
        commit();
        ReadResponse(XMLResponseNoNS, OrdNo);
    end;

    local procedure ReadResponse(Var XMLResponseParam: XmlDocument; OrdNoParam: code[20])
    var
        OrderHist : Record OrderHistory;
        RespStatus: Text[10];
        RespMsg: text[100];
        RespGrpCode: text[10];
        RespOrdNo: code[20];
        CarrCode: code[10];
        SrvCode: Code[10];
        ResOrderDate: Date;
        xmlNodeList1: XmlNodeList;
        xmlNodeList2: XmlNodeList;
        xmlNodeList3: XmlNodeList;
        xmldomElem1: XmlElement;
        xmldomElem2: XmlElement;
        xmldomElem3: XmlElement;
        xmlNode1: XmlNode;
        xmlNode2: XmlNode;
        xmlNode3: XmlNode;
        i: Integer;
        YYYY: Integer;
        MM: Integer;
        DD: Integer;
    begin
        xmlNodeList1 := XMLResponseParam.GetDescendantElements('dataResponse');
        FOR i := 1 TO xmlNodeList1.Count() DO BEGIN

            if xmlNodeList1.Get(i, xmlNode1) then //dataResponse
                xmldomElem1 := xmlNode1.AsXmlElement();
            if not xmldomElem1.IsEmpty() and xmldomElem1.HasElements() then
                xmlNodeList2 := xmldomElem1.GetChildNodes();

            //>> Status     
            if xmlNodeList2.Get(1, xmlNode2) then
                xmldomElem2 := xmlNode2.AsXmlElement();
            if not xmldomElem2.IsEmpty() then
                Evaluate(RespStatus, xmldomElem2.InnerText());
            //<< Status  

            //>> message
            if xmlNodeList2.Get(2, xmlNode2) then
                xmldomElem2 := xmlNode2.AsXmlElement();
            if not xmldomElem2.IsEmpty() then
                Evaluate(RespMsg, xmldomElem2.InnerText());
            //<< message

            //>> group_code
            if xmlNodeList2.Get(3, xmlNode2) then
                xmldomElem2 := xmlNode2.AsXmlElement();
            if not xmldomElem2.IsEmpty() then
                Evaluate(RespGrpCode, xmldomElem2.InnerText());
            //<< group_code

            //>> order_no
            if xmlNodeList2.Get(4, xmlNode2) then
                xmldomElem2 := xmlNode2.AsXmlElement();
            if not xmldomElem2.IsEmpty() then
                Evaluate(RespOrdNo, xmldomElem2.InnerText());
            //<< order_no

            if xmlNodeList2.Get(5, xmlNode2) then //OrderStatus
                xmldomElem2 := xmlNode2.AsXmlElement();
            if xmldomElem2.HasElements() then
                xmlNodeList3 := xmldomElem2.GetChildNodes();

            //>> OrderDate
            if xmlNodeList3.Get(1, xmlNode3) then
                xmldomElem3 := xmlNode3.AsXmlElement();
            if not xmldomElem3.IsEmpty() then begin
                EVALUATE(YYYY, Copystr(xmldomElem3.InnerText(), 1, 4));
                EVALUATE(MM, Copystr(xmldomElem3.InnerText(), 5, 2));
                EVALUATE(DD, Copystr(xmldomElem3.InnerText(), 7, 2));
                ResOrderDate := DMY2Date(DD, MM, YYYY);
            end;
            //<< OrderDate

            //>> CarrierCode
            if xmlNodeList3.Get(4, xmlNode3) then
                xmldomElem3 := xmlNode3.AsXmlElement();
            if not xmldomElem3.IsEmpty() then
                Evaluate(CarrCode, xmldomElem3.InnerText());
            //<< CarrierCode

            //>> ServiceCode
            if xmlNodeList3.Get(5, xmlNode3) then
                xmldomElem3 := xmlNode3.AsXmlElement();
            if not xmldomElem3.IsEmpty() then
                Evaluate(SrvCode, xmldomElem3.InnerText());
            //<< ServiceCode
        
            //>> Update Order History
            if OrderHist.get(OrdNoParam) then begin
                OrderHist."WS Status" := copystr(RespStatus,1,5);
                OrderHist."WS Message" := RespMsg;
                OrderHist."Group Code" := RespGrpCode;
                OrderHist."Order Date" := ResOrderDate;
                OrderHist."Carrier Code" := CarrCode;
                OrderHist."Service Code" := SrvCode;
                OrderHist.Modify();
            end;
            //<< Update Order History

            Clear(RespOrdNo);
            Clear(RespGrpCode);
            Clear(RespMsg);
            Clear(RespStatus);
            Clear(ResOrderDate);
            clear(CarrCode);
            clear(SrvCode);
            Clear(xmlNodeList2);
        END;
    end;

    var
        XMLDomMgt: Codeunit "XML DOM Mgt.";
        URL: Text;
        myInt: Integer;
        SOAPNamespaceLbl: Label 'http://schemas.xmlsoap.org/soap/envelope/';
        XSDNamespaceLbl: Label 'https://moultonordervision.com/Ws/OrderStatusWebService.asmx';
        ContentTypeLbl: Label 'multipart/form-data; charset=utf-8';
        StrxmlNodeValue: Text;
        OrdStatusNode: XmlNode;
        HttpRspMsg: HttpResponseMessage;
        strXMLNode: XmlNode;
        strXMLNodeTemp: XmlNode;
        xmlcd: XmlCData;
        XMLResponseNoNS: XmlDocument;
}