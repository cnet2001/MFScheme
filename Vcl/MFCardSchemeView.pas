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

	暂不支持 OpenGL 功能 以后扩充
	声明:本工程代码都是自己实现的没有其他任何第三方组件和代码

重构:   -2006-6-10     重构类 以及 类关系

	-2006-6-26  编写  TMFCardSchemeView
	-2006-6-28  编写  TMFCardPaint
	-2006-6-29  编写  TMFCardHeadPaint
	-2006-6-29  编写  TMFCardContentPaint
	-2006-7-3   编写  TCardCalculater
	-2006-7-4   编写  TMFCardContentOptions
	-2006-7-5   优化  TMFCardContentPaint
	-2006-7-12  编写  TMFCardViewControl 鼠标键盘事件控制类
	-2006-7-18  完善  数据改变事件通知
	-2006-7-20  完善  立体效果和风格
        -2008-5-15 增加定位功能
ToDo:

*******************************************************************************}

unit MFCardSchemeView;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls,ImgList,StrUtils,
  StdCtrls,Forms,ExtCtrls,Graphics,Dialogs ,CommCtrl,ComCtrls,DateUtils,
  MFBaseScheme,MFScheme,MFPaint,MFBaseSchemePainter,Types,OpenGL,
  MFBaseSchemeCommon;

type
  TMFCardPaint=class;
  TCardCalculater=class;
  TMFCardHeadPaint =class;
  TMFCardContentPaint=class;
  TMFCardContentOptions=class;
  TMFCardViewControl=class;

  TCardDownEvent = procedure(Source: TObject;DragCard:TMFSchemeDataItem;var Accept:Boolean;X,Y:Integer) of object;

  TMFCardMoveType=(cmNone,cmTreeSize,cmItemLeft,cmItemRight,cmItemMove);

  TMFCardMoveRec=record
     MoveType: TMFCardMoveType;
     OPoint,NPoint,DownPoint:TPoint;
     ARect:TRect;
     AItem:TMFSchemeDataItem;
     MouseType:TMouseType;
  end;

  TMFCardSchemeView=class(TMFBaseSchemeView,IZcDrawData)
  private
    function GetCalculater: TCardCalculater;

  protected
    FContentOptions: TMFCardContentOptions;
    FCardPaint:TMFCardPaint;
    FCardViewControl:TMFCardViewControl;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    destructor Destroy; override;
    procedure InIt;override;
    procedure Paint;override;
    function GetWholeHeight:Integer;override;
    function GetWholeWidth:Integer;override;
    {IZcDrawData}
    function GetSchemeDataTree:TMFSchemeDataTree;
    function GetDrawCalculater:TDrawCalculater;
    function GetDrawImageList:TImageList;
    {IZcDrawData}
    procedure DblClick;override; 
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    property Calculater:TCardCalculater read GetCalculater;
    property Painter:TMFCardPaint read FCardPaint;
    property Control:TMFCardViewControl read FCardViewControl;

    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    function GetDataTreeClientRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;override;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DragDrop(Source: TObject;X,Y: Integer);override;
    procedure DragCanceled; override;
    procedure DoScrollTimer;override;
    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);override;

  published
    property TreeOptions ;
    property IndicaterOptions ;
    property HeadOptions ;
    property FootOptions ;
    property ReadOnly;
    property ContentOptions:TMFCardContentOptions read FContentOptions write FContentOptions;
    property ShowHint;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaintItem;
    property OnAfterDragItemDown;
    property OnBeforDragItemDown;
    property OnAdjustDragDrop;
    property OnSetNodeHeight;
    property OnSetHintData;
    property OnItemSelectChange;
    property OnDblClickView;
    property OnDragOtherDrop;
    property OnDragOtherOver;
    property OnDragItemOver;    
    property Images;
    property Caption;
  end;

  TMFCardContentOptions=Class(TMFContentOptions)
  private
    FCardWidth: Integer;
    procedure SetCardWidth(const Value: Integer);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
  published
    property CardWidth:Integer read FCardWidth write SetCardWidth;
    property Pen;
    property Font;
    property Color;
    property MultiSelect;   
  end;

  TMFCardPaint=class(TMFAdvSchemePaint)
  private
    FCardCalculater:TCardCalculater;
  protected

  public
    constructor Create(AOwner:TMFCardSchemeView);reintroduce; virtual;
    destructor Destroy; override;
    procedure PaintMoveSize(RClient: TRect);
    procedure Paint(APaint:TMFBaseSchemePaint=nil);reintroduce;
    procedure PaintNeedClear(R:TRect);
    procedure PaintRowList(APaint:TMFBaseSchemePaint=nil);virtual;
    property CardCalculater:TCardCalculater read FCardCalculater write FCardCalculater ;
  end;

  TCardCalculater=class(TDrawCalculater)
  private
    function GetSchemeView: TMFCardSchemeView;
  protected

  public
    constructor Create(AOwner:TMFCardSchemeView);reintroduce;virtual;
    function GetWholeHeight:Integer;override;
    function GetWholeWidth:Integer;override;
    function GetNodeItemRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;
    function GetHitInfo(APoint:TPoint):TViewHitInfo;override;
    function GetNodeInfo(APoint:TPoint;APaintClass:TMFAdvSchemePaint):TViewHitInfo;
    function GetVisible(APaint:TMFBaseSchemePaint):Boolean;override;
    function GetNeedClearRect:TRect;
    function GetRelativeRect(APaint:TMFBaseSchemePaint):TRect;override;
    function GetRealRect(APaint:TMFBaseSchemePaint):TRect;override;
    function GetClientRect(APaint:TMFBaseSchemePaint):TRect;override;
    function GetOffSetPoint(APaint:TMFBaseSchemePaint):TPoint;override;
    function GetNodeTextRect(ANode:TMFSchemeDataTreeNode;
      var Need:Boolean):TRect;

    property SchemeView:TMFCardSchemeView read GetSchemeView;
  end;

  TMFCardHeadPaint=class(TMFHeadPaint)
  private

  protected

  public
    procedure Paint; override;
    procedure PaintHeadContent(Item: TMFSchemeDataItem; ACanvas: TCanvas;
      R: TRect;AIndex:Integer);virtual;
    procedure ZcInvalidate(const R: TRect);  override;
  end;

  TMFCardContentPaint=class(TMFContentPaint)
  private

  protected

  public
    procedure PaintContentItem(Item: TMFSchemeDataItem; ACanvas: TCanvas;
      R: TRect);
    function PaintCardStyle(Item: TMFSchemeDataItem; ACanvas: TCanvas;
      R: TRect):TRect;
    procedure PaintRow(Node: TMFSchemeDataTreeNode; ACanvas: TCanvas;
      R,RealRect: TRect);override;
    procedure Paint; override;
    procedure ZcInvalidate(const R: TRect);  override;
  end;



  TMFCardViewControl=Class(TMFBaseViewControl)
  private
    procedure ScorllMessage(hwnd: HWND; Msg: Cardinal; wParam,
      lParam: Integer);
  protected
    FTimerID:Integer;
    MoveRec:TMFCardMoveRec;
    function GetSchemeView: TMFCardSchemeView;

  public
    constructor Create(AView:TMFCardSchemeView);reintroduce;virtual;
    procedure StartScrollTimer;
    procedure DoScrollTimer;
    procedure EndScrollTimer;
    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);

    procedure DragItemOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);override;
    procedure DragItemDrop(Source: TObject;X,Y: Integer);override;
    procedure DragOtherOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);override;
    procedure DragOtherDrop(Source: TObject;X,Y: Integer);override;

    procedure DragCanceled; override;
    procedure BeginDrag(Immediate: Boolean; Threshold: Integer = -1);
    function Dragging: Boolean; override;
    procedure EndDrag(Drop: Boolean); override;
    function Calc(R: TRect; APoint: TPoint): TRect;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DblClick;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
    procedure SetCursor(var Message: TWMSetCursor);
    procedure HintShow(var Message: TCMHintShow);
    function GetHintStr(AViewHitInfo: TViewHitInfo): String;
    procedure AdjustDragDrop(NewNode: TMFSchemeDataTreeNode;
      var AdjustMoveType: TAdjustMoveType);
    function CanNodeKeyDown:Boolean;
    procedure NeedScroll(Node: TMFSchemeDataTreeNode);
    procedure ScrolltoNode(Node:TMFSchemeDataTreeNode;Percent:Integer=30);
    procedure ScrolltoLeft(Value:integer;Percent:Integer=30);
    procedure ScrolltoItem(AItem:TMFSchemeDataItem);
    procedure VScrollPage(Direction:Boolean);
    procedure HScrollPage(Direction:Boolean);
    procedure AdjustScrollBar(ScrollBarKind:TScrollBarKind);

    procedure SetHintData(Sender: TObject; AViewHitInfo: TViewHitInfo;
      var HintRec: THintRec; var R: TRect; ACanvas: TCanvas); virtual;

    Property SchemeView:TMFCardSchemeView read GetSchemeView;
  end;

