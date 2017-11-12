{**************************************************************

项目名称 :ThinkWide
版权所有 (c) 2006 ThinkWide
+-------------------------------------------------------------
项目:


版本: 1


创建日期: -2006-8-11 19:02:09


作者: 章称 (Andyzhang)

+-------------------------------------------------------------
描述:   

更新:    -2006-8-11 19:02:09


ToDo:

***************************************************************}

unit MFSchemeObjectXml;

interface

uses
  Classes, Forms, SysUtils, Controls, MFSchemeXml, TypInfo , Variants;

type
  TMFXmlObjectWriter = class(TPersistent)
  protected
    procedure WriteProperty(ANode: TXmlNode; AObject: TObject; AParent: TComponent; PropInfo: PPropInfo);
  public
    procedure WriteObject(ANode: TXmlNode; AObject: TObject; AParent: TComponent = nil);
    procedure WriteComponent(ANode: TXmlNode; AComponent: TComponent; AParent: TComponent = nil);
  end;

  TMFXmlObjectReader = class(TPersistent)
  protected
    procedure ReadProperty(ANode: TXmlNode; AObject: TObject; AParent: TComponent; PropInfo: PPropInfo);
  public
    function CreateComponent(ANode: TXmlNode; AOwner, AParent: TComponent; AName: string = ''): TComponent;
    procedure ReadObject(ANode: TXmlNode; AObject: TObject; AParent: TComponent = nil);
    procedure ReadComponent(ANode: TXmlNode; AComponent: TComponent; AParent: TComponent);
  end;

function ComponentCreateFromXmlFile(const FileName: string; Owner: TComponent;
  const Name: string): TComponent;


function ComponentCreateFromXmlNode(ANode: TXmlNode; Owner: TComponent;
  const Name: string): TComponent;


function ComponentCreateFromXmlStream(S: TStream; Owner: TComponent;
  const Name: string): TComponent;

function ComponentCreateFromXmlString(const Value: string; Owner: TComponent;
  const Name: string): TComponent;

function FormCreateFromXmlFile(const FileName: string; Owner: TComponent;
  const Name: string): TForm;

function FormCreateFromXmlStream(S: TStream; Owner: TComponent;
  const Name: string): TForm;

function FormCreateFromXmlString(const Value: string; Owner: TComponent;
  const Name: string): TForm;

procedure ObjectLoadFromXmlFile(AObject: TObject; const FileName: string;
  AParent: TComponent = nil);

procedure ObjectLoadFromXmlNode(AObject: TObject; ANode: TXmlNode; AParent: TComponent = nil);

procedure ObjectLoadFromXmlStream(AObject: TObject; S: TStream; AParent: TComponent = nil);

procedure ObjectLoadFromXmlString(AObject: TObject; const Value: string; AParent: TComponent = nil);

procedure ObjectSaveToXmlFile(AObject: TObject; const FileName: string;
  AParent: TComponent = nil);

procedure ObjectSaveToXmlNode(AObject: TObject; ANode: TXmlNode; AParent: TComponent = nil);

procedure ObjectSaveToXmlStream(AObject: TObject; S: TStream; AParent: TComponent = nil);

function ObjectSaveToXmlString(AObject: TObject; AParent: TComponent = nil): string;

procedure ComponentSaveToXmlFile(AComponent: TComponent; const FileName: string;
  AParent: TComponent = nil);

procedure ComponentSaveToXmlNode(AComponent: TComponent; ANode: TXmlNode;
  AParent: TComponent = nil);

procedure ComponentSaveToXmlStream(AComponent: TComponent; S: TStream;
  AParent: TComponent = nil);

function ComponentSaveToXmlString(AComponent: TComponent; AParent: TComponent = nil): string;

procedure FormSaveToXmlFile(AForm: TForm; const FileName: string);

procedure FormSaveToXmlStream(AForm: TForm; S: TStream);

function FormSaveToXmlString(AForm: TForm): string;

resourcestring
  sxwIllegalVarType        = '违法的变量类型';
  sxrUnregisteredClassType = '未注册的类';
  sxrInvalidPropertyValue  = '错误的属性';
  sxwInvalidMethodName     = '错误的方法名称';

