{**************************************************************

项目名称 :ThinkWide基础类
版权所有 (c) 2005 ThinkWide
+-------------------------------------------------------------
项目:


版本: 1


创建日期:2005-10-5 19:02:09


作者: 章称(Andyzhang)

+-------------------------------------------------------------
描述:

更新:   -2005-10-5 19:02:09
	-2006-7-11 添加 TMFBrushstyleList  加入换肤功能 (未完成 )

ToDo:

***************************************************************}

unit MFPaint;

interface

uses
  Windows,Classes, Controls, Graphics, ImgList,Dialogs,Contnrs,Types,
  MFBaseSchemeCommon,Variants,VarUtils,MFSchemeXml,MFSchemeObjectXml;

type

  TDrawRegion = class
  private
    FHandle: TDrawRegionHandle;
    function GetIsEmpty: Boolean;
  protected
    procedure DestroyHandle;
  public
    constructor Create(AHandle: TDrawRegionHandle); overload; virtual;
    constructor Create(const ABounds: TRect); overload;
    constructor Create; overload;
    constructor Create(ALeft, ATop, ARight, ABottom: Integer); overload;
    destructor Destroy; override;

    procedure Combine(ARegion: TDrawRegion; AOperation: TDrawRegionOperation;
      ADestroyRegion: Boolean = True);
    procedure Offset(DX, DY: Integer);
    function PtInRegion(const Pt: TPoint): Boolean; overload;
    function PtInRegion(X, Y: Integer): Boolean; overload;
    function RectInRegion(const R: TRect): Boolean; overload;
    function RectInRegion(ALeft, ATop, ARight, ABottom: Integer): Boolean; overload;

    property Handle: TDrawRegionHandle read FHandle write FHandle;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  { TDrawCanvas }

  TDrawCanvas = class
  private
    FCanvas: TCanvas;
    function GetBrush: TBrush;
    function GetCopyMode: TCopyMode;
    function GetFont: TFont;
    function GetHandle: HDC;
    function GetPen: TPen;
    function GetWindowOrg: TPoint;
    procedure SetBrush(Value: TBrush);
    procedure SetCopyMode(Value: TCopyMode);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetPixel(X, Y: Integer; Value: TColor);
    procedure SetWindowOrg(const P: TPoint);
  public
    constructor Create(ACanvas:TCanvas); virtual;
    destructor Destroy;override ;
    procedure CopyRect(const Dest: TRect; ACanvas: TCanvas; const Source: TRect);
    procedure Draw(X, Y: Integer; Graphic: TGraphic);
    
    procedure DrawLine(X1,Y1,X2,Y2: Integer;APen:TPen=nil);overload;
    procedure DrawLine(P1,P2: TPoint;APen:TPen=nil);overload;
    procedure DrawLine(R: TRect;ABorders: TDrawBorders =[dLeft, dTop, dRight, dBottom];APen:TPen=nil);overload;

    procedure DrawComplexFrame(const R: TRect; ALeftTopColor, ARightBottomColor: TColor;
      ABorders: TDrawBorders =[dLeft, dTop, dRight, dBottom]; ABorderWidth: Integer = 1);overload;

    procedure DrawComplexFrameLine(const R: TRect;APen:TPen;ABorders: TDrawBorders =
      [dLeft, dTop, dRight, dBottom]); overload;

    procedure DrawEdge(const R: TRect; ASunken, AOuter: Boolean;
      ABorders: TDrawBorders = [dLeft, dTop, dRight, dBottom]);
    procedure DrawFocusRect(const R: TRect);
    procedure DrawGlyph(X, Y: Integer; AGlyph: TBitmap; AEnabled: Boolean = True;
      ABackgroundColor: TColor = clNone{; ATempCanvas: TCanvas = nil});
    procedure DrawImage(Images: TCustomImageList; X, Y, Index: Integer;
      Enabled: Boolean = True);
    procedure DrawTexT(const Text: string; R: TRect; Flags: Integer;
      Enabled: Boolean = True);
    procedure FillRect(const R: TRect; ABitmap: TBitmap = nil); overload;
    procedure FillRect(R: TRect; const AParams: TDrawViewParams;
      ABorders: TDrawBorders = []; ABorderColor: TColor = clDefault; ALineWidth: Integer = 1); overload;

    function FontHeight(AFont: TFont): Integer;
    procedure FrameRect(const R: TRect; Color: TColor = clDefault;
      ALineWidth: Integer = 1; ABorders: TDrawBorders = DrawBordersAll);
    procedure InvertFrame(const R: TRect; ABorderSize: Integer);
    procedure InvertRect(R: TRect);
    procedure LineTo(X, Y: Integer);
    procedure MoveTo(X, Y: Integer);
    procedure Polygon(const Points: array of TPoint);
    procedure Polyline(const Points: array of TPoint);
    function TextExtent(const Text: string): TSize; overload;
    procedure TextExtent(const Text: string; var R: TRect; Flags: Integer); overload;
    function TextHeight(const Text: string): Integer;
    function TextWidth(const Text: string): Integer;

    procedure AssignParams(AParams: TDrawViewParams);
    procedure SetBrushColor(Value: TColor);

    procedure GetTextStringsBounds(Text: string; R: TRect; Flags: Integer;
      Enabled: Boolean; var ABounds: TRectArray);

    procedure ExcludeClipRect(const R: TRect);
    procedure IntersectClipRect(const R: TRect);
    function GetClipRegion: TDrawRegion;
    procedure SetClipRegion(ARegion: TDrawRegion; AOperation: TDrawRegionOperation;
      ADestroyRegion: Boolean = True);
    function RectVisible(R: TRect): Boolean;

    property Brush: TBrush read GetBrush write SetBrush;
    property Canvas: TCanvas read FCanvas write FCanvas;
    property CopyMode: TCopyMode read GetCopyMode write SetCopyMode;
    property Font: TFont read GetFont write SetFont;
    property Handle: HDC read GetHandle;
    property DefCanvas: TCanvas read FCanvas write FCanvas;
    property Pen: TPen read GetPen write SetPen;
    property Pixels[X, Y: Integer]: TColor write SetPixel;
    property WindowOrg: TPoint read GetWindowOrg write SetWindowOrg;
  end;

  {TDrawScreenCanvas}
  TDrawScreenCanvas = class(TDrawCanvas)
  public
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
  end;

  {TRegisteredViews}

  TRegisteredRec= record
    AType:TRegisteredType;
    AClass:TClass;
  end;
  PRegisteredRec=^TRegisteredRec;


  TRegisteredViews = class(TObject)
  private
    FItems: TStringList;
    FRegisterClasses: Boolean;
    function GetCount: Integer;
    function GetDescription(Index: Integer): string;
    function GetItem(Index: Integer): TClass;
    function GetItemRec(Index: Integer): TRegisteredRec;
  public
    constructor Create(ARegisterClasses: Boolean = False);
    destructor Destroy; override;
    procedure Clear;
    function FindByClassName(const AClassName: string): TClass;
    function FindByDescription(const ADescription: string): TClass;
    function GetDescriptionByClass(AClass: TClass): string;
    function GetIndexByClass(AClass: TClass): Integer;
    procedure Register(AClass: TClass; const ADescription: string;
      RegisteredType:TRegisteredType=rgtDefault);
    procedure Unregister(AClass: TClass);
    property Count: Integer read GetCount;
    property Descriptions[Index: Integer]: string read GetDescription;
    property Items[Index: Integer]: TClass read GetItem; default;
    property ItemsRec[Index: Integer]:TRegisteredRec read GetItemRec;
  end;

  {TMFBrushList}
  TMFBrushStyleList=class(TPersistent)
  private
    FBrush:TStringList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Add(StyleName:String);
    procedure Delete(StyleName:String);
    procedure Clear;
    function GetBrushImage(StyleName:String):TBitmap;
    function GetBrushTexture(StyleName:String;AColor:TColor):TBitmap;
    function GetBrushBitMap(StyleName:String;AColor:TColor):TBitmap;
    function GetBrushTransition(StyleName:String;AColor,BColor:TColor;StyleType:Integer):TBitmap;
  end;


