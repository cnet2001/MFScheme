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
	     4) 实现智能化的排程算法

	-2005-1-7  编写  TGraphScrollBar  类
	-2005-1-10 完成  TGraphScrollBar  类
	-2005-1-20 编写  TPlanCrockCenter 类 排程界面实现类
	-2005-2-8  完成  TPlanCrockCenter 类
	-2005-2-9  编写  TMFMacList,TMFCard 排程控制类
	声明:本工程代码都是自己实现的没有其他任何第三方组件和代码
	
重构:   -2006-6-10     重构类 以及 类关系
	目的 1) 实现卡片式，干特图式等 风格
	     3) 一份数据2种以上视图
	     4) 实现智能化的排程算法

	-2006-6-11  搬移  TGraphScrollBar     滚动条控制类
	-2006-6-12  编写  TMFBaseScheme      容器类
	-2006-6-15  编写  TMFBaseSchemeView  界面视图类
	-2006-6-16  编写  TMFSchemeTree,TMFSchemeTreeNode    基础树控制类
	-2006-6-22  编写  TMFSchemeDataTree,TMFSchemeDataTreeNode 数据树控制类
	-2006-6-23  编写  TMFSchemeDataItem   数据容器类
	-2006-7-16  编写  TMFSchemeDataItemLinks TMFSchemeDataItemLink 关系

ToDo:

*******************************************************************************}
unit MFBaseScheme;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls,ImgList,StrUtils,
  StdCtrls,Forms,ExtCtrls,Graphics,Dialogs ,CommCtrl,ComCtrls,DateUtils,
  MFPaint,Variants,Math,Contnrs,MFBaseSchemeCommon;