implementation

{ TMFCardSchemeView }

procedure TMFCardSchemeView.CMHintShow(var Message: TCMHintShow);
begin
  FCardViewControl.HintShow(Message);
end;

procedure TMFCardSchemeView.DblClick;
begin
  inherited;
  FCardViewControl.DblClick;
end;

destructor TMFCardSchemeView.Destroy;
begin
  FCardPaint.Free;
  FCardViewControl.Free;
  FContentOptions.Free;
  inherited;
end;

procedure TMFCardSchemeView.DoScrollTimer;
begin
  inherited;
  FCardViewControl.DoScrollTimer;
end;

procedure TMFCardSchemeView.DragCanceled;
begin
  inherited;
  FCardViewControl.DragCanceled;
end;

procedure TMFCardSchemeView.DragDrop(Source: TObject; X, Y: Integer);
begin
  inherited;
  if Source = Self.Parent then
    FCardViewControl.DragItemDrop(Source,X, Y)
  else
    FCardViewControl.DragOtherDrop(Source,X, Y);
end;

procedure TMFCardSchemeView.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  if Source = Self.Parent then
    FCardViewControl.DragItemOver(Source,X, Y,State,Accept)
  else
    FCardViewControl.DragOtherOver(Source,X, Y,State,Accept);
end;

function TMFCardSchemeView.GetCalculater: TCardCalculater;
begin
  Result :=FCardPaint.CardCalculater; ;
end;

function TMFCardSchemeView.GetDataTreeClientRect(
  AItem: TMFSchemeDataItem; ANode: TMFSchemeDataTreeNode): TRect;
begin
  Result := FCardPaint.FCardCalculater.GetNodeItemRect(AItem,ANode);
end;

function TMFCardSchemeView.GetDrawCalculater: TDrawCalculater;
begin
  Result:=Calculater;
end;

function TMFCardSchemeView.GetDrawImageList: TImageList;
begin
  Result:=Images;
end;

function TMFCardSchemeView.GetSchemeDataTree: TMFSchemeDataTree;
begin
  if ParentScheme<>nil then
    Result:=TMFCustomScheme(ParentScheme).SchemeDataTree
  else
    Result:=nil;
end;

function TMFCardSchemeView.GetWholeHeight: Integer;
begin   
  Result:= FCardPaint.FCardCalculater.GetWholeHeight;
end;

function TMFCardSchemeView.GetWholeWidth: Integer;
begin
  Result:= FCardPaint.FCardCalculater.GetWholeWidth;
end;

procedure TMFCardSchemeView.InIt;
begin
  inherited;
  FCardPaint:=TMFCardPaint.Create(Self);
  FCardViewControl:=TMFCardViewControl.Create(Self);
  FContentOptions := TMFCardContentOptions.Create(self);
  Caption := '卡片式';
end;

procedure TMFCardSchemeView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  FCardViewControl.KeyDown(Key,Shift);
end;

procedure TMFCardSchemeView.KeyPress(var Key: Char);
begin
  inherited;
  FCardViewControl.KeyPress(Key);
end;

procedure TMFCardSchemeView.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FCardViewControl.MouseDown(Button,Shift,X, Y);
end;

procedure TMFCardSchemeView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FCardViewControl.MouseMove(Shift,X, Y);
end;

procedure TMFCardSchemeView.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FCardViewControl.MouseUp(Button,Shift,X, Y);
end;

procedure TMFCardSchemeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

procedure TMFCardSchemeView.Paint;
begin
  inherited;
  if ParentScheme<>nil  then
    FCardPaint.Paint;
  //GetParentForm(TControl(Parent)).Canvas.TextOut(0,0,'Parent');
end;


