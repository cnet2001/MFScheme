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
	声明:本工程代码都是自己实现的没有其他任何第三方组件和代码

重构:   -2006-6-10     重构类 以及 类关系

	-2006-6-23  编写  TDrawCalculater
	-2006-6-23  编写  TMFAdvSchemePaint
	-2006-6-23  编写  TMFSchemeTreePaint
	-2006-6-23  编写  TMFIndicaterPaint
	-2006-6-23  编写  TMFHeadPaint
	-2006-6-23  编写  TMFFootPaint
	-2006-6-23  编写  TMFContentPaint
	-2006-7-25  编写  TMFHintWindow  开会决定Hint要灵活一点的

ToDo:

*******************************************************************************}

unit MFBaseSchemePainter;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,ImgList,StrUtils,
  StdCtrls,Forms,ExtCtrls,Graphics,Dialogs ,CommCtrl,ComCtrls,DateUtils,
  MFPaint,Variants,Math,MFBaseScheme,Types,MFBaseSchemeCommon;
type

  TDrawCalculater=class;

  TMFAdvSchemePaint=class;

  TMFBaseSchemePaintClass=class of TMFBaseSchemePaint;

  IZcDrawData=interface
    ['{E263896B-0E8D-4D51-BD14-A3D28C9AA105}']
    function GetSchemeDataTree:TMFSchemeDataTree;
    function GetDrawCalculater:TDrawCalculater;
    function GetDrawImageList:TImageList;
  end;

  TDrawCalculater=class(TInterfacedPersistent)
  private
    function GetScheme: TMFBaseScheme;
  protected
    FPaintList:TList;
    FControl: TMFBaseSchemeView;
    function GetItemCount: integer;
    function GetItemPainter(index: Integer): TMFAdvSchemePaint;
  public
    constructor Create(AControl: TMFBaseSchemeView); virtual;
    destructor Destroy; override;
    function GetPaintClass(APaintClass:TMFBaseSchemePaintClass):TMFAdvSchemePaint;
    function GetWholeHeight:Integer;virtual;
    function GetWholeWidth:Integer;virtual;
    function GetHitInfo(APoint:TPoint):TViewHitInfo;virtual;abstract;
    procedure DeletePainter(Index:Integer);overload;virtual;
    procedure DeletePainter(APaint:TMFBaseSchemePaint);overload;virtual;
    //当前屏幕位置
    function GetClientRect(APaint:TMFBaseSchemePaint):TRect;virtual;
    //相对位移
    function GetOffSetPoint(APaint:TMFBaseSchemePaint):TPoint;virtual;

    //以自己为参照物的相对位移  类式与Windows Api 的 GetViewportOrgEx
    //这里没有使用系统提供的函数是因为自己计算比较灵活控制

    function GetRealRect(APaint:TMFBaseSchemePaint):TRect;virtual;

    //以原点为参照物的相对位移  类式与Windows Api 的 GetWindowOrgEx
    
    function GetRelativeRect(APaint:TMFBaseSchemePaint):TRect;virtual;

    function GetVisible(APaint:TMFBaseSchemePaint):Boolean;virtual;
    function GetSchemeDataTree:TMFSchemeDataTree;
    function AddPainter(APaint:TMFBaseSchemePaintClass;PaintType:TPaintType=tPaint):TMFBaseSchemePaint;virtual;
    property ItemPainter[index:Integer]:TMFAdvSchemePaint read GetItemPainter;
    property ItemCount:integer read GetItemCount;
    property Scheme:TMFBaseScheme read GetScheme;
  end;

  TMFAdvSchemePaint=class(TMFBaseSchemePaint)
  private
  
  protected
    FZcDrawData:IZcDrawData;
    FFastBmp:TBitmap;
  public
    constructor Create(AControl: TMFBaseSchemeView);override;
    destructor Destroy; override;
    Procedure ClearFastBmp(AColor:TColor);virtual;
    function GetVisible: Boolean;override;
    function GetRealRect:TRect;virtual;
    function GetOffSetPoint:TPoint;virtual;
    function GetClientRect:TRect;virtual;
    function GetRelativeRect:TRect;virtual;
    function GetSchemeDataTree:TMFSchemeDataTree;virtual;
    function GetDrawCalculater:TDrawCalculater;virtual;
  end;

  TMFSchemeTreePaint=class(TMFAdvSchemePaint)
  private
    FOpenResBmp,FCloseResBmp: TBitmap;
  protected
    function GetTreeWidth: Integer;virtual;
  public
    constructor Create(AControl: TMFBaseSchemeView); override;
    destructor Destroy;override;
    procedure Paint; override;
    function GetImages:TImageList;
    procedure PaintRow(Node:TMFSchemeDataTreeNode;ACanvas:TCanvas;R,RealRect:TRect);override;
    procedure ZcInvalidate(const R: TRect);  override;
    property TreeWidth :Integer read GetTreeWidth ;
  end;

  TMFIndicaterPaint=class(TMFAdvSchemePaint)
  private

  protected

  public
    constructor Create(AControl: TMFBaseSchemeView); override;
    procedure Paint; override;
    procedure PaintRow(Node:TMFSchemeDataTreeNode;ACanvas:TCanvas;R,RealRect:TRect);override;
    procedure ZcInvalidate(const R: TRect);  override;
  end;

  TMFHeadPaint=class(TMFAdvSchemePaint)
  private
  protected
  public
    constructor Create(AControl: TMFBaseSchemeView); override;
    procedure Paint; override;
    procedure PaintHeadItem(Index:Integer;R:TRect);virtual;
    procedure ZcInvalidate(const R: TRect);  override;
  end;

  TMFFootPaint=class(TMFAdvSchemePaint)
  private

  protected

  public
    constructor Create(AControl: TMFBaseSchemeView); override;
    procedure Paint; override;
    procedure ZcInvalidate(const R: TRect);  override;
  end;

  TMFContentPaint=class(TMFAdvSchemePaint)
  private

  protected

  public
    constructor Create(AControl: TMFBaseSchemeView); override;
    procedure Paint; override;
    procedure ZcInvalidate(const R: TRect);  override;
  end;


  TMFDateTimeWindow = class(TCustomControl)
  private
    FActivating: Boolean;
    FBitMap:TBitmap;
    FHintType: THintType;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure NCPaint(DC: HDC); virtual;
    procedure Paint; override;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    function GetHintCanvas:TCanvas;
    function CalcHintRect(MaxWidth: Integer; const AHint: string;
      AData: Pointer): TRect; virtual;
    procedure Activate(Rect: TRect); virtual;
    procedure ReleaseHandle;
    property BiDiMode;
    property Caption;
    property Color;
    property Canvas;
    property Font;
    property HintType:THintType  read FHintType write FHintType;
  end;

  TMFHintWindow=class(THintWindow)
  private
    FHintType: THintType;

  protected
    FBitMap:TBitmap;
    FUserColor:TCOLOR;
    FText:String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure NCPaint(DC: HDC); override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string;
      AData: Pointer): TRect; override;
    property HintType:THintType  read FHintType write FHintType;
  end;

