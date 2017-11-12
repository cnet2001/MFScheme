{*******************************************************************************

��Ŀ���� :ThinkWide
��Ȩ���� (c) 2005
+-------------------------------------------------------------------------------
��Ŀ:


�汾: 1


��������:2005-1-5 19:02:09


����: �³�(Andyzhang)

+-------------------------------------------------------------------------------
����:

����:   -2005-1-5 19:02:09  ������˼
	Ŀ�� 1) ʵ�ֿ�Ƭʽ   ���̿��ƻ�����  (����ʵ��)
	     2) ʵ�ָ���ͼʽ ���̿��ƻ�����  (�Ժ�ʵ��)
	     3) ��Windows VCL ���ʵ��
	     4) ʵ�����ܻ����Ÿ��㷨

	-2005-1-7  ��д  TGraphScrollBar  ��
	-2005-1-10 ���  TGraphScrollBar  �� 
	-2005-1-20 ��д  TPlanCrockCenter �� �Ÿ׽���ʵ����
	-2005-2-8  ���  TPlanCrockCenter ��
	-2005-2-9  ��д  TMFMacList,TMFCard �Ÿ׿�����

�ع�:   -2006-6-10     �ع��� �Լ� ���ϵ
	Ŀ�� 1) ʵ�ֿ�Ƭʽ������ͼʽ�� ���
	     3) һ������2��������ͼ
	     4) ʵ�����ܻ����Ÿ��㷨

	-2006-6-27    MFSchemeDesignForm
ToDo:

*******************************************************************************}


unit MFSchemeDesignForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ImgList,MFBaseScheme,MFPaint,MFScheme,
  DesignWindows,Menus,DesignIntf,MFDBScheme,MFGunterSchemeView,MFCardSchemeView,
  MFBaseSchemeCommon, ExtCtrls,
  Spin;

type
  TfrmSchemeDesign = class(TDesignWindow)
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
    chkLine: TCheckBox;
    chkNowTime: TCheckBox;
    memMain: TMemo;
    Panel1: TPanel;
    btnSet: TSpeedButton;
    chkDragHint: TCheckBox;
    tbThree: TTabSheet;
    MemHelp: TMemo;
    tbFour: TTabSheet;
    btnTimeDel: TSpeedButton;
    btnTimeAdd: TSpeedButton;
    Label1: TLabel;
    BtnSFont: TSpeedButton;
    chkWLine: TCheckBox;
    LVMain: TListView;
    chkVisible: TCheckBox;
    Label5: TLabel;
    Label4: TLabel;
    cboType: TComboBox;
    speInterval: TSpinEdit;
    chkRest: TCheckBox;
    chkShadow: TCheckBox;
    chkProcess: TCheckBox;
    tbFive: TTabSheet;
    LVRest: TListView;
    btnRestAdd: TSpeedButton;
    btnRestDel: TSpeedButton;
    chkWeek1: TCheckBox;
    chkWeek2: TCheckBox;
    chkWeek3: TCheckBox;
    chkWeek4: TCheckBox;
    chkWeek5: TCheckBox;
    chkWeek6: TCheckBox;
    chkWeek7: TCheckBox;
    Label6: TLabel;
    cboRestColor: TColorBox;
    edtBegin: TEdit;
    edtEnd: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    chkCardMulit: TCheckBox;
    chkGuntMulit: TCheckBox;
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
    speTree: TSpinEdit;
    Label9: TLabel;
    Label13: TLabel;
    speUnit: TSpinEdit;
    cboWeekRest: TColorBox;
    Label14: TLabel;
    Label15: TLabel;
    cboProcessType: TComboBox;
    Label17: TLabel;
    speProcessHeigh: TSpinEdit;
    Label16: TLabel;
    cboTimeColor: TColorBox;
    
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
    procedure LVRestChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cboRestColorChange(Sender: TObject);
    procedure edtBeginExit(Sender: TObject);
    procedure edtEndExit(Sender: TObject);
    procedure edtBeginKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtEndKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRestAddClick(Sender: TObject);
    procedure btnRestDelClick(Sender: TObject);
    procedure chkGuntMulitClick(Sender: TObject);
    procedure chkCardMulitClick(Sender: TObject);
    procedure speCardChange(Sender: TObject);
    procedure speTreeChange(Sender: TObject);
    procedure chkHeadClick(Sender: TObject);
    procedure speUnitChange(Sender: TObject);
    procedure cboWeekRestChange(Sender: TObject);
    procedure speProcessHeighChange(Sender: TObject);
    procedure cboProcessTypeChange(Sender: TObject);
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
    procedure DesignerClosed(const Designer: IDesigner; AGoingDormant: Boolean);
	    override;
    procedure DesignerOpened(const Designer: IDesigner; AResurrecting: Boolean);
	    override;
    procedure ItemDeleted(const ADesigner: IDesigner; Item: TPersistent);
	    override;
    procedure ItemInserted(const ADesigner: IDesigner; Item: TPersistent);
	    override;
    procedure ItemsModified(const Designer: IDesigner); override;
    procedure SelectionChanged(const ADesigner: IDesigner; const ASelection:
	    IDesignerSelections); override;
    property Scheme: TMFScheme write SetMFScheme;
  end;