type

  TMFBaseScheme=class;
  TMFSchemeTree =class;
  TMFSchemeDataItem =class;
  TMFSchemeTreeNode= class;
  TMFSchemeDataTreeNode= class;
  TMFFootOptions=class;
  TMFHeadOptions=class;
  TMFIndicaterOptions=class;
  TMFTreeOptions=class;
  TMFContentOptions=class;
  TMFSchemeDataItemLinks=class;
  TMFSchemeDataItemLink=class;
  TMFSchemeTreeNodeClass=class of TMFSchemeTreeNode;
  TMFBaseSchemePaintClass = class of TMFBaseSchemePaint;
  TMFBaseSchemePaint=class;
  EMFSchemeTree = class(Exception);
  TMFBaseSchemeView=class;

  TViewHitInfo = record
    APoint: TPoint;
    AColumn: Integer;
    ANode: TMFSchemeDataTreeNode;
    AItem: TMFSchemeDataItem;
    AHitType:TMFHitType;
    APaintClass: TMFBaseSchemePaint;
    ASubClass: TObject;
  end;

  THintRec = record
    HintType: THintType;
    Font : TFont;
    Color: TColor;
    HintStr:string;
  end;

  THintDataEvent=procedure(Sender:TObject;AViewHitInfo:TViewHitInfo;
    var HintRec:THintRec;var R:TRect; ACanvas: TCanvas) of object;

  TMFHintDataRec=record
    HintDataEvent: THintDataEvent;
    AViewHitInfo:TViewHitInfo;
  end;
  
  TAdjustDragDropEvent = procedure(NewNode:TMFSchemeDataTreeNode;
    var AdjustMoveType:TAdjustMoveType;StartDataItem:TMFSchemeDataItem=Nil;
      EndDataItem:TMFSchemeDataItem=Nil) of object;

  TDblClickViewEvent=procedure(Sender:TObject;AViewHitInfo:TViewHitInfo)of object;

  TDragHintEvent=procedure(Sender:TObject;ADateTime:TDateTime;AItem:TMFSchemeDataItem;AViewHitInfo:TViewHitInfo;
    var HintRec:THintRec;var ARect:TRect; ACanvas: TCanvas)of object;

  TItemSelectChangeEvent = procedure(Sender: TObject;Item:TMFSchemeDataItem;
    var AllowChange:Boolean) of object;

  TItemDragOtherDropEvent = procedure(Source: TObject;AViewHitInfo:TViewHitInfo;
    X,Y:Integer) of object;

  TItemDragOtherOverEvent = procedure(Source: TObject;AViewHitInfo:TViewHitInfo;
    var Accept:Boolean;X,Y:Integer) of object;

  TItemDownEvent = procedure(Source: TObject;DragItem:TMFSchemeDataItem;
    NewNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer) of object;

  TItemUpEvent = procedure(Source: TObject;DragItem:TMFSchemeDataItem;
    OldNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer) of object;

  TItemOverEvent = procedure(Source: TObject;DragItem:TMFSchemeDataItem;
    NewNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer) of object;

  TNodeHeightEvent = procedure(ANode: TMFSchemeTreeNode; var NodeHeight: Integer) of object;

  TPaintItemEvent=procedure(Sender:TObject;Item:TMFSchemeDataItem;ACanvas:TCanvas;R:TRect) of object;

  TDragDropNearEvent=procedure(NewNode:TMFSchemeDataTreeNode;
    DragItem:TMFSchemeDataItem;var Space:Integer;
    var NearDateTime:TDateTime;DragDateTime: TDateTime;X,Y:Integer) of object ;

  TBeforItemTimeChangeEvent =procedure (DataItem:TMFSchemeDataItem;
    ItemTimeChangeType:TItemTimeChangeType;var NewTime:TDateTime;
    var Accept:Boolean) of object ;

  TAfterItemTimeChangeEvent=procedure(DataItem: TMFSchemeDataItem;
      ItemTimeChangeType: TItemTimeChangeType)of object ;

  IZcTreeListener = interface
    ['{61309F60-AB27-4E38-BED1-B5CD619A542B}']
    procedure OnTreeChanged(Sender: TMFSchemeTree; AEvent: TMFSchemeTreeNotify; AIndex, ACount, AFlag: Integer);
  end;

  IZcTreeChanger = interface
    ['{EB3F2C53-B9DF-4B7C-9370-86FD871E5FFD}']
    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);
    procedure ItemSelectChanged(BeforeChange,Value:Boolean;AItem:TMFSchemeDataItem;
      var Accept:Boolean);
    function GetDataTreeClientRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;
    function GetOffSetPoint:TPoint;
  end;

  TZcTreeListenerManager = class(TObject)
  private
    // 事件监听者列表
    FExcludeListener: IZcTreeListener;
    FList: TInterfaceList;
    procedure TreeChanged(Sender: TMFSchemeTree; AEvent: TMFSchemeTreeNotify; AIndex, ACount, AFlag: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AListener: IZcTreeListener);
    procedure Remove(AListener: IZcTreeListener);
  end;

  TGraphScrollBar = class(TPersistent)
  private
    fOwner: TMFBaseScheme;
    fIncrement: TScrollBarInc;
    fPageIncrement: TScrollbarInc;
    fPosition: Integer;
    fRange: Integer;
    fCalcRange: Integer;
    fKind: TScrollBarKind;
    fMargin: Word;
    fVisible: Boolean;
    fTracking: Boolean;
    fSmooth: Boolean;
    fDelay: Integer;
    fButtonSize: Integer;
    fColor: TColor;
    fParentColor: Boolean;
    fSize: Integer;
    fStyle: TScrollBarStyle;
    fThumbSize: Integer;
    fPageDiv: Integer;
    fLineDiv: Integer;
    fUpdateNeeded: Boolean;
    FIsInitFlatScrollBar:Boolean;
    constructor Create(AOwner: TMFBaseScheme; AKind: TScrollBarKind);
    procedure CalcAutoRange;
    function ControlSize(ControlSB, AssumeSB: Boolean): Integer;
    procedure DoSetRange(Value: Integer);
    function GetScrollPos: Integer;
    function NeedsScrollBarVisible: Boolean;
    function IsIncrementStored: Boolean;
    procedure ScrollMessage(var Msg: TWMScroll);
    procedure SetButtonSize(Value: Integer);
    procedure SetColor(Value: TColor);
    procedure SetParentColor(Value: Boolean);
    procedure SetPosition(Value: Integer);
    procedure SetSize(Value: Integer);
    procedure SetStyle(Value: TScrollBarStyle);
    procedure SetThumbSize(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure Update(ControlSB, AssumeSB: Boolean);
    function ScrollBarVisible(Code: Word): Boolean;overload;
  public
    procedure Assign(Source: TPersistent); override;
    procedure ChangeBiDiPosition;
    property Kind: TScrollBarKind read FKind;
    function IsScrollBarVisible: Boolean;
    function ScrollBarVisible: Boolean;overload;
    property ScrollPos: Integer read GetScrollPos;
    property Range: Integer read fRange;
    property Owner: TMFBaseScheme read fOwner;
  published
    property ButtonSize: Integer read fButtonSize write SetButtonSize default 0;
    property Color: TColor read fColor write SetColor default clBtnHighlight;
    property Increment: TScrollBarInc read fIncrement write FIncrement stored IsIncrementStored default 8;
    property Margin: Word read fMargin write fMargin default 0;
    property ParentColor: Boolean read fParentColor write SetParentColor default True;
    property Position: Integer read fPosition write SetPosition default 0;
    property Smooth: Boolean read fSmooth write FSmooth default True;
    property Size: Integer read fSize write SetSize default 0;
    property Style: TScrollBarStyle read fStyle write SetStyle default ssRegular;
    property ThumbSize: Integer read fThumbSize write SetThumbSize default 0;
    property Tracking: Boolean read fTracking write FTracking default True;
    property Visible: Boolean read fVisible write SetVisible default True;
  end;

  TMFBaseScheme = class(TCustomControl)
  private
    FHorzScrollBar: TGraphScrollBar;
    FVertScrollBar: TGraphScrollBar;
    UpdatingScrollBars:Boolean;
    FRealWidth: Integer;
    FRealHeight: Integer;
    FBorderStyle: TBorderStyle;
    procedure SetHorzScrollBar(const Value: TGraphScrollBar);
    procedure SetVertScrollBar(const Value: TGraphScrollBar);

    function GetRealLeft: Integer;
    function GetRealTop: Integer;
    procedure SetRealLeft(const Value: Integer);
    procedure SetRealTop(const Value: Integer);
    procedure SetBorderStyle(const Value: TBorderStyle);
  protected
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMScrollUpdate(var Message: TMessage); message WM_ScrollUpdate;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMCancelMode(var Message: TMessage); message CM_CANCELMODE;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    Procedure WMEraseBkGnd( Var Message: TWMEraseBkGnd ); message WM_ERASEBKGND;
    procedure AddChildComponent(AComponent: TComponent); virtual;
    procedure RemoveChildComponent(AComponent: TComponent); virtual;
    procedure InitAddChildComponent(AComponent: TComponent); virtual;
    function GetWholeHeight: Integer;virtual;
    function GetWholeWidth: Integer; virtual;
    procedure CreateWnd;override;
    procedure CreateParams(var Params: TCreateParams); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetNodeHeight(ANode:TMFSchemeTreeNode;var NodeHeight:Integer);virtual;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DragDrop(Source: TObject;X,Y: Integer);override;
    procedure AdjustScrollBar(ScrollBarKind: TScrollBarKind);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function InvalidateRect(RRect:TRect;bErase:Boolean=False):Boolean;
    function UpdateScrollBars:Boolean;
    function GetDrawRect:TRect;virtual;
    function IsScrollBarCreate:Boolean;
    function GetConfigureText:String;virtual;
    procedure SetConfigureText(Value:string);virtual;

    property Canvas;
    property DragCursor;
    property Color;
    property RealTop :Integer  read  GetRealTop  write  SetRealTop ;
    property RealLeft:Integer  read  GetRealLeft  write  SetRealLeft ;
    property WholeWidth:Integer  read  GetWholeWidth ;
    property WholeHeight:Integer read  GetWholeHeight ;
  published
    property HorzScrollBar: TGraphScrollBar read fHorzScrollBar write SetHorzScrollBar;
    property VertScrollBar: TGraphScrollBar read fVertScrollBar write SetVertScrollBar;
    property TabStop default True;
  end;

  TMFBaseSchemePaint = class(TInterfacedPersistent)
  private
    FScheme: TMFBaseScheme;
    FSchemeView:TMFBaseSchemeView;
    FVisible: Boolean;
    FPaintType: TPaintType;
    function GetCanvas: TDrawCanvas;
    function GetScheme: TMFBaseScheme;
    function GetLocalCanvas: TDrawCanvas;

  protected
    FDrawCanvas:TDrawCanvas;
    function GetActiveSchemeView: TMFBaseSchemeView;
  public
    constructor Create(AControl: TMFBaseSchemeView);virtual;
    destructor Destroy; override;
    procedure PaintRow(Node:TMFSchemeDataTreeNode;ACanvas:TCanvas;R,RealRect:TRect);virtual;
    procedure Paint; virtual;
    procedure ZcInvalidate(const R: TRect);  virtual;
    procedure WinInvalidate(const R: TRect);  virtual;
    procedure InitPaint; virtual;

    function GetVisible: Boolean;virtual;
    property PaintType:TPaintType read FPaintType write FPaintType;
    property LocalCanvas: TDrawCanvas read GetLocalCanvas;
    property Canvas: TDrawCanvas read GetCanvas;
    property Visible: Boolean read GetVisible;
    property Scheme: TMFBaseScheme read GetScheme;
    property SchemeView: TMFBaseSchemeView read GetActiveSchemeView;
  end;


  TMFSchemeTree=class(TInterfacedPersistent,IZcTreeListener)
  private
    FUpdateLock: Boolean;
    FMajorList: TList;
    FVirtualRoot: TMFSchemeTreeNode;
    FSelectList:TList;
    FAutoExpand: Boolean;
    FShowNotFindValueError: Boolean;
    FModified: Boolean;
    FListeners: TZcTreeListenerManager;
    FItemClass: TMFSchemeTreeNodeClass;
    FParent:TControl;
    function GetFirstNode: TMFSchemeTreeNode;
    function GetItem(I: Integer): TMFSchemeTreeNode;
    function GetIsUpdating: Boolean;
    function GetCount: Integer;
    procedure SetAutoExpand(const Value: Boolean);
    function GetItemClass: TMFSchemeTreeNodeClass;
    procedure SetShowNotFindValueError(const Value: Boolean);
    procedure SetModified(const Value: Boolean);
    function GetRootItemCount: Integer;
    function GetLastNode: TMFSchemeTreeNode;
    function GetRootItem(I: Integer): TMFSchemeTreeNode;
    function GetParent: TControl;
    function GetSelected: TMFSchemeTreeNode;
    function GetSelectionCount: Integer;
    function GetSelections(index: Integer): TMFSchemeTreeNode;
  protected
    function Get(AIndex: Integer): TMFSchemeTreeNode;
    function CreateItem: TMFSchemeTreeNode; virtual;
    procedure ResetMajorList;
    procedure Renumber(AFromIndex, AToIndex: Integer);
    procedure Error(const Msg: string);
    procedure ItemNotify(AEvent: TMFSchemeTreeNotify; AIndex, ACount: Integer; AFlag: Integer = 0); virtual;
    {IZcTreeListener}
    procedure OnTreeChanged(Sender: TMFSchemeTree; AEvent: TMFSchemeTreeNotify; AIndex, ACount, AFlag: Integer); virtual;

    property ItemClass: TMFSchemeTreeNodeClass read GetItemClass write FItemClass;
  public
    constructor Create(AControl:TControl);  virtual;
    constructor Create2(AControl:TControl;AItemClass: TMFSchemeTreeNodeClass); overload; virtual;
    procedure Assign(Source: TPersistent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    function  LastVisibleNode:TMFSchemeTreeNode;
    procedure Delete(I: Integer);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ItemSelectChanged(BeforeChange,Value:Boolean;AItem:TMFSchemeDataItem;
      var Accept:Boolean);
    procedure NotifyNodeChange(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);
    procedure SyncNotify;
    function AddNode(AParent: TMFSchemeTreeNode; AIndex: Integer = -1): TMFSchemeTreeNode;  overload;virtual;
    function AddNode(AParent: TMFSchemeTreeNode; ACaption:String;AHeight:Integer;AIndex: Integer = -1): TMFSchemeTreeNode; overload; virtual;
    function AddNodeObject(AParent: TMFSchemeTreeNode; ACaption:String;
      AHeight:Integer;Ptr: Pointer): TMFSchemeTreeNode;virtual;
    function GetTreeHeight(ANode:TMFSchemeTreeNode=nil):Integer;virtual;
    function FindItem(I: Integer): TMFSchemeTreeNode; overload;
    function FindItem(I: Integer; var AItem: TMFSchemeTreeNode): Boolean; overload;
    procedure CollapseAll;
    procedure ExpandAll;
    procedure ClearSelection(KeepPrimary: Boolean = False);virtual;
    property Parent:TControl read GetParent;
    property IsUpdating: Boolean read GetIsUpdating;
    property Items[I: Integer]: TMFSchemeTreeNode read GetItem; default;
    property Count: Integer read GetCount;
    property RootItemCount: Integer read GetRootItemCount;
    property RootItems[I: Integer]: TMFSchemeTreeNode read GetRootItem;
    property FirstNode: TMFSchemeTreeNode read GetFirstNode;
    property LastNode: TMFSchemeTreeNode read GetLastNode;
    property Listeners: TzcTreeListenerManager read FListeners;
    property AutoExpand: Boolean read FAutoExpand write SetAutoExpand;
    property ShowNotFindValueError: Boolean read FShowNotFindValueError write SetShowNotFindValueError;
    property Modified: Boolean read FModified write SetModified;
    property Selected:TMFSchemeTreeNode  read GetSelected;
    property Selections[index:Integer]:TMFSchemeTreeNode  read GetSelections;
    property SelectionCount:Integer  read GetSelectionCount;
  end;


  TMFSchemeTreeNode=class(TInterfacedPersistent)
  private
    FChildList: TList;
    FMajorIndex: Integer;
    FOwner: TMFSchemeTree;
    FParent: TMFSchemeTreeNode;
    FExpanded: Boolean;
    FVisible: Boolean;
    FData: Pointer;
    FCaption: string;
    FHeight: Integer;
    FHide: Boolean;
    FSelectedIndex: integer;
    FImageIndex: integer;
    FValues:TStringList;
    FNodeName: string;
    FHint: string;
    function GetChildNodes(AIndex: Integer): TMFSchemeTreeNode;
    function GetCount: Integer;
    function GetFirstChild: TMFSchemeTreeNode;
    function GetHasChildren: Boolean;
    function GetLastChild: TMFSchemeTreeNode;
    function GetLastPosterity: TMFSchemeTreeNode;
    function GetLevel: Integer;
    function GetMinorIndex: Integer;
    function GetNextNode: TMFSchemeTreeNode;
    function GetNextSibling: TMFSchemeTreeNode;
    function GetPosterityCount: Integer;
    function GetPrevNode: TMFSchemeTreeNode;
    function GetPrevSibling: TMFSchemeTreeNode;
    function SafeParent: TMFSchemeTreeNode;
    procedure SetLevel(const Value: Integer);
    function ChildList: TList;
    function GetFirstSibling: TMFSchemeTreeNode;
    function GetLastSibling: TMFSchemeTreeNode;
    procedure SetHeight(const Value: Integer);
    procedure SetSelected(const Value: Boolean);
    function GetSelected: Boolean;
    procedure SetCaption(const Value: string);
    procedure SetHide(const Value: Boolean);
    function GetHeight: Integer;
    procedure SetImageIndex(const Value: integer);
    procedure SetSelectedIndex(const Value: integer);
  protected
    function AddChild(I: Integer; ANode: TMFSchemeTreeNode): TMFSchemeTreeNode; overload;
    function GetChild(I: Integer): TMFSchemeTreeNode;
    function GetExpanded: Boolean; virtual;
    procedure SetExpanded(const Value: Boolean); virtual;
    function GetVisible: Boolean; virtual;
    procedure SetVisible(const Value: Boolean); virtual;
    function GetValues(const AName: string): string; virtual;
    procedure SetValues(const AName: string; const Value: string); virtual;
    function GetID: Integer; virtual; abstract;
    procedure SetID(const Value: Integer); virtual; abstract;
    property ID: Integer read GetID write SetID;
  public
    constructor Create(AOnwer: TMFSchemeTree); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function AddChild(I: Integer): TMFSchemeTreeNode; overload;
    function AddChild: TMFSchemeTreeNode; overload;
    function FindItem(I: Integer): TMFSchemeTreeNode;
    procedure Delete(AFree: Boolean = True); virtual;
    procedure DeleteChildren(AFree: Boolean = True); virtual;
    function UpLevel: Boolean; virtual;
    function DownLevel: Boolean; virtual;
    function UpMove: Boolean; virtual;
    function DownMove: Boolean; virtual;

    procedure MoveTo(Destination: TMFSchemeTreeNode; Mode: TNodeMoveType); virtual;
    function IsLastVisibleNode:Boolean;
    function CanUpLevel: Boolean; dynamic;
    function CanDownLevel: Boolean; dynamic;
    function CanUpMove: Boolean; dynamic;
    function CanDownMove: Boolean; dynamic;

    function Expand: Boolean;
    function Collapse: Boolean;
    function IsNotVisibleOrHide:Boolean;

    property Expanded: Boolean read GetExpanded write SetExpanded;
    property Visible: Boolean read GetVisible write SetVisible; 

    property Owner: TMFSchemeTree read FOwner;
    property Parent: TMFSchemeTreeNode read FParent;
    property AbsoluteIndex: Integer read FMajorIndex;
    property RelativeIndex: Integer read GetMinorIndex;
    property PrevSibling: TMFSchemeTreeNode read GetPrevSibling;
    property NextSibling: TMFSchemeTreeNode read GetNextSibling;
    property FirstSibling: TMFSchemeTreeNode read GetFirstSibling;
    property LastSibling: TMFSchemeTreeNode read GetLastSibling;
    property NextNode: TMFSchemeTreeNode read GetNextNode;
    property PrevNode: TMFSchemeTreeNode read GetPrevNode;
    property LastPosterity: TMFSchemeTreeNode read GetLastPosterity;
    property LastChild: TMFSchemeTreeNode read GetLastChild;
    property FirstChild: TMFSchemeTreeNode read GetFirstChild;
    property PosterityCount: Integer read GetPosterityCount;
    property Level: Integer read GetLevel write SetLevel;
    property ChildCount: Integer read GetCount;
    property ChildNodes[AIndex: Integer]: TMFSchemeTreeNode read GetChildNodes;
    property HasChildren: Boolean read GetHasChildren;

    property Values[const AName: string]: string read GetValues write SetValues;
    property Data: Pointer read FData write FData;
    property Caption: string read FCaption write SetCaption;
    property Height: Integer read GetHeight write SetHeight;
    property Selected: Boolean read GetSelected write SetSelected;
    property Hide:Boolean read FHide write SetHide;
    property ImageIndex:integer read FImageIndex write SetImageIndex;
    property SelectedIndex:integer read FSelectedIndex write SetSelectedIndex;
    property NodeName:string read FNodeName write FNodeName;
    property Hint: string read FHint write FHint; //bely 2008-04-07
  end;

  TMFSchemeDataTree=class(TMFSchemeTree)
  private
    FMajorDataItemList:TList;
    FSelectItemList:TList;
    FActiveDataItem: TMFSchemeDataItem;
    function GetDataItem(I: Integer): TMFSchemeDataItem;
    function GetDataItemCount: Integer;
    function GetSelectionItemCount: Integer;
    function GetSelectionsItem(index: Integer): TMFSchemeDataItem;
  protected
    FItemLinks:TMFSchemeDataItemLinks;
    FMaxNodeItemCount: Integer;
    function GetItem(I: Integer): TMFSchemeDataTreeNode;
  public
    constructor Create2(AControl:TControl;AItemClass: TMFSchemeTreeNodeClass); override;
    destructor Destroy; override;
    function AddNode(AParent: TMFSchemeDataTreeNode; AIndex: Integer = -1): TMFSchemeDataTreeNode; reintroduce;overload;
    function AddNode(AParent: TMFSchemeDataTreeNode; ACaption:String;
      AHeight:Integer;AIndex: Integer = -1): TMFSchemeDataTreeNode; reintroduce;overload;
    function AddNodeObject(AParent: TMFSchemeDataTreeNode; ACaption:String;
      AHeight:Integer;Ptr: Pointer): TMFSchemeDataTreeNode; reintroduce; virtual;
    function GetItemByItemName(Value:string):TMFSchemeDataItem;
    function GetNodeByNodeName(Value:string):TMFSchemeDataTreeNode;
    function FindDataItem(I: Integer): TMFSchemeDataItem; overload;
    function FindDataItem(I: Integer; var AItem: TMFSchemeDataItem): Boolean; overload;
    function GetTreeHeight(ANode:TMFSchemeDataTreeNode=nil):Integer; reintroduce;virtual;
    Procedure NotifyItemLink(ADataItem:TMFSchemeDataItem);
    Procedure ListMaxNodeItemCount;
    property DataItems[I: Integer]: TMFSchemeDataItem read GetDataItem; default;
    property DataItemCount: Integer read GetDataItemCount;
    property MaxNodeItemCount:Integer read FMaxNodeItemCount;
    property Items[I: Integer]: TMFSchemeDataTreeNode read GetItem;
    procedure ClearItemSelection(KeepPrimary: Boolean = False);virtual;
    procedure ClearItem;
    property SelectionsItem[index:Integer]:TMFSchemeDataItem  read GetSelectionsItem;
    property SelectionItemCount:Integer  read GetSelectionItemCount;
    property DataItemLinks:TMFSchemeDataItemLinks read FItemLinks;
    property ActiveDataItem: TMFSchemeDataItem read FActiveDataItem write FActiveDataItem;
  end;

  TMFSchemeDataTreeNode=class(TMFSchemeTreeNode)
  private
    FDataItemList:TList;
    function AddDataItem(I: Integer;
      ADataItem: TMFSchemeDataItem): TMFSchemeDataItem;overload;
    function GetDataItem(I: Integer): TMFSchemeDataItem;
    function GetDataItemCount: Integer;
    function GetDataItemList: TList;
  protected
    property DataItemList:TList read GetDataItemList;
    procedure DeleteSelectItem(I: Integer);
  public
    constructor Create(AOnwer: TMFSchemeDataTree);reintroduce;virtual;
    destructor Destroy; override;
    function GetNodeRect:TRect;virtual;
    procedure Refresh;
    procedure ClearItems;
    procedure AdjustItemIndex(StartDataItem:TMFSchemeDataItem=Nil;
      EndDataItem:TMFSchemeDataItem=Nil);
    procedure AdjustItemDateTime(StartDataItem:TMFSchemeDataItem=Nil;
      EndDataItem:TMFSchemeDataItem=Nil;AdjustMoveType:TAdjustMoveType=amtStand);

    function AddDataItem:TMFSchemeDataItem; overload;
    function AddDataItem(I: Integer):TMFSchemeDataItem; overload;
    Procedure DeleteDataItem(AItem:TMFSchemeDataItem);overload;
    procedure DeleteDataItem(I: Integer); overload;
    procedure DeleteDataItem;overload;
    property DataItems[I: Integer]: TMFSchemeDataItem read GetDataItem; default;
    property DataItemCount: Integer read GetDataItemCount;
  end;

  TWillFree= procedure of object;

  TMFSchemeDataItem=class(TInterfacedPersistent)
  private
    FUserData,FSysData:Pointer;
    FParent: TMFSchemeDataTreeNode;
    FVisible: Boolean;
    FPercent: Double;
    FIntervalDate: TDateTime;
    FBeginDate: TDateTime;
    FText: String;
    FModify: Boolean;
    FReadOnly: Boolean;
    FColor: TColor;
    FCaptionPosition: TCaptionPosition;
    FLeftShapeType: TMFSchemeShapeType;
    FRightShapeType: TMFSchemeShapeType;
    FEnabled: boolean;
    FValues:TStringList;
    FItemName: string;
    FHint :string;
    procedure SetVisible(const Value: Boolean);
    function GetSelected: Boolean;
    procedure SetSelected(const Value: Boolean);
    procedure SetBeginDate(const Value: TDateTime);
    procedure SetIntervalDate(const Value: TDateTime);
    procedure SetPercent(const Value: Double);
    function GetAbsoluteIndex: Integer;
    function GetRelativeIndex: Integer;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetText(const Value: String);
    function GetNextDataItem: TMFSchemeDataItem;
    function GetPrevDataItem: TMFSchemeDataItem;
    procedure SetColor(const Value: TColor);
    procedure SetCaptionPosition(const Value: TCaptionPosition);
    procedure SetLeftShapeType(const Value: TMFSchemeShapeType);
    procedure SetRightShapeType(const Value: TMFSchemeShapeType);
    function GetValues(const AName: string): string;
    procedure SetValues(const AName, Value: string);
  protected

  public
    constructor Create(Parent:TMFSchemeDataTreeNode);virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetItemClientRect:TRect;virtual;
    function GetOffSetPoint:TPoint;virtual;
    procedure Refresh;
    procedure AfterSelectChange;
    function CheckSelectChange(Value:Boolean):Boolean;
    property NextDataItem: TMFSchemeDataItem read GetNextDataItem;
    property PrevDataItem: TMFSchemeDataItem read GetPrevDataItem;
    function IsActiveDataItem:Boolean;
    function MoveTo(ADataItem:TMFSchemeDataItem;MoveType:TItemMoveType):Boolean; overload;
    function MoveTo(ADataTreeNode:TMFSchemeDataTreeNode;index:Integer=-1):Boolean; overload;
    property Parent:TMFSchemeDataTreeNode read FParent;
    property UserData:Pointer read FUserData write FUserData;
    property SysData:Pointer read FSysData write FSysData;
    property BeginDate:TDateTime read FBeginDate write SetBeginDate;
    property IntervalDate:TDateTime read FIntervalDate write SetIntervalDate;
    property Percent:Double read FPercent write SetPercent;
    property Text:String read FText write SetText;
    property Color:TColor read FColor write SetColor;
    property Visible:Boolean read FVisible write SetVisible;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property Selected: Boolean read GetSelected write SetSelected;
    property Values[const AName: string]: string read GetValues write SetValues;
    property Modify:Boolean read FModify write FModify;
    property AbsoluteIndex: Integer read GetAbsoluteIndex;
    property RelativeIndex: Integer read GetRelativeIndex;
    property CaptionPosition:TCaptionPosition read FCaptionPosition write SetCaptionPosition;
    property LeftShapeType: TMFSchemeShapeType read FLeftShapeType write SetLeftShapeType;
    property RightShapeType: TMFSchemeShapeType read FRightShapeType write SetRightShapeType;
    property Enabled:boolean read FEnabled write FEnabled;
    property ItemName:string read FItemName write FItemName;
    property Hint: string read FHint write FHint; //bely 2008-04-07
  end;

  TItemLinkArray=array of Integer;

  TMFSchemeDataItemLinks=class(TInterfacedPersistent)
  private
    function GetItem(Index: Integer): TMFSchemeDataItemLink;
    procedure SetItem(Index: Integer; const Value: TMFSchemeDataItemLink);
  protected
    FOwner:TMFSchemeDataTree;
    FList:TList;
  public
    constructor Create(Owner:TMFSchemeDataTree);virtual;
    destructor Destroy; override;
    function Add(PrevItem,NextItem:TMFSchemeDataItem):TMFSchemeDataItemLink;
    procedure Delete(Index:Integer;IsFree:Boolean=True);overload;
    procedure Delete(ADataItemLink:TMFSchemeDataItemLink;IsFree:Boolean=True);overload;
    procedure Clear;
    function FindItems(AItem:TMFSchemeDataItem):TItemLinkArray; overload;
    function FindItems(PrevItem,NextItem:TMFSchemeDataItem):TItemLinkArray;overload;
    function FindPrevItems(PrevItem:TMFSchemeDataItem):TItemLinkArray;
    function FindNextItems(NextItem:TMFSchemeDataItem):TItemLinkArray;
    function Count:Integer;
    property Items[Index:Integer]:TMFSchemeDataItemLink read GetItem write SetItem;
  end;

  TLinkPath=array of TPoint;

  TMFSchemeDataItemLink=class(TInterfacedPersistent)
  private
    FRPrev,FRNext:TRect;
    FNextLinkDataItem: TMFSchemeDataItem;
    FPrevLinkDataItem: TMFSchemeDataItem;
    procedure SetNextLinkDataItem(const Value: TMFSchemeDataItem);
    procedure SetPrevLinkDataItem(const Value: TMFSchemeDataItem);
  protected
    FLinkPath:TLinkPath;
    FOwner:TMFSchemeDataItemLinks;
    function NeedCalcPath:Boolean;
  public
    constructor Create(Owner:TMFSchemeDataItemLinks);virtual;
    destructor Destroy; override;
    procedure CalcPath;
    function PassPath(ARect:TRect;var bLastPoint:Boolean):TLinkPath;
    property LinkPath:TLinkPath read FLinkPath;
    property PrevLinkDataItem:TMFSchemeDataItem read FPrevLinkDataItem write SetPrevLinkDataItem;
    property NextLinkDataItem:TMFSchemeDataItem read FNextLinkDataItem write SetNextLinkDataItem;
  end;

  TMFBaseSchemeView=class(TComponent)
  private
    FTabStop: Boolean;
    FVisible: Boolean;

    FFootOptions: TMFFootOptions;
    FHeadOptions: TMFHeadOptions;
    FIndicaterOptions: TMFIndicaterOptions;
    FTreeOptions: TMFTreeOptions;
    //FContentOptions: TMFContentOptions;
    FNotifyChange:Boolean;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnDragDrop: TDragDropEvent;
    FOnDragOver: TDragOverEvent;
    FOnEndDrag: TEndDragEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnKeyUp: TKeyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseWheel: TMouseWheelEvent;
    FOnMouseWheelDown: TMouseWheelUpDownEvent;
    FOnMouseWheelUp: TMouseWheelUpDownEvent;
    FOnStartDrag: TStartDragEvent;
    FNotifyFree: TWillFree;
    FParent: TComponent;
    FParentScheme: TMFBaseScheme;
    FWindowProc: TWndMethod;
    FControlStyle: TControlStyle;
    FControlState: TControlState;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FReadOnly: Boolean;
    FOnBeforDragItemDown: TItemDownEvent;
    FOnAdjustDragDrop :TAdjustDragDropEvent;
    FOnAfterDragItemDown: TItemUpEvent;
    FOnPaintItem: TPaintItemEvent;
    FOnDragDropNear: TDragDropNearEvent;
    FShowHint: Boolean;
    FOnSetHintData: THintDataEvent;
    FOnDragItemOver: TItemOverEvent;
    FOnSetNodeHeight: TNodeHeightEvent;
    FOnBeforItemTimeChange: TBeforItemTimeChangeEvent;
    FOnAfterItemTimeChange: TAfterItemTimeChangeEvent;
    FOnDragOtherDrop: TItemDragOtherDropEvent;
    FOnDragOtherOver: TItemDragOtherOverEvent;
    FOnItemSelectChange: TItemSelectChangeEvent;
    FOnDblClickView: TDblClickViewEvent;
    FOnDragHint: TDragHintEvent;
    FImages: TImageList;
    FCaption: String;
    function GetEnabled: Boolean;
    function GetFocused: Boolean;
    function GetOnDblClick: TNotifyEvent;
    function GetOnDragDrop: TDragDropEvent;
    function GetOnDragOver: TDragOverEvent;
    function GetOnEndDrag: TEndDragEvent;
    function GetOnKeyDown: TKeyEvent;
    function GetOnKeyPress: TKeyPressEvent;
    function GetOnKeyUp: TKeyEvent;
    function GetOnMouseDown: TMouseEvent;
    function GetOnMouseMove: TMouseMoveEvent;
    function GetOnMouseUp: TMouseEvent;
    function GetOnMouseWheel: TMouseWheelEvent;
    function GetOnMouseWheelDown: TMouseWheelUpDownEvent;
    function GetOnMouseWheelUp: TMouseWheelUpDownEvent;
    function GetOnStartDrag: TStartDragEvent;
    function GetTabStop: Boolean;
    function GetVisible: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetFocused(const Value: Boolean);
    procedure SetOnDblClick(const Value: TNotifyEvent);
    procedure SetOnDragDrop(const Value: TDragDropEvent);
    procedure SetOnDragOver(const Value: TDragOverEvent);
    procedure SetOnEndDrag(const Value: TEndDragEvent);
    procedure SetOnKeyDown(const Value: TKeyEvent);
    procedure SetOnKeyPress(const Value: TKeyPressEvent);
    procedure SetOnKeyUp(const Value: TKeyEvent);
    procedure SetOnMouseDown(const Value: TMouseEvent);
    procedure SetOnMouseMove(const Value: TMouseMoveEvent);
    procedure SetOnMouseUp(const Value: TMouseEvent);
    procedure SetOnMouseWheel(const Value: TMouseWheelEvent);
    procedure SetOnMouseWheelDown(const Value: TMouseWheelUpDownEvent);
    procedure SetOnMouseWheelUp(const Value: TMouseWheelUpDownEvent);
    procedure SetOnStartDrag(const Value: TStartDragEvent);
    procedure SetTabStop(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetParent(const Value: TComponent);
    procedure SetParentScheme(const Value: TMFBaseScheme);
    procedure SetOnEnter(const Value: TNotifyEvent);
    procedure SetOnExit(const Value: TNotifyEvent);
    function GetOnEnter: TNotifyEvent;
    function GetOnExit: TNotifyEvent;
    procedure SetOnClick(const Value: TNotifyEvent);
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMHitTest(var Message: TCMHitTest); message CM_HITTEST;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;

    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMSysKeyDown(var Message: TWMKeyDown); message WM_SYSKEYDOWN;
    procedure WMKeyUp(var Message: TWMKeyUp); message WM_KEYUP;
    procedure WMSysKeyUp(var Message: TWMKeyUp); message WM_SYSKEYUP;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure CMWantSpecialKey(var Message: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure MouseWheelHandler(var Message: TMessage);
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    function GetMouseCapture: Boolean;
    procedure SetMouseCapture(const Value: Boolean);
    function GetParentScheme: TMFBaseScheme;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetShowHint(const Value: Boolean);
    procedure SetImages(const Value: TImageList);
    procedure SetCaption(const Value: String);

  protected
    procedure SetComponentState(Value:TComponentState); virtual;
    procedure Loaded; override;
    procedure DoEnter; dynamic;
    procedure DoExit; dynamic;
    procedure DoScrollTimer;dynamic;
    function DoKeyPress(var Message: TWMKey): Boolean;dynamic;
    function DoKeyDown(var  Message: TWMKey): Boolean;dynamic;
    function DoKeyUp(var Message: TWMKey): Boolean;dynamic;
    function DoSpecialKey(var Message: TWMKey): Boolean;dynamic;
    procedure DoMouseDown(var Message: TWMMouse; Button: TMouseButton;
      Shift: TShiftState);dynamic ;
    procedure DoMouseUp(var Message: TWMMouse; Button: TMouseButton);dynamic;
    function CalcCursorPos: TPoint;
    procedure ReadState(Reader: TReader); override;
    procedure SetParentComponent(AParent: TComponent); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Notification(AComponent: TComponent;Operation: TOperation); override;
    property ControlState: TControlState read FControlState write FControlState;
    property ControlStyle: TControlStyle read FControlStyle write FControlStyle;
    property MouseCapture:Boolean read GetMouseCapture write  SetMouseCapture;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InIt;virtual;

    procedure TreeChanged(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);virtual;
    function GetDataTreeClientRect(AItem:TMFSchemeDataItem;ANode:TMFSchemeDataTreeNode=nil):TRect;virtual;
    function  ClientToScreen(APoint:TPoint):TPoint;
    function  ScreenToClient(APoint:TPoint):TPoint;
    procedure ClearView;
    procedure SetNodeHeight(ANode:TMFSchemeTreeNode;var NodeHeight:Integer);virtual;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); dynamic;
    procedure DragCanceled; dynamic;
    procedure DragDrop(Source: TObject;X,Y: Integer);dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); dynamic;
    procedure KeyDown(var Key: Word; Shift: TShiftState); dynamic;
    procedure KeyUp(var Key: Word; Shift: TShiftState); dynamic;
    procedure KeyPress(var Key: Char); dynamic;
    procedure WndProc(var Message: TMessage); virtual;
    function IsNotifyChange:Boolean;
    procedure BeginUpdate; virtual;
    procedure CancelUpdate;virtual;
    procedure EndUpdate;virtual;
    procedure Paint;virtual;abstract;
    procedure DragHint(Sender:TObject;ADateTime:TDateTime;AItem:TMFSchemeDataItem;AViewHitInfo:TViewHitInfo;
      var HintRec:THintRec;var ARect:TRect; ACanvas: TCanvas);virtual;

    procedure DblClickView(Sender:TObject;AViewHitInfo:TViewHitInfo);virtual;

    procedure ItemSelectChanged(BeforeChange,Value:Boolean;AItem:TMFSchemeDataItem;
      var Accept:Boolean);virtual;
    procedure DragOtherDrop(Source: TObject;AViewHitInfo:TViewHitInfo;
      X,Y:Integer);virtual;
    procedure DragOtherOver(Source: TObject;AViewHitInfo:TViewHitInfo;
      var Accept:Boolean;X,Y:Integer);virtual;

    procedure BeforDragItemDown(Source: TObject;DragItem:TMFSchemeDataItem;
      NewNode:TMFSchemeDataTreeNode ;var Accept:Boolean;X,Y:Integer);virtual;

    procedure AdjustDragDrop(NewNode:TMFSchemeDataTreeNode;
      var AdjustMoveType:TAdjustMoveType;StartDataItem:TMFSchemeDataItem=Nil;
      EndDataItem:TMFSchemeDataItem=Nil);virtual;

    procedure BeforItemTimeChange(DataItem:TMFSchemeDataItem;
      ItemTimeChangeType:TItemTimeChangeType;var NewTime:TDateTime;var Accept:Boolean);virtual;

    procedure AfterItemTimeChange(DataItem:TMFSchemeDataItem;
      ItemTimeChangeType:TItemTimeChangeType);virtual;

    procedure DragItemOver(Source: TObject;DragItem:TMFSchemeDataItem;
      NewNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer);virtual;

    procedure AfterDragItemDown(Source: TObject;DragItem:TMFSchemeDataItem;
      OldNode:TMFSchemeDataTreeNode;var Accept:Boolean;X,Y:Integer);virtual;

    procedure PaintItem(Sender:TObject;Item:TMFSchemeDataItem;
      ACanvas:TCanvas;R:TRect);virtual;

    procedure DragDropNear(NewNode:TMFSchemeDataTreeNode; DragItem:TMFSchemeDataItem;
      var Space:Integer; var NearDateTime:TDateTime;DragDateTime: TDateTime;X,Y:Integer) ; virtual;

    procedure SetHintData(Sender: TObject; AViewHitInfo:TViewHitInfo;
      var HintRec:THintRec; var R: TRect; ACanvas: TCanvas);virtual;
    function GetHintStr(AViewHitInfo: TViewHitInfo): String;virtual;
    function GetPaintClass: TMFBaseSchemePaintClass; virtual; abstract;
    function GetClientRect:TRect;
    function GetRealRect:TRect;
    function GetWholeHeight:Integer;virtual;
    function GetWholeWidth:Integer;virtual;
    function GetOffSetPoint:TPoint;
    function GetWholeRect:TRect;
    procedure CalcScrollBar;
    procedure UpdateScroll;
    procedure Update;
    procedure Invalidate;
    procedure Click; dynamic;
    procedure DblClick; dynamic;
    function GetConfigureText:String;virtual;
    procedure SetConfigureText(Value:string);virtual;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    property Parent: TComponent read FParent write SetParent;
    property ParentScheme: TMFBaseScheme read GetParentScheme write SetParentScheme;
    property NotifyFree:TWillFree read FNotifyFree write FNotifyFree;
    property Focused: Boolean read GetFocused write SetFocused;
    property TabStop: Boolean read GetTabStop write SetTabStop;
    //property Visible: Boolean read GetVisible write SetVisible;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property OnClick: TNotifyEvent read FOnClick write SetOnClick;
    property OnDblClick: TNotifyEvent read GetOnDblClick write SetOnDblClick;
    property OnDragDrop: TDragDropEvent read GetOnDragDrop write SetOnDragDrop;
    property OnDragOver: TDragOverEvent read GetOnDragOver write SetOnDragOver;
    property OnEndDrag: TEndDragEvent read GetOnEndDrag write SetOnEndDrag;
    property OnKeyDown: TKeyEvent read GetOnKeyDown write SetOnKeyDown;
    property OnKeyPress: TKeyPressEvent read GetOnKeyPress write SetOnKeyPress;
    property OnKeyUp: TKeyEvent read GetOnKeyUp write SetOnKeyUp;
    property OnMouseDown: TMouseEvent read GetOnMouseDown write SetOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read GetOnMouseMove write SetOnMouseMove;
    property OnMouseUp: TMouseEvent read GetOnMouseUp write SetOnMouseUp;
    property OnMouseWheel: TMouseWheelEvent read GetOnMouseWheel write SetOnMouseWheel;
    property OnMouseWheelDown: TMouseWheelUpDownEvent read GetOnMouseWheelDown write SetOnMouseWheelDown;
    property OnMouseWheelUp: TMouseWheelUpDownEvent read GetOnMouseWheelUp write SetOnMouseWheelUp;
    property OnStartDrag: TStartDragEvent read GetOnStartDrag write SetOnStartDrag;
    property OnEnter: TNotifyEvent read GetOnEnter write SetOnEnter;
    property OnExit: TNotifyEvent read GetOnExit write SetOnExit;

    property OnDragOtherDrop:TItemDragOtherDropEvent read FOnDragOtherDrop write FOnDragOtherDrop;
    property OnDragOtherOver:TItemDragOtherOverEvent read FOnDragOtherOver write FOnDragOtherOver;

    property OnBeforDragItemDown:TItemDownEvent read FOnBeforDragItemDown write FOnBeforDragItemDown;
    property OnAfterDragItemDown:TItemUpEvent read FOnAfterDragItemDown write FOnAfterDragItemDown;
    property OnAdjustDragDrop :TAdjustDragDropEvent read FOnAdjustDragDrop write FOnAdjustDragDrop;

    property OnDragDropNear:TDragDropNearEvent read FOnDragDropNear write FOnDragDropNear;

    property OnDragItemOver:TItemOverEvent read  FOnDragItemOver write FOnDragItemOver;

    property OnBeforItemTimeChange:TBeforItemTimeChangeEvent read  FOnBeforItemTimeChange write FOnBeforItemTimeChange;
    property OnAfterItemTimeChange:TAfterItemTimeChangeEvent read  FOnAfterItemTimeChange write FOnAfterItemTimeChange;

    property OnSetNodeHeight:TNodeHeightEvent read FOnSetNodeHeight write FOnSetNodeHeight;

    property OnPaintItem:TPaintItemEvent read FOnPaintItem write FOnPaintItem;

    property OnSetHintData:THintDataEvent read FOnSetHintData write FOnSetHintData;

    property TreeOptions:TMFTreeOptions read FTreeOptions write  FTreeOptions;
    property IndicaterOptions:TMFIndicaterOptions read FIndicaterOptions write FIndicaterOptions;
    property HeadOptions:TMFHeadOptions read FHeadOptions write FHeadOptions;
    property FootOptions:TMFFootOptions read FFootOptions write FFootOptions;
    property WindowProc: TWndMethod read FWindowProc write FWindowProc;
    property ReadOnly:Boolean  read FReadOnly write SetReadOnly;
    property ShowHint: Boolean read FShowHint write SetShowHint;
    property OnItemSelectChange:TItemSelectChangeEvent read FOnItemSelectChange write FOnItemSelectChange;
    property OnDblClickView:TDblClickViewEvent read FOnDblClickView write FOnDblClickView;
    property OnDragHint:TDragHintEvent read FOnDragHint write FOnDragHint;
    property Images:TImageList read FImages write SetImages;
    property Caption:String read FCaption write SetCaption; 
  end;

  TMFBaseOptions=Class(TPersistent)
  private
    procedure SetColor(const Value: TColor);
  protected
    FBaseView:TMFBaseSchemeView;
    FFont: TFont;
    FPen: TPen;
    FColor: TColor;
    procedure SetView(const Value: TMFBaseSchemeView);
    procedure SetFont(const Value: TFont);
    procedure SetPen(const Value: TPen);
  public
    function GetOwner:TPersistent; override;
    constructor Create(AView:TMFBaseSchemeView);reintroduce;virtual;
    destructor Destroy;override;
    procedure SetChange(Sender:TObject);virtual;
    procedure Change;virtual;
    procedure ChangeScroll;virtual;
    procedure ChangeAll;virtual;
    procedure Assign(Source: TPersistent); override;
    property View:TMFBaseSchemeView read FBaseView write SetView;
    property Pen:TPen read FPen write SetPen;
    property Font:TFont read FFont write SetFont;
    property Color:TColor read FColor write SetColor;
  end;

  TMFTreeOptions=Class(TMFBaseOptions)
  private
    FVisible: Boolean;
    FShowLines: Boolean;
    FShowButtons: Boolean;
    FRowSelect: Boolean;
    FIndent: Integer;
    FWidth: Integer;
    FCaption: String;
    FAutoMoveToSelect: Boolean;
    procedure SetIndent(const Value: Integer);
    procedure SetRowSelect(const Value: Boolean);
    procedure SetShowButtons(const Value: Boolean);
    procedure SetShowLines(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetCaption(const Value: String);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
  published
    property Visible:Boolean read FVisible write SetVisible;
    property RowSelect:Boolean read FRowSelect write SetRowSelect;
    property ShowButtons:Boolean read FShowButtons write SetShowButtons;
    property ShowLines:Boolean read FShowLines write SetShowLines;
    property Indent:Integer read FIndent write SetIndent;
    property Width:Integer read FWidth write SetWidth;
    property Caption:String read FCaption write SetCaption;
    property Pen;
    property Font;
    property Color;
    property AutoMoveToSelect:Boolean read FAutoMoveToSelect write FAutoMoveToSelect;
  end;

  TMFHeadOptions=Class(TMFBaseOptions)
  private
    FVisible: Boolean;
    FHeight: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
  published
    property Visible:Boolean read FVisible write SetVisible;
    property Height:Integer read FHeight write SetHeight;
    property Pen;
    property Font;
    property Color;
  end;

  TMFIndicaterOptions=Class(TMFBaseOptions)
  private
    FVisible: Boolean;
    FDefaultHeight: Integer;
    FWidth: Integer;
    procedure SetVisible(const Value: Boolean);
    procedure SetDefaultHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
  published
    property Visible:Boolean read FVisible write SetVisible;
    property Width:Integer read FWidth write SetWidth;
    property DefaultHeight:Integer read FDefaultHeight write SetDefaultHeight;
    property Pen;
    property Font;
    property Color;
  end;
  TMFFootOptions=Class(TMFBaseOptions)
  private
    FVisible: Boolean;
    FHeight: Integer;
    FCaption: String;

    procedure SetHeight(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetCaption(const Value: String);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
  published
    property Visible:Boolean read FVisible write SetVisible;
    property Height:Integer read FHeight write SetHeight;
    property Caption:String read FCaption write SetCaption;
    property Pen;
    property Font;
    property Color;
  end;

  TMFContentOptions=Class(TMFBaseOptions)
  private
    FVisible: Boolean;
    FMultiSelect: Boolean;
    FItemSeleMFype:TItemSeleMFype;
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create(AView:TMFBaseSchemeView);override;
    procedure Assign(Source: TPersistent); override;
    property MultiSelect:Boolean read FMultiSelect write FMultiSelect default False;
  published
    property ItemSeleMFype:TItemSeleMFype read FItemSeleMFype write FItemSeleMFype;
    property Visible:Boolean read FVisible write SetVisible default True;
  end;

  TMFBaseViewControl=Class(TPersistent)
  protected
    FEnable: Boolean;
    FBaseView:TMFBaseSchemeView;
    procedure SetEnable(const Value: Boolean);
  public
    constructor Create(AView:TMFBaseSchemeView);virtual;
    Function IsReadOnly:Boolean;virtual;
    procedure KeyPress(var Key: Char); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer); virtual;
    procedure DragCanceled; virtual;
    procedure BeginDrag(Immediate: Boolean; Threshold: Integer = -1);virtual;
    procedure EndDrag(Drop: Boolean); virtual;
    function Dragging: Boolean; virtual;
    function CheckItemSeleMFype(AButton:TMouseButton;AItemSeleMFype:TItemSeleMFype):Boolean;

    procedure DragItemOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);virtual;
    procedure DragItemDrop(Source: TObject;X,Y: Integer); virtual;
    
    procedure DragOtherOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);virtual;
    procedure DragOtherDrop(Source: TObject;X,Y: Integer);virtual;

  published
    property Enable:Boolean read FEnable write SetEnable;
  end;

  TMFBaseSchemeViewClass= class of TMFBaseSchemeView;

function RealRound(Value:Double):Integer;
function VarToDateTimeDef(value:Variant):TDateTime;

implementation
{$R Scheme.res}

{ TGraphScrollBar }
function VarToDateTimeDef(value:Variant):TDateTime;
begin
  if  value=Null then
    Result :=0
  else
    Result :=VarToDateTime(value);
end;

function RealRound(Value:Double):Integer;
begin
  if Trunc(Value) <> Value then
    Result:= Trunc(Value)+1
  else
    Result:= Trunc(Value);
end;

constructor TGraphScrollBar.Create(AOwner: TMFBaseScheme; AKind: TScrollBarKind);
begin
  inherited Create;
  fOwner := AOwner;
  fSize:=0;
  fKind := AKind;
  fPageIncrement := 30;
  fIncrement := fPageIncrement div 10;
  fVisible := True;
  fDelay := 10;
  fLineDiv := 4;
  fPageDiv := 12;
  fColor := clBtnHighlight;
  fParentColor := True;
  fUpdateNeeded := True;
  fStyle := ssRegular;
  fSmooth:=True;
end;

function TGraphScrollBar.IsIncrementStored: Boolean;
begin
  Result := not Smooth;
end;

procedure TGraphScrollBar.Assign(Source: TPersistent);
begin
  if Source is TGraphScrollBar then
  begin
    Visible := TGraphScrollBar(Source).Visible;
    Position := TGraphScrollBar(Source).Position;
    Increment := TGraphScrollBar(Source).Increment;
    DoSetRange(TGraphScrollBar(Source).Range);
  end
  else
    inherited Assign(Source);
end;

procedure TGraphScrollBar.ChangeBiDiPosition;
begin
  if Kind = sbHorizontal then
    if IsScrollBarVisible then
      if not Owner.UseRightToLeftScrollBar then
	Position := 0
      else
	Position := Range;
end;

procedure TGraphScrollBar.CalcAutoRange;
var
  I: Integer;
  NewRange: Integer;
  GraphObject: TMFBaseScheme;
begin
  if Kind = sbHorizontal then
  begin

  end
  else
  begin

  end;
  DoSetRange(NewRange + Margin);
end;

function TGraphScrollBar.IsScrollBarVisible: Boolean;
var
  Style: Longint;
begin
  Style := WS_HSCROLL;
  if Kind = sbVertical then Style := WS_VSCROLL;
  Result := (Visible) and
	    (GetWindowLong(Owner.Handle, GWL_STYLE) and Style <> 0);
end;

function TGraphScrollBar.ScrollBarVisible(Code: Word): Boolean;
var
  Style: Longint;
begin
  Style := WS_HSCROLL;
  if Code = SB_VERT then Style := WS_VSCROLL;
  Result := GetWindowLong(Owner.Handle, GWL_STYLE) and Style <> 0;
end;

function TGraphScrollBar.ControlSize(ControlSB, AssumeSB: Boolean): Integer;
var
  BorderAdjust: Integer;
  function Adjustment(Code, Metric: Word): Integer;
  begin
    Result := 0;
    if not ControlSB then
    begin
      if AssumeSB and not ScrollBarVisible(Code) then
	Result := -(GetSystemMetrics(Metric) - BorderAdjust)
      else if not AssumeSB and ScrollBarVisible(Code) then
	Result := GetSystemMetrics(Metric) - BorderAdjust;
    end;
  end;

begin
  BorderAdjust := Integer(GetWindowLong(Owner.Handle, GWL_STYLE) and
    (WS_BORDER or WS_THICKFRAME) <> 0);
  if Kind = sbVertical then
    Result := Owner.ClientHeight + Adjustment(SB_HORZ, SM_CXHSCROLL) else
    Result := Owner.ClientWidth + Adjustment(SB_VERT, SM_CYVSCROLL);
end;

function TGraphScrollBar.GetScrollPos: Integer;
begin
  Result := 0;
  if Visible then Result := Position;
end;

function TGraphScrollBar.NeedsScrollBarVisible: Boolean;
var I:Integer;
begin
  if Kind=sbHorizontal then
    i:=Owner.WholeWidth
  else
    i:=Owner.WholeHeight;
  //fRange
  Result := i > ControlSize(False, False);
end;

procedure TGraphScrollBar.ScrollMessage(var Msg: TWMScroll);
var
  Incr, FinalIncr, Count: Integer;
  CurrentTime, StartTime, ElapsedTime: Longint;

  function GetRealScrollPosition: Integer;
  var
    SI: TScrollInfo;
    Code: Integer;
  begin
    SI.cbSize := SizeOf(TScrollInfo);
    SI.fMask := SIF_TRACKPOS;
    Code := SB_HORZ;
    if fKind = sbVertical then Code := SB_VERT;
    Result := Msg.Pos;
    if FlatSB_GetScrollInfo(Owner.Handle, Code, SI) then
      Result := SI.nTrackPos;
  end;

begin
  //fPosition:=GetRealScrollPosition;
{  if Self.Kind=sbHorizontal then
    FlatSB_SetScrollPos(Owner.Handle, SB_HORZ, GetRealScrollPosition, True)
  else
    FlatSB_SetScrollPos(Owner.Handle, SB_VERT, GetRealScrollPosition , True);
}
  with Msg do
  begin
    if fSmooth and (ScrollCode in [SB_LINEUP, SB_LINEDOWN, SB_PAGEUP, SB_PAGEDOWN]) then
    begin
      case ScrollCode of
	SB_LINEUP, SB_LINEDOWN:
	  begin
	    Incr := fIncrement div fLineDiv;
	    FinalIncr := fIncrement mod fLineDiv;
	    Count := fLineDiv;
	  end;
	SB_PAGEUP, SB_PAGEDOWN:
	  begin
	    Incr := FPageIncrement;
	    FinalIncr := Incr mod fPageDiv;
	    Incr := Incr div fPageDiv;
	    Count := fPageDiv;
	  end;
      else
	Count := 0;
	Incr := 0;
	FinalIncr := 0;
      end;
      CurrentTime := 0;
      while Count > 0 do
      begin
	StartTime := GetTickCount;
	ElapsedTime := StartTime - CurrentTime;
	if ElapsedTime < fDelay then Sleep(fDelay - ElapsedTime);
	CurrentTime := StartTime;
	case ScrollCode of
	  SB_LINEUP: SetPosition(fPosition - Incr);
	  SB_LINEDOWN: SetPosition(fPosition + Incr);
	  SB_PAGEUP: SetPosition(fPosition - Incr);
	  SB_PAGEDOWN: SetPosition(fPosition + Incr);
	end;
	Owner.Update;
	Dec(Count);
      end;
      if FinalIncr > 0 then
      begin
	case ScrollCode of
	  SB_LINEUP: SetPosition(fPosition - FinalIncr);
	  SB_LINEDOWN: SetPosition(fPosition + FinalIncr);
	  SB_PAGEUP: SetPosition(fPosition - FinalIncr);
	  SB_PAGEDOWN: SetPosition(fPosition + FinalIncr);
	end;
      end;
    end
    else
      case ScrollCode of
	SB_LINEUP: SetPosition(fPosition - fIncrement);
	SB_LINEDOWN: SetPosition(fPosition + fIncrement);
	SB_PAGEUP: SetPosition(fPosition - ControlSize(True, False));
	SB_PAGEDOWN: SetPosition(fPosition + ControlSize(True, False));
	SB_THUMBPOSITION:
	      SetPosition(GetRealScrollPosition);
	SB_THUMBTRACK:
	      SetPosition(GetRealScrollPosition);
	SB_TOP: SetPosition(0);
	SB_BOTTOM: SetPosition(fCalcRange);
	SB_ENDSCROLL: begin end;
      end;
  end;
end;

procedure TGraphScrollBar.SetButtonSize(Value: Integer);
const
  SysConsts: array[TScrollBarKind] of Integer = (SM_CXHSCROLL, SM_CXVSCROLL);
var
  NewValue: Integer;
begin
  if Value <> ButtonSize then
  begin
    NewValue := Value;
    if NewValue = 0 then
      Value := GetSystemMetrics(SysConsts[Kind]);
    fButtonSize := Value;
    fUpdateNeeded := True;
    Owner.UpdateScrollBars;
    if NewValue = 0 then
      fButtonSize := 0;
  end;
end;

procedure TGraphScrollBar.SetColor(Value: TColor);
begin
  if Value <> Color then
  begin
    fColor := Value;
    fParentColor := False;
    fUpdateNeeded := True;
    Owner.UpdateScrollBars;
  end;
end;

procedure TGraphScrollBar.SetParentColor(Value: Boolean);
begin
  if ParentColor <> Value then
  begin
    fParentColor := Value;
    if Value then Color := clBtnHighlight;
  end;
end;

procedure TGraphScrollBar.SetPosition(Value: Integer);
var
  Code: Word;
  Form: TCustomForm;
  OldPos: Integer;
begin

  if Kind = sbHorizontal then
    Code := SB_HORZ
  else
    Code := SB_VERT;

  if  Value>(Range-ControlSize(True,true)) then Value:=Range-ControlSize(True,true);
  if  Value<0 then Value:=0;

  if  fPosition = Value then Exit;

  fPosition := Value;

  if FlatSB_GetScrollPos(Owner.Handle, Code) <> fPosition then
  FlatSB_SetScrollPos(Owner.Handle, Code, fPosition, True);


  Owner.Perform(WM_ScrollUpdate,0,0);

end;

procedure TGraphScrollBar.SetSize(Value: Integer);
const
  SysConsts: array[TScrollBarKind] of Integer = (SM_CYHSCROLL, SM_CYVSCROLL);
var
  NewValue: Integer;
begin
  if Value <> Size then
  begin
    NewValue := Value;
    if NewValue = 0 then
      Value := GetSystemMetrics(SysConsts[Kind]);
    fSize := Value;
    fUpdateNeeded := True;
    Owner.UpdateScrollBars;
    if NewValue = 0 then
      fSize := 0;
  end;
end;

procedure TGraphScrollBar.SetStyle(Value: TScrollBarStyle);
begin
  if Style <> Value then
  begin
    fStyle := Value;
    {if fStyle= ssRegular then
      UninitializeFlatSB(Owner.Handle)
    else
      InitializeFlatSB(Owner.Handle); }

    fUpdateNeeded := True;
    Owner.UpdateScrollBars;
  end;
end;

procedure TGraphScrollBar.SetThumbSize(Value: Integer);
begin
  if ThumbSize <> Value then
  begin
    fThumbSize := Value;
    fUpdateNeeded := True;
    Owner.UpdateScrollBars;
  end;
end;

procedure TGraphScrollBar.DoSetRange(Value: Integer);
var
  NewRange: Integer;
begin
  if Value <= 0 then
    NewRange := 0 ;

  if fRange <> NewRange then
  begin
    fRange := NewRange;
    Owner.UpdateScrollBars;
  end;
end;

procedure TGraphScrollBar.SetVisible(Value: Boolean);
begin
  //if fVisible <> Value then
  begin
    fVisible := Value;
    Owner.UpdateScrollBars;
  end;
end;

procedure TGraphScrollBar.Update(ControlSB, AssumeSB: Boolean);
type
  TPropKind = (pkStyle, pkButtonSize, pkThumbSize, pkSize, pkBkColor);
const
  Kinds: array[TScrollBarKind] of Integer = (WSB_PROP_HSTYLE, WSB_PROP_VSTYLE);
  Styles: array[TScrollBarStyle] of Integer = (FSB_REGULAR_MODE,
    FSB_ENCARTA_MODE, FSB_FLAT_MODE);
  Props: array[TScrollBarKind, TPropKind] of Integer = (
    { Horizontal }
    (WSB_PROP_HSTYLE, WSB_PROP_CXHSCROLL, WSB_PROP_CXHTHUMB, WSB_PROP_CYHSCROLL,
     WSB_PROP_HBKGCOLOR),
    { Vertical }
    (WSB_PROP_VSTYLE, WSB_PROP_CYVSCROLL, WSB_PROP_CYVTHUMB, WSB_PROP_CXVSCROLL,
     WSB_PROP_VBKGCOLOR));
var
  Code: Word;
  ScrollInfo: TScrollInfo;

  procedure UpdateScrollProperties(Redraw: Boolean);
  begin
    if Style<>ssRegular then
      FlatSB_SetScrollProp(Owner.Handle, Props[Kind, pkStyle], Styles[Style], True);

    if ButtonSize > 0 then
      FlatSB_SetScrollProp(Owner.Handle, Props[Kind, pkButtonSize], ButtonSize, True);
    if ThumbSize > 0 then
      FlatSB_SetScrollProp(Owner.Handle, Props[Kind, pkThumbSize], ThumbSize, True);
    if Size > 0 then
      FlatSB_SetScrollProp(Owner.Handle, Props[Kind, pkSize], Size, True);
    {FlatSB_SetScrollProp(Owner.Handle, Props[Kind, pkBkColor],
      ColorToRGB(Color), False);}
  end;

begin
  fCalcRange := 0;

  Code := SB_HORZ;
  fRange:=Owner.WholeWidth;

  if Kind = sbVertical then
  begin
    Code := SB_VERT;
    fRange:=Owner.WholeHeight;
  end;


  if Visible then
  begin
    fCalcRange := Range - ControlSize(True, True);
    if fCalcRange < 0 then
    begin
      fCalcRange := 0;
      SetPosition(0)
    end;
  end;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  ScrollInfo.fMask := SIF_ALL;
  ScrollInfo.nMin := 0;
  if fCalcRange > 0 then
    ScrollInfo.nMax := Range
  else
  begin
    ScrollInfo.nMax := 0;
  end;
  ScrollInfo.nPage := ControlSize(ControlSB, AssumeSB) + 1;
  ScrollInfo.nPos := fPosition;
  ScrollInfo.nTrackPos := fPosition;

  fUpdateNeeded := False;

  FlatSB_SetScrollInfo(Owner.Handle, Code, ScrollInfo, True);

  fPageIncrement := (ControlSize(True, False) * 9) div 10;
  if Smooth then fIncrement := fPageIncrement div 10;
  //UpdateScrollProperties(fUpdateNeeded);
end;


function TGraphScrollBar.ScrollBarVisible: Boolean;
begin
  if Kind = sbVertical then
    Result:=ScrollBarVisible(SB_HORZ)
  else
    Result:=ScrollBarVisible(SB_VERT);
end;

{ TMFBaseScheme }
procedure TMFBaseScheme.CreateWnd;
begin
  inherited CreateWnd;

  UpdateScrollBars;
end;

constructor TMFBaseScheme.Create(AOwner: TComponent);
var
  i:Integer;
const                       
  Style = [csCaptureMouse,csOpaque, csDoubleClicks];
begin
  inherited;
  Parent := TWinControl(AOwner) ;
  if NewStyleControls then
    ControlStyle := Style
  else
    ControlStyle := Style + [csFramed];

  FBorderStyle := bsSingle;
  Width:=300;
  Height :=300;
  FRealWidth:=0;
  FRealHeight:=0;
  UpdatingScrollBars:=False;
  FHorzScrollBar:= TGraphScrollBar.Create(Self,sbHorizontal);
  FVertScrollBar:= TGraphScrollBar.Create(self,sbVertical);
  UpdateScrollBars;
  TabStop := True;
  Color:=clWhite;
  Ctl3D:=True;
  Perform(CM_CTL3DCHANGED, 0, 0);
  //DoubleBuffered;
end;

destructor TMFBaseScheme.Destroy;
begin
  FHorzScrollBar.Free;
  FVertScrollBar.Free;
  inherited;
end;

procedure TMFBaseScheme.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style := CS_DBLCLKS;
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
	Style := Style and not WS_BORDER;
	ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
	Style := Style or WS_BORDER;
  end;
end;

procedure TMFBaseScheme.WMHScroll(var Message: TWMHScroll);
var ScrollArea:TRect;
begin
  if (Message.ScrollBar = 0) and HorzScrollBar.Visible then
    HorzScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TMFBaseScheme.WMVScroll(var Message: TWMHScroll);
begin
  if (Message.ScrollBar = 0) and VertScrollBar.Visible then
    VertScrollBar.ScrollMessage(Message)
  else
    inherited;
end;


function  TMFBaseScheme.UpdateScrollBars:Boolean;
begin
  Result:=False;
  if IsScrollBarCreate then
  if not UpdatingScrollBars and HandleAllocated then
  begin
    try
      UpdatingScrollBars := True;

      if VertScrollBar.NeedsScrollBarVisible then
      begin
	HorzScrollBar.Update(False, True);
	VertScrollBar.Update(True, False);
	Result:=True;
      end
      else if HorzScrollBar.NeedsScrollBarVisible then
      begin
	VertScrollBar.Update(False, True);
	HorzScrollBar.Update(True, False);
	Result:=True;
      end
      else
      begin
	VertScrollBar.Update(False, False);
	HorzScrollBar.Update(True, False);
      end;
    finally
      UpdatingScrollBars := False;
    end;
    //CalcVisibleBounds;
  end;

end;

procedure TMFBaseScheme.SetHorzScrollBar(const Value: TGraphScrollBar);
begin
  fHorzScrollBar := Value;
end;

procedure TMFBaseScheme.SetVertScrollBar(const Value: TGraphScrollBar);
begin
  fVertScrollBar := Value;
end;


procedure TMFBaseScheme.WMScrollUpdate(var Message: TMessage);
begin
  if not UpdatingScrollBars then
   Invalidate;
end;

procedure TMFBaseScheme.WMSize(var Message: TWMSize);
begin
  //if not UpdateScrollBars then
  UpdateScrollBars;
  AdjustScrollBar(sbHorizontal);
  AdjustScrollBar(sbVertical);
  Invalidate;
end;

procedure TMFBaseScheme.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  Paint;
end;

procedure TMFBaseScheme.CMDesignHitTest(var Message: TCMDesignHitTest);
begin
  //inherited;
  Message.Result := 0;
  if (Message.Msg =WM_VSCROLL) or (Message.Msg=WM_HSCROLL) then
  begin
    Message.Result:=1;
  end;

end;

function TMFBaseScheme.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  if WheelDelta>0 then
  begin
    SendMessage(Handle, WM_VSCROLL,SB_LINEUP , 0);
  end
  else begin
    SendMessage(Handle, WM_VSCROLL,SB_LINEDOWN , 0);
  end;
end;

procedure TMFBaseScheme.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  Paint;
end;



procedure TMFBaseScheme.WMContextMenu(var Message: TWMContextMenu);
begin
  inherited;
end;


function TMFBaseScheme.GetRealLeft: Integer;
begin
  if HorzScrollBar <> nil then
    Result :=HorzScrollBar.Position
  else
    Result :=0;
end;

function TMFBaseScheme.GetRealTop: Integer;
begin
  if VertScrollBar <> nil then
    Result :=VertScrollBar.Position
  else
    Result :=0;
end;

procedure TMFBaseScheme.SetRealLeft(const Value: Integer);
begin
  if HorzScrollBar <> nil then
    HorzScrollBar.Position :=Value
end;

procedure TMFBaseScheme.SetRealTop(const Value: Integer);
begin
  if VertScrollBar <> nil then
    VertScrollBar.Position :=Value
end;

function TMFBaseScheme.GetDrawRect: TRect;
begin
  Result :=Rect(0,0,HorzScrollBar.ControlSize(False,False),VertScrollBar.ControlSize(False,False) )
end;


procedure TMFBaseScheme.RemoveChildComponent(AComponent: TComponent);
begin

end;

procedure TMFBaseScheme.AddChildComponent(AComponent: TComponent);
begin
  InitAddChildComponent(AComponent);
end;

procedure TMFBaseScheme.InitAddChildComponent(AComponent: TComponent);
begin

end;

function TMFBaseScheme.GetWholeHeight: Integer;
begin
  Result :=  0;
end;

function TMFBaseScheme.GetWholeWidth: Integer;
begin
  Result :=  0;
end;


procedure TMFBaseScheme.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS  or DLGC_WANTCHARS;
  //DLGC_WANTTAB
end;

procedure TMFBaseScheme.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetFocus;
  //Invalidate;
end;

function TMFBaseScheme.InvalidateRect(RRect: TRect;
  bErase: Boolean): Boolean;
begin
  Result:=windows.InvalidateRect(Handle,@RRect,bErase);
end;

procedure TMFBaseScheme.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;

end;

procedure TMFBaseScheme.DragDrop(Source: TObject; X, Y: Integer);
begin
  inherited;

end;

procedure FrameWindow(Wnd: HWnd);
var
  Rect              : TRect;
  DC                : hDC;
  OldPen, Pen       : hPen;
  OldBrush, Brush   : hBrush;
  X2, Y2            : Integer;
begin
  GetWindowRect(Wnd, Rect);
  DC := GetWindowDC(Wnd);
  SetROP2(DC, R2_NOT);
  Pen := CreatePen(PS_InsideFrame, 1, 0);
  OldPen := SelectObject(DC, Pen);
  Brush := GetStockObject(Null_Brush);
  OldBrush := SelectObject(DC, Brush);
  X2 := Rect.Right - Rect.Left;
  Y2 := Rect.Bottom - Rect.Top;
  Rectangle(DC, 0, 0, X2, Y2);
  SelectObject(DC, OldBrush);
  SelectObject(DC, OldPen);
  ReleaseDC(Wnd, DC);
  DeleteObject(Pen);
end;


procedure TMFBaseScheme.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TMFBaseScheme.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure TMFBaseScheme.CMCancelMode(var Message: TMessage);
begin
  inherited;
end;

procedure TMFBaseScheme.AdjustScrollBar(ScrollBarKind: TScrollBarKind);
begin
  if IsScrollBarCreate then
  begin
    UpdatingScrollBars:=True;

    if ScrollBarKind= sbVertical then
    begin
      if VertScrollBar.Position> GetWholeHeight-GetClientRect.Bottom then
	VertScrollBar.Position :=GetWholeHeight-GetClientRect.Bottom;

    end
    else begin
      if HorzScrollBar.Position> GetWholeWidth-GetClientRect.Right then
	HorzScrollBar.Position :=GetWholeWidth-GetClientRect.Right;
    end;
    UpdatingScrollBars:=False;
  end;
end;

function TMFBaseScheme.IsScrollBarCreate: Boolean;
begin
  Result := (VertScrollBar<>nil) and (HorzScrollBar<>nil);

end;

procedure TMFBaseScheme.SetNodeHeight(ANode: TMFSchemeTreeNode;
  var NodeHeight: Integer);
begin

end;

procedure TMFBaseScheme.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result:=1;
end;

function TMFBaseScheme.GetConfigureText: String;
begin
  Result:=ConfigureToText(Self);
end;

procedure TMFBaseScheme.SetConfigureText(Value: string);
begin
  TextToConfigure(Value,Self);
end;

{TMFBaseSchemePaint}

function TMFBaseSchemePaint.GetCanvas: TDrawCanvas;
begin
  if Scheme<>nil then
  begin
    if LocalCanvas.DefCanvas <>Scheme.Canvas then
      LocalCanvas.DefCanvas :=Scheme.Canvas;
    Result := LocalCanvas;
  end
  else
    Result :=nil;
end;


procedure TMFBaseSchemePaint.ZcInvalidate(const R: TRect);
begin

end;

procedure TMFBaseSchemePaint.WinInvalidate(const R: TRect);
begin
  InvalidateRect(Scheme.Handle,@R,False);
end;

procedure TMFBaseSchemePaint.Paint;
begin

end;


constructor TMFBaseSchemePaint.Create(AControl: TMFBaseSchemeView);
begin
  FSchemeView := AControl;
end;

function TMFBaseSchemePaint.GetActiveSchemeView: TMFBaseSchemeView;
begin
  Result :=FSchemeView;
end;

destructor TMFBaseSchemePaint.Destroy;
begin
  if Assigned(FDrawCanvas) then FreeAndNil(FDrawCanvas);
  inherited;
end;

function TMFBaseSchemePaint.GetScheme: TMFBaseScheme;
begin
  if Assigned(SchemeView) then
    Result:=SchemeView.ParentScheme;

end;

procedure TMFBaseSchemePaint.InitPaint;
begin
  if Scheme <> nil then Paint;
end;

function TMFBaseSchemePaint.GetLocalCanvas: TDrawCanvas;
begin
  if Scheme<>nil then
  begin
    if not Assigned(FDrawCanvas) then
      FDrawCanvas:=TDrawCanvas.Create(Scheme.Canvas);
    Result := FDrawCanvas;
  end
  else
    raise Exception.Create('Canvas 没有 handle 错误!');
end;

function TMFBaseSchemePaint.GetVisible: Boolean;
begin
  Result := FVisible;
end;

procedure TMFBaseSchemePaint.PaintRow(Node: TMFSchemeDataTreeNode;
  ACanvas: TCanvas; R,RealRect: TRect);
begin

end;

{ TMFSchemeTreeNode }

function TMFSchemeTreeNode.AddChild: TMFSchemeTreeNode;
begin
  Result := Owner.CreateItem;
  AddChild(-1, Result);
end;

function TMFSchemeTreeNode.AddChild(I: Integer): TMFSchemeTreeNode;
begin
  Result := Owner.CreateItem;
  AddChild(I, Result);
end;

function TMFSchemeTreeNode.AddChild(I: Integer; ANode: TMFSchemeTreeNode): TMFSchemeTreeNode;
var
  vPreChild: TMFSchemeTreeNode;
begin
  if ANode = nil then raise EMFSchemeTree.Create('Node is nil');
  if FChildList = nil then FChildList := TList.Create;
  if I = -1 then I := FChildList.Count;

  FChildList.Insert(I, ANode);

  ANode.FVisible := Visible and FExpanded;

  if FMajorIndex = -1 then // 主序号＝-1的节点是虚拟根节点
    ANode.FParent := nil
  else
    ANode.FParent := Self;

  // 计算新节点的主索引
  if I = 0 then
    I := FMajorIndex + 1
  else
  begin
    vPreChild := FChildList[I - 1];
    if vPreChild.HasChildren then
      I := vPreChild.LastPosterity.AbsoluteIndex + 1
    else
      I := vPreChild.AbsoluteIndex + 1;
  end;

  // 将新节点插入到主列表中
  FOwner.FMajorList.Insert(I, ANode);
  FOwner.Renumber(I, FOwner.Count - 1);
  FOwner.ItemNotify(tnAdd, I, 1);
  FOwner.NotifyNodeChange(eNode,tnAdd,I);
  Result := ANode;
end;


procedure TMFSchemeTreeNode.Assign(Source: TPersistent);
begin
  if Source is TMFSchemeTreeNode then
  begin
    Data := TMFSchemeTreeNode(Source).Data;
    Caption := TMFSchemeTreeNode(Source).Caption;

  end
  else inherited;
end;

function TMFSchemeTreeNode.CanDownLevel: Boolean;
begin
  Result := PrevSibling <> nil;
end;

function TMFSchemeTreeNode.CanDownMove: Boolean;
begin
  Result := RelativeIndex < SafeParent.ChildCount - 1;
end;

function TMFSchemeTreeNode.CanUpLevel: Boolean;
begin
  Result := Parent <> nil;
end;

function TMFSchemeTreeNode.CanUpMove: Boolean;
begin
  Result := RelativeIndex > 0;
end;

function TMFSchemeTreeNode.ChildList: TList;
begin
  if FChildList = nil then FChildList := TList.Create;
  Result := FChildList;
end;

function TMFSchemeTreeNode.Collapse: Boolean;
begin
  Result := Expanded;
  Expanded := False;
end;

constructor TMFSchemeTreeNode.Create(AOnwer: TMFSchemeTree);
begin
  FOwner := AOnwer;
  FVisible := FOwner.AutoExpand;//False;
  FExpanded := FOwner.AutoExpand;//False;
  FHeight:=20;
  FHide:=False;
  FImageIndex := -1;
  FSelectedIndex := -1;
end;

procedure TMFSchemeTreeNode.Delete(AFree: Boolean);
var
  iFrom, iTo: Integer;
  I: Integer;
  vNode:TMFSchemeTreeNode;
begin
  iFrom := AbsoluteIndex;
  if HasChildren then
    iTo := LastPosterity.AbsoluteIndex
  else
    iTo := iFrom;
  SafeParent.FChildList.Remove(Self);

  //将这些节点从主列表中删除

  for I := iTo downto iFrom do
  begin
    vNode:=Owner.FMajorList.Items[I];
    Owner.ItemNotify(tnDelete, I, 1);
    Owner.FSelectList.Remove(vNode);
    if AFree then vNode.Free;
    Owner.FMajorList.Delete(I);
  end;
  Owner.Renumber(iFrom, Owner.Count - 1);
  Owner.NotifyNodeChange(eNode,tnDelete,-1);
end;

procedure TMFSchemeTreeNode.DeleteChildren(AFree: Boolean);
var
  iFrom, iTo: Integer;
  I: Integer;
  vNode: TMFSchemeTreeNode;
begin
  if not HasChildren then Exit;
  iFrom := ChildNodes[0].AbsoluteIndex;
  iTo := LastPosterity.AbsoluteIndex;
  if AFree then FChildList.Clear;
  // 将这些节点从主列表中删除
  for I := iTo downto iFrom do
  begin
    vNode := Owner.Items[I];
    Owner.ItemNotify(tnDelete, I, 1);
    Owner.FSelectList.Remove(vNode);
    Owner.FMajorList.Delete(I);
    if AFree then vNode.Free;
  end;
  Owner.Renumber(iFrom, Owner.Count - 1);
  Owner.NotifyNodeChange(eNode,tnDelete,-1);
end;

destructor TMFSchemeTreeNode.Destroy;
begin

  if Assigned(FChildList) then
    FreeAndNil(FChildList);
  if Assigned(FValues) then
    FreeAndNil(FValues);
  inherited;
end;

function TMFSchemeTreeNode.DownLevel: Boolean;
var
  vPreSibling: TMFSchemeTreeNode;
begin
  Result := False;

  vPreSibling := PrevSibling;
  if (vPreSibling = nil) or not CanDownLevel then Exit;

  SafeParent.ChildList.Remove(Self);
  FParent := vPreSibling;
  vPreSibling.ChildList.Add(Self);

  // 展开父节点
  FParent.Expanded := True;
  Owner.ItemNotify(tnLevel, AbsoluteIndex, 1);
  Result := True;
end;

function TMFSchemeTreeNode.DownMove: Boolean;
var
  iBeginIndex: Integer;
  iEndIndex: Integer;
  iToIndex: Integer;
  I: Integer;
begin
  Result := False;
  if (not CanDownMove) or (NextSibling = nil) then Exit;

  iBeginIndex := AbsoluteIndex;
  if HasChildren then
    iEndIndex := LastPosterity.AbsoluteIndex
  else
    iEndIndex := iBeginIndex;
  if NextSibling.HasChildren then
    iToIndex := NextSibling.LastPosterity.AbsoluteIndex
  else
    iToIndex := NextSibling.AbsoluteIndex;

  for I := iBeginIndex to iEndIndex do
    Owner.FMajorList.Move(iBeginIndex, iToIndex);

  // 交换节点在父节点的节点列表中的位置
  SafeParent.ChildList.Exchange(RelativeIndex, RelativeIndex + 1);

  // 重新编排节点的序号
  Owner.BeginUpdate;
  Owner.Renumber(iBeginIndex, iToIndex);
  Owner.EndUpdate;

  Owner.ItemNotify(tnMove, iBeginIndex, 1, 1);

  for I := iBeginIndex to iToIndex do
    Owner.ItemNotify(tnVisible, I, 1);

  Owner.ItemNotify(tnSelect, AbsoluteIndex, 1, 0);

  Result := True;
end;

function TMFSchemeTreeNode.Expand: Boolean;
begin
  Result := not Expanded;
  Expanded := True;
end;

function TMFSchemeTreeNode.FindItem(I: Integer): TMFSchemeTreeNode;
begin
  if (FChildList <> nil) and (I >= 0) and (I < FChildList.Count) then
    Result := TMFSchemeTreeNode(FChildList[I])
  else
    Result := nil;
end;

function TMFSchemeTreeNode.GetChild(I: Integer): TMFSchemeTreeNode;
begin
  Result := FindItem(I);
  if Result = nil then
    Owner.Error(Format('Index out of Bounds(%d)', [I]));
end;

function TMFSchemeTreeNode.GetChildNodes(AIndex: Integer): TMFSchemeTreeNode;
begin
  Result := FindItem(AIndex);
  if Result = nil then
    Owner.Error(Format('Index out of Bounds(%d)', [AIndex]));
end;

function TMFSchemeTreeNode.GetCount: Integer;
begin
  if FChildList = nil then
    Result := 0
  else
    Result := FChildList.Count;
end;

function TMFSchemeTreeNode.GetExpanded: Boolean;
begin
  Result := FExpanded;// and FVisible;
end;

function TMFSchemeTreeNode.GetFirstChild: TMFSchemeTreeNode;
begin
  Result := FindItem(0);
end;

function TMFSchemeTreeNode.GetFirstSibling: TMFSchemeTreeNode;
begin
  Result := SafeParent.FirstChild;
end;

function TMFSchemeTreeNode.GetHasChildren: Boolean;
begin
  Result := (FChildList <> nil) and (FChildList.Count > 0);
end;


function TMFSchemeTreeNode.GetHeight: Integer;
begin
  Result:=FHeight;
  if  Owner.Parent is TMFBaseScheme then
    TMFBaseScheme(Owner.Parent).SetNodeHeight(Self,Result);
end;

function TMFSchemeTreeNode.GetLastChild: TMFSchemeTreeNode;
begin
  if (FChildList <> nil) and (FChildList.Count > 0) then
    Result := TMFSchemeTreeNode(FChildList.Last)
  else
    Result := nil;
end;

function TMFSchemeTreeNode.GetLastPosterity: TMFSchemeTreeNode;
begin
  Result := LastChild;
  if Result = nil then Exit;
  while Result.LastChild <> nil do
    Result := Result.LastChild;
end;

function TMFSchemeTreeNode.GetLastSibling: TMFSchemeTreeNode;
begin
  Result := SafeParent.LastChild;
end;

function TMFSchemeTreeNode.GetLevel: Integer;
var
  vNode: TMFSchemeTreeNode;
begin
  vNode := Self;
  Result := 0;
  while vNode.Parent <> nil do
  begin
    Inc(Result);
    vNode := vNode.Parent;
  end;
end;

function TMFSchemeTreeNode.GetMinorIndex: Integer;
begin
  Result := SafeParent.FChildList.IndexOf(Self);
end;

function TMFSchemeTreeNode.GetNextNode: TMFSchemeTreeNode;
begin
  Result := Owner.FindItem(FMajorIndex + 1);
end;

function TMFSchemeTreeNode.GetNextSibling: TMFSchemeTreeNode;
begin
  Result := SafeParent.FindItem(RelativeIndex + 1);
end;

function TMFSchemeTreeNode.GetPosterityCount: Integer;
var
  vNode: TMFSchemeTreeNode;
begin
  Result := 0;
  vNode := Self;

  while vNode <> nil do
  begin
    Inc(Result, vNode.ChildCount);
    vNode := vNode.LastChild;
  end;
end;

function TMFSchemeTreeNode.GetPrevNode: TMFSchemeTreeNode;
begin
  Result := Owner.FindItem(AbsoluteIndex - 1);
end;

function TMFSchemeTreeNode.GetPrevSibling: TMFSchemeTreeNode;
begin
  Result := SafeParent.FindItem(RelativeIndex - 1);
end;

function TMFSchemeTreeNode.GetSelected: Boolean;
begin
  Result := FOwner.FSelectList.IndexOf(self)>-1;
end;

function TMFSchemeTreeNode.GetValues(const AName: string): string;
begin
//  if Owner.ShowNotFindValueError then
//    raise EMFSchemeTree.Create(Format('字段%d不存在]', [AName]))
//  else
//    Result := Null;
  if not Assigned(FValues) then
    FValues:=TStringList.Create;
  Result:=FValues.Values[AName];
end;


function TMFSchemeTreeNode.IsLastVisibleNode: Boolean;
begin
  if Owner.LastVisibleNode=Self then
    Result :=True
  else
    Result :=False;
end;

function TMFSchemeTreeNode.IsNotVisibleOrHide: Boolean;
begin
  Result := (not Visible or Hide);
end;

procedure TMFSchemeTreeNode.MoveTo(Destination: TMFSchemeTreeNode;
  Mode: TNodeMoveType);
var
  I: Integer;
  vSibling: TMFSchemeTreeNode;
  iIndex,iSelf,iEnd: Integer;
  vOldPrevSibling: TMFSchemeTreeNode;
begin
  iSelf:=AbsoluteIndex;
  case Mode of
    nmtAdd	:begin
		   {if FParent<>nil then
		     FParent.FChildList.Delete(RelativeIndex);
		   FParent:= Destination.Parent;
		   FParent.FChildList.Add(Self);

		   Owner.FMajorList.Move

		   Owner.BeginUpdate;
		   Owner.Renumber(iToIndex, iEndIndex);
		   Owner.EndUpdate; }
		 end;
    nmtAddFirst	:  ;

    nmtAddChild	:  ;

    nmtAddChildFirst: ;

    nmtInsert	:  ;

  end;
end;

function TMFSchemeTreeNode.SafeParent: TMFSchemeTreeNode;
begin
  if FParent = nil then
    Result := FOwner.FVirtualRoot
  else
    Result := FParent;
end;

procedure TMFSchemeTreeNode.SetCaption(const Value: string);
begin
  if FCaption<>Value then
  begin
    FCaption := Value;
    FOwner.NotifyNodeChange(eNode,tnCaption,AbsoluteIndex);
  end;
end;

procedure TMFSchemeTreeNode.SetExpanded(const Value: Boolean);
  procedure ExpandNode(ANode: TMFSchemeTreeNode);
  var
    I: Integer;
  begin
    for I := 0 to ANode.ChildCount - 1 do
    begin
      ANode.ChildNodes[I].SetVisible(True);
      if ANode.ChildNodes[I].FExpanded then ExpandNode(ANode.ChildNodes[I]);
    end;
    ANode.FExpanded := True;
  end;
var
  I: Integer;
  vParent: TMFSchemeTreeNode;
begin
  if Value then  // 展开
  begin
    Owner.BeginUpdate;
    vParent := Parent;
    while (vParent <> nil) and (not vParent.Expanded) do
    begin
      vParent.Expanded := True;
      vParent := vParent.Parent;
    end;

    ExpandNode(Self);
    Owner.EndUpdate;
    Owner.NotifyNodeChange(eNode,tnExpand,AbsoluteIndex);
  end
  else // 合拢
  begin
    Owner.BeginUpdate;
    if not (HasChildren) then Exit;

    for I := AbsoluteIndex + 1 to LastPosterity.AbsoluteIndex do
    begin
      Owner.Items[I].SetVisible(False);
    end;
    FExpanded := False;
    Owner.EndUpdate;
    Owner.NotifyNodeChange(eNode,tnCollapse,AbsoluteIndex);
  end;

  Owner.ItemNotify(tnExpand, AbsoluteIndex, 1);
end;

procedure TMFSchemeTreeNode.SetHeight(const Value: Integer);
begin
  if FHeight<>Value then
  begin
    FHeight := Value;
    FOwner.NotifyNodeChange(eNode,tnHeight,AbsoluteIndex);
  end;
end;

procedure TMFSchemeTreeNode.SetHide(const Value: Boolean);
begin
  if  FHide<>Value then
  begin
    FHide := Value;
    FOwner.NotifyNodeChange(eNode,tnHide,AbsoluteIndex);
  end;
end;

procedure TMFSchemeTreeNode.SetImageIndex(const Value: integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex:= Value;
    FOwner.NotifyNodeChange(eNode,tnImageIndex,AbsoluteIndex);
  end;
end;

procedure TMFSchemeTreeNode.SetLevel(const Value: Integer);
var
  iLevel: Integer;
begin
  iLevel := Level;
  if Value > iLevel then
    while (Value > iLevel) and DownLevel do iLevel := Level
  else
    while (Value < iLevel) and UpLevel do iLevel := Level;
end;


procedure TMFSchemeTreeNode.SetSelected(const Value: Boolean);
begin
  with FOwner do
  begin
    if Value then
    begin
      if FSelectList.IndexOf(self)=-1 then FSelectList.Add(Self);
    end
    else
      if FSelectList.IndexOf(self)>-1 then
	FSelectList.Delete(FSelectList.IndexOf(self));
    FOwner.NotifyNodeChange(eNode,tnSelect,AbsoluteIndex);
  end;

end;

procedure TMFSchemeTreeNode.SetSelectedIndex(const Value: integer);
begin
  if FSelectedIndex <> Value then
  begin
    FSelectedIndex:= Value;
    FOwner.NotifyNodeChange(eNode,tnImageIndex,AbsoluteIndex);
  end;
end;

procedure TMFSchemeTreeNode.SetValues(const AName: string; const Value: string);
var I:Integer;
begin
//  if Owner.ShowNotFindValueError then
//    raise EMFSchemeTree.Create(Format('字段%d不存在]', [AName]));
  if not Assigned(FValues) then
    FValues:=TStringList.Create;
  i:=FValues.IndexOfName(AName);
  if i>-1 then
    FValues.Values[AName]:=Value
  else
    FValues.Add(AName+'='+Value);
end;

function TMFSchemeTreeNode.GetVisible: Boolean;
begin
  if Parent = nil then
    Result := FVisible
  else
    Result := FVisible and Parent.Visible;
end;

procedure TMFSchemeTreeNode.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Owner.ItemNotify(tnVisible, AbsoluteIndex, 1);
    Owner.NotifyNodeChange(eNode,tnVisible,AbsoluteIndex);
  end;
end;

function TMFSchemeTreeNode.UpLevel: Boolean;
var
  I: Integer;
  vSibling: TMFSchemeTreeNode;
  iIndex: Integer;
  vOldPrevSibling: TMFSchemeTreeNode;
begin
  Result := False;

  if (FParent = nil) or not CanUpLevel then Exit;

  vOldPrevSibling := Self.PrevSibling;
  // 将其后面的兄弟都收编为自己的子节点
  iIndex := RelativeIndex + 1;
  for I := RelativeIndex + 1 to FParent.ChildList.Count - 1 do
  begin
    vSibling := FParent.ChildList[iIndex];
    ChildList.Add(vSibling);
    vSibling.FParent := Self;
    FParent.ChildList.Delete(iIndex);
  end;
  // 将自己从父节点的列表中删除，并插入到祖父节点的列表中
  FParent.ChildList.Remove(Self);
  FParent.SafeParent.ChildList.Insert(FParent.RelativeIndex + 1, Self);
  FParent := FParent.FParent;
  Result := True;
  Owner.ItemNotify(tnLevel, AbsoluteIndex, 1);
end;

function TMFSchemeTreeNode.UpMove: Boolean;
var
  iBeginIndex: Integer;
  iEndIndex: Integer;
  iToIndex: Integer;
  I: Integer;
begin
  Result := False;
  if (not CanUpMove) or (PrevSibling = nil) then Exit;

  iBeginIndex := AbsoluteIndex;
  if HasChildren then
    iEndIndex := LastPosterity.AbsoluteIndex
  else
    iEndIndex := iBeginIndex;
  iToIndex := PrevSibling.AbsoluteIndex;

  for I := iBeginIndex to iEndIndex do
    Owner.FMajorList.Move(I, iToIndex + I - iBeginIndex);

  // 交换节点在父节点的节点列表中的位置
  SafeParent.ChildList.Exchange(RelativeIndex, RelativeIndex - 1);

  // 重新编排节点的序号
  Owner.BeginUpdate;
  Owner.Renumber(iToIndex, iEndIndex);
  Owner.EndUpdate;

  Owner.ItemNotify(tnMove, iBeginIndex, 1, -1);

  for I := iToIndex to iEndIndex do
    Owner.ItemNotify(tnVisible, I, 1);

  Owner.ItemNotify(tnSelect, AbsoluteIndex, 1, 0);
  Result := True;
end;

{ TMFBaseSchemeView }

constructor TMFBaseSchemeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWindowProc := WndProc;
  FControlStyle := [csCaptureMouse, csClickEvents, csSetCaption, csDoubleClicks];
  FReadOnly:=False;
  FParentScheme:=nil;
  BeginUpdate;
  InIt;
end;

destructor TMFBaseSchemeView.Destroy;
begin
  FFootOptions.Free;
  FHeadOptions.Free;
  FIndicaterOptions.Free;
  FTreeOptions.Free;
  //FContentOptions.Free;

  inherited;
end;

procedure TMFBaseSchemeView.GetChildren(Proc: TGetChildProc;
  Root: TComponent);
begin
  inherited;

end;

function TMFBaseSchemeView.GetClientRect: TRect;
begin
  if ParentScheme<>nil then
   Result:=ParentScheme.ClientRect;
end;

function TMFBaseSchemeView.GetEnabled: Boolean;
begin
  if ParentScheme<>nil then
    Result:=ParentScheme.Enabled;
end;

function TMFBaseSchemeView.GetFocused: Boolean;
begin
  if ParentScheme<>nil then
    Result:=ParentScheme.Focused ;
end;

function TMFBaseSchemeView.GetOffSetPoint: TPoint;
begin
  if ParentScheme<>nil then
    Result := Point(ParentScheme.RealLeft,ParentScheme.RealTop);
end;

function TMFBaseSchemeView.GetOnDblClick: TNotifyEvent;
begin
  Result:=FOnDblClick;
end;

function TMFBaseSchemeView.GetOnDragDrop: TDragDropEvent;
begin
  Result:=FOnDragDrop;
end;

function TMFBaseSchemeView.GetOnDragOver: TDragOverEvent;
begin
  Result:=FOnDragOver;
end;

function TMFBaseSchemeView.GetOnEndDrag: TEndDragEvent;
begin
  Result:=FOnEndDrag;
end;

function TMFBaseSchemeView.GetOnKeyDown: TKeyEvent;
begin
  Result:=FOnKeyDown;
end;

function TMFBaseSchemeView.GetOnKeyPress: TKeyPressEvent;
begin
  Result:=FOnKeyPress;
end;

function TMFBaseSchemeView.GetOnKeyUp: TKeyEvent;
begin
  Result:=FOnKeyUp;
end;

function TMFBaseSchemeView.GetOnMouseDown: TMouseEvent;
begin
  Result:=FOnMouseDown;
end;

function TMFBaseSchemeView.GetOnMouseMove: TMouseMoveEvent;
begin
  Result:=FOnMouseMove;
end;

function TMFBaseSchemeView.GetOnMouseUp: TMouseEvent;
begin
  Result:=FOnMouseUp;
end;

function TMFBaseSchemeView.GetOnMouseWheel: TMouseWheelEvent;
begin
  Result:=FOnMouseWheel;
end;

function TMFBaseSchemeView.GetOnMouseWheelDown: TMouseWheelUpDownEvent;
begin
  Result:=FOnMouseWheelDown;
end;

function TMFBaseSchemeView.GetOnMouseWheelUp: TMouseWheelUpDownEvent;
begin
  Result:=FOnMouseWheelUp;
end;

function TMFBaseSchemeView.GetOnStartDrag: TStartDragEvent;
begin
  Result:=FOnStartDrag;
end;

function TMFBaseSchemeView.GetParentComponent: TComponent;
begin
  Result := Parent;
end;

function TMFBaseSchemeView.GetConfigureText: String;
begin
  Result:=ConfigureToText(Self);
end;

procedure TMFBaseSchemeView.SetConfigureText(Value: string);
begin
  TextToConfigure(Value,Self);
end;

function TMFBaseSchemeView.GetRealRect: TRect;
begin
  Result := GetClientRect;
  OffsetRect(Result,-GetOffSetPoint.X,-GetOffSetPoint.y);
end;


function TMFBaseSchemeView.GetTabStop: Boolean;
begin
  Result:= FTabStop;
end;

function TMFBaseSchemeView.GetVisible: Boolean;
begin
  Result:=FVisible;
end;

function TMFBaseSchemeView.GetWholeHeight: Integer;
begin
  Result:=GetClientRect.Bottom ;
end;

function TMFBaseSchemeView.GetWholeRect: TRect;
begin
  if ParentScheme<>nil then
  Result:= Rect(0,0,GetWholeWidth,GetWholeHeight) ;
end;

function TMFBaseSchemeView.GetWholeWidth: Integer;
begin
  Result:=GetClientRect.Right ;
end;

function TMFBaseSchemeView.HasParent: Boolean;
begin
  Result := Parent <> nil;
end;

procedure TMFBaseSchemeView.InIt;
begin
  FNotifyChange:=True;
  FFootOptions:=TMFFootOptions.Create(self);
  FHeadOptions:=TMFHeadOptions.Create(self);
  FIndicaterOptions:=TMFIndicaterOptions.Create(self);
  FTreeOptions:=TMFTreeOptions.Create(self);
  //FContentOptions:=TMFContentOptions.Create;
end;

procedure TMFBaseSchemeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) then
  begin
    if (FParentScheme=AComponent) then FParentScheme:=nil;
    if (FImages=AComponent) then FImages:=nil;
  end;
end;

procedure TMFBaseSchemeView.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  Parent := Reader.Parent;
end;

procedure TMFBaseSchemeView.SetEnabled(const Value: Boolean);
begin
  ParentScheme.Enabled :=Value;
end;

procedure TMFBaseSchemeView.SetFocused(const Value: Boolean);
begin
  if ParentScheme<>nil then
  if Value then
    ParentScheme.SetFocus;

end;

procedure TMFBaseSchemeView.SetOnDblClick(const Value: TNotifyEvent);
begin
  FOnDblClick := Value;
end;

procedure TMFBaseSchemeView.SetOnDragDrop(const Value: TDragDropEvent);
begin
  FOnDragDrop := Value;
end;

procedure TMFBaseSchemeView.SetOnDragOver(const Value: TDragOverEvent);
begin
  FOnDragOver := Value;
end;

procedure TMFBaseSchemeView.SetOnEndDrag(const Value: TEndDragEvent);
begin
  FOnEndDrag := Value;
end;

procedure TMFBaseSchemeView.SetOnKeyDown(const Value: TKeyEvent);
begin
  FOnKeyDown := Value;
end;

procedure TMFBaseSchemeView.SetOnKeyPress(const Value: TKeyPressEvent);
begin
  FOnKeyPress := Value;
end;

procedure TMFBaseSchemeView.SetOnKeyUp(const Value: TKeyEvent);
begin
  FOnKeyUp := Value;
end;

procedure TMFBaseSchemeView.SetOnMouseDown(const Value: TMouseEvent);
begin
  FOnMouseDown := Value;
end;

procedure TMFBaseSchemeView.SetOnMouseMove(const Value: TMouseMoveEvent);
begin
  FOnMouseMove := Value;
end;

procedure TMFBaseSchemeView.SetOnMouseUp(const Value: TMouseEvent);
begin
  FOnMouseUp := Value;
end;

procedure TMFBaseSchemeView.SetOnMouseWheel(
  const Value: TMouseWheelEvent);
begin
  FOnMouseWheel := Value;
end;

procedure TMFBaseSchemeView.SetOnMouseWheelDown(
  const Value: TMouseWheelUpDownEvent);
begin
  FOnMouseWheelDown := Value;
end;

procedure TMFBaseSchemeView.SetOnMouseWheelUp(
  const Value: TMouseWheelUpDownEvent);
begin
  FOnMouseWheelUp := Value;
end;

procedure TMFBaseSchemeView.SetOnStartDrag(const Value: TStartDragEvent);
begin
  FOnStartDrag := Value;
end;

procedure TMFBaseSchemeView.SetParent(const Value: TComponent);
begin
  FParent := Value;
  if Value is TMFBaseScheme then
  begin
    TMFBaseScheme(Value).AddChildComponent(Self);
  end
  else
    raise Exception.Create('Parent Must Be A TMFBaseScheme Class ');
end;

procedure TMFBaseSchemeView.SetParentComponent(AParent: TComponent);
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    Parent := TMFBaseScheme(AParent);
    if AParent is TMFBaseScheme then
      TMFBaseScheme(AParent).AddChildComponent(Self);
  end;
end;

procedure TMFBaseSchemeView.SetParentScheme(const Value: TMFBaseScheme);
var OldParentScheme:TMFBaseScheme;
begin
  if  FParentScheme <> Value then
  begin
    OldParentScheme := FParentScheme;
    FParentScheme:=Value;

    if OldParentScheme<>nil then
    begin
      OldParentScheme.Perform(WM_ActiveViewChange,0,0);

    end;

    if Assigned(FParentScheme) then
    begin
      FParentScheme.FreeNotification(self);
    end;
  end;
  
  if Value<>nil then
    Value.ShowHint:=ShowHint;
end;

procedure TMFBaseSchemeView.SetTabStop(const Value: Boolean);
begin
  FTabStop := Value;
end;

procedure TMFBaseSchemeView.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;


procedure TMFBaseSchemeView.WMLButtonDown(var Message: TWMLButtonDown);
begin
  //ShowMessage('ok');
  //if csCaptureMouse in ControlStyle then MouseCapture := True;
  //if csClickEvents in ControlStyle then Include(FControlState, csClicked);
  DoMouseDown(Message, mbLeft, []);
end;

procedure TMFBaseSchemeView.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  //if csCaptureMouse in ControlStyle then MouseCapture := True;
  //if csClickEvents in ControlStyle then
  DblClick;
  //DoMouseDown(Message, mbLeft, [ssDouble]);
end;


procedure TMFBaseSchemeView.CMDesignHitTest(
  var Message: TCMDesignHitTest);
begin

end;

procedure TMFBaseSchemeView.CMHintShow(var Message: TMessage);
begin

end;

procedure TMFBaseSchemeView.CMHitTest(var Message: TCMHitTest);
begin

end;

procedure TMFBaseSchemeView.CMMouseEnter(var Message: TMessage);
begin

end;

procedure TMFBaseSchemeView.CMMouseLeave(var Message: TMessage);
begin

end;

procedure TMFBaseSchemeView.WMContextMenu(var Message: TWMContextMenu);
begin

end;

procedure TMFBaseSchemeView.WMLButtonUp(var Message: TWMLButtonUp);
begin
  DoMouseUp(Message, mbLeft);
end;

procedure TMFBaseSchemeView.WMMButtonDblClk(
  var Message: TWMMButtonDblClk);
begin

end;

procedure TMFBaseSchemeView.WMMButtonDown(var Message: TWMMButtonDown);
begin
  DoMouseDown(Message, mbMiddle, []);
end;

procedure TMFBaseSchemeView.WMMButtonUp(var Message: TWMMButtonUp);
begin
  DoMouseUp(Message, mbMiddle);
end;

procedure TMFBaseSchemeView.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  if not (csNoStdEvents in ControlStyle) then
    with Message do
	MouseMove(KeysToShiftState(Keys), Message.XPos, Message.YPos);
end;

procedure TMFBaseSchemeView.WMMouseWheel(var Message: TWMMouseWheel);
begin
  if not Mouse.WheelPresent then
  begin
    //Mouse.WheelPresent := True;
    Mouse.SettingChanged(SPI_GETWHEELSCROLLLINES);
  end;
  TCMMouseWheel(Message).ShiftState := KeysToShiftState(Message.Keys);
  MouseWheelHandler(TMessage(Message));
  if Message.Result = 0 then inherited;
end;

procedure TMFBaseSchemeView.WMRButtonDblClk(
  var Message: TWMRButtonDblClk);
begin
  DoMouseDown(Message, mbRight, [ssDouble]);
end;

procedure TMFBaseSchemeView.WMRButtonDown(var Message: TWMRButtonDown);
begin
  DoMouseDown(Message, mbRight, []);
end;

procedure TMFBaseSchemeView.WMRButtonUp(var Message: TWMRButtonUp);
begin
  DoMouseUp(Message, mbRight);
end;

procedure TMFBaseSchemeView.WndProc(var Message: TMessage);
begin

  Dispatch(Message);
end;

procedure TMFBaseSchemeView.MouseWheelHandler(var Message: TMessage);
var
  Form: TCustomForm;
begin
  Form := GetParentForm(ParentScheme);
  if (Form <> nil)  then Form.MouseWheelHandler(TMessage(Message))
  else with TMessage(Message) do
  begin
    WndProc(Message);
    Result := Message.Result;
  end;
end;

procedure TMFBaseSchemeView.Click;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TMFBaseSchemeView.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
end;

procedure TMFBaseSchemeView.DblClick;
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

function TMFBaseSchemeView.CalcCursorPos: TPoint;
begin
  GetCursorPos(Result);
  Windows.ScreenToClient(ParentScheme.Handle,Result);
end;

procedure TMFBaseSchemeView.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then FOnMouseDown(Self,Button,Shift,X,Y);
end;

procedure TMFBaseSchemeView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then FOnMouseMove(Self,Shift,X,Y);
end;

procedure TMFBaseSchemeView.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then FOnMouseUp(Self,Button,Shift,X,Y);
end;

procedure TMFBaseSchemeView.DoMouseDown(var Message: TWMMouse;
  Button: TMouseButton; Shift: TShiftState);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
      if (ParentScheme.Width > 32768) or (ParentScheme.Height > 32768) then
	with CalcCursorPos do
	  Self.MouseDown(Button, KeysToShiftState(Keys) + Shift, X, Y)
      else
	Self.MouseDown(Button, KeysToShiftState(Keys) + Shift, Message.XPos, Message.YPos);
end;

procedure TMFBaseSchemeView.DoMouseUp(var Message: TWMMouse;
  Button: TMouseButton);
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do Self.MouseUp(Button, KeysToShiftState(Keys), XPos, YPos);
end;

function TMFBaseSchemeView.GetMouseCapture: Boolean;
begin
  Result := GetCaptureControl = ParentScheme;
end;

procedure TMFBaseSchemeView.SetMouseCapture(const Value: Boolean);
begin
  if MouseCapture <> Value then
    if Value then SetCaptureControl(ParentScheme) else SetCaptureControl(nil);
end;

procedure TMFBaseSchemeView.WMKeyDown(var Message: TWMKeyDown);
begin
 DoKeyDown(Message);
end;

procedure TMFBaseSchemeView.WMKeyUp(var Message: TWMKeyUp);
begin
  DoKeyUp(Message);
end;

procedure TMFBaseSchemeView.WMSysKeyDown(var Message: TWMKeyDown);
begin
  DoKeyDown(Message);
end;

procedure TMFBaseSchemeView.WMSysKeyUp(var Message: TWMKeyUp);
begin
  DoKeyUp(Message);
end;

procedure TMFBaseSchemeView.CMEnter(var Message: TCMEnter);
begin
  DoEnter;
end;

procedure TMFBaseSchemeView.CMExit(var Message: TCMExit);
begin
  DoExit;
end;

procedure TMFBaseSchemeView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) then FOnKeyDown(Self,Key ,Shift);
end;

