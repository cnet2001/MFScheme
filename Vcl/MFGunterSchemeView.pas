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
	-2005-1-18 完成  TGraphScrollBar  类 纯Windows VCL 组件控制滚动条 自
					     动适应XP风格
	-2005-1-20 编写  TPlanCrockCenter 类 排缸界面实现类
	-2005-2-8  完成  TPlanCrockCenter 类
	-2005-2-9  编写  TMFMacList,TMFCard 排缸控制类

	暂不支持 OpenGL 功能 以后扩充
	声明:本工程代码都是自己实现的没有其他任何第三方组件和代码

重构:   -2006-6-10     重构类 以及 类关系

	-2006-7-3  编写  TMFGunterSchemeView
	-2006-7-3  编写  TMFGunterContentOptions
	-2006-7-3  编写  TMFGunterHeadOptions   - 2006-7-10 被再次重构时 Cancle
	-2006-7-4  编写  TGunterCalculater
	-2006-7-5  编写  TMFGunterPaint
	-2006-7-6  编写  TMFGunterHeadPaint
	-2006-7-7  编写  TMFGunterContentPaint
        再次重构
	-2006-7-10 编写  TMFHeadOptions  TMFHeadOptionItem
	为了可以灵活的分层加入自定义分层功能  替换 TMFGunterHeadOptions 的功能
	-2006-7-12 编写  TMFGunterViewControl 鼠标键盘事件控制类
	-2006-7-17 编写  创建线条关系
	-2006-7-20 完善  立体效果和风格
	-2006-7-24 编写  TMFHourforDays TMFHourforDayItem
	-2006-7-26 完善  Hint功能
	-2006-7-27 完善  DragHint功能
        -2008-5-15 增加定位功能  
ToDo:

*******************************************************************************}

unit MFGunterSchemeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,ImgList,StrUtils,
  StdCtrls,Forms,ExtCtrls,Graphics,Dialogs ,CommCtrl,ComCtrls,DateUtils,
  MFBaseScheme,MFScheme,MFPaint,MFBaseSchemePainter,types,OpenGL,
  MFSchemeCNDate,MFBaseSchemeCommon;

type
  TMFGunterPaint=class;
  TGunterCalculater=class;
  TMFGunterContentOptions=Class;
  TMFTimeHeadItem=class;
  TMFViewHeadOptions=class;
  TMFGunterViewControl=class;

  TMFGunterMoveType=(gmNone,gmScorllMove,gmTreeSize,gmItemLeft,
    gmItemRight,gmItemMove,gmSelect,gmContent);

  TMFGunterMoveRec=record
     MoveType: TMFGunterMoveType;
     OPoint,NPoint,DownPoint:TPoint;
     ARect:TRect;
     AItem:TMFSchemeDataItem;
     MouseType:TMouseType;
  end;

  TMFGantterTimeScale = (gMinute,gHour,gDay,gWeek,gMonth,gQuarter,gHalfYear,gYear);
  TMFWeekDay=(wMonday,wTuesday,wWednesday,wThursday,wFriday,wSaturday,wSunday);
  TMFWeekDays = set of TMFWeekDay;

  {TMFGunterSchemeView}

  TMFGunterSchemeView=class(TMFBaseSchemeView,IZcDrawData)
  private
    function GetCalculater: TGunterCalculater;

  protected
    FHeadTimeOptions: TMFViewHeadOptions;
    FContentOptions: TMFGunterContentOptions;
    FGunterViewControl:TMFGunterViewControl;
    FGunterPaint:TMFGunterPaint;
    procedure SetHeadOptions(const Value: TMFViewHeadOptions);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    destructor Destroy; override;
    procedure InIt;override;
    procedure Paint;override;
    procedure DblClick;override;
    function GetWholeHeight:Integer;override;
    function GetWholeWidth:Integer;override;
    {IZcDrawData}
    function GetSchemeDataTree:TMFSchemeDataTree;
    function GetDrawCalculater:TDrawCalculater;
    function GetDrawImageList:TImageList;
    {IZcDrawData}
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    function GetDataTreeClientRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;override;

    property Calculater:TGunterCalculater read GetCalculater;
    property Painter:TMFGunterPaint read FGunterPaint;
    property Control:TMFGunterViewControl read FGunterViewControl;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DragDrop(Source: TObject;X,Y: Integer);override;
    procedure DragCanceled; override;
    procedure DoScrollTimer;override;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);override;
  published
    property TreeOptions ;
    property IndicaterOptions ;
    property HeadTimeOptions:TMFViewHeadOptions read  FHeadTimeOptions write SetHeadOptions ;
    property FootOptions;
    property HeadOptions;
    property ReadOnly;
    property ContentOptions:TMFGunterContentOptions read FContentOptions write FContentOptions;
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
    property OnDragDropNear;
    property OnDragItemOver;
    property OnSetNodeHeight;
    property OnAfterItemTimeChange;
    property OnBeforItemTimeChange;
    property OnSetHintData;
    property OnDragOtherDrop;
    property OnDragOtherOver;
    property OnItemSelectChange;
    property OnDblClickView;
    property OnDragHint;
    property Images;
    property Caption;
  end;

  {TMFGunterPaint}

  TMFGunterPaint=class(TMFAdvSchemePaint)
  private
    FGunterCalculater:TGunterCalculater;
  protected

  public
    constructor Create(AOwner:TMFGunterSchemeView);reintroduce; virtual;
    destructor Destroy; override;
    procedure Paint(APaint:TMFBaseSchemePaint=nil);reintroduce;
    procedure PaintRowList(APaint:TMFBaseSchemePaint=nil);virtual;
    procedure PaintMoveSize(RClient:TRect);
    procedure PaintNeedClear(R:TRect);
  end;

  {TGunterCalculater}

  TGunterCalculater=class(TDrawCalculater)
  private
    function GetSchemeView: TMFGunterSchemeView;
    function GetSubTimeHeadItem: TMFTimeHeadItem;
  protected

  public
    constructor Create(AOwner:TMFGunterSchemeView);reintroduce;virtual;
    function GetStartTime:TDateTime;
    function GetEndTime:TDateTime;
    function GetNeedClearRect: TRect;
    function GetPaintClass(APaintClass: TMFBaseSchemePaintClass): TMFAdvSchemePaint;
    function GetWholeHeight:Integer;override;
    function GetWholeWidth:Integer;override;

    function GetNodeTextRect(ANode:TMFSchemeDataTreeNode;
      var Need:Boolean):TRect;

    function GetHitInfo(APoint:TPoint):TViewHitInfo;override;
    function GetNodeInfo(APoint:TPoint;APaintClass:TMFAdvSchemePaint):TViewHitInfo;
    function GetVisible(APaint:TMFBaseSchemePaint):Boolean;override;
    function GetRealRect(APaint:TMFBaseSchemePaint):TRect;override;
    function GetClientRect(APaint:TMFBaseSchemePaint):TRect;override;
    function GetRelativeRect(APaint:TMFBaseSchemePaint):TRect;override;
    function GetOffSetPoint(APaint:TMFBaseSchemePaint):TPoint;override;
    property SchemeView:TMFGunterSchemeView read GetSchemeView;

    function GetNodeItemRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;
    function GetIntervalCount(tStart,tEnd:TDateTime;ATimeScale:TMFGantterTimeScale):Double;
    function GetSubIntervalCount:Double;virtual;
    function GetIntervalWith:Integer;virtual;

    function GetClientLeftToDateTime(AValue:Integer):TDateTime;virtual;
    function GetDateTimeToClientLeft(AValue:TDateTime):Integer;virtual;

    function GetRelativeLeftToDateTime(AValue:Integer):TDateTime;virtual;
    function GetDateTimeToRelativeLeft(AValue:TDateTime):Integer;virtual;

    function GetLastDateTime(AValue: TDateTime;ATimeScale: TMFGantterTimeScale): TDateTime;
    function GetFirstDateTime(AValue:TDateTime;ATimeScale:TMFGantterTimeScale):TDateTime;
    function GetIncDateTime(AValue:TDateTime;ATimeScale:TMFGantterTimeScale;iStep:Integer):TDateTime;

    function GetUnitDateTime(AValue:TDateTime;ATimeScale:TMFGantterTimeScale):TDateTime;
    function GetSubUnitDateTime:TDateTime;virtual;
    function GetTimeHeadItemRect(ATimeHeadItem:TMFTimeHeadItem):TRect;virtual;
    function GetTimeHeadItemLeft(ATimeHeadItem:TMFTimeHeadItem): Integer;
    function GetTimeHeadItemUnitRect(APoint:TPoint;ATimeHeadItem:TMFTimeHeadItem):TRect;
    property SubTimeHeadItem:TMFTimeHeadItem read GetSubTimeHeadItem;
  end;

  {TMFTimeHeads}

  TMFTimeHeads=class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TMFTimeHeadItem;
    procedure SetItem(Index: Integer; const Value: TMFTimeHeadItem);
  public
    function Add: TMFTimeHeadItem;
    procedure Update(Item: TCollectionItem);override;
    property Items[Index: Integer]: TMFTimeHeadItem read GetItem write SetItem; default;
  end;

  {TMFTimeHeadItem}

  TMFTimeHeadItem=class(TCollectionItem)
  private
    FVisible: Boolean;
    FInterval: Integer;
    FTimeScale: TMFGantterTimeScale;
    FFont: TFont;
    FContentVLinePen: TPen;
    FPen: TPen;
    FHeight: Integer;
    FColor: TColor;

    procedure SetInterval(const Value: Integer);
    procedure SetTimeScale(const Value: TMFGantterTimeScale);
    procedure SetContentVLinePen(const Value: TPen);
    procedure SetFont(const Value: TFont);
    procedure SetPen(const Value: TPen);
    procedure SetVisible(const Value: Boolean);
    procedure SetHeight(const Value: Integer);
    procedure SetColor(const Value: TColor);

  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy; override;
    procedure Change(Sender:TObject);virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property TimeScale: TMFGantterTimeScale read FTimeScale write SetTimeScale;
    property Interval:Integer read FInterval write SetInterval;
    property ContentVLinePen:TPen read FContentVLinePen write SetContentVLinePen;
    property Pen:TPen read FPen write SetPen;
    property Font:TFont read FFont write SetFont;
    property Visible:Boolean read FVisible write SetVisible;
    property Height:Integer read FHeight write SetHeight;
    property Color:TColor read FColor write SetColor;
  end;

  {TMFViewHeadOptions}

  TMFViewHeadOptions=Class(TMFBaseOptions)
  private
    FHeadItems: TMFTimeHeads;
    FIntervalWidth: Integer;
    FSpreadType: TSpreadType;
    FScaleFormat: TStrings;
    FNowTimeLinePen: TPen;
    FHintScaleFormat: TStrings;
    procedure SetHeadItems(const Value: TMFTimeHeads);
    procedure SetIntervalWidth(const Value: Integer);
    procedure SetSpreadType(const Value: TSpreadType);
    procedure SetScaleFormat(const Value: TStrings);
    procedure SetNowTimeLinePen(const Value: TPen);
    procedure SetHintScaleFormat(const Value: TStrings);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    destructor Destroy; override;
    procedure SetChange(Sender:TObject);
    procedure Assign(Source: TPersistent); override;
    function GetUnitHeadItem:TMFTimeHeadItem;
  published
    property SpreadType:TSpreadType read FSpreadType write SetSpreadType;
    property IntervalWidth:Integer read FIntervalWidth write SetIntervalWidth;
    property HeadItems:TMFTimeHeads read FHeadItems write SetHeadItems;
    property ScaleFormat:TStrings read FScaleFormat  write SetScaleFormat;
    property HintScaleFormat:TStrings read FHintScaleFormat  write SetHintScaleFormat;
    property NowTimeLinePen:TPen read FNowTimeLinePen write SetNowTimeLinePen;
  end;

  {TMFGunterHeadOptions}
  //- 2006-7-10 再次重构时被 Cancle
  TMFGunterHeadOptions=Class(TMFBaseOptions)
  private
    FInterval: Integer;
    FDateTimeFormat: string;
    FTimeScale: TMFGantterTimeScale;
    FFont: TFont;
    FContentVLinePen: TPen;
    FOwner:TPersistent;
    FNowTimeLinePen: TPen;
    procedure SetDateTimeFormat(const Value: string);
    procedure SetInterval(const Value: Integer);
    procedure SetTimeScale(const Value: TMFGantterTimeScale);
    procedure SetNowTimeLinePen(const Value: TPen);
  public
    constructor Create(AView:TMFBaseSchemeView;AOwner:TPersistent);reintroduce;virtual;
    destructor Destroy;override;
    function GetOwner:TPersistent; override;
    procedure Assign(Source: TPersistent); override;
    procedure Change;override;
  published
    property TimeScale: TMFGantterTimeScale read FTimeScale write SetTimeScale;
    property Interval:Integer read FInterval write SetInterval;
    property DateTimeFormat:string read FDateTimeFormat write SetDateTimeFormat;
    property Pen;
    property Font;
    property NowTimeLinePen:TPen read FNowTimeLinePen write SetNowTimeLinePen;
  end;

  TMFHourforDayItem=class;
  {TMFHourforDay}

  TMFHourforDays=class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TMFHourforDayItem;
    procedure SetItem(Index: Integer; const Value: TMFHourforDayItem);
    function GetView: TMFGunterSchemeView;
  public
    function Add: TMFHourforDayItem;
    property View:TMFGunterSchemeView read GetView;
    property Items[Index: Integer]: TMFHourforDayItem read GetItem write SetItem; default;
  end;

  {TMFHourforDayItem}

  TMFHourforDayItem=class(TCollectionItem)
  private
    FVisible: Boolean;
    FWorkTimeBegin: String;
    FWorkTimeEnd: String;
    FColor: TColor;
    procedure SetVisible(const Value: Boolean);
    procedure SetWorkTimeBegin(const Value: String);
    procedure SetWorkTimeEnd(const Value: String);
    procedure SetColor(const Value: TColor);

  protected
    function CheckInputTime(Value:String):Boolean;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy; override;
    procedure Change;virtual;
    procedure Assign(Source: TPersistent); override;
    function GetStartHour:Integer;
    function GetStartMinute:Integer;
    function GetALLStartMinute:Integer;
    function GetEndMinute:Integer;
    function GetALLEndMinute:Integer;
    function GetEndHour:Integer;
    function GetHour(AValue:String):Integer;
    function GetMinute(AValue:String):Integer;
  published
    property WorkTimeBegin:String read FWorkTimeBegin write SetWorkTimeBegin;
    property WorkTimeEnd:String read FWorkTimeEnd write SetWorkTimeEnd;
    property Visible :Boolean read FVisible write SetVisible;
    property Color:TColor read FColor write SetColor;

  end;

  {TMFGunterContentOptions}
  
  TMFGunterContentOptions=Class(TMFContentOptions)
  private
    FGantterEndTime: TDateTime;
    FGantterStartTime: TDateTime;
    FRestDateColor: TColor;
    FWorkHourforDays: TMFHourforDays;
    FWorkDayforWeek: TMFWeekDays;
    FShowRestDateColor: Boolean;
    FAutoFetchSpace: Integer;
    FShowDragHint: Boolean;
    FShowPercent: Boolean;
    FPercentPosition: TPercentPosition;
    FPercentWidth: Integer;
    FPercentColorType: TPercentColorType;
    FPercentColor: TColor;
    FItemShadow: Boolean;
    FTItemFontColorType: TItemFontColorType;
    procedure SetWorkDayforWeek(const Value: TMFWeekDays);
    procedure SetWorkHourforDays(const Value: TMFHourforDays);
    procedure SetRestDateColor(const Value: TColor);
    procedure SetShowRestDateColor(const Value: Boolean);
    procedure SetShowPercent(const Value: Boolean);
    procedure SetPercentPosition(const Value: TPercentPosition);
    procedure SetPercentWidth(const Value: Integer);
    procedure SetFPercentColorType(const Value: TPercentColorType);
    procedure SetPercentColor(const Value: TColor);
    procedure SetItemShadow(const Value: Boolean);
    procedure SetTItemFontColorType(const Value: TItemFontColorType);
  protected
    procedure SetGantterEndTime(const Value: TDateTime);
    procedure SetGantterStartTime(const Value: TDateTime);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
    destructor Destroy;override;
  published
    property GantterStartTime: TDateTime read FGantterStartTime write SetGantterStartTime;
    property GantterEndTime: TDateTime read FGantterEndTime write SetGantterEndTime;
    property ShowRestDateColor:Boolean read FShowRestDateColor write SetShowRestDateColor;

    property RestDateColor:TColor read FRestDateColor write SetRestDateColor;

    property WorkDayforWeek:TMFWeekDays read FWorkdayforWeek write SetWorkdayforWeek;
    property WorkHourforDays:TMFHourforDays read FWorkHourforDays write SetWorkHourforDays;
    property AutoFetchSpace:Integer read FAutoFetchSpace write FAutoFetchSpace;
    property ShowDragHint:Boolean read FShowDragHint write FShowDragHint;
    property ShowPercent:Boolean read FShowPercent  write SetShowPercent;
    property PercentPosition:TPercentPosition read FPercentPosition  write SetPercentPosition;
    property PercentWidth:Integer read FPercentWidth  write SetPercentWidth;
    property PercentColorType:TPercentColorType read FPercentColorType write SetFPercentColorType;
    property PercentColor:TColor  read  FPercentColor write SetPercentColor;
    property Pen;
    property Font;
    property Color;
    property MultiSelect;
    property ItemFontColorType:TItemFontColorType  read FTItemFontColorType write SetTItemFontColorType;
    property ItemShadow:Boolean  read FItemShadow write SetItemShadow;
  end;

  THeadDrawType=(hHead,hLine);
  
  {TMFGunterHeadPaint}

  TMFGunterHeadPaint=class(TMFHeadPaint)
  private

  protected

  public
    function GetDrawCalculater:TGunterCalculater;reintroduce;
    procedure Paint; override;
    function  FormatGunterDate(Format:String;AStart,AEnd:TDateTime): String;virtual;
    function  GetFormatText(AScale:TMFGantterTimeScale):String;virtual;

    procedure PrepareContent(ACanvas:TCanvas;R: TRect);

    procedure PaintTimeHeadItem(ACanvas:TCanvas;AHeadItem:TMFTimeHeadItem;
      RLine:TRect;AHeadDrawType:THeadDrawType=hHead);virtual;

    procedure PaintNowTimeLine(ACanvas: TCanvas;R: TRect);

    procedure PaintContentLine(AHeadItem:TMFTimeHeadItem;AStart,AEnd:TDateTime;
      ACanvas: TCanvas;R: TRect);virtual;

    procedure PaintItemContent(AHeadItem:TMFTimeHeadItem;AStart,AEnd:TDateTime;
      ACanvas: TCanvas;R: TRect);virtual;
      
    procedure ZcInvalidate(const R: TRect);  override;
  end;

  {TMFGunterContentPaint}
  
  TMFGunterContentPaint=class(TMFContentPaint)
  private
     

  protected
    function PaintGunterStyle(Item: TMFSchemeDataItem; ACanvas: TCanvas;
      R: TRect):TRect;
    function PaintGunterPercent(Item: TMFSchemeDataItem; ACanvas: TCanvas;
      R: TRect):TRect;
  public
    function GetDrawCalculater:TGunterCalculater;reintroduce;
    procedure Paint; override;
    procedure PaintContent(Node: TMFSchemeDataTreeNode;ACanvas: TCanvas; R: TRect);
    procedure PaintItemContent(ADataItem:TMFSchemeDataItem;ACanvas: TCanvas;
      R: TRect);

    function GetItemSharp(ADataItem:TMFSchemeDataItem;R: TRect):TRangePath;

    procedure PaintNowTimeLine(ACanvas: TCanvas;R: TRect);
    procedure PaintRow(Node: TMFSchemeDataTreeNode; ACanvas: TCanvas;
      R,RealRect: TRect);override;
    procedure PaintLinkLine(Node:TMFSchemeDataTreeNode; ACanvas: TCanvas;
      R,RealRect: TRect);
    procedure ZcInvalidate(const R: TRect);  override;
  end;

  {TMFViewHeadOptions}

  TMFItemDataOptions=Class(TMFBaseOptions)
  private
    FItemHeight: Integer;
    FTextureType: Integer;
    FCustomBrush: String;
    FBrush: TBrush;
    FBrushType: TMFBrushType;
    FPicture: TPicture;
    FSpreadType: TSpreadType;
    procedure SetBrush(const Value: TBrush);
    procedure SetBrushType(const Value: TMFBrushType);
    procedure SetItemHeight(const Value: Integer);
    procedure SetPicture(const Value: TPicture);
    procedure SetSpreadType(const Value: TSpreadType);

  public
    constructor Create(AView:TMFBaseSchemeView);override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property SpreadType:TSpreadType read FSpreadType write SetSpreadType;
    property ItemHeight:Integer read FItemHeight write SetItemHeight;
    property Pen;
    property Font;
    property Brush:TBrush read FBrush write SetBrush;
    property BrushType:TMFBrushType read FBrushType write SetBrushType;
    property CustomBrush:String read FCustomBrush  write FCustomBrush;
    property TextureType:Integer read FTextureType write FTextureType;
    property Picture :TPicture read FPicture write SetPicture;
  end;

  {TMFGunterViewControl}

  TMFGunterViewControl=Class(TMFBaseViewControl)
  private
    procedure ScorllMessage(hwnd: HWND; Msg: Cardinal; wParam,
      lParam: Integer);

  protected
    MoveRec:TMFGunterMoveRec;
    FTimerID:Integer;
    FFirstSelect:Boolean;
    DateTimeWindow:TMFDateTimeWindow;
    function GetSchemeView: TMFGunterSchemeView;
  public
    constructor Create(AView:TMFGunterSchemeView);reintroduce;virtual;
    procedure StartScrollTimer;
    procedure DoScrollTimer;
    procedure EndScrollTimer;
    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);
    procedure DragCanceled; override;
    procedure DragItemOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);override;
    procedure DragItemDrop(Source: TObject;X,Y: Integer);override;

    procedure DragOtherOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);override;
    procedure DragOtherDrop(Source: TObject;X,Y: Integer);override;

    procedure BeginDrag(Immediate: Boolean; Threshold: Integer = -1);override;
    function Dragging: Boolean; override;
    procedure EndDrag(Drop: Boolean); override;

    function GetDragHintCaption(ADateTime:TDateTime):String;
    function GetDragHintRect(R:TRect):TRect;

    procedure KeyPress(var Key: Char); override;
    function Calc(R: TRect; APoint: TPoint): TRect;
    procedure DragDropNear(NewNode: TMFSchemeDataTreeNode;DragItem: TMFSchemeDataItem;
      var R: TRect);virtual;

    procedure AdjustScrollBar(ScrollBarKind: TScrollBarKind);
    procedure ScrolltoDateTime(ADateTime:TDateTime;Percent:Integer=30);
    procedure ScrolltoNode(Node:TMFSchemeDataTreeNode;Percent:Integer=30);
    procedure ScrolltoItem(AItem:TMFSchemeDataItem);
    procedure NeedScroll(Node: TMFSchemeDataTreeNode);
    procedure VScrollPage(Direction:Boolean);
    procedure HScrollPage(Direction:Boolean);
    function CanNodeKeyDown:Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DblClick;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
    procedure AdjustDragDrop(AViewHitInfo:TViewHitInfo);
    procedure SetCursor(var Message:TWMSetCursor);
    procedure HintShow(var Message: TCMHintShow);
    function CheckItemCanChange(AViewHitInfo:TViewHitInfo):Boolean;
    function GetHintStr(AViewHitInfo: TViewHitInfo): String;
    procedure SetHintData(Sender:TObject;AViewHitInfo:TViewHitInfo;
      var HintRec:THintRec;var R:TRect; ACanvas: TCanvas);
    procedure MultiSelect(ResetOldSelected : Boolean; SelectRect : TRect);
    Property SchemeView:TMFGunterSchemeView read GetSchemeView;
  end;


