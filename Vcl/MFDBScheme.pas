{*******************************************************************************

项目名称 :ThinkWide基础类
版权所有 (c) 2005 ThinkWide
+-------------------------------------------------------------------------------
项目:


版本: 1


创建日期:2005-1-5 19:02:09


作者: 章称(Andyzhang)

+-------------------------------------------------------------------------------
描述:

更新:   -2005-1-5 19:02:09  创建构思
	目的 1) 实现卡片式   工程卡计划管理  (首先实现)
	     2) 实现干特图式 工程卡计划管理  (以后实现)
	     3) 纯Windows VCL 组件实现
	     4) 实现智能化的排缸算法

	-2005-1-7  编写  TGraphScrollBar  类
	-2005-1-10 完成  TGraphScrollBar  类 
	-2005-1-20 编写  TPlanCrockCenter 类 排缸界面实现类
	-2005-2-8  完成  TPlanCrockCenter 类
	-2005-2-9  编写  TMFMacList,TMFCard 排缸控制类

重构:   -2006-6-10     重构类 以及 类关系

	-2006-7-28  创建  TMFDBCustomScheme
	-2006-7-29  创建写  TMFDBCardSchemeView
	-2006-7-29  创建  TMFDBGunterSchemeView
	-2006-7-29  创建  TSchemeNodeDataLink,TSchemeItemDataLink
	-2006-7-29  编写  TSchemeFeildItem
	-2006-7-29  编写  TSchemeFeilds
	-2006-7-29  编写  TSchemeViewFeildItem
	-2006-7-29  编写  TSchemeViewFeilds
	-2006-7-31  完善  TMFDBCustomScheme

ToDo:

*******************************************************************************}

unit MFDBScheme;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls,ImgList,StrUtils,
  StdCtrls,Forms,ExtCtrls,Graphics,Dialogs ,CommCtrl,ComCtrls,DateUtils,
  MFBaseScheme,MFPaint,MFBaseSchemePainter,MFBaseSchemeCommon,
  DB,MFScheme,Variants,MFGunterSchemeView,MFCardSchemeView,Types;

