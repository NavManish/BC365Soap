codeunit 50102 "SOAP Document"
{
    var
        XMLDomMgt: Codeunit "XML DOM Mgt."; //https://diveshboramsdnavblog.wordpress.com/2018/03/09/vs-code-xml-dom-management-part-2/
        SoapNS11Lbl: Label 'http://schemas.xmlsoap.org/soap/envelope/&#8217';
        SoapNS12Lbl: Label 'http://www.w3.org/2003/05/soap-envelope&#8217';
        XsiNSLbl: Label 'http://www.w3.org/2001/XMLSchema-instance&#8217';
        XsdNSLbl: Label 'http://www.w3.org/2001/XMLSchema&#8217';

        //Use this function to Create a Soap Message
    procedure CreateSoapMessage();
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        lTempXmlNode: XmlNode;
        lXMLText: Text;
    begin
        CreateSoapDocument(lXmlDocument, 1, lEnvolopeXmlNode, lHeaderXmlNode, lBodyXmlNode);

        //Add Additional Nodes to the Soap Headers if Needed- Below is the Sample
        XMLDomMgt.AddElement(lHeaderXmlNode, 'SampleHeaders', 'Test', SoapNS12Lbl, lTempXmlNode);

        //You can add/append an existing Node to the Soap Body using XmlNode.AsXmlElement.InnerXml – Below is the Sample
        XMLDomMgt.AddElement(lBodyXmlNode, 'SampleBody', 'Test', SoapNS12Lbl, lTempXmlNode);

        lXmlDocument.WriteTo(lXMLText);
        Message(lXMLText);
    end;

    //Use this function to Create a Soap Document with Soap Version 1.1 & 1.2. This function will return the XML Document along with the reference of the created nodes like Envelope, Header & Body.
    procedure CreateSoapDocument(var pXmlDocument: XmlDocument; pVersion: Option "1.1","1.2"; var pEnvelopeXmlNode: XmlNode; var pHeaderXmlNode: XmlNode; var pBodyXmlNode: XmlNode);
    begin
        CreateEnvelope(pXmlDocument, pEnvelopeXmlNode, pVersion);
        CreateHeader(pEnvelopeXmlNode, pHeaderXmlNode, pVersion);
        CreateBody(pEnvelopeXmlNode, pBodyXmlNode, pVersion);
    end;

    //Use this function to Create a Soap Document with Soap Version 1.1 & 1.2. This function will return the XML Document along with the reference of the created Body node.
    procedure CreateSoapDocumentBody(var pXmlDocument: XmlDocument; pVersion: Option "1.1","1.2"; var pBodyXmlNode: XmlNode);
    var
        lEnvelopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
    begin
        CreateSoapDocument(pXmlDocument, pVersion, lEnvelopeXmlNode, lHeaderXmlNode, pBodyXmlNode);
    end;

    //This function will create a Soap Envelope
    procedure CreateEnvelope(var pXmlDocument: XmlDocument; var pEnvelopeXmlNode: XmlNode; pVersion: Option "1.1","1.2");
    begin
        pXmlDocument := XmlDocument.Create();
        With XMLDomMgt do begin
            AddDeclaration(pXmlDocument, '1.0', 'UTF-8', 'no');
            if pVersion = pVersion::"1.1" then
                AddRootElementWithPrefix(pXmlDocument, 'Envelope', 'Soap', SoapNS11Lbl, pEnvelopeXmlNode)
            else
                AddRootElementWithPrefix(pXmlDocument, 'Envelope', 'Soap', SoapNS12Lbl, pEnvelopeXmlNode);
            AddPrefix(pEnvelopeXmlNode, 'xsi', XsiNSLbl);
            AddPrefix(pEnvelopeXmlNode, 'xsd', XsdNSLbl);
        end;
    end;

    //This function will create a Soap Header
    procedure CreateHeader(var pEnvelopeXmlNode: XmlNode; var pHeaderXmlNode: XmlNode; pVersion: Option "1.1","1.2");
    begin
        if pVersion = pVersion::"1.1" then
            XMLDOMMgt.AddElement(pEnvelopeXmlNode, 'Header', '', SoapNS11Lbl, pHeaderXmlNode)
        else
            XMLDOMMgt.AddElement(pEnvelopeXmlNode, 'Header', '', SoapNS12Lbl, pHeaderXmlNode);
    end;

    //This function will create a Soap Body
    procedure CreateBody(var pSoapEnvelope: XmlNode; var pSoapBody: XmlNode; pVersion: Option "1.1","1.2");
    begin
        if pVersion = pVersion::"1.1" then
            XMLDOMMgt.AddElement(pSoapEnvelope, 'Body', '', SoapNS11Lbl, pSoapBody)
        else
            XMLDOMMgt.AddElement(pSoapEnvelope, 'Body', '', SoapNS12Lbl, pSoapBody);
    end;
}