function CheckWinXP: Boolean;

implementation

{ TDrawCalculater }
function CheckWinXP: Boolean;
begin
  Result := (Win32MajorVersion > 5) or
    ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1));
end;

function TDrawCalculater.AddPainter(
  APaint: TMFBaseSchemePaintClass;PaintType:TPaintType): TMFBaseSchemePaint;
begin
  Result:=APaint.Create(FControl);
  Result.PaintType:=PaintType;
  FPaintList.Add(Result);
end;

constructor TDrawCalculater.Create(AControl: TMFBaseSchemeView);
begin
  FControl:= AControl;
  FPaintList:=TList.Create;
end;

procedure TDrawCalculater.DeletePainter(Index: Integer);
begin
  FPaintList.Delete(Index);
end;

procedure TDrawCalculater.DeletePainter(APaint: TMFBaseSchemePaint);
begin
  FPaintList.Delete(FPaintList.IndexOf(Pointer(APaint)));
end;

destructor TDrawCalculater.Destroy;
var I:Integer;
begin
  for i:=0 to FPaintList.Count -1 do
    TMFAdvSchemePaint(FPaintList.Items[i]).Free;
  FPaintList.Free;
  inherited;
end;

function TDrawCalculater.GetClientRect(APaint: TMFBaseSchemePaint): TRect;
begin

end;

function TDrawCalculater.GetItemCount: integer;
begin
  Result:=FPaintList.Count;
end;

function TDrawCalculater.GetItemPainter(
  index: Integer): TMFAdvSchemePaint;
begin
  Result:=TMFAdvSchemePaint(FPaintList.Items[index]);