var BrushStyleList:TMFBrushStyleList;

function CenterRect(R:TRect;Height:Integer=-1;Width:Integer=-1):TRect;

function InvertColor(AColor:TColor):TColor;
function VarToIntDef(const V: Variant;const ADefault: Integer):Integer;
function VarToInt(const V: Variant):Integer;
function VarToFloatDef(const V: Variant;const ADefault: Double):Double;
function VarToFloat(const V: Variant):Double;

function VarToColor(const V: Variant):TColor;
function VarToColorDef(const V: Variant;const ADefault: TColor):TColor;

function RegisteredViews: TRegisteredViews;

function DrawFlagsToDTFlags(Flags: Integer): Integer;
//function ColorToRGB(Color: TColor): Longint;
function GetRValue(Color: Integer): Byte;
function GetGValue(Color: Integer): Byte;
function GetBValue(Color: Integer): Byte;
function RGB(R, G, B: Byte): Integer;
function ChangeToComponent(Value: string; Instance: TComponent): TComponent;
function ChangeToText(Component: TComponent): string;

function ConfigureToText(Component: TComponent): string;
function TextToConfigure(Value: string; Instance: TComponent): TComponent;

function GetRealColor(AColor: TColor): TColor;
function GetLightColor(ABtnFaceColorPart, AHighlightColorPart, AWindowColorPart: TDrawColorPart): TColor;
function GetLightBtnFaceColor: TColor;
function GetLightDownedColor: TColor;
function GetLightDownedSelColor: TColor;
function GetLightSelColor: TColor;

procedure PenAssign(PenDes,PenSou:TPen);
procedure BrushAssign(BrushDes,BrushSou:TBrush);
implementation

uses
  Menus;
var
  FRegisteredViews:TRegisteredViews;
type
  TCanvasAccess = class(TCanvas);

function ConfigureToText(Component: TComponent): string;
var
  ADoc: TMFSchemeXml;
  AWriter: TMFXmlObjectWriter;
begin
  ADoc := TMFSchemeXml.CreateName('Root');
  try
    ADoc.Utf8Encoded := True;
    ADoc.EncodingString := 'UTF-8';
    AWriter := TMFXmlObjectWriter.Create;
    try
      AWriter.WriteComponent(ADoc.Root, Component, Component.GetParentComponent);
    finally
      AWriter.Free;
    end;

    ADoc.XmlFormat := xfReadable;

    Result := ADoc.Root.WriteToString ;
  finally
    ADoc.Free;
  end;
end;

function TextToConfigure(Value: string; Instance: TComponent): TComponent;
var
  ADoc: TMFSchemeXml;
  AReader: TMFXmlObjectReader;
begin
  ADoc := TMFSchemeXml.Create;
  try
    ADoc.ReadFromString(Value);
    AReader := TMFXmlObjectReader.Create;
    try
      AReader.ReadComponent(ADoc.Root, Instance, Instance.GetParentComponent);

    finally
      AReader.Free;
    end;
  finally
    ADoc.Free;
  end;
end;

function ChangeToText(Component: TComponent): string;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create('');
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;


function ChangeToComponent(Value: string; Instance: TComponent): TComponent;
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjecttextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(Instance);
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;



function VarToColor(const V: Variant):TColor;
begin
  Result:=VarToIntDef(V,clWhite);
end;

function VarToColorDef(const V: Variant;const ADefault: TColor):TColor;
begin
  Result:=VarToIntDef(V,ADefault);
end;

function CenterRect(R:TRect;Height:Integer=-1;Width:Integer=-1):TRect;
var
  P:TPoint;iTop,iLeft,iRight,iBottom:Integer;
begin
  P := CenterPoint(R);
  iTop:= R.Top;
  iLeft:= R.Left;
  iRight:= R.Right;
  iBottom:= R.Bottom;
  
  if Height<>-1 then
  begin
    iTop:=P.Y-Trunc(Height/2);
    iBottom:=P.Y+Trunc(Height/2);
  end;

  if Width<>-1 then
  begin
    iLeft:=P.X-Trunc(Width/2);
    iRight:=P.X+Trunc(Width/2);
  end;

  Result:=Rect(iLeft,iTop,iRight,iBottom);
end;


function VarToFloatDef(const V: Variant;const ADefault: Double):Double;
begin
  if VarIsNumeric(V) then
    Result:=V
  else
    Result:=ADefault;