procedure TMFCardSchemeView.TreeChanged(AEventType: TEventType;
  AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin
  inherited;
  FCardViewControl.TreeChanged(AEventType,AEvent,AIndex);
end;

procedure TMFCardSchemeView.WMSetCursor(var Message: TWMSetCursor);
begin
  inherited;
  FCardViewControl.SetCursor(Message);
end;

{ TMFCardPaint }

constructor TMFCardPaint.Create(AOwner: TMFCardSchemeView);
begin
  inherited Create(AOwner);
  FCardCalculater:=TCardCalculater.Create(AOwner);
  FCardCalculater.AddPainter(TMFCardHeadPaint);
  FCardCalculater.AddPainter(TMFFootPaint);
  FCardCalculater.AddPainter(TMFSchemeTreePaint,tPaintRow);
  FCardCalculater.AddPainter(TMFIndicaterPaint,tPaintRow);
  FCardCalculater.AddPainter(TMFCardContentPaint,tPaintRow);
end;

destructor TMFCardPaint.Destroy;
begin
  FCardCalculater.Free;
  inherited;
end;

procedure TMFCardPaint.Paint(APaint:TMFBaseSchemePaint);
var I:Integer; R:TRect;
begin
  //inherited;
  if  APaint<>nil then
  begin
    i:=FCardCalculater.FPaintList.IndexOf(APaint);
    if I>-1 then
    if FCardCalculater.ItemPainter[i].PaintType=tPaint then
      FCardCalculater.ItemPainter[i].Paint
    else
      PaintRowList(FCardCalculater.ItemPainter[i]);
  end
  else begin
    with TMFCardSchemeView(SchemeView) do
    for i:=0 to FCardCalculater.ItemCount-1 do
      if  FCardCalculater.ItemPainter[i].Visible then
      begin
	if FCardCalculater.ItemPainter[i].PaintType=tPaint then
	  FCardCalculater.ItemPainter[i].Paint
      end;
    PaintRowList;

    R :=FCardCalculater.GetNeedClearRect;
    if not IsRectEmpty(R) then
      PaintNeedClear(R);
  end;
end;

procedure TMFCardPaint.PaintMoveSize(RClient: TRect);
begin
  Canvas.DrawFocusRect(RClient);
end;

procedure TMFCardPaint.PaintNeedClear(R: TRect);
begin
  with Scheme.Canvas do
  begin
    Brush.Color := Scheme.color;
    Brush.Style := bsSolid;
    FillRect(R);
  end;
end;

procedure TMFCardPaint.PaintRowList(APaint:TMFBaseSchemePaint);
var
  RClient,RSou,RDes,RReal,RNew:TRect;
  I,J,Height,NewWidth,NewLeft,iTop,iBottom,DBottom,DTop:Integer;
  Node:TMFSchemeDataTreeNode;
begin
  inherited;
  RClient:=GetClientRect;
  RReal := GetRealRect;

  with SchemeView do
  begin
    iTop:=0; iBottom:=0;
    if HeadOptions.Visible then  iTop:= HeadOptions.Height ;
    if FootOptions.Visible then  iBottom:= FootOptions.Height ;

    RClient:=Rect(RClient.Left,RClient.Top+iTop,RClient.Right,RClient.Bottom-iBottom );
    RReal:=Rect(RReal.Left,RReal.Top+iTop,RReal.Right,RReal.Bottom-iBottom );
  end;

  iTop:=RReal.Top;
  
  Height:= 0;
  For I:=0 to GetSchemeDataTree.Count -1 do
  begin
    Node:=GetSchemeDataTree.Items[I];
    if Node.IsNotVisibleOrHide then  Continue;
    {if Node.Parent<>nil then
      if not Node.Parent.Expanded then  Continue;}
      
    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;
    NewWidth:=0;
    NewLeft:=0;
    DTop:=0;
    DBottom :=0;
    if iTop< RClient.Top then DTop:=RClient.Top-iTop;
    if iBottom> RClient.Bottom then  DBottom:=iBottom-RClient.Bottom;

    if iBottom< RClient.Top then Continue;
    if iTop>RClient.Bottom  then Continue;

    FFastBmp.Width := RClient.Right-RClient.Left;
    FFastBmp.Height:= Node.Height;
    FFastBmp.Canvas.Brush.Color :=clWhite;
    FFastBmp.Canvas.FillRect(FFastBmp.Canvas.ClipRect);
    RSou :=Rect(0,0,FFastBmp.Width ,FFastBmp.Height);
    if APaint<>nil then
    begin
      j:=CardCalculater.FPaintList.IndexOf(APaint);
      if j>-1 then
      with CardCalculater do
      if ItemPainter[j].Visible  then
      if  ItemPainter[j].PaintType=tPaintRow then
      begin
	RNew:=ItemPainter[j].GetClientRect;
	NewWidth:=RNew.Right;
	NewLeft:=RNew.Left;
	Rdes := Rect(NewLeft,iTop,NewWidth ,iBottom);
	RNew:=Rect(RNew.Left,RSou.Top,RNew.Right,RSou.Bottom);
	ItemPainter[j].PaintRow(Node,FFastBmp.Canvas,RNew,Rdes);
      end
    end
    else
    for j:=0 to CardCalculater.ItemCount-1 do
    with CardCalculater do
    if ItemPainter[j].Visible  then
    if  ItemPainter[j].PaintType=tPaintRow then
    begin
      RNew:=ItemPainter[j].GetClientRect;
      if NewWidth<RNew.Right then
	NewWidth:=RNew.Right;
      if NewLeft>RNew.Left then
	NewLeft:=RNew.Left;
      Rdes := Rect(NewLeft,iTop,NewWidth ,iBottom);
      RNew:=Rect(RNew.Left,RSou.Top,RNew.Right,RSou.Bottom);
      ItemPainter[j].PaintRow(Node,FFastBmp.Canvas,RNew,Rdes);
    end;
    RSou :=Rect(NewLeft,DTop,NewWidth,FFastBmp.Height-DBottom);
    Rdes := Rect(NewLeft,iTop+DTop,NewWidth ,iBottom-DBottom);
    Canvas.CopyRect(Rdes,FFastBmp.Canvas,RSou);

  end;
end;

{ TCardCalculater }

constructor TCardCalculater.Create(AOwner: TMFCardSchemeView);
begin
  inherited Create(AOwner);
end;

function TCardCalculater.GetClientRect(APaint: TMFBaseSchemePaint): TRect;
var
  TreeLeft,TreeTop,TreeBottom,ContentLeft,HeadWidth:Integer;
  RClient:TRect;
begin
  with  SchemeView  do
  begin
    RClient:= GetClientRect;
    if APaint.InheritsFrom(TMFCardPaint) then
      Result:=RClient;

    if IndicaterOptions.Visible then
      TreeLeft:=IndicaterOptions.Width
    else
      TreeLeft:=0;

    if HeadOptions.Visible then
      TreeTop:=HeadOptions.Height
    else
      TreeTop:=0;

    HeadWidth := RClient.Right-TreeLeft;

    if FootOptions.Visible then
      TreeBottom:= RClient.Bottom-FootOptions.Height
    else
      TreeBottom:= RClient.Bottom;

    if  TreeOptions.Visible then
      ContentLeft := TreeLeft+TreeOptions.Width
    else
      ContentLeft := TreeLeft;

    if APaint.InheritsFrom(TMFHeadPaint) then
      Result :=Rect(0,0,HeadWidth,HeadOptions.Height);
    if APaint.InheritsFrom(TMFContentPaint) then
      Result :=Rect(ContentLeft,TreeTop,RClient.Right,TreeBottom);
    if APaint.InheritsFrom(TMFIndicaterPaint) then
      Result :=Rect(0,TreeTop,IndicaterOptions.Width,TreeBottom);
    if APaint.InheritsFrom(TMFSchemeTreePaint) then
      Result :=Rect(TreeLeft,TreeTop,TreeOptions.Width+TreeLeft,TreeBottom);
    if APaint.InheritsFrom(TMFFootPaint) then
      Result :=Rect(0,TreeBottom,RClient.Right,RClient.Bottom);

  end;
end;

function TCardCalculater.GetHitInfo(APoint: TPoint): TViewHitInfo;
var
  I:Integer;R:TRect;
begin
  inherited;
  Result.APoint:= APoint;
  Result.ANode:=nil;
  Result.AItem:=nil;
  Result.AColumn:=-1;
  Result.AhitType:=pNone;
  Result.APaintClass:=nil;
  for i:=0 to ItemCount-1 do
    if  ItemPainter[i].Visible then
    begin
      R:=GetClientRect(ItemPainter[i]);
      if PtInRect(R,APoint) then
      begin
	//Result.APaintClass:=ItemPainter[i];
	Result:=GetNodeInfo(APoint,ItemPainter[i]);
      end;
    end;
end;

function TCardCalculater.GetNeedClearRect: TRect;
var RClient:TRect;Bottom, Height:Integer;
begin
  Result:=Rect(0,0,0,0);
  RClient:=GetPaintClass(TMFContentPaint).GetClientRect;
  Height :=SchemeView.GetSchemeDataTree.GetTreeHeight;
  {if SchemeView.FootOptions.Visible then
    Bottom:= RClient.Bottom-SchemeView.FootOptions.Height
  else }
    Bottom:= RClient.Bottom;

  if RClient.Bottom >(Height+RClient.Top) then
    Result:=Rect(0,Height+RClient.Top,RClient.Right,Bottom);

end;

function TCardCalculater.GetNodeInfo(APoint: TPoint;
  APaintClass: TMFAdvSchemePaint): TViewHitInfo;
var
  R,RReal:TRect;
  I,Height,CardWidth,iTop,iBottom,Index:Integer;
  P:TPoint;
  Node:TMFSchemeDataTreeNode;
begin
  inherited;
  Result.APoint:=APoint;
  Result.APaintClass:=APaintClass;
  Result.AhitType:=pNone;
  Result.ANode:=nil;
  Result.AItem:=nil;
  Result.AHitType:=pNone;

  R:=SchemeView.GetClientRect;
  RReal := SchemeView.GetRealRect;

  if SchemeView.HeadOptions.Visible then
  begin
    R:=Rect(R.Left,R.Top+SchemeView.HeadOptions.Height,R.Right,R.Bottom );
    RReal:=Rect(RReal.Left,RReal.Top+SchemeView.HeadOptions.Height,RReal.Right,RReal.Bottom );
  end;

  iTop:=RReal.Top;
  Height:=0;
  CardWidth:=TMFCardSchemeView(SchemeView).ContentOptions.CardWidth;

  if APaintClass.InheritsFrom(TMFHeadPaint) then
  begin
    if Abs(APoint.X - GetPaintClass(TMFSchemeTreePaint).GetClientRect.Right)<3 then
      Result.AHitType:=pTreeRight;

  end;

  For I:=0 to GetSchemeDataTree.Count -1 do
  begin
    Node:=TMFSchemeDataTreeNode(GetSchemeDataTree.Items[I]);
    if Node.IsNotVisibleOrHide then  Continue;
    {if Node.Parent<>nil then
      if not Node.Parent.Expanded then  Continue; }

    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;

    if (APoint.Y> iTop) And (APoint.Y<iBottom) then
    begin
      Result.ANode:=Node;
      if APaintClass.InheritsFrom(TMFContentPaint) then
      begin
	if GetSchemeDataTree.MaxNodeItemCount<1 then Break;
	RReal := APaintClass.GetRealRect;
	Index:=Trunc((APoint.X-RReal.Left) div CardWidth);
	if Node.DataItemCount>Index then
	begin
	  Result.AItem:= Node.DataItems[Index];
	  Result.AhitType:=pItem;
	end;
      end;

      if APaintClass.InheritsFrom(TMFSchemeTreePaint) then
      begin
	if Node.HasChildren then
	begin
	  RReal := APaintClass.GetClientRect;
	  RReal := Rect(RReal.Left,iTop,RReal.Right,iBottom);
	  P:=CenterPoint(RReal);
    
	  RReal:=Rect(RReal.Left+4,P.Y-5,RReal.Left+15,P.Y+6);
	  OffsetRect(RReal,SchemeView.TreeOptions.Indent*Node.Level,0);
	  if PtInRect(RReal,APoint) then
	    Result.AhitType:=pNodePlus;
	end;
       end;

      Break;
    end;
  end;
end;

function TCardCalculater.GetNodeItemRect(AItem: TMFSchemeDataItem;
  ANode: TMFSchemeDataTreeNode): TRect;
var
  iBottom,iTop,iLeft,iRight:Integer;
  RClient,RReal:TRect;APoint:TPoint;
begin
  if AItem<>nil then ANode:= AItem.Parent;
  with GetSchemeDataTree do
  begin
    iBottom:=GetTreeHeight(ANode);
    iTop:=iBottom-ANode.Height;
    RClient:=GetPaintClass(TMFSchemeTreePaint).GetClientRect;
    Result:=Rect(RClient.Left,iTop+RClient.Top,RClient.Right,iBottom++RClient.Top);

    if AItem=nil then
    begin
      APoint:=GetPaintClass(TMFSchemeTreePaint).GetOffSetPoint;
      OffsetRect(Result,0,-APoint.Y);
    end
    else begin

      iLeft:=(AItem.RelativeIndex* SchemeView.ContentOptions.CardWidth);

      RReal := GetPaintClass(TMFContentPaint).GetRealRect;
      iLeft:=iLeft+RReal.Left;

      Result:=Rect(iLeft,iTop+RClient.Top,iLeft+SchemeView.ContentOptions.CardWidth,iBottom+RClient.Top);
      APoint:=GetPaintClass(TMFContentPaint).GetOffSetPoint;
      OffsetRect(Result,0,-APoint.Y);
    end;
  end;
end;

function TCardCalculater.GetNodeTextRect(ANode: TMFSchemeDataTreeNode;
  var Need: Boolean): TRect;
var
  RClient:TRect;
  P:TPoint;
  iText,iHeight:Integer;
begin
  RClient:=ANode.GetNodeRect;
  P:=CenterPoint(RClient);

  RClient.Left :=RClient.Left+30+SchemeView.TreeOptions.Indent*ANode.Level;
  with GetPaintClass(TMFSchemeTreePaint).Canvas do
  begin
    Font.Assign(SchemeView.TreeOptions.Font);
    iText:=TextWidth('A');
    iText:=iText*Length(ANode.Caption);
    iHeight:=TextHeight('A');
    RClient.top:=P.Y-Trunc(iHeight/2);
    RClient.Bottom:= RClient.top+ iHeight;
    Result:=RClient;
    if iText>(RClient.Right- RClient.Left) then
      Need:=True
    else
      Need:=False;
  end;

end;

function TCardCalculater.GetOffSetPoint(
  APaint: TMFBaseSchemePaint): TPoint;
begin
  Result :=Point(TMFCustomScheme(Scheme).RealLeft,TMFCustomScheme(Scheme).RealTop);
end;

function TCardCalculater.GetRealRect(APaint: TMFBaseSchemePaint): TRect;
begin
  Result := GetClientRect(APaint);
  OffsetRect(Result,-GetOffSetPoint(APaint).X,-GetOffSetPoint(APaint).Y);
end;

function TCardCalculater.GetRelativeRect(
  APaint: TMFBaseSchemePaint): TRect;
begin
  Result := GetClientRect(APaint);
  OffsetRect(Result,GetOffSetPoint(APaint).X,GetOffSetPoint(APaint).Y);
end;

function TCardCalculater.GetSchemeView: TMFCardSchemeView;
begin
  Result:=TMFCardSchemeView(FControl);
end;


function TCardCalculater.GetVisible(APaint: TMFBaseSchemePaint): Boolean;
begin
  Result := False;
  with TMFCardSchemeView(GetSchemeView) do
  begin
    if APaint.InheritsFrom(TMFHeadPaint) then
      Result:= HeadOptions.Visible ;
    if APaint.InheritsFrom(TMFContentPaint) then
      Result := ContentOptions.Visible;
    if APaint.InheritsFrom(TMFIndicaterPaint) then
      Result :=  IndicaterOptions.Visible ;
    if APaint.InheritsFrom(TMFSchemeTreePaint) then
      Result := TreeOptions.Visible ;
    if APaint.InheritsFrom(TMFFootPaint) then
      Result := FootOptions.Visible ;
  end;
end;

function TCardCalculater.GetWholeHeight: Integer;
var iHeight:Integer;
begin
  Result:=inherited GetWholeHeight;
  iHeight:=0;
  if GetSchemeDataTree<>nil then
  with GetSchemeView do
  begin
    if HeadOptions.Visible  then iHeight :=HeadOptions.Height;
    Result :=iHeight+ GetSchemeDataTree.GetTreeHeight;
    if FootOptions.Visible  then  Result:=Result+ FootOptions.Height;
  end; 
end;

function TCardCalculater.GetWholeWidth: Integer;
var iWidth:Integer;
begin
  Result:=inherited GetWholeWidth;
  iWidth:=0;
  if GetSchemeDataTree<>nil then
  with TMFCardSchemeView(GetSchemeView) do
  begin
    if IndicaterOptions.Visible  then iWidth :=IndicaterOptions.Width;
    if TreeOptions.Visible  then  iWidth:=iWidth+ TreeOptions.Width;

    Result :=iWidth+ GetSchemeDataTree.MaxNodeItemCount*ContentOptions.CardWidth;
  end;
end;

{ TMFCardHeadPaint }

procedure TMFCardHeadPaint.Paint;
var
  R,RSou,RDes,RReal:TRect;
  J,Height,Width,DLeft,iStart,iEnd:Integer;
begin
  inherited;
  R:=GetClientRect;
  RReal :=GetRealRect;
  //RDes:= GetRelativeRect;
  with GetDrawCalculater do
    Width:=GetClientRect(GetPaintClass(TMFContentPaint)).Left;

  R:=Rect(R.Left+Width,R.Top,R.Right,R.Bottom);
  RReal:=Rect(RReal.Left+Width,RReal.Top,RReal.Right,RReal.Bottom);

  Height:=SchemeView.HeadOptions.Height;
  Width:=TMFCardSchemeView(SchemeView).ContentOptions.CardWidth;

  DLeft:=0;
  if RReal.Left < R.Left then
    DLeft:=(R.Left-RReal.Left) mod Width;

  FFastBmp.Width := (RealRound((R.Right-R.Left) / Width+1))*Width;
  FFastBmp.Height:= Height;
  
  FFastBmp.Canvas.Brush.Color:=clWhite;
  FFastBmp.Canvas.Brush.Style := bsSolid; 
  FFastBmp.Canvas.FillRect(FFastBmp.Canvas.ClipRect);

  RReal :=GetRelativeRect;
  RReal:=Rect(RReal.Left+Width,RReal.Top,RReal.Right,RReal.Bottom);
  iStart:=Trunc((RReal.Left-R.Left) / Width);
  iEnd:=iStart+ RealRound((RReal.Right-RReal.Left) / Width);

  //开会决定 没有卡片时也要显示栏位 2006-7-27
  {if iEnd>GetSchemeDataTree.MaxNodeItemCount-1 then
     iEnd:=GetSchemeDataTree.MaxNodeItemCount-1; }

  for J:=iStart to iEnd do
  begin
    RSou:=Rect((J-iStart)*Width ,0,(J-iStart+1)*Width,FFastBmp.Height);
    PaintHeadContent(nil,FFastBmp.Canvas,RSou,J);
  end;

  RSou:=Rect(DLeft,0,FFastBmp.Width+DLeft,FFastBmp.Height);
  RDes := Rect(R.Left,0,R.Left+ FFastBmp.Width,FFastBmp.Height);
  Canvas.CopyRect(RDes,FFastBmp.Canvas,RSou);

end;

procedure TMFCardHeadPaint.PaintHeadContent(Item: TMFSchemeDataItem;
  ACanvas: TCanvas; R: TRect;AIndex:Integer);
begin
  LocalCanvas.DefCanvas:= ACanvas;
  LocalCanvas.Brush.Style:=bsSolid;
  LocalCanvas.Brush.Color:=clBtnFace;

  LocalCanvas.DefCanvas.FillRect(R);
  LocalCanvas.DrawComplexFrame(R,clBtnHighlight,clBtnShadow);
  LocalCanvas.Brush.Color:=clBtnFace;
  LocalCanvas.DrawTexT(IntToStr(AIndex+1),R,gAlignCenter);
end;

procedure TMFCardHeadPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

{ TMFCardContentPaint }

procedure TMFCardContentPaint.Paint;
var
  R,Ra,Rb,AReal:TRect;
  I,J,Height,Width,iTop,iBottom,DTop,DLeft,iStart,iEnd:Integer;
  Node:TMFSchemeDataTreeNode;
begin
  inherited;
  R:=GetClientRect;
  AReal := GetRealRect;
  iTop:=AReal.Top;
  Height:= 0;
  if GetSchemeDataTree.MaxNodeItemCount>0 then
  For I:=0 to GetSchemeDataTree.Count -1 do
  begin
    Node:=TMFSchemeDataTreeNode(GetSchemeDataTree.Items[I]);
    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;
    
    DTop:=0;
    if iTop< R.Top then
      DTop:=R.Top-iTop;

    Width:=TMFCardSchemeView(SchemeView).ContentOptions.CardWidth;

    DLeft:=0;
    if AReal.Left < R.Left then
      DLeft:=(R.Left-AReal.Left) mod Width;
    
    if iBottom< R.Top then Continue;
    if iTop>R.Bottom  then Continue;

    FFastBmp.Width := (Round((R.Right-R.Left) / Width)+1)*Width;
    FFastBmp.Height:= Node.Height;
    FFastBmp.FreeImage;
    
    iStart:=Round((AReal.Left-R.Left) / TMFCardSchemeView(SchemeView).ContentOptions.CardWidth);
    iEnd:=iStart+ Round((AReal.Right-AReal.Left) / TMFCardSchemeView(SchemeView).ContentOptions.CardWidth);

    if iEnd>GetSchemeDataTree.MaxNodeItemCount-1 then
     iEnd:=GetSchemeDataTree.MaxNodeItemCount-1;
     
    FFastBmp.Canvas.Brush.Color :=clWhite;
    FFastBmp.Canvas.FillRect(FFastBmp.Canvas.ClipRect);

    for J:=iStart to iEnd do
    begin
      Ra:=Rect((J-iStart)*Width ,0,(J-iStart+1)*Width,FFastBmp.Height);
      PaintContentItem(Node.DataItems[J],FFastBmp.Canvas,Ra);
    end;
    //PaintContentItem(Node,FFastBmp.Canvas,Ra);
    Ra:=Rect(DLeft,DTop,DLeft+FFastBmp.Width ,FFastBmp.Height);
    Rb := Rect(R.Left,iTop+DTop,R.Left+FFastBmp.Width ,iBottom);
    Canvas.CopyRect(Rb,FFastBmp.Canvas,Ra);
  end;
end;

function TMFCardContentPaint.PaintCardStyle(Item: TMFSchemeDataItem;
  ACanvas: TCanvas; R: TRect):TRect;
var RRight,RBottom: TRect;
begin
  InflateRect(R,-2,-2);
  Result:=Rect(R.Left,R.Top,R.Right-3,R.Bottom-3 );
  RRight:= Rect(R.Right-3,R.Top+3,R.Right,R.Bottom );
  RBottom:= Rect(R.Left+3,R.Bottom-3,R.Right,R.Bottom );
  ACanvas.Brush.Style :=bsSolid;
  ACanvas.Brush.Color := cl3DDkShadow;
  ACanvas.FillRect(RRight);
  ACanvas.FillRect(RBottom);
  LocalCanvas.Canvas:= ACanvas ;
  //LocalCanvas.DrawComplexFrame(R,cl3DLight,cl3DDkShadow,[dleft,dtop,dright,dbottom],3);
end;


procedure TMFCardContentPaint.PaintContentItem(Item: TMFSchemeDataItem; ACanvas:TCanvas;
  R: TRect);
var RClient:TRect;
begin
  LocalCanvas.DefCanvas:= ACanvas;
  if (Item<>nil) then
  begin
    RClient:=PaintCardStyle(Item,ACanvas,R);
    if  Item.Selected then
    begin
      LocalCanvas.Brush.Color:=clHighlight ;
      LocalCanvas.DefCanvas.FillRect(RClient);
      LocalCanvas.DrawTexT(Item.Text,RClient,gAlignCenter);
      LocalCanvas.DrawComplexFrame(RClient,clBtnShadow,clBtnShadow,DrawBordersAll);
      if Scheme.Focused then LocalCanvas.DrawFocusRect(RClient);
    end
    else begin
    
      LocalCanvas.Brush.Color:=Item.Color;
      LocalCanvas.DefCanvas.FillRect(RClient);
      LocalCanvas.DrawTexT(Item.Text,RClient,gAlignCenter);
      LocalCanvas.DrawComplexFrame(RClient,clBtnShadow,clBtnShadow,DrawBordersAll);
    end;
    
  end
  else begin
    LocalCanvas.Brush.Color:=clWhite;
    LocalCanvas.DefCanvas.FillRect(R);
  end;

  LocalCanvas.DrawComplexFrame(R,clBtnShadow,clBtnShadow,[dRight, dBottom]);

  SchemeView.PaintItem(SchemeView,Item,ACanvas,RClient);
  
end;

procedure TMFCardContentPaint.PaintRow(Node: TMFSchemeDataTreeNode;
  ACanvas: TCanvas; R,RealRect: TRect);
var
  RClient,RSou,RDes,RReal:TRect;
  J,Width,DLeft,iStart,iEnd:Integer;
begin
  inherited;
  RReal := GetRealRect;
  RClient:= GetClientRect;
  //开会决定 没有卡片时也要显示栏位
  //if GetSchemeDataTree.MaxNodeItemCount>0 then
  begin

    Width:=TMFCardSchemeView(SchemeView).ContentOptions.CardWidth;
    DLeft:=0;
    
    if RReal.Left < RClient.Left then
      DLeft:=(RClient.Left-RReal.Left) mod Width;

    FFastBmp.Width := (RealRound((R.Right-R.Left) / Width)+1)*Width;
    FFastBmp.Height:= Node.Height;
    ClearFastBmp(clWhite);


    iStart:=Trunc((RClient.Left-RReal.Left) / Width);

    iEnd:=iStart+ RealRound((RReal.Right-RReal.Left) / Width);

    //开会决定 没有卡片时也要显示栏位
    {if iEnd>GetSchemeDataTree.MaxNodeItemCount-1 then
     iEnd:=GetSchemeDataTree.MaxNodeItemCount-1; }

    ClearFastBmp(clWhite);

    for J:=iStart to iEnd do
    begin
      RSou:=Rect((J-iStart)*Width ,0,(J-iStart+1)*Width,FFastBmp.Height);
      PaintContentItem(Node.DataItems[J],FFastBmp.Canvas,RSou);
    end;
    //PaintContentItem(Node,FFastBmp.Canvas,Ra);
    RSou:=Rect(DLeft,R.Top ,DLeft+FFastBmp.Width ,R.Bottom);
    RDes := Rect(R.Left,R.Top,R.Left+FFastBmp.Width ,R.Bottom);
    ACanvas.CopyRect(RDes,FFastBmp.Canvas,RSou);
  end;
end;

procedure TMFCardContentPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

{ TMFCardContentOptions }

procedure TMFCardContentOptions.Assign(Source: TPersistent);
begin
  inherited;
  FCardWidth:= TMFCardContentOptions(Source).CardWidth;
end;


constructor TMFCardContentOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited;
  FCardWidth:=100;
end;

procedure TMFCardContentOptions.SetCardWidth(const Value: Integer);
begin
  if FCardWidth<> Value then
  begin
    FCardWidth := Value;
    Change; 
  end;
end;

{ TMFCardViewControl }

procedure TMFCardViewControl.BeginDrag(Immediate: Boolean;
  Threshold: Integer);
begin
  StartScrollTimer;
  SchemeView.ParentScheme.BeginDrag(Immediate,Threshold);
end;

function TMFCardViewControl.Calc(R: TRect; APoint: TPoint): TRect;
var
  RClient,RNode:TRect;
  AViewHitInfo:TViewHitInfo;
begin
  with SchemeView.FCardPaint.FCardCalculater do
  begin
    RClient:=GetPaintClass(TMFContentPaint).GetClientRect;

    case MoveRec.MoveType of
      cmTreeSize : R.Right:=APoint.X;
      cmItemLeft : begin
		    R.Left:=APoint.X;

		  end;
      cmItemRight: begin
		    R.Right:=APoint.X;
		    if RClient.Left>R.Left then
		      R.Left:=RClient.Left;
		  end;
      cmItemMove :begin
		   OffsetRect(R,APoint.X-MoveRec.DownPoint.X,0);
		   AViewHitInfo:=GetHitInfo(APoint);
		   if  AViewHitInfo.ANode<>nil then
		   begin
		     RNode:=AViewHitInfo.ANode.GetNodeRect;
		     R:=Rect(R.Left,RNode.Top,R.Right,RNode.Bottom);
		     
		   end
		 end;
    end;
  end;
  Result:=R;
end;

constructor TMFCardViewControl.Create(AView: TMFCardSchemeView);
begin
  inherited Create(AView);
  MoveRec.MoveType:=cmNone;
  MoveRec.AItem:=nil;
end;

procedure TMFCardViewControl.ScorllMessage(hwnd:HWND;Msg:Cardinal;wParam,lParam:Integer);
var Position,MaxLength:Integer;
begin

  with SchemeView,ParentScheme do
  if Msg=WM_VSCROLL then
  begin
    Position:=VertScrollBar.Position;
    if wParam= SB_LINEUP then
    begin
      Position:=Position-50;
      if Position>=0 then
      begin
	VertScrollBar.Position:= Position;
	MoveRec.MoveType:=cmNone;
      end
      else
       if  VertScrollBar.Position<>0 then
       begin
	 VertScrollBar.Position:= 0;
	 MoveRec.MoveType:=cmNone;
       end;
    end;
    if wParam= SB_LINEDOWN then
    begin
      Position:=Position+50;
      MaxLength:= GetWholeHeight-GetClientRect.Bottom;
      if Position<=MaxLength then
      begin
	VertScrollBar.Position:= Position;
	MoveRec.MoveType:=cmNone;
      end
      else
	if  VertScrollBar.Position<>MaxLength then
	begin
	  VertScrollBar.Position:= MaxLength;
	  MoveRec.MoveType:=cmNone;
	end;
     end;

    {if (wParam= SB_LINEUP) and (VertScrollBar.Position<>0) then
   begin
     SendMessage(hwnd, Msg,wParam,lParam);
     MoveRec.MoveType:=gmNone;
   end;
   if (wParam= SB_LINEDOWN) and (VertScrollBar.Position<>GetWholeHeight) then
   begin
     SendMessage(hwnd, Msg,wParam,lParam);
     MoveRec.MoveType:=gmNone;

   end;}

  end
  else
  begin

    Position:=HorzScrollBar.Position;
    if wParam= SB_LINELEFT then
    begin
      Position:=Position-50;
      if Position>=0 then
      begin
	HorzScrollBar.Position:= Position;
	MoveRec.MoveType:=cmNone;
      end
      else
	if  HorzScrollBar.Position<>0 then
	begin
	  HorzScrollBar.Position:= 0;
	  MoveRec.MoveType:=cmNone;
	end;
    end;

    if wParam= SB_LINEDOWN then
    begin
      Position:=Position+50;
      MaxLength:= GetWholeWidth-GetClientRect.Right;
      if Position<=MaxLength then
      begin
	HorzScrollBar.Position:= Position;
	MoveRec.MoveType:=cmNone;
      end
      else
	if  HorzScrollBar.Position<>MaxLength then
	begin
	  HorzScrollBar.Position:= MaxLength;
	  MoveRec.MoveType:=cmNone;
	end;
    end;

  end;

end;

procedure TMFCardViewControl.DoScrollTimer;
var pLocal:TPoint;
begin    
  GetCursorPos(pLocal);
  with SchemeView.ParentScheme  do
  begin
    
    Windows.ScreenToClient(Handle,pLocal);

    if (pLocal.Y <(25)) And (pLocal.Y >-5)  then
      ScorllMessage(Handle, WM_VSCROLL,SB_LINEUP , 0);

    if (pLocal.Y >(Height-25)) And (pLocal.Y <Height+5)  then
      ScorllMessage(Handle, WM_VSCROLL,SB_LINEDOWN , 0);

    if (pLocal.X <(25)) And (pLocal.X >-50) then
      ScorllMessage(Handle, WM_HSCROLL,SB_LINELEFT , 0);

    if (pLocal.X >Width-50) And (pLocal.X <Width) then
      ScorllMessage(Handle, WM_HSCROLL,SB_LINERIGHT , 0);

  end;
end;

procedure TMFCardViewControl.DragCanceled;
var RClient:TRect;
begin
  with SchemeView.FCardPaint.FCardCalculater do
  begin
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
    SchemeView.FCardPaint.PaintMoveSize(RClient);
    MoveRec.MoveType:=cmNone;
    EndDrag(False); 
  end;
end;

procedure TMFCardViewControl.DragItemDrop(Source: TObject; X, Y: Integer);
var
  RClient:TRect; AViewHitInfo:TViewHitInfo;
  bAccept:Boolean;
  J:Integer;
  AdjustMoveType: TAdjustMoveType;
begin
  inherited;
  if not IsReadOnly then
  if (Source = SchemeView.ParentScheme) then
  with SchemeView,GetSchemeDataTree,SchemeView.FCardPaint.FCardCalculater do
  begin
    MoveRec.NPoint :=Point(X, Y);
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
    SchemeView.FCardPaint.PaintMoveSize(RClient);
    RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
    AViewHitInfo:=GetHitInfo(MoveRec.NPoint);

    SchemeView.BeginUpdate;
    for J:=0  to SelectionItemCount-1 do
    begin
      bAccept:=True;
      
      SchemeView.BeforDragItemDown(Source,SelectionsItem[J],AViewHitInfo.ANode,bAccept,X,Y);
      if bAccept then
      begin
	if  AViewHitInfo.ANode<>nil then
	begin

	  if AViewHitInfo.AItem<>nil  then
	  begin
	    if AViewHitInfo.AItem<>SelectionsItem[J] then
	      SelectionsItem[J].MoveTo(AViewHitInfo.AItem,imtInsert)
	  end
	  else
	    SelectionsItem[J].MoveTo(AViewHitInfo.ANode);
	end;

	SchemeView.AfterDragItemDown(Source,SelectionsItem[J],AViewHitInfo.ANode,bAccept,X,Y);
      end;
      
    end;
    AdjustMoveType:=amtDefault;
    
    SchemeView.AdjustDragDrop(AViewHitInfo.ANode,AdjustMoveType);
    
    AdjustDragDrop(AViewHitInfo.ANode,AdjustMoveType);
    
    SchemeView.EndUpdate;

    SchemeView.FCardPaint.PaintRowList();
    MoveRec.OPoint:= MoveRec.NPoint;
    MoveRec.MoveType:=cmNone;

    EndDrag(True);
  end;
end;

function TMFCardViewControl.Dragging: Boolean;
begin
  Result:= SchemeView.ParentScheme.Dragging;
end;

procedure TMFCardViewControl.DragItemOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  RClient:TRect;
  AViewHitInfo:TViewHitInfo;
begin
  inherited;
  Accept:=False;
  if not IsReadOnly then
  With SchemeView.FCardPaint.FCardCalculater,SchemeView.ParentScheme do
  begin
    AViewHitInfo:= GetHitInfo(Point(X,Y));
    if Source = SchemeView.ParentScheme then
    begin
      Accept:=True;
      SchemeView.DragItemOver(SchemeView,MoveRec.AItem,AViewHitInfo.ANode,Accept,X,Y);

      MoveRec.NPoint:=Point(X,Y);
      if MoveRec.MoveType=cmItemMove then
      begin
	RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
	SchemeView.FCardPaint.PaintMoveSize(RClient);
      end;

      MoveRec.MoveType:=cmItemMove;
      RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
      SchemeView.FCardPaint.PaintMoveSize(RClient);

      MoveRec.OPoint:=MoveRec.NPoint;
    end
    else begin
      Accept:=False;
      SchemeView.DragItemOver(SchemeView,MoveRec.AItem,AViewHitInfo.ANode,Accept,X,Y);

    end;
  end;
end;

procedure TMFCardViewControl.EndDrag(Drop: Boolean);
begin
  EndScrollTimer;
  SchemeView.ParentScheme.EndDrag(Drop);
end;

procedure TMFCardViewControl.EndScrollTimer;
begin
  if FTimerID <> 0 then
    KillTimer(SchemeView.ParentScheme.Handle, FTimerID);
  FTimerID:=0;  
end;

function TMFCardViewControl.GetSchemeView: TMFCardSchemeView;
begin
  Result := TMFCardSchemeView(FBaseView);
end;

procedure TMFCardViewControl.KeyDown(var Key: Word; Shift: TShiftState);
var Node:TMFSchemeTreeNode;
begin
  inherited;
  with SchemeView,SchemeView.GetSchemeDataTree do
  begin
    case Key of
      VK_DOWN : if CanNodeKeyDown then
		begin
		  if Selected.NextNode<>nil then
		  begin
		    Node:= Selected.NextNode;

		    while Node<>nil do
		    begin  
		      if Node.Visible then
			Break;
		      Node:= Node.NextNode;
		    end;

		    if Node<>nil then
		    begin
		      SchemeView.BeginUpdate;
		      ClearSelection(True);
		      Node.Selected:=True;
		      Selected.Selected:=False;
		      SchemeView.EndUpdate;
		      if TreeOptions.AutoMoveToSelect then
			NeedScroll(TMFSchemeDataTreeNode(Node));
		    end;
		  end;
		end;

      VK_UP   :  if CanNodeKeyDown then
		begin
		  
		  if Selected.PrevNode<>nil then
		  begin

		    Node:= Selected.PrevNode;

		    while Node<>nil do
		    begin  
		      if Node.Visible then
			Break;
		      Node:= Node.PrevNode;
		    end;

		    if Node<>nil then
		    begin
		      SchemeView.BeginUpdate;
		      ClearSelection(True);
		      Node.Selected:=True;
		      Selected.Selected:=False;
		      SchemeView.EndUpdate;
		      if TreeOptions.AutoMoveToSelect then
			NeedScroll(TMFSchemeDataTreeNode(Node));
		    end;
		  end;

		end;
      
      VK_RIGHT: HScrollPage(False);

      VK_LEFT : HScrollPage(true);

      VK_PRIOR: VScrollPage(True);

      VK_NEXT : VScrollPage(False);		
    end;
  end;
end;

procedure TMFCardViewControl.KeyPress(var Key: Char);
begin

end;

procedure TMFCardViewControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AViewHitInfo:TViewHitInfo;
  RClient:TRect;
begin
    //Andyzhang Change mouse Select Item Type
  if CheckItemSeleMFype(Button,SchemeView.ContentOptions.ItemSeleMFype) then
  with SchemeView,SchemeView.FCardPaint.FCardCalculater do
  begin
    AViewHitInfo:=GetHitInfo(Point(X,y));
    MoveRec.ARect:=Rect(0,0,0,0);
    if  AViewHitInfo.APaintClass.InheritsFrom(TMFSchemeTreePaint)
      and (AViewHitInfo.ANode<>nil) then
    begin
      if AViewHitInfo.AhitType=pNodePlus then
      begin
	AViewHitInfo.ANode.Expanded:=not AViewHitInfo.ANode.Expanded;
	AdjustScrollBar(sbVertical);
        Invalidate;
      end
      else
      begin
	GetSchemeDataTree.ClearSelection();
	AViewHitInfo.ANode.Selected:= True;
	FCardPaint.Paint(AViewHitInfo.APaintClass);
	FCardPaint.Paint(FCardPaint.FCardCalculater.GetPaintClass(TMFIndicaterPaint));
      end;

    end;// end if


    if AViewHitInfo.AHitType in [pItem,pTreeRight,pItemLeft,pItemRight] then
    begin
      MoveRec.DownPoint := Point(X,Y);
      MoveRec.OPoint :=  Point(X,Y);
      MoveRec.MoveType := cmNone;
      Case AViewHitInfo.AHitType of
	pTreeRight:begin
		     MoveRec.MoveType := cmTreeSize;
		     MoveRec.ARect:=GetPaintClass(TMFSchemeTreePaint).GetClientRect;
		     MoveRec.ARect.Top:=GetPaintClass(TMFHeadPaint).GetClientRect.Top;
		   end;

	pItemLeft :if (not IsReadOnly) and (AViewHitInfo.AItem<>nil) and AViewHitInfo.AItem.Enabled then
		   begin
		     MoveRec.MoveType := cmItemLeft;
		     MoveRec.ARect:= AViewHitInfo.AItem.GetItemClientRect;
		     MoveRec.AItem:=AViewHitInfo.AItem;
		   end;

	pItemRight:if (not IsReadOnly) and (AViewHitInfo.AItem<>nil) and AViewHitInfo.AItem.Enabled then
		   begin
		     MoveRec.MoveType := cmItemRight;
		     MoveRec.ARect:= AViewHitInfo.AItem.GetItemClientRect;
		     MoveRec.AItem:=AViewHitInfo.AItem;
		   end;
	pItem     :if not IsReadOnly then
		   if (AViewHitInfo.AItem<>nil) and AViewHitInfo.AItem.Enabled then
		    Begin
		      MoveRec.MoveType := cmItemMove;
		      MoveRec.ARect:= AViewHitInfo.AItem.GetItemClientRect;
		      MoveRec.AItem:=AViewHitInfo.AItem;
		    end;
      end;
      RClient:=Calc(MoveRec.ARect,MoveRec.DownPoint);
      if AViewHitInfo.AHitType<>pItem then
	FCardPaint.PaintMoveSize(RClient);
    end;

    //if not IsReadOnly then
    if (AViewHitInfo.AItem=nil) and
      (AViewHitInfo.APaintClass.InheritsFrom(TMFContentPaint)) then
    begin
       GetSchemeDataTree.ClearItemSelection();
       FCardPaint.Paint(AViewHitInfo.APaintClass);
    end;

    //if not IsReadOnly then
    if  AViewHitInfo.APaintClass.InheritsFrom(TMFContentPaint)
    and (AViewHitInfo.ANode<>nil) and (AViewHitInfo.AItem<>nil) then
    with GetSchemeDataTree,AViewHitInfo do
    begin

      //MultiSelect
      if FContentOptions.MultiSelect then

      begin
	if ssCtrl in Shift then
	begin
	  AItem.Selected:=not AItem.Selected;

	end
	else begin
	  if SelectionItemCount>1 then
	  begin
	    if not AItem.Selected then
	    begin
	      ClearItemSelection();
	      AItem.Selected:=True;
	    end;
	  end
	  else begin
	    ClearItemSelection();
	    AItem.Selected:=True;
	  end;
	end;

      end
      else begin
	ClearItemSelection();
	AItem.Selected:=True;
      end;


      ActiveDataItem:=AItem;
      FCardPaint.Paint(APaintClass);
    end;
  end;
  //ShowMessage(P.APaintClass.ClassName+P.ANode.Caption);
end;

procedure TMFCardViewControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var RClient:TRect;
begin
  inherited;
  if MoveRec.MoveType<>cmNone then
  begin
    MoveRec.NPoint:=Point(X,Y);
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);

    case MoveRec.MoveType of
      cmTreeSize:
		begin
		  SchemeView.FCardPaint.PaintMoveSize(RClient);
		  RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
		  SchemeView.FCardPaint.PaintMoveSize(RClient);
		end;

      cmItemMove:begin
		  //SchemeView.FGunterPaint.PaintMoveSize(RClient);
		  //RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
		  //SchemeView.FGunterPaint.PaintMoveSize(RClient);
		  SchemeView.ParentScheme.DragCursor:=crSizeAll;
		  BeginDrag(False);
	        end;
    end;
    MoveRec.OPoint:=MoveRec.NPoint;
  end;