end;

function TDrawCalculater.GetOffSetPoint(
  APaint: TMFBaseSchemePaint): TPoint;
begin

end;

function TDrawCalculater.GetPaintClass(
  APaintClass: TMFBaseSchemePaintClass): TMFAdvSchemePaint;
var I:Integer;
begin
  Result:=nil;
  for i:=0 to ItemCount-1 do
  if ItemPainter[i].InheritsFrom(APaintClass) then
  begin
    Result:= ItemPainter[i];
    Break;
  end;
end;

function TDrawCalculater.GetRealRect(APaint: TMFBaseSchemePaint): TRect;
begin

end;

function TDrawCalculater.GetRelativeRect(
  APaint: TMFBaseSchemePaint): TRect;
begin

end;

function TDrawCalculater.GetScheme: TMFBaseScheme;
begin
  Result:=FControl.ParentScheme;
end;

function TDrawCalculater.GetSchemeDataTree: TMFSchemeDataTree;
begin
  if Supports(FControl,IZcDrawData) then
     Result:=(FControl as IZcDrawData).GetSchemeDataTree;
end;

function TDrawCalculater.GetVisible(APaint: TMFBaseSchemePaint): Boolean;
begin
  Result:= False;
end;

function TDrawCalculater.GetWholeHeight: Integer;
begin
  Result:=0;
  if Scheme<>nil then
    Result:=Scheme.ClientHeight;
end;

function TDrawCalculater.GetWholeWidth: Integer;
begin
  Result:=0;
  if Scheme<>nil then
    Result:=Scheme.ClientWidth;
end;

{ TMFAdvSchemePaint }

procedure TMFAdvSchemePaint.ClearFastBmp(AColor: TColor);
begin
  with FFastBmp do
  begin
    Canvas.Pen.Style:=psClear;
    Canvas.Brush.Color:=AColor;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(FFastBmp.Canvas.ClipRect);
  end;
end;

constructor TMFAdvSchemePaint.Create(AControl: TMFBaseSchemeView);
begin
  inherited;
  if Supports(AControl,IZcDrawData) then
     FZcDrawData:=(AControl as IZcDrawData);
  FFastBmp:=TBitmap.Create;
end;

destructor TMFAdvSchemePaint.Destroy;
begin
  FFastBmp.Free; 
  inherited;
end;

function TMFAdvSchemePaint.GetClientRect: TRect;
begin
  Result:=FZcDrawData.GetDrawCalculater.GetClientRect(self);
end;

function TMFAdvSchemePaint.GetDrawCalculater: TDrawCalculater;
begin
  Result:=FZcDrawData.GetDrawCalculater;
end;

function TMFAdvSchemePaint.GetOffSetPoint: TPoint;
begin
  Result:=FZcDrawData.GetDrawCalculater.GetOffSetPoint(self);
end;

function TMFAdvSchemePaint.GetRealRect: TRect;
begin
  Result:=FZcDrawData.GetDrawCalculater.GetRealRect(self);
end;

function TMFAdvSchemePaint.GetRelativeRect: TRect;
begin
  Result:=FZcDrawData.GetDrawCalculater.GetRelativeRect(self);

end;

function TMFAdvSchemePaint.GetSchemeDataTree: TMFSchemeDataTree;
begin
  Result:=FZcDrawData.GetSchemeDataTree;
end;

function TMFAdvSchemePaint.GetVisible: Boolean;
begin
  Result:=FZcDrawData.GetDrawCalculater.GetVisible(self);
end;

{ TMFSchemeTreePaint }

constructor TMFSchemeTreePaint.Create(AControl: TMFBaseSchemeView);
begin
  inherited;
  FOpenResBmp := TBitmap.Create;
  FOpenResBmp.Handle := LoadBitmap(HInstance,'Open');

  FCloseResBmp:= TBitmap.Create;
  FCloseResBmp.Handle := LoadBitmap(HInstance,'close');
end;

destructor TMFSchemeTreePaint.Destroy;
begin
  FOpenResBmp.Free;
  FCloseResBmp.Free;
  inherited;
end;

function TMFSchemeTreePaint.GetImages: TImageList;
begin
  Result:=SchemeView.Images;
end;

function TMFSchemeTreePaint.GetTreeWidth: Integer;
begin
  Result :=150;
end;