implementation

type
  THackPersistent = class(TPersistent);
  THackComponent = class(TComponent)
  public
    procedure SetComponentState(const AState: TComponentState);
  published
    property ComponentState;
  end;

  THackReader = class(TReader);

function ComponentCreateFromXmlFile(const FileName: string; Owner: TComponent;
  const Name: string): TComponent;
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := ComponentCreateFromXmlStream(S, Owner, Name);
  finally
    S.Free;
  end;
end;

function ComponentCreateFromXmlNode(ANode: TXmlNode; Owner: TComponent;
  const Name: string): TComponent;
var
  AReader: TMFXmlObjectReader;
begin
  Result := nil;
  if not assigned(ANode) then exit;
  
  AReader := TMFXmlObjectReader.Create;
  try
    
    Result := AReader.CreateComponent(ANode, Owner, nil, Name);
  finally
    AReader.Free;
  end;
end;

function ComponentCreateFromXmlStream(S: TStream; Owner: TComponent;
  const Name: string): TComponent;
var
  ADoc: TMFSchemeXml;
begin
  Result := nil;
  if not assigned(S) then exit;
  
  ADoc := TMFSchemeXml.Create;
  try
    
    ADoc.LoadFromStream(S);
    
    Result := ComponentCreateFromXmlNode(ADoc.Root, Owner, Name);
  finally
    ADoc.Free;
  end;
end;

function ComponentCreateFromXmlString(const Value: string; Owner: TComponent;
  const Name: string): TComponent;
var
  S: TStream;
begin
  S := TStringStream.Create(Value);
  try
    Result := ComponentCreateFromXmlStream(S, Owner, Name);
  finally
    S.Free;
  end;
end;

function FormCreateFromXmlFile(const FileName: string; Owner: TComponent;
  const Name: string): TForm;
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := FormCreateFromXmlStream(S, Owner, Name);
  finally
    S.Free;
  end;
end;

function FormCreateFromXmlStream(S: TStream; Owner: TComponent;
  const Name: string): TForm;
var
  ADoc: TMFSchemeXml;
begin
  Result := nil;
  if not assigned(S) then exit;
  ADoc := TMFSchemeXml.Create;
  try
    ADoc.LoadFromStream(S);
    Result := TForm(ComponentCreateFromXmlNode(ADoc.Root, Owner, Name));
  finally
    ADoc.Free;
  end;
end;

function FormCreateFromXmlString(const Value: string; Owner: TComponent;
  const Name: string): TForm;
var
  S: TStream;
begin
  S := TStringStream.Create(Value);
  try
    Result := FormCreateFromXmlStream(S, Owner, Name);
  finally
    S.Free;
  end;
end;

procedure ObjectLoadFromXmlFile(AObject: TObject; const FileName: string;
  AParent: TComponent = nil);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    ObjectLoadFromXmlStream(AObject, S, AParent);
  finally
    S.Free;
  end;
end;

procedure ObjectLoadFromXmlNode(AObject: TObject; ANode: TXmlNode; AParent: TComponent = nil);
var
  AReader: TMFXmlObjectReader;
begin
  if not assigned(AObject) or not assigned(ANode) then exit;
  AReader := TMFXmlObjectReader.Create;
  try
    if AObject is TComponent then
      AReader.ReadComponent(ANode, TComponent(AObject), AParent)
    else
      AReader.ReadObject(ANode, AObject, AParent);
  finally
    AReader.Free;
  end;
end;

procedure ObjectLoadFromXmlStream(AObject: TObject; S: TStream; AParent: TComponent = nil);
var
  ADoc: TMFSchemeXml;
begin
  if not assigned(S) then exit;
  ADoc := TMFSchemeXml.Create;
  try
    ADoc.LoadFromStream(S);
    ObjectLoadFromXmlNode(AObject, ADoc.Root, AParent);
  finally
    ADoc.Free;
  end;
end;

procedure ObjectLoadFromXmlString(AObject: TObject; const Value: string; AParent: TComponent = nil);
var
  S: TStringStream;