procedure TMFBaseSchemeView.KeyPress(var Key: Char);
begin
  if Assigned(FOnKeyPress) then FOnKeyPress(Self,Key );
end;

procedure TMFBaseSchemeView.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyUp) then FOnKeyUp(Self,Key,Shift );

end;

procedure TMFBaseSchemeView.DoEnter;
begin
  if Assigned(FOnEnter) then FOnEnter(Self);
end;

procedure TMFBaseSchemeView.DoExit;
begin
  if Assigned(FOnExit) then FOnExit(Self);
end;

procedure TMFBaseSchemeView.SetOnEnter(const Value: TNotifyEvent);
begin
  FOnEnter := Value;
end;

procedure TMFBaseSchemeView.SetOnExit(const Value: TNotifyEvent);
begin
  FOnExit := Value;
end;

function TMFBaseSchemeView.GetOnEnter: TNotifyEvent;
begin
  Result:=FOnEnter;
end;

function TMFBaseSchemeView.GetOnExit: TNotifyEvent;
begin
  Result:=FOnExit;
end;

function TMFBaseSchemeView.DoKeyDown(var Message: TWMKey): Boolean;
var
  ShiftState: TShiftState;
begin
  with Message do
  begin
    ShiftState := KeyDataToShiftState(KeyData);
    if not (csNoStdEvents in ControlStyle) then
    begin
      Self.KeyDown(CharCode, ShiftState);
      if CharCode = 0 then Exit;
    end;
  end;
  Result := False;