procedure TMFSchemeTreePaint.Paint;
var
  R,RSou,RDes:TRect;
  I,Height,ATop,iTop,iBottom,DTop:Integer;
  Node:TMFSchemeDataTreeNode;
begin
  inherited;
  R:=GetClientRect;
  ATop :=Scheme.RealTop;
  iTop:=R.Top-ATop;
  Height:= 0;
  For I:=0 to GetSchemeDataTree.Count -1 do
  begin
    Node:= GetSchemeDataTree.Items[i];
    if Node.IsNotVisibleOrHide then  Continue;
    {if Node.Parent<>nil then
      if not Node.Parent.Expanded then Continue;}
    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;
    
    DTop:=0;
    if iTop< R.Top then
    begin
      DTop:=R.Top-iTop;
      //iTop:=R.Top;
    end; 
    
    if iBottom< R.Top then Continue;
    if iTop>R.Bottom  then Continue;
    
    FFastBmp.Width := R.Right-R.Left;
    FFastBmp.Height:= Node.Height;
    RSou:=Rect(0 ,0,FFastBmp.Width,FFastBmp.Height);
    FFastBmp.FreeImage;
    RDes := Rect(R.Left,iTop, R.Right,iBottom);

    PaintRow(Node,FFastBmp.Canvas,RSou,RDes);

    RSou:=Rect(0,DTop,FFastBmp.Width,FFastBmp.Height);
    RDes := Rect(R.Left,iTop+DTop, R.Right,iBottom);
    Canvas.CopyRect(RDes,FFastBmp.Canvas,RSou);
  end;

end;

procedure TMFSchemeTreePaint.PaintRow(Node: TMFSchemeDataTreeNode;ACanvas:TCanvas;
  R,RealRect: TRect);
var
  P:TPoint;Ra,RClient:TRect;ImageWidth,ImageTop:integer;
  ABorders: TDrawBorders;Iml:TImageList;
begin
  RClient:=R;
  ImageWidth := 0;
  Iml:=GetImages;
  if Iml<>nil then ImageWidth:=Iml.Width+2;

  LocalCanvas.DefCanvas:= FFastBmp.Canvas;
  FFastBmp.Width:=R.Right;
  FFastBmp.Height:=R.Bottom-R.Top ;
  with  LocalCanvas do
  begin
    Brush.Style:=bsSolid;
    if SchemeView.IndicaterOptions.Visible then
      ABorders:=[dRight, dBottom]
    else
      ABorders:=[dLeft,dRight, dBottom];
    if  Node.Selected  then
    begin
      Brush.Color:=clHighlight ;
      DefCanvas.FillRect(R);
      DrawComplexFrame(R,clBtnShadow,clBtnShadow,ABorders);
      if Scheme.Focused then DrawFocusRect(R);
    end
    else
    begin
      Brush.Color:=clWhite;
      DefCanvas.FillRect(R);
      DrawComplexFrame(R,clBtnShadow,clBtnShadow,ABorders);
    end;
    LocalCanvas.Brush.Style :=bsClear ;

    if Node.HasChildren then
    begin
      P:=CenterPoint(R);
      
      Ra:=Rect(R.Left+4,P.Y-5,R.Left+15,P.Y+6);
      OffsetRect(Ra,SchemeView.TreeOptions.Indent*Node.Level,0);

      if not Node.Expanded then
	DefCanvas.Draw(Ra.Left,Ra.Top,FCloseResBmp)
      else
	DefCanvas.Draw(Ra.Left,Ra.Top,FOpenResBmp);
      {
      Pen.Color := clLtGray;
      DefCanvas.Rectangle(Ra);
      Pen.Color := clBlack;

      MoveTo(Ra.Left+2,P.Y);
      LineTo(Ra.Left+9,P.Y);
      if not Node.Expanded then
      begin
	MoveTo(Ra.Left+5,P.Y-3);
	LineTo(Ra.Left+5,P.Y+4);
      end; }
    end;
    OffsetRect(R,20+SchemeView.TreeOptions.Indent*Node.Level,0);

    Font.Assign(SchemeView.TreeOptions.Font);

    if  Iml<>nil then
      ImageTop:= (R.Bottom -R.Top - Iml.Height) div 2
    else
      ImageTop:=0;
        
    if Node.Selected then
    begin
      Font.Color:=InvertColor(Font.Color);
      if  Iml<>nil then
        Iml.Draw(FFastBmp.Canvas,R.Left,R.Top+ImageTop,Node.SelectedIndex );
    end
    else
      if  Iml<>nil then
	Iml.Draw(FFastBmp.Canvas,R.Left,R.Top+ImageTop,Node.ImageIndex );


    R.Left := R.Left+ImageWidth;
    DrawTexT(Node.Caption,R,gAlignVCenter);
    
  end;

  ACanvas.CopyRect(RClient,FFastBmp.Canvas,RClient);