end;

function VarToFloat(const V: Variant):Double;
begin
  Result:=VarToFloatDef(V,0);
end;


function VarToIntDef(const V: Variant;const ADefault: Integer):Integer;
begin
  if VarIsNumeric(V) then
    Result:=V
  else
    Result:=ADefault;
end;

function VarToInt(const V: Variant):Integer;
begin
  Result:=VarToIntDef(V,0);
end;

function InvertColor(AColor:TColor):TColor;
var R,G,B:Byte; I:Integer;
begin
  I:= ColorToRGB(AColor);
  G:=255-Windows.GetGValue(I);
  R:=255-Windows.GetRValue(I);
  B:=255-Windows.GetBValue(I);
  Result:= Windows.RGB(R,G,B);
end;

procedure PenAssign(PenDes,PenSou:TPen);
begin
  if PenDes.Color<>PenSou.Color then PenDes.Color:=PenSou.Color;
  if PenDes.Mode<>PenSou.Mode then  PenDes.Mode:=PenSou.Mode;
  if PenDes.Style<>PenSou.Style then  PenDes.Style:=PenSou.Style;
  if PenDes.Width<>PenSou.Width then  PenDes.Width:=PenSou.Width ;

end;

procedure BrushAssign(BrushDes,BrushSou:TBrush);
begin
  BrushDes.Color:=BrushSou.Color;
  BrushDes.Style:=BrushSou.Style;
  BrushDes.Bitmap.Assign(BrushSou.Bitmap);
end;

function DrawFlagsToDTFlags(Flags: Integer): Integer;
begin
  Result := DT_NOPREFIX;
  if gAlignLeft and Flags <> 0 then
    Result := Result or DT_LEFT;
  if gAlignRight and Flags <> 0 then
    Result := Result or DT_RIGHT;
  if gAlignHCenter and Flags <> 0 then
    Result := Result or DT_CENTER;
  if gAlignTop and Flags <> 0 then
    Result := Result or DT_TOP;
  if gAlignBottom and Flags <> 0 then
    Result := Result or DT_BOTTOM;
  if gAlignVCenter and Flags <> 0 then
    Result := Result or DT_VCENTER;
  if gSingleLine and Flags <> 0 then
    Result := Result or DT_SINGLELINE;
  if gDontClip and Flags <> 0 then
    Result := Result or DT_NOCLIP;
  if gExpandTabs and Flags <> 0 then
    Result := Result or DT_EXPANDTABS;
  if gShowPrefix and Flags <> 0 then
    Result := Result and not DT_NOPREFIX;
  if gWordBreak and Flags <> 0 then
    Result := Result or DT_WORDBREAK or DT_EDITCONTROL;
  if gShowEndEllipsis and Flags <> 0 then
    Result := Result or DT_END_ELLIPSIS;
  if gDontPrint and Flags <> 0 then
    Result := Result or DT_CALCRECT;
  if gShowPathEllipsis and Flags <> 0 then
    Result := Result or DT_PATH_ELLIPSIS;
end;


{function ColorToRGB(Color: TColor): Longint;
var
  R, G, B: Byte;
begin
  Result := ColorToRGB(Color);
  if Color < 0 then
  begin
    R := GetRValue(Result);
    G := GetGValue(Result);
    B := GetBValue(Result);
    Result := RGB(B, G, R);
  end;  
end; }


function GetRValue(Color: Integer): Byte;
begin
  Result := Byte(Color);
end;

function GetGValue(Color: Integer): Byte;
begin
  Result := Byte(Color shr 8);
end;

function GetBValue(Color: Integer): Byte;
begin
  Result := Byte(Color shr 16);
end;

function RGB(R, G, B: Byte): Integer;
begin
  Result := (R or (G shl 8) or (B shl 16));
end;


function GetRealColor(AColor: TColor): TColor;
var
  DC: HDC;
begin
  DC := GetDC(0);
  Result := GetNearestColor(DC, AColor);
  ReleaseDC(0, DC);
end;

function GetLightColor(ABtnFaceColorPart, AHighlightColorPart, AWindowColorPart: TDrawColorPart): TColor;
var
  ABtnFaceColor, AHighlightColor, AWindowColor: TColor;

  function GetLightIndex(ABtnFaceValue, AHighlightValue, AWindowValue: Byte): Integer;
  begin
    Result :=
      MulDiv(ABtnFaceValue, ABtnFaceColorPart, 100) +
      MulDiv(AHighlightValue, AHighlightColorPart, 100) +
      MulDiv(AWindowValue, AWindowColorPart, 100);
    if Result < 0 then Result := 0;
    if Result > 255 then Result := 255;
  end;

begin
  ABtnFaceColor := ColorToRGB(clBtnFace);
  AHighlightColor := ColorToRGB(clHighlight);
  AWindowColor := ColorToRGB(clWindow);
  if (ABtnFaceColor = 0) or (ABtnFaceColor = $FFFFFF) then
    Result := AHighlightColor
  else
    Result := RGB(
      GetLightIndex(GetRValue(ABtnFaceColor), GetRValue(AHighlightColor), GetRValue(AWindowColor)),
      GetLightIndex(GetGValue(ABtnFaceColor), GetGValue(AHighlightColor), GetGValue(AWindowColor)),
      GetLightIndex(GetBValue(ABtnFaceColor), GetBValue(AHighlightColor), GetBValue(AWindowColor)));
end;

function GetLightBtnFaceColor: TColor;

  function GetLightValue(Value: Byte): Byte;
  begin
    Result := Value + MulDiv(255 - Value, 16, 100);
  end;

begin
  Result := ColorToRGB(clBtnFace);
  Result := RGB(
    GetLightValue(GetRValue(Result)),
    GetLightValue(GetGValue(Result)),
    GetLightValue(GetBValue(Result)));
  Result := GetRealColor(Result);
end;

function GetLightDownedColor: TColor;
begin
  Result := GetRealColor(GetLightColor(11, 9, 73));
end;

function GetLightDownedSelColor: TColor;
begin
  Result := GetRealColor(GetLightColor(14, 44, 40));
end;

function GetLightSelColor: TColor;
begin
  Result := GetRealColor(GetLightColor(-2, 30, 72));