end;

function TMFBaseSchemeView.DoKeyPress(var Message: TWMKey): Boolean;
var
  Ch: Char;
begin
  if not (csNoStdEvents in ControlStyle) then
    with Message do
    begin
      Ch := Char(CharCode);
      Self.KeyPress(Ch);
      CharCode := Word(Ch);
      if Char(CharCode) = #0 then Exit;
    end;
  Result := False;
end;

function TMFBaseSchemeView.DoKeyUp(var Message: TWMKey): Boolean;
var
  ShiftState: TShiftState;
begin
  with Message do
  begin
    ShiftState := KeyDataToShiftState(KeyData);
    if not (csNoStdEvents in ControlStyle) then
    begin
      Self.KeyUp(CharCode, ShiftState);
      if CharCode = 0 then Exit;
    end;
  end;
  Result := False;
end;

procedure TMFBaseSchemeView.WMChar(var Message: TWMChar);
begin
  DoKeyPress(Message);
end;

procedure TMFBaseSchemeView.CMWantSpecialKey(
  var Message: TCMWantSpecialKey);
begin
  DoSpecialKey(Message);
end;

function TMFBaseSchemeView.DoSpecialKey(var Message: TWMKey): Boolean;
begin
 // Message.Result:=1;
end;

function TMFBaseSchemeView.GetParentScheme: TMFBaseScheme;
begin
  //Result:=FParentScheme;
  if FParentScheme<>nil then
    Result:=FParentScheme
  else
    raise Exception.Create('当前View不是激活的View');