const
  StringTimeScale:array [TMFGantterTimeScale] of string =
	('Minute','Hour','Day','Week','Month','Quarter','HalfYear','Year');
  StringScaleFormat:String= 'Minute=[S:nn]'#13+
			    'Hour=[S:hh]'#13+
			    'Day=[S:dd]'#13+
			    'Week=[S:dd]-[E:dd]'#13+
			    'Month=[S:yyyy-mm]'#13+
			    'Quarter=[S:yyyy-mm] ~ [E:yyyy-mm]'#13+
			    'HalfYear=[S:yyyy-mm] ~ [E:yyyy-mm]'#13+
			    'Year=[S:yyyy]'#13;
  StringHintScaleFormat:String= 'Minute=[S:nn]'#13+
			    'Hour=[S:hh]'#13+
			    'Day=[S:dd]'#13+
			    'Week=[S:dd]-[E:dd]'#13+
			    'Month=[S:yyyy-mm]'#13+
			    'Quarter=[S:yyyy-mm] ~ [E:yyyy-mm]'#13+
			    'HalfYear=[S:yyyy-mm] ~ [E:yyyy-mm]'#13+
			    'Year=[S:yyyy]'#13;

implementation

procedure TMFGunterSchemeView.CMHintShow(var Message: TCMHintShow);
var R:TRect;
begin
  inherited;
  FGunterViewControl.HintShow(Message);   
end;

procedure TMFGunterSchemeView.DblClick;
begin
  inherited;
  FGunterViewControl.DblClick;
end;

destructor TMFGunterSchemeView.Destroy;
begin
  FGunterPaint.Free;
  FContentOptions.free;
  FHeadTimeOptions.Free;
  FGunterViewControl.Free;
  //ShowMessage('Destroy');
  inherited;
end;

procedure TMFGunterSchemeView.DoScrollTimer;
begin
  inherited;
  FGunterViewControl.DoScrollTimer;
end;

procedure TMFGunterSchemeView.DragCanceled;
begin
  inherited;
  FGunterViewControl.DragCanceled;
end;

procedure TMFGunterSchemeView.DragDrop(Source: TObject; X, Y: Integer);
begin
  inherited;
  if Source = Self.Parent then
    FGunterViewControl.DragItemDrop(Source,X, Y)
  else
    FGunterViewControl.DragOtherDrop(Source,X, Y);
end;

procedure TMFGunterSchemeView.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  //if Source = nil then
  if Source = Self.Parent then
    FGunterViewControl.DragItemOver(Source,X, Y,State,Accept)
  else
    FGunterViewControl.DragOtherOver(Source,X, Y,State,Accept);
end;

function TMFGunterSchemeView.GetCalculater: TGunterCalculater;
begin
  Result :=FGunterPaint.FGunterCalculater;
end;

function TMFGunterSchemeView.GetDataTreeClientRect(AItem: TMFSchemeDataItem;
  ANode: TMFSchemeDataTreeNode): TRect;
begin
   Result:=FGunterPaint.FGunterCalculater.GetNodeItemRect(AItem,ANode);
end;

function TMFGunterSchemeView.GetDrawCalculater: TDrawCalculater;
begin
  Result:=Calculater;
end;

function TMFGunterSchemeView.GetDrawImageList: TImageList;
begin
  Result:=Images;
end;

function TMFGunterSchemeView.GetSchemeDataTree: TMFSchemeDataTree;
begin
  Result:=TMFCustomScheme(Parent).SchemeDataTree;
end;

function TMFGunterSchemeView.GetWholeHeight: Integer;
begin
  Result:= FGunterPaint.FGunterCalculater.GetWholeHeight;
end;

function TMFGunterSchemeView.GetWholeWidth: Integer;
begin
  Result:= FGunterPaint.FGunterCalculater.GetWholeWidth;
end;

procedure TMFGunterSchemeView.InIt;
begin
  inherited;
  HeadOptions.Height:=50;
  FGunterPaint:=TMFGunterPaint.Create(Self);
  FContentOptions:= TMFGunterContentOptions.Create(Self);
  FHeadTimeOptions:= TMFViewHeadOptions.Create(self);
  FGunterViewControl:=TMFGunterViewControl.Create(Self);
  FContentOptions.RestDateColor:= $00FAFAFA;
  FContentOptions.WorkDayforWeek:=[wMonday,wTuesday,wWednesday,wThursday,wFriday];
  Caption := '甘特图式';
end;    

procedure TMFGunterSchemeView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  FGunterViewControl.KeyDown(Key,Shift);
end;


procedure TMFGunterSchemeView.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TMFGunterSchemeView.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FGunterViewControl.MouseDown(Button,Shift,X, Y);
end;

procedure TMFGunterSchemeView.MouseMove(Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FGunterViewControl.MouseMove(Shift,X,Y);
end;

procedure TMFGunterSchemeView.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FGunterViewControl.MouseUp(Button,Shift,X,Y);
end;

procedure TMFGunterSchemeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

procedure TMFGunterSchemeView.Paint;
begin
  inherited;
  FGunterPaint.Paint;
end;

procedure TMFGunterSchemeView.SetHeadOptions(
  const Value: TMFViewHeadOptions);
begin
  FHeadTimeOptions.Assign(Value);
end;

{ TMFGunterPaint }

constructor TMFGunterPaint.Create(AOwner: TMFGunterSchemeView);
begin
  inherited Create(AOwner);
  FGunterCalculater:=TGunterCalculater.Create(AOwner);
  FGunterCalculater.AddPainter(TMFGunterHeadPaint);
  FGunterCalculater.AddPainter(TMFFootPaint);
  FGunterCalculater.AddPainter(TMFSchemeTreePaint,tPaintRow);
  FGunterCalculater.AddPainter(TMFIndicaterPaint,tPaintRow);
  FGunterCalculater.AddPainter(TMFGunterContentPaint,tPaintRow);
end;

destructor TMFGunterPaint.Destroy;
begin
  FGunterCalculater.Free;
  inherited;
end;

procedure TMFGunterPaint.Paint(APaint:TMFBaseSchemePaint);
var I:Integer; R:TRect;
begin
  if  APaint<>nil then
  begin
    i:=FGunterCalculater.FPaintList.IndexOf(APaint);
    if I>-1 then
    if FGunterCalculater.ItemPainter[i].PaintType=tPaint then
      FGunterCalculater.ItemPainter[i].Paint
    else
      PaintRowList(FGunterCalculater.ItemPainter[i]);
  end
  else begin
    with TMFGunterSchemeView(SchemeView) do
    Begin
      for i:=0 to FGunterCalculater.ItemCount-1 do
	if  FGunterCalculater.ItemPainter[i].Visible then
	begin
	  if FGunterCalculater.ItemPainter[i].PaintType=tPaint then
	    FGunterCalculater.ItemPainter[i].Paint
	  else
	    PaintRowList(FGunterCalculater.ItemPainter[i]);
	end;

      R :=FGunterCalculater.GetNeedClearRect;
      if not IsRectEmpty(R) then
	PaintNeedClear(R);
    end;  
  end;
end;

procedure TMFGunterPaint.PaintMoveSize(RClient: TRect);
begin
  {Canvas.Pen.Style:=psDot;
  Canvas.Pen.Mode:=pmNot;
  Canvas.Pen.Color:=clBlack;
  Canvas.Pen.Width:=1;
  Canvas.Brush.Style:=bsClear;
  Canvas.DefCanvas.Rectangle(RClient);}
  Canvas.DrawFocusRect(RClient);
end;


procedure TMFGunterPaint.PaintNeedClear(R: TRect);
begin
  with Scheme.Canvas do
  begin
    Brush.Color := Scheme.color;
    Brush.Style := bsSolid;
    FillRect(R);
  end;
end;

procedure TMFGunterPaint.PaintRowList(APaint:TMFBaseSchemePaint);
var
  RClient,RSou,RDes,RReal,RNew:TRect;
  I,J,Height,NewWidth,NewLeft,iTop,iBottom,DTop,DBottom,iOffLeft:Integer;
  Node:TMFSchemeDataTreeNode;


begin
  inherited;
  RClient:=GetClientRect;
  RReal := GetRealRect;

  iOffLeft:=GetOffSetPoint.X;
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
      if not Node.Parent.Expanded then  Continue; }
      
    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;

    NewWidth:=0;
    NewLeft:=0;
    DTop:=0;
    DBottom:=0;

    if iTop< RClient.Top then  DTop:=RClient.Top-iTop;
      
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
      j:=FGunterCalculater.FPaintList.IndexOf(APaint);
      if j>-1 then
      with FGunterCalculater do
      if ItemPainter[j].Visible  then
      if  ItemPainter[j].PaintType=tPaintRow then
      begin
	RNew:=ItemPainter[j].GetClientRect;
	NewWidth:=RNew.Right;
	NewLeft:=RNew.Left;
	
	RDes := Rect(iOffLeft+RClient.Left,iTop,
	iOffLeft+RClient.Left+NewWidth ,iTop+Node.Height);

	RNew:=Rect(RNew.Left,RSou.Top,RNew.Right,RSou.Bottom);
	ItemPainter[j].PaintRow(Node,FFastBmp.Canvas,RNew,RDes);
      end
    end
    else
    for j:=0 to FGunterCalculater.ItemCount-1 do
    with FGunterCalculater do
    if ItemPainter[j].Visible  then
    if ItemPainter[j].PaintType=tPaintRow then
    begin
      RNew:=ItemPainter[j].GetClientRect;
      if NewWidth<RNew.Right then  NewWidth:=RNew.Right;
      if NewLeft>RNew.Left then NewLeft:=RNew.Left;

	RDes := Rect(iOffLeft+RClient.Left,iTop,
	iOffLeft+RClient.Left+NewWidth ,iTop+Node.Height);

      RNew:=Rect(RNew.Left,RSou.Top,RNew.Right,RSou.Bottom);
      ItemPainter[j].PaintRow(Node,FFastBmp.Canvas,RNew,RDes);
    end;

    RSou :=Rect(NewLeft,DTop,NewWidth,FFastBmp.Height-DBottom);
    RDes := Rect(RClient.Left+NewLeft,iTop+DTop,RClient.Left+NewWidth ,iBottom-DBottom);
    Canvas.CopyRect(RDes,FFastBmp.Canvas,RSou);

  end;


