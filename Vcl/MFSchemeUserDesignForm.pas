{*******************************************************************************

项目名称 :ThinkWide基础类
版权所有 (c) 2005 上海ThinkWide
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
	目的 1) 实现卡片式，干特图式等 风格
	     3) 一份数据2种以上视图
	     4) 实现智能化的排缸算法

	-2006-6-27    MFSchemeDesignForm
ToDo:

*******************************************************************************}


unit MFSchemeUserDesignForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ImgList,MFBaseScheme,MFPaint,MFScheme,
  Menus,MFDBScheme,MFGunterSchemeView,MFCardSchemeView,
  MFBaseSchemeCommon, ExtCtrls,Spin;

type
  TfrmSchemeUserDesign = class(TForm)
    MainPage: TPageControl;
    TabMain: TTabSheet;
    TV: TTreeView;
    btnCancel: TButton;
    btnAdd: TButton;
    ImageList1: TImageList;
    PmuList: TPopupMenu;
    btnDelete: TButton;
    pgcMain: TPageControl;
    TabSheet1: TTabSheet;
    lblBackColor: TLabel;
    cboBackColor: TColorBox;
    lblFont: TLabel;
    btnContentFont: TSpeedButton;
    TabSheet3: TTabSheet;
    chkHint: TCheckBox;
    btnTreeFont: TSpeedButton;
    Label2: TLabel;
    edtTree: TEdit;
    Label3: TLabel;
    PgcTemp: TPageControl;
    tbGunter: TTabSheet;
    dlgFont: TFontDialog;
    tbCard: TTabSheet;
    lbCard: TLabel;
    speCard: TSpinEdit;
    PageControl1: TPageControl;
    tbOne: TTabSheet;
    tbTwo: TTabSheet;
    lblStartTime: TLabel;
    lblEndTime: TLabel;
    dtpStartTime: TDateTimePicker;
    DtpEndTime: TDateTimePicker;
    memMain: TMemo;
    Panel1: TPanel;
    btnSet: TSpeedButton;
    btnApply: TButton;
    tbThree: TTabSheet;
    MemHelp: TMemo;
    tbFour: TTabSheet;
    btnTimeDel: TSpeedButton;
    btnTimeAdd: TSpeedButton;
    Label1: TLabel;
    BtnSFont: TSpeedButton;
    Label5: TLabel;
    Label4: TLabel;
    chkWLine: TCheckBox;
    cboType: TComboBox;
    LVMain: TListView;
    chkVisible: TCheckBox;
    speInterval: TSpinEdit;
    chkLine: TCheckBox;
    chkNowTime: TCheckBox;
    chkDragHint: TCheckBox;
    chkShadow: TCheckBox;
    chkRest: TCheckBox;
    chkProcess: TCheckBox;
    tbFive: TTabSheet;
    chkWeek1: TCheckBox;
    chkWeek2: TCheckBox;
    chkWeek3: TCheckBox;
    chkWeek4: TCheckBox;
    chkWeek5: TCheckBox;
    chkWeek6: TCheckBox;
    chkWeek7: TCheckBox;
    LVRest: TListView;
    btnRestAdd: TSpeedButton;
    btnRestDel: TSpeedButton;
    Label6: TLabel;
    cboRestColor: TColorBox;
    edtBegin: TEdit;
    edtEnd: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    chkCardMulit: TCheckBox;
    chkGuntMulit: TCheckBox;
    speTree: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    speHead: TSpinEdit;
    Label11: TLabel;
    speIndicate: TSpinEdit;
    Label12: TLabel;
    speFoot: TSpinEdit;
    chkHead: TCheckBox;
    chkIndicate: TCheckBox;
    chkTree: TCheckBox;
    chkFoot: TCheckBox;
    Label13: TLabel;
    speUnit: TSpinEdit;
    cboWeekRest: TColorBox;
    Label14: TLabel;
    Label15: TLabel;
    cboProcessType: TComboBox;
    Label17: TLabel;
    speProcessHeigh: TSpinEdit;
    cboTimeColor: TColorBox;
    Label16: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnTreeFontClick(Sender: TObject);
    procedure LVMainChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure dtpStartTimeChange(Sender: TObject);
    procedure btnContentFontClick(Sender: TObject);
    procedure btnTimeDelClick(Sender: TObject);
    procedure btnTimeAddClick(Sender: TObject);
    procedure chkWLineClick(Sender: TObject);
    procedure BtnSFontClick(Sender: TObject);
    procedure cboTypeSelect(Sender: TObject);
    procedure speIntervalChange(Sender: TObject);
    procedure chkVisibleClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure DtpEndTimeChange(Sender: TObject);
    procedure chkLineClick(Sender: TObject);
    procedure chkNowTimeClick(Sender: TObject);
    procedure cboBackColorChange(Sender: TObject);
    procedure edtTreeChange(Sender: TObject);
    procedure chkDragHintClick(Sender: TObject);
    procedure chkShadowClick(Sender: TObject);
    procedure chkRestClick(Sender: TObject);
    procedure chkProcessClick(Sender: TObject);
    procedure chkWeek1Click(Sender: TObject);
    procedure btnRestDelClick(Sender: TObject);
    procedure btnRestAddClick(Sender: TObject);
    procedure LVRestChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cboRestColorChange(Sender: TObject);
    procedure edtBeginExit(Sender: TObject);
    procedure edtEndExit(Sender: TObject);
    procedure edtEndKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtBeginKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkGuntMulitClick(Sender: TObject);
    procedure chkCardMulitClick(Sender: TObject);
    procedure speCardChange(Sender: TObject);
    procedure chkHeadClick(Sender: TObject);
    procedure speTreeChange(Sender: TObject);
    procedure speUnitChange(Sender: TObject);
    procedure cboWeekRestChange(Sender: TObject);
    procedure cboProcessTypeClick(Sender: TObject);
    procedure speProcessHeighChange(Sender: TObject);
    procedure cboTimeColorChange(Sender: TObject);
  private
    FScheme:TMFScheme;
    procedure SetMFScheme(const Value: TMFScheme);
    procedure AddSchemeView(Send:TObject);
    procedure DelSchemeView(Send:TObject);
  public
    function GetActiveView:TMFBaseSchemeView;
    procedure GetSetting(View:TMFBaseSchemeView);
    procedure SetSetting(View:TMFBaseSchemeView);
    procedure ListView;
    procedure ListViewType;
    property Scheme: TMFScheme write SetMFScheme;
  end;