end;

procedure TMFBaseSchemeView.BeginUpdate;
begin
  FNotifyChange:=False;
end;

procedure TMFBaseSchemeView.CancelUpdate;
begin
  FNotifyChange:=True;
end;

procedure TMFBaseSchemeView.EndUpdate;
begin
  FNotifyChange:=True;
  Update;
end;

function TMFBaseSchemeView.IsNotifyChange: Boolean;
begin
  Result:= FNotifyChange;
end;

procedure TMFBaseSchemeView.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

function TMFBaseSchemeView.ScreenToClient(APoint: TPoint): TPoint;
begin
  Result:=ParentScheme.ScreenToClient(APoint);
end;

function TMFBaseSchemeView.GetDataTreeClientRect(AItem: TMFSchemeDataItem;
  ANode: TMFSchemeDataTreeNode): TRect;
begin

end;

procedure TMFBaseSchemeView.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(FOnDragOver) then
    FOnDragOver(Self,Source,X, Y,State,Accept);
end;

procedure TMFBaseSchemeView.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Assigned(FOnDragDrop) then
    FOnDragDrop(Self,Source,X, Y);
end;

procedure TMFBaseSchemeView.DragCanceled;
begin

end;

procedure TMFBaseSchemeView.UpdateScroll;
begin
  if  FParentScheme<>nil then
    ParentScheme.UpdateScrollBars;