end;

procedure TMFSchemeTreePaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

{ TMFIndicaterPaint }



constructor TMFIndicaterPaint.Create(AControl: TMFBaseSchemeView);
begin
  inherited;

end;

procedure TMFIndicaterPaint.Paint;
var
  R,RSou,RDes,RReal:TRect;
  I,Height,iTop,iBottom,DTop:Integer;
  Node:TMFSchemeDataTreeNode;
begin
  inherited;
  R:=GetClientRect;
  RReal := GetRealRect;
  iTop:=RReal.Top;
  Height:= 0;
  For I:=0 to GetSchemeDataTree.Count -1 do
  begin
    Node:= GetSchemeDataTree.Items[i];
    if Node.IsNotVisibleOrHide then  Continue;
    {if Node.Parent<>nil then
      if Not Node.Parent.Expanded then Continue; }

    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;

    DTop:=0;
    if iTop< R.Top then
    begin
      DTop:=R.Top-iTop;
    end;

    if iBottom< R.Top then Continue;
    if iTop>R.Bottom  then Continue;

    FFastBmp.Width := R.Right-R.Left ;
    FFastBmp.Height:= Node.Height;
    RSou:=Rect(0 ,0,FFastBmp.Width,FFastBmp.Height);

    PaintRow(Node,FFastBmp.Canvas,RSou,RSou);

    RSou:=Rect(0,DTop,FFastBmp.Width,FFastBmp.Height);
    RDes := Rect(0,iTop+DTop, FFastBmp.Width,iBottom);
    //GetParentForm(Scheme).Canvas.CopyRect(Rb,FFastBmp.Canvas,Ra);
    Canvas.CopyRect(RDes,FFastBmp.Canvas,RSou);
  end;
end;

procedure TMFIndicaterPaint.PaintRow(Node: TMFSchemeDataTreeNode; ACanvas:TCanvas;
  R,RealRect: TRect);
var P:TPoint;Ra:TRect;
begin
  Ra:=GetClientRect;
  Ra:=Rect(Ra.Left ,R.Top,Ra.Right,R.Bottom);

  LocalCanvas.DefCanvas:= ACanvas;
  LocalCanvas.Brush.Style:=bsSolid;
  LocalCanvas.Brush.Color :=SchemeView.IndicaterOptions.Color;
  LocalCanvas.DefCanvas.FillRect(Ra);
  LocalCanvas.DrawComplexFrame(R,clBtnHighlight,clBtnShadow);
  LocalCanvas.Brush.Color:=clBlack;
  P:=CenterPoint(Ra);
  //P:=Point(Round((R.Right+R.Left)/2),Round((R.Bottom+R.Top)/2));
  if Node.Selected then
    LocalCanvas.Polygon([Point(P.X-2,P.Y-4),Point(P.X+2,P.Y),Point(P.X-2,P.Y+4)]);
end;

procedure TMFIndicaterPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

{ TMFHeadPaint }

constructor TMFHeadPaint.Create(AControl: TMFBaseSchemeView);
begin
  inherited;

end;

procedure TMFHeadPaint.Paint;
var
  R,RSou:TRect;
  Width:Integer;
begin
  inherited;
  R:=GetClientRect;
  RSou:=R;
  Width:=0;

  if (SchemeView.IndicaterOptions.Visible)  then
  begin
    Width:=SchemeView.IndicaterOptions.Width;
    RSou:=Rect(R.Left,R.Top,R.Left+Width,R.Bottom);
    PaintHeadItem(-2,RSou);
  end;  

  if SchemeView.TreeOptions.Visible then
  begin
    OffsetRect(RSou,Width,0);
    RSou:=Rect(RSou.Left,RSou.Top,RSou.Left+SchemeView.TreeOptions.Width,RSou.Bottom);
    PaintHeadItem(-1,RSou);
  end;
  
end;