end;

{ TDrawRegion }

constructor TDrawRegion.Create(AHandle: TDrawRegionHandle);
begin
  inherited Create;
  FHandle := AHandle;
end;

constructor TDrawRegion.Create(const ABounds: TRect);
var
  AHandle: TDrawRegionHandle;
begin
  AHandle := CreateRectRgnIndirect(ABounds);
  Create(AHandle);
end;

constructor TDrawRegion.Create;
begin
  Create(0, 0, 0, 0);

end;

constructor TDrawRegion.Create(ALeft, ATop, ARight, ABottom: Integer);
begin
  Create(Rect(ALeft, ATop, ARight, ABottom));
end;

destructor TDrawRegion.Destroy;
begin
  DestroyHandle;
  inherited;
end;

function TDrawRegion.GetIsEmpty: Boolean;
var
  R: TRect;
begin
  Result := GetRgnBox(FHandle, R) = NULLREGION;
end;

procedure TDrawRegion.DestroyHandle;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
end;

procedure TDrawRegion.Combine(ARegion: TDrawRegion; AOperation: TDrawRegionOperation;
  ADestroyRegion: Boolean = True);
const
  Modes: array[TDrawRegionOperation] of Integer = (RGN_COPY, RGN_OR, RGN_DIFF, RGN_AND);
begin
  if AOperation = roSet then
    CombineRgn(FHandle, ARegion.Handle, 0, Modes[AOperation])
  else
    CombineRgn(FHandle, FHandle, ARegion.Handle, Modes[AOperation]);

  if ADestroyRegion then ARegion.Free;
end;

procedure TDrawRegion.Offset(DX, DY: Integer);
begin
  OffsetRgn(FHandle, DX, DY);
end;

function TDrawRegion.PtInRegion(const Pt: TPoint): Boolean;
begin
  Result := Windows.PtInRegion(Handle, Pt.X, Pt.Y);
end;

function TDrawRegion.PtInRegion(X, Y: Integer): Boolean;
begin
  Result := PtInRegion(Point(X, Y));
end;

function TDrawRegion.RectInRegion(const R: TRect): Boolean;
begin
  Result := Windows.RectInRegion(Handle, R);

end;

function TDrawRegion.RectInRegion(ALeft, ATop, ARight, ABottom: Integer): Boolean;
begin
  Result := RectInRegion(Rect(ALeft, ATop, ARight, ABottom));
end;

{ TDrawCanvas }

constructor TDrawCanvas.Create(ACanvas:TCanvas);
begin
  inherited Create;
  FCanvas := ACanvas;
end;

function TDrawCanvas.GetBrush: TBrush;
begin
  Result := Canvas.Brush;
end;

function TDrawCanvas.GetCopyMode: TCopyMode;
begin
  Result := Canvas.CopyMode;
end;

function TDrawCanvas.GetFont: TFont;
begin
  Result := Canvas.Font;
end;

function TDrawCanvas.GetHandle: HDC;
begin
  Result := Canvas.Handle;
end;

function TDrawCanvas.GetPen: TPen;
begin
  Result := Canvas.Pen;
end;

function TDrawCanvas.GetWindowOrg: TPoint;
begin
  GetWindowOrgEx(Handle, Result);
end;

procedure TDrawCanvas.SetBrush(Value: TBrush);
begin
  Canvas.Brush := Value;
end;

procedure TDrawCanvas.SetCopyMode(Value: TCopyMode);
begin
  Canvas.CopyMode := Value;
end;

procedure TDrawCanvas.SetFont(Value: TFont);
begin
  Canvas.Font := Value;
end;

procedure TDrawCanvas.SetPen(Value: TPen);
begin
  Canvas.Pen := Value;
end;

procedure TDrawCanvas.SetPixel(X, Y: Integer; Value: TColor);
begin
  Canvas.Pixels[X, Y] := Value;
end;

procedure TDrawCanvas.SetWindowOrg(const P: TPoint);
begin
  SetWindowOrgEx(Handle, P.X, P.Y, nil);
end;

procedure TDrawCanvas.CopyRect(const Dest: TRect; ACanvas: TCanvas;
  const Source: TRect);
begin
  if IsRectEmpty(Dest) or IsRectEmpty(Source) then Exit;
  Canvas.CopyRect(Dest, ACanvas, Source);
end;

procedure TDrawCanvas.Draw(X, Y: Integer; Graphic: TGraphic);
begin
  Canvas.Draw(X, Y, Graphic);
end;

procedure TDrawCanvas.DrawComplexFrame(const R: TRect;
  ALeftTopColor, ARightBottomColor: TColor; ABorders: TDrawBorders;
  ABorderWidth: Integer);
var
  ABorder: TDrawBorder;

  function GetBorderColor: TColor;
  begin
    if ABorder in [dLeft, dTop] then
      Result := ALeftTopColor
    else
      Result := ARightBottomColor;
  end;

  function GetBorderBounds: TRect;
  begin
    Result := R;
    with Result do
      case ABorder of
	dLeft:
	  Right := Left + ABorderWidth;
	dTop:
	  Bottom := Top + ABorderWidth;
	dRight:
	  Left := Right - ABorderWidth;
	dBottom:
	  Top := Bottom - ABorderWidth;
      end;
  end;

begin
  for ABorder := Low(ABorder) to High(ABorder) do
    if ABorder in ABorders then
    begin
      SetBrushColor(GetBorderColor);
      FillRect(GetBorderBounds);
    end;
end;

procedure TDrawCanvas.DrawFocusRect(const R: TRect);
begin
  with TCanvasAccess(Canvas) do
  begin
    Brush.Style := bsSolid;
    SetBrushColor(clWhite);
    Font.Color := clBlack;
    RequiredState([csFontValid]);
    DrawFocusRect(R);
  end;
end;

procedure TDrawCanvas.DrawGlyph(X, Y: Integer; AGlyph: TBitmap; AEnabled: Boolean = True;
  ABackgroundColor: TColor = clNone{; ATempCanvas: TCanvas = nil});
var
  APrevBrushStyle: TBrushStyle;
  AImageList: TImageList;
  ABitmap: TBitmap;