end;

procedure TMFBaseSchemeView.Update;
begin
  if FParentScheme<>nil then
  begin

    UpdateScroll;

    Invalidate;
  end;
end;

procedure TMFBaseSchemeView.WMTimer(var Msg: TWMTimer);
begin
  DoScrollTimer;
end;

procedure TMFBaseSchemeView.DoScrollTimer;
begin

end;

procedure TMFBaseSchemeView.TreeChanged(AEventType: TEventType;
  AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin

end;

procedure TMFBaseSchemeView.Invalidate;
begin
  if IsNotifyChange then
  if not (csLoading in ComponentState) then
  if (FParentScheme<>nil) then
    FParentScheme.Invalidate;
end;

procedure TMFBaseSchemeView.CalcScrollBar;
begin
  with ParentScheme do
  begin
    Self.Update;
    if VertScrollBar.Position> GetWholeHeight-GetClientRect.Bottom then
    begin
      VertScrollBar.Position :=GetWholeHeight-GetClientRect.Bottom;
      Self.Update;
    end;
    

    if HorzScrollBar.Position> GetWholeWidth-GetClientRect.Right then
    begin
      HorzScrollBar.Position :=GetWholeWidth-GetClientRect.Right;
      Self.Update;
    end;
  end;
end;

procedure TMFBaseSchemeView.ClearView;
begin
  with ParentScheme.Canvas do
  begin
    Brush.Color := ParentScheme.Color;
    Brush.Style := bsSolid;
    FillRect(GetClientRect);
  end;
end;

procedure TMFBaseSchemeView.AfterDragItemDown(Source: TObject;
  DragItem: TMFSchemeDataItem; OldNode:TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  if Assigned(FOnAfterDragItemDown) then
    FOnAfterDragItemDown(Source,DragItem,OldNode,Accept,X,Y);
end;

procedure TMFBaseSchemeView.PaintItem(Sender: TObject;
  Item: TMFSchemeDataItem; ACanvas: TCanvas; R: TRect);
begin
  if Assigned(FOnPaintItem) then
    FOnPaintItem(Sender,Item,ACanvas,R);

end;

procedure TMFBaseSchemeView.BeforDragItemDown(Source: TObject;
  DragItem: TMFSchemeDataItem; NewNode:TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  if Assigned(FOnBeforDragItemDown) then
    FOnBeforDragItemDown(Source,DragItem,NewNode,Accept,X,Y);
end;

procedure TMFBaseSchemeView.AdjustDragDrop(
  NewNode: TMFSchemeDataTreeNode; var AdjustMoveType: TAdjustMoveType;
  StartDataItem:TMFSchemeDataItem=Nil;EndDataItem:TMFSchemeDataItem=Nil);
begin
  if Assigned(FOnAdjustDragDrop) then
    FOnAdjustDragDrop(NewNode,AdjustMoveType,StartDataItem,EndDataItem);

end;

procedure TMFBaseSchemeView.DragDropNear(NewNode: TMFSchemeDataTreeNode;
  DragItem: TMFSchemeDataItem; var Space: Integer;
  var NearDateTime: TDateTime;DragDateTime: TDateTime; X, Y: Integer);
begin
  if Assigned(FOnDragDropNear) then
    FOnDragDropNear(NewNode,DragItem,Space,NearDateTime,DragDateTime,X,Y);

end;

procedure TMFBaseSchemeView.SetShowHint(const Value: Boolean);
begin
  if Assigned(FParentScheme) then
  begin
    ParentScheme.ShowHint:=Value;
  end;
  FShowHint := Value;
end;

function TMFBaseSchemeView.ClientToScreen(APoint: TPoint): TPoint;
begin
  Result:=ParentScheme.ClientToScreen(APoint);
end;

procedure TMFBaseSchemeView.SetHintData(Sender: TObject;
  AViewHitInfo: TViewHitInfo; var HintRec: THintRec; var R: TRect;
  ACanvas: TCanvas);
begin
  //bely 2008-04-07
  with AViewHitInfo do
  begin
    if AItem <> nil then
      HintRec.HintStr := AItem.Hint
    else if ANode <> nil then
      HintRec.HintStr := ANode.Hint;
  end;

  if Assigned(FOnSetHintData) then
    FOnSetHintData(Sender,AViewHitInfo,HintRec,R,ACanvas);
end;

procedure TMFBaseSchemeView.DragItemOver(Source: TObject;
  DragItem: TMFSchemeDataItem; NewNode: TMFSchemeDataTreeNode;
  var Accept: Boolean; X, Y: Integer);
begin
  if Assigned(FOnDragItemOver) then
    FOnDragItemOver(Source,DragItem,NewNode,Accept,X,Y);
end;

procedure TMFBaseSchemeView.SetNodeHeight(ANode: TMFSchemeTreeNode;
  var NodeHeight: Integer);
begin
  if Assigned(FOnSetNodeHeight) then
    FOnSetNodeHeight(ANode,NodeHeight);
end;



procedure TMFBaseSchemeView.AfterItemTimeChange(
  DataItem: TMFSchemeDataItem; ItemTimeChangeType: TItemTimeChangeType);
begin
  if Assigned(FOnAfterItemTimeChange) then
    FOnAfterItemTimeChange(DataItem,ItemTimeChangeType);

end;

procedure TMFBaseSchemeView.BeforItemTimeChange(
  DataItem: TMFSchemeDataItem; ItemTimeChangeType: TItemTimeChangeType;
  var NewTime: TDateTime; var Accept: Boolean);
begin
  if Assigned(FOnBeforItemTimeChange) then
    FOnBeforItemTimeChange(DataItem,ItemTimeChangeType,NewTime,Accept);

end;

procedure TMFBaseSchemeView.Loaded;
begin
  inherited;
  CancelUpdate;
end;

procedure TMFBaseSchemeView.SetComponentState(Value: TComponentState);
begin
  inherited;
   
end;

procedure TMFBaseSchemeView.DragOtherDrop(Source: TObject;
  AViewHitInfo: TViewHitInfo; X, Y: Integer);
begin
  if Assigned(FOnDragOtherDrop) then
    FOnDragOtherDrop(Source,AViewHitInfo,X,Y);
end;

procedure TMFBaseSchemeView.DragOtherOver(Source: TObject;
  AViewHitInfo: TViewHitInfo; var Accept: Boolean; X, Y: Integer);
begin
  if Assigned(FOnDragOtherOver) then
    FOnDragOtherOver(Source,AViewHitInfo,Accept,X,Y);
end;

procedure TMFBaseSchemeView.ItemSelectChanged(BeforeChange,
  Value: Boolean; AItem: TMFSchemeDataItem; var Accept: Boolean);
begin
  if Assigned(FOnItemSelectChange) then
    FOnItemSelectChange(Self,AItem,Accept);
end;

procedure TMFBaseSchemeView.DblClickView(Sender: TObject;
  AViewHitInfo: TViewHitInfo);
begin
  if Assigned(FOnDblClickView) then
    FOnDblClickView(Self,AViewHitInfo);
end;

procedure TMFBaseSchemeView.DragHint(Sender: TObject;ADateTime:TDateTime;
  AItem: TMFSchemeDataItem; AViewHitInfo: TViewHitInfo;
  var HintRec: THintRec; var ARect: TRect; ACanvas: TCanvas);
begin
  if Assigned(FOnDragHint) then
    FOnDragHint(Sender,ADateTime,AItem,AViewHitInfo,HintRec,ARect,ACanvas);
end;

procedure TMFBaseSchemeView.SetImages(const Value: TImageList);
begin
  if FImages<>Value then
  begin
    FImages := Value;
    if  FImages<>nil then
      FImages.RemoveFreeNotification(self);
    Self.Invalidate;
  end;
end;

procedure TMFBaseSchemeView.SetCaption(const Value: String);
begin
  if  FCaption<>Value then
  begin
    FCaption := Value;
    Self.Invalidate;
  end;
end;

function TMFBaseSchemeView.GetHintStr(AViewHitInfo: TViewHitInfo): String;
begin

end;

{ TMFSchemeTree }

function TMFSchemeTree.AddNode(AParent: TMFSchemeTreeNode;
  AIndex: Integer): TMFSchemeTreeNode;
begin
  if AParent = nil then
    Result := FVirtualRoot.AddChild(AIndex)
  else
    Result := AParent.AddChild(AIndex);
end;

function TMFSchemeTree.AddNode(AParent: TMFSchemeTreeNode;
  ACaption: String; AHeight, AIndex: Integer): TMFSchemeTreeNode;
begin
  BeginUpdate;
  if AParent = nil then
    Result := FVirtualRoot.AddChild(AIndex)
  else
    Result := AParent.AddChild(AIndex);
  Result.Height := AHeight;
  Result.Caption := ACaption;
  EndUpdate;
  NotifyNodeChange(eNode,tnAdd,Result.AbsoluteIndex);
end;

function TMFSchemeTree.AddNodeObject(AParent: TMFSchemeTreeNode;
  ACaption: String; AHeight: Integer;
  Ptr: Pointer): TMFSchemeTreeNode;
begin
  BeginUpdate;
  if AParent = nil then
    Result := FVirtualRoot.AddChild(-1)
  else
    Result := AParent.AddChild(-1);
  Result.Height := AHeight;
  Result.Caption := ACaption;
  Result.Data:= Ptr;
  EndUpdate;
  NotifyNodeChange(eNode,tnAdd,Result.AbsoluteIndex);
end;

procedure TMFSchemeTree.Assign(Source: TPersistent);
  procedure CreateTreeNode(Dest, Sour: TMFSchemeTreeNode);
  var
    I: Integer;
  begin
    if Sour.HasChildren then
    begin
      for I := 0 to Sour.ChildCount - 1 do
	CreateTreeNode(Dest.AddChild, Sour.ChildNodes[I])
    end
    else
      Dest.Assign(Sour);
  end;
begin
  if Source is TMFSchemeTree then
  begin
    BeginUpdate;
    try
      Clear;
      CreateTreeNode(FVirtualRoot, TMFSchemeTree(Source).FVirtualRoot);
    finally
      EndUpdate;
    end;
  end
  else inherited;
end;

procedure TMFSchemeTree.BeginUpdate;
begin
  FUpdateLock := True;
end;

procedure TMFSchemeTree.Clear;
begin
  FVirtualRoot.DeleteChildren;
end;

procedure TMFSchemeTree.ClearSelection(KeepPrimary: Boolean);
var I:Integer;
begin
  if KeepPrimary then
  begin
    for I:=FSelectList.Count-1 downto 1 do
      FSelectList.Delete(I);
  end
  else
    FSelectList.Clear;
end;

procedure TMFSchemeTree.CollapseAll;
  procedure CollapseNode(ANode: TMFSchemeTreeNode);
  var
    I: Integer;
  begin
    for I := 0 to ANode.ChildCount - 1 do
    begin
      CollapseNode(ANode.ChildNodes[I]);
    end;
    ANode.Collapse;
  end;
var
  I: Integer;
begin
  for I := 0 to RootItemCount - 1 do
    CollapseNode(RootItems[I]);
end;

constructor TMFSchemeTree.Create(AControl:TControl);
begin
  //if FItemClass = nil then FItemClass := TMFSchemeTreeNode;
  inherited Create;
  Create2(AControl,TMFSchemeTreeNode);
end;

constructor TMFSchemeTree.Create2(AControl:TControl;AItemClass: TMFSchemeTreeNodeClass);
begin
  FParent:= AControl;
  FItemClass := AItemClass;
  if FItemClass = nil then FItemClass := TMFSchemeTreeNode;
  FSelectList:=TList.Create;
  FMajorList := TList.Create;
  FVirtualRoot := TMFSchemeTreeNode.Create(Self);
  FVirtualRoot.FMajorIndex := -1;
  FVirtualRoot.FExpanded := True;
  FVirtualRoot.FVisible := True;
  FListeners := TZcTreeListenerManager.Create;
  FAutoExpand := True;

  FShowNotFindValueError := True;
end;

function TMFSchemeTree.CreateItem: TMFSchemeTreeNode;
begin
  Result := ItemClass.Create(Self);
end;

procedure TMFSchemeTree.Delete(I: Integer);
var
  vNode: TMFSchemeTreeNode;
begin
  if FindItem(I, vNode) then vNode.Delete;
end;

destructor TMFSchemeTree.Destroy;
begin
  BeginUpdate;
  Clear;
  FSelectList.Free;
  FMajorList.Free;
  FVirtualRoot.Free;
  FListeners.Free;
  inherited;
end;

procedure TMFSchemeTree.EndUpdate;
begin
  FUpdateLock := False;
end;

procedure TMFSchemeTree.Error(const Msg: string);
begin
  raise EMFSchemeTree.Create(Msg);
end;

function TMFSchemeTree.FindItem(I: Integer): TMFSchemeTreeNode;
begin
  if (I >= 0) and (I < FMajorList.Count) then
    Result := TMFSchemeTreeNode(FMajorList[I])
  else
    Result := nil;
end;

{procedure TMFSchemeTree.RemoveNotification(AListenerManager: TMFSchemeTreeListenerManager);
begin
  //Listeners.FFreeNotifies.Add(AListenerManager);
end;
}
function TMFSchemeTree.FindItem(I: Integer; var AItem: TMFSchemeTreeNode): Boolean;
begin
  if (I >= 0) and (I < FMajorList.Count) then
  begin
    AItem := TMFSchemeTreeNode(FMajorList[I]);
    Result := True;
  end
  else
    Result := False;
end;

function TMFSchemeTree.Get(AIndex: Integer): TMFSchemeTreeNode;
begin
  Result := FindItem(AIndex);
  if Result = nil then
    Error(Format('Index out of Bounds (%d)', [AIndex]));
end;

function TMFSchemeTree.GetCount: Integer;
begin
  Result := FMajorList.Count;
end;

function TMFSchemeTree.GetFirstNode: TMFSchemeTreeNode;
begin
  Result := FindItem(0);
end;

function TMFSchemeTree.GetIsUpdating: Boolean;
begin
  Result :=FUpdateLock;
end;

function TMFSchemeTree.GetItem(I: Integer): TMFSchemeTreeNode;
begin
  Result := FindItem(I);
  if Result = nil then
    Error(Format('Index out of Bounds (%d)', [I]));
end;

function TMFSchemeTree.GetItemClass: TMFSchemeTreeNodeClass;
begin
  if FItemClass = nil then
    FItemClass := TMFSchemeTreeNode;
  Result := FItemClass;
end;

function TMFSchemeTree.GetLastNode: TMFSchemeTreeNode;
begin
  if Count > 0 then Result := Items[Count - 1] else result := nil;
end;

function TMFSchemeTree.GetParent: TControl;
begin
  Result :=FParent;
end;

function TMFSchemeTree.GetRootItem(I: Integer): TMFSchemeTreeNode;
begin
  Result := FVirtualRoot.ChildNodes[I];
end;

function TMFSchemeTree.GetRootItemCount: Integer;
begin
  Result := FVirtualRoot.ChildCount;
end;

function TMFSchemeTree.GetSelected: TMFSchemeTreeNode;
begin
  if SelectionCount >0 then
    Result:= Selections[0]
  else
    Result:=nil;
end;

function TMFSchemeTree.GetSelectionCount: Integer;
begin
  Result:=FSelectList.Count;
end;

function TMFSchemeTree.GetSelections(index: Integer): TMFSchemeTreeNode;
begin
  Result:=TMFSchemeTreeNode(FSelectList.Items[index]);
end;

function TMFSchemeTree.GetTreeHeight(ANode: TMFSchemeTreeNode): Integer;
var I:Integer; iHeight:Integer;
begin
  iHeight:=0;
  if Assigned(FMajorList) then
  if Count>0 then
  begin
    if ANode=nil then ANode := Items[Count-1];
    for I:=0 to ANode.AbsoluteIndex  do
    begin
      if not Items[I].IsNotVisibleOrHide then
	iHeight:=iHeight+ Items[I].Height;
    end;
  end;
  Result := iHeight;

end;
procedure TMFSchemeTree.ItemNotify(AEvent: TMFSchemeTreeNotify;
  AIndex, ACount, AFlag: Integer);
begin
  //Listeners.TreeChanged(Self, AEvent, AIndex, ACount, AFlag);

  if not IsUpdating then
    FModified := True;
end;


function TMFSchemeTree.LastVisibleNode: TMFSchemeTreeNode;
var I:Integer;
begin
  Result := nil ;
  for I:=Count-1 downto 0  do
  if Items[i].Visible then
  begin
    Result := Items[i];
    Break;
  end;
end;


// 响应别的树发来的通知消息，是本树与发消息的树保持结构上的同步
procedure TMFSchemeTree.ItemSelectChanged(BeforeChange,Value:Boolean;AItem:TMFSchemeDataItem;
  var Accept:Boolean);
begin
  if Supports(FParent,IZcTreeChanger) then
  begin
    (FParent As IZcTreeChanger).ItemSelectChanged(BeforeChange,Value,AItem,Accept);
  end;
end;

procedure TMFSchemeTree.NotifyNodeChange(AEventType:TEventType ;AEvent: TMFSchemeTreeNotify; AIndex: Integer);
begin
  if not FUpdateLock then
  if Supports(FParent,IZcTreeChanger) then
  begin
    (FParent As IZcTreeChanger).TreeChanged(AEventType,AEvent,AIndex);
  end;
end;

procedure TMFSchemeTree.OnTreeChanged(Sender: TMFSchemeTree; AEvent: TMFSchemeTreeNotify;
  AIndex, ACount, AFlag: Integer);
  procedure CreateTreeNode(Dest, Sour: TMFSchemeTreeNode);
  var
    I: Integer;
  begin
    for I := 0 to Sour.ChildCount - 1 do
    begin
      if Sour.HasChildren then
	CreateTreeNode(Dest.AddChild, Sour.ChildNodes[I])
      else
	Dest.AddChild;
    end;
  end;
var
  Node: TMFSchemeTreeNode;
begin
  Listeners.FExcludeListener := Sender as IZcTreeListener;
  try
    case AEvent of
      tnAdd:
	begin
	  if AIndex = 0 then
	    AddNode(nil)
	  else
	  begin
	    Node := Items[AIndex -1];
	    Node := Node.SafeParent.AddChild(Node.RelativeIndex + 1);
	    Node.Level := Sender.Items[AIndex].Level;
	  end;
	end;
      tnDelete:
	begin
	  Items[AIndex].Delete;
	end;
      tnLevel:
	Items[AIndex].Level := Sender.Items[AIndex].Level;
      tnSync:
	begin
	  Clear;
	  if Sender.Count > 0 then
	    CreateTreeNode(AddNode(nil), Sender.Items[0]);
	end;
      tnMove:
	begin
	  if AFlag = -1 then Items[AIndex].UpMove else Items[AIndex].DownMove;
	end;
    end;
  finally
    Listeners.FExcludeListener := nil;
  end;
end;

procedure TMFSchemeTree.Renumber(AFromIndex, AToIndex: Integer);
var
  I: Integer;
  vNode: TMFSchemeTreeNode;
begin
  if AToIndex = -1 then AToIndex := FMajorList.Count - 1;
  for I := AFromIndex to Min(AToIndex, FMajorList.Count -1) do
  begin
    vNode := TMFSchemeTreeNode(FMajorList[I]);
    vNode.FMajorIndex := I;
    //vNode.TreeNodeChanged;
  end;
end;

procedure TMFSchemeTree.ResetMajorList;
begin

end;

procedure TMFSchemeTree.SetAutoExpand(const Value: Boolean);
begin
  FAutoExpand := Value;
end;

procedure TMFSchemeTree.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

procedure TMFSchemeTree.SetShowNotFindValueError(const Value: Boolean);
begin
  FShowNotFindValueError := Value;
end;

procedure TMFSchemeTree.SyncNotify;
begin
  ItemNotify(tnSync, 0, 0);
end;

procedure TMFSchemeTree.ExpandAll;
  procedure ExpandNode(ANode: TMFSchemeTreeNode);
  var
    I: Integer;
  begin
    for I := 0 to ANode.ChildCount - 1 do
    begin
      ExpandNode(ANode.ChildNodes[I]);
    end;
    ANode.Expand;
  end;
var
  I: Integer;
begin
  for I := 0 to RootItemCount - 1 do
    ExpandNode(RootItems[I]);
end;

{ TZcTreeListenerManager }

procedure TZcTreeListenerManager.Add(AListener: IZcTreeListener);
begin
  If FList.IndexOf(AListener) = -1 then
    FList.Add(AListener);
end;

constructor TZcTreeListenerManager.Create;
begin
  FList := TInterfaceList.Create;
end;

destructor TZcTreeListenerManager.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TZcTreeListenerManager.Remove(AListener: IZcTreeListener);
begin
  FList.Remove(AListener);
end;

procedure TZcTreeListenerManager.TreeChanged(Sender: TMFSchemeTree;
  AEvent: TMFSchemeTreeNotify; AIndex, ACount, AFlag: Integer);
var
  I: Integer;
begin
  {for I := 0 to FList.Count - 1 do
  begin
    if (FExcludeListener = nil) or (IZcTreeListener(FList[I]) <> FExcludeListener) then
      IZcTreeListener(FList[I]).OnTreeChanged(Sender, AEvent, AIndex, ACount, AFlag);
  end;  }
end;


{ TMFSchemeDataItem }

procedure TMFSchemeDataItem.Assign(Source: TPersistent);
begin
  inherited;
  if  Source is  TMFSchemeDataItem then
  begin
    //FUserData^:=TMFSchemeDataItem(Source).FUserData^;
    //FSysData^:=TMFSchemeDataItem(Source).FSysData^;;
    FVisible:=TMFSchemeDataItem(Source).FVisible;
    FPercent:=TMFSchemeDataItem(Source).FPercent;
    FIntervalDate:=TMFSchemeDataItem(Source).FIntervalDate;
    FBeginDate:=TMFSchemeDataItem(Source).FBeginDate;
    FText:=TMFSchemeDataItem(Source).FText;
    FModify:=TMFSchemeDataItem(Source).FModify;
    FReadOnly:=TMFSchemeDataItem(Source).FReadOnly;
    FColor:=TMFSchemeDataItem(Source).FColor;
    FCaptionPosition:=TMFSchemeDataItem(Source).FCaptionPosition;
    FLeftShapeType:=TMFSchemeDataItem(Source).FLeftShapeType;
    FRightShapeType:=TMFSchemeDataItem(Source).FRightShapeType;
  end;
end;

constructor TMFSchemeDataItem.Create(Parent: TMFSchemeDataTreeNode);
begin
  FUserData:=nil;
  FSysData :=nil;
  FColor := clWhite ;
  FEnabled:=True;
end;


destructor TMFSchemeDataItem.Destroy;
var I:Integer;
begin
  with TMFSchemeDataTree(Parent.FOwner) do
  begin
    NotifyItemLink(Self);
    Self.Parent.DeleteDataItem(Self);

    NotifyNodeChange(eItem,tnDelete,AbsoluteIndex);
  end;
  if Assigned(FValues) then
    FreeAndNil(FValues);  
  inherited;
end;

function TMFSchemeDataItem.GetAbsoluteIndex: Integer;
begin
  Result := TMFSchemeDataTree(Parent.Owner).FMajorDataItemList.IndexOf(self);
end;

function TMFSchemeDataItem.GetItemClientRect: TRect;
begin
  if Supports(Parent.Owner.Parent,IZcTreeChanger) then
    Result:=(Parent.Owner.Parent as IZcTreeChanger).GetDataTreeClientRect(Self,nil);
end;


function TMFSchemeDataItem.GetOffSetPoint: TPoint;
begin
  if Supports(Parent.Owner.Parent,IZcTreeChanger) then
    Result:=(Parent.Owner.Parent as IZcTreeChanger).GetOffSetPoint;
end;

function TMFSchemeDataItem.GetRelativeIndex: Integer;
begin
  Result := Parent.FDataItemList.IndexOf(self);

end;

function TMFSchemeDataItem.GetSelected: Boolean;
begin
  Result:=False;
  
  with TMFSchemeDataTree(Parent.FOwner) do
  if Assigned(FSelectItemList) then
  begin
    Result := FSelectItemList.IndexOf(self)>-1;
  end;
end;

function TMFSchemeDataItem.MoveTo(ADataItem:TMFSchemeDataItem;
  MoveType: TItemMoveType): Boolean;
begin
  FParent.FDataItemList.Delete(RelativeIndex);
  FParent:= ADataItem.Parent;

  Case MoveType of
    imtAdd:FParent.FDataItemList.Add(self);

    imtAddFirst: FParent.FDataItemList.Insert(0,self);

    imtInsert:FParent.FDataItemList.Insert(ADataItem.RelativeIndex,self);

  end;

  TMFSchemeDataTree(Parent.FOwner).ListMaxNodeItemCount;
  Parent.FOwner.NotifyNodeChange(eItem,tnMove,AbsoluteIndex);
  
  FModify:=True;
end;

procedure TMFSchemeDataItem.SetText(const Value: String);
begin
  if FText<>  Value then
  begin
    FText := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnCaption,AbsoluteIndex);
  end;
end;

function TMFSchemeDataItem.GetNextDataItem: TMFSchemeDataItem;
var I:Integer;
begin
  Result:=nil;
  I:=RelativeIndex+1;
  if I<Parent.DataItemCount then
  begin
    Result:=Parent.DataItems[I];
  end;
end;

function TMFSchemeDataItem.GetPrevDataItem: TMFSchemeDataItem;
var I:Integer;
begin
  Result:=nil;
  I:=RelativeIndex-1;
  if I>-1 then
  begin
    Result:=Parent.DataItems[I];
  end;
end;

procedure TMFSchemeDataItem.SetColor(const Value: TColor);
begin
  if FColor<>  Value then
  begin
    FColor := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnColor,AbsoluteIndex);
  end;
end;

procedure TMFSchemeDataItem.SetCaptionPosition(
  const Value: TCaptionPosition);
begin
  if FCaptionPosition<>  Value then
  begin
    FCaptionPosition := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnCaptionPosition,AbsoluteIndex);
  end;
