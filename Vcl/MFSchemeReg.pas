{*******************************************************************************

项目名称 :ThinkWide
版权所有 (c) 2005
+-------------------------------------------------------------------------------
项目:


版本: 1


创建日期:2005-1-5 19:02:09


作者: 章称

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


ToDo:

*******************************************************************************}

unit MFSchemeReg;

interface

uses
  Classes,Windows,Messages ,Controls,DesignIntf,  DesignEditors,MFPaint,
  MFBaseScheme,MFScheme,MFBaseSchemePainter,MFCardSchemeView,
  MFSchemeDesignForm,MFGunterSchemeView,MFDBScheme;

type
  TMFSchemeEditor =class(TComponentEditor)
  private

  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer;  override;
  
  end;
  
  TMFViewTypeProperty = class(TClassProperty)
  protected
    function HasSubProperties: Boolean;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

procedure SetNewClassRefresh;

procedure Register;
{$R scheme.dcr}
implementation

function TMFViewTypeProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
  if not HasSubProperties then
    Exclude(Result, paSubProperties);
  Result := Result - [paReadOnly] +
    [paValueList, paSortList, paRevertable, paVolatileSubProperties];
end;

function TMFViewTypeProperty.GetValue: string;
begin
  if HasSubProperties then
    Result := RegisteredViews.GetDescriptionByClass(TMFBaseSchemeView(GetOrdValue).ClassType)
  else
    Result := '';
end;

procedure TMFViewTypeProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := 0 to RegisteredViews.Count - 1 do
    Proc(RegisteredViews.Descriptions[I]);
end;

function TMFViewTypeProperty.HasSubProperties: Boolean;
var
  I: Integer;
begin
  for I := 0 to PropCount - 1 do
  begin
    Result := TSchemeViewItem(GetComponent(I)).SchemeView <> nil;
    if not Result then Exit;
  end;
  Result := True;
end;

procedure TMFViewTypeProperty.SetValue(const Value: string);
var
  ASchemeViewClass: TMFBaseSchemeViewClass;
  I: Integer;
begin
  ASchemeViewClass := TMFBaseSchemeViewClass(RegisteredViews.FindByClassName(Value));
  if ASchemeViewClass = nil then
    ASchemeViewClass := TMFBaseSchemeViewClass(RegisteredViews.FindByDescription(Value));
  if GetValue <> Value then
    SetNewClassRefresh;
  for I := 0 to PropCount - 1 do
    TSchemeViewItem(GetComponent(I)).SchemeViewClass := ASchemeViewClass;
  Modified;
end;

function EnumChildProc(WND: HWND; LParam: Integer): BOOL; stdcall
var
  AName: array[0..255] of Char;
const
  S: string = 'TPropSelection';
begin
  Result := True;
  if (GetClassName(WND, @AName[0], 255) <> 0) and (AName = S) then
  begin
    SendMessage(WND, WM_CHAR, $2D, $4A0001);
    InvalidateRect(WND, nil, True);
    SendMessage(GetParent(WND), WM_SIZE, 0, 0);
  end;
end;

function EnumWnd(WND: HWND; LParam: Integer): BOOL; stdcall;
begin
  Result := True;
  EnumChildWindows(WND, @EnumChildProc, 0);
end;


procedure SetNewClassRefresh;
begin
  EnumWindows(@EnumWnd, 0);
end;
//------------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('MF Scheme',[TMFScheme,TMFDBScheme]);
  RegisterPropertyEditor(TypeInfo(TMFBaseSchemeView), TSchemeViewItem, 'SchemeView',TMFViewTypeProperty);
  RegisterComponentEditor(TMFScheme,TMFSchemeEditor);
  RegisterClasses([TMFCardSchemeView,TMFGunterSchemeView]);
  RegisterNoIcon([TMFCardSchemeView,TMFGunterSchemeView]);
end;

{ TMFSchemeEditor }

procedure TMFSchemeEditor.Edit;
begin
  inherited;
  ExecuteVerb(0);
end;

procedure TMFSchemeEditor.ExecuteVerb(Index: Integer);
var
  Scheme: TMFScheme;
begin
  inherited;
  if not (Component is TMFScheme) then
    Exit;
  Scheme := TMFScheme(Component);
  case Index of
    0:begin
      if not Assigned(frmSchemeDesign) then
	frmSchemeDesign := TfrmSchemeDesign.Create(nil);
      frmSchemeDesign.Designer := Designer;
      frmSchemeDesign.Scheme := Scheme;
      frmSchemeDesign.Show;
    end;
  end;
end;


function TMFSchemeEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '编辑 Scheme(&E)';
    1: Result := '-';
    2: Result := 'www.MFSoft.Com';
    3: Result := 'Create by Zhangcheng 2006-2008';
  end;
end;

function TMFSchemeEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


end.
 