var
  frmSchemeUserDesign: TfrmSchemeUserDesign;

function  ShowDesignForm(Scheme:TMFScheme):TForm;

implementation

{$R *.dfm}
function  ShowDesignForm(Scheme:TMFScheme):TForm;
begin
  if Scheme<>nil then
  begin
    frmSchemeUserDesign:=TfrmSchemeUserDesign.Create(nil);
    frmSchemeUserDesign.Scheme :=Scheme;
    frmSchemeUserDesign.ListView;
    frmSchemeUserDesign.ShowModal;
    //frmSchemeUserDesign.Release;
  end;
end;

{ TTfrmSchemeDesign }


{procedure TfrmSchemeUserDesign.SelectionChanged(const ADesigner: IDesigner;
  const ASelection: IDesignerSelections);
var
  I: Integer;
begin
  inherited;
  if ASelection.Count >0 then
  begin
    for I := 0 to TV.Items.Count - 1 do
    begin
      if  TPersistent(TV.Items[i].Data)= ASelection.Items[0] then
      begin
	TV.Items[i].Selected:=True;
	GetSetting(TMFBaseSchemeView(TV.Items[i].Data));
      end;
    end;

  end;
end; }

procedure TfrmSchemeUserDesign.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Release;
  frmSchemeUserDesign:=nil;
end;

procedure TfrmSchemeUserDesign.SetMFScheme(const Value: TMFScheme);
begin
  FScheme:=Value;
  if Assigned(FScheme) then
  begin
    ListView;
    ListViewType;
  end;
end;

procedure TfrmSchemeUserDesign.ListView;
var
  I: Integer;Node:TTreeNode;
begin
  TV.Items.Clear;
  for I := 0 to FScheme.SchemeViewsCount - 1 do
  begin
    Node:=TV.Items.AddObject(nil,FScheme.SchemeViews[i].Caption,FScheme.SchemeViews[i]);
    if FScheme.ActiveSchemeView=FScheme.SchemeViews[i] then
      Node.Selected:=True;
  end;
end;

procedure TfrmSchemeUserDesign.TVChange(Sender: TObject; Node: TTreeNode);
begin
  if tv.Selected<>nil then
  begin
    GetSetting(TMFBaseSchemeView(tv.Selected.Data));
  end;