procedure TMFHeadPaint.PaintHeadItem(Index:Integer; R: TRect);
begin
  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color :=SchemeView.HeadOptions.Color;
  Canvas.DefCanvas.FillRect(R);
  Canvas.DrawComplexFrame(R,clBtnHighlight,clBtnShadow);
  Canvas.Brush.Style:=bsClear ;
  Canvas.Font.Assign(SchemeView.TreeOptions.Font);
  if Index=-1 then  Canvas.DrawTexT(SchemeView.TreeOptions.Caption,R,gAlignCenter);
end;

procedure TMFHeadPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

{ TMFFootPaint }

constructor TMFFootPaint.Create(AControl: TMFBaseSchemeView);
begin
  inherited;
end;

procedure TMFFootPaint.Paint;
var RClient,R:TRect;AParams: TDrawViewParams;
begin
  inherited;
  Canvas.Font.Assign(SchemeView.FootOptions.Font);
  Canvas.Pen.Assign(SchemeView.FootOptions.Pen);
  
  RClient:=GetClientRect;
  Canvas.DefCanvas.Brush.Color :=SchemeView.FootOptions.Color;
  Canvas.DefCanvas.FillRect(RClient);

  Canvas.DrawLine(RClient);

  with SchemeView.IndicaterOptions do
  begin
    R:= RClient;
    if Visible then
    begin
      R.Left:=R.Left+width;
      RClient.Right:=RClient.Left+width;
      Canvas.DrawLine(RClient);
    end;
    R.Left:=R.Left+3;
    Canvas.DefCanvas.Brush.Style:=bsClear;

    Canvas.DrawTexT(SchemeView.FootOptions.Caption ,R,gAlignVCenter);

  end;

end;

procedure TMFFootPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

{ TMFContentPaint }

constructor TMFContentPaint.Create(AControl: TMFBaseSchemeView);
begin
  inherited;

end;

procedure TMFContentPaint.Paint;
begin
  inherited;

end;

procedure TMFContentPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;


{ TMFHintWindow }

procedure TMFHintWindow.ActivateHint(Rect: TRect; const AHint: string);
begin
  inherited;

end;

procedure TMFHintWindow.ActivateHintData(Rect: TRect; const AHint: string;
  AData: Pointer);
begin
  inherited;

end;

function TMFHintWindow.CalcHintRect(MaxWidth: Integer;
  const AHint: string; AData: Pointer): TRect;
var    //Date = 中间变量   @Set =Data
  R:TRect;
  HintRec:THintRec;
  HintDataRec:^TMFHintDataRec;
  HintDataEvent:THintDataEvent;
begin
  R:=Rect(0,0,100,100);
  HintRec.HintType:=htText;
  HintRec.Font:=Font ;
  HintRec.Color:=Color;
  HintRec.HintStr:=AHint;
  if AData<>nil then
  begin
    HintDataRec:=AData;
    HintDataEvent:= HintDataRec^.HintDataEvent;
    HintDataEvent(Self,HintDataRec^.AViewHitInfo,HintRec,
    R,FBitMap.Canvas);
    HintType:= HintRec.HintType;
  end;

  if HintRec.HintType=htText then
  begin
    FUserColor:=HintRec.Color;
    FText := HintRec.HintStr;
    Result:=(inherited CalcHintRect(MaxWidth,FText,AData));
  end
  else
  begin
    FUserColor:=HintRec.Color;
    FText := HintRec.HintStr;
    Result:=R;
  end;
  Dispose(HintDataRec);
end;

constructor TMFHintWindow.Create(AOwner: TComponent);
begin
  inherited;
  FBitMap:=TBitmap.Create;
  FUserColor:=Color;
  FBitMap.Width:=500;
  FBitMap.Height:=500;  
end;

procedure TMFHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
//  if CheckWinXP then
//    Params.WindowClass.style := Params.WindowClass.style or CS_DROPSHADOW;
end;

destructor TMFHintWindow.Destroy;
begin
  FBitMap.Free;
  inherited;
end;

procedure TMFHintWindow.NCPaint(DC: HDC);
var
  R: TRect;
begin
  R := Rect(0, 0, Width, Height);
  Windows.DrawEdge(DC, R, BDR_RAISEDOUTER, BF_RECT);
end;

procedure TMFHintWindow.Paint;
var
  R:TRect;