begin
  if AEnabled  then
  begin
    APrevBrushStyle := Brush.Style;
    if ABackgroundColor = clNone then
      Brush.Style := bsClear
    else
      Brush.Color := ABackgroundColor;
    Canvas.BrushCopy(Bounds(X, Y, AGlyph.Width, AGlyph.Height), AGlyph,
      Rect(0, 0, AGlyph.Width, AGlyph.Height), AGlyph.TransparentColor);
    Brush.Style := APrevBrushStyle;
    Exit;
  end;

  AImageList := nil;
  ABitmap := nil;
  try
    AImageList := TImageList.Create(nil);
    AImageList.Width := AGlyph.Width;
    AImageList.Height := AGlyph.Height;
    if ABackgroundColor <> clNone then
      begin
        ABitmap := TBitmap.Create;
        ABitmap.Width := AImageList.Width;
        ABitmap.Height := AImageList.Height;
        with ABitmap.Canvas do
        begin
          Brush.Color := ABackgroundColor;
          FillRect(Rect(0, 0, ABitmap.Width, ABitmap.Height));
        end;
      end;

    if AGlyph.TransparentMode = tmFixed then
      AImageList.AddMasked(AGlyph, AGlyph.TransparentColor)
    else
      AImageList.AddMasked(AGlyph, clDefault);

    if ABitmap <> nil then
    begin
      AImageList.Draw(ABitmap.Canvas, 0, 0, 0, dsTransparent,itImage, AEnabled);
      Draw(X, Y, ABitmap);
    end
    else
	AImageList.Draw(Canvas, X, Y, 0,dsTransparent, itImage, AEnabled);
  finally
    ABitmap.Free;
    AImageList.Free;
  end;
end;

procedure TDrawCanvas.DrawImage(Images: TCustomImageList; X, Y, Index: Integer;
  Enabled: Boolean = True);
begin
  if (0 <= Index) and (Index < Images.Count) then
    Images.Draw(Canvas, X, Y, Index,Enabled);
end;

procedure TDrawCanvas.DrawText(const Text: string; R: TRect; Flags: Integer;
  Enabled: Boolean);
var

  AUseDrawText: Boolean;

  PrevBrushStyle: TBrushStyle;
  PrevFontColor: TColor;

  procedure ProcessFlags;
  var
    ASize: TSize;
    ASizeR: TRect;
  begin
    ASize := TextExtent(Text);
    if (ASize.cx < R.Right - R.Left) and (ASize.cy < R.Bottom - R.Top) then
      Flags := Flags or gDontClip;
    if AUseDrawText then
    begin
      if (Flags and gSingleLine = 0) and (Flags and (gAlignBottom or gAlignVCenter) <> 0) then
      begin
        ASizeR := Rect(0, 0, R.Right - R.Left - Ord(not Enabled), 0);
        TextExtent(Text, ASizeR, Flags);
	case Flags and (gAlignBottom or gAlignVCenter) of
	  gAlignBottom:
            R.Top := R.Bottom - (ASizeR.Bottom - ASizeR.Top + Ord(not Enabled));
	  gAlignVCenter:
            R.Top := (R.Top + R.Bottom - (ASizeR.Bottom - ASizeR.Top)) div 2;
        end;
      end;
      Flags := DrawFlagsToDTFlags(Flags);
    end
    else
    begin
      if ASize.cx < R.Right - R.Left then
	case Flags and (gAlignLeft or gAlignRight or gAlignHCenter) of
	  gAlignRight:
            R.Left := R.Right - ASize.cx - Ord(not Enabled);
	  gAlignHCenter:
            R.Left := (R.Left + R.Right - ASize.cx) div 2;
        end;
      if ASize.cy < R.Bottom - R.Top then
	case Flags and (gAlignTop or gAlignBottom or gAlignVCenter) of
	  gAlignBottom:
            R.Top := R.Bottom - ASize.cy - Ord(not Enabled);
	  gAlignVCenter:
            R.Top := (R.Top + R.Bottom - ASize.cy) div 2;
        end;
      if Flags and gDontClip = 0 then
        Flags := ETO_CLIPPED
      else
        Flags := 0;
    end;
    Flags := Flags and not (gShowEndEllipsis or gShowPathEllipsis);
  end;

  procedure DoDrawText;
  begin
    if AUseDrawText then
      Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags)
    else
      ExtTextOut(Canvas.Handle, R.Left, R.Top, Flags, @R, PChar(Text), Length(Text), nil);
  end;

begin
  if Length(Text) = 0 then Exit;
  AUseDrawText := (Flags and gSingleLine = 0) or
    (Flags and (gShowPrefix or gShowEndEllipsis or gShowPathEllipsis) <> 0);
  ProcessFlags;
  PrevBrushStyle := Brush.Style;
  PrevFontColor := Font.Color;
  if not Enabled then
  begin
    with R do
    begin
      Inc(Left);
      Inc(Top);
    end;
    Brush.Style := bsClear;
    Font.Color := clBtnHighlight;
    DoDrawText;
    OffsetRect(R, -1, -1);
    Font.Color := clBtnShadow;
  end;
  DoDrawText;
  if Brush.Style <> PrevBrushStyle then
    Brush.Style := PrevBrushStyle;
  Font.Color := PrevFontColor;
end;

procedure TDrawCanvas.DrawEdge(const R: TRect; ASunken, AOuter: Boolean;
  ABorders: TDrawBorders);
begin
  if ASunken then
    if AOuter then
      DrawComplexFrame(R, clBtnShadow, clBtnHighlight, ABorders)
    else
      DrawComplexFrame(R, cl3DDkShadow, cl3DLight, ABorders)
  else
    if AOuter then
      DrawComplexFrame(R, cl3DLight, cl3DDkShadow, ABorders)
    else
      DrawComplexFrame(R, clBtnHighlight, clBtnShadow, ABorders);
end;

procedure TDrawCanvas.FillRect(const R: TRect; ABitmap: TBitmap = nil);
var
  ABitmapSize, AOffset: TPoint;
  AFirstCol, AFirstRow, ALastCol, ALastRow, I, J: Integer;
  ABitmapRect, ACellRect: TRect;