begin
  S := TStringStream.Create(Value);
  try
    ObjectLoadFromXmlStream(AObject, S, AParent);
  finally
    S.Free;
  end;
end;

procedure ObjectSaveToXmlFile(AObject: TObject; const FileName: string;
  AParent: TComponent = nil);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    ObjectSaveToXmlStream(AObject, S, AParent);
  finally
    S.Free;
  end;
end;

procedure ObjectSaveToXmlNode(AObject: TObject; ANode: TXmlNode; AParent: TComponent = nil);
var
  AWriter: TMFXmlObjectWriter;
begin
  if not assigned(AObject) or not assigned(ANode) then exit;
  
  AWriter := TMFXmlObjectWriter.Create;
  try
    
    if AObject is TComponent then
      AWriter.WriteComponent(ANode, TComponent(AObject), AParent)
    else begin
      ANode.Name := AObject.ClassName;
      AWriter.WriteObject(ANode, AObject, AParent);
    end;
  finally
    AWriter.Free;
  end;
end;

procedure ObjectSaveToXmlStream(AObject: TObject; S: TStream; AParent: TComponent = nil);
var
  ADoc: TMFSchemeXml;
begin
  if not assigned(S) then exit;
  
  ADoc := TMFSchemeXml.Create;
  try
    ADoc.Utf8Encoded := True;
    ADoc.EncodingString := 'UTF-8';
    ADoc.XmlFormat := xfReadable;
    
    ObjectSaveToXmlNode(AObject, ADoc.Root, AParent);
    
    ADoc.SaveToStream(S);
  finally
    ADoc.Free;
  end;
end;

function ObjectSaveToXmlString(AObject: TObject; AParent: TComponent = nil): string;
var
  S: TStringStream;
begin
  S := TStringStream.Create('');
  try
    ObjectSaveToXmlStream(AObject, S, AParent);
    Result := S.DataString;
  finally
    S.Free;
  end;
end;

procedure ComponentSaveToXmlFile(AComponent: TComponent; const FileName: string;
  AParent: TComponent = nil);
begin
  ObjectSaveToXmlFile(AComponent, FileName, AParent);
end;

procedure ComponentSaveToXmlNode(AComponent: TComponent; ANode: TXmlNode;
  AParent: TComponent = nil);
begin
  ObjectSaveToXmlNode(AComponent, ANode, AParent);
end;

procedure ComponentSaveToXmlStream(AComponent: TComponent; S: TStream;
  AParent: TComponent = nil);
begin
  ObjectSaveToXmlStream(AComponent, S, AParent);
end;

function ComponentSaveToXmlString(AComponent: TComponent; AParent: TComponent = nil): string;
begin
  Result := ObjectSaveToXmlString(AComponent, AParent);
end;

procedure FormSaveToXmlFile(AForm: TForm; const FileName: string);
begin
  ComponentSaveToXmlFile(AForm, FileName, AForm);
end;

procedure FormSaveToXmlStream(AForm: TForm; S: TStream);
begin
  ComponentSaveToXmlStream(AForm, S, AForm);
end;

function FormSaveToXmlString(AForm: TForm): string;
begin
  Result := ComponentSaveToXmlString(AForm, AForm);
end;


procedure TMFXmlObjectWriter.WriteComponent(ANode: TXmlNode; AComponent,
  AParent: TComponent);
begin
  if not assigned(ANode) or not assigned(AComponent) then exit;
  ANode.Name := AComponent.ClassName;
  if length(AComponent.Name) > 0 then
    ANode.AttributeAdd('Name', AComponent.Name);
  WriteObject(ANode, AComponent, AParent);
end;

procedure TMFXmlObjectWriter.WriteObject(ANode: TXmlNode; AObject: TObject;
  AParent: TComponent);
var
  i, Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
  S: TStringStream;
  AWriter: TWriter;
  AChildNode: TXmlNode;
  AComponentNode: TXmlNode;
