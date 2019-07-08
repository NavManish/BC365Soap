codeunit 50100 "VS XML DOM Management"
{
    trigger OnRun();
    begin
    end;
    procedure AddAttribute(pXMLNode: XmlNode; pName: Text; var pValue: Text): Boolean
    begin

        IF pXMLNode.AsXmlElement().IsEmpty() then
            exit(false);
        pXMLNode.AsXmlElement().SetAttribute(pName, pValue);
    end;
    procedure FindNode(pXMLRootNode: XmlNode; pNodePath: Text; var pFoundXMLNode: XmlNode): Boolean
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit(false);
        IF pXMLRootNode.SelectSingleNode(pNodePath, pFoundXMLNode) then
            exit(true);
    end;
    procedure FindNodeWithNameSpace(pXMLRootNode: XmlNode; pNodePath: Text; pPrefix: Text; pNamespace: Text; var pFoundXMLNode: XmlNode): Boolean
    var
        lXmlNsMgr: XmlNamespaceManager;
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit(false);
        lXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable());
        lXMLNsMgr.AddNamespace(pPrefix, pNamespace);
        
        IF pXMLRootNode.SelectSingleNode(pNodePath, lXmlNsMgr, pFoundXMLNode) then
            Exit(true);
    end;
    procedure FindNodesWithNameSpace(pXMLRootNode: XmlNode; pXPath: Text; pPrefix: Text; pNamespace: Text; var pFoundXmlNodeList: XmlNodeList): Boolean
    var
        lXmlNsMgr: XmlNamespaceManager;
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit(false);
        lXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable());
        lXMLNsMgr.AddNamespace(pPrefix, pNamespace);
        exit(FindNodesWithNamespaceManager(pXMLRootNode, pXPath, lXmlNsMgr, pFoundXmlNodeList));
    end;
    procedure FindNodesWithNamespaceManager(pXMLRootNode: XmlNode; pXPath: Text; pXmlNsMgr: XmlNamespaceManager; var pFoundXmlNodeList: XmlNodeList): Boolean
    var
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit(false);
        IF not pXMLRootNode.SelectNodes(pXPath, pXmlNsMgr, pFoundXmlNodeList) then
            exit(false);

        IF pFoundXmlNodeList.Count() = 0 then
            exit(false);
        exit(true);
    end;
    procedure FindNodeXML(pXMLRootNode: XmlNode; pNodePath: Text): Text
    var
        lXmlNode: XmlNode;
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit('');
        IF pXMLRootNode.SelectSingleNode(pNodePath, lXmlNode) then
            Exit(lXmlNode.AsXmlElement().InnerXml());
    end;
    procedure FindNodeText(pXMLRootNode: XmlNode; pNodePath: Text): Text
    var
        lXmlNode: XmlNode;
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit('');
        IF pXMLRootNode.SelectSingleNode(pNodePath, lXmlNode) then
            Exit(lXmlNode.AsXmlElement().InnerText());
    end;
    procedure FindNodeTextWithNameSpace(pXMLRootNode: XmlNode; pNodePath: Text; pPrefix: Text; pNamespace: Text): Text
    var
        lXmlNode: XmlNode;
        lXmlNsMgr: XmlNamespaceManager;
    begin
        IF pXMLRootNode.AsXmlElement().IsEmpty() then
            exit('');
        lXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable());
        lXMLNsMgr.AddNamespace(pPrefix, pNamespace);

        IF pXMLRootNode.SelectSingleNode(pNodePath, lXmlNsMgr, lXmlNode) then
            Exit(lXmlNode.AsXmlElement().InnerText());
    end;
    procedure LoadXMLDocumentFromText(pXMLText: Text; var pXMLDocument: XmlDocument)
    begin
        IF pXMLText = '' then
            exit;
        XmlDocument.ReadFrom(pXMLText, pXMLDocument);
    end;
    procedure LoadXMLNodeFromText(pXMLText: Text; var pXMLRootNode: XmlNode)
    var
        lXmlDocument: XmlDocument;
    begin
        LoadXMLDocumentFromText(pXMLText, lXmlDocument);
        pXMLRootNode := lXmlDocument.AsXmlNode();
    end;
}