end;
{TGunterCalculater}

constructor TGunterCalculater.Create(AOwner: TMFGunterSchemeView);
begin
  inherited Create(AOwner);
end;

function TGunterCalculater.GetClientRect(APaint: TMFBaseSchemePaint): TRect;
var
  TreeLeft,TreeTop,TreeBottom,ContentLeft,HeadWidth:Integer;
  RClient:TRect;
begin
  with  SchemeView do
  begin
    RClient:= GetClientRect;
    if APaint.InheritsFrom(TMFGunterPaint) then
      Result:=SchemeView.GetClientRect;

    if IndicaterOptions.Visible then
      TreeLeft:=IndicaterOptions.Width
    else
      TreeLeft:=0;

    if HeadOptions.Visible then
      TreeTop:=HeadOptions.Height
    else
      TreeTop:=0;

    HeadWidth := RClient.Right;

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

    //bely zhou
    if Result.Right < Result.Left then
       Result.Right := Result.Left;
    if Result.Bottom < Result.Top then
       Result.Bottom := Result.Top; 
  end;
end;

function TGunterCalculater.GetHitInfo(APoint: TPoint): TViewHitInfo;
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
  Result.ASubClass:=nil;
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

function TGunterCalculater.GetNodeInfo(APoint: TPoint;
  APaintClass: TMFAdvSchemePaint): TViewHitInfo;
var
  R,RReal:TRect;
  P:TPoint;
  I,J,Height,iTop,iBottom,iStart,iEnd,iHeadTop,
  iBHeadTop,iHeadHeight:Integer;
  Node:TMFSchemeDataTreeNode;
begin
  inherited;
  Result.APoint:=APoint;
  Result.APaintClass:=APaintClass;
  Result.ASubClass:=nil;
  Result.ANode:=nil;
  Result.AItem:=nil;
  Result.AhitType:=pNone;
  R:=SchemeView.GetClientRect;
  RReal := SchemeView.GetRealRect;

  if SchemeView.HeadOptions.Visible then
  begin
    R:=Rect(R.Left,R.Top+SchemeView.HeadOptions.Height,R.Right,R.Bottom );
    RReal:=Rect(RReal.Left,RReal.Top+SchemeView.HeadOptions.Height,RReal.Right,RReal.Bottom );
  end;

  iTop:=RReal.Top;
  Height:=0;

  if APaintClass.InheritsFrom(TMFHeadPaint) then
  begin
    if Abs(APoint.X - GetPaintClass(TMFSchemeTreePaint).GetClientRect.Right)<3 then
      Result.AHitType:=pTreeRight;

    if APoint.X>GetPaintClass(TMFSchemeTreePaint).GetClientRect.Right then
    with SchemeView,FGunterPaint.FGunterCalculater,HeadTimeOptions,HeadItems do
    for  I:=0 to Count-1 do
    begin
      if PtInRect(GetTimeHeadItemRect(HeadItems[I]),Apoint) then
      begin
	Result.ASubClass:=HeadItems[I];
	Break;
      end;
    end;

  end;

  if APaintClass.InheritsFrom(TMFFootPaint) then
  begin


  end;

  if APaintClass.InheritsFrom(TMFContentPaint) or
    APaintClass.InheritsFrom(TMFSchemeTreePaint) or
    APaintClass.InheritsFrom(TMFIndicaterPaint) then
  For I:=0 to GetSchemeDataTree.Count -1 do
  begin
    Node:=TMFSchemeDataTreeNode(GetSchemeDataTree.Items[I]);
    if  Node.IsNotVisibleOrHide then  Continue;
    {if Node.Parent<>nil then
      if not Node.Parent.Expanded then  Continue;}

    iTop:=iTop+Height;
    Height:=Node.Height;
    iBottom:=iTop+Height;

    if (APoint.Y>= iTop) And (APoint.Y<iBottom) then
    begin
      Result.ANode:=Node;

      if APaintClass.InheritsFrom(TMFContentPaint) then
      begin
	Result.AHitType:=pContent;
	if GetSchemeDataTree.MaxNodeItemCount<1 then Break;
	RReal := APaintClass.GetRealRect;

	for J:=0 to Node.DataItemCount-1 do
	begin
	  iStart :=GetDateTimeToClientLeft(Node.DataItems[j].BeginDate);
	  iEnd :=GetDateTimeToClientLeft(Node.DataItems[j].BeginDate+Node.DataItems[j].IntervalDate);
	  //dMouse:= GetClientLeftToDateTime(APoint.X); //GetRelativeLeftToDateTime(APoint.X-RReal.Left);
	  if (APoint.X>= iStart) And (APoint.X <= iEnd) then
	  begin
	    Result.AItem:=Node.DataItems[j];
	    Result.AHitType:=pItem;
	    if APoint.X-iStart<=2 then
	      Result.AHitType:= pItemLeft;
	    if iEnd-APoint.X<=2 then
	      Result.AHitType:= pItemRight;
	  end;
	end;//end for
	  
      end; //end if

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

function TGunterCalculater.GetOffSetPoint(
  APaint: TMFBaseSchemePaint): TPoint;
begin
  Result :=Point(TMFCustomScheme(Scheme).RealLeft,TMFCustomScheme(Scheme).RealTop);
end;

function TGunterCalculater.GetRealRect(APaint: TMFBaseSchemePaint): TRect;
begin
  Result := GetClientRect(APaint);
  OffsetRect(Result,-GetOffSetPoint(APaint).X,-GetOffSetPoint(APaint).Y);
end;