end;

procedure TfrmSchemeUserDesign.AddSchemeView(Send:TObject);
var
  View:TMFBaseSchemeView ; Node:TTreeNode;
begin
  if  Assigned(FScheme) then
  begin
    View:=FScheme.CreateSchemeView(TMFBaseSchemeViewClass(RegisteredViews.Items[TMenuItem(Send).Tag]) );
    View.Name := Designer.UniqueName(View.ClassName);
    View.Parent:=FScheme;
    Node:=TV.Items.AddObject(nil,View.Name,View);
    Node.Selected:=True;
    Designer.Modified;
  end;
end;

procedure TfrmSchemeUserDesign.ListViewType;
var I:Integer; Item:TMenuItem;
begin
  PmuList.Items.Clear;

  for I:=0 to RegisteredViews.Count-1 do
  begin

    if FScheme is TMFDBScheme then
    begin
      if RegisteredViews.ItemsRec[I].AType=rgtDB then
      begin
	Item:=TMenuItem.Create(PmuList);
	Item.Tag := I;
	Item.Caption :=RegisteredViews.Descriptions[I];
	Item.OnClick:=AddSchemeView;
	PmuList.Items.Add(Item);
      end;
    end
    else begin
      if RegisteredViews.ItemsRec[I].AType<>rgtDB then
      begin
	Item:=TMenuItem.Create(PmuList);
	Item.Tag := I;
	Item.Caption :=RegisteredViews.Descriptions[I];
	Item.OnClick:=AddSchemeView;
	PmuList.Items.Add(Item);
      end;

    end;

  end;
end;

procedure TfrmSchemeUserDesign.btnAddClick(Sender: TObject);
var P:TPoint;
begin
  P:=btnAdd.ClientToScreen(Point(0,0));
  PmuList.Popup(P.X,P.Y+btnAdd.Height);
  //ShowMessage('ok');
end;

procedure TfrmSchemeUserDesign.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSchemeUserDesign.btnDeleteClick(Sender: TObject);
begin
  DelSchemeView(self);
end;

procedure TfrmSchemeUserDesign.DelSchemeView(Send: TObject);
begin
  if TV.Selected <>nil then
  begin
    TMFBaseSchemeView(TV.Selected.Data).Free;
    TV.Selected.Free;
    Designer.Modified;
  end;
end;

procedure TfrmSchemeUserDesign.GetSetting(View:TMFBaseSchemeView);
var
  I:Integer;
  AMFWeekDay: TMFWeekDay;
  Chk:TCheckBox;