begin
  if not assigned(ANode) or not assigned(AObject) then exit;

  
  if AObject is TComponent then with TComponent(AObject) do begin
    if ComponentCount > 0 then begin
      AChildNode := ANode.NodeNew('Components');
      for i := 0 to ComponentCount - 1 do begin
        AComponentNode := AChildNode.NodeNew(Components[i].ClassName);
        if length(Components[i].Name) > 0 then
          AComponentNode.AttributeAdd('Name', Components[i].Name);
        WriteObject(AComponentNode, Components[i], TComponent(AObject));
      end;
    end;
  end;

  
  Count := GetTypeData(AObject.ClassInfo)^.PropCount;
  if Count > 0 then begin
    GetMem(PropList, Count * SizeOf(Pointer));
    try
      GetPropInfos(AObject.ClassInfo, PropList);
      for i := 0 to Count - 1 do begin
        PropInfo := PropList^[i];
        if PropInfo = nil then continue;
        if IsStoredProp(AObject, PropInfo) then
          WriteProperty(ANode, AObject, AParent, PropInfo);
      end;
    finally
      FreeMem(PropList, Count * SizeOf(Pointer));
    end;
  end;

  
  if AObject is TPersistent then begin
    S := TStringStream.Create('');
    try
      AWriter := TWriter.Create(S, 4096);
      try
        THackPersistent(AObject).DefineProperties(AWriter);
      finally
        AWriter.Free;
      end;
      
      if S.Size > 0 then begin
        
        ANode.NodeNew('DefinedProperties').BinaryString := S.DataString;
      end;
    finally
      S.Free;
    end;
  end;
end;

procedure TMFXmlObjectWriter.WriteProperty(ANode: TXmlNode; AObject: TObject;
  AParent: TComponent; PropInfo: PPropInfo);
