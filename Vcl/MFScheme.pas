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

	-2006-6-26  编写  TMFCustomScheme


ToDo:

*******************************************************************************}


unit MFScheme;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls,ImgList,StrUtils,
  StdCtrls,Forms,ExtCtrls,Graphics,Dialogs ,CommCtrl,ComCtrls,DateUtils,
  MFBaseScheme,MFPaint,MFBaseSchemePainter,MFBaseSchemeCommon;

type
  TSchemeViewItem=class;
  TSchemeViews=class;
  
  TMFCustomScheme = class(TMFBaseScheme,IZcTreeChanger)
  private
    FOnItemSelectChange: TItemSelectChangeEvent;

  protected
    FSchemeDataTree:TMFSchemeDataTree;
    FSchemeViews: TList;
    FSchemeView: TMFBaseSchemeView;
    function GetSchemeViews(Index: Integer): TMFBaseSchemeView;
    function GetSchemeViewsCount: Integer;
    procedure Notification(AComponent: TComponent;Operation: TOperation); override;
    procedure SetActiveSchemeView(const Value: TMFBaseSchemeView);
    { IZcTreeChanger }
    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);
    function GetDataTreeClientRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;
    procedure ItemSelectChanged(BeforeChange,Value:Boolean;AItem:TMFSchemeDataItem;
      var Accept:Boolean);
    function GetOffSetPoint:TPoint;
    { IZcTreeChanger }
    procedure AddSchemeView(Value:TMFBaseSchemeView);
    procedure RemoveSchemeView(Value:TMFBaseSchemeView);
    procedure DestroySchemeView;
    procedure InitAddChildComponent(AComponent: TComponent); override;
    procedure RemoveChildComponent(AComponent: TComponent); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure WndProc(var Message: TMessage); override;
    procedure InvalidateView;
    procedure ActiveViewChange(var Message: TMessage); message WM_ActiveViewChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint;override;
    procedure Clear;virtual;
    procedure ClearView;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure SetNodeHeight(ANode:TMFSchemeTreeNode;var NodeHeight:Integer);override;
    function GetWholeHeight:Integer;override;
    function GetWholeWidth:Integer;override;
    procedure Click;override;
    procedure DblClick; override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DragDrop(Source: TObject;X,Y: Integer);override;
    procedure DragCanceled; override;
    function CreateSchemeView(SchemeViewClass: TMFBaseSchemeViewClass): TMFBaseSchemeView;
    property SchemeDataTree:TMFSchemeDataTree  read  FSchemeDataTree;
    property ActiveSchemeView:TMFBaseSchemeView read FSchemeView write SetActiveSchemeView;
    property SchemeViewsCount: Integer read GetSchemeViewsCount;
    property SchemeViews[Index: Integer]: TMFBaseSchemeView read GetSchemeViews;
    property OnItemSelectChange:TItemSelectChangeEvent read FOnItemSelectChange write FOnItemSelectChange;
  published
  end;

  TMFScheme = class(TMFCustomScheme)
  published
    property ActiveSchemeView;
    property BorderStyle;
    property Align;
    property Enabled;
    property TabOrder ;
    property TabStop;
    property Ctl3D;
    property DockSite;
    property DockManager;
    property ImeMode;
    property ImeName;
    property UseDockManager;
    property Color;
    property DragKind;
    property DragCursor;
    property PopupMenu;
    property Visible;
    property OnDockDrop;
    property OnDockOver;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnUnDock;
    property OnClick;
    property OnDblClick;
    property OnContextPopup;
    property OnEndDock;
    property OnEndDrag;
    property OnDragOver;
    property OnDragDrop;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property OnItemSelectChange;
  end;

  TSchemeViews=class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSchemeViewItem;
    procedure SetItem(Index: Integer; const Value: TSchemeViewItem);
  public
    function Add: TSchemeViewItem;
    property Items[Index: Integer]: TSchemeViewItem read GetItem write SetItem; default;
  end;

  TSchemeViewItem=class(TCollectionItem)
  private
    FActive: Boolean;
    function GetViewClassName: string;
    procedure SetSchemeViewClass(const Value: TMFBaseSchemeViewClass);
    procedure SetViewClassName(const Value: string);
    procedure SetActive(const Value: Boolean);
  protected
    FSchemeView:TMFBaseSchemeView;
    FSchemeViewClass:TMFBaseSchemeViewClass;
    function GetDisplayName: string; override;
    procedure RecSchemeViewClass;
    procedure CreateSchemeViewClass;
    procedure DestroySchemeViewClass;
    procedure NotifyFree;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy; override;
    property SchemeViewClass: TMFBaseSchemeViewClass read FSchemeViewClass write SetSchemeViewClass;
  published
    property SchemeView :TMFBaseSchemeView read FSchemeView ;
    property ViewClassName: string read GetViewClassName write SetViewClassName;
    property Active:Boolean read FActive write SetActive;
  end;
implementation

{ TMFCustomScheme }

constructor TMFCustomScheme.Create(AOwner: TComponent);
begin
  inherited;
  FSchemeViews := TList.Create;
  FSchemeDataTree :=TMFSchemeDataTree.Create2(Self,TMFSchemeDataTreeNode);