function TGunterCalculater.GetPaintClass(
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

function TGunterCalculater.GetSchemeView: TMFGunterSchemeView;
begin
  Result:=TMFGunterSchemeView(FControl);
end;

function TGunterCalculater.GetVisible(APaint: TMFBaseSchemePaint): Boolean;
begin
  Result := False;
  with TMFGunterSchemeView(GetSchemeView) do
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

function TGunterCalculater.GetWholeHeight: Integer;
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

function TGunterCalculater.GetWholeWidth: Integer;
var iWidth:Integer;
begin
  Result:=inherited GetWholeWidth;
  if GetSchemeDataTree<>nil then
  if GetSchemeDataTree<>nil then
  with TMFGunterSchemeView(GetSchemeView) do
  begin
    iWidth:=0;
    if IndicaterOptions.Visible  then iWidth :=IndicaterOptions.Width;
    if TreeOptions.Visible  then  iWidth:=iWidth+ TreeOptions.Width;

    Result:=iWidth+Trunc( GetSubIntervalCount*GetIntervalWith);

  end;
end;

function TGunterCalculater.GetIntervalCount(tStart, tEnd: TDateTime;
  ATimeScale: TMFGantterTimeScale): Double;
begin
  Result:=0;
  case ATimeScale of
    gMinute  :Result := MinuteSpan(tStart,tEnd);
    gHour    :Result := HourSpan(tStart,tEnd);
    gDay     :Result := DaySpan(tStart,tEnd);
    gWeek    :Result := WeekSpan(tStart,tEnd);
    gMonth   :Result := MonthSpan(tStart,tEnd);
    gQuarter :Result := MonthSpan(tStart,tEnd)/3;
    gHalfYear:Result := YearSpan(tStart,tEnd)/6;
    gYear    :Result := YearSpan(tStart,tEnd);
  end;
end;

function TGunterCalculater.GetSubIntervalCount:Double;
begin
  if SubTimeHeadItem<>nil then
    Result:=GetIntervalCount(GetStartTime,GetEndTime,SubTimeHeadItem.TimeScale)/SubTimeHeadItem.Interval
  else
    Result :=0 ;
end;

function TGunterCalculater.GetTimeHeadItemLeft(ATimeHeadItem:TMFTimeHeadItem): Integer;
var fDiff:Double;
begin

  fDiff:=GetFirstDateTime(GetStartTime,ATimeHeadItem.TimeScale)-GetStartTime;
  if fDiff<>0 then
    Result:=Trunc(fDiff/GetUnitDateTime(GetStartTime,SubTimeHeadItem.TimeScale)* GetIntervalWith)
  else
    Result:=0;

end;

function TGunterCalculater.GetFirstDateTime(AValue:TDateTime;ATimeScale:TMFGantterTimeScale): TDateTime;
begin
  Result:=0;
  case ATimeScale of
    gMinute  :Result :=RecodeSecond(RecodeMilliSecond(AValue,0),0);
    gHour    :Result :=RecodeMinute(RecodeSecond(RecodeMilliSecond(AValue,0),0),0);
    gDay     :Result := StartOfTheDay(AValue) ;
    gWeek    :Result := StartOfTheWeek(AValue) ;
    gMonth   :Result := StartOfTheMonth(AValue);
    gQuarter :if MonthOfTheYear(AValue)<=3 then
		 Result := StartOfTheYear(AValue)
	      else
		if MonthOfTheYear(AValue)<=6 then
		   Result := StartOfTheMonth(EncodeDate(YearOf(AValue),4,1))
		else
		  if MonthOfTheYear(AValue)<=9 then
		     Result := StartOfTheMonth(EncodeDate(YearOf(AValue),7,1))
		  else
		     Result := StartOfTheMonth(EncodeDate(YearOf(AValue),10,1));

    gHalfYear:if MonthOfTheYear(AValue)<=6 then
		 Result := StartOfTheMonth(DateOf(AValue)-DayOfTheYear(AValue)+1)
	      else
		 Result := StartOfTheMonth(EncodeDate(YearOf(AValue),6,1));
    gYear    :Result := StartOfTheYear(AValue);
  end;

end;

function TGunterCalculater.GetLastDateTime(AValue: TDateTime;
  ATimeScale: TMFGantterTimeScale): TDateTime;
begin
  Result:=0;
  case ATimeScale of
    gMinute  :Result :=IncMinute(GetFirstDateTime(AValue,ATimeScale),1);
    gHour    :Result :=IncHour(GetFirstDateTime(AValue,ATimeScale),1);
    gDay     :Result :=EndOfTheDay(GetFirstDateTime(AValue,ATimeScale));
    gWeek    :Result :=EndOfTheWeek(GetFirstDateTime(AValue,ATimeScale));
    gMonth   :Result :=EndOfTheMonth(GetFirstDateTime(AValue,ATimeScale));
    gQuarter :if MonthOfTheYear(AValue)<=3 then
		 Result := EndOfTheMonth(EncodeDate(YearOf(AValue),3,1))
	      else
		if MonthOfTheYear(AValue)<=6 then
		   Result := EndOfTheMonth(EncodeDate(YearOf(AValue),6,1))
		else
		  if MonthOfTheYear(AValue)<=9 then
		     Result := EndOfTheMonth(EncodeDate(YearOf(AValue),9,1))
		  else
		     Result := EndOfTheYear(AValue);

    gHalfYear:if MonthOfTheYear(AValue)<=6 then
		 Result := DateOf(AValue)-DayOfTheYear(AValue)+1
	      else
		 Result := EncodeDate(YearOf(AValue),6,1);
    gYear    :Result := EndOfTheYear(AValue);
  end;
end;

function TGunterCalculater.GetNeedClearRect: TRect;
var RClient:TRect; Bottom,Height:Integer;
begin
  Result:=Rect(0,0,0,0);
  RClient:=GetPaintClass(TMFContentPaint).GetClientRect;
  Height :=SchemeView.GetSchemeDataTree.GetTreeHeight;

  {if SchemeView.FootOptions.Visible then
    Bottom:= RClient.Bottom-SchemeView.FootOptions.Height
  else   }
    Bottom:= RClient.Bottom;

  if RClient.Bottom >(Height+RClient.Top) then
    Result:=Rect(0,Height+RClient.Top,RClient.Right,Bottom);

end;

function TGunterCalculater.GetUnitDateTime(AValue: TDateTime;
  ATimeScale: TMFGantterTimeScale): TDateTime;
begin
  Result:=GetLastDateTime(AValue,ATimeScale)-GetFirstDateTime(AValue,ATimeScale);
end;

function TGunterCalculater.GetDateTimeToRelativeLeft(
  AValue: TDateTime): Integer;
begin
  Result:=Trunc((AValue-GetStartTime)/GetSubUnitDateTime*GetIntervalWith);
end;

function TGunterCalculater.GetRelativeLeftToDateTime(
  AValue: Integer): TDateTime;
begin
  Result:=(AValue*GetSubUnitDateTime)/GetIntervalWith+GetStartTime;
end;

function TGunterCalculater.GetEndTime: TDateTime;
begin
  Result:=SchemeView.ContentOptions.GantterEndTime;
end;

function TGunterCalculater.GetStartTime: TDateTime;
begin
  Result:=SchemeView.ContentOptions.FGantterStartTime;
end;

function TGunterCalculater.GetSubUnitDateTime: TDateTime;
begin
  if SubTimeHeadItem<>nil then
    Result:=GetUnitDateTime(GetStartTime,SubTimeHeadItem.TimeScale)*
	  SubTimeHeadItem.FInterval
  else
   Result:=0;
end;

function TGunterCalculater.GetRelativeRect(
  APaint: TMFBaseSchemePaint): TRect;
begin
  Result := GetClientRect(APaint);
  OffsetRect(Result,GetOffSetPoint(APaint).X,GetOffSetPoint(APaint).Y);
end;

function TGunterCalculater.GetIncDateTime(AValue: TDateTime;
  ATimeScale: TMFGantterTimeScale; iStep: Integer): TDateTime;
begin
  Result:=0;
  case ATimeScale of
    gMinute  :Result := IncMinute(AValue,iStep);
    gHour    :Result := IncHour(AValue,iStep);
    gDay     :Result := IncDay(AValue,iStep);
    gWeek    :Result := IncWeek(AValue,iStep);
    gMonth   :Result := IncMonth(AValue,iStep);
    gQuarter :Result := IncMonth(AValue,iStep*3);
    gHalfYear:Result := IncMonth(AValue,iStep*6);
    gYear    :Result := IncYear(AValue,iStep);
  end;

end;

function TGunterCalculater.GetSubTimeHeadItem: TMFTimeHeadItem;
begin
  Result := SchemeView.FHeadTimeOptions.GetUnitHeadItem;
end;

function TGunterCalculater.GetIntervalWith: Integer;
begin
  Result:=SchemeView.HeadTimeOptions.IntervalWidth;
end;

function TGunterCalculater.GetTimeHeadItemRect(
  ATimeHeadItem: TMFTimeHeadItem): TRect;
var
  I,iTop,iHeight,iCount:Integer; RClient:TRect;
  LastVisibleItem:TMFTimeHeadItem;
begin
  iTop:=0;
  RClient:= GetPaintClass(TMFContentPaint).GetClientRect;
  with SchemeView.HeadTimeOptions do
  begin
    Case SpreadType of
      sAuto :begin
	       iCount:=0;
	       for i:=0  to HeadItems.Count-1  do
		 if HeadItems.Items[I].Visible then
		 begin
		   iCount:= iCount+1;
		   LastVisibleItem:=HeadItems.Items[I];
		 end;
	       iHeight:= Trunc(SchemeView.HeadOptions.Height/iCount);

	       iCount:=0;
	       iTop:= SchemeView.HeadOptions.Height;
	       for i:=0  to ATimeHeadItem.Index do
		 if HeadItems.Items[I].Visible then
		 begin
		   iCount:= iCount+1;
		   iTop:=iTop-iHeight;
		 end;
	       
	       Result := Rect(RClient.Left,iTop,RClient.Right,iTop+ iHeight);
	       if  ATimeHeadItem=LastVisibleItem then
		 Result.Top:=0; // := Rect(RClient.Left,0,RClient.Right,iTop+ iHeight);
	     end;

      sFix  :begin
	       for i:=0  to ATimeHeadItem.Index do
		 if HeadItems.Items[I].Visible then
		   iTop:=iTop+ HeadItems.Items[i].Height;
	       Result := Rect(RClient.Left,SchemeView.HeadOptions.Height-iTop,
	         RClient.Right,SchemeView.HeadOptions.Height-iTop+ATimeHeadItem.Height);
	     end;
    end;
  end;
end;


function TGunterCalculater.GetClientLeftToDateTime(
  AValue: Integer): TDateTime;
var RReal:TRect;
begin
  RReal:=GetPaintClass(TMFContentPaint).GetRealRect;
  Result:=GetRelativeLeftToDateTime(AValue-RReal.Left);
end;

function TGunterCalculater.GetDateTimeToClientLeft(
  AValue: TDateTime): Integer;
var RReal:TRect;
begin
  RReal:=GetPaintClass(TMFContentPaint).GetRealRect;
  Result:=RReal.Left+GetDateTimeToRelativeLeft(AValue);
end;

function TGunterCalculater.GetNodeItemRect(AItem: TMFSchemeDataItem;
  ANode: TMFSchemeDataTreeNode): TRect;
var
  iBottom,iTop,iLeft,iRight:Integer;
  RClient:TRect;APoint:TPoint;
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
      iLeft:=GetDateTimeToClientLeft(AItem.BeginDate);
      iRight:=GetDateTimeToClientLeft(AItem.BeginDate+AItem.IntervalDate);
      Result:=Rect(iLeft,iTop+RClient.Top,iRight,iBottom++RClient.Top);
      APoint:=GetPaintClass(TMFContentPaint).GetOffSetPoint;
      OffsetRect(Result,0,-APoint.Y);
    end;
  end;
end;

function TGunterCalculater.GetNodeTextRect(
  ANode: TMFSchemeDataTreeNode;var Need:Boolean): TRect;
var
  RClient:TRect;
  P:TPoint;
  iText,iHeight,iLeft:Integer;
begin
  RClient:=ANode.GetNodeRect;
  iLeft:=RClient.Left ;
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
    Result.Left:=iLeft;
  end;

end;

function TGunterCalculater.GetTimeHeadItemUnitRect(APoint: TPoint;
  ATimeHeadItem: TMFTimeHeadItem): TRect;
var
  RSou,RReal:TRect;
  dStart,dNow:TDateTime;
  iLeft,iRight:Integer;
begin
  RReal := GetPaintClass(TMFHeadPaint).GetRelativeRect;
  with TMFGunterSchemeView(SchemeView).ContentOptions  do
  begin

    RSou:=GetTimeHeadItemRect(ATimeHeadItem);

    dNow:=GetClientLeftToDateTime(APoint.X);

    dStart:=GetFirstDateTime(GetStartTime,ATimeHeadItem.FTimeScale);

    while dStart<dNow do
      dStart:=GetIncDateTime(dStart,ATimeHeadItem.TimeScale,ATimeHeadItem.FInterval);
    dStart:= GetIncDateTime(dStart,ATimeHeadItem.TimeScale,-ATimeHeadItem.FInterval);
    dNow:=GetIncDateTime(dStart,ATimeHeadItem.TimeScale,ATimeHeadItem.FInterval);
    iLeft :=GetDateTimeToClientLeft(dStart);
    iRight:=GetDateTimeToClientLeft(dNow);
    Result:=Rect(iLeft,RSou.Top,iRight,RSou.Bottom);

  end;
end;

{ TMFGunterHeadPaint }

function TMFGunterHeadPaint.GetDrawCalculater: TGunterCalculater;
begin
  Result:= TGunterCalculater(inherited GetDrawCalculater);
end;

function TMFGunterHeadPaint.FormatGunterDate(Format:String;AStart,AEnd:TDateTime): String;
  Function GetFormatDateTime(AStr:String):string;
  var I:Integer;
  begin
    i:=Pos(':',AStr);
    if i>0 then
      Result :=Trim(Copy(AStr,i+1,Length(AStr)-i-1))
    else
      Result := '';
  end;

  Function GetChineseNum(Value:integer):string;
  const cChineseNum :array [0..9] of string =('零','一','二','三','四','五',
    '六','七','八','九');
  var I,J:Integer;S:string;
  begin
    S:=IntTostr(Value);
    Result:='';
    for I:=1 to Length(S)  do
    begin
      J:=StrToInt(S[I]);
      Result:=Result+ cChineseNum[J] ;
    end;

  end;

  Function UserFormatDateTime(sFormat:string;dDateTime:TDateTime):string;
  var I:Integer;S:string;
  begin
    // 我在考虑要不要实现多语言 目前支持中文和英文
    if  SysLocale.PriLangID= LANG_CHINESE  then
    begin
    
      if LowerCase(Trim(sFormat))='yyyyy' then
      begin
	I:=YearOf(dDateTime);
	S:=GetChineseNum(I);
	Result:=StringReplace(sFormat,'yyyyy',S,[]);

      end
      else

      if LowerCase(Trim(sFormat))='ddd' then
      begin
	Result:=FormatDateTime(sFormat,dDateTime);
	Result:=RightStr(Result,2);
      end
      
      else
      if LowerCase(Trim(sFormat))='mmm' then
      begin
	Result:=FormatDateTime(sFormat,dDateTime);
	Result:=LeftStr(Result,2);
      end
      else
	Result:=FormatDateTime(sFormat,dDateTime);
    end
    else
      Result:=FormatDateTime(sFormat,dDateTime);
  end;

  Function GetFormatStr(ATimeType:integer;AFormat:string):string;
  var I:Integer;Str:string;
  begin
    Result:='';
    case ATimeType of
      0:begin
	  i:=Pos('[S:',AFormat);
	  if i>0 then
	  begin
	    Inc(i,-3);
	    Str:=RightStr(AFormat,Length(AFormat)-i-2);
	    i:=Pos(']',Str);
	    Str:=LeftStr(Str,I);
	    Result := Str;
	  end;
	end;

      1:begin
	  i:=Pos('[E:',AFormat);
	  if i>0 then
	  begin
	    Inc(i,-3);
	    Str:=RightStr(AFormat,Length(AFormat)-i-2);
	    i:=Pos(']',Str);
	    Str:=LeftStr(Str,I);
	    Result := Str;
	  end;  
	end;
    end;

  end;
var Str:string;
begin
  with TMFGunterSchemeView(SchemeView).ContentOptions do
  begin
    Result:=Format;
    Str:=GetFormatStr(0,Result);
    while Str<>'' do
    begin
      Result:=StringReplace(Result,Str,UserFormatDateTime(GetFormatDateTime(Str),AStart),[]);
      Str:=GetFormatStr(0,Result);
    end;
    Str:=GetFormatStr(1,Result);
    while Str<>'' do
    begin
      Result:=StringReplace(Result,Str,UserFormatDateTime(GetFormatDateTime(Str),AEnd),[]);
      Str:=GetFormatStr(1,Result);
    end;
  end;
end;


procedure TMFGunterHeadPaint.Paint;
var I:Integer;R:TRect;
begin
  inherited;
  with TMFGunterSchemeView(SchemeView).HeadTimeOptions do
  begin
    for I:=0 to HeadItems.Count-1  do
    if  HeadItems.Items[i].Visible then 
      PaintTimeHeadItem(Canvas.DefCanvas,HeadItems.Items[i],R);
  end;
end;

procedure TMFGunterHeadPaint.PaintTimeHeadItem(ACanvas:TCanvas;
  AHeadItem:TMFTimeHeadItem;RLine:TRect;AHeadDrawType:THeadDrawType=hHead);
var
  RClient,RSou,RDes,RReal:TRect; dStart,dEnd:TDateTime;
  Height,Width,iLeft,iRight:Integer;
begin
  RClient:=GetClientRect;
  RReal := GetRelativeRect;
  with TMFGunterSchemeView(SchemeView).ContentOptions ,GetDrawCalculater do
  begin

    Width:=GetClientRect(GetPaintClass(TMFContentPaint)).Left;
    RSou:=GetTimeHeadItemRect(AHeadItem);
    Height :=RSou.Bottom - RSou.Top ;
    RClient:=Rect(RClient.Left+Width,RSou.Top,RClient.Right+Width,RSou.Bottom);
    RReal:=Rect(RReal.Left,RSou.Top,RReal.Right,RSou.Bottom);
    dStart:=GetFirstDateTime(GetStartTime,AHeadItem.FTimeScale);

    while dStart<GetRelativeLeftToDateTime(RReal.Left) do
      dStart:=GetIncDateTime(dStart,AHeadItem.TimeScale,AHeadItem.FInterval);

    dStart:=GetIncDateTime(dStart,AHeadItem.TimeScale,-AHeadItem.FInterval);

    if  AHeadDrawType= hhead then
    begin
      FFastBmp.Height:= Height;
      FFastBmp.Width :=RReal.Right-RReal.Left;
    end
    else begin
      FFastBmp.Height:= RLine.Bottom;
      FFastBmp.Width :=RLine.Right-RLine.Left;
      FFastBmp.Canvas.CopyRect(RLine,ACanvas,RLine);
    end;

    while dStart<GetRelativeLeftToDateTime(RReal.Right) do
    begin
      dEnd:=GetIncDateTime(dStart,AHeadItem.TimeScale,AHeadItem.FInterval);
      iLeft:=GetDateTimeToRelativeLeft(dStart);

      iRight:=GetDateTimeToRelativeLeft(dEnd);

      RSou:=Rect(iLeft-RReal.Left,0,iRight-RReal.Left,FFastBmp.Height);
      
      if  AHeadDrawType= hhead then
	PaintItemContent(AHeadItem,dStart,IncSecond(dEnd,-1),FFastBmp.Canvas,RSou)
      else
      begin

	PaintContentLine(AHeadItem,dStart,IncSecond(dEnd,-1),FFastBmp.Canvas,RSou);
      end;
      dStart:=dEnd;
    end;
  end;

  RSou:=Rect(0,0,FFastBmp.Width,FFastBmp.Height);
  RDes := Rect(RClient.Left,RClient.top,RClient.Left+ FFastBmp.Width,RClient.Bottom);

  
  if AHeadDrawType= hLine then
    RDes:=RLine
  else
  begin
    if AHeadItem.Index=0 then
     PaintNowTimeLine(FFastBmp.Canvas,RSou);
  end;
  ACanvas.CopyRect(RDes,FFastBmp.Canvas,RSou);
end;

procedure TMFGunterHeadPaint.PaintItemContent(AHeadItem:TMFTimeHeadItem;AStart,AEnd:TDateTime;ACanvas: TCanvas; R: TRect);
var RClient:TRect;
begin
  with LocalCanvas do
  begin
    DefCanvas:= ACanvas;
    Pen.Assign(AHeadItem.Pen);
    Brush.Style:=bsClear;
    Brush.Color:=AHeadItem.Color;
    DefCanvas.FillRect(R);

    RClient:= R;
    RClient.Left :=R.Left -1;
    RClient.Top := R.Top -1;
    DrawLine(RClient );
    //DrawComplexFrame(R,clBtnShadow,clBtnShadow,);
    Brush.Style:=bsClear;
    Font.Assign(AHeadItem.FFont);
    DrawTexT(FormatGunterDate(GetFormatText(AHeadItem.TimeScale),AStart,AEnd),R,gAlignCenter);
  end;
end;

procedure TMFGunterHeadPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

function TMFGunterHeadPaint.GetFormatText(
  AScale: TMFGantterTimeScale): String;
begin
  with TMFGunterSchemeView(SchemeView).HeadTimeOptions do
  begin
    Result:=ScaleFormat.Values[StringTimeScale[AScale]];
  end;
end;

procedure TMFGunterHeadPaint.PrepareContent(ACanvas: TCanvas;R: TRect);
var I:Integer;
begin
  inherited;
  with TMFGunterSchemeView(SchemeView).HeadTimeOptions do
  begin
    for I:=0 to HeadItems.Count-1  do
    if  HeadItems.Items[i].Visible then
      //if HeadItems.Items[i].ContentVLinePen.Style<>psClear then
	PaintTimeHeadItem(ACanvas,HeadItems.Items[i],R,hLine);
  end;
end;

procedure TMFGunterHeadPaint.PaintContentLine(AHeadItem: TMFTimeHeadItem;
  AStart, AEnd: TDateTime; ACanvas: TCanvas; R: TRect);

  Procedure RestFill(RFill:TRect;AColor:TColor);
  begin
    ACanvas.Pen.Style:=psClear;
    ACanvas.Brush.Style :=bsSolid;
    ACanvas.Brush.Color:=AColor;
     
    ACanvas.FillRect(RFill);

  end;

var
  I,iSHour,iEHour,iLength:Integer;
  RClient:TRect; bDraw:Boolean;
begin
  if  AHeadItem.ContentVLinePen.Style<>psClear then
  begin
    LocalCanvas.Canvas:= ACanvas ;
    ACanvas.Pen.Assign(AHeadItem.ContentVLinePen);
    ACanvas.Brush.Style:=bsClear;
    LocalCanvas.DrawComplexFrame(R,clBtnFace,clBtnFace,[dright]);
  end;

  with TMFGunterSchemeView(SchemeView).ContentOptions do
  if ShowRestDateColor then
  begin

    // for the day
    if AHeadItem.TimeScale= gDay then
    if not( TMFWeekDay(DayOfTheWeek(AStart)-1) in WorkDayforWeek) then
    begin
      RestFill(R, RestDateColor );

    end;

    // for the hour
    RClient := R;
    if AHeadItem.TimeScale= gHour then
    begin

      if not( TMFWeekDay(DayOfTheWeek(AStart)-1) in WorkDayforWeek) then
      begin
	RestFill(R,RestDateColor);
      end
      else
      begin
	iLength := R.Right-R.Left;
	iSHour:=MinuteOfTheDay(AStart);
	iEHour:=MinuteOfTheDay(AEnd);
	RestFill(R,RestDateColor);
	for I:=0 to WorkHourforDays.Count-1 do
	with WorkHourforDays.Items[I] do
	if Visible then
	begin
          RClient:=R;
          bDraw:=false;
          if (GetALLStartMinute<=iSHour) And
            (GetALLEndMinute>=iEHour)  then
	  begin
            bDraw:=true;
	  end
          else
          begin
            if (GetALLStartMinute>=iSHour) And
              (GetALLStartMinute<=iEHour)  then
            begin
              RClient.Left:= R.Left+
                Round(iLength*(GetALLStartMinute-iSHour)/(iEHour-iSHour));
              bDraw:=true;
            end;

            if (GetALLEndMinute>=iSHour) And
              (GetALLEndMinute<=iEHour)  then
            begin
              RClient.Right:= R.Right-
                Round(iLength*(iEHour-GetALLEndMinute)/(iEHour-iSHour));
              bDraw:=true;
            end;
          end;
          if bDraw then
          begin
            RestFill(RClient,Color);
          end;
	end;

      end;

    end;

  end; // end if
end;

procedure TMFGunterHeadPaint.PaintNowTimeLine(ACanvas: TCanvas; R: TRect);
var NowLeft,Width:Integer; RClient:TRect;
begin
  with TMFGunterSchemeView(SchemeView).HeadTimeOptions ,GetDrawCalculater do
  if FNowTimeLinePen.Style <>psClear then
  begin
    NowLeft:=GetDateTimeToClientLeft(Now);
    
    RClient:=GetPaintClass(TMFContentPaint).GetClientRect;
    if (NowLeft>RClient.Left) and (NowLeft<RClient.Right)  then
    begin
      Width:=Trunc((R.Bottom-R.top)/2);
      R.Left:=NowLeft-RClient.Left;
      LocalCanvas.Canvas:=ACanvas;
      ACanvas.Brush.Style:=bsSolid;
      
      ACanvas.Brush.Color:=NowTimeLinePen.Color;
      ACanvas.Pen.Style:=psClear;
      ACanvas.Pen.Mode:=NowTimeLinePen.Mode;

      {ACanvas.Polygon([Point(R.Left-6,R.Top),Point(R.Left+6,R.Top),
      Point(R.Left+6,R.Top+6),Point(R.Left,R.Top+12),Point(R.Left-6,R.Top+6)]);}
      
      ACanvas.Polygon([Point(R.Left-4,R.Top),Point(R.Left+4,R.Top),
      Point(R.Left,R.Top+4)]);

      ACanvas.Pen.Assign(NowTimeLinePen);
      ACanvas.Brush.Style:=bsClear;

      ACanvas.MoveTo(R.Left,R.Top+5);
      ACanvas.LineTo(R.Left,R.Bottom);

    end;
  end;
  

end;

{ TMFGunterContentPaint }

function TMFGunterContentPaint.GetDrawCalculater: TGunterCalculater;
begin
  Result := TGunterCalculater(inherited GetDrawCalculater);
end;

procedure TMFGunterContentPaint.Paint;
begin
  inherited;

end;

procedure TMFGunterContentPaint.PaintContent(Node: TMFSchemeDataTreeNode;ACanvas: TCanvas; R: TRect);
begin
  LocalCanvas.DefCanvas:= ACanvas;
  with LocalCanvas,TMFGunterSchemeView(SchemeView) do
  begin
    Brush.Style:=bsClear;

    if ContentOptions.Pen.Style<>psClear then
    begin
      DrawLine(R,[dBottom],ContentOptions.Pen);
    end
    else
      if Node.IsLastVisibleNode  then
      begin
	ACanvas.Pen.Assign(ContentOptions.Pen);
        ACanvas.Pen.Style:=psSolid;
	DrawLine(R,[dBottom],nil);

      end;
  end;
end;

procedure TMFGunterContentPaint.PaintItemContent(
  ADataItem: TMFSchemeDataItem; ACanvas: TCanvas; R: TRect);
var
  RClient,RText:TRect;
  iHeight,iWidth:Integer;
  P:TPoint;
  Range:TRangePath;
begin

  LocalCanvas.DefCanvas:= ACanvas;

  with TMFGunterSchemeView(SchemeView),LocalCanvas.DefCanvas do
  begin
    Font.Assign(ContentOptions.Font);

    Pen.Color:=clBlack;
    Pen.Mode:=pmCopy;
    Pen.Style:=psSolid ;

    if ContentOptions.ItemShadow then
      RClient:=PaintGunterStyle(ADataItem,ACanvas,R)
    else
      RClient:= R;

    if ADataItem.Selected then
    begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Rectangle(RClient);

      if ContentOptions.ShowPercent then
	PaintGunterPercent(ADataItem,ACanvas,RClient);

      LocalCanvas.DrawFocusRect(RClient);

    end
    else begin

      Brush.Style:=bsSolid;
      Brush.Color:=ADataItem.Color;
      Rectangle(RClient);
	
      if ContentOptions.ShowPercent then
	PaintGunterPercent(ADataItem,ACanvas,RClient);
    end;

    Brush.Style :=bsClear ;
    
    iWidth  := LocalCanvas.TextWidth(ADataItem.Text);
    iHeight := LocalCanvas.TextHeight(ADataItem.Text);
    
    RText:=CenterRect(RClient,iHeight);

    case ADataItem.CaptionPosition of

      cpCenter:begin
		 if  ContentOptions.ItemFontColorType=fctAuto Then
		 begin
		   if ADataItem.Selected then
		     Font.Color := InvertColor(ContentOptions.Font.Color)
		   else
		     Font.Color := InvertColor(ADataItem.Color);
		 end;

		 LocalCanvas.DrawTexT(ADataItem.Text,RClient,gAlignCenter+gShowEndEllipsis);
	       end;

      cpRight :begin
		 OffsetRect(RText,(R.Right-R.Left)+5 ,0 );
		 RText.Right := RText.Left+iWidth;
		 LocalCanvas.DrawTexT(ADataItem.Text,RText,gAlignLeft+gAlignVCenter);
	       end;

      cpLeft  :begin
		 OffsetRect(RText,-iWidth-5,0);
		 RText.Right := RText.Left+iWidth;
		 LocalCanvas.DrawTexT(ADataItem.Text,RText,gAlignLeft+gAlignVCenter);
	       end;
	       
    end;
    
  end;

  SchemeView.PaintItem(SchemeView,ADataItem,ACanvas,RClient);

  //LocalCanvas.DrawComplexFrame(R,clBtnShadow,clBtnShadow,[dleft,dBottom,dRight]);
end;

function TMFGunterContentPaint.PaintGunterStyle(Item: TMFSchemeDataItem;
  ACanvas: TCanvas; R: TRect):TRect;
var RRight,RBottom: TRect;
begin

  Result:=Rect(R.Left,R.Top,R.Right-3,R.Bottom-3 );
  RRight:= Rect(R.Right-3,R.Top+3,R.Right,R.Bottom );
  RBottom:= Rect(R.Left+3,R.Bottom-3,R.Right,R.Bottom );
  ACanvas.Brush.Style :=bsSolid;
  ACanvas.Brush.Color := cl3DDkShadow;
  ACanvas.FillRect(RRight);
  ACanvas.FillRect(RBottom);
  LocalCanvas.Canvas:= ACanvas ;
 
end;

procedure TMFGunterContentPaint.PaintLinkLine(
  Node: TMFSchemeDataTreeNode; ACanvas: TCanvas; R,RealRect: TRect);
var  // zhangcheng write
  DX, DY, DXY, IsRect,I,J,iLeft: Integer;
  LastPoint:Boolean;
  P1, P3,PTemp: TPoint;  FPoints:array [0..3] of TPoint;
  RClient:TRect;LinkPath:TLinkPath;
  
  procedure Rotate(var P: TPoint);
  var
    X, Y: Integer;
  begin
    X := (P.X * DX - P.Y * DY) div DXY;
    Y := (P.X * DY + P.Y * DX) div DXY;
    P.X := X + FPoints[1].X;
    P.Y := Y + FPoints[1].Y;
  end;
  
begin

  RClient:=GetDrawCalculater.GetPaintClass(TMFContentPaint).GetClientRect;
  iLeft:=RClient.Left;
  RClient:=RealRect;
  
  ACanvas.Pen.Style:=psSolid;
  ACanvas.Pen.Mode :=pmCopy;
  ACanvas.Pen.Color:=clBlue;
  ACanvas.Brush.Color := clBlue;
  ACanvas.Brush.Style:=bsSolid;
  
  with GetSchemeDataTree do
    For I:=0 to DataItemLinks.Count-1 do
    begin
      DataItemLinks.Items[i].CalcPath;
      LinkPath:=DataItemLinks.Items[i].PassPath(RClient,LastPoint);
      if Length(LinkPath)>1  then
      begin
	For J:=Low(LinkPath) to High(LinkPath)  do
	begin
	  LinkPath[J].Y:=LinkPath[J].Y-RClient.Top;
	  LinkPath[J].X:=LinkPath[J].X-iLeft;
	end;
	ACanvas.Polyline(LinkPath);

	if LastPoint then
	begin
	  PTemp :=LinkPath[Length(LinkPath)-1];

	  P1:=PTemp;

	  P3:=LinkPath[Length(LinkPath)-2];

	  FPoints[1]:=P1;

	  // 这个东西计算是比较复杂的
	  
	  DX := P3.X - P1.X; DY := P3.Y - P1.Y;

	  if (DX = 0) or (DY = 0) then
	    DXY := Abs(DX + DY)
	  else
	    DXY := Round(Sqrt(DX * DX + DY * DY));
	  
	  if DXY = 0 then DXY := 1;
	  FPoints[0].X := 5; FPoints[0].Y := (10 + 1) shr 1;
	  FPoints[2].X := 5; FPoints[2].Y := -FPoints[0].Y;
	  Rotate(FPoints[0]); Rotate(FPoints[2]);
	  FPoints[3]:=FPoints[2];
	  
	  ACanvas.Polygon(FPoints);
	end;
	
      end;
    end;

end;

procedure TMFGunterContentPaint.PaintNowTimeLine(ACanvas: TCanvas;
  R: TRect);
var NowLeft:Integer; RClient:TRect;
begin
  with TMFGunterSchemeView(SchemeView).HeadTimeOptions ,GetDrawCalculater do
  if FNowTimeLinePen.Style <>psClear then
  begin
    NowLeft:=GetDateTimeToClientLeft(Now);

    RClient:=Self.GetClientRect;
    if (NowLeft>RClient.Left) and (NowLeft<RClient.Right)  then
    begin
      R.Left:=NowLeft-RClient.Left;
      LocalCanvas.Canvas:=ACanvas;
      LocalCanvas.DrawLine(R,[dLeft],FNowTimeLinePen);
    end;
  end;

end;

procedure TMFGunterContentPaint.PaintRow(Node: TMFSchemeDataTreeNode;
  ACanvas: TCanvas; R,RealRect: TRect);
var
  RClient,RSou,RDes,RReal:TRect; dStart,dEnd,dItemStart,dItemEnd:TDateTime;
  i,Height,NowLeft, iLeft,iRight:Integer;
begin
  RClient:=GetClientRect;
  RReal := GetRelativeRect;
  with TMFGunterSchemeView(SchemeView).ContentOptions ,GetDrawCalculater do
  begin

    Height :=Node.Height;

    dStart:=GetRelativeLeftToDateTime(RReal.Left);
    dEnd := GetRelativeLeftToDateTime(RReal.Right);

    FFastBmp.Width :=R.Right-R.Left;
    FFastBmp.Height:= Height;
    RSou:=Rect(0,0,FFastBmp.Width,FFastBmp.Height);
    
    ClearFastBmp(Color);

    TMFGunterHeadPaint(GetPaintClass(TMFHeadPaint)).PrepareContent(FFastBmp.Canvas,RSou);

    PaintContent(Node,FFastBmp.Canvas,RSou);

    for i:=0 to Node.DataItemCount-1 do
    begin
      dItemEnd:=Node.DataItems[i].BeginDate+Node.DataItems[i].IntervalDate;
      dItemStart :=  Node.DataItems[i].BeginDate;
      if (dStart > dItemEnd) or (dEnd > dItemStart) then
      begin
	iLeft:=GetDateTimeToRelativeLeft(dItemStart);
	iRight:=GetDateTimeToRelativeLeft(dItemEnd);
	RDes:=Rect(iLeft-RReal.Left+RClient.Left,0,iRight-RReal.Left+RClient.Left,FFastBmp.Height);
	PaintItemContent(Node.DataItems[i],FFastBmp.Canvas,RDes);
      end;
    end;

    PaintLinkLine(Node,FFastBmp.Canvas,R,RealRect);

    PaintNowTimeLine(FFastBmp.Canvas,RSou);
  end;

  ACanvas.CopyRect(R,FFastBmp.Canvas,RSou);
end;

procedure TMFGunterContentPaint.ZcInvalidate(const R: TRect);
begin
  inherited;

end;

function TMFGunterContentPaint.PaintGunterPercent(
  Item: TMFSchemeDataItem; ACanvas: TCanvas; R: TRect): TRect;
var RClient:TRect;
begin
  
  with TMFGunterSchemeView(SchemeView).ContentOptions,ACanvas do
  begin
    RClient:=R;
    Brush.Style:=bsSolid;
    Pen.Width:=1;
    Pen.Mode:=pmCopy;

    if Item.Selected then
    begin
      Brush.Color:= clHighlight;
      Pen.Style:=psDot ;
    end
    else begin
      if PercentColorType=pctAuto then
	Brush.Color:= InvertColor(Item.Color)
      else
	Brush.Color:=PercentColor;
      Pen.Style:=psSolid ;
      
    end;

    RClient.Right:= RClient.Left +
      Trunc((RClient.Right-RClient.Left)* Item.Percent/100);

    case PercentPosition of
      ppTop:   begin
		 RClient.Top:=R.Top;
		 RClient.Bottom:=RClient.Top+PercentWidth;
	       end;
      ppCenter: RClient := CenterRect(RClient,PercentWidth);

      ppAll: ;//

      ppBottom:begin
		 RClient.Bottom:=R.Bottom;
		 RClient.Top:=RClient.Bottom-PercentWidth;
	       end;

    end;
    if R.Right< RClient.Right then
      RClient.Right:= R.Right;
    Rectangle(RClient);
  end;
end;

function TMFGunterContentPaint.GetItemSharp(
  ADataItem: TMFSchemeDataItem;R: TRect): TRangePath;
begin

  case ADataItem.LeftShapeType of
    stNone:begin
	     
	   end;

    stPolygonUp:begin

		end;

    stPolygonDown:begin

		  end;

    stRotundity:begin

		end;

    stTriangleUp:begin

		 end;

    stTriangleDown:begin

		   end;
		   
    stDiamond:begin

	      end;
  end;
end;

{ TMFGunterContentOptions }

procedure TMFGunterContentOptions.Assign(Source: TPersistent);
begin
  if  Source is TMFGunterContentOptions then
  begin
    inherited;
    FGantterEndTime:= TMFGunterContentOptions(Source).GantterEndTime;
    FGantterStartTime:=TMFGunterContentOptions(Source).GantterStartTime;
  end;
    
end;

constructor TMFGunterContentOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited Create(AView);
  FGantterStartTime:=DateOf(Now())-1;
  FGantterEndTime:=IncDay(FGantterStartTime);
  FWorkHourforDays:= TMFHourforDays.Create(AView,TMFHourforDayItem);
  FShowRestDateColor:=True;
  FPen.Color:=clBtnShadow;
  FPen.Style:=psClear;
  FColor := clWhite;
  FAutoFetchSpace:=7;
  FShowDragHint:=True;
  FShowPercent:=True;
  FPercentWidth:=6;
  FItemShadow:=True;
  FTItemFontColorType := fctAuto;
end;

destructor TMFGunterContentOptions.Destroy;
begin
  FWorkHourforDays.Free;
  inherited;
end;

procedure TMFGunterContentOptions.SetFPercentColorType(
  const Value: TPercentColorType);
begin
  if FPercentColorType<>Value then
  begin
    FPercentColorType := Value;
    Change; 
  end;
end;

procedure TMFGunterContentOptions.SetGantterEndTime(
  const Value: TDateTime);
begin
  if FGantterEndTime<> Value then
  begin
    FGantterEndTime := Value;
    View.Update;
  end;
end;

procedure TMFGunterContentOptions.SetGantterStartTime(
  const Value: TDateTime);
begin
  if FGantterStartTime<> Value then
  begin
    FGantterStartTime := Value;
    View.Update;
  end;
end;


procedure TMFGunterContentOptions.SetItemShadow(const Value: Boolean);
begin
  if FItemShadow<>Value then
  begin
    FItemShadow := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetPercentColor(const Value: TColor);
begin
  if FPercentColor<>Value then
  begin
    FPercentColor := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetPercentPosition(
  const Value: TPercentPosition);
begin
  if FPercentPosition<> Value then
  begin
    FPercentPosition := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetPercentWidth(const Value: Integer);
begin
  if FPercentWidth<> Value then
  begin
    FPercentWidth := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetRestDateColor(const Value: TColor);
begin
  if FRestDateColor<> Value then
  begin
    FRestDateColor := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetShowPercent(const Value: Boolean);
begin
  if FShowPercent<> Value then
  begin
    FShowPercent := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetShowRestDateColor(
  const Value: Boolean);
begin
  if FShowRestDateColor<> Value then
  begin
    FShowRestDateColor := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetTItemFontColorType(
  const Value: TItemFontColorType);
begin
  if FTItemFontColorType<> Value then
  begin
    FTItemFontColorType := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetWorkdayforWeek(
  const Value: TMFWeekDays);
begin
  if FWorkdayforWeek <> Value then
  begin
    FWorkdayforWeek := Value;
    Change;
  end;
end;

procedure TMFGunterContentOptions.SetWorkHourforDays(
  const Value: TMFHourforDays);
begin
  FWorkHourforDays := Value;
end;

{ TMFGunterHeadOptions }

procedure TMFGunterHeadOptions.Assign(Source: TPersistent);
begin
  if Source is TMFGunterHeadOptions then
  begin
    FInterval:=TMFGunterHeadOptions(Source).Interval;
    FDateTimeFormat:=TMFGunterHeadOptions(Source).DateTimeFormat;
    FTimeScale:=TMFGunterHeadOptions(Source).TimeScale;
    FFont.Assign(TMFGunterHeadOptions(Source).FFont);
    FContentVLinePen.Assign(TMFGunterHeadOptions(Source).FContentVLinePen);
  end
  else
    inherited;
end;

procedure TMFGunterHeadOptions.Change;
begin
  inherited;
end;

constructor TMFGunterHeadOptions.Create(AView:TMFBaseSchemeView;AOwner:TPersistent);
begin
  inherited Create(AView);
  FFont:=TFont.Create;
  FContentVLinePen:=TPen.Create;
  FNowTimeLinePen:=TPen.Create;
  FOwner:=AOwner;
end;

destructor TMFGunterHeadOptions.Destroy;
begin
  FContentVLinePen.Free;
  FNowTimeLinePen.Free;
  FFont.Free;
  inherited;
end;

function TMFGunterHeadOptions.GetOwner: TPersistent;
begin
  Result:=FOwner;
end;

procedure TMFGunterHeadOptions.SetDateTimeFormat(const Value: string);
begin
  FDateTimeFormat := Value;
end;

procedure TMFGunterHeadOptions.SetInterval(const Value: Integer);
begin
  FInterval := Value;
end;

procedure TMFGunterHeadOptions.SetNowTimeLinePen(const Value: TPen);
begin
  FNowTimeLinePen.Assign(Value);
end;

procedure TMFGunterHeadOptions.SetTimeScale(
  const Value: TMFGantterTimeScale);
begin
  FTimeScale := Value;
end;

{ TMFTimeHeadItem }

procedure TMFTimeHeadItem.Assign(Source: TPersistent);
begin
  inherited;
  if  Source is  TMFTimeHeadItem then
  begin
    FVisible		:= TMFTimeHeadItem(Source).FVisible;
    FInterval		:= TMFTimeHeadItem(Source).FInterval;
    FTimeScale		:= TMFTimeHeadItem(Source).FTimeScale;
    FFont	     	:= TMFTimeHeadItem(Source).FFont;
    FContentVLinePen 	:= TMFTimeHeadItem(Source).FContentVLinePen;
    FPen	     	:= TMFTimeHeadItem(Source).FPen;
    Change(self);
  end;
end;

procedure TMFTimeHeadItem.Change(Sender:TObject);
begin
  if Collection <>nil then
  begin
    TMFTimeHeads(Collection).Update(Self);
  end;
end;

constructor TMFTimeHeadItem.Create(Collection: TCollection);
begin
  inherited;
  FFont:= TFont.Create;
  FContentVLinePen := TPen.Create;
  FPen:= TPen.Create;
  FVisible:=True;
  FInterval:= 1;
  FTimeScale := gDay;
  FHeight:=25;
  FPen.OnChange:=Change;
  FFont.OnChange := Change;
  FContentVLinePen.OnChange :=Change;
  FColor:=clBtnFace;
  Pen.Color := clBtnShadow
end;

destructor TMFTimeHeadItem.Destroy;
begin
  FFont.Free;
  FContentVLinePen.Free;
  FPen.Free; 
  inherited;
end;

function TMFTimeHeadItem.GetDisplayName: string;
begin
  Result := 'Item-'+StringTimeScale[TimeScale];
end;


procedure TMFTimeHeadItem.SetColor(const Value: TColor);
begin
  if FColor<> Value then
  begin
    FColor := Value;
    Change(self);
  end;
end;

procedure TMFTimeHeadItem.SetContentVLinePen(const Value: TPen);
begin
  FContentVLinePen.Assign(Value);
end;

procedure TMFTimeHeadItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TMFTimeHeadItem.SetHeight(const Value: Integer);
begin
  if FHeight<> Value then
  begin
    FHeight := Value;
    Change(self);
  end;
end;

procedure TMFTimeHeadItem.SetInterval(const Value: Integer);
begin
  if FInterval<> Value then
  begin
    FInterval:=Value;
    Change(self);
  end;
end;

procedure TMFTimeHeadItem.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TMFTimeHeadItem.SetTimeScale(
  const Value: TMFGantterTimeScale);
begin
  if FTimeScale<> Value then
  begin
    FTimeScale := Value;
    Change(self);
  end;
end;

procedure TMFTimeHeadItem.SetVisible(const Value: Boolean);
begin
  if FVisible<> Value then
  begin
    FVisible := Value;
    Change(self);
  end;
end;

{ TMFTimeHeads }

function TMFTimeHeads.Add: TMFTimeHeadItem;
begin
  Result:= TMFTimeHeadItem(inherited Add );
  
end;

function TMFTimeHeads.GetItem(Index: Integer): TMFTimeHeadItem;
begin
  Result:= TMFTimeHeadItem(inherited GetItem(Index) );
end;

procedure TMFTimeHeads.SetItem(Index: Integer;
  const Value: TMFTimeHeadItem);
begin
  inherited SetItem(Index,Value);
end;

procedure TMFTimeHeads.Update(Item: TCollectionItem);
begin
  inherited;

  if Owner<>nil then
  with TMFViewHeadOptions(Owner) do
  if View <>nil then
  if not (csLoading in View.ComponentState) then
  begin
    View.Invalidate;

  end;
end;

{ TMFViewHeadOptions }

procedure TMFViewHeadOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is  TMFViewHeadOptions then
  begin
    FHeadItems.Assign(TMFViewHeadOptions(Source).HeadItems);
    FNowTimeLinePen.Assign(TMFViewHeadOptions(Source).NowTimeLinePen);
    FIntervalWidth:=TMFViewHeadOptions(Source).FIntervalWidth;
  end;
end;

constructor TMFViewHeadOptions.Create(AView: TMFBaseSchemeView);
begin
  inherited Create(AView);
  FHeadItems:= TMFTimeHeads.Create(Self,TMFTimeHeadItem);
  FScaleFormat:= TStringList.Create;
  TStringList(FScaleFormat).OnChange := SetChange;
  FScaleFormat.Text := StringScaleFormat;
  FHintScaleFormat:= TStringList.Create;
  FScaleFormat.Text := StringHintScaleFormat;
  FNowTimeLinePen:=TPen.Create;
  FIntervalWidth:=50;
end;

destructor TMFViewHeadOptions.Destroy;
begin
  FHeadItems.Free;
  FScaleFormat.Free;
  FHintScaleFormat.Free; 
  FNowTimeLinePen.Free;
  inherited;
end;

function TMFViewHeadOptions.GetUnitHeadItem: TMFTimeHeadItem;
begin
  if  HeadItems.Count >0 then
    Result := HeadItems.GetItem(0)
  else
    Result := nil;
end;

procedure TMFViewHeadOptions.SetChange(Sender: TObject);
begin
  Change; 
end;

procedure TMFViewHeadOptions.SetHeadItems(const Value: TMFTimeHeads);
begin
  FHeadItems.Assign(Value);
end;

procedure TMFViewHeadOptions.SetHintScaleFormat(const Value: TStrings);
begin
  FHintScaleFormat := Value;
end;

procedure TMFViewHeadOptions.SetIntervalWidth(const Value: Integer);
begin
  if FIntervalWidth<>Value then
  begin
    FIntervalWidth := Value;
    View.Update;
  end;
end;

procedure TMFViewHeadOptions.SetNowTimeLinePen(const Value: TPen);
begin
  FNowTimeLinePen.Assign(Value);
end;

procedure TMFViewHeadOptions.SetScaleFormat(const Value: TStrings);
begin
  FScaleFormat.Assign(Value);
end;


procedure TMFViewHeadOptions.SetSpreadType(const Value: TSpreadType);
begin
  if FSpreadType<>Value then
  begin
    FSpreadType := Value;
    Change;
  end;
end;

{ TMFItemDataOptions }

procedure TMFItemDataOptions.Assign(Source: TPersistent);
begin
  inherited;

end;

constructor TMFItemDataOptions.Create(AView: TMFBaseSchemeView);
begin
  inherited;
  FPicture :=TPicture.Create;
  FBrush:=TBrush.Create;
end;

destructor TMFItemDataOptions.Destroy;
begin
  FPicture.Free;
  FBrush.Free;
  inherited;
end;

procedure TMFItemDataOptions.SetBrush(const Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TMFItemDataOptions.SetBrushType(const Value: TMFBrushType);
begin
  FBrushType := Value;
end;

procedure TMFItemDataOptions.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
end;

procedure TMFItemDataOptions.SetPicture(const Value: TPicture);
begin
  FPicture.Assign( Value);
end;

procedure TMFItemDataOptions.SetSpreadType(const Value: TSpreadType);
begin
  if FSpreadType<>Value then
  begin
    FSpreadType := Value;
    Change;
  end;
end;

procedure TMFGunterSchemeView.TreeChanged(AEventType: TEventType;
  AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin
  inherited;
  FGunterViewControl.TreeChanged(AEventType,AEvent,AIndex);
end;

procedure TMFGunterSchemeView.WMSetCursor(var Message: TWMSetCursor);
begin
  inherited;
  FGunterViewControl.SetCursor(Message);
end;

{ TMFGunterViewControl }

constructor TMFGunterViewControl.Create(AView: TMFGunterSchemeView);
begin
  inherited Create(AView);
  MoveRec.MoveType:=gmNone;
  MoveRec.AItem :=nil;
end;

function TMFGunterViewControl.GetSchemeView: TMFGunterSchemeView;
begin
  Result:=TMFGunterSchemeView(FBaseView);
end;

procedure TMFGunterViewControl.NeedScroll(Node:TMFSchemeDataTreeNode);
var
 R,RClient:TRect;iHeight,Percent:Integer;
begin
 with SchemeView.FGunterPaint.FGunterCalculater do
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

procedure TMFGunterViewControl.KeyDown(var Key: Word; Shift: TShiftState);
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

      VK_UP   : if CanNodeKeyDown then
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


procedure TMFGunterViewControl.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TMFGunterViewControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AViewHitInfo:TViewHitInfo; RClient:TRect;
begin
  with SchemeView,SchemeView.FGunterPaint.FGunterCalculater do
  //Andyzhang Change mouse Select Item Type
  if CheckItemSeleMFype(Button,ContentOptions.ItemSeleMFype) then
  begin
    MoveRec.MouseType:= mtDown;
    MoveRec.DownPoint := Point(X,Y);
    MoveRec.OPoint :=  MoveRec.DownPoint;
    MoveRec.NPoint :=  MoveRec.DownPoint;

    MoveRec.ARect:=Rect(0,0,0,0);
    AViewHitInfo:=GetHitInfo(Point(X,y));
    if AViewHitInfo.APaintClass<> nil then
    begin

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
	  FGunterPaint.Paint(AViewHitInfo.APaintClass);
	  FGunterPaint.Paint(GetPaintClass(TMFIndicaterPaint));
	end;
      end;

      if AViewHitInfo.AHitType in [pContent,pItem,pTreeRight,pItemLeft,pItemRight] then
      begin

	Case AViewHitInfo.AHitType of
	  pTreeRight:begin
		       MoveRec.MoveType := gmTreeSize;
		       MoveRec.ARect:=GetPaintClass(TMFSchemeTreePaint).GetClientRect;
		       MoveRec.ARect.Top:=GetPaintClass(TMFHeadPaint).GetClientRect.Top;
		     end;

	  pItemLeft :if CheckItemCanChange(AViewHitInfo) then
		     begin
		       MoveRec.MoveType := gmItemLeft;
		       MoveRec.ARect:= AViewHitInfo.AItem.GetItemClientRect;
		       MoveRec.AItem:=AViewHitInfo.AItem;
		     end
		     else
		       MoveRec.MoveType := gmNone;

	  pItemRight:if CheckItemCanChange(AViewHitInfo) then
		     begin
		       MoveRec.MoveType := gmItemRight;
		       MoveRec.ARect:= AViewHitInfo.AItem.GetItemClientRect;
		       MoveRec.AItem:=AViewHitInfo.AItem;
		     end
		     else
		       MoveRec.MoveType := gmNone;
	  pItem     :if CheckItemCanChange(AViewHitInfo) then
		      Begin
			MoveRec.MoveType := gmItemMove;
			MoveRec.ARect:= AViewHitInfo.AItem.GetItemClientRect;
			MoveRec.AItem:=AViewHitInfo.AItem;
		      end
		      else
		       MoveRec.MoveType := gmNone;
	  pContent :begin
		      MoveRec.MoveType := gmContent;
		      MoveRec.ARect:=GetPaintClass(TMFContentPaint).GetClientRect;

		    end;
	end;
	RClient:=Calc(MoveRec.ARect,MoveRec.DownPoint);
	if not (AViewHitInfo.AHitType in [pItem,pContent]) then
	  FGunterPaint.PaintMoveSize(RClient);
      end;


      //if not IsReadOnly then
      if  AViewHitInfo.APaintClass.InheritsFrom(TMFContentPaint)
      and (AViewHitInfo.ANode<>nil) and (AViewHitInfo.AItem<>nil) then
      with GetSchemeDataTree,AViewHitInfo do
      begin

	//MultiSelect
	if ContentOptions.MultiSelect then

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
	FGunterPaint.Paint(APaintClass);
      end;

    end;

  end;
  
end;

function TMFGunterViewControl.Calc(R:TRect;APoint:TPoint):TRect;
var
  RClient,RNode:TRect;
  AViewHitInfo:TViewHitInfo;
begin
  with SchemeView.FGunterPaint.FGunterCalculater do
  begin
    RClient:=GetPaintClass(TMFContentPaint).GetClientRect;

    case MoveRec.MoveType of
      gmTreeSize : R.Right:=APoint.X;
      gmItemLeft : begin
		    R.Left:=APoint.X;

		  end;
      gmItemRight: begin
		    R.Right:=APoint.X;
		    if RClient.Left>R.Left then
		      R.Left:=RClient.Left;
		  end;
      gmItemMove :begin
		   OffsetRect(R,APoint.X-MoveRec.DownPoint.X,0);
		   AViewHitInfo:=GetHitInfo(APoint);
		   if  AViewHitInfo.ANode<>nil then
		   begin
		     RNode:=AViewHitInfo.ANode.GetNodeRect;
		     R:=Rect(R.Left,RNode.Top,R.Right,RNode.Bottom);
		     DragDropNear(AViewHitInfo.ANode,MoveRec.AItem,R);
		   end
		 end;
    end;
  end;
  Result:=R;
end;

procedure TMFGunterViewControl.MouseMove(Shift: TShiftState; X,
  Y: Integer);
var RClient:TRect;
begin
  inherited;
  if ssLeft in Shift  then
  begin
    MoveRec.NPoint:=Point(X,Y);
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);


    case MoveRec.MoveType of
      gmTreeSize,gmItemLeft,gmItemRight:
		begin
		  SchemeView.FGunterPaint.PaintMoveSize(RClient);
		  RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
		  SchemeView.FGunterPaint.PaintMoveSize(RClient);
		  
		end;

      gmItemMove:begin

		  SchemeView.ParentScheme.DragCursor:=crSizeAll;
		  BeginDrag(False);
		end;

      gmContent:begin
                  if SchemeView.ContentOptions.MultiSelect then
		  if (Abs(MoveRec.NPoint.X-MoveRec.DownPoint.X)>5)
		    and (Abs(MoveRec.NPoint.Y-MoveRec.DownPoint.Y)>5) then
		  begin
		    MoveRec.MoveType:=gmSelect;
		    RClient:=MoveRec.ARect;
		    RClient.TopLeft := SchemeView.ClientToScreen(RClient.TopLeft);
		    RClient.BottomRight := SchemeView.ClientToScreen(RClient.BottomRight);
		    ClipCursor(@RClient);

		    if not (ssCtrl in Shift) then
		    begin
		      SchemeView.GetSchemeDataTree.ClearItemSelection;

		    end;

		    FFirstSelect:=True;
		  end;
		end;

      gmSelect: with SchemeView.FGunterPaint.Canvas,MoveRec do
		begin
		  
		  Canvas.Pen.Mode :=pmNot;
		  Canvas.Pen.Style := psDot;
		  Canvas.Brush.Style :=bsClear;
		  RClient:=Classes.Rect(MoveRec.DownPoint,MoveRec.OPoint);
		  if not FFirstSelect then
		    Canvas.Rectangle(RClient);
		    
		  RClient:=Classes.Rect(MoveRec.DownPoint,MoveRec.NPoint);
		  Canvas.Rectangle(RClient);
		  FFirstSelect:=False;
		end;

    end;

  end;

  MoveRec.MouseType:=mtMove;
  MoveRec.OPoint:=MoveRec.NPoint;

end;

procedure TMFGunterViewControl.AdjustScrollBar(ScrollBarKind:TScrollBarKind);
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

procedure TMFGunterViewControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  RClient,R:TRect;
  dEnd,dBegin:TDateTime;
  AViewHitInfo:TViewHitInfo;
  Accept:Boolean;
begin
  inherited;
  //if ssLeft in Shift then
  with SchemeView.FGunterPaint, FGunterCalculater do
  begin
    if MoveRec.MoveType in [gmItemLeft,gmItemRight,gmTreeSize] then
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
	gmItemLeft :begin
		     
		     dEnd:=MoveRec.AItem.BeginDate+MoveRec.AItem.IntervalDate;
		     if X>MoveRec.ARect.Right then X:=MoveRec.ARect.Right-5;
		     Accept:=True;
		     dBegin:=GetClientLeftToDateTime(X);

		     SchemeView.BeforItemTimeChange(MoveRec.AItem,tctBegin,dBegin,Accept);
		     if  Accept then
		     begin
		       MoveRec.AItem.BeginDate:= dBegin;
		       MoveRec.AItem.IntervalDate:= dEnd-MoveRec.AItem.BeginDate;
		       SchemeView.AfterItemTimeChange(MoveRec.AItem,tctBegin);
		     end;
		   end;
		   
	gmItemRight:begin
		      Accept:=True;
		      dEnd:= GetClientLeftToDateTime(RClient.Right)-MoveRec.AItem.BeginDate;
		      SchemeView.BeforItemTimeChange(MoveRec.AItem,tctInterval,dEnd,Accept);
		      if Accept then
		      begin
			MoveRec.AItem.IntervalDate :=dEnd;
			SchemeView.AfterItemTimeChange(MoveRec.AItem,tctInterval);
		      end;
		   end;
	gmTreeSize :begin
		     SchemeView.TreeOptions.Width:= RClient.Right-RClient.Left;
		     AdjustScrollBar(sbHorizontal);
		   end;
      end;


      {if UnionRect(R,RClient,MoveRec.ARect) then
	 RClient:=R;
      InflateRect(RClient,1,0) ; }
      SchemeView.Update;
      MoveRec.AItem:=nil;
      MoveRec.OPoint:=MoveRec.NPoint;
    end;
            
    if  (not Dragging)  then
    begin
      if MoveRec.MoveType in [gmSelect] then
      begin
	RClient:=Classes.Rect(MoveRec.DownPoint,MoveRec.NPoint);
	MultiSelect(not (ssCtrl in Shift),RClient);

	SchemeView.Update;
	ClipCursor(nil);
      end
      else
      begin

	AViewHitInfo:=GetHitInfo(MoveRec.DownPoint);
	if (AViewHitInfo.AItem=nil)
	and (AViewHitInfo.APaintClass.InheritsFrom(TMFContentPaint)) then
	begin
	   GetSchemeDataTree.ClearItemSelection();
	   Paint(AViewHitInfo.APaintClass);
	end;
      end;
    end;
    MoveRec.MouseType:=mtUp;
    MoveRec.MoveType:=gmNone;
  end;
  
end;

procedure TMFGunterViewControl.BeginDrag(Immediate: Boolean;
  Threshold: Integer);
begin
  DateTimeWindow:=TMFDateTimeWindow.Create(SchemeView);
  StartScrollTimer;

  SchemeView.ParentScheme.BeginDrag(Immediate,Threshold);
  //MoveRec.MoveType:=gmItemMove;
end;

function TMFGunterViewControl.Dragging: Boolean;
begin
  Result:= SchemeView.ParentScheme.Dragging;
end;

procedure TMFGunterViewControl.EndDrag(Drop: Boolean);
begin
  EndScrollTimer;
  SchemeView.ParentScheme.EndDrag(Drop);
  DateTimeWindow.Free;
end;

procedure TMFGunterViewControl.DragItemDrop(Source: TObject; X, Y: Integer);
var
  RClient:TRect; AViewHitInfo:TViewHitInfo;
  bAccept:Boolean; dInterval,dNow:TDateTime;
  OldNode:TMFSchemeDataTreeNode;
  J:Integer;
begin
  inherited;
  if not IsReadOnly then
  if (Source = SchemeView.ParentScheme) then
  with SchemeView,FGunterPaint.FGunterCalculater,GetSchemeDataTree do
  begin

    MoveRec.NPoint :=Point(X, Y);

    AViewHitInfo:=GetHitInfo(MoveRec.NPoint);
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
    SchemeView.FGunterPaint.PaintMoveSize(RClient);

    RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
    dNow:= GetClientLeftToDateTime(RClient.Left);
    dInterval := MoveRec.AItem.BeginDate-dNow;

    SchemeView.BeginUpdate;
    for J:=0  to SelectionItemCount-1 do
    begin
      bAccept:=True;
      SchemeView.BeforDragItemDown(Source,SelectionsItem[J],AViewHitInfo.ANode,bAccept,X,Y);

      if bAccept then
      begin
	SelectionsItem[J].BeginDate := SelectionsItem[J].BeginDate- dInterval;
        //bely zhou BUG  <-- Andyzhang 不是bug,只是OldNode为空表示没有更改父节点
	OldNode:=SelectionsItem[J].Parent;
	if  AViewHitInfo.ANode<>nil then
	if  AViewHitInfo.ANode<>SelectionsItem[J].Parent then
	begin

	  SelectionsItem[J].MoveTo(AViewHitInfo.ANode);

	end;

	SchemeView.AfterDragItemDown(Source,SelectionsItem[J],OldNode,bAccept,X,Y);
      end;

    end;

    Self.AdjustDragDrop(AViewHitInfo);

    MoveRec.OPoint:= MoveRec.NPoint;
    MoveRec.MoveType:=gmNone;
    EndDrag(True);
    SchemeView.EndUpdate;
  end;
end;

procedure TMFGunterViewControl.DragItemOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  RClient:TRect;
  ADateTime:TDateTime;
  AViewHitInfo:TViewHitInfo;
  AHintRec:THintRec;
begin
  inherited;
  Accept:=False;
  if not IsReadOnly then
  With SchemeView,SchemeView.FGunterPaint.FGunterCalculater,ParentScheme do
  begin
    AViewHitInfo:=GetHitInfo(Point(X,Y));

    if Source = SchemeView.ParentScheme then
    begin
      Accept:=True;

      SchemeView.DragItemOver(SchemeView,MoveRec.AItem,AViewHitInfo.ANode,Accept,X,Y);
      if Accept then
      begin

	MoveRec.NPoint:=Point(X,Y);

	if MoveRec.MoveType=gmItemMove then
	begin
	  RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
	  SchemeView.FGunterPaint.PaintMoveSize(RClient);
	end;

	MoveRec.MoveType:=gmItemMove;

	RClient:=Calc(MoveRec.ARect,MoveRec.NPoint);
	SchemeView.FGunterPaint.PaintMoveSize(RClient);

	if ContentOptions.ShowDragHint then
	begin
	  ADateTime:= GetClientLeftToDateTime(RClient.Left);
	  DateTimeWindow.Caption:= GetDragHintCaption(ADateTime);
	  RClient:= GetDragHintRect(RClient);
	  AHintRec.Font:=DateTimeWindow.Font;
	  AHintRec.Color :=DateTimeWindow.Color;
	  AHintRec.HintType :=htText;
	  AHintRec.HintStr  := DateTimeWindow.Caption;
	  SchemeView.DragHint(SchemeView,ADateTime,MoveRec.AItem,
	    AViewHitInfo,AHintRec,RClient,DateTimeWindow.GetHintCanvas);
	  DateTimeWindow.HintType:=AHintRec.HintType;
	  DateTimeWindow.Caption:=AHintRec.HintStr;
	  //DateTimeWindow.Font.Assign(AHintRec.Font);
	  DateTimeWindow.Color :=AHintRec.Color;
	  DateTimeWindow.Activate(RClient);
	end;

	MoveRec.OPoint:=MoveRec.NPoint;
      end;

    end
    else
    begin
      Accept:=False;
      SchemeView.DragItemOver(Source,MoveRec.AItem,AViewHitInfo.ANode,Accept,X,Y);

    end;
  end;
end;

procedure TMFGunterViewControl.DragCanceled;
var RClient:TRect;
begin
  with SchemeView.FGunterPaint.FGunterCalculater do
  begin
    RClient:=Calc(MoveRec.ARect,MoveRec.OPoint);
    SchemeView.FGunterPaint.PaintMoveSize(RClient);
    MoveRec.MoveType:=gmNone;
    EndScrollTimer;
    EndDrag(False);
  end;
end;

procedure TMFGunterViewControl.EndScrollTimer;
begin
  if FTimerID <> 0 then
    KillTimer(SchemeView.ParentScheme.Handle, FTimerID);
  FTimerID:=0;  
end;

procedure TMFGunterViewControl.StartScrollTimer;
begin
  if FTimerID = 0 then
    FTimerID:= SetTimer(SchemeView.ParentScheme.Handle, 1, 200, nil);
end;

procedure TMFGunterViewControl.ScorllMessage(hwnd:HWND;Msg:Cardinal;wParam,lParam:Integer);
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
	MoveRec.MoveType:=gmNone;
      end
      else
       if  VertScrollBar.Position<>0 then
       begin
	 VertScrollBar.Position:= 0;
	 MoveRec.MoveType:=gmNone;
       end;
    end;
    if wParam= SB_LINEDOWN then
    begin
      Position:=Position+50;
      MaxLength:= GetWholeHeight-GetClientRect.Bottom;
      if Position<=MaxLength then
      begin
	VertScrollBar.Position:= Position;
	MoveRec.MoveType:=gmNone;
      end
      else
	if  VertScrollBar.Position<>MaxLength then
	begin
	  VertScrollBar.Position:= MaxLength;
	  MoveRec.MoveType:=gmNone;
	end;
     end;

    {if (wParam= SB_LINEUP) and (VertScrollBar.Position<>0) then
   begin
     SendMessage(hwnd, Msg,wParam,lParam);
     MoveRec.MoveType:=gmNone;
   end;
   if (wParam= SB_LINEDOWN)and (VertScrollBar.Position<>GetWholeHeight) then
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
	MoveRec.MoveType:=gmNone;
      end
      else
	if  HorzScrollBar.Position<>0 then
	begin
	  HorzScrollBar.Position:= 0;
	  MoveRec.MoveType:=gmNone;
	end;
    end;

    if wParam= SB_LINEDOWN then
    begin
      Position:=Position+50;
      MaxLength:= GetWholeWidth-GetClientRect.Right;
      if Position<=MaxLength then
      begin
	HorzScrollBar.Position:= Position;
	MoveRec.MoveType:=gmNone;
      end
      else
	if  HorzScrollBar.Position<>MaxLength then
	begin
	  HorzScrollBar.Position:= MaxLength;
	  MoveRec.MoveType:=gmNone;
	end;
    end;

  end;

end;

procedure TMFGunterViewControl.DoScrollTimer;
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

procedure TMFGunterViewControl.TreeChanged(AEventType: TEventType;
  AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin
  inherited;
  if SchemeView.IsNotifyChange then
  begin
    case AEventType of
      eNode: begin
	       SchemeView.Update;
	     end;
      eItem:begin
	      SchemeView.Invalidate;

	    end;
      eItemLink:begin SchemeView.Invalidate; end;

    end;

  end;
end;

procedure TMFGunterViewControl.SetCursor(var Message:TWMSetCursor);
var
  APoint: TPoint;
  AViewHitInfo:TViewHitInfo;
begin
  inherited;
  with SchemeView do
  if not (csDesigning in ComponentState) then
  begin
    GetCursorPos(APoint);
    AViewHitInfo:=FGunterPaint.FGunterCalculater.GetHitInfo(ScreenToClient(APoint));
    case AViewHitInfo.AHitType of
      pItemLeft,pItemRight:
	begin
          Message.Result := 1;
          if not IsReadOnly then
            Windows.SetCursor(Screen.Cursors[crSizeWE])
          else
            Windows.SetCursor(Screen.Cursors[crDefault]);
	end;

      pTreeRight:
	begin
	  Message.Result := 1;
	  Windows.SetCursor(Screen.Cursors[crHSplit])
	end;

      PNone:
	begin
	  Message.Result := 1;
	  Windows.SetCursor(Screen.Cursors[crDefault]);
	end;
    end;
  end;
end;


procedure TMFGunterViewControl.DragDropNear(
  NewNode: TMFSchemeDataTreeNode; DragItem: TMFSchemeDataItem;
  var R: TRect);
var
  Space,iOldLeft,iNewLeft:Integer;
  NearDateTime,DragDateTime:TDateTime;
begin
  with SchemeView.FGunterPaint.FGunterCalculater do
  begin
    Space:=SchemeView.ContentOptions.AutoFetchSpace;
    DragDateTime:= GetClientLeftToDateTime(R.Left);
    NearDateTime:= DragDateTime;
    
    SchemeView.DragDropNear(NewNode,DragItem,Space,
      NearDateTime,DragDateTime,MoveRec.NPoint.X,MoveRec.NPoint.Y);
    if NearDateTime<> DragDateTime then
    begin
      iNewLeft:= GetDateTimeToClientLeft(NearDateTime);
      iOldLeft:= GetDateTimeToClientLeft(DragDateTime);
      
      if Abs(iNewLeft -iOldLeft)<=Space  then
      begin
	OffsetRect(R,iNewLeft -iOldLeft,0);
      end;

    end;
  end;
end;

procedure TMFGunterViewControl.AdjustDragDrop(AViewHitInfo: TViewHitInfo);
var
  AdjustMoveType: TAdjustMoveType;
  StartDataItem,EndDataItem:TMFSchemeDataItem;
begin
  if AViewHitInfo.AItem<>nil then
  begin
    EndDataItem :=  AViewHitInfo.AItem;
    StartDataItem := AViewHitInfo.AItem.PrevDataItem;
  
    AdjustMoveType:=amtDefault;
    SchemeView.AdjustDragDrop(AViewHitInfo.ANode,AdjustMoveType,
      StartDataItem,EndDataItem);

    AViewHitInfo.ANode.AdjustItemDateTime(StartDataItem, EndDataItem,AdjustMoveType);
  end;
end;

procedure TMFGunterViewControl.ScrolltoDateTime(ADateTime: TDateTime;Percent:Integer=30);
var
  iLeft,iWidth,I:Integer;
  RClient:TRect;
begin
  with SchemeView.FGunterPaint.FGunterCalculater,SchemeView.ParentScheme.HorzScrollBar do
  begin
    iLeft := GetDateTimeToRelativeLeft(ADateTime);
    RClient:=GetPaintClass(TMFContentPaint).GetClientRect;
    iWidth:=Trunc((RClient.Right- RClient.Left)*Percent/100);
    I:=iLeft-iWidth;

    if I<0 then I:=0;
    if I>SchemeView.GetWholeWidth then I:=SchemeView.GetWholeWidth;

    Position:= i;

  end;
end;

procedure TMFGunterViewControl.ScrolltoNode(Node: TMFSchemeDataTreeNode;
  Percent: Integer);
var
  iTop,iHeight,I:Integer;
  P:TPoint;
  RClient:TRect;
begin
  if Node<>nil then
  with SchemeView.FGunterPaint.FGunterCalculater,
    SchemeView.ParentScheme.VertScrollBar do
  begin
    P:=SchemeView.GetOffSetPoint;

    RClient:=GetPaintClass(TMFSchemeTreePaint).GetClientRect;
    iTop :=Node.GetNodeRect.Top+P.Y-RClient.Top;
    //SchemeView.GetSchemeDataTree.LastVisibleNode
    iHeight:=Trunc((RClient.Bottom- RClient.Top)*Percent/100);
    I:=iTop-iHeight;

    if I<0 then I:=0;
    
    if I>SchemeView.GetWholeHeight then
      I:=SchemeView.GetWholeHeight;

    Position:= i;

  end;
end;


procedure TMFGunterViewControl.HintShow(var Message: TCMHintShow);
var
  HintDataRec:^TMFHintDataRec;
  AViewHitInfo:TViewHitInfo;
  RClient:TRect;
  bNeedShow:Boolean;
  ADate:TDateTime;
begin
  with Message.HintInfo^,SchemeView.FGunterPaint.FGunterCalculater do
  begin
    HintWindowClass:= TMFHintWindow;
    HintStr:='xx';
    HideTimeout:=-1;
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
	    if bNeedShow or (ANode.Hint <> '') then
	    begin
	      HintStr:=ANode.Caption;
	      CursorRect:=RClient;
	      Message.Result:=0;
	    end;

	end;

	if AItem<>nil then
	if APaintClass.InheritsFrom(TMFContentPaint) then
	begin
	  RClient:=AItem.GetItemClientRect;
	  CursorRect:=RClient;
	  HintStr:=AItem.Text; 
	  Message.Result:=0;
	end;

	if APaintClass.InheritsFrom(TMFHeadPaint) then
	if ASubClass<>nil then
	begin
	  CursorRect:=GetTimeHeadItemUnitRect(APoint,TMFTimeHeadItem(ASubClass));
	  HideTimeout:=3000;
	  ADate:=GetClientLeftToDateTime(APoint.X);
	  HintStr:='公历: '+ FormatDateTime('YY-mm-dd', ADate)+
	  ' 农历: '+GregDateToCNStr(ADate);
	  Message.Result:=0;
	end;

      end;

    end
    else
      Message.Result:=1;
  end;
end;

procedure TMFGunterViewControl.SetHintData(Sender: TObject; AViewHitInfo:TViewHitInfo;
  var HintRec:THintRec; var R: TRect; ACanvas: TCanvas);
begin
  with AViewHitInfo do
  begin
    HintRec.HintType := htImage;
    R:=Rect(0,0,100,100);
    
    if  APaintClass.InheritsFrom(TMFSchemeTreePaint) then
    begin
      HintRec.HintType := htText;
      //HintRec.Font.Color:=clSkyBlue;
      HintRec.Color:=clInfoBk;
    end;

    if APaintClass.InheritsFrom(TMFHeadPaint) and (ASubClass<>nil) then
    begin
      HintRec.HintType := htText;
      //HintRec.Font.Color:=clSkyBlue;
      HintRec.Color:=clInfoBk;
    end;

    if AItem<>nil then
    begin
      HintRec.HintType := htText;
      //HintRec.Font.Color:=clSkyBlue;
      HintRec.Color:=clInfoBk;
    end;

    SchemeView.SetHintData(Self,AViewHitInfo,HintRec,R,ACanvas);
  end;

end;

function TMFGunterViewControl.GetDragHintRect(R: TRect): TRect;
var
  Y,X:Integer; P:TPoint;
  Height,Width :Integer;
  RClient:TRect;
begin

  RClient := Rect(0, 0, 150, 0);
  DrawText(DateTimeWindow.Canvas.Handle, PChar(DateTimeWindow.Caption), -1, RClient, DT_CALCRECT or DT_LEFT or
    DT_WORDBREAK or DT_NOPREFIX or DateTimeWindow.DrawTextBiDiModeFlagsReadingOnly);

  Inc(RClient.Right, 6);
  Inc(RClient.Bottom, 2);
  Width:=RClient.Right;
  Height:= RClient.Bottom;
  X:= MoveRec.DownPoint.X-10-Width;
  Y:= MoveRec.ARect.Top-10-Height;
  P:= SchemeView.ClientToScreen(Point(X,Y));

  if (P.Y<0) then
  begin
    P.Y:=P.Y+10+Height+(R.Bottom-R.Top)+10;
  end;
  Result:=Rect(P.X,P.Y,P.X+Width,P.Y+Height );

end;

function TMFGunterViewControl.GetDragHintCaption(
  ADateTime: TDateTime): String;
begin

  Result:='开始时间:'+FormatDateTime('yy-mm-dd ',ADateTime)+#13+
	  '结束时间:'+FormatDateTime('yy-mm-dd ',ADateTime+MoveRec.AItem.IntervalDate)  ;
end;

procedure TMFGunterViewControl.DblClick;
var P:TPoint;AViewHitInfo:TViewHitInfo;R:TRect;
begin
  inherited;
  if GetCursorPos(P) then
  begin
    P:=SchemeView.ScreenToClient(P);
    AViewHitInfo:=SchemeView.FGunterPaint.FGunterCalculater.GetHitInfo(P);
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

procedure TMFGunterViewControl.MultiSelect(ResetOldSelected: Boolean;
  SelectRect: TRect);

  function AdjustRect(R: TRect):TRect;
  var I:integer;
  begin
    if R.Left>R.Right then
    begin
      I:=R.Left;
      R.Left:=R.Right;
      R.Right:=I;
    end;

    if R.Top>R.Bottom then
    begin
      I:=R.Top;
      R.Top:=R.Bottom;
      R.Bottom:=I;
    end;
    Result:=R;
  end;

var I:integer; RClient:TRect;
begin
  SchemeView.BeginUpdate;
  with SchemeView.GetSchemeDataTree do
  begin
    SelectRect:=AdjustRect(SelectRect);
    if ResetOldSelected then ClearItemSelection();
    for i:=0 to DataItemCount-1 do
    if windows.IntersectRect(RClient,DataItems[i].GetItemClientRect,SelectRect) then
    begin
      DataItems[i].Selected:=True;
    end;
  end;
  SchemeView.CancelUpdate;
end;

procedure TMFGunterViewControl.DragOtherDrop(Source: TObject; X,
  Y: Integer);
var AViewHitInfo:TViewHitInfo;
begin
  inherited;
  with SchemeView,FGunterPaint.FGunterCalculater do
  begin
    AViewHitInfo:=GetHitInfo(Point(X, Y));
    SchemeView.DragOtherDrop(Source,AViewHitInfo,X,Y);
  end;
end;

procedure TMFGunterViewControl.DragOtherOver(Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var AViewHitInfo:TViewHitInfo;
begin
  inherited;
  with SchemeView,FGunterPaint.FGunterCalculater do
  begin
    SchemeView.FGunterViewControl.DoScrollTimer;
    AViewHitInfo:=GetHitInfo(Point(X, Y));
    SchemeView.DragOtherOver(Source,AViewHitInfo,Accept,X,Y);
  end;
end;

procedure TMFGunterViewControl.HScrollPage(Direction: Boolean);
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

procedure TMFGunterViewControl.VScrollPage(Direction: Boolean);
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

function TMFGunterViewControl.CanNodeKeyDown: Boolean;
begin
  with SchemeView,SchemeView.GetSchemeDataTree do
  if GetSchemeDataTree<>nil then
    if Selected<>nil then
      Result:=True
    else
      Result:=False;
end;

procedure TMFGunterViewControl.ScrolltoItem(AItem: TMFSchemeDataItem);
begin
  ScrolltoNode(AItem.Parent);
  ScrolltoDateTime(AItem.BeginDate,30);
end;

function TMFGunterViewControl.GetHintStr(
  AViewHitInfo: TViewHitInfo): String;
var ADate:TDateTime;
begin
  with AViewHitInfo,SchemeView.FGunterPaint.FGunterCalculater do
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

      if APaintClass.InheritsFrom(TMFHeadPaint) then
      if ASubClass<>nil then
      begin
        ADate:= GetClientLeftToDateTime(APoint.X);
        Result:='公历: '+ FormatDateTime('YY-mm-dd', ADate)+
        ' 农历: '+GregDateToCNStr(ADate);
      end;

    end;

  end;
  //Result:=SchemeView.GetHintStr(AViewHitInfo);
end;

function TMFGunterViewControl.CheckItemCanChange(
  AViewHitInfo: TViewHitInfo): Boolean;
begin
  Result:= ((not IsReadOnly) and (AViewHitInfo.AItem<>nil)
    and AViewHitInfo.AItem.Enabled
    and not AViewHitInfo.AItem.ReadOnly){bely BUG} {Andyzhang 呵呵,忘记测试Item的ReadOnly}
end;

{ TMFHourforDayItem }

procedure TMFHourforDayItem.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFHourforDayItem then
  begin
    FVisible:=TMFHourforDayItem(Source).Visible;
    FWorkTimeBegin:=TMFHourforDayItem(Source).WorkTimeBegin;
    FWorkTimeEnd:=TMFHourforDayItem(Source).WorkTimeEnd;
  end;
end;

procedure TMFHourforDayItem.Change;
begin
  TMFBaseSchemeView(Collection.Owner).Invalidate;
end;

function TMFHourforDayItem.CheckInputTime(Value: String): Boolean;
var I:integer;
begin
  Result:=True;
  for I:=1 to Length(Value) do
  if not( Value[i] in ['0'..'9',':']) then
  begin
    Result:=False;
    Break;
  end;
end;

constructor TMFHourforDayItem.Create(Collection: TCollection);
begin
  inherited;
  FVisible := True;
  FWorkTimeBegin:='8:30';
  FWorkTimeEnd:='17:30';
  FColor:= clWhite;
end;

destructor TMFHourforDayItem.Destroy;
begin

  inherited;
end;

function TMFHourforDayItem.GetALLEndMinute: Integer;
begin
  Result:=GetEndHour *60 +GetEndMinute;
end;

function TMFHourforDayItem.GetALLStartMinute: Integer;
begin
  Result:=GetStartHour *60 +GetStartMinute;
end;

function TMFHourforDayItem.GetDisplayName: string;
begin
  Result := 'Item- '+FWorkTimeBegin+'~'+FWorkTimeEnd;
end;

function TMFHourforDayItem.GetEndHour: Integer;
begin
  Result:=GetHour(FWorkTimeEnd);
end;

function TMFHourforDayItem.GetEndMinute: Integer;
begin
  Result:=GetMinute(FWorkTimeEnd);
end;

function TMFHourforDayItem.GetHour(AValue: String): Integer;
var I:Integer;S:string;
begin
  I:=Pos(':',AValue);
  
  if I>0 then
    S:=LeftStr(AValue,I-1)
  else
    S:=AValue;
  Result:=StrToIntDef(S,0);
end;

function TMFHourforDayItem.GetMinute(AValue: String): Integer;
var I:Integer;S:string;
begin
  I:=Pos(':',AValue);
  
  if I>0 then
    S:=RightStr(AValue,Length(AValue)-I);

  Result:=StrToIntDef(S,0);
end;

function TMFHourforDayItem.GetStartHour: Integer;
begin
  Result:=GetHour(FWorkTimeBegin);
end;

function TMFHourforDayItem.GetStartMinute: Integer;
begin
  Result:=GetMinute(FWorkTimeBegin);
end;

procedure TMFHourforDayItem.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Change;
  end;
end;

procedure TMFHourforDayItem.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible := Value;
    Change
  end;  
end;

procedure TMFHourforDayItem.SetWorkTimeBegin(const Value: String);
begin
  if FWorkTimeBegin <> Value then
  begin
    //FWorkTimeBegin := Value;
    if CheckInputTime(Value) then
    begin
      FWorkTimeBegin := Value;
      Change;
    end
    else
      Application.MessageBox('错误的时间格式!','错误',MB_OK+MB_IconError);

  end;
end;

procedure TMFHourforDayItem.SetWorkTimeEnd(const Value: String);
begin
  if  FWorkTimeEnd <> Value  then
  begin
    //FWorkTimeEnd := Value;
    if CheckInputTime(Value) then
    begin
      FWorkTimeEnd := Value;
      Change;
    end
    else
      Application.MessageBox('错误的时间格式!','错误',MB_OK+MB_IconError);

  end;
end;

{ TMFHourforDays }

function TMFHourforDays.Add: TMFHourforDayItem;
begin
  Result:= TMFHourforDayItem(inherited Add);
end;

function TMFHourforDays.GetItem(Index: Integer): TMFHourforDayItem;
begin
  Result:= TMFHourforDayItem(inherited GetItem(Index) );
end;

function TMFHourforDays.GetView: TMFGunterSchemeView;
begin
  Result := TMFGunterSchemeView(Owner);
end;

procedure TMFHourforDays.SetItem(Index: Integer;
  const Value: TMFHourforDayItem);
begin
  inherited SetItem(Index,Value);
end;

initialization
  RegisteredViews.Register(TMFGunterSchemeView,'GunterSchemeView');
finalization
  RegisteredViews.Unregister(TMFGunterSchemeView);
end.