begin
  if View<>nil then
  begin
    
    chkHead.Checked:= View.HeadOptions.Visible;
    chkTree.Checked:= View.TreeOptions.Visible;
    chkFoot.Checked:= View.FootOptions.Visible;
    chkIndicate.Checked:= View.IndicaterOptions.Visible;

    speTree.Value :=View.TreeOptions.Width;
    speHead.Value:= View.HeadOptions.Height;

    speFoot.Value:= View.FootOptions.Height;
    speIndicate.Value:= View.IndicaterOptions.Width;


    if  View.InheritsFrom(TMFGunterSchemeView) then
    with View as TMFGunterSchemeView do
    begin
      tbCard.PageControl := PgcTemp;
      tbGunter.PageControl := pgcMain;

      DtpStartTime.DateTime := ContentOptions.GantterStartTime;
      DtpEndTime.DateTime := ContentOptions.GantterEndTime;
      cboBackColor.Selected := ContentOptions.Color;
      btnContentFont.Font:= ContentOptions.Font;
      chkHint.Checked :=  ShowHint;
      chkDragHint.Checked :=ContentOptions.ShowDragHint;
      chkLine.Checked :=  ContentOptions.Pen.Style <> psClear ;
      btnTreeFont.Font := TreeOptions.Font;
      edtTree.Text := TreeOptions.Caption;
      chkNowTime.Checked := HeadTimeOptions.NowTimeLinePen.Style <> psClear;

      LVMain.Clear;
      for I:=0 to HeadTimeOptions.HeadItems.Count -1   do
      begin
	LVMain.AddItem(HeadTimeOptions.HeadItems[I].DisplayName,HeadTimeOptions.HeadItems[I]);

      end;
      chkShadow.Checked := ContentOptions.ItemShadow;
      chkRest.Checked:= ContentOptions.ShowRestDateColor;
      chkProcess.Checked := ContentOptions.ShowPercent;
      memMain.Text := HeadTimeOptions.ScaleFormat.Text;

      for AMFWeekDay:=Low(AMFWeekDay) to High(AMFWeekDay) do
      if AMFWeekDay in ContentOptions.WorkDayforWeek then
      begin
	Chk :=TCheckBox( Self.FindComponent('chkWeek'+inttostr(Ord(AMFWeekDay)+1))); //
	if Chk<>nil then
	  Chk.Checked:=True;
      end;

      LVRest.Clear;
      for I:=0 to ContentOptions.WorkHourforDays.Count -1  do
      begin
	LVRest.AddItem(ContentOptions.WorkHourforDays[I].DisplayName,ContentOptions.WorkHourforDays[I]);

      end;
      chkGuntMulit.Checked:=ContentOptions.MultiSelect;

      speUnit.Value := HeadTimeOptions.IntervalWidth;

      cboWeekRest.Selected := ContentOptions.RestDateColor;

      cboProcessType.ItemIndex:= Ord(ContentOptions.PercentPosition );

      speProcessHeigh.Value := ContentOptions.PercentWidth;
    end;

    if  View.InheritsFrom(TMFCardSchemeView) then
    with View as TMFCardSchemeView do
    begin
      tbGunter.PageControl := PgcTemp;
      tbCard.PageControl := pgcMain;
      speCard.Value := ContentOptions.CardWidth;

      cboBackColor.Selected := ContentOptions.Color;
      btnContentFont.Font:= ContentOptions.Font;
      chkHint.Checked :=  ShowHint;

      chkCardMulit.Checked:=ContentOptions.MultiSelect;
      btnTreeFont.Font := TreeOptions.Font;
      edtTree.Text := TreeOptions.Caption;
    end;


  end;
end;

procedure TfrmSchemeUserDesign.SetSetting;
begin
  if GetActiveView<>nil then
  with GetActiveView do
  begin
    if dtpStartTime.Tag=1 then  ;


  end;
end;

function TfrmSchemeUserDesign.GetActiveView: TMFBaseSchemeView;
begin
  Result := nil;
  if TV.Selected<>nil then
  Result :=  TMFBaseSchemeView(TV.Selected.Data)
end;

procedure TfrmSchemeUserDesign.btnTreeFontClick(Sender: TObject);
begin
  dlgFont.Font:= btnTreeFont.Font;
  if dlgFont.Execute then
  begin
    btnTreeFont.Font := dlgFont.Font;
    if GetActiveView<> nil then
     GetActiveView.TreeOptions.Font:=   btnTreeFont.Font;

  end;
end;

procedure TfrmSchemeUserDesign.LVMainChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
  procedure SetEnable(Value:Boolean);
  begin
    speInterval.Enabled := Value;
    chkWLine.Enabled := Value;
    cboType.Enabled := Value;
    BtnSFont.Enabled := Value;
    chkVisible.Enabled := Value;
    cboTimeColor.Enabled := Value;
  end;
begin
  if LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    SetEnable(True);
    speInterval.Value := Interval;
    chkWLine.Checked  := ContentVLinePen.Style <> psClear;
    cboType.ItemIndex :=  Ord(TimeScale);
    BtnSFont.Font :=  Font;
    chkVisible.Checked := Visible ;
    cboTimeColor.Selected := Color;
  end
  else
    SetEnable(False);;
end;

procedure TfrmSchemeUserDesign.dtpStartTimeChange(Sender: TObject);
begin
  if GetActiveView<>nil then
    TMFGunterSchemeView(GetActiveView).ContentOptions.GantterStartTime:=
       dtpStartTime.DateTime;
end;

procedure TfrmSchemeUserDesign.btnContentFontClick(Sender: TObject);
begin
  dlgFont.Font:= btnContentFont.Font;
  if dlgFont.Execute then
  begin
    btnContentFont.Font := dlgFont.Font;
    cboBackColorChange(self);
  end;
end;

procedure TfrmSchemeUserDesign.btnTimeDelClick(Sender: TObject);
begin
  if LVMain.Selected <> nil then
  begin
    TMFTimeHeadItem(LVMain.Selected.Data).Free;
    LVMain.DeleteSelected;

  end;