var
  frmSchemeDesign: TfrmSchemeDesign;

implementation

{$R *.dfm}

{ TTfrmSchemeDesign }

procedure TfrmSchemeDesign.DesignerClosed(const Designer: IDesigner;
  AGoingDormant: Boolean);
begin
  Close;
  inherited;

end;

procedure TfrmSchemeDesign.DesignerOpened(const Designer: IDesigner;
  AResurrecting: Boolean);
begin
  inherited;

end;

procedure TfrmSchemeDesign.ItemDeleted(const ADesigner: IDesigner;
  Item: TPersistent);
var I:Integer;
begin
  inherited;
  if Item = FScheme then Close;
  for I :=TV.Items.Count - 1  to 0 do
  begin
    if   TPersistent(TV.Items[i].Data)= Item then
    TV.Items[i].Delete;
  end;
end;

procedure TfrmSchemeDesign.ItemInserted(const ADesigner: IDesigner;
  Item: TPersistent);
begin
  inherited;

end;

procedure TfrmSchemeDesign.ItemsModified(const Designer: IDesigner);
begin
  inherited;
  //ListView;
end;

procedure TfrmSchemeDesign.SelectionChanged(const ADesigner: IDesigner;
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
end;

procedure TfrmSchemeDesign.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmSchemeDesign.Release;
  frmSchemeDesign:=nil;
end;

procedure TfrmSchemeDesign.SetMFScheme(const Value: TMFScheme);
begin
  FScheme:=Value;
  if Assigned(FScheme) then
  begin
    ListView;
    ListViewType;
  end;
end;

procedure TfrmSchemeDesign.ListView;
var
  I: Integer;
begin
  TV.Items.Clear;
  for I := 0 to FScheme.SchemeViewsCount - 1 do
  begin
    TV.Items.AddObject(nil,FScheme.SchemeViews[i].Name,FScheme.SchemeViews[i]);
  end;
end;

procedure TfrmSchemeDesign.TVChange(Sender: TObject; Node: TTreeNode);
begin
  if tv.Selected<>nil then
  begin
    Designer.SelectComponent(TPersistent(tv.Selected.Data));
    Designer.Modified;
  end;
end;

procedure TfrmSchemeDesign.AddSchemeView(Send:TObject);
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

procedure TfrmSchemeDesign.ListViewType;
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

procedure TfrmSchemeDesign.btnAddClick(Sender: TObject);
var P:TPoint;
begin
  P:=btnAdd.ClientToScreen(Point(0,0));
  PmuList.Popup(P.X,P.Y+btnAdd.Height);
  //ShowMessage('ok');
end;

procedure TfrmSchemeDesign.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSchemeDesign.btnDeleteClick(Sender: TObject);
begin
  DelSchemeView(self);
end;

procedure TfrmSchemeDesign.DelSchemeView(Send: TObject);
begin
  if TV.Selected <>nil then
  begin
    TMFBaseSchemeView(TV.Selected.Data).Free;
    TV.Selected.Free;
    Designer.Modified;
  end;
end;

procedure TfrmSchemeDesign.GetSetting(View:TMFBaseSchemeView);
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
      //caption:='ok';
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

      btnTreeFont.Font := TreeOptions.Font;
      edtTree.Text := TreeOptions.Caption;
      chkCardMulit.Checked:=ContentOptions.MultiSelect;
    end;


  end;
end;

procedure TfrmSchemeDesign.SetSetting;
begin
  if GetActiveView<>nil then
  with GetActiveView do
  begin
    if dtpStartTime.Tag=1 then


  end;
end;

function TfrmSchemeDesign.GetActiveView: TMFBaseSchemeView;
begin
  Result := nil;
  if TV.Selected<>nil then
  Result :=  TMFBaseSchemeView(TV.Selected.Data)
end;

procedure TfrmSchemeDesign.btnTreeFontClick(Sender: TObject);
begin
  dlgFont.Font:= btnTreeFont.Font;
  if dlgFont.Execute then
  begin
    btnTreeFont.Font := dlgFont.Font;
    if GetActiveView<> nil then
     GetActiveView.TreeOptions.Font:=   btnTreeFont.Font;

  end;
end;

procedure TfrmSchemeDesign.LVMainChange(Sender: TObject; Item: TListItem;
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
    SetEnable(False);
end;

procedure TfrmSchemeDesign.dtpStartTimeChange(Sender: TObject);
begin
  if GetActiveView<>nil then
    TMFGunterSchemeView(GetActiveView).ContentOptions.GantterStartTime:=
       dtpStartTime.DateTime;
end;

procedure TfrmSchemeDesign.btnContentFontClick(Sender: TObject);
begin
  dlgFont.Font:= btnContentFont.Font;
  if dlgFont.Execute then
  begin
    btnContentFont.Font := dlgFont.Font;
    cboBackColorChange(self);
  end;
end;

procedure TfrmSchemeDesign.btnTimeDelClick(Sender: TObject);
begin
  if LVMain.Selected <> nil then
  begin
    TMFTimeHeadItem(LVMain.Selected.Data).Free;
    LVMain.DeleteSelected;

  end;
end;

procedure TfrmSchemeDesign.btnTimeAddClick(Sender: TObject);
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

procedure TfrmSchemeDesign.chkWLineClick(Sender: TObject);
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

procedure TfrmSchemeDesign.BtnSFontClick(Sender: TObject);
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

procedure TfrmSchemeDesign.cboTypeSelect(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    TimeScale :=TMFGantterTimeScale(cboType.ItemIndex) ;
    LVMain.Selected.Caption := DisplayName;
  end;
end;

procedure TfrmSchemeDesign.speIntervalChange(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    Interval:=speInterval.Value ;
  end;
end;

procedure TfrmSchemeDesign.chkVisibleClick(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    Visible:= chkVisible.Checked ;
  end;
end;

procedure TfrmSchemeDesign.btnSetClick(Sender: TObject);
begin
  if  GetActiveView <> nil then
  with  TMFGunterSchemeView(GetActiveView).HeadTimeOptions do
  begin
    ScaleFormat.Text :=memMain.Text ;
  end;
end;

procedure TfrmSchemeDesign.DtpEndTimeChange(Sender: TObject);
begin
  if GetActiveView<>nil then
    TMFGunterSchemeView(GetActiveView).ContentOptions.GantterEndTime:=
       DtpEndTime.DateTime;

end;

procedure TfrmSchemeDesign.chkLineClick(Sender: TObject);
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

procedure TfrmSchemeDesign.chkNowTimeClick(Sender: TObject);
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

procedure TfrmSchemeDesign.cboBackColorChange(Sender: TObject);
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

procedure TfrmSchemeDesign.edtTreeChange(Sender: TObject);
begin
  if GetActiveView<> nil then
    GetActiveView.TreeOptions.Caption:= edtTree.Text ;
end;

procedure TfrmSchemeDesign.chkDragHintClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    ShowDragHint:= chkDragHint.Checked;
  end;
end;

procedure TfrmSchemeDesign.chkShadowClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    ItemShadow := chkShadow.Checked;
  end;
end;

procedure TfrmSchemeDesign.chkRestClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    ShowRestDateColor:= chkRest.Checked;
  end;
end;

procedure TfrmSchemeDesign.chkProcessClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    showPercent := chkProcess.Checked;
  end;
end;

procedure TfrmSchemeDesign.chkWeek1Click(Sender: TObject);
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

procedure TfrmSchemeDesign.LVRestChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
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

procedure TfrmSchemeDesign.cboRestColorChange(Sender: TObject);
begin
  if  LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin
    Color:=cboRestColor.Selected ;
  end;
end;

procedure TfrmSchemeDesign.edtBeginExit(Sender: TObject);
begin
  if  LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin
    WorkTimeBegin:=edtBegin.Text  ;
    LVRest.Selected.Caption := DisplayName;
  end;
end;

procedure TfrmSchemeDesign.edtEndExit(Sender: TObject);
begin
  if  LVRest.Selected <> nil then
  with TMFHourforDayItem(LVRest.Selected.Data) do
  begin
    WorkTimeEnd:=edtEnd.Text  ;
    LVRest.Selected.Caption := DisplayName;
  end;
end;

procedure TfrmSchemeDesign.edtBeginKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then  edtBeginExit(self);
end;

procedure TfrmSchemeDesign.edtEndKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then  edtEndExit(self);
end;

procedure TfrmSchemeDesign.btnRestAddClick(Sender: TObject);
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

procedure TfrmSchemeDesign.btnRestDelClick(Sender: TObject);
begin
  if LVRest.Selected <> nil then
  begin
    TMFHourforDayItem(LVRest.Selected.Data).Free;
    LVRest.DeleteSelected;

  end;
end;

procedure TfrmSchemeDesign.chkGuntMulitClick(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    MultiSelect := chkGuntMulit.Checked;
  end;
end;

procedure TfrmSchemeDesign.chkCardMulitClick(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    TMFCardSchemeView(GetActiveView).ContentOptions.MultiSelect:=chkCardMulit.Checked;

  end;
end;

procedure TfrmSchemeDesign.speCardChange(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    TMFCardSchemeView(GetActiveView).ContentOptions.CardWidth :=speCard.Value;
  end;
end;

procedure TfrmSchemeDesign.speTreeChange(Sender: TObject);
begin
  if GetActiveView <> nil then
  begin
    GetActiveView.TreeOptions.Width :=speTree.Value;
  end;
end;

procedure TfrmSchemeDesign.chkHeadClick(Sender: TObject);
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

procedure TfrmSchemeDesign.speUnitChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).HeadTimeOptions do
  begin
    IntervalWidth := speUnit.Value;

  end;
end;

procedure TfrmSchemeDesign.cboWeekRestChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    RestDateColor:= cboWeekRest.Selected;
  end;
end;

procedure TfrmSchemeDesign.speProcessHeighChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin
    PercentWidth := speProcessHeigh.Value;
  end;
end;

procedure TfrmSchemeDesign.cboProcessTypeChange(Sender: TObject);
begin
  if GetActiveView<>nil then
  with TMFGunterSchemeView(GetActiveView).ContentOptions do
  begin

    PercentPosition := TPercentPosition(cboProcessType.ItemIndex);
  end;
end;

procedure TfrmSchemeDesign.cboTimeColorChange(Sender: TObject);
begin
  if  LVMain.Selected <> nil then
  with TMFTimeHeadItem(LVMain.Selected.Data) do
  begin
    Color:=cboTimeColor.Selected;
  end;

end;

end.