end;

destructor TMFCustomScheme.Destroy;
begin
  DestroySchemeView;
  FSchemeViews.Free;
  FSchemeDataTree.Free;
  inherited;
end;

procedure TMFCustomScheme.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
var
  I: Integer;
begin
  inherited;
  if Assigned(FSchemeViews) then
  begin
    for I := 0 to SchemeViewsCount - 1 do
    begin
      Proc(SchemeViews[I]);
    end;
  end;
end;

function TMFCustomScheme.GetSchemeViews(Index: Integer): TMFBaseSchemeView;
begin
  Result := FSchemeViews[Index];
end;

function TMFCustomScheme.GetSchemeViewsCount: Integer;
begin
  Result := FSchemeViews.Count;
end;

procedure TMFCustomScheme.Paint;
begin
  inherited;
  if ActiveSchemeView<>nil then
  begin

    ActiveSchemeView.Paint;
  end
  else
    Clear;
  //UpdateScrollBars;
end;

function TMFCustomScheme.CreateSchemeView(
  SchemeViewClass: TMFBaseSchemeViewClass): TMFBaseSchemeView;
begin
  Result:=SchemeViewClass.Create(GetParentForm(Self));
  Result.Parent :=Self;
  AddSchemeView(Result);
end;

procedure TMFCustomScheme.RemoveSchemeView(Value: TMFBaseSchemeView);
var I:Integer;
begin
  I:=FSchemeViews.IndexOf(Pointer(Value));
  if I>-1 then  FSchemeViews.Delete(I);
end;

procedure TMFCustomScheme.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove)then
  begin
    if (AComponent is TMFBaseSchemeView) then
      RemoveSchemeView(TMFBaseSchemeView(AComponent));
    if  AComponent =  ActiveSchemeView then
      ActiveSchemeView:=nil;
  end;
end;

procedure TMFCustomScheme.InitAddChildComponent(AComponent: TComponent);
begin
  inherited;
  if AComponent is TMFBaseSchemeView then
    AddSchemeView(TMFBaseSchemeView(AComponent));
end;

procedure TMFCustomScheme.RemoveChildComponent(AComponent: TComponent);
begin
  inherited;
  if AComponent is TMFBaseSchemeView then
    RemoveSchemeView(TMFBaseSchemeView(AComponent));
end;

procedure TMFCustomScheme.AddSchemeView(Value: TMFBaseSchemeView);
begin
  if FSchemeViews.IndexOf(Value)<0 then
  begin
    FSchemeViews.Add(Value);
    Value.FreeNotification(self);
  end;
end;

procedure TMFCustomScheme.DestroySchemeView;
var
  I: Integer;
begin
  inherited;
  if Assigned(FSchemeViews) then
  begin
    for I :=SchemeViewsCount - 1  downto 0 do
    begin
      TMFBaseSchemeView(SchemeViews[i]).Free;
    end;
  end;
end;

procedure TMFCustomScheme.SetActiveSchemeView(
  const Value: TMFBaseSchemeView);
begin
  if FSchemeView<>Value then
  begin
    FSchemeView := Value;
    if  Assigned(Value) then
    begin
      Value.FreeNotification(self);
      Value.ParentScheme :=Self;
      Value.CalcScrollBar;
    end;
    Invalidate;
  end;
end;

function TMFCustomScheme.GetWholeHeight: Integer;
begin
  Result:=inherited GetWholeHeight;
  if Assigned(ActiveSchemeView) then
    Result := ActiveSchemeView.GetWholeHeight;
end;