var
  PropType: PTypeInfo;
  AChildNode: TXmlNode;
  ACollectionNode: TXmlNode;

  procedure WritePropName;
  begin
    AChildNode := ANode.NodeNew(PPropInfo(PropInfo)^.Name);
  end;

  procedure WriteInteger(Value: Int64);
  begin
    AChildNode.ValueAsString := IntToStr(Value);
  end;

  procedure WriteString(Value: string);
  begin
    AChildNode.ValueAsString := Value;
  end;

  procedure WriteSet(Value: Longint);
  var
    I: Integer;
    BaseType: PTypeInfo;
    S, Enum: string;
  begin
    BaseType := GetTypeData(PropType)^.CompType^;
    for i := 0 to SizeOf(TIntegerSet) * 8 - 1 do begin
      if i in TIntegerSet(Value) then begin
        Enum := GetEnumName(BaseType, i);
        if i > 0 then
          S := S + ',' + Enum
        else
          S := Enum;
      end;
    end;
    AChildNode.ValueAsString := Format('[%s]', [S]);
  end;

  procedure WriteIntProp(IntType: PTypeInfo; Value: Longint);
  var
    Ident: string;
    IntToIdent: TIntToIdent;
  begin
    IntToIdent := FindIntToIdent(IntType);
    if Assigned(IntToIdent) and IntToIdent(Value, Ident) then
      WriteString(Ident)
    else
      WriteInteger(Value);
  end;

  procedure WriteCollectionProp(Collection: TCollection);
  var
    i: integer;
  begin
    if assigned(Collection) then begin
      for i := 0 to Collection.Count - 1 do
      begin
        ACollectionNode := AChildNode.NodeNew(Collection.Items[i].ClassName);
        WriteObject(ACollectionNode, Collection.Items[I], AParent);
      end;
    end;
  end;

  procedure WriteOrdProp;
  var
    Value: Longint;
  begin
    Value := GetOrdProp(AObject, PropInfo);
    if not (Value = PPropInfo(PropInfo)^.Default) then begin
      WritePropName;
      case PropType^.Kind of
      tkInteger:     WriteIntProp(PPropInfo(PropInfo)^.PropType^, Value);
      tkChar:        WriteString(Chr(Value));
      tkSet:         WriteSet(Value);
      tkEnumeration: WriteString(GetEnumName(PropType, Value));
      end;
    end;
  end;

  procedure WriteFloatProp;
  var
    Value: Extended;
  begin
    Value := GetFloatProp(AObject, PropInfo);
    if not (Value = 0) then
      ANode.WriteFloat(PPropInfo(PropInfo)^.Name, Value);
  end;

  procedure WriteInt64Prop;
  var
    Value: Int64;
  begin
    Value := GetInt64Prop(AObject, PropInfo);
    if not (Value = 0) then
      ANode.WriteInt64(PPropInfo(PropInfo)^.Name, Value);
  end;

  procedure WriteStrProp;
  var
    Value: string;
  begin
    Value := GetStrProp(AObject, PropInfo);
    if not (length(Value) = 0) then
      ANode.WriteString(PPropInfo(PropInfo)^.Name, Value);
  end;

  procedure WriteObjectProp;
  var
    Value: TObject;
    ComponentName: string;
    function GetComponentName(Component: TComponent): string;
    begin
      if Component.Owner = AParent then
        Result := Component.Name
      else if Component = AParent then
        Result := 'Owner'
      else if assigned(Component.Owner) and (length(Component.Owner.Name) > 0)
        and (length(Component.Name) > 0) then
        Result := Component.Owner.Name + '.' + Component.Name
      else if length(Component.Name) > 0 then
        Result := Component.Name + '.Owner'
      else Result := '';
    end;

  begin
    Value := TObject(GetOrdProp(AObject, PropInfo));
    if not assigned(Value) then exit;
    WritePropName;
    if Value is TComponent then begin
      ComponentName := GetComponentName(TComponent(Value));
      if length(ComponentName) > 0 then
        WriteString(ComponentName);
    end else begin
      WriteString(Format('(%s)', [Value.ClassName]));
      if Value is TCollection then
        WriteCollectionProp(TCollection(Value))
      else begin
        if AObject is TComponent then
          WriteObject(AChildNode, Value, TComponent(AObject))
        else
          WriteObject(AChildNode, Value, AParent)
      end;
      
      if AChildNode.NodeCount = 0 then
        ANode.NodeRemove(AChildNode);
    end;
  end;

  procedure WriteMethodProp;
  var
    Value: TMethod;
    function IsDefaultValue: Boolean;
    begin
      Result := (Value.Code = nil) or
        ((Value.Code <> nil) and assigned(AParent) and (AParent.MethodName(Value.Code) = ''));
    end;
  begin
    Value := GetMethodProp(AObject, PropInfo);
    if not IsDefaultValue then begin
      if assigned(Value.Code) then begin
        WritePropName;
        if assigned(AParent) then
          WriteString(AParent.MethodName(Value.Code))
        else
          AChildNode.ValueAsString := '???';
      end;
    end;
  end;

  procedure WriteVariantProp;
  var
    AValue: Variant;
    ACurrency: Currency;
  var
    VType: Integer;
  begin
    AValue := GetVariantProp(AObject, PropInfo);
    if not VarIsEmpty(AValue) then begin
      if VarIsArray(AValue) then
        raise Exception.Create(sxwIllegalVarType);
      WritePropName;
      VType := VarType(AValue);
      AChildNode.AttributeAdd('VarType', IntToHex(VType, 4));
      case VType and varTypeMask of
      varOleStr:  AChildNode.ValueAsWideString := AValue;
      varString:  AChildNode.ValueAsString := AValue;
      varByte,
      varSmallInt,
      varInteger: AChildNode.ValueAsInteger := AValue;
      varSingle,
      varDouble:  AChildNode.ValueAsFloat := AValue;
      varCurrency:
        begin
          ACurrency := AValue;
          AChildNode.BufferWrite(ACurrency, SizeOf(ACurrency));
        end;
      varDate:    AChildNode.ValueAsDateTime := AValue;
      varBoolean: AChildNode.ValueAsBool := AValue;
      else
        try
          ANode.ValueAsString := AValue;
        except
          raise Exception.Create(sxwIllegalVarType);
        end;
      end;
    end;
  end;