end;

procedure TfrmSchemeUserDesign.btnTimeAddClick(Sender: TObject);
var Item:TMFTimeHeadItem;
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).HeadTimeOptions.HeadItems do
  begin
    LVMain.Selected :=nil;
    Item := Add;
    LVMain.AddItem(Item.DisplayName,Item);
  end;
end;

procedure TfrmSchemeUserDesign.chkWLineClick(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    if chkWLine.Checked then
      ContentVLinePen.Style := psSolid
    else
      ContentVLinePen.Style := psClear;

  end;
end;

procedure TfrmSchemeUserDesign.BtnSFontClick(Sender: TObject);
begin
  dlgFont.Font:= BtnSFont.Font;
  if dlgFont.Execute then
  begin
    BtnSFont.Font := dlgFont.Font;
    if  LVMain.Selected <> nil then
    with TMFTimeHeadItem(LVMain.Selected.Data) do
      Font:=BtnSFont.Font;
  end;
end;

procedure TfrmSchemeUserDesign.cboTypeSelect(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    TimeScale :=TMFGantterTimeScale(cboType.ItemIndex) ;
    LVMain.Selected.Caption := DisplayName;
  end;
end;

procedure TfrmSchemeUserDesign.speIntervalChange(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    Interval:=speInterval.Value ;
  end;
end;

procedure TfrmSchemeUserDesign.chkVisibleClick(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    Visible:= chkVisible.Checked ;
  end;
end;

procedure TfrmSchemeUserDesign.btnSetClick(Sender: TObject);
begin
  if  GetActiveView <> nil then
  with  TMFGunterSchemeView(GetActiveView).HeadTimeOptions do
  begin
    ScaleFormat.Text :=memMain.Text ;
  end;
end;

procedure TfrmSchemeUserDesign.btnApplyClick(Sender: TObject);
begin
  //SetSetting();
end;

procedure TfrmSchemeUserDesign.DtpEndTimeChange(Sender: TObject);
begin
  if GetActiveView<>nil then
    TMFGunterSchemeView(GetActiveView).ContentOptions.GantterEndTime:=
       DtpEndTime.DateTime;

end;

procedure TfrmSchemeUserDesign.chkLineClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    if chkLine.Checked then
      Pen.Style:= psDot
    else
      Pen.Style:= psClear;
  end;
end;

procedure TfrmSchemeUserDesign.chkNowTimeClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).HeadTimeOptions do
  begin
    if chkNowTime.Checked then
      NowTimeLinePen.Style:= psSolid
    else
      NowTimeLinePen.Style:= psClear;
  end;
end;

procedure TfrmSchemeUserDesign.cboBackColorChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  begin
    if GetActiveView.InheritsFrom(TMFGunterSchemeView) then
    with GetActiveView as TMFGunterSchemeView do
    begin
      ContentOptions.Color := cboBackColor.Selected;
      ContentOptions.Font := btnContentFont.Font;
      ShowHint := chkHint.Checked;
    end;

    if GetActiveView.InheritsFrom(TMFCardSchemeView) then
     with GetActiveView as TMFCardSchemeView do
    begin
      ContentOptions.Color := cboBackColor.Selected;
      ContentOptions.Font := btnContentFont.Font;
      ShowHint := chkHint.Checked;
    end;

  end;

end;

procedure TfrmSchemeUserDesign.edtTreeChange(Sender: TObject);
begin
  if GetActiveView<> nil then
    GetActiveView.TreeOptions.Caption:= edtTree.Text ;
end;

procedure TfrmSchemeUserDesign.chkDragHintClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    ShowDragHint:= chkDragHint.Checked;
  end;
end;

procedure TfrmSchemeUserDesign.chkShadowClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    ItemShadow := chkShadow.Checked;
  end;
end;

procedure TfrmSchemeUserDesign.chkRestClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    ShowRestDateColor:= chkRest.Checked;
  end;
end;

procedure TfrmSchemeUserDesign.chkProcessClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    showPercent := chkProcess.Checked;
  end;
end;

procedure TfrmSchemeUserDesign.chkWeek1Click(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    if TCheckBox(Sender).Checked then
      WorkDayforWeek:= WorkDayforWeek + [TMFWeekDay(TCheckBox(Sender).Tag)]
    else
      WorkDayforWeek:= WorkDayforWeek - [TMFWeekDay(TCheckBox(Sender).Tag)];
  end;
end;

procedure TfrmSchemeUserDesign.btnRestDelClick(Sender: TObject);
begin
  if LVRest.Selected <> nil then
  begin
    TMFHourforDayItem(LVRest.Selected.Data).Free;
    LVRest.DeleteSelected;
    GetActiveView.Invalidate;
  end;
end;

procedure TfrmSchemeUserDesign.btnRestAddClick(Sender: TObject);
var Item:TMFHourforDayItem;
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions.WorkHourforDays do
  begin
    LVRest.Selected :=nil;
    Item := Add;
    LVRest.AddItem(Item.DisplayName,Item);
  end;
end;

procedure TfrmSchemeUserDesign.LVRestChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
  procedure SetEnable(Value:Boolean);
  begin
    cboRestColor.Enabled := Value;
    edtBegin.Enabled := Value;
    edtEnd.Enabled := Value;
  end;
begin
  if LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin
    SetEnable(True);
    cboRestColor.Selected:=Color;
    edtBegin.Text := WorkTimeBegin;
    edtEnd.Text := WorkTimeEnd;
  end
  else
    SetEnable(False);
end;

procedure TfrmSchemeUserDesign.cboRestColorChange(Sender: TObject);
begin
  if  LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin

    Color:=cboRestColor.Selected ;
  end;
end;

procedure TfrmSchemeUserDesign.edtBeginExit(Sender: TObject);
begin
  if  LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin
    WorkTimeBegin:=edtBegin.Text  ;
    LVRest.Selected.Caption := DisplayName;
  end;
end;

procedure TfrmSchemeUserDesign.edtEndExit(Sender: TObject);
begin
  if  LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin
    WorkTimeEnd:=edtEnd.Text  ;
    LVRest.Selected.Caption := DisplayName;
  end;
end;

procedure TfrmSchemeUserDesign.edtEndKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=13 then  edtEndExit(self);
end;

procedure TfrmSchemeUserDesign.edtBeginKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=13 then  edtBeginExit(self);
end;

procedure TfrmSchemeUserDesign.chkGuntMulitClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    MultiSelect := chkGuntMulit.Checked;
  end;
end;

procedure TfrmSchemeUserDesign.chkCardMulitClick(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    TMFCardSchemeView(GetActiveView).ContentOptions.MultiSelect:=chkCardMulit.Checked;

  end;
end;

procedure TfrmSchemeUserDesign.speCardChange(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    TMFCardSchemeView(GetActiveView).ContentOptions.CardWidth :=speCard.Value;
  end;
end;

procedure TfrmSchemeUserDesign.chkHeadClick(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    if Sender = chkHead then
      GetActiveView.HeadOptions.Visible:= chkHead.Checked;

    if Sender = chkTree then
      GetActiveView.TreeOptions.Visible:= chkTree.Checked;

    if Sender = chkFoot then
      GetActiveView.FootOptions.Visible:= chkFoot.Checked;

    if Sender = chkIndicate then
      GetActiveView.IndicaterOptions.Visible:= chkIndicate.Checked;

    if Sender = speHead then
      GetActiveView.HeadOptions.Height:= speHead.Value;

    if Sender = speIndicate then
      GetActiveView.IndicaterOptions.Width:= speIndicate.Value;

    if Sender = speFoot then
      GetActiveView.FootOptions.Height:= speFoot.Value;

  end;

end;

procedure TfrmSchemeUserDesign.speTreeChange(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    GetActiveView.TreeOptions.Width :=speTree.Value;
  end;
end;

procedure TfrmSchemeUserDesign.speUnitChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).HeadTimeOptions do
  begin
    IntervalWidth := speUnit.Value;

  end;
end;

procedure TfrmSchemeUserDesign.cboWeekRestChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    RestDateColor:= cboWeekRest.Selected;
  end;
end;

procedure TfrmSchemeUserDesign.cboProcessTypeClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    PercentPosition := TPercentPosition(cboProcessType.ItemIndex);
  end;
end;

procedure TfrmSchemeUserDesign.speProcessHeighChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    PercentWidth := speProcessHeigh.Value;
  end;
end;

procedure TfrmSchemeUserDesign.cboTimeColorChange(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    Color:=cboTimeColor.Selected;
  end;
  
end;

end.