end;

procedure TMFCardViewControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var RClient,R:TRect; dEnd:TDateTime;
begin
  inherited;  
  with SchemeView.FCardPaint, FCardCalculater do
  if MoveRec.MoveType in [cmItemLeft,cmItemRight,cmTreeSize] then
  begin
    MoveRec.NPoint:=Point(X,Y);
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
    PaintMoveSize(RClient);
    RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
    R:=SchemeView.GetClientRect;

    if (RClient.Right-RClient.Left)<5 then
      RClient.Right:=RClient.Left+5;

    if (RClient.Right>R.Right) then
      RClient.Right:=R.Right-5;

    case MoveRec.MoveType of
      cmItemLeft :begin

		  end;
      cmItemRight:begin


		  end;
      cmTreeSize :begin
		    SchemeView.TreeOptions.Width:= RClient.Right-RClient.Left;
		    AdjustScrollBar(sbHorizontal);
		  end;
    end;

    
    if UnionRect(R,RClient,MoveRec.ARect) then
       RClient:=R;
    InflateRect(RClient,1,0) ;
    SchemeView.Update;
    MoveRec.AItem:=nil;
    MoveRec.OPoint:=MoveRec.NPoint; 
  end;
  MoveRec.MoveType:=cmNone;
end;

procedure TMFCardViewControl.StartScrollTimer;
begin
  if FTimerID = 0 then
    FTimerID:= SetTimer(SchemeView.ParentScheme.Handle, 1, 200, nil);