begin
  if (PPropInfo(PropInfo)^.SetProc <> nil) and
    (PPropInfo(PropInfo)^.GetProc <> nil) then
  begin
    PropType := PPropInfo(PropInfo)^.PropType^;
    case PropType^.Kind of
    tkInteger, tkChar, tkEnumeration, tkSet: WriteOrdProp;
    tkFloat:                                 WriteFloatProp;
    tkString, tkLString, tkWString:          WriteStrProp;
    tkClass:                                 WriteObjectProp;
    tkMethod:                                WriteMethodProp;
    tkVariant:                               WriteVariantProp;
    tkInt64:                                 WriteInt64Prop;
    end;
  end;
end;



function TMFXmlObjectReader.CreateComponent(ANode: TXmlNode;
  AOwner, AParent: TComponent; AName: string): TComponent;
var
  AClass: TComponentClass;
begin
  AClass := TComponentClass(GetClass(ANode.Name));
  if not assigned(AClass) then
    raise Exception.Create(sxrUnregisteredClassType);
  Result := AClass.Create(AOwner);
  if length(AName) = 0 then
    Result.Name := ANode.AttributeByName['Name']
  else
    Result.Name := AName;
  if not assigned(AParent) then
    AParent := Result;
  ReadComponent(ANode, Result, AParent);
end;

procedure TMFXmlObjectReader.ReadComponent(ANode: TXmlNode; AComponent,
  AParent: TComponent);
begin
  ReadObject(ANode, AComponent, AParent);
end;

procedure TMFXmlObjectReader.ReadObject(ANode: TXmlNode; AObject: TObject; AParent: TComponent);
var
  i, Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
  S: TStringStream;
  AReader: TReader;
  AChildNode: TXmlNode;
  AComponentNode: TXmlNode;
  AClass: TComponentClass;
  AComponent: TComponent;
begin
  if not assigned(ANode) or not assigned(AObject) then exit;

  
  if AObject is TComponent then with THackComponent(AObject) do begin
    THackComponent(AObject).Updating;
    SetComponentState(ComponentState + [csLoading, csReading]);
  end;
  try

    
    if AObject is TComponent then with TComponent(AObject) do begin
      AChildNode := ANode.NodeByName('Components');
      if assigned(AChildNode) then begin
        for i := 0 to AChildNode.NodeCount - 1 do begin
          AComponentNode := AChildNode.Nodes[i];
          AComponent := FindComponent(AComponentNode.AttributeByName['Name']);
          if not assigned(AComponent) then begin
            AClass := TComponentClass(GetClass(AComponentNode.Name));
            if not assigned(AClass) then
              raise Exception.Create(sxrUnregisteredClassType);
            AComponent := AClass.Create(TComponent(AObject));
            AComponent.Name := AComponentNode.AttributeByName['Name'];
            
            if (AComponent is TControl) and (AObject is TWinControl) then
              TControl(AComponent).Parent := TWinControl(AObject);
          end;
          ReadComponent(AComponentNode, AComponent, TComponent(AObject));
        end;
      end;
    end;

    
    Count := GetTypeData(AObject.ClassInfo)^.PropCount;
    if Count > 0 then begin
      GetMem(PropList, Count * SizeOf(Pointer));
      try
        GetPropInfos(AObject.ClassInfo, PropList);
        for i := 0 to Count - 1 do begin
          PropInfo := PropList^[i];
          if PropInfo = nil then continue;
          if IsStoredProp(AObject, PropInfo) then
            ReadProperty(ANode, AObject, AParent, PropInfo);
        end;
      finally
        FreeMem(PropList, Count * SizeOf(Pointer));
      end;
    end;

    
    if AObject is TPersistent then begin
      AChildNode := ANode.NodeByName('DefinedProperties');
      if assigned(AChildNode) then begin
        S := TStringStream.Create(AChildNode.BinaryString);
        try
          AReader := TReader.Create(S, 4096);
          try
            THackReader(AReader).ReadProperty(TPersistent(AObject));
          finally
            AReader.Free;
          end;
        finally
          S.Free;
        end;
      end;
    end;

  finally
    
    if AObject is TComponent then with THackComponent(AObject) do begin
      SetComponentState(ComponentState - [csReading]);
      THackComponent(AObject).Loaded;
      THackComponent(AObject).Updated;
    end;
  end;