end;

procedure TMFSchemeDataItem.SetLeftShapeType(
  const Value: TMFSchemeShapeType);
begin
  if FLeftShapeType<>  Value then
  begin
    FLeftShapeType := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnSharp,AbsoluteIndex);
  end;

end;

procedure TMFSchemeDataItem.SetRightShapeType(
  const Value: TMFSchemeShapeType);
begin
  if FRightShapeType<>  Value then
  begin
    FRightShapeType := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnSharp,AbsoluteIndex);
  end;
end;

function TMFSchemeDataItem.CheckSelectChange(Value: Boolean): Boolean;
begin
  Result:=True;
  Parent.FOwner.ItemSelectChanged(True,Value,Self,Result);
end;

procedure TMFSchemeDataItem.AfterSelectChange;
var Accept:boolean;
begin
  Parent.FOwner.ItemSelectChanged(false,Selected,Self,Accept);
end;

function TMFSchemeDataItem.GetValues(const AName: string): string;
begin
  if not Assigned(FValues) then
    FValues:=TStringList.Create;
  Result:=FValues.Values[AName];
end;

procedure TMFSchemeDataItem.SetValues(const AName, Value: string);
var I:Integer;
begin
  if not Assigned(FValues) then
    FValues:=TStringList.Create;
  i:=FValues.IndexOfName(AName);
  if i>-1 then
    FValues.Values[AName]:=Value
  else
    FValues.Add(AName+'='+Value);
end;


{ TMFSchemeDataTree }

function TMFSchemeDataTreeNode.AddDataItem: TMFSchemeDataItem;
begin
  Result := TMFSchemeDataItem.Create(Self);
  AddDataItem(-1, Result);
end;

function TMFSchemeDataTreeNode.AddDataItem(I: Integer): TMFSchemeDataItem;
begin
  if not Assigned(FDataItemList) then
    FDataItemList:=TList.Create;
  Result := TMFSchemeDataItem.Create(Self);
  AddDataItem(I, Result);
end;

function TMFSchemeDataTreeNode.AddDataItem(I: Integer;
  ADataItem: TMFSchemeDataItem): TMFSchemeDataItem;
var
  vPreChild: TMFSchemeDataItem;
begin
  if ADataItem = nil then raise EMFSchemeTree.Create('DataItem is nil');
  if FDataItemList=nil then FDataItemList := TList.Create;
  if I = -1 then I := FDataItemList.Count;

  FDataItemList.Insert(I, ADataItem);
  TMFSchemeDataTree(FOwner).FMajorDataItemList.Add(ADataItem);
  ADataItem.FVisible := Visible;
  Result := ADataItem;
  ADataItem.FParent := Self;
  if TMFSchemeDataTree(FOwner).MaxNodeItemCount<FDataItemList.Count then
    TMFSchemeDataTree(FOwner).FMaxNodeItemCount:=FDataItemList.Count;
  FOwner.NotifyNodeChange(eItem,tnAdd,I);
end;


function TMFSchemeDataItem.IsActiveDataItem: Boolean;
begin
  Result:= TMFSchemeDataTree(Parent.Owner).ActiveDataItem=Self;
end;

function TMFSchemeDataItem.MoveTo(ADataTreeNode: TMFSchemeDataTreeNode;
  index: Integer): Boolean;
begin
  FParent.DataItemList.Delete(RelativeIndex);
  FParent:= ADataTreeNode;
  if index=-1 then
    FParent.DataItemList.Add(self)
  else
    FParent.DataItemList.Insert(index,self);

  TMFSchemeDataTree(Parent.FOwner).ListMaxNodeItemCount;
  Parent.FOwner.NotifyNodeChange(eItem,tnMove,AbsoluteIndex);
  
  FModify:=True;
end;

procedure TMFSchemeDataItem.Refresh;
var R:TRect;
begin
  R:=GetItemClientRect;
  with TMFBaseScheme(Parent.Owner.Parent) do
  if IntersectRect(R,R,ClientRect) then
    InvalidateRect(R);
end;

procedure TMFSchemeDataItem.SetBeginDate(const Value: TDateTime);
begin
  if FBeginDate<> Value then
  begin
    FBeginDate := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnChange,AbsoluteIndex);
  end;
end;

procedure TMFSchemeDataItem.SetIntervalDate(const Value: TDateTime);
begin
  if FIntervalDate<> Value then
  begin
    FIntervalDate := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnChange,AbsoluteIndex);
  end;
end;

procedure TMFSchemeDataItem.SetPercent(const Value: Double);
begin
  if FPercent<> Value then
  begin
    FPercent := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnPercent,AbsoluteIndex);
  end;
end;

procedure TMFSchemeDataItem.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TMFSchemeDataItem.SetSelected(const Value: Boolean);
begin
  with TMFSchemeDataTree(Parent.FOwner) do
  if Value<>(FSelectItemList.IndexOf(self)>-1) then
  if CheckSelectChange(Value) then
  begin
    if Value then
    begin
      if FSelectItemList.IndexOf(self)=-1 then
      begin
       FSelectItemList.Add(Self);
       NotifyNodeChange(eItem,tnSelect,AbsoluteIndex);
      end;
    end
    else
      if FSelectItemList.IndexOf(self)>-1 then
      begin
	FSelectItemList.Delete(FSelectItemList.IndexOf(self));
	NotifyNodeChange(eItem,tnSelect,AbsoluteIndex);
      end;
    AfterSelectChange;
  end;

end;

procedure TMFSchemeDataItem.SetVisible(const Value: Boolean);
begin
  if FVisible<>  Value then
  begin
    FVisible := Value;
    Parent.FOwner.NotifyNodeChange(eItem,tnVisible,AbsoluteIndex);
  end;
end;

function TMFSchemeDataTree.GetDataItem(I: Integer): TMFSchemeDataItem;
begin
  Result :=FindDataItem(I);
  if Result = nil then
    Error(Format('Index out of Bounds (%d)', [I]));
end;

function TMFSchemeDataTree.GetDataItemCount: Integer;
begin
  Result:=FMajorDataItemList.Count;
end;

function TMFSchemeDataTree.FindDataItem(I: Integer): TMFSchemeDataItem;
begin
  if (I >= 0) and (I < FMajorDataItemList.Count) then
    Result := TMFSchemeDataItem(FMajorDataItemList[I])
  else
    Result := nil;
end;

function TMFSchemeDataTree.FindDataItem(I: Integer;
  var AItem: TMFSchemeDataItem): Boolean;
begin
  Result:=False;
  AItem:=FindDataItem(I);
  if AItem<>nil then Result:=True;
end;

{ TMFSchemeDataTree }

constructor TMFSchemeDataTree.Create2(AControl:TControl;AItemClass: TMFSchemeTreeNodeClass);
begin
  inherited Create2(AControl,AItemClass);
  FMajorDataItemList:=TList.Create;
  FSelectItemList:=TList.Create;
  FItemLinks:=TMFSchemeDataItemLinks.Create(Self);
  FMaxNodeItemCount:=-1;
end;

destructor TMFSchemeDataTree.Destroy;
begin
  BeginUpdate;
  FreeAndNil(FSelectItemList);
  FreeAndNil(FItemLinks);
  inherited;
  FreeAndNil(FMajorDataItemList);
end;

function TMFSchemeDataTree.GetTreeHeight(ANode:TMFSchemeDataTreeNode=nil): Integer;
//var I:Integer; iHeight:Integer;
begin
  Result:=(inherited GetTreeHeight(ANode));
{  iHeight:=0;
  if Assigned(FMajorList) then
  if Count>0 then
  begin
    if ANode=nil then ANode := Items[Count-1];
    for I:=0 to ANode.AbsoluteIndex  do
    begin
      if Items[I].Parent=nil then
      begin
	if  Items[I].Visible  then
	  iHeight:=iHeight+Items[I].Height;
      end
      else
      if Items[I].Parent.Expanded and Items[I].Visible  then
	iHeight:=iHeight+Items[I].Height;
    end;
  end;
  Result := iHeight; }
end;

function TMFSchemeDataTree.AddNode(AParent: TMFSchemeDataTreeNode;
  AIndex: Integer): TMFSchemeDataTreeNode;
begin
  Result:=TMFSchemeDataTreeNode(inherited AddNode(AParent,AIndex));
end;

procedure TMFSchemeDataTree.ListMaxNodeItemCount;
var I:Integer;
begin
  FMaxNodeItemCount:=-1;
  for I:=0 to Count-1 do
  begin
    if FMaxNodeItemCount<TMFSchemeDataTreeNode(Items[I]).DataItemCount then
      FMaxNodeItemCount:= TMFSchemeDataTreeNode(Items[I]).DataItemCount;
  end;
end;

function TMFSchemeDataTree.GetItem(I: Integer): TMFSchemeDataTreeNode;
begin
  Result := TMFSchemeDataTreeNode(inherited GetItem(I));
end;

procedure TMFSchemeDataTree.ClearItemSelection(KeepPrimary: Boolean);
var I:Integer;
begin
  if KeepPrimary then
  begin
    for I:=FSelectItemList.Count-1 downto 1 do
      FSelectItemList.Delete(I);
  end
  else
    FSelectItemList.Clear;
  NotifyNodeChange(eItem,tnDelete,-1);
end;

function TMFSchemeDataTree.GetSelectionItemCount: Integer;
begin
  Result :=FSelectItemList.Count;
end;

function TMFSchemeDataTree.GetSelectionsItem(
  index: Integer): TMFSchemeDataItem;
begin
  Result:= TMFSchemeDataItem(FSelectItemList.Items[index]);
end;


procedure TMFSchemeDataTree.NotifyItemLink(ADataItem: TMFSchemeDataItem);
var
  ArrayList:TItemLinkArray;
  I,J:Integer;
begin
  if Assigned(FItemLinks) then
  begin
    ArrayList:=FItemLinks.FindItems(ADataItem);
    J:=Length(ArrayList);
    //for I:=High(ArrayList) downto Low(ArrayList) do
    for I:=J-1 downto 0 do
    begin
      FItemLinks.Delete(ArrayList[I]);

    end;
  end;
end;

function TMFSchemeDataTree.AddNode(AParent: TMFSchemeDataTreeNode;
  ACaption: String; AHeight, AIndex: Integer): TMFSchemeDataTreeNode;
begin
  Result:=TMFSchemeDataTreeNode(inherited AddNode(AParent,ACaption,AHeight,AIndex));
end;

function TMFSchemeDataTree.AddNodeObject(AParent: TMFSchemeDataTreeNode;
  ACaption: String; AHeight: Integer;
  Ptr: Pointer): TMFSchemeDataTreeNode;
begin
  Result:=TMFSchemeDataTreeNode(inherited AddNodeObject(AParent,ACaption,AHeight,Ptr));
end;

procedure TMFSchemeDataTree.ClearItem;
var I:Integer;
begin

  for I:=FMajorDataItemList.Count-1 downto 0 do
  begin
    TMFSchemeDataItem(FMajorDataItemList.Items[I]).Free;
  end;
  NotifyNodeChange(eItem,tnDelete,-1);
end;

function TMFSchemeDataTree.GetNodeByNodeName(
  Value: string): TMFSchemeDataTreeNode;
var i:Integer ;ANode:TMFSchemeDataTreeNode;
begin
  Result:=nil;
  for i:=0 to GetCount-1 do
  begin
    ANode:= TMFSchemeDataTreeNode(FindItem(i));
    if SameText(ANode.NodeName,Value) then
      Result :=ANode;
  end;
end;

function TMFSchemeDataTree.GetItemByItemName(
  Value: string): TMFSchemeDataItem;
var i:Integer ;AItem:TMFSchemeDataItem;
begin
  Result:=nil;
  for i:=0 to GetDataItemCount-1 do
  begin
    AItem:= FindDataItem(i);
    if SameText(AItem.ItemName,Value) then
      Result :=AItem;
  end;
end;

{ TMFTreeOptions }

procedure TMFTreeOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFTreeOptions then
  begin
    FVisible:= TMFTreeOptions(Source).Visible;
    FShowLines:= TMFTreeOptions(Source).ShowLines;
    FShowButtons:= TMFTreeOptions(Source).ShowButtons;
    FRowSelect:= TMFTreeOptions(Source).RowSelect;
    FIndent:= TMFTreeOptions(Source).Indent;
    FWidth:= TMFTreeOptions(Source).Width;
  end;
end;

constructor TMFTreeOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited;
  FVisible:=True;
  FShowLines:=True;
  FShowButtons:=True;
  FRowSelect:=True;
  FIndent:= 10;
  FWidth:=120;
  FAutoMoveToSelect :=True;
end;

procedure TMFTreeOptions.SetCaption(const Value: String);
begin
  if FCaption<>Value then
  begin
    FCaption := Value;
    Change;
  end;
end;

procedure TMFTreeOptions.SetIndent(const Value: Integer);
begin
  if FIndent<>Value then
  begin
    FIndent := Value;
    Change;
  end;
end;

procedure TMFTreeOptions.SetRowSelect(const Value: Boolean);
begin
  FRowSelect := Value;
end;

procedure TMFTreeOptions.SetShowButtons(const Value: Boolean);
begin
  FShowButtons := Value;
end;

procedure TMFTreeOptions.SetShowLines(const Value: Boolean);
begin
  FShowLines := Value;
end;

procedure TMFTreeOptions.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible := Value;
    ChangeAll;
  end;
end;

procedure TMFTreeOptions.SetWidth(const Value: Integer);
begin
  if FWidth<>Value then
  begin
    FWidth := Value;
    ChangeAll;
  end;
end;

{ TMFHeadOptions }

procedure TMFHeadOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFHeadOptions then
  begin
    FVisible:= TMFHeadOptions(Source).Visible;
    FHeight:= TMFHeadOptions(Source).Height;
  end;
end;

constructor TMFHeadOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited;
  FVisible:=True;
  FHeight:=16;
end;

procedure TMFHeadOptions.SetHeight(const Value: Integer);
begin
  if FHeight<>Value then
  begin
    FHeight:=Value;
    ChangeAll;
  end;
end;

procedure TMFHeadOptions.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    ChangeAll;
  end;
end;

{ TMFIndicaterOptions }

procedure TMFIndicaterOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFIndicaterOptions then
  begin
    FVisible:=TMFIndicaterOptions(Source).Visible;
    FDefaultHeight:=TMFIndicaterOptions(Source).DefaultHeight;
    FWidth:=TMFIndicaterOptions(Source).Width;
  end ;
end;

constructor TMFIndicaterOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited;
  FVisible:=True;
  FDefaultHeight:=16;
  FWidth:=12;
  FColor := clBtnFace;
end;

procedure TMFIndicaterOptions.SetDefaultHeight(const Value: Integer);
begin
  FDefaultHeight := Value;
end;

procedure TMFIndicaterOptions.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    ChangeAll;
  end;
end;

procedure TMFIndicaterOptions.SetWidth(const Value: Integer);
begin
  if FWidth<>Value then
  begin
    FWidth:=Value;
    ChangeAll;
  end;
end;

{ TMFFootOptions }

procedure TMFFootOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFFootOptions then
  begin
    FVisible:=TMFFootOptions(Source).Visible;
    FHeight:= TMFFootOptions(Source).Height;
  end;
end;

constructor TMFFootOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited;
  FHeight:=20;
  FPen.Color:= clBtnShadow;
end;

procedure TMFFootOptions.SetCaption(const Value: String);
begin
  if  FCaption <> Value then
  begin
    FCaption := Value;
    Change;
  end;
end;

procedure TMFFootOptions.SetHeight(const Value: Integer);
begin
  if FHeight<>Value then
  begin
    FHeight:=Value;
    ChangeAll;
  end;
end;

procedure TMFFootOptions.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    ChangeAll;
  end;
end;

{ TMFContentOptions }

procedure TMFContentOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFContentOptions then
  begin
    FVisible:=TMFContentOptions(Source).Visible;
  end;
end;

constructor TMFContentOptions.Create(AView:TMFBaseSchemeView);
begin
  inherited;
  FVisible:=True;
  FColor:=clWhite;
end;

procedure TMFContentOptions.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible:=Value;
    Change;
  end;
end;

procedure TMFSchemeDataTreeNode.AdjustItemDateTime(
  StartDataItem: TMFSchemeDataItem;EndDataItem:TMFSchemeDataItem;
  AdjustMoveType:TAdjustMoveType);
var
  I,iStart,iEnd,iMid:Integer;dDate:TDateTime;
begin

  case AdjustMoveType of

    amtAfterItem,amtTouchMove:
      begin
	if StartDataItem <> nil then
	  iStart:= StartDataItem.RelativeIndex
	else
	  iStart:= 1;

	if EndDataItem <> nil then
	  iEnd:= EndDataItem.RelativeIndex
	else
	  iEnd:= DataItemCount-1;
      end;

    amtAfterItemAll,amtTouchMoveAll:
      begin
	iStart:= 1;
	iEnd:= DataItemCount-1;
	if  iEnd>0 then
	  StartDataItem:=Self.DataItems[0];
      end;

    amtAfterItemTouchMove:
      begin
	iEnd:= DataItemCount-1;
	iMid:=iEnd;
	if Assigned(EndDataItem) then
	  iMid:= EndDataItem.RelativeIndex;

      end;

  end;

  if not (AdjustMoveType in [amtDefault,amtStand]) then
  begin
    if StartDataItem<>nil then
      dDate:=StartDataItem.BeginDate+StartDataItem.IntervalDate
    else
    begin
      if DataItemCount<2 then Exit;
      //Andyzhang 这个没有必要了
      //raise Exception.Create('Need StartDataItem');
    end;
  end;

  for I:=iStart to iEnd do
  begin

    case AdjustMoveType of

      amtAfterItem,amtAfterItemAll:
	begin
	  DataItems[I].BeginDate:= dDate;
	  dDate:=DataItems[I].BeginDate+DataItems[I].IntervalDate;
	end;

      amtTouchMove,amtTouchMoveAll:
	begin
	  if DataItems[I].BeginDate<dDate then
	    DataItems[I].BeginDate:= dDate;
	  dDate:=DataItems[I].BeginDate+DataItems[I].IntervalDate;
	end;
	
      amtAfterItemTouchMove:
	begin

	  if I<iMid then
	  begin
	    DataItems[I].BeginDate:= dDate;
	    dDate:=DataItems[I].BeginDate+DataItems[I].IntervalDate;

	  end
	  else begin
	    if DataItems[I].BeginDate<dDate then
	      DataItems[I].BeginDate:= dDate;
	    dDate:=DataItems[I].BeginDate+DataItems[I].IntervalDate;

	  end;
	end;
    end;
  end;

