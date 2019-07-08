codeunit 50105 "Read Xml"
{
    trigger OnRun()
    var
        lXmlText: Text;
    begin
        lXmlText := '';
        lXmlText += '';
        lXmlText += 'URl1';
        lXmlText += '';
        lXmlText += 'TOKEN 1';
        lXmlText += '';
        lXmlText += '';

        lXmlText += '';
        lXmlText += 'URl2';
        lXmlText += '';
        lXmlText += 'TOKEN 2';
        lXmlText += '';
        lXmlText += '';

        lXmlText += '';
        lXmlText += 'URL21';
        lXmlText += '';
        lXmlText += 'TOKEN 21';
        lXmlText += '';
        lXmlText += '';

        lXmlText += '';
        ReadXml(lXmlText);
    end;

    local procedure ReadXml(pXmlText: Text);
    var
        XmlDOMMgt: Codeunit "XML DOM Mgt.";
        lXmlDocument: XmlDocument;
        lXmlRootNode: XmlNode;
        lAccessTokenList: XmlNodeList;
        lNodeList: XmlNodeList;
        lXMLNode: XmlNode;
        lTempNode: XmlNode;
    begin
        XmlDOMMgt.LoadXMLDocumentFromText(pXmlText, lXmlDocument);
        XmlDOMMgt.GetRootNode(lXmlDocument, lXmlRootNode);
        if not XmlDOMMgt.FindNodes(lXmlRootNode, 'Access_Token', lAccessTokenList) then
            error('Node Access_Token not found');
        foreach lXMLNode in lAccessTokenList do begin
            lNodeList := lXMLNode.AsXmlElement().GetChildNodes();
            foreach lTempNode in lNodeList do
                case lTempNode.AsXmlElement().Name() of
                    'Instance_Url':
                        Message(lTempNode.AsXmlElement().InnerText());
                    'YourToken':
                        Message(lTempNode.AsXmlElement().InnerText());
                end;
        end;
    end;
}