begin
  inherited;
  if HintType=htText then
  begin
    with Canvas do
    begin
      Pen.Style :=psClear;
      Brush.Color:=FUserColor ;
      Brush.Style:=bsSolid;
      Rectangle(0,0,Width,Height);
    end;

    R:=ClientRect;
    Inc(R.Top,3);
    Inc(R.Left,2);
    //SetBKMode(Canvas.Handle,TRANSPARENT);
    //Canvas.Font.Color:=clSkyBlue;
    Canvas.Font.Assign(Font);
    DrawText(Canvas.Handle, PChar(FText),-1,R,DT_LEFT);
  end
  else
  begin
    Canvas.Draw(0,0,FBitMap);
  end;
end;

{ TMFDateTimeWindow }

procedure TMFDateTimeWindow.Activate(Rect: TRect);
type
  TAnimationStyle = (atSlideNeg, atSlidePos, atBlend);
const
  AnimationStyle: array[TAnimationStyle] of Integer = (AW_VER_NEGATIVE,
    AW_VER_POSITIVE, AW_BLEND);
var
  Animate: BOOL;
  Style: TAnimationStyle;
begin
  FActivating := True;
  try
    Inc(Rect.Bottom, 4);
    UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_NOACTIVATE);
    if Assigned(AnimateWindowProc) then
    begin
      SystemParametersInfo(SPI_GETTOOLTIPANIMATION, 0, @Animate, 0);
      if Animate then
      begin
        SystemParametersInfo(SPI_GETTOOLTIPFADE, 0, @Animate, 0);
        if Animate then
	  Style := atBlend
        else
          Style := atSlidePos;
        AnimateWindowProc(Handle, 100, AnimationStyle[Style] or AW_SLIDE);
      end;
    end;
    if not IsWindowVisible(Handle) then
     ShowWindow(Handle, SW_SHOWNOACTIVATE);
    Invalidate;
  finally
    FActivating := False;
  end;
end;

function TMFDateTimeWindow.CalcHintRect(MaxWidth: Integer;
  const AHint: string; AData: Pointer): TRect;
begin
  if HintType=htText then
    Result:=Rect(0,0,width,Height)
  else
  begin
    Result := Rect(0, 0, MaxWidth, 0);
    DrawText(Canvas.Handle, PChar(AHint), -1, Result, DT_CALCRECT or DT_LEFT or
      DT_WORDBREAK or DT_NOPREFIX or DrawTextBiDiModeFlagsReadingOnly);
    Inc(Result.Right, 6);
    Inc(Result.Bottom, 2);
  end;
end;

procedure TMFDateTimeWindow.CMTextChanged(var Message: TMessage);
begin

end;

constructor TMFDateTimeWindow.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle:=[csOpaque];
  FBitMap:=TBitmap.Create;
  FBitMap.Width:=500;
  FBitMap.Height:=500;
end;

procedure TMFDateTimeWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS ;

    if CheckWinXP then
      WindowClass.Style := WindowClass.Style or CS_DROPSHADOW;

    if NewStyleControls then ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
  end;
end;

destructor TMFDateTimeWindow.Destroy;
begin
  FBitMap.Free;
  inherited;
end;

function TMFDateTimeWindow.GetHintCanvas: TCanvas;
begin
  Result := FBitMap.Canvas;  
end;

procedure TMFDateTimeWindow.NCPaint(DC: HDC);
var
  R: TRect;
begin
  R := Rect(0, 0, Width, Height);
  Windows.DrawEdge(DC, R, BDR_RAISEDOUTER, BF_RECT);
end;

procedure TMFDateTimeWindow.Paint;
var
  R: TRect;
begin
  if HintType=htText then
  begin
    R := ClientRect;
    Inc(R.Left, 2);
    Inc(R.Top, 2);
    Canvas.Font.Color := Screen.HintFont.Color;
    DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
  end
  else
  begin
    Canvas.Draw(0,0,FBitMap);
  end;
end;

procedure TMFDateTimeWindow.ReleaseHandle;
begin
  DestroyHandle;
end;

procedure TMFDateTimeWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTTRANSPARENT;
end;

procedure TMFDateTimeWindow.WMNCPaint(var Message: TMessage);
var
  DC: HDC;
begin
  DC := GetWindowDC(Handle);
  try
    NCPaint(DC);
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TMFDateTimeWindow.WMPrint(var Message: TMessage);
begin
  PaintTo(Message.WParam, 0, 0);
  NCPaint(Message.WParam);
end;

end.