type
  TMFDBScheme = class;
  TSchemeViewFeildItem=class;
  TMFDBCardSchemeView=class;
  
  TNodeRec=record
    KeyField:Variant;
    NodeType:TNodeType;
    BookMark:TBookmark;
  end;

  PNodeRec=^TNodeRec;

  TItemRec=record
    KeyField:Variant;
    ItemField:array of Variant;
    BookMark:TBookmark;
  end;

  PItemRec=^TItemRec;

  TSchemeFeildItem=class;

  TSchemeNodeDataLink = class(TDataLink)
  private
    FScheme: TMFDBScheme;
    FFieldCount: Integer;
    FModified: Boolean;
    function GetFields(Value: String): TField;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  public
    constructor Create(Scheme: TMFDBScheme);
    destructor Destroy; override;
    procedure Modified;
    procedure Reset;
    property FieldCount: Integer read FFieldCount;
    property Fields[Value:String]: TField read GetFields;
    property Scheme: TMFDBScheme read FScheme;
  end;

  TSchemeItemDataLink = class(TDataLink)
  private
    FScheme: TMFDBScheme;
    FFieldCount: Integer;
    FModified: Boolean;
    function GetFields(Value: String): TField;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  public
    constructor Create(Scheme: TMFDBScheme);
    destructor Destroy; override;
    procedure Modified;
    procedure Post;
    property FieldCount: Integer read FFieldCount;
    property Fields[Value:String]: TField read GetFields;
    property Scheme: TMFDBScheme read FScheme;
  end;


  TSchemeFeilds=class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSchemeFeildItem;
    procedure SetItem(Index: Integer; const Value: TSchemeFeildItem);
  public
    function Add: TSchemeFeildItem;
    property Items[Index: Integer]: TSchemeFeildItem read GetItem write SetItem; default;
  end;

  TSchemeFeildItem=class(TCollectionItem)
  private
    FFieldName: String;
    FFieldType: TSchemeFeildType;
    procedure SetFieldName(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy; override;
  published
    property  FieldName: String read FFieldName write SetFieldName;
    property  FieldType: TSchemeFeildType read FFieldType write FFieldType;
  end;


  TSchemeViewFeilds=class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSchemeViewFeildItem;
    procedure SetItem(Index: Integer; const Value: TSchemeViewFeildItem);
  public
    function Add: TSchemeViewFeildItem;
    property Items[Index: Integer]: TSchemeViewFeildItem read GetItem write SetItem; default;
  end;

  TSchemeViewFeildItem=class(TCollectionItem)
  private
    FVisible: Boolean;
    FWidth: Integer;
    FFieldName: String;
    FCaption: String;
    FFont: TFont;
    FHeight: Integer;
    FLeft: Integer;
    FTop: Integer;
    FPlaceType: TPlaceType;
    FViewType: TViewType;
    FUnitText: String;
    FDateTimeFormat: String;
    procedure SetFieldName(const Value: String);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetFont(const Value: TFont);
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetDateTimeFormat(const Value: String);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy; override;
  published
    property  Caption:String read FCaption write FCaption;
    property  UnitText:String read FUnitText write FUnitText;
    property  Top: Integer read FTop write SetTop;
    property  Left: Integer read FLeft write SetLeft;
    property  Width: Integer read FWidth write SetWidth;
    property  Height: Integer read FHeight write SetHeight;
    property  Visible: Boolean read FVisible write SetVisible;
    property  FieldName: String read FFieldName write SetFieldName;
    property  Font: TFont read FFont write SetFont;
    property  ViewType: TViewType read FViewType write FViewType;
    property  PlaceType: TPlaceType read FPlaceType write FPlaceType;
    property  DateTimeFormat:String read FDateTimeFormat write SetDateTimeFormat;
  end;


  TMFDBScheme = class(TMFScheme)
  private
    FSchemeFeilds: TSchemeFeilds;
    FNodeFormat:string;
    FNodeDataLink:TSchemeNodeDataLink;
    FItemDataLink:TSchemeItemDataLink;
    FTreeKeyFieldName: string;
    FNodeGroupBy: String;
    FItemKeyFieldName: string;
    FItemRelationKeyFieldName: string;
    FISUpdateDB:Boolean;
    procedure SetItemDataSource(const Value: TDataSource);
    procedure SetTreeDataSource(const Value: TDataSource);
    procedure SetTreeKeyFieldName(const Value: string);
    procedure SetSchemeFeilds(const Value: TSchemeFeilds);
    function GetItemDataSource: TDataSource;
    function GetTreeDataSource: TDataSource;
    procedure SetItemKeyFieldName(const Value: string);
    procedure SetItemRelationKeyFieldName(const Value: string);

  protected
    //Tree
    procedure TreeActiveChanged;
    procedure TreeDataChanged;
    procedure TreeEditingChanged;
    procedure TreeRecordChanged(Field: TField);

    procedure ItemActiveChanged;
    procedure ItemDataChanged;
    procedure ItemEditingChanged;
    procedure ItemRecordChanged(Field: TField);
    procedure ItemUpdateData;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdateDB;
    procedure EndUpdateDB;
    procedure RefreshNode;
    procedure RefreshItem;
    function GetNodeCaption:string;
    function FindRecord(ADataItem: TMFSchemeDataItem):Boolean;
    function FindDataItem(Key:String):TMFSchemeDataItem;
    procedure UpdateDB(ADataItem: TMFSchemeDataItem);
    procedure UpdateDataItem(ADataItem: TMFSchemeDataItem;Field: TField=nil);
    function DeleteItem(ADataItem: TMFSchemeDataItem):Boolean;
    function DeleteSelectionItems:Boolean;
    function GetNodeItem(KeyValue:Variant):TMFSchemeDataItem;
    function GetTreeNode(KeyValue:Variant):TMFSchemeDataTreeNode;
    function GetParentTreeNode(KeyValue:Variant):TMFSchemeDataTreeNode;
    function GetItemFieldData(Item: TMFSchemeDataItem;
      FieldName: String): Variant;
  published
    property ItemRelationKeyField: string read FItemRelationKeyFieldName write SetItemRelationKeyFieldName;
    property ItemKeyField: string read FItemKeyFieldName write SetItemKeyFieldName;
    property TreeKeyField: string read FTreeKeyFieldName write SetTreeKeyFieldName;
    property TreeDataSource: TDataSource read GetTreeDataSource write SetTreeDataSource;
    property ItemDataSource: TDataSource read GetItemDataSource write SetItemDataSource;
    property NodeFormat:String read FNodeFormat write FNodeFormat;
    property NodeGroupBy:String read FNodeGroupBy write FNodeGroupBy;
    property SchemeFeilds:TSchemeFeilds read FSchemeFeilds write SetSchemeFeilds;
  end;


  TMFDBGunterSchemeView=class(TMFGunterSchemeView)
  private
    FSchemeViewFeilds: TSchemeViewFeilds;
    FDefaultNodeHight: Integer;
    FCardView:TMFDBCardSchemeView;
    procedure SetSchemeViewFeilds(const Value: TSchemeViewFeilds);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function GetItemFieldData(Item: TMFSchemeDataItem;
      FieldName: String): Variant;
  public
    procedure InIt;override;
    destructor Destroy; override;
    procedure DragItemOver(Source: TObject;DragItem:TMFSchemeDataItem;
      NewNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer);override;
    procedure SetNodeHeight(ANode:TMFSchemeTreeNode;var NodeHeight:Integer);override;
    procedure PaintItem(Sender:TObject;Item:TMFSchemeDataItem;
      ACanvas:TCanvas;R:TRect);override;

    procedure AfterDragItemDown(Source: TObject;DragItem:TMFSchemeDataItem;
      OldNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer);override;

    procedure AfterItemTimeChange(DataItem:TMFSchemeDataItem;
      ItemTimeChangeType:TItemTimeChangeType);override;
    procedure SetHintData(Sender: TObject; AViewHitInfo: TViewHitInfo;
      var HintRec: THintRec; var R: TRect; ACanvas: TCanvas);override;
    procedure DragHint(Sender:TObject;ADateTime:TDateTime;AItem:TMFSchemeDataItem;AViewHitInfo:TViewHitInfo;
      var HintRec:THintRec;var ARect:TRect; ACanvas: TCanvas);override;
  published
    property CardView:TMFDBCardSchemeView read FCardView write FCardView;
    property SchemeViewFeilds:TSchemeViewFeilds read FSchemeViewFeilds write SetSchemeViewFeilds;
    property DefaultNodeHight:Integer read FDefaultNodeHight write FDefaultNodeHight;
  end;

  TMFDBCardSchemeView=class(TMFCardSchemeView)
  private
    FSchemeViewFeilds: TSchemeViewFeilds;
    FGroupHight: Integer;
    FCardHight: Integer;
    procedure SetSchemeViewFeilds(const Value: TSchemeViewFeilds);

  protected

  public
    procedure InIt;override;
    destructor Destroy; override;
    procedure DragItemOver(Source: TObject;DragItem:TMFSchemeDataItem;
      NewNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer);override;
    procedure SetNodeHeight(ANode:TMFSchemeTreeNode;var NodeHeight:Integer);override;
    procedure PaintHintItem(Sender:TObject;Item:TMFSchemeDataItem;
      ACanvas:TCanvas;R:TRect);
    procedure PaintItem(Sender:TObject;Item:TMFSchemeDataItem;
      ACanvas:TCanvas;R:TRect);override;
    procedure AfterDragItemDown(Source: TObject;DragItem:TMFSchemeDataItem;
      OldNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer);override;
    procedure SetHintData(Sender: TObject; AViewHitInfo:TViewHitInfo;
      var HintRec:THintRec; var R: TRect; ACanvas: TCanvas); override;
  published
    property SchemeViewFeilds:TSchemeViewFeilds read FSchemeViewFeilds write SetSchemeViewFeilds;
    property CardHight:Integer read FCardHight write FCardHight;
    property GroupHight:Integer read FGroupHight write FGroupHight;
  end;

implementation

{ TSchemeFeilds }

function VarEquals(const V1, V2: Variant): Boolean;
begin
  try
    Result := V1 = V2;
  except
    Result := False;
  end;
end;

function TSchemeFeilds.Add: TSchemeFeildItem;
begin
  Result:= TSchemeFeildItem(inherited Add );
end;

function TSchemeFeilds.GetItem(Index: Integer): TSchemeFeildItem;
begin
  Result:= TSchemeFeildItem(inherited GetItem(Index) );
end;

procedure TSchemeFeilds.SetItem(Index: Integer;
  const Value: TSchemeFeildItem);
begin
  inherited SetItem(Index,Value);
end;

{ TSchemeFeildItem }

constructor TSchemeFeildItem.Create(Collection: TCollection);
begin
  inherited;

end;

destructor TSchemeFeildItem.Destroy;
begin

  inherited;
end;

function TSchemeFeildItem.GetDisplayName: string;
begin
  if FFieldName<>'' then
    Result :=FFieldName
  else
    Result :='TSchemeFeildItem';
end;

procedure TSchemeFeildItem.SetFieldName(const Value: String);
begin
  FFieldName := Value;
end;


{ TMFDBCustomScheme }

constructor TMFDBScheme.Create(AOwner: TComponent);
begin
  inherited;
  FNodeDataLink:=TSchemeNodeDataLink.Create(Self);
  FItemDataLink:=TSchemeItemDataLink.Create(Self);
  FSchemeFeilds:=TSchemeFeilds.Create(Self,TSchemeFeildItem);

end;

destructor TMFDBScheme.Destroy;
begin
  FNodeDataLink.Free;
  FItemDataLink.Free;
  FSchemeFeilds.Free;

  inherited;
end;

function TMFDBScheme.GetItemDataSource: TDataSource;
begin
  Result:= FItemDataLink.DataSource;
end;

function TMFDBScheme.GetNodeCaption: string;

  function GetFormatField(Text:String):string;
  var I,J:integer;bIn:Boolean;
    Str,StrField,sField:string;
    Field:TField;
  begin
    i:=0;
    bIn:=False;
    while i<=Length(Text) do
    begin
      if Text[i]='[' then bIn:=True;

      if bIn then
      begin
	StrField:=StrField+Text[i];

      end;

      if not bIn then Str:=Str+Text[i];

      if Text[i]=']' then
      begin
	bIn:=False;
	sField:=Copy(StrField,2,Length(StrField)-2);
	Field:=FNodeDataLink.DataSet.FindField(sField);
	if Field<>nil then
	  Str:=Str+Field.AsString
	else
	  Str:=Str+StrField;
	StrField:='';
      end;

      Inc(i);
    end;
    Result:=Str;

  end;
begin
  Result:=GetFormatField(NodeFormat);
end;

function TMFDBScheme.GetNodeItem(KeyValue: Variant): TMFSchemeDataItem;
var i:Integer;
begin
  Result:=nil;
  i:=0;
  while I<FSchemeDataTree.DataItemCount do
  begin
    if VarEquals(KeyValue,
      PItemRec(FSchemeDataTree.DataItems[I].SysData).KeyField) then
    begin
      Result:= FSchemeDataTree.DataItems[I];
      Break;
    end;

    Inc(i);
  end;
end;

function TMFDBScheme.GetParentTreeNode(
  KeyValue: Variant): TMFSchemeDataTreeNode;
var i:Integer;
begin
  Result:=nil;
  i:=0;
  while I<FSchemeDataTree.Count do
  begin
    if PNodeRec(FSchemeDataTree.Items[I].Data).NodeType=tnpFolder then
    if VarEquals(KeyValue,
      PNodeRec(FSchemeDataTree.Items[I].Data).KeyField) then
    begin
      Result:= FSchemeDataTree.Items[I];
      Break;
    end;

    Inc(i);
  end;
end;

function TMFDBScheme.GetTreeDataSource: TDataSource;
begin
  Result:= FNodeDataLink.DataSource;
end;

function TMFDBScheme.GetTreeNode(KeyValue: Variant): TMFSchemeDataTreeNode;
var i:Integer;
begin
  Result:=nil;
  i:=0;
  while I<FSchemeDataTree.Count do
  begin

    if VarEquals(KeyValue,
      PNodeRec(FSchemeDataTree.Items[I].Data).KeyField) then
    begin
      Result:= FSchemeDataTree.Items[I];
      Break;
    end;

    Inc(i);
  end;
end;

procedure TMFDBScheme.ItemActiveChanged;
begin
  FSchemeDataTree.ClearItem;
  if FItemDataLink.DataSet.Active then
  with FItemDataLink.DataSet do
  begin

    DisableControls;
    BeginUpdate;
    First;

    while not Eof do
    begin
      RefreshItem;
      Next;
    end;
    
    EnableControls;
    EndUpdate;
  end;
end;

procedure TMFDBScheme.ItemDataChanged;
var I:Integer;
begin

  with FSchemeDataTree do
  begin
    if  FItemDataLink.DataSet.RecordCount<DataItemCount then
    begin
      try
	FItemDataLink.DataSet.DisableControls;
	for I:=DataItemCount-1 downto 0 do
	begin
          if FItemDataLink.DataSet.IsEmpty then
          begin
            DataItems[I].Free;

          end
          else
          begin
            if FItemDataLink.DataSet.BookmarkValid(PItemRec(DataItems[I].SysData).BookMark) then
            begin

              FItemDataLink.DataSet.GotoBookmark(PItemRec(DataItems[I].SysData).BookMark);
              if PItemRec(DataItems[I].SysData).KeyField <> FItemDataLink.DataSet.FieldByName(ItemKeyField).Value then
                DataItems[I].Free;
            end
            else
              DataItems[I].Free;
          end;
	end;
      finally
	FItemDataLink.DataSet.EnableControls;
      end;
    end;
    //if FItemDataLink.DataSet.State= dsInsert then
    if  FItemDataLink.DataSet.RecordCount>DataItemCount then
    begin
      RefreshItem;
    end;
  end;
end;

procedure TMFDBScheme.ItemEditingChanged;
begin

end;

procedure TMFDBScheme.ItemRecordChanged(Field: TField);
var AItem:TMFSchemeDataItem;
begin
  AItem:=GetNodeItem(FItemDataLink.DataSet.FieldValues[ItemKeyField]);
  if (AItem<>nil) and (Field<>nil) then
    UpdateDataItem(AItem,Field);
end;

procedure TMFDBScheme.ItemUpdateData;
begin

end;

procedure TMFDBScheme.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation=opRemove then
  begin
    if (FNodeDataLink <> nil) and (AComponent =TreeDataSource)
      then TreeDataSource:=nil;

    if (FItemDataLink <> nil) and (AComponent =ItemDataSource)
      then ItemDataSource:=nil;

  end;
end;

procedure TMFDBScheme.UpdateDataItem(ADataItem:TMFSchemeDataItem;Field: TField=nil);
var
  I:Integer;AData:Variant;Node:TMFSchemeDataTreeNode;

  procedure SetData(Index:integer);
  begin
    AData:= FItemDataLink.DataSet.FieldByName(FSchemeFeilds.Items[Index].FieldName).Value;
    PItemRec(ADataItem.SysData).ItemField[Index]:=AData;
    
    case FSchemeFeilds.Items[Index].FieldType of
      tfpBegin    : ADataItem.BeginDate:=VarToDateTime(AData);

      tfpInterval : ADataItem.IntervalDate:=VarToDateTime(AData);

      tfpEnd      : ADataItem.IntervalDate:=VarToDateTime(AData)-ADataItem.BeginDate;

      tfpText     : ADataItem.Text :=VarToStr(AData)  ;

      tfpBackColor: ADataItem.Color:= VarToColor(AData);

      tfpPercent  : ADataItem.Percent:=VarToFloat(AData)

    end;
  end;
begin
  PItemRec(ADataItem.SysData).BookMark:=FItemDataLink.DataSet.GetBookmark;

  for i:=0 to FSchemeFeilds.Count-1 do
  begin
    if Field=nil then
      SetData(I)
    else
    if CompareText(Field.FieldName,FSchemeFeilds.Items[I].FieldName)=0 then
    begin
      SetData(I);      
    end;
  end;
  //if Field<>nil then
  if Field=FItemDataLink.DataSet.FieldByName(ItemRelationKeyField) then
  begin
    if PNodeRec(ADataItem.Parent.Data).KeyField<>
      Field.Value then
    begin
      Node:=GetTreeNode(Field.Value);
      if  Node<>nil then
       ADataItem.MoveTo(Node);
    end;
  end;
end;

procedure TMFDBScheme.RefreshItem;
var
  PNode:TMFSchemeDataTreeNode;
  Item:TMFSchemeDataItem;
  NodeGroupCaption :Variant;
  P:PItemRec;
begin
  Item:=GetNodeItem(FItemDataLink.DataSet.FindField(FItemKeyFieldName).Value);
  if Item<>nil then
    UpdateDataItem(Item)
  else
  begin
    PNode:=GetTreeNode(FItemDataLink.DataSet.FindField(ItemRelationKeyField).Value);
    if PNode<>nil then
    begin
      New(P);
      P.KeyField := FItemDataLink.DataSet.FindField(FItemKeyFieldName).Value;
      SetLength(P.ItemField,FSchemeFeilds.Count);

      Item:=PNode.AddDataItem;
      Item.SysData:=P;
      UpdateDataItem(Item);

    end;

  end;

end;

procedure TMFDBScheme.RefreshNode;
var Node,PNode:TMFSchemeDataTreeNode;
    Caption:string;DefaultHeight:Integer;
    NodeGroupCaption :Variant;
    P,PN:PNodeRec;
begin
  DefaultHeight:=50;
  if ActiveSchemeView<>nil then
    DefaultHeight:=ActiveSchemeView.IndicaterOptions.DefaultHeight;
  Node:=GetTreeNode(FNodeDataLink.DataSet.FindField(FTreeKeyFieldName).Value);
  Caption:=GetNodeCaption;
  if Node<>nil then
    Node.Caption:=Caption
  else
  begin
    New(P);
    P.NodeType := tnpItem;
    P.KeyField :=FNodeDataLink.DataSet.FindField(TreeKeyField).Value;
    if Trim(NodeGroupBy)<>'' then
    begin
      NodeGroupCaption:=FNodeDataLink.DataSet.FindField(FNodeGroupBy).Value;
      PNode:=GetParentTreeNode(NodeGroupCaption) ;

      if PNode=nil then
      begin
	New(PN);
	PN.KeyField:=NodeGroupCaption;
	PN.NodeType:=tnpFolder;
	PNode:=FSchemeDataTree.AddNodeObject(nil,vartostr( NodeGroupCaption),DefaultHeight,PN);
      end;
      FSchemeDataTree.AddNodeObject(PNode,Caption,DefaultHeight,P);

    end
    else
      FSchemeDataTree.AddNodeObject(nil,Caption,DefaultHeight,P);

  end;

end;

procedure TMFDBScheme.SetItemDataSource(const Value: TDataSource);
begin
  if ItemDataSource<>Value then
  begin
    FItemDataLink.DataSource := Value;
    if  Value<>nil then
      Value.FreeNotification(self);
  end;
end;

procedure TMFDBScheme.SetItemKeyFieldName(const Value: string);
begin
  FItemKeyFieldName := Value;
end;

procedure TMFDBScheme.SetSchemeFeilds(const Value: TSchemeFeilds);
begin
  FSchemeFeilds.Assign(Value);
end;

procedure TMFDBScheme.SetTreeDataSource(const Value: TDataSource);
begin
  if TreeDataSource<>Value then
  begin
    FNodeDataLink.DataSource := Value;
    if  Value<>nil then
      Value.FreeNotification(self);
  end;
end;

procedure TMFDBScheme.SetTreeKeyFieldName(const Value: string);
begin
  FTreeKeyFieldName := Value;
end;

procedure TMFDBScheme.TreeActiveChanged;
begin
  FSchemeDataTree.Clear;
  if FNodeDataLink.DataSet.Active then
  with FNodeDataLink.DataSet do
  begin
    
    DisableControls;
    BeginUpdate;
    First;

    while not Eof do
    begin
      RefreshNode;
      Next;
    end;
    
    EnableControls;
    EndUpdate;
  end;  
end;

procedure TMFDBScheme.TreeDataChanged;
begin

end;

procedure TMFDBScheme.TreeEditingChanged;
begin

end;

procedure TMFDBScheme.TreeRecordChanged(Field: TField);
begin

end;

{ TSchemeViewFeildItem }

constructor TSchemeViewFeildItem.Create(Collection: TCollection);
begin
  inherited;
  FFont:=TFont.Create;
  FVisible:=True;
  FDateTimeFormat:='mm-dd hh:nn';
end;

destructor TSchemeViewFeildItem.Destroy;
begin
  FFont.Free;
  inherited;
end;

function TSchemeViewFeildItem.GetDisplayName: string;
begin
  if FFieldName<>'' then
    Result:=FFieldName
  else
    Result:='TSchemeViewFeildItem';
end;

procedure TSchemeViewFeildItem.SetDateTimeFormat(const Value: String);
begin
  FDateTimeFormat := Value;
end;

procedure TSchemeViewFeildItem.SetFieldName(const Value: String);
begin
  FFieldName:=Value;
end;

procedure TSchemeViewFeildItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TSchemeViewFeildItem.SetHeight(const Value: Integer);
begin
  FHeight := Value;
end;

procedure TSchemeViewFeildItem.SetLeft(const Value: Integer);
begin
  FLeft := Value;
end;

procedure TSchemeViewFeildItem.SetTop(const Value: Integer);
begin
  FTop := Value;
end;

procedure TSchemeViewFeildItem.SetVisible(const Value: Boolean);
begin
  FVisible:= Value;
end;

procedure TSchemeViewFeildItem.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ TMFDBGunterSchemeView }