begin
  if (ABitmap = nil) or ABitmap.Empty then
  begin
    Canvas.FillRect(R);
    Exit;
  end;

  with ABitmapSize, ABitmap do
  begin
    X := Width;
    Y := Height;
  end;
  with R, ABitmapSize do
  begin
    AFirstCol := Left div X;
    AFirstRow := Top div Y;
    ALastCol := Right div X - Ord(Right mod X = 0);
    ALastRow := Bottom div Y - Ord(Bottom mod Y = 0);
    for J := AFirstRow to ALastRow do
      for I := AFirstCol to ALastCol do
      begin
        AOffset.X := I * X;
        AOffset.Y := J * Y;
	ACellRect := Bounds(AOffset.X, AOffset.Y, X, Y);
	IntersectRect(ACellRect, ACellRect, R);
	ABitmapRect := ACellRect;
	OffsetRect(ABitmapRect, -AOffset.X, -AOffset.Y);
	CopyRect(ACellRect, ABitmap.Canvas, ABitmapRect);
      end;
  end;
end;

procedure TDrawCanvas.FillRect(R: TRect; const AParams: TDrawViewParams;
  ABorders: TDrawBorders = []; ABorderColor: TColor = clDefault; ALineWidth: Integer = 1);
begin
  FrameRect(R, ABorderColor, ALineWidth, ABorders);
  with R do
  begin
    if dLeft in ABorders then
      Inc(Left, ALineWidth);
    if dRight in ABorders then
      Dec(Right, ALineWidth);
    if dTop in ABorders then
      Inc(Top, ALineWidth);
    if dBottom in ABorders then
      Dec(Bottom, ALineWidth);
  end;
  SetBrushColor(AParams.Color);
  FillRect(R, AParams.Bitmap);
end;


function TDrawCanvas.FontHeight(AFont: TFont): Integer;
begin
  Font := AFont;
  Result := TextHeight('QQ');
end;

procedure TDrawCanvas.FrameRect(const R: TRect; Color: TColor = clDefault;
  ALineWidth: Integer = 1; ABorders: TDrawBorders = DrawBordersAll);
begin
  if Color <> clDefault then
  begin
    SetBrushColor(Color);
    Brush.Style := bsSolid;  
  end;
  with R do
  begin
    if dLeft in ABorders then
      FillRect(Rect(Left, Top, Left + ALineWidth, Bottom));
    if dRight in ABorders then
      FillRect(Rect(Right - ALineWidth, Top, Right, Bottom));
    if dTop in ABorders then
      FillRect(Rect(Left, Top, Right, Top + ALineWidth));
    if dBottom in ABorders then
      FillRect(Rect(Left, Bottom - ALineWidth, Right, Bottom));
  end;
end;

procedure TDrawCanvas.InvertFrame(const R: TRect; ABorderSize: Integer);
begin
  with R do
  begin
    InvertRect(Rect(Left, Top, Left + ABorderSize, Bottom));
    InvertRect(Rect(Right - ABorderSize, Top, Right, Bottom));
    InvertRect(Rect(Left + ABorderSize, Top,
      Right - ABorderSize, Top + ABorderSize));
    InvertRect(Rect(Left + ABorderSize, Bottom - ABorderSize,
      Right - ABorderSize, Bottom));
  end;
end;

procedure TDrawCanvas.InvertRect(R: TRect);
begin
  with Canvas do
  begin
    CopyMode := cmDstInvert;
    CopyRect(R, Canvas, R);
    CopyMode := cmSrcCopy;
  end;
end;

procedure TDrawCanvas.LineTo(X, Y: Integer);
begin
  Canvas.LineTo(X, Y);
end;

procedure TDrawCanvas.MoveTo(X, Y: Integer);
begin
  Canvas.MoveTo(X, Y);
end;

procedure TDrawCanvas.Polygon(const Points: array of TPoint);
begin
  Canvas.Polygon(Points);
end;

procedure TDrawCanvas.Polyline(const Points: array of TPoint);
begin
  Canvas.Polyline(Points);
end;

function TDrawCanvas.TextExtent(const Text: string): TSize;
begin
  TCanvasAccess(Canvas).RequiredState([csHandleValid, csFontValid]);
  Result.cX := 0;
  Result.cY := 0;
  GetTextExtentPoint(Handle, PChar(Text), Length(Text), Result);
end;

procedure TDrawCanvas.TextExtent(const Text: string; var R: TRect; Flags: Integer);
var
  RWidth, RHeight, TextWidth, TextHeight: Integer;
  procedure CalcRSizes(var AWidth, AHeight: Integer);
  begin
    with R do
    begin
      AWidth := Right - Left;
      AHeight := Bottom - Top;
    end;
  end;

  procedure AlignR;
  begin
    if Flags and DT_CENTER <> 0 then
      OffsetRect(R, (RWidth - TextWidth) div 2, 0)
    else
      if Flags and DT_RIGHT <> 0 then
        OffsetRect(R, RWidth - TextWidth, 0);
    if Flags and DT_VCENTER <> 0 then
      OffsetRect(R, 0, (RHeight - TextHeight) div 2)
    else
      if Flags and DT_BOTTOM <> 0 then
        OffsetRect(R, 0, RHeight - TextHeight);
  end;
begin
  CalcRSizes(RWidth, RHeight);
  Flags := DrawFlagsToDTFlags(Flags);
  Windows.DrawText(Canvas.Handle, PChar(Text), Length(Text), R,
    Flags and not DT_VCENTER or DT_CALCRECT);
  CalcRSizes(TextWidth, TextHeight);
  AlignR;
end;


function TDrawCanvas.TextHeight(const Text: string): Integer;
begin
  Result := TextExtent(Text).cy;
end;

function TDrawCanvas.TextWidth(const Text: string): Integer;
begin
  Result := TextExtent(Text).cx;
end;

procedure TDrawCanvas.AssignParams(AParams: TDrawViewParams);
begin
  SetBrushColor(AParams.Color);
  Font := AParams.Font;
  Font.Color := AParams.TextColor;
end;

procedure TDrawCanvas.SetBrushColor(Value: TColor);
begin
  if Brush.Color <> Value then
    Brush.Color := Value;
end;


procedure TDrawCanvas.GetTextStringsBounds(Text: string; R: TRect; Flags: Integer;
  Enabled: Boolean; var ABounds: TRectArray);