end;

procedure TMFXmlObjectReader.ReadProperty(ANode: TXmlNode;
  AObject: TObject; AParent: TComponent; PropInfo: PPropInfo);
var
  PropType: PTypeInfo;
  AChildNode: TXmlNode;
  Method: TMethod;
  PropObject: TObject;

  procedure SetSetProp(const AValue: string);
  var
    S: string;
    P: integer;
    ASet: integer;
    EnumType: PTypeInfo;

    procedure AddToEnum(const EnumName: string);
    var
      V: integer;
    begin
      if length(EnumName) = 0 then exit;
      V := GetEnumValue(EnumType, EnumName);
      if V = -1 then
        raise Exception.Create(sxrInvalidPropertyValue);
      Include(TIntegerSet(ASet), V);
    end;
  begin
    ASet := 0;
    EnumType := GetTypeData(PropType)^.CompType^;
    S := copy(AValue, 2, length(AValue) - 2);
    repeat
      P := Pos(',', S);
      if P > 0 then begin
        AddToEnum(copy(S, 1, P - 1));
        S := copy(S, P + 1, length(S));
      end else begin
        AddToEnum(S);
        break;
      end;
    until False;
    SetOrdProp(AObject, PropInfo, ASet);
  end;

  procedure SetIntProp(const AValue: string);
  var
    V: Longint;
    IdentToInt: TIdentToInt;
  begin
    IdentToInt := FindIdentToInt(PropType);
    if Assigned(IdentToInt) and IdentToInt(AValue, V) then
      SetOrdProp(AObject, PropInfo, V)
    else
      SetOrdProp(AObject, PropInfo, StrToInt(AValue));
  end;

  procedure SetCharProp(const AValue: string);
  begin
    if length(AValue) <> 1 then
      raise Exception.Create(sxrInvalidPropertyValue);
    SetOrdProp(AObject, PropInfo, Ord(AValue[1]));
  end;

  procedure SetEnumProp(const AValue: string);
  var
    V: integer;
  begin
    V := GetEnumValue(PropType, AValue);
    if V = -1 then
      raise Exception.Create(sxrInvalidPropertyValue);
    SetOrdProp(AObject, PropInfo, V)
  end;

  procedure ReadCollectionProp(ACollection: TCollection);
  var
    i: integer;
    Item: TPersistent;
  begin
    ACollection.BeginUpdate;
    try
      ACollection.Clear;
      for i := 0 to AChildNode.NodeCount - 1 do begin
        Item := ACollection.Add;
        ReadObject(AChildNode.Nodes[i], Item, AParent);
      end;
    finally
      ACollection.EndUpdate;
    end;
  end;

  procedure SetObjectProp(const AValue: string);
  var
    AClassName: string;
    PropObject: TObject;
    Reference: TComponent;
  begin
    if length(AValue) = 0 then exit;
    if AValue[1] = '(' then begin
      
      AClassName := Copy(AValue, 2, length(AValue) - 2);
      PropObject := TObject(GetOrdProp(AObject, PropInfo));
      if assigned(PropObject) and (PropObject.ClassName = AClassName) then begin
        if PropObject is TCollection then
          ReadCollectionProp(TCollection(PropObject))
        else begin
          if AObject is TComponent then
            ReadObject(AChildNode, PropObject, TComponent(AObject))
          else
            ReadObject(AChildNode, PropObject, AParent);
        end;
      end else
        raise Exception.Create(sxrUnregisteredClassType);
    end else begin
      
      if assigned(AParent) then begin
        Reference := FindNestedComponent(AParent, AValue);
        SetOrdProp(AObject, PropInfo, Longint(Reference));
      end;
    end;
  end;

  procedure SetMethodProp(const AValue: string);
  var
    Method: TMethod;
  begin
    
    if not assigned(AParent) then exit;
    Method.Code := AParent.MethodAddress(AValue);
    if not assigned(Method.Code) then
      raise Exception.Create(sxwInvalidMethodName);
    Method.Data := AParent;
    TypInfo.SetMethodProp(AObject, PropInfo, Method);
  end;

  procedure SetVariantProp(const AValue: string);
  var
    VType: integer;
    Value: Variant;
    ACurrency: Currency;
  begin
    VType := StrToInt(AChildNode.AttributeByName['VarType']);

    case VType and varTypeMask of
    varOleStr:  Value := AChildNode.ValueAsWideString;
    varString:  Value := AChildNode.ValueAsString;
    varByte,
    varSmallInt,
    varInteger: Value := AChildNode.ValueAsInteger;
    varSingle,
    varDouble:  Value := AChildNode.ValueAsFloat;
    varCurrency:
      begin
        AChildNode.BufferWrite(ACurrency, SizeOf(ACurrency));
        Value := ACurrency;
      end;
    varDate:    Value := AChildNode.ValueAsDateTime;
    varBoolean: Value := AChildNode.ValueAsBool;
    else
      try
        Value := ANode.ValueAsString;
      except
        raise Exception.Create(sxwIllegalVarType);
      end;
    end;

    TVarData(Value).VType := VType;
    TypInfo.SetVariantProp(AObject, PropInfo, Value);
  end;