destructor TMFDBGunterSchemeView.Destroy;
begin
  FSchemeViewFeilds.Free;
  inherited;
end;

procedure TMFDBGunterSchemeView.DragItemOver(Source: TObject;
  DragItem: TMFSchemeDataItem; NewNode: TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  inherited;
  if NewNode<>nil then
  begin
    Accept := PNodeRec(NewNode.Data).NodeType<>tnpFolder;

  end;
end;

procedure TMFDBGunterSchemeView.InIt;
begin
  inherited;
  FDefaultNodeHight:=20;
  FSchemeViewFeilds:=TSchemeViewFeilds.Create(Self,TSchemeViewFeildItem);
end;

function TMFDBGunterSchemeView.GetItemFieldData(Item: TMFSchemeDataItem;FieldName:String):Variant;
var I:Integer;
begin
  Result:=Null;
  with TMFDBScheme(ParentScheme).SchemeFeilds do
  for I:=0 to Count-1  do
  begin
    if Items[i].FieldName=FieldName then
    begin
      Result:=PItemRec(Item.SysData).ItemField[i];
      Break;
    end;
  end;
end;

procedure TMFDBGunterSchemeView.PaintItem(Sender: TObject;
  Item: TMFSchemeDataItem; ACanvas: TCanvas; R: TRect);
var
  I,iTop,iHeight,iLeft,iWidth:Integer;
  VData:Variant;Str:String;
  RClient,RText:TRect;
  BackColor:TColor;

  function DrawBackColor(Var AColor:TColor):Boolean;
  var I:integer;
  begin
    Result:=False;
    with SchemeViewFeilds  do
    if not Item.Selected then
      For i:=0 to Count-1 do
	if (Items[i].Visible) and (Items[i].ViewType=tvBackColor) then
	begin
	  VData:=GetItemFieldData(Item,Items[i].FieldName);
	  AColor:=VarToInt(VData);
	  ACanvas.Brush.Style :=bsSolid;
	  ACanvas.Brush.Color:=AColor;
	  ACanvas.FillRect(R);
	  Result:=True;
	end;
  end;

  {function DrawProgress(Var AColor:TColor):Boolean;
  var I:integer;ipTop,ipBottom,ipRight:integer;
  begin
    Result:=False;
    with SchemeViewFeilds  do
      if not Item.Selected then
      For i:=0 to Count-1 do
	if (Items[i].Visible) and (Items[i].ViewType=tvPercent) then
	begin
	  VData:=GetItemFieldData(Item,Items[i].FieldName);
	  ACanvas.Brush.Style :=bsSolid;
	  ACanvas.Brush.Color:=InvertColor(AColor);

	  ipTop:=R.Top+ Items[i].Top;
	  ipBottom:=ipTop+ Items[i].Height;
	  ipRight:=R.Left+trunc((R.Right -R.Left)* VarToInt(VData)/100);

	  if ipRight>R.Right then
	   ipRight:= R.Right;

	  RText := Rect(R.Left ,ipTop,ipRight,ipBottom );
	  ACanvas.FillRect(RText);
          Result:=True;
	end;
  end; }

begin
  {RClient:=R;
  InflateRect(RClient,-2,-2);
  iTop:=R.top;
  iLeft:=R.Left ;

  with SchemeViewFeilds  do
  begin

    // Draw BackColor
    if DrawBackColor(BackColor) then
      DrawProgress(BackColor);

    // Draw Text
    For i:=0 to Count-1 do
    if Items[i].Visible then
    begin
      ACanvas.Font.Assign(SchemeViewFeilds.Items[i].Font);
      ACanvas.Brush.Style:=bsClear; 
      VData:=GetItemFieldData(Item,Items[i].FieldName);
      Str:=Items[i].Caption+VarToStr(VData)+Items[i].UnitText;
      iHeight:=ACanvas.TextHeight('A');
      iWidth:=ACanvas.TextWidth(Str);

      Rtext:=Rect(iLeft,iTop,iLeft+iWidth+3,iTop+iHeight+3);
      IntersectRect(Rtext,Rtext,RClient);

      case Items[i].ViewType of
	tvText :
	  DrawText(ACanvas.Handle,PChar(Str),Length(Str),Rtext,DT_END_ELLIPSIS );

	tvColor: ;

      end;

      Case Items[i].PlaceType of
	ptAutoLine :begin
		      iTop:= iHeight + iTop+3;
		      iLeft:=R.Left;
		    end;

	ptAfter    :begin
		      iTop:= iHeight + iTop+3;
		      iLeft:=iLeft+iWidth+2;
		    end;

	ptPlace    :begin
		      iTop:= Items[i].Top;
		      iLeft:= Items[i].Left;

		    end;

      end;

    end;

  end;}

  inherited;
end;

procedure TMFDBGunterSchemeView.SetNodeHeight(ANode: TMFSchemeTreeNode;
  var NodeHeight: Integer);
begin
  NodeHeight:=FDefaultNodeHight;
  inherited;
end;

procedure TMFDBGunterSchemeView.SetSchemeViewFeilds(
  const Value: TSchemeViewFeilds);
begin
  FSchemeViewFeilds.Assign(Value);
end;

procedure TMFDBGunterSchemeView.AfterItemTimeChange(
  DataItem: TMFSchemeDataItem; ItemTimeChangeType: TItemTimeChangeType);
begin
  TMFDBScheme(ParentScheme).UpdateDB(DataItem);
end;

procedure TMFDBGunterSchemeView.AfterDragItemDown(Source: TObject;
  DragItem: TMFSchemeDataItem; OldNode: TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  inherited;
  TMFDBScheme(ParentScheme).UpdateDB(DragItem);
end;

procedure TMFDBGunterSchemeView.SetHintData(Sender: TObject;
  AViewHitInfo: TViewHitInfo; var HintRec: THintRec; var R: TRect;
  ACanvas: TCanvas);
begin
  inherited;
  if AViewHitInfo.AItem <>nil then
  if CardView<>nil then
  begin
    HintRec.HintType := htImage;
    R:=Rect(0,0,CardView.ContentOptions.CardWidth,CardView.CardHight);
    CardView.PaintHintItem(Self,AViewHitInfo.AItem,ACanvas,R);
  end;
end;
procedure TMFDBGunterSchemeView.DragHint(Sender: TObject;
  ADateTime: TDateTime; AItem: TMFSchemeDataItem;
  AViewHitInfo: TViewHitInfo; var HintRec: THintRec; var ARect: TRect;
  ACanvas: TCanvas);
begin
  
  HintRec.HintStr:= '开始时间:'+FormatDateTime('mm-dd HH:MM',ADateTime)+#13+
  '结束时间:'+FormatDateTime('mm-dd HH:MM',ADateTime+AItem.IntervalDate)  ;
  ARect.Right :=ARect.Left+10 +
  ACanvas.TextWidth('开始时间:'+FormatDateTime('mm-dd HH:MM',ADateTime));
  inherited;
end;

procedure TMFDBGunterSchemeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation=opRemove then
  begin
    if (FCardView <> nil) and (AComponent =FCardView)
      then FCardView:=nil;

  end;
end;

{ TMFDBCardSchemeView }

procedure TMFDBCardSchemeView.AfterDragItemDown(Source: TObject;
  DragItem: TMFSchemeDataItem; OldNode: TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  inherited;
  TMFDBScheme(ParentScheme).UpdateDB(DragItem);
end;

destructor TMFDBCardSchemeView.Destroy;
begin
  FSchemeViewFeilds.Free;
  inherited;
end;

procedure TMFDBCardSchemeView.DragItemOver(Source: TObject;
  DragItem: TMFSchemeDataItem; NewNode: TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  inherited;
  if NewNode<>nil then
  begin
    Accept := PNodeRec(NewNode.Data).NodeType<>tnpFolder;

  end;
end;

procedure TMFDBCardSchemeView.InIt;
begin
  inherited;
  FGroupHight:=20;
  FCardHight:=100;
  FSchemeViewFeilds:=TSchemeViewFeilds.Create(Self,TSchemeViewFeildItem);
end;

procedure TMFDBCardSchemeView.PaintHintItem(Sender: TObject;
  Item: TMFSchemeDataItem; ACanvas: TCanvas; R: TRect);
var
  I,iTop,iHeight,iLeft,iWidth,iAll,iText1,iText2,iText3:Integer;
  VData:Variant;Str:String;
  RClient,RText:TRect;
  BackColor:TColor;

  function DrawBackColor(Var AColor:TColor):Boolean;
  var
    I:integer;
  begin
    Result:=False;
    AColor:=clInfoBk;
    with TMFDBScheme(ParentScheme),SchemeViewFeilds  do
    begin

      ACanvas.Pen.Style:=psSolid;
      ACanvas.Pen.Mode:=pmCopy;
      ACanvas.Pen.Color:=clBtnShadow;
      ACanvas.Brush.Style :=bsSolid;
      ACanvas.Brush.Color:=AColor;
      ACanvas.FillRect(R); 
      //ACanvas.Rectangle(R);
      Result:=True;

    end;
  end;

  function DrawProgress(Var AColor:TColor):Boolean;
  var I:integer;ipTop,ipBottom,ipRight:integer;
  begin
    {Result:=False;
    with TMFDBScheme(ParentScheme),SchemeViewFeilds  do
      if not Item.Selected then
      For i:=0 to Count-1 do
	if (Items[i].Visible) and (Items[i].ViewType=tvPercent) then
	begin
	  VData:=GetItemFieldData(Item,Items[i].FieldName);
	  ACanvas.Brush.Style :=bsSolid;
	  ACanvas.Brush.Color:=InvertColor(AColor);

	  ipTop:=R.Top+ Items[i].Top;
	  ipBottom:=ipTop+ Items[i].Height;
	  ipRight:=R.Left+Trunc((R.Right -R.Left)* VarToInt(VData)/100);

	  if ipRight>R.Right then
	   ipRight:= R.Right;

	  RText := Rect(R.Left ,ipTop,ipRight,ipBottom );
	  ACanvas.FillRect(RText);
          Result:=True;
	end;}
  end;

begin
  if Item<>nil then
  begin
    RClient:=R;
    //InflateRect(RClient,3,3);
    iTop:=R.top;
    iLeft:=R.Left ;

    with TMFDBScheme(ParentScheme), SchemeViewFeilds  do
    begin

      // Draw BackColor
      if DrawBackColor(BackColor) then
	DrawProgress(BackColor);

      // Draw Text
      ACanvas.Brush.Style:=bsClear;
      For i:=0 to Count-1 do
      if Items[i].Visible then
      begin
	ACanvas.Font.Assign(SchemeViewFeilds.Items[i].Font);
	VData:=GetItemFieldData(Item,Items[i].FieldName);
	Str:=Items[i].Caption+VarToStr(VData)+Items[i].UnitText;
	iHeight:=ACanvas.TextHeight('A');
	iWidth:=ACanvas.TextWidth(Str);

	Rtext:=Rect(iLeft,iTop,iLeft+iWidth+3,iTop+iHeight+3);
	IntersectRect(RText,RText,RClient);

	case Items[i].ViewType of
	  tvDateTime:
	    begin
	      if Trim(Items[i].DateTimeFormat)<>'' then
		Str:=Items[i].Caption+FormatDateTime(Items[i].DateTimeFormat,VarToDateTime(VData))+Items[i].UnitText;
	      DrawText(ACanvas.Handle,PChar(Str),Length(Str),RText,DT_END_ELLIPSIS );

	    end;
	    
	  tvText :
	    begin
	      ACanvas.Brush.Style:=bsClear;
	      DrawText(ACanvas.Handle,PChar(Str),Length(Str),RText,DT_END_ELLIPSIS );
	    end;
	    
	  tvColor:
	    begin
	      iAll:=(RClient.Right - RClient.Left);
	      iText1:=ACanvas.TextWidth(Items[i].Caption)+2;
	      iText2:=ACanvas.TextWidth(Items[i].UnitText)+2;
	      iText3:=iAll-iText1-iText2;

	      RText:=Rect(iLeft,iTop,iLeft+iText1,iTop+iHeight+3);

	      IntersectRect(RText,RText,RClient);
	      DrawText(ACanvas.Handle,PChar(Items[i].Caption),Length(Items[i].Caption),RText,DT_END_ELLIPSIS );


	      RText:=Rect(iLeft+iText1,iTop+1,iLeft+iText1+iText3,iTop+iHeight);
	      IntersectRect(RText,RText,RClient);
	      VData:=GetItemFieldData(Item,Items[i].FieldName);
	      ACanvas.Brush.Style:=bsSolid;
	      ACanvas.Brush.Color:= VarToColor(VData);
	      ACanvas.FillRect(RText);

	      RText:=Rect(iLeft+iText1+iText3,iTop,iLeft+iText1+iText3+iText2,iTop+iHeight+3);
	      IntersectRect(RText,RText,RClient);
	      DrawText(ACanvas.Handle,PChar(Items[i].UnitText),Length(Items[i].UnitText),RText,DT_END_ELLIPSIS );

	    end;

	end;

	if Items[i].ViewType in [tvText,tvColor,tvDateTime]  then
	Case Items[i].PlaceType of
	  ptAutoLine :begin
			iTop:= iHeight + iTop+3;
			iLeft:=R.Left;
		      end;

	  ptAfter    :begin
			//iTop:= iHeight + iTop+3;
			iLeft:=iLeft+iWidth+5;
		      end;

	  ptPlace    :begin
			iTop := Items[i].Top;
			iLeft:= Items[i].Left;
		      end;

	end;

      end;

    end;
  end;
  inherited;
end;

procedure TMFDBCardSchemeView.PaintItem(Sender: TObject;
  Item: TMFSchemeDataItem; ACanvas: TCanvas; R: TRect);
var
  I,iTop,iHeight,iLeft,iWidth,iAll,iText1,iText2,iText3:Integer;
  VData:Variant;Str:String;
  RClient,RText:TRect;
  BackColor:TColor;

  function DrawBackColor(Var AColor:TColor):Boolean;
  var
    I:integer;
  begin
    Result:=False;
    AColor:=clWhite;
    with TMFDBScheme(ParentScheme),SchemeViewFeilds  do
    begin
      For i:=0 to Count-1 do
      begin
	if (Items[i].Visible) and (Items[i].ViewType=tvBackColor) then
	begin
	  AColor:=VarToColor(GetItemFieldData(Item,Items[i].FieldName));
	end;
      end;

      if not Item.Selected then
      begin
	ACanvas.Pen.Style:=psSolid;
	ACanvas.Pen.Mode:=pmCopy;
	ACanvas.Pen.Color:=clBtnShadow; 
	ACanvas.Brush.Style :=bsSolid;
	ACanvas.Brush.Color:=AColor;
	ACanvas.Rectangle(R);
	Result:=True;
      end
      else
      begin
	//VData:=GetItemFieldData(Item,Items[i].FieldName);
	//VarToInt(VData);
	AColor:= clHighlight;
	ACanvas.Brush.Style :=bsSolid;
	ACanvas.Brush.Color:=AColor;
	ACanvas.FillRect(R);
	ACanvas.DrawFocusRect(R);
	Result:=True;
      end;

    end;
  end;

  function DrawProgress(Var AColor:TColor):Boolean;
  var I:integer;ipTop,ipBottom,ipRight:integer;
  begin
    {Result:=False;
    with TMFDBScheme(ParentScheme),SchemeViewFeilds  do
      if not Item.Selected then
      For i:=0 to Count-1 do
	if (Items[i].Visible) and (Items[i].ViewType=tvPercent) then
	begin
	  VData:=GetItemFieldData(Item,Items[i].FieldName);
	  ACanvas.Brush.Style :=bsSolid;
	  ACanvas.Brush.Color:=InvertColor(AColor);

	  ipTop:=R.Top+ Items[i].Top;
	  ipBottom:=ipTop+ Items[i].Height;
	  ipRight:=R.Left+Trunc((R.Right -R.Left)* VarToInt(VData)/100);

	  if ipRight>R.Right then
	   ipRight:= R.Right;

	  RText := Rect(R.Left ,ipTop,ipRight,ipBottom );
	  ACanvas.FillRect(RText);
          Result:=True;
	end;}
  end;

begin
  if Item<>nil then
  begin
    RClient:=R;
    InflateRect(RClient,-3,-3);
    iTop:=R.top;
    iLeft:=R.Left ;

    with TMFDBScheme(ParentScheme), SchemeViewFeilds  do
    begin

      // Draw BackColor
      if DrawBackColor(BackColor) then
	DrawProgress(BackColor);

      // Draw Text
      ACanvas.Brush.Style:=bsClear;
      For i:=0 to Count-1 do
      if Items[i].Visible then
      begin
	ACanvas.Font.Assign(SchemeViewFeilds.Items[i].Font);
	VData:=GetItemFieldData(Item,Items[i].FieldName);
	Str:=Items[i].Caption+VarToStr(VData)+Items[i].UnitText;
	iHeight:=ACanvas.TextHeight('A');
	iWidth:=ACanvas.TextWidth(Str);

	Rtext:=Rect(iLeft,iTop,iLeft+iWidth+3,iTop+iHeight+3);
	IntersectRect(RText,RText,RClient);

	case Items[i].ViewType of
	  tvDateTime:
	    begin
	      if Trim(Items[i].DateTimeFormat)<>'' then
		Str:=Items[i].Caption+FormatDateTime(Items[i].DateTimeFormat,VarToDateTime(VData))+Items[i].UnitText;
	      DrawText(ACanvas.Handle,PChar(Str),Length(Str),RText,DT_END_ELLIPSIS );

	    end;
	    
	  tvText :
	    begin
	      ACanvas.Brush.Style:=bsClear;
	      DrawText(ACanvas.Handle,PChar(Str),Length(Str),RText,DT_END_ELLIPSIS );
	    end;
	    
	  tvColor:
	    begin
	      iAll:=(RClient.Right - RClient.Left);
	      iText1:=ACanvas.TextWidth(Items[i].Caption)+2;
	      iText2:=ACanvas.TextWidth(Items[i].UnitText)+2;
	      iText3:=iAll-iText1-iText2;

	      RText:=Rect(iLeft,iTop,iLeft+iText1,iTop+iHeight+3);

	      IntersectRect(RText,RText,RClient);
	      DrawText(ACanvas.Handle,PChar(Items[i].Caption),Length(Items[i].Caption),RText,DT_END_ELLIPSIS );


	      RText:=Rect(iLeft+iText1,iTop+1,iLeft+iText1+iText3,iTop+iHeight);
	      IntersectRect(RText,RText,RClient);
	      VData:=GetItemFieldData(Item,Items[i].FieldName);
	      ACanvas.Brush.Style:=bsSolid;
	      ACanvas.Brush.Color:= VarToColor(VData);
	      ACanvas.FillRect(RText);

	      RText:=Rect(iLeft+iText1+iText3,iTop,iLeft+iText1+iText3+iText2,iTop+iHeight+3);
	      IntersectRect(RText,RText,RClient);
	      DrawText(ACanvas.Handle,PChar(Items[i].UnitText),Length(Items[i].UnitText),RText,DT_END_ELLIPSIS );

	    end;

	end;

	if Items[i].ViewType in [tvText,tvColor,tvDateTime]  then
	Case Items[i].PlaceType of
	  ptAutoLine :begin
			iTop:= iHeight + iTop+3;
			iLeft:=R.Left;
		      end;

	  ptAfter    :begin
			//iTop:= iHeight + iTop+3;
			iLeft:=iLeft+iWidth+5;
		      end;

	  ptPlace    :begin
			iTop := Items[i].Top;
			iLeft:= Items[i].Left;
		      end;

	end;

      end;

    end;
  end;
  inherited;
end;

procedure TMFDBCardSchemeView.SetHintData(Sender: TObject;
  AViewHitInfo: TViewHitInfo; var HintRec: THintRec; var R: TRect;
  ACanvas: TCanvas);
begin
  inherited;
  if AViewHitInfo.AItem <>nil then
  begin
    HintRec.HintType := htImage;
    R:=Rect(0,0,Self.FContentOptions.CardWidth-2,Self.CardHight-2);
    //R :=AViewHitInfo.AItem.GetItemClientRect;
    Self.PaintHintItem(Self,AViewHitInfo.AItem,ACanvas,R);
  end;
end;

procedure TMFDBCardSchemeView.SetNodeHeight(ANode: TMFSchemeTreeNode;
  var NodeHeight: Integer);
begin
  
  if ANode<>nil then
  begin
    if PNodeRec(ANode.Data).NodeType=tnpFolder then
      NodeHeight:=FGroupHight
    else
      NodeHeight:=FCardHight;

  end;
  inherited;
end;

procedure TMFDBCardSchemeView.SetSchemeViewFeilds(
  const Value: TSchemeViewFeilds);
begin
  FSchemeViewFeilds.Assign(Value);
end;

{ TSchemeViewFeilds }

function TSchemeViewFeilds.Add: TSchemeViewFeildItem;
begin
  Result :=TSchemeViewFeildItem(inherited add);
end;

function TSchemeViewFeilds.GetItem(Index: Integer): TSchemeViewFeildItem;
begin
  Result := TSchemeViewFeildItem(inherited GetItem(Index));
end;

procedure TSchemeViewFeilds.SetItem(Index: Integer;
  const Value: TSchemeViewFeildItem);
begin
  inherited SetItem(Index,Value);
end;


{ TSchemeNodeDataLink }

procedure TSchemeNodeDataLink.ActiveChanged;
begin
  inherited;
  if FScheme <> nil then
    FScheme.TreeActiveChanged;
end;

constructor TSchemeNodeDataLink.Create(Scheme: TMFDBScheme);
begin
  FScheme:=Scheme;
end;

procedure TSchemeNodeDataLink.DataSetChanged;
begin
  inherited;

end;

procedure TSchemeNodeDataLink.DataSetScrolled(Distance: Integer);
begin
  inherited;

end;

destructor TSchemeNodeDataLink.Destroy;
begin

  inherited;
end;

procedure TSchemeNodeDataLink.EditingChanged;
begin
  inherited;

end;

procedure TSchemeNodeDataLink.FocusControl(Field: TFieldRef);
begin
  inherited;

end;

function TSchemeNodeDataLink.GetFields(Value: String): TField;
begin

end;

procedure TSchemeNodeDataLink.LayoutChanged;
begin
  inherited;

end;

procedure TSchemeNodeDataLink.Modified;
begin

end;

procedure TSchemeNodeDataLink.RecordChanged(Field: TField);
begin
  inherited;

end;

procedure TSchemeNodeDataLink.Reset;
begin

end;

procedure TSchemeNodeDataLink.UpdateData;
begin
  inherited;

end;

{ TSchemeItemDataLink }

procedure TSchemeItemDataLink.ActiveChanged;
begin
  inherited;
  if FScheme <> nil then
    FScheme.ItemActiveChanged;
end;

constructor TSchemeItemDataLink.Create(Scheme: TMFDBScheme);
begin
  FScheme:=Scheme;
end;

procedure TSchemeItemDataLink.DataSetChanged;
begin
  inherited;
  if FScheme <> nil then
    FScheme.ItemDataChanged;
end;

procedure TSchemeItemDataLink.DataSetScrolled(Distance: Integer);
begin
  inherited;

end;

destructor TSchemeItemDataLink.Destroy;
begin

  inherited;
end;

procedure TSchemeItemDataLink.EditingChanged;
begin
  inherited;
  if FScheme <> nil then
    FScheme.ItemEditingChanged;

end;

procedure TSchemeItemDataLink.FocusControl(Field: TFieldRef);
begin
  inherited;

end;

function TSchemeItemDataLink.GetFields(Value: String): TField;
begin

end;

procedure TSchemeItemDataLink.LayoutChanged;
begin
  inherited;

end;

procedure TSchemeItemDataLink.Modified;
begin

end;

procedure TSchemeItemDataLink.RecordChanged(Field: TField);
begin
  inherited;
  if FScheme <> nil then
    FScheme.ItemRecordChanged(Field);
end;

procedure TSchemeItemDataLink.Post;
begin
  if (DataSet <> nil)then
  if DataSet.State in [dsEdit,dsInsert] then
    DataSet.Post;
end;

procedure TSchemeItemDataLink.UpdateData;
begin
  inherited;


end;


function TMFDBScheme.GetItemFieldData(Item: TMFSchemeDataItem;
  FieldName: String): Variant;
var I:Integer;
begin
  Result:=Null;
  if Item<>nil then
  with SchemeFeilds do
  for I:=0 to Count-1  do
  begin
    if Items[i].FieldName=FieldName then
    begin
      Result:=PItemRec(Item.SysData).ItemField[i];
      Break;
    end;
  end;
end;

procedure TMFDBScheme.UpdateDB(ADataItem: TMFSchemeDataItem);
var
  I:Integer;AData:Variant; ATime:TDateTime;
begin
  if not FISUpdateDB then
  if FItemDataLink.DataSet.BookmarkValid(PItemRec(ADataItem.SysData).BookMark) then
  begin
    FItemDataLink.DataSet.GotoBookmark(PItemRec(ADataItem.SysData).BookMark);
    FItemDataLink.Edit;
    for i:=0 to FSchemeFeilds.Count-1 do
    with FItemDataLink.DataSet.FieldByName(FSchemeFeilds.Items[I].FieldName) do
    begin

      case FSchemeFeilds.Items[I].FieldType of
	tfpBegin    : AData :=TDateTime( ADataItem.BeginDate);

	tfpInterval : AData :=TDateTime( ADataItem.IntervalDate);

	tfpEnd      : begin
			ATime := (ADataItem.IntervalDate+ADataItem.BeginDate);
			AData := TDateTime(ATime);
		      end;
		      
	tfpText     : AData := ADataItem.Text;

	tfpBackColor: AData := ADataItem.Color;

	tfpPercent  : AData := ADataItem.Percent;

      end;
      
      if FSchemeFeilds.Items[I].FieldType<>tfpNone then
      begin
	Value:=AData ;
	PItemRec(ADataItem.SysData).ItemField[I]:=AData;
      end;

    end;

    if PNodeRec(ADataItem.Parent.Data).KeyField<>
      FItemDataLink.DataSet.FieldByName(ItemRelationKeyField).Value then
    begin
      FItemDataLink.DataSet.FieldByName(ItemRelationKeyField).Value:=PNodeRec(ADataItem.Parent.Data).KeyField;
    end;
    
    FItemDataLink.Post;
  end;  
end;

procedure TMFDBScheme.SetItemRelationKeyFieldName(const Value: string);
begin
  FItemRelationKeyFieldName := Value;
end;

procedure TMFDBScheme.BeginUpdateDB;
begin
  FISUpdateDB:=True; 
end;

procedure TMFDBScheme.EndUpdateDB;
begin
  FISUpdateDB:=False;
end;

function TMFDBScheme.FindDataItem(Key: String): TMFSchemeDataItem;
var i:Integer;
begin
  Result :=nil;
  for i:=0 to Self.SchemeDataTree.DataItemCount-1 do
  begin
    if  PItemRec(SchemeDataTree.DataItems[i].SysData).KeyField = Key then
    begin
      Result:=SchemeDataTree.DataItems[i];
    end;
  end;
end;

function TMFDBScheme.FindRecord(ADataItem: TMFSchemeDataItem): Boolean;
begin
  Result:=False; 
  if FItemDataLink.DataSet.BookmarkValid(PItemRec(ADataItem.SysData).BookMark) then
  begin
    Result :=True;
    FItemDataLink.DataSet.GotoBookmark(PItemRec(ADataItem.SysData).BookMark);
  end;
end;

function TMFDBScheme.DeleteSelectionItems: Boolean;
var P:PItemRec;  i:Integer;
begin
  inherited;
  Result :=False;
  BeginUpdate;
  for i:=Self.SchemeDataTree.SelectionItemCount-1 downto 0 do
  begin
    DeleteItem(SchemeDataTree.SelectionsItem[i]);
  end;
  EndUpdate;
  Result:=True;
end;

function TMFDBScheme.DeleteItem(ADataItem: TMFSchemeDataItem): Boolean;
var P:PItemRec;  i:Integer;
begin
  inherited;
  Result :=False;
  P:=PItemRec(ADataItem.SysData);
  if FItemDataLink.DataSet.BookmarkValid(P.BookMark) then
  begin
    FItemDataLink.DataSet.GotoBookmark(P.BookMark);
    FItemDataLink.DataSet.FreeBookmark(P.BookMark);
    P.BookMark:=nil;
    Dispose(P);
    ADataItem.Free ;
    FItemDataLink.DataSet.Delete;
  end;
  Result:=True;
end;

initialization
  RegisteredViews.Register(TMFDBCardSchemeView,'DBCardSchemeView',rgtDB);
  RegisteredViews.Register(TMFDBGunterSchemeView,'DBGunterSchemeView',rgtDB);
finalization
  RegisteredViews.Unregister(TMFDBCardSchemeView);
  RegisteredViews.Unregister(TMFDBGunterSchemeView);
end.