procedure TMFCustomScheme.TreeChanged(AEventType: TEventType;
  AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin
  if ActiveSchemeView<>nil then
    ActiveSchemeView.TreeChanged(AEventType,AEvent,AIndex);
end;

function TMFCustomScheme.GetWholeWidth: Integer;
begin
  Result:= inherited GetWholeWidth;
  if Assigned(ActiveSchemeView) then
    Result := ActiveSchemeView.GetWholeWidth;
end;

procedure TMFCustomScheme.WndProc(var Message: TMessage);
begin
  inherited;
  if ActiveSchemeView<>nil then
    ActiveSchemeView.WindowProc(Message); 
end;

function TMFCustomScheme.GetDataTreeClientRect(AItem: TMFSchemeDataItem;
  ANode: TMFSchemeDataTreeNode): TRect;
begin
  if ActiveSchemeView<>nil then
    Result:=ActiveSchemeView.GetDataTreeClientRect(AItem,ANode);
end;

procedure TMFCustomScheme.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  if ActiveSchemeView<>nil then
    ActiveSchemeView.DragOver(Source, X, Y,State,Accept);
end;

procedure TMFCustomScheme.DragDrop(Source: TObject; X, Y: Integer);
begin
  inherited;
  if ActiveSchemeView<>nil then
    ActiveSchemeView.DragDrop(Source, X, Y);
end;

procedure TMFCustomScheme.DragCanceled;
begin
  inherited;
  if ActiveSchemeView<>nil then
    ActiveSchemeView.DragCanceled;
end;


function TMFCustomScheme.GetOffSetPoint:TPoint;
begin
  if ActiveSchemeView<>nil then
  begin
    Result:= ActiveSchemeView.GetOffSetPoint;
  end;
end;

procedure TMFCustomScheme.Click;
begin
  inherited;
  if ActiveSchemeView<>nil then
    ActiveSchemeView.Click;
end;

procedure TMFCustomScheme.DblClick;
begin
  inherited;
  if ActiveSchemeView<>nil then
    ActiveSchemeView.DblClick;
end;

procedure TMFCustomScheme.BeginUpdate;
begin
  if ActiveSchemeView<>nil then
    ActiveSchemeView.BeginUpdate;
end;

procedure TMFCustomScheme.EndUpdate;
begin
  if ActiveSchemeView<>nil then
    ActiveSchemeView.EndUpdate;
end;

procedure TMFCustomScheme.ActiveViewChange(var Message: TMessage);
begin
  ActiveSchemeView:=nil;
  InvalidateView;
end;

procedure TMFCustomScheme.InvalidateView;
begin
  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color:=Color;
  Canvas.FillRect(ClientRect);
end;

procedure TMFCustomScheme.SetNodeHeight(ANode: TMFSchemeTreeNode;
  var NodeHeight: Integer);
begin
  inherited;
  if ActiveSchemeView <>nil then
    ActiveSchemeView.SetNodeHeight(ANode,NodeHeight);
end;

procedure TMFCustomScheme.Clear;
begin
  Canvas.Brush.Color:=Color;
  Canvas.Brush.Style:=bsSolid;
  Canvas.FillRect(ClientRect);
end;

procedure TMFCustomScheme.ClearView;
var I:Integer;
begin
  for i:=SchemeViewsCount-1 downto 0 do
  begin
    SchemeViews[I].Free;
  end;
end;

procedure TMFCustomScheme.ItemSelectChanged(BeforeChange, Value: Boolean;AItem:TMFSchemeDataItem;
  var Accept: Boolean);
begin
  if Assigned(FOnItemSelectChange) then
    FOnItemSelectChange(Self,AItem,Accept);
  if ActiveSchemeView<>nil then
    ActiveSchemeView.ItemSelectChanged(BeforeChange,Value,AItem,Accept);
end;

{ TSchemeViews }

function TSchemeViews.Add: TSchemeViewItem;
begin
  Result:= TSchemeViewItem(inherited Add );
end;

function TSchemeViews.GetItem(Index: Integer): TSchemeViewItem;
begin
  Result:= TSchemeViewItem(inherited GetItem(Index) );
end;

procedure TSchemeViews.SetItem(Index: Integer;
  const Value: TSchemeViewItem);
begin
  inherited SetItem(Index,Value);
end;

{ TSchemeViewItem }

constructor TSchemeViewItem.Create(Collection: TCollection);
begin
  inherited;
end;

procedure TSchemeViewItem.CreateSchemeViewClass;
begin
  if SchemeViewClass <> nil then
  begin
    FSchemeView:= SchemeViewClass.Create(TMFBaseScheme(Collection.Owner));
    FSchemeView.NotifyFree := NotifyFree;
  end;
end;

destructor TSchemeViewItem.Destroy;
begin
  if Assigned(TSchemeViewItem(Self).FSchemeView) then
    TSchemeViewItem(Self).FSchemeView.Free;
  inherited;
end;

procedure TSchemeViewItem.DestroySchemeViewClass;
begin
  FreeAndNil(FSchemeView);
end;

function TSchemeViewItem.GetDisplayName: string;
begin
  Result :='ViewItem';
end;

function TSchemeViewItem.GetViewClassName: string;
begin
  if FSchemeView = nil then
    Result := ''
  else
    Result := FSchemeView.ClassName;
end;

procedure TSchemeViewItem.NotifyFree;
begin
  //Self.Free;
end;

procedure TSchemeViewItem.RecSchemeViewClass;
begin
  DestroySchemeViewClass;
  CreateSchemeViewClass;
end;

procedure TSchemeViewItem.SetActive(const Value: Boolean);
var I:Integer;
begin
  if FActive<> Value then
  begin
    for i:=0 to Collection.Count-1  do
    begin
      TSchemeViewItem(Collection.Items[i]).FActive:=False;
      {if Assigned(TSchemeViewItem(Collection.Items[i]).FSchemeView) then
      TSchemeViewItem(Collection.Items[i]).FSchemeView.Visible:=False; }
    end;
    FActive := Value;
   { if Assigned(TSchemeViewItem(Self).FSchemeView) then
    TSchemeViewItem(Self).FSchemeView.Visible := Value;}
  end;
end;

procedure TSchemeViewItem.SetSchemeViewClass(
  const Value: TMFBaseSchemeViewClass);
begin
  if (FSchemeViewClass <> Value) then
  begin
    FSchemeViewClass := Value;
    RecSchemeViewClass;
  end;
end;

procedure TSchemeViewItem.SetViewClassName(const Value: string);
begin
  SchemeViewClass := TMFBaseSchemeViewClass(RegisteredViews.FindByClassName(Value));
end;  


end.