var
  AAlignHorz, AAlignVert, AMaxCharCount: Integer;
  ATextR: TRect;
  AStringSize: TSize;

  procedure PrepareRects;
  begin
    if not Enabled then
      with R do
      begin
        Dec(Right);
        Dec(Bottom);
      end;
    ATextR := R;
    TextExtent(Text, ATextR, Flags);
    case AAlignVert of
      gAlignBottom:
        OffsetRect(ATextR, 0, R.Bottom - ATextR.Bottom);
      gAlignVCenter:
        OffsetRect(ATextR, 0, (R.Bottom - ATextR.Bottom) div 2);
    end;
  end;

  procedure CheckMaxCharCount;

    function ProcessSpecialChars: Boolean;
    const
      SpecialChars = [#10, #13];
    var
      I, ACharCount: Integer;
    begin
      Result := False;
      for I := 1 to AMaxCharCount do
        if Text[I] in SpecialChars then
        begin
          AMaxCharCount := I - 1;
          ACharCount := 1;
          if (I < Length(Text)) and
            (Text[I + 1] in SpecialChars) and (Text[I] <> Text[I + 1]) then
            Inc(ACharCount);
          Delete(Text, I, ACharCount);
          Result := True;
          Break;
        end;
    end;

    procedure ProcessSpaces;
    var
      I: Integer;
    begin
      if AMaxCharCount < Length(Text) then
        for I := AMaxCharCount + 1 downto 1 do
          if Text[I] = ' ' then
          begin
            if I < AMaxCharCount then
            begin
              AMaxCharCount := I;
	      if AAlignHorz <> gAlignLeft then
              begin
                Delete(Text, I, 1);
                Dec(AMaxCharCount);
              end;
            end;  
            Break;
          end;
    end;

  begin
    if not ProcessSpecialChars then
      ProcessSpaces;
  end;

  procedure GetStringSize;
  begin
    if AMaxCharCount = 0 then
      AStringSize.cx := 0
    else
      GetTextExtentPoint(Handle, PChar(Copy(Text, 1, AMaxCharCount)),
        AMaxCharCount, AStringSize);
  end;

  function GetBounds: TRect;
  begin
    Result := ATextR;
    with Result, AStringSize do
    begin
      case AAlignHorz of
	gAlignLeft:
          Right := Left + cx;
	gAlignRight:
          Left := Right - cx;
	gAlignHCenter:
          begin
            Left := (Left + Right - cx) div 2;
            Right := Left + cx;
          end;
      end;
      Bottom := Top + cy;
    end;
    ATextR.Top := Result.Bottom;
  end;

begin
  if Text = '' then Exit;
  if Flags and gShowPrefix <> 0 then
  begin
    Text := StripHotKey(Text);
    Flags := Flags and not gShowPrefix;
  end;
  AAlignHorz := Flags and (gAlignLeft or gAlignRight or gAlignHCenter);
  AAlignVert := Flags and (gAlignTop or gAlignBottom or gAlignVCenter);
  PrepareRects;
  repeat
    GetTextExtentExPoint(Handle, PChar(Text), Length(Text), R.Right - R.Left,
      @AMaxCharCount, nil, AStringSize);
    CheckMaxCharCount;
    GetStringSize;
    SetLength(ABounds, High(ABounds) + 2);
    ABounds[High(ABounds)] := GetBounds;
    Delete(Text, 1, AMaxCharCount);
  until Text = '';
end;


procedure TDrawCanvas.ExcludeClipRect(const R: TRect);
begin
  with R do
    Windows.ExcludeClipRect(Handle, Left, Top, Right, Bottom);
end;

procedure TDrawCanvas.IntersectClipRect(const R: TRect);
begin
  with R do
    Windows.IntersectClipRect(Canvas.Handle, Left, Top, Right, Bottom);
end;

function TDrawCanvas.GetClipRegion: TDrawRegion;
begin
  Result := TDrawRegion.Create;
  if GetClipRgn(Handle, Result.Handle) = 0 then
    SetRectRgn(Result.Handle, 0, 0, MaxInt div 20, MaxInt div 20);
end;

procedure TDrawCanvas.SetClipRegion(ARegion: TDrawRegion; AOperation: TDrawRegionOperation;
  ADestroyRegion: Boolean = True);
var
  AClipRegion: TDrawRegion;
  AWindowOrg: TPoint;
begin
  if AOperation = roSet then
    SelectClipRgn(Handle, ARegion.Handle)
  else
  begin
    AWindowOrg := WindowOrg;
    ARegion.Offset(-AWindowOrg.X, -AWindowOrg.Y);
    AClipRegion := GetClipRegion;
    AClipRegion.Combine(ARegion, AOperation, False);
    SetClipRegion(AClipRegion, roSet);
  end;
  if ADestroyRegion then ARegion.Free;
end;

function TDrawCanvas.RectVisible(R: TRect): Boolean;
begin
  Result := Windows.RectVisible(Handle, R);
end;

{ TScreenCanvas }

type
  TScreenCanvas = class(TCanvas)
  private
    procedure FreeHandle;
  protected
    procedure CreateHandle; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

constructor TScreenCanvas.Create;
begin
  inherited;
end;

destructor TScreenCanvas.Destroy;
begin
  FreeHandle;
  inherited;
end;


procedure TScreenCanvas.FreeHandle;
begin
  ReleaseDC(0, Handle);
  Handle := 0;
end;

procedure TScreenCanvas.CreateHandle;
begin
  Handle := GetDC(0);
end;


destructor TDrawCanvas.Destroy;
begin

  inherited;
end;

procedure TDrawCanvas.DrawComplexFrameLine(const R: TRect;
  APen:TPen;ABorders: TDrawBorders);
var
  ABorder: TDrawBorder; 

  function GetBorder1Point: TPoint;
  begin
    with R,Result do
      case ABorder of
	dLeft,dTop:begin
		     X := Left;
		     Y := Top;
		   end;

	dRight,dBottom: begin
			  X := Right;
			  Y := Bottom;
			end;
      end;
  end;
  function GetBorder2Point: TPoint;
  begin
    with R,Result do
      case ABorder of
	dLeft,dBottom:begin
		     X := Left;
		     Y := Bottom;
		   end;

	dRight,dTop: begin
			  X := Right;
			  Y := top;
			end;
      end;
  end;

begin
  if Brush.Style<>bsClear then Brush.Style:=bsClear;
  Pen.Assign(APen);

  for ABorder := Low(ABorder) to High(ABorder) do
    if ABorder in ABorders then
    begin
      MoveTo(GetBorder1Point.X,GetBorder1Point.Y);
      LineTo(GetBorder2Point.X,GetBorder2Point.y);
    end;
end;


procedure TDrawCanvas.DrawLine(X1, Y1, X2, Y2: Integer; APen: TPen);
begin
  if APen<>nil then Pen.Assign(APen);
  if Brush.Style<>bsClear then Brush.Style:=bsClear;
  MoveTo(X1,Y1);
  LineTo(X2,Y2);
end;

procedure TDrawCanvas.DrawLine(P1, P2: TPoint; APen: TPen);
begin
  DrawLine(P1.X,P1.Y,P2.X,P2.Y,APen);

end;

procedure TDrawCanvas.DrawLine(R: TRect; ABorders: TDrawBorders;
  APen: TPen);

  procedure GetPoint(ABorder:TDrawBorder;var P1,P2:TPoint);
  begin
      case ABorder of
	dLeft:
	  begin
	    P1 := R.TopLeft;
	    P2 := Point(R.Left,R.Bottom);
	  end;
	dTop:
	  begin
	    P1 := R.TopLeft;
	    P2 := Point(R.Right,R.Top);
	  end;
	dRight:
	  begin
	    P1 := Point(R.Right,R.Top);
	    P2 := R.BottomRight;
	  end;

	dBottom:
	  begin
	    P1 := Point(R.Left,R.Bottom);
	    P2 := R.BottomRight;
	  end;
      end;

  end;

var P1,P2:TPoint;ABorder:TDrawBorder;
begin
  if APen<>nil then Pen.Assign(APen);
  R.Bottom:= R.Bottom-1;
  R.Right := R.Right-1;
  for ABorder := Low(ABorder) to High(ABorder) do
    if ABorder in ABorders then
    begin
      GetPoint(ABorder,P1,P2);
      DrawLine(P1,P2,nil);
    end;
end;

{ TDrawScreenCanvas }

constructor TDrawScreenCanvas.Create;
begin
  inherited Create(TScreenCanvas.Create);
end;

destructor TDrawScreenCanvas.Destroy;
begin
  FCanvas.Free;
  inherited;
end;


constructor TRegisteredViews.Create(ARegisterClasses: Boolean = False);
begin
  inherited Create;
  FRegisterClasses := ARegisterClasses;
  FItems := TStringList.Create;
end;

destructor TRegisteredViews.Destroy;
begin
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TRegisteredViews.Clear;
begin
  FItems.Clear;
end;

function TRegisteredViews.FindByClassName(const AClassName: string): TClass;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[I].ClassName = AClassName then
    begin
      Result := Items[I];
      Exit;
    end;
  end;
end;

function TRegisteredViews.FindByDescription(const ADescription: string):
	TClass;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Descriptions[I] = ADescription then
    begin
      Result := Items[I];
      Exit;
    end;
  end;
end;

function TRegisteredViews.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TRegisteredViews.GetDescription(Index: Integer): string;
begin
  Result := FItems[Index];
end;

function TRegisteredViews.GetDescriptionByClass(AClass: TClass): string;
var
  AIndex: Integer;
begin
  AIndex := GetIndexByClass(AClass);
  if AIndex = -1 then
    Result := ''
  else
    Result := Descriptions[AIndex];
end;

function TRegisteredViews.GetIndexByClass(AClass: TClass): Integer;
var I:Integer;
begin
  Result:=-1;
  for I:=0 to FItems.Count -1 do
  if PRegisteredRec(FItems.Objects[I]).AClass=AClass then
  begin
    Result := I;
    Break;
  end;
  
end;

function TRegisteredViews.GetItem(Index: Integer): TClass;
begin
  Result := TClass(PRegisteredRec(FItems.Objects[Index]).AClass);
end;

procedure TRegisteredViews.Register(AClass: TClass; const ADescription:
	string;RegisteredType:TRegisteredType=rgtDefault);
var RegisteredRec:PRegisteredRec;
begin
  if GetIndexByClass(AClass) = -1 then
  begin
    New(RegisteredRec);
    RegisteredRec.AType:=RegisteredType;
    RegisteredRec.AClass:=AClass;
    FItems.AddObject(ADescription, TObject(RegisteredRec));
    if FRegisterClasses then RegisterClass(TPersistentClass(AClass));
  end;
end;

procedure TRegisteredViews.Unregister(AClass: TClass);
var
  I: Integer;
begin
  I := GetIndexByClass(AClass);
  if I <> -1 then
    FItems.Delete(I);
end;

function RegisteredViews: TRegisteredViews;
begin
  if (FRegisteredViews = nil) then
    FRegisteredViews := TRegisteredViews.Create(True);
  Result := FRegisteredViews;
end;

function TRegisteredViews.GetItemRec(Index: Integer): TRegisteredRec;
begin
  Result := PRegisteredRec(FItems.Objects[Index])^;
end;

{ TMFBrushStyleList }

procedure TMFBrushStyleList.Add(StyleName: String);
begin

end;

procedure TMFBrushStyleList.Clear;
begin

end;

constructor TMFBrushStyleList.Create;
begin
  FBrush:=TStringList.Create;
end;

procedure TMFBrushStyleList.Delete(StyleName: String);
begin

end;

destructor TMFBrushStyleList.Destroy;
begin
  Clear;
  FBrush.Free;
  inherited;
end;

function TMFBrushStyleList.GetBrushBitMap(StyleName: String;
  AColor: TColor): TBitmap;
begin

end;

function TMFBrushStyleList.GetBrushImage(StyleName: String): TBitmap;
begin

end;

function TMFBrushStyleList.GetBrushTexture(StyleName: String;
  AColor: TColor): TBitmap;
begin

end;

function TMFBrushStyleList.GetBrushTransition(StyleName: String; AColor,
  BColor: TColor; StyleType: Integer): TBitmap;
begin

end;



end.