end;

procedure TMFCardViewControl.TreeChanged(AEventType: TEventType;
  AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin
  if SchemeView.IsNotifyChange then
  begin
    case AEventType of
      eNode: begin
	       SchemeView.Update;
	     end;
      eItem:begin SchemeView.Update; end;

      eItemLink:begin SchemeView.Invalidate; end;
    end;

  end;
end;

procedure TMFCardViewControl.AdjustScrollBar(ScrollBarKind:TScrollBarKind);
begin
  with SchemeView , ParentScheme do
  if ScrollBarKind= sbVertical then
  begin
    if VertScrollBar.Position> GetWholeHeight-GetClientRect.Bottom then
      VertScrollBar.Position :=GetWholeHeight-GetClientRect.Bottom;

  end
  else begin
    if HorzScrollBar.Position> GetWholeWidth-GetClientRect.Right then
      HorzScrollBar.Position :=GetWholeWidth-GetClientRect.Right;

  end;
  SchemeView.UpdateScroll;
end;

procedure TMFCardViewControl.SetCursor(var Message: TWMSetCursor);
var
  APoint: TPoint;
  AViewHitInfo:TViewHitInfo;
begin
  inherited;
  with SchemeView do
  if (not (csDesigning in ComponentState))  then
  begin
    GetCursorPos(APoint);
    AViewHitInfo:=FCardPaint.FCardCalculater.GetHitInfo(ScreenToClient(APoint));
    case AViewHitInfo.AHitType of
      pTreeRight:
	begin
	  Message.Result := 1;
	  Windows.SetCursor(Screen.Cursors[crHSplit])
	end;

      pNone:
	begin
	  Message.Result := 1;
	  Windows.SetCursor(Screen.Cursors[crDefault]);
	end;
    end;
  end;
end;

procedure TMFCardViewControl.AdjustDragDrop(
  NewNode: TMFSchemeDataTreeNode; var AdjustMoveType: TAdjustMoveType);
begin

end;

procedure TMFCardViewControl.NeedScroll(Node:TMFSchemeDataTreeNode);
var
 R,RClient:TRect;iHeight,Percent:Integer;
begin
 with SchemeView.FCardPaint.FCardCalculater do
 begin
   R := Node.GetNodeRect;
   RClient := GetPaintClass(TMFSchemeTreePaint).GetClientRect;
       
   if R.Top< RClient.Top then ScrolltoNode(Node,0);
       
   if R.Bottom> RClient.Bottom then
   begin
     iHeight:=RClient.Bottom-RClient.Top;
     Percent:=Trunc((iHeight-Node.Height) /iHeight *100);

     ScrolltoNode(Node,Percent);
   end;
 end;
end;


procedure TMFCardViewControl.ScrolltoLeft(Value:integer;Percent:Integer=30);
var
  iLeft,iWidth,I:Integer;
  RClient:TRect;
begin
  with SchemeView.FCardPaint.FCardCalculater,SchemeView.ParentScheme.HorzScrollBar do
  begin
    iLeft := Value;
    RClient:=GetPaintClass(TMFContentPaint).GetClientRect;
    iWidth:=Trunc((RClient.Right- RClient.Left)*Percent/100);
    I:=iLeft-iWidth;

    if I<0 then I:=0;
    if I>SchemeView.GetWholeWidth then I:=SchemeView.GetWholeWidth;

    Position:= i;

  end;
end;

procedure TMFCardViewControl.ScrolltoNode(Node: TMFSchemeDataTreeNode;
  Percent: Integer);
var
  iTop,iHeight,I:Integer;
  P:TPoint;
  RClient:TRect;
begin
  if Node<>nil then
  with SchemeView.FCardPaint.FCardCalculater,SchemeView.ParentScheme.VertScrollBar do
  begin
    P:=SchemeView.GetOffSetPoint;

    RClient:=GetPaintClass(TMFSchemeTreePaint).GetClientRect;

    iTop :=Node.GetNodeRect.Top+P.Y-RClient.Top;

    iHeight:=Trunc((RClient.Bottom- RClient.Top)*Percent/100);
    I:=iTop-iHeight;

    if I<0 then I:=0;
    if I>SchemeView.GetWholeHeight then I:=SchemeView.GetWholeHeight;

    Position:= i;

  end;
end;

procedure TMFCardViewControl.HintShow(var Message: TCMHintShow);
var
  HintDataRec:^TMFHintDataRec;
  AViewHitInfo:TViewHitInfo;
  RClient,RItem:TRect;
  bNeedShow:Boolean;
  ADate:TDateTime;
  APoint:TPoint;
begin
  with Message.HintInfo^,SchemeView.FCardPaint.FCardCalculater do
  begin
    HintWindowClass:= TMFHintWindow;
    AViewHitInfo:= GetHitInfo(CursorPos);
    if not Dragging then
    with AViewHitInfo do
    begin
      New(HintDataRec);
      HintDataRec^.HintDataEvent := SetHintData;
      HintDataRec^.AViewHitInfo:=AViewHitInfo;
      HintData:= HintDataRec;

      Message.Result:=1;
      if APaintClass<>nil then
      begin
	if ANode<>nil then
	if APaintClass.InheritsFrom(TMFSchemeTreePaint) then
	begin
	  RClient:=GetNodeTextRect(ANode,bNeedShow);
	  if PtInRect(RClient,APoint) then
	    if bNeedShow then
	    begin
	      HintStr:=GetHintStr(AViewHitInfo);
	      CursorRect:=RClient;
	      //ReshowTimeout:=5000;
	      HideTimeout:=3000;
	      Message.Result:=0;
	    end;

	end;

	if AItem<>nil then
	if APaintClass.InheritsFrom(TMFContentPaint) then
	begin
	  RClient:=AItem.GetItemClientRect;
          InflateRect(RClient,10,10);
	  CursorRect:=RClient;
	  HintStr:=GetHintStr(AViewHitInfo);
	  RItem:=AItem.GetItemClientRect;

	  OffsetRect(RItem,0,(RItem.Bottom-RItem.Top));
	  APoint:=SchemeView.ClientToScreen(RItem.TopLeft);

	  HintPos:=APoint;
	  //ReshowTimeout:=5000;
	  HideTimeout:=3000;
	  Message.Result:=0;
	end;

      end;

    end
    else
      Message.Result:=1;
  end;
end;


procedure TMFCardViewControl.SetHintData(Sender: TObject; AViewHitInfo:TViewHitInfo;
  var HintRec:THintRec; var R: TRect; ACanvas: TCanvas);
begin
  with AViewHitInfo do
  begin
    HintRec.HintType := htImage;
    R:=Rect(0,0,100,100);
    
    if  APaintClass.InheritsFrom(TMFSchemeTreePaint) then
    begin
      HintRec.HintType := htText;
      //HintRec.Font.Color:=clWhite;
      HintRec.Color:=clInfoBk;
    end;

    if AItem<>nil then
    begin
      HintRec.HintType := htText;
      //HintRec.Font.Color:=clWhite;
      HintRec.Color:=clInfoBk;
    end;

    SchemeView.SetHintData(Self,AViewHitInfo,HintRec,R,ACanvas);
  end;

end;

procedure TMFCardViewControl.DblClick;
var P:TPoint;AViewHitInfo:TViewHitInfo;R:TRect;
begin
  inherited;
  if GetCursorPos(P) then
  begin
    P:=SchemeView.ScreenToClient(P);
    AViewHitInfo:=SchemeView.FCardPaint.FCardCalculater.GetHitInfo(P);
    SchemeView.DblClickView(SchemeView,AViewHitInfo);
    if AViewHitInfo.ANode<>nil then
    if AViewHitInfo.ANode.HasChildren then
    begin
      R:=AViewHitInfo.ANode.GetNodeRect;
      if PtInRect(R,P) then
      begin
	AViewHitInfo.ANode.Expanded:=not AViewHitInfo.ANode.Expanded;
	AdjustScrollBar(sbVertical);
	//SchemeView.Invalidate;
      end;
    end;
  end;

end;

procedure TMFCardViewControl.DragOtherDrop(Source: TObject; X,
  Y: Integer);
var AViewHitInfo:TViewHitInfo;
begin
  inherited;
  With SchemeView.FCardPaint.FCardCalculater do
  begin
    SchemeView.FCardViewControl.DoScrollTimer();
    AViewHitInfo:= GetHitInfo(Point(X,Y));
    SchemeView.DragOtherDrop(Source,AViewHitInfo,X,Y);
  end;
end;

procedure TMFCardViewControl.DragOtherOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var AViewHitInfo:TViewHitInfo;
begin
  inherited;
  With SchemeView.FCardPaint.FCardCalculater do
  begin
    AViewHitInfo:= GetHitInfo(Point(X,Y));
    SchemeView.DragOtherOver(Source,AViewHitInfo,Accept,X,Y);
  end;
end;

procedure TMFCardViewControl.HScrollPage(Direction: Boolean);
Var
  ScrollMessage:TWMVScroll;
begin
  ScrollMessage.Msg:=WM_HScroll;
  if Direction then
    ScrollMessage.ScrollCode:=SB_LINELEFT
  else
    ScrollMessage.ScrollCode:=SB_LINERIGHT;
  ScrollMessage.Pos:=0;
  ScrollMessage.ScrollBar:=0;
  SchemeView.ParentScheme.Dispatch(ScrollMessage);
end;

procedure TMFCardViewControl.VScrollPage(Direction: Boolean);
Var
  ScrollMessage:TWMVScroll;
begin
  ScrollMessage.Msg:=WM_VScroll;
  if Direction then
    ScrollMessage.ScrollCode:=SB_PAGEUP
  else
    ScrollMessage.ScrollCode:=SB_PAGEDOWN;
  ScrollMessage.Pos:=0;
  ScrollMessage.ScrollBar:=0;
  SchemeView.ParentScheme.Dispatch(ScrollMessage);
end;

function TMFCardViewControl.CanNodeKeyDown: Boolean;
begin
  with SchemeView,SchemeView.GetSchemeDataTree do
  if GetSchemeDataTree<>nil then
    if Selected<>nil then
      Result:=True
    else
      Result:=False;
end;

procedure TMFCardViewControl.ScrolltoItem(AItem: TMFSchemeDataItem);
begin
  ScrolltoNode(AItem.Parent);
  ScrolltoLeft(AItem.GetOffSetPoint.X,30);
end;

function TMFCardViewControl.GetHintStr(
  AViewHitInfo: TViewHitInfo): String;
begin
  with AViewHitInfo do
  begin
    if APaintClass<>nil then
    begin
      if ANode<>nil then
      if APaintClass.InheritsFrom(TMFSchemeTreePaint) then
      begin
        Result:=ANode.Caption;
      end;

      if AItem<>nil then
      if APaintClass.InheritsFrom(TMFContentPaint) then
      begin

        Result:=AItem.Text;

      end;

    end;

  end;
  Result:=SchemeView.GetHintStr(AViewHitInfo);
end;

initialization
  RegisteredViews.Register(TMFCardSchemeView,'CardSchemeView');
finalization
  RegisteredViews.Unregister(TMFCardSchemeView);
end.