begin
  if (PPropInfo(PropInfo)^.SetProc <> nil) and
    (PPropInfo(PropInfo)^.GetProc <> nil) then
  begin
    PropType := PPropInfo(PropInfo)^.PropType^;
    AChildNode := ANode.NodeByName(PPropInfo(PropInfo)^.Name);
    if assigned(AChildNode) then begin
      
      case PropType^.Kind of
      tkInteger:     SetIntProp(AChildNode.ValueAsString);
      tkChar:        SetCharProp(AChildNode.ValueAsString);
      tkSet:         SetSetProp(AChildNode.ValueAsString);
      tkEnumeration: SetEnumProp(AChildNode.ValueAsString);
      tkFloat:       SetFloatProp(AObject, PropInfo, AChildNode.ValueAsFloat);
      tkString,
      tkLString,
      tkWString:     SetStrProp(AObject, PropInfo, AChildNode.ValueAsString);
      tkClass:       SetObjectProp(AChildNode.ValueAsString);
      tkMethod:      SetMethodProp(AChildNode.ValueAsString);
      tkVariant:     SetVariantProp(AChildNode.ValueAsString);
      tkInt64:       SetInt64Prop(AObject, PropInfo, AChildNode.ValueAsInt64);
      end;
    end else begin
      
      case PropType^.Kind of
      tkInteger:     SetOrdProp(AObject, PropInfo, PPropInfo(PropInfo)^.Default);
      tkChar:        SetOrdProp(AObject, PropInfo, PPropInfo(PropInfo)^.Default);
      tkSet:         SetOrdProp(AObject, PropInfo, PPropInfo(PropInfo)^.Default);
      tkEnumeration: SetOrdProp(AObject, PropInfo, PPropInfo(PropInfo)^.Default);
      tkFloat:       SetFloatProp(AObject, PropInfo, 0);
      tkString,
      tkLString,
      tkWString:     SetStrProp(AObject, PropInfo, '');
      tkClass:
        begin
          PropObject := TObject(GetOrdProp(AObject, PropInfo));
          if PropObject is TComponent then
            SetOrdProp(AObject, PropInfo, 0);
        end;
      tkMethod:
        begin
          Method := TypInfo.GetMethodProp(AObject, PropInfo);
          Method.Code := nil;
          TypInfo.SetMethodProp(AObject, PropInfo, Method);
        end;
      tkInt64:       SetInt64Prop(AObject, PropInfo, 0);
      end;
    end;
  end;
end;


procedure THackComponent.SetComponentState(const AState: TComponentState);
type
  PInteger = ^integer;
var
  PSet: PInteger;
  AInfo: PPropInfo;
begin
  PSet := PInteger(@AState);
  AInfo := GetPropInfo(THackComponent, 'ComponentState');
  if assigned(AInfo.GetProc) then
    PInteger(Integer(Self) + Integer(AInfo.GetProc) and $00FFFFFF)^ := PSet^;
end;

initialization



end.