end;

procedure TMFSchemeDataTreeNode.AdjustItemIndex(
  StartDataItem: TMFSchemeDataItem;EndDataItem:TMFSchemeDataItem);
var
  I,J,iStart,iEnd:Integer;dDate:TDateTime;
  TempItem :TMFSchemeDataItem;
begin

  if StartDataItem <> nil then
    iStart:= StartDataItem.RelativeIndex
  else
    iStart:= 0;
    
  if EndDataItem <> nil then
    iEnd:= EndDataItem.RelativeIndex
  else
    iEnd:= DataItemCount-1;

  for J:=iStart to iEnd do
  begin
    TempItem := DataItems[J];

    for I:=J+1 to iEnd do
    begin
      if TempItem.BeginDate>DataItems[I].BeginDate then
	DataItemList.Exchange(I,J);

    end;

  end; // end for


end;

procedure TMFSchemeDataTreeNode.ClearItems;
var I:Integer;
begin
  if Assigned(FDataItemList) then
  for I:= FDataItemList.Count -1 downto 0 do
  begin
    TMFSchemeDataItem(FDataItemList.Items[I]).Free;
  end;
end;

constructor TMFSchemeDataTreeNode.Create(AOnwer: TMFSchemeDataTree);
begin
  inherited Create(AOnwer);
end;

procedure TMFSchemeDataTreeNode.DeleteDataItem(I: Integer);
var J:Integer;
begin
  if I>-1 then
  with TMFSchemeDataTree(FOwner) do
  if  Assigned(FMajorDataItemList) then
  begin
    J:=FMajorDataItemList.IndexOf(FDataItemList.Items[I]);
    if J>-1  then FMajorDataItemList.Delete(J);
    DataItemList.Delete(I);
    TMFSchemeDataTree(FOwner).ListMaxNodeItemCount;
  end;
end;

procedure TMFSchemeDataTreeNode.DeleteDataItem;
begin
  DeleteDataItem(DataItemList.Count-1);
end;

procedure TMFSchemeDataTreeNode.DeleteDataItem(AItem: TMFSchemeDataItem);
begin
  with TMFSchemeDataTree(FOwner) do
  if  Assigned(FSelectItemList) then
  begin
    DeleteSelectItem(FSelectItemList.IndexOf(AItem));
    if AItem.IsActiveDataItem then  ActiveDataItem:=nil;
  end;
  DeleteDataItem(DataItemList.IndexOf(AItem));
end;

procedure TMFSchemeDataTreeNode.DeleteSelectItem(I: Integer);
begin
  if I>-1 then
  begin
    TMFSchemeDataTree(FOwner).FSelectItemList.Delete(I);
  end;
end;

destructor TMFSchemeDataTreeNode.Destroy;
begin
  if Assigned(FDataItemList) then
  begin
    ClearItems;
    FDataItemList.Free;
  end;
  inherited;
end;

function TMFSchemeDataTreeNode.GetDataItem(
  I: Integer): TMFSchemeDataItem;
begin
  Result:=nil;
  if  Assigned(FDataItemList) then
  begin
    if (i<FDataItemList.Count)  and  (i>-1) then
      Result:=TMFSchemeDataItem(FDataItemList.Items[I]);
  end;
end;

function TMFSchemeDataTreeNode.GetDataItemCount: Integer;
begin
  Result:=-1;
  if  Assigned(FDataItemList) then
    Result:=FDataItemList.Count;
end;

{ TMFBaseOptions }

procedure TMFBaseOptions.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TMFBaseOptions then
  begin
    FFont  :=  TMFBaseOptions(Source).FFont;
    FPen   :=  TMFBaseOptions(Source).FPen;
    FColor :=  TMFBaseOptions(Source).FColor;
  end;
end;

procedure TMFBaseOptions.Change;
begin
  FBaseView.Invalidate;
end;

procedure TMFBaseOptions.ChangeAll;
begin
  ChangeScroll;
  Change;
end;

procedure TMFBaseOptions.ChangeScroll;
begin
  if FBaseView.IsNotifyChange then
    FBaseView.UpdateScroll;
end;

constructor TMFBaseOptions.Create(AView: TMFBaseSchemeView);
begin
  FPen:=TPen.Create;
  FPen.OnChange :=SetChange;
  FFont:=TFont.Create;
  FFont.OnChange := SetChange;
  FBaseView:= AView;
  AView.SetComponentState([csLoading]);
  FColor := clBtnFace;
end;

destructor TMFBaseOptions.Destroy;
begin
  FPen.Free;
  FFont.Free;
  inherited;
end;

function TMFBaseOptions.GetOwner: TPersistent;
begin
  Result := FBaseView;
end;

procedure TMFBaseOptions.SetChange(Sender: TObject);
begin
  Change;
end;

procedure TMFBaseOptions.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Change; 
  end;
end;

procedure TMFBaseOptions.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TMFBaseOptions.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TMFBaseOptions.SetView(const Value: TMFBaseSchemeView);
begin
  FBaseView := Value;
end;

{ TMFBaseViewControl }

procedure TMFBaseViewControl.BeginDrag(Immediate: Boolean;
  Threshold: Integer);
begin

end;

function TMFBaseViewControl.CheckItemSeleMFype(AButton: TMouseButton;
  AItemSeleMFype: TItemSeleMFype): Boolean;
begin
  case  AItemSeleMFype of
    istLeft:Result:= (AButton= mbLeft);
    istRight:Result:= (AButton=mbRight);
    istMiddle:Result:= (AButton=mbMiddle);
    istAll:Result:= True;
  end;
end;

constructor TMFBaseViewControl.Create(AView: TMFBaseSchemeView);
begin
  inherited Create;
  FBaseView:=AView;
end;

procedure TMFBaseViewControl.DragCanceled;
begin

end;

function TMFBaseViewControl.Dragging: Boolean;
begin

end;

procedure TMFBaseViewControl.DragItemDrop(Source: TObject; X, Y: Integer);
begin

end;

procedure TMFBaseViewControl.DragItemOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

end;

procedure TMFBaseViewControl.DragOtherDrop(Source: TObject; X,
  Y: Integer);
begin

end;

procedure TMFBaseViewControl.DragOtherOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

end;

procedure TMFBaseViewControl.EndDrag(Drop: Boolean);
begin

end;

function TMFBaseViewControl.IsReadOnly: Boolean;
begin
  Result:=FBaseView.ReadOnly;
end;

procedure TMFBaseViewControl.KeyDown(var Key: Word; Shift: TShiftState);
begin

end;

procedure TMFBaseViewControl.KeyPress(var Key: Char);
begin

end;

procedure TMFBaseViewControl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TMFBaseViewControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TMFBaseViewControl.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TMFBaseViewControl.SetEnable(const Value: Boolean);
begin
  FEnable := Value;
end;

function TMFSchemeDataTreeNode.GetDataItemList: TList;
begin
  if not Assigned(FDataItemList) then
    FDataItemList:=TList.Create;
  Result :=FDataItemList ;
end;

function TMFSchemeDataTreeNode.GetNodeRect: TRect;
begin
  if Supports(Owner.Parent,IZcTreeChanger) then
    Result:=(Owner.Parent as IZcTreeChanger).GetDataTreeClientRect(nil,Self);
end;

procedure TMFSchemeDataTreeNode.Refresh;
var R:TRect;
begin
  R:=GetNodeRect;
  with TMFBaseScheme(Owner.Parent) do
  if IntersectRect(R,R,ClientRect) then
    InvalidateRect(R);
end;

{ TMFSchemeDataItemLink }

procedure TMFSchemeDataItemLink.CalcPath;
var
  PFirst,PLast,P:TPoint;
  ARNext,ARPrev:TRect;
begin
  if NeedCalcPath then
  begin
    P:= PrevLinkDataItem.GetOffSetPoint;
    ARNext := FRNext;
    ARPrev := FRPrev;
    //OffsetRect(ARNext,-P.X,-P.Y);
    //OffsetRect(ARPrev,-P.X,-P.Y);
    SetLength(FLinkPath,2);
    PFirst:=Point(ARPrev.Right,(ARPrev.Top+ARPrev.Bottom) div 2);
    FLinkPath[0]:= PFirst;
    PLast:=Point(ARNext.Left,(ARNext.Top+ARNext.Bottom) div 2);


    if PFirst.X < PLast.X  then
    begin
      if  PFirst.Y = PLast.Y then  FLinkPath[1]:= PLast;

      if PFirst.Y> PLast.Y then
      begin
	SetLength(FLinkPath,3);
	FLinkPath[1]:= Point(ARNext.Left+5,PFirst.Y);
	FLinkPath[2]:= Point(ARNext.Left+5,ARNext.Bottom+1);

      end;

      if PFirst.Y< PLast.Y then
      begin
	SetLength(FLinkPath,3);
	FLinkPath[1]:= Point(ARNext.Left+5,PFirst.Y);
	FLinkPath[2]:= Point(ARNext.Left+5,ARNext.Top-1);

      end;

    end
    else begin
    
      if  PFirst.Y = PLast.Y then
      begin
	FLinkPath[1]:= PLast;
	SetLength(FLinkPath,6);
	FLinkPath[1]:= Point(PFirst.X+15,PFirst.Y);
	FLinkPath[2]:= Point(PFirst.X+15,ARNext.Top-5);
	FLinkPath[3]:= Point(ARNext.Left-15,ARNext.Top-5);
	FLinkPath[4]:= Point(ARNext.Left-15,PLast.Y);
	FLinkPath[5]:= Point(ARNext.Left,PLast.Y);
      end;
      
      if PFirst.Y> PLast.Y then
      begin
	SetLength(FLinkPath,6);
	FLinkPath[1]:= Point(PFirst.X+15,PFirst.Y);
	FLinkPath[2]:= Point(PFirst.X+15,(PLast.Y+PFirst.Y) div 2);
	FLinkPath[3]:= Point(ARNext.Left-15,(PLast.Y+PFirst.Y) div 2);
	FLinkPath[4]:= Point(ARNext.Left-15,PLast.Y);
	FLinkPath[5]:= Point(ARNext.Left,PLast.Y);
      end;

      if PFirst.Y< PLast.Y then
      begin
	SetLength(FLinkPath,6);
	FLinkPath[1]:= Point(PFirst.X+15,PFirst.Y);
	FLinkPath[2]:= Point(PFirst.X+15,(PLast.Y+PFirst.Y) div 2);
	FLinkPath[3]:= Point(ARNext.Left-15,(PLast.Y+PFirst.Y) div 2);
	FLinkPath[4]:= Point(ARNext.Left-15,PLast.Y);
	FLinkPath[5]:= Point(ARNext.Left,PLast.Y);
      end;


    end;

  end;
end;


constructor TMFSchemeDataItemLink.Create(Owner: TMFSchemeDataItemLinks);
begin
  inherited Create;
  FOwner := Owner;  
end;

destructor TMFSchemeDataItemLink.Destroy;
begin
  FOwner.Delete(Self,False);
  inherited;
end;

function TMFSchemeDataItemLink.NeedCalcPath: Boolean;
var
  ARNext,ARPrev:TRect; P:TPoint;
begin
  Result:=False;
  P:=FNextLinkDataItem.GetOffSetPoint;
  ARNext:= FNextLinkDataItem.GetItemClientRect;
  OffsetRect(ARNext,P.X,P.Y);

  ARPrev:= FPrevLinkDataItem.GetItemClientRect;
  OffsetRect(ARPrev,P.X,P.Y);

  if not EqualRect(ARNext,FRNext) then
    Result:=True;

  if not Result then
    if not EqualRect(ARPrev,FRPrev) then
      Result:=True;

  FRNext:=ARNext;
  FRPrev:=ARPrev;
end;

function TMFSchemeDataItemLink.PassPath(ARect: TRect;var bLastPoint:Boolean): TLinkPath;

  function Subtract(AVec1, AVec2 : TPoint) : TPoint;
  begin
    Result.X := AVec1.X - AVec2.X;
    Result.Y := AVec1.Y - AVec2.Y;
  end;

  function LinesCross(LineAP1, LineAP2, LineBP1, LineBP2 : TPoint) : boolean;
  Var
    diffLA, diffLB : TPoint;
    CompareA, CompareB : integer;
  begin
    Result := False;

    diffLA := Subtract(LineAP2, LineAP1);
    diffLB := Subtract(LineBP2, LineBP1);

    CompareA := diffLA.X*LineAP1.Y - diffLA.Y*LineAP1.X;
    CompareB := diffLB.X*LineBP1.Y - diffLB.Y*LineBP1.X;

    if ( ((diffLA.X*LineBP1.Y - diffLA.Y*LineBP1.X) <= CompareA) xor
	 ((diffLA.X*LineBP2.Y - diffLA.Y*LineBP2.X) <= CompareA) ) and
       ( ((diffLB.X*LineAP1.Y - diffLB.Y*LineAP1.X) <= CompareB) xor
	 ((diffLB.X*LineAP2.Y - diffLB.Y*LineAP2.X) <= CompareB) ) then
      Result := True;
  end;

  function LineIntersect(LineAP1, LineAP2, LineBP1, LineBP2 : TPoint) :TPoint;
  Var
    LDetLineA, LDetLineB, LDetDivInv : Real;
    LDiffLA, LDiffLB : TPoint;
  begin
    LDetLineA := LineAP1.X*LineAP2.Y - LineAP1.Y*LineAP2.X;
    LDetLineB := LineBP1.X*LineBP2.Y - LineBP1.Y*LineBP2.X;

    LDiffLA := Subtract(LineAP1, LineAP2);
    LDiffLB := Subtract(LineBP1, LineBP2);

    LDetDivInv := 1 / ((LDiffLA.X*LDiffLB.Y) - (LDiffLA.Y*LDiffLB.X));

    Result.X := Round(((LDetLineA*LDiffLB.X) - (LDiffLA.X*LDetLineB)) * LDetDivInv);
    Result.Y := Round(((LDetLineA*LDiffLB.Y) - (LDiffLA.Y*LDetLineB)) * LDetDivInv);
  end;

  function OffSetPoint(APoint:TPoint;X,Y:Integer):TPoint;
  begin
    Result :=Point( APoint.X+X,APoint.Y + Y) ;
  end;
  
  function GetLastPoint(Value:TLinkPath):TPoint;
  begin
    Result:=Value[Length(Value)-1];

  end;

  function PInRect(const Rect: TRect; const P: TPoint): Boolean;
  begin
    Result := (P.X >= Rect.Left) and (P.X <= Rect.Right) and (P.Y >= Rect.Top)
      and (P.Y <= Rect.Bottom);
  end;
var
  I,J:Integer;
  PPrev,PCross,Poffset:TPoint;
begin
  //SetLength(Result,Length(FLinkPath));
  SetLength(Result,0);
  Poffset:=FNextLinkDataItem.GetOffSetPoint;
  OffsetRect(ARect,0,Poffset.Y);
  bLastPoint:=False;
  for I:=Low(FLinkPath) to High(FLinkPath)  do
  begin
    //Result[i] :=OffSetPoint(FLinkPath[i],-Poffset.X,-Poffset.Y);
    if I<>Low(FLinkPath) then
    begin
    
      //First
      
      if PInRect(ARect,PPrev) then
      begin
	SetLength(Result,Length(Result)+1);
	Result[Length(Result)-1] :=OffSetPoint(PPrev,-Poffset.X,-Poffset.Y);
      end;
      
      if not (PInRect(ARect,PPrev) and PInRect(ARect,FLinkPath[i]))  then
      begin
	//1
	if  LinesCross(PPrev,FLinkPath[i],ARect.TopLeft,
	  Point(ARect.Right,ARect.Top)) then
	begin
	  PCross:=LineIntersect(PPrev,FLinkPath[i],ARect.TopLeft,
	    Point(ARect.Right,ARect.Top));
	    
	  SetLength(Result,Length(Result)+1);
	  Result[Length(Result)-1] :=OffSetPoint(PCross,-Poffset.X,-Poffset.Y);

	end;

	//2
	if  LinesCross(PPrev,FLinkPath[i],ARect.TopLeft,
	  Point(ARect.Left,ARect.Bottom)) then
	begin
	  PCross:=LineIntersect(PPrev,FLinkPath[i],ARect.TopLeft,
	    Point(ARect.Left,ARect.Bottom));
	  SetLength(Result,Length(Result)+1);
	  Result[Length(Result)-1]:= OffSetPoint(PCross,-Poffset.X,-Poffset.Y);
	end;

	//3
	if  LinesCross(PPrev,FLinkPath[i],ARect.BottomRight,
	  Point(ARect.Right,ARect.Top)) then
	begin
	  PCross:=LineIntersect(PPrev,FLinkPath[i],ARect.BottomRight,
	    Point(ARect.Right,ARect.Top));
	  SetLength(Result,Length(Result)+1);
	  Result[Length(Result)-1]:= OffSetPoint(PCross,-Poffset.X,-Poffset.Y);
	end;

	//4
	if  LinesCross(PPrev,FLinkPath[i],ARect.BottomRight,
	  Point(ARect.Left,ARect.Bottom)) then
	begin
	  PCross:=LineIntersect(PPrev,FLinkPath[i],ARect.BottomRight,
	    Point(ARect.Left,ARect.Bottom));
	  SetLength(Result,Length(Result)+1);
	  Result[Length(Result)-1]:= OffSetPoint(PCross,-Poffset.X,-Poffset.Y);
	end;
      end;


      //Last
      if PInRect(ARect,FLinkPath[i]) then
      begin
	SetLength(Result,Length(Result)+1);
	Result[Length(Result)-1] :=OffSetPoint(FLinkPath[i],-Poffset.X,-Poffset.Y);
	if i=High(FLinkPath) then bLastPoint:=True;
      end;
    end;

    PPrev := FLinkPath[i];

  end;

end;

procedure TMFSchemeDataItemLink.SetNextLinkDataItem(
  const Value: TMFSchemeDataItem);
begin
  if Value=nil then Exception.Create('Cann''t set nil ');
  FNextLinkDataItem := Value;
end;

procedure TMFSchemeDataItemLink.SetPrevLinkDataItem(
  const Value: TMFSchemeDataItem);
begin
  if Value=nil then Exception.Create('Cann''t set nil ');
  FPrevLinkDataItem := Value;
end;

{ TMFSchemeDataItemLinks }

function TMFSchemeDataItemLinks.Add(PrevItem,
  NextItem: TMFSchemeDataItem): TMFSchemeDataItemLink;
var I:integer;  
begin
  Result:= TMFSchemeDataItemLink.Create(Self);
  Result.PrevLinkDataItem:=PrevItem;
  Result.NextLinkDataItem:=NextItem;
  I:=FList.Add(Result);
  FOwner.NotifyNodeChange(eItemLink,tnAdd,I);
end;

procedure TMFSchemeDataItemLinks.Clear;
var I:Integer;
begin
  FOwner.BeginUpdate;
  if FList.Count>0 then
  For I:=FList.Count -1 downto 0 do
  begin
    Self.Delete(I);
  end;
  FOwner.EndUpdate;
  FOwner.NotifyNodeChange(eItemLink,tnDelete,-1);
end;

function TMFSchemeDataItemLinks.Count: Integer;
begin
  Result:=FList.Count ;
end;

constructor TMFSchemeDataItemLinks.Create(Owner: TMFSchemeDataTree);
begin
  inherited Create;
  FList:=TList.Create;
  FOwner:= Owner;
end;

procedure TMFSchemeDataItemLinks.Delete(Index: Integer;IsFree:Boolean);
begin
  if IsFree then
    Items[Index].Free
  else
    FList.Delete(Index);
  FOwner.NotifyNodeChange(eItemLink,tnDelete,Index);
end;

procedure TMFSchemeDataItemLinks.Delete(
  ADataItemLink: TMFSchemeDataItemLink;IsFree:Boolean=True);
var I:integer;  
begin
  I:=FList.IndexOf(ADataItemLink);
  if I<>-1 then Delete(I,IsFree);
end;

destructor TMFSchemeDataItemLinks.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TMFSchemeDataItemLinks.FindItems(PrevItem,
  NextItem: TMFSchemeDataItem): TItemLinkArray;
var I,J:Integer;
begin
  SetLength(Result,0);
  for I:=0 to Count-1 do
  if (Items[I].PrevLinkDataItem=PrevItem)
    or (Items[I].NextLinkDataItem=NextItem) then
  begin
    J:= Length(Result)+1;
    SetLength(Result,J);
    Result[J-1]:=I;
  end;
end;

function TMFSchemeDataItemLinks.FindItems(
  AItem: TMFSchemeDataItem): TItemLinkArray;
var I,J:Integer;
begin
  SetLength(Result,0);
  for I:=0 to Count-1 do
  if (Items[I].PrevLinkDataItem=AItem)
    or (Items[I].NextLinkDataItem=AItem) then
  begin
    J:= Length(Result)+1;
    SetLength(Result,J);
    Result[J-1]:=I;
  end;
end;

function TMFSchemeDataItemLinks.FindNextItems(
  NextItem: TMFSchemeDataItem): TItemLinkArray;
var I,J:Integer;
begin
  SetLength(Result,0);
  for I:=0 to Count-1 do
  if (Items[I].NextLinkDataItem=NextItem) then
  begin
    J:= Length(Result)+1;
    SetLength(Result,J);
    Result[J-1]:=I;
  end;
end;

function TMFSchemeDataItemLinks.FindPrevItems(
  PrevItem: TMFSchemeDataItem): TItemLinkArray;
var I,J:Integer;
begin
  SetLength(Result,0);
  for I:=0 to Count-1 do
  if (Items[I].PrevLinkDataItem=PrevItem) then
  begin
    J:= Length(Result)+1;
    SetLength(Result,J);
    Result[J-1]:=I;
  end;
end;

function TMFSchemeDataItemLinks.GetItem(
  Index: Integer): TMFSchemeDataItemLink;
begin
  Result:=TMFSchemeDataItemLink(FList.Items[Index]);
end;

procedure TMFSchemeDataItemLinks.SetItem(Index: Integer;
  const Value: TMFSchemeDataItemLink);
begin
  FList.Items[Index]:=Value;
end;

end.
