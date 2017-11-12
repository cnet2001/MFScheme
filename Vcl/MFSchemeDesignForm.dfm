object frmSchemeDesign: TfrmSchemeDesign
  Left = 319
  Top = 160
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #23646#24615#35774#35745
  ClientHeight = 416
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object MainPage: TPageControl
    Left = 8
    Top = 8
    Width = 529
    Height = 361
    ActivePage = TabMain
    TabOrder = 0
    object TabMain: TTabSheet
      Caption = #32534#36753
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TV: TTreeView
        Left = 4
        Top = 6
        Width = 220
        Height = 289
        BevelInner = bvNone
        BevelOuter = bvNone
        Ctl3D = True
        HideSelection = False
        Images = ImageList1
        Indent = 19
        ParentCtl3D = False
        ParentShowHint = False
        ReadOnly = True
        RowSelect = True
        ShowButtons = False
        ShowHint = True
        ShowLines = False
        TabOrder = 0
        OnChange = TVChange
      end
      object btnAdd: TButton
        Left = 64
        Top = 304
        Width = 75
        Height = 25
        Caption = #28155#21152'(&A)'
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnDelete: TButton
        Left = 144
        Top = 304
        Width = 75
        Height = 25
        Caption = #21024#38500'(&D)'
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object pgcMain: TPageControl
        Left = 232
        Top = 8
        Width = 289
        Height = 321
        ActivePage = TabSheet1
        Style = tsFlatButtons
        TabOrder = 3
        object TabSheet1: TTabSheet
          Caption = #22522#26412#35774#32622
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lblBackColor: TLabel
            Left = 9
            Top = 175
            Width = 54
            Height = 12
            Caption = #24213'    '#33394':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object lblFont: TLabel
            Left = 9
            Top = 207
            Width = 54
            Height = 12
            Caption = #23383'    '#20307':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object btnContentFont: TSpeedButton
            Left = 65
            Top = 201
            Width = 120
            Height = 25
            Caption = #24403#21069#23383#20307
            Flat = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            OnClick = btnContentFontClick
          end
          object Label10: TLabel
            Left = 9
            Top = 77
            Width = 66
            Height = 12
            Caption = #26631#39064#26639#39640#24230':'
          end
          object Label11: TLabel
            Left = 9
            Top = 109
            Width = 66
            Height = 12
            Caption = #23548#33322#26465#23485#24230':'
          end
          object Label12: TLabel
            Left = 9
            Top = 141
            Width = 66
            Height = 12
            Caption = #33050#27880#26639#39640#24230':'
          end
          object cboBackColor: TColorBox
            Left = 65
            Top = 171
            Width = 120
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = cboBackColorChange
          end
          object chkHint: TCheckBox
            Left = 8
            Top = 240
            Width = 97
            Height = 17
            Caption = #26174#31034#25552#31034
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = cboBackColorChange
          end
          object speHead: TSpinEdit
            Left = 80
            Top = 72
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 2
            Value = 1
            OnChange = chkHeadClick
          end
          object speIndicate: TSpinEdit
            Left = 80
            Top = 104
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 3
            Value = 1
            OnChange = chkHeadClick
          end
          object speFoot: TSpinEdit
            Left = 80
            Top = 136
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 4
            Value = 1
            OnChange = chkHeadClick
          end
          object chkHead: TCheckBox
            Left = 0
            Top = 8
            Width = 97
            Height = 17
            Caption = #26174#31034#26631#39064#26639
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            OnClick = chkHeadClick
          end
          object chkIndicate: TCheckBox
            Left = 96
            Top = 8
            Width = 97
            Height = 17
            Caption = #26174#31034#23548#33322#26465
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            OnClick = chkHeadClick
          end
          object chkTree: TCheckBox
            Left = 0
            Top = 40
            Width = 97
            Height = 17
            Caption = #26174#31034#26641#30446#24405
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 7
            OnClick = chkHeadClick
          end
          object chkFoot: TCheckBox
            Left = 96
            Top = 40
            Width = 97
            Height = 17
            Caption = #26174#31034#33050#27880
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            OnClick = chkHeadClick
          end
        end
        object TabSheet3: TTabSheet
          Caption = #26641#30446#24405
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImageIndex = 2
          ParentFont = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object btnTreeFont: TSpeedButton
            Left = 73
            Top = 17
            Width = 120
            Height = 22
            Caption = #24403#21069#23383#20307
            Flat = True
            OnClick = btnTreeFontClick
          end
          object Label2: TLabel
            Left = 17
            Top = 23
            Width = 54
            Height = 12
            Caption = #23383'    '#20307':'
          end
          object Label3: TLabel
            Left = 17
            Top = 55
            Width = 54
            Height = 12
            Caption = #26631'    '#39064':'
          end
          object Label9: TLabel
            Left = 17
            Top = 85
            Width = 54
            Height = 12
            Caption = #26641' '#23485' '#24230':'
          end
          object edtTree: TEdit
            Left = 72
            Top = 50
            Width = 121
            Height = 20
            TabOrder = 0
            OnChange = edtTreeChange
          end
          object speTree: TSpinEdit
            Left = 72
            Top = 80
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 1
            Value = 1
            OnChange = speTreeChange
          end
        end
      end
    end
  end
  object btnCancel: TButton
    Left = 459
    Top = 377
    Width = 75
    Height = 25
    Cancel = True
    Caption = #20851#38381'(&C)'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object PgcTemp: TPageControl
    Left = -400
    Top = 88
    Width = 141
    Height = 81
    ActivePage = tbGunter
    TabOrder = 2
    Visible = False
    object tbCard: TTabSheet
      Caption = #21345#29255
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 4
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbCard: TLabel
        Left = 17
        Top = 21
        Width = 54
        Height = 12
        Caption = #21345#29255#23485#24230':'
      end
      object speCard: TSpinEdit
        Left = 72
        Top = 16
        Width = 81
        Height = 21
        MaxValue = 1000
        MinValue = 1
        TabOrder = 0
        Value = 1
        OnChange = speCardChange
      end
      object chkCardMulit: TCheckBox
        Left = 16
        Top = 45
        Width = 97
        Height = 17
        Caption = #20801#35768#22810#36873
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = chkCardMulitClick
      end
    end
    object tbGunter: TTabSheet
      Caption = #29976#29305#22270
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 3
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 133
        Height = 53
        ActivePage = tbFive
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        ExplicitHeight = 54
        object tbOne: TTabSheet
          Caption = #22522#26412
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lblStartTime: TLabel
            Left = 9
            Top = 8
            Width = 54
            Height = 12
            Caption = #24320#22987#26102#38388':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object lblEndTime: TLabel
            Left = 9
            Top = 32
            Width = 54
            Height = 12
            Caption = #32467#26463#26102#38388':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label15: TLabel
            Left = 9
            Top = 149
            Width = 78
            Height = 12
            Caption = #36827#24230#26174#31034#20301#32622':'
          end
          object Label17: TLabel
            Left = 33
            Top = 172
            Width = 54
            Height = 12
            Caption = #36827#24230#23485#24230':'
          end
          object dtpStartTime: TDateTimePicker
            Left = 65
            Top = 4
            Width = 120
            Height = 20
            BevelInner = bvNone
            BevelOuter = bvNone
            Date = 38930.000000000000000000
            Time = 38930.000000000000000000
            DateFormat = dfLong
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = dtpStartTimeChange
          end
          object DtpEndTime: TDateTimePicker
            Left = 65
            Top = 28
            Width = 120
            Height = 20
            Date = 38931.000000000000000000
            Time = 38931.000000000000000000
            DateFormat = dfLong
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = DtpEndTimeChange
          end
          object chkLine: TCheckBox
            Left = 8
            Top = 56
            Width = 73
            Height = 17
            Caption = #27178#21521#32447#26465
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = chkLineClick
          end
          object chkNowTime: TCheckBox
            Left = 80
            Top = 56
            Width = 73
            Height = 17
            Caption = #24403#21069#26102#38388
            TabOrder = 3
            OnClick = chkNowTimeClick
          end
          object chkDragHint: TCheckBox
            Left = 160
            Top = 56
            Width = 97
            Height = 17
            Caption = #26174#31034#25176#25341#25552#31034
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = chkDragHintClick
          end
          object chkRest: TCheckBox
            Left = 80
            Top = 88
            Width = 89
            Height = 17
            Caption = #26174#31034#20241#24687#26085
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            OnClick = chkRestClick
          end
          object chkShadow: TCheckBox
            Left = 8
            Top = 88
            Width = 73
            Height = 17
            Caption = #26174#31034#38452#24433
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            OnClick = chkShadowClick
          end
          object chkProcess: TCheckBox
            Left = 160
            Top = 88
            Width = 73
            Height = 17
            Caption = #26174#31034#36827#24230
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 7
            OnClick = chkProcessClick
          end
          object chkGuntMulit: TCheckBox
            Left = 8
            Top = 117
            Width = 97
            Height = 17
            Caption = #20801#35768#22810#36873
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            OnClick = chkGuntMulitClick
          end
          object cboProcessType: TComboBox
            Left = 88
            Top = 144
            Width = 81
            Height = 20
            Style = csDropDownList
            TabOrder = 9
            OnChange = cboProcessTypeChange
            Items.Strings = (
              #20013
              #19978
              #19979
              #20840#37096)
          end
          object speProcessHeigh: TSpinEdit
            Left = 88
            Top = 168
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 10
            Value = 1
            OnChange = speProcessHeighChange
          end
        end
        object tbFour: TTabSheet
          Caption = #26102#38388#36724
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object btnTimeDel: TSpeedButton
            Left = 245
            Top = 64
            Width = 23
            Height = 22
            Flat = True
            Glyph.Data = {
              36060000424D3606000000000000360400002800000020000000100000000100
              08000000000000020000830B0000830B00000001000000010000000000003300
              00006600000099000000CC000000FF0000000033000033330000663300009933
              0000CC330000FF33000000660000336600006666000099660000CC660000FF66
              000000990000339900006699000099990000CC990000FF99000000CC000033CC
              000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
              0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
              330000333300333333006633330099333300CC333300FF333300006633003366
              33006666330099663300CC663300FF6633000099330033993300669933009999
              3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
              330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
              66006600660099006600CC006600FF0066000033660033336600663366009933
              6600CC336600FF33660000666600336666006666660099666600CC666600FF66
              660000996600339966006699660099996600CC996600FF99660000CC660033CC
              660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
              6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
              990000339900333399006633990099339900CC339900FF339900006699003366
              99006666990099669900CC669900FF6699000099990033999900669999009999
              9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
              990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
              CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
              CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
              CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
              CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
              CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
              FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
              FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
              FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
              FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
              000000808000800000008000800080800000C0C0C00080808000191919004C4C
              4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
              6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E809090909
              0909090909090909E8E8E8E8818181818181818181818181E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
              0909090909090909E8E8E8E8818181818181818181818181E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
            NumGlyphs = 2
            OnClick = btnTimeDelClick
          end
          object btnTimeAdd: TSpeedButton
            Left = 245
            Top = 40
            Width = 23
            Height = 22
            Flat = True
            Glyph.Data = {
              36060000424D3606000000000000360400002800000020000000100000000100
              08000000000000020000830B0000830B00000001000000010000000000003300
              00006600000099000000CC000000FF0000000033000033330000663300009933
              0000CC330000FF33000000660000336600006666000099660000CC660000FF66
              000000990000339900006699000099990000CC990000FF99000000CC000033CC
              000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
              0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
              330000333300333333006633330099333300CC333300FF333300006633003366
              33006666330099663300CC663300FF6633000099330033993300669933009999
              3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
              330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
              66006600660099006600CC006600FF0066000033660033336600663366009933
              6600CC336600FF33660000666600336666006666660099666600CC666600FF66
              660000996600339966006699660099996600CC996600FF99660000CC660033CC
              660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
              6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
              990000339900333399006633990099339900CC339900FF339900006699003366
              99006666990099669900CC669900FF6699000099990033999900669999009999
              9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
              990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
              CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
              CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
              CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
              CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
              CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
              FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
              FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
              FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
              FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
              000000808000800000008000800080800000C0C0C00080808000191919004C4C
              4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
              6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E809090909
              0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
              0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
            NumGlyphs = 2
            OnClick = btnTimeAddClick
          end
          object Label1: TLabel
            Left = 4
            Top = 159
            Width = 30
            Height = 12
            Caption = #23383#20307':'
          end
          object BtnSFont: TSpeedButton
            Left = 43
            Top = 153
            Width = 80
            Height = 25
            Caption = #24403#21069#23383#20307
            Flat = True
            OnClick = BtnSFontClick
          end
          object Label5: TLabel
            Left = 4
            Top = 193
            Width = 30
            Height = 12
            Caption = #31867#22411':'
          end
          object Label4: TLabel
            Left = 148
            Top = 192
            Width = 30
            Height = 12
            Caption = #38388#38548':'
          end
          object Label13: TLabel
            Left = 9
            Top = 12
            Width = 54
            Height = 12
            Caption = #21333#20301#23485#24230':'
          end
          object Label16: TLabel
            Left = 149
            Top = 160
            Width = 30
            Height = 12
            Caption = #39068#33394':'
          end
          object chkWLine: TCheckBox
            Left = 5
            Top = 128
            Width = 97
            Height = 17
            Caption = #32437#21521#32447#26465
            TabOrder = 0
            OnClick = chkWLineClick
          end
          object LVMain: TListView
            Left = 5
            Top = 40
            Width = 233
            Height = 73
            Columns = <
              item
                Caption = #21517#31216
                Width = 100
              end
              item
                Caption = #31867#22411
                Width = 100
              end>
            ColumnClick = False
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            TabOrder = 1
            ViewStyle = vsReport
            OnChange = LVMainChange
          end
          object chkVisible: TCheckBox
            Left = 125
            Top = 128
            Width = 97
            Height = 17
            Caption = #26159#21542#21487#35265
            TabOrder = 2
            OnClick = chkVisibleClick
          end
          object cboType: TComboBox
            Left = 43
            Top = 188
            Width = 81
            Height = 20
            Style = csDropDownList
            TabOrder = 3
            OnSelect = cboTypeSelect
            Items.Strings = (
              #20998#38047
              #23567#26102
              #22825
              #26143#26399
              #26376
              #23395#24230
              #21322#24180
              #24180)
          end
          object speInterval: TSpinEdit
            Left = 179
            Top = 188
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 4
            Value = 1
            OnChange = speIntervalChange
          end
          object speUnit: TSpinEdit
            Left = 64
            Top = 8
            Width = 81
            Height = 21
            MaxValue = 1000
            MinValue = 1
            TabOrder = 5
            Value = 1
            OnChange = speUnitChange
          end
          object cboTimeColor: TColorBox
            Left = 178
            Top = 157
            Width = 80
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            OnChange = cboTimeColorChange
          end
        end
        object tbFive: TTabSheet
          Caption = #24037#20316#26085
          ImageIndex = 4
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object btnRestAdd: TSpeedButton
            Left = 218
            Top = 79
            Width = 23
            Height = 22
            Flat = True
            Glyph.Data = {
              36060000424D3606000000000000360400002800000020000000100000000100
              08000000000000020000830B0000830B00000001000000010000000000003300
              00006600000099000000CC000000FF0000000033000033330000663300009933
              0000CC330000FF33000000660000336600006666000099660000CC660000FF66
              000000990000339900006699000099990000CC990000FF99000000CC000033CC
              000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
              0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
              330000333300333333006633330099333300CC333300FF333300006633003366
              33006666330099663300CC663300FF6633000099330033993300669933009999
              3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
              330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
              66006600660099006600CC006600FF0066000033660033336600663366009933
              6600CC336600FF33660000666600336666006666660099666600CC666600FF66
              660000996600339966006699660099996600CC996600FF99660000CC660033CC
              660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
              6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
              990000339900333399006633990099339900CC339900FF339900006699003366
              99006666990099669900CC669900FF6699000099990033999900669999009999
              9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
              990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
              CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
              CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
              CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
              CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
              CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
              FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
              FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
              FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
              FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
              000000808000800000008000800080800000C0C0C00080808000191919004C4C
              4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
              6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E809090909
              0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
              0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
              09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
            NumGlyphs = 2
            OnClick = btnRestAddClick
          end
          object btnRestDel: TSpeedButton
            Left = 218
            Top = 103
            Width = 23
            Height = 22
            Flat = True
            Glyph.Data = {
              36060000424D3606000000000000360400002800000020000000100000000100
              08000000000000020000830B0000830B00000001000000010000000000003300
              00006600000099000000CC000000FF0000000033000033330000663300009933
              0000CC330000FF33000000660000336600006666000099660000CC660000FF66
              000000990000339900006699000099990000CC990000FF99000000CC000033CC
              000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
              0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
              330000333300333333006633330099333300CC333300FF333300006633003366
              33006666330099663300CC663300FF6633000099330033993300669933009999
              3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
              330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
              66006600660099006600CC006600FF0066000033660033336600663366009933
              6600CC336600FF33660000666600336666006666660099666600CC666600FF66
              660000996600339966006699660099996600CC996600FF99660000CC660033CC
              660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
              6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
              990000339900333399006633990099339900CC339900FF339900006699003366
              99006666990099669900CC669900FF6699000099990033999900669999009999
              9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
              990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
              CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
              CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
              CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
              CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
              CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
              FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
              FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
              FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
              FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
              000000808000800000008000800080800000C0C0C00080808000191919004C4C
              4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
              6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E809090909
              0909090909090909E8E8E8E8818181818181818181818181E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
              1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
              0909090909090909E8E8E8E8818181818181818181818181E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
              E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
            NumGlyphs = 2
            OnClick = btnRestDelClick
          end
          object Label6: TLabel
            Left = 9
            Top = 190
            Width = 30
            Height = 12
            Caption = #24213#33394':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 9
            Top = 217
            Width = 30
            Height = 12
            Caption = #26102#38388':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label8: TLabel
            Left = 99
            Top = 219
            Width = 18
            Height = 12
            Caption = '---'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label14: TLabel
            Left = 9
            Top = 58
            Width = 66
            Height = 12
            Caption = #20241#24687#26085#39068#33394':'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object LVRest: TListView
            Left = 10
            Top = 79
            Width = 199
            Height = 97
            Columns = <
              item
                Caption = #21517#31216
                Width = 150
              end>
            ColumnClick = False
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnChange = LVRestChange
          end
          object chkWeek1: TCheckBox
            Left = 10
            Top = 8
            Width = 55
            Height = 17
            Caption = #26143#26399#19968
            TabOrder = 1
            OnClick = chkWeek1Click
          end
          object chkWeek2: TCheckBox
            Tag = 1
            Left = 74
            Top = 8
            Width = 55
            Height = 17
            Caption = #26143#26399#20108
            TabOrder = 2
            OnClick = chkWeek1Click
          end
          object chkWeek3: TCheckBox
            Tag = 2
            Left = 138
            Top = 8
            Width = 55
            Height = 17
            Caption = #26143#26399#19977
            TabOrder = 3
            OnClick = chkWeek1Click
          end
          object chkWeek4: TCheckBox
            Tag = 3
            Left = 202
            Top = 8
            Width = 55
            Height = 17
            Caption = #26143#26399#22235
            TabOrder = 4
            OnClick = chkWeek1Click
          end
          object chkWeek5: TCheckBox
            Tag = 4
            Left = 10
            Top = 32
            Width = 55
            Height = 17
            Caption = #26143#26399#20116
            TabOrder = 5
            OnClick = chkWeek1Click
          end
          object chkWeek6: TCheckBox
            Tag = 5
            Left = 74
            Top = 32
            Width = 55
            Height = 17
            Caption = #26143#26399#20845
            TabOrder = 6
            OnClick = chkWeek1Click
          end
          object chkWeek7: TCheckBox
            Tag = 6
            Left = 138
            Top = 32
            Width = 55
            Height = 17
            Caption = #26143#26399#19971
            TabOrder = 7
            OnClick = chkWeek1Click
          end
          object cboRestColor: TColorBox
            Left = 41
            Top = 186
            Width = 96
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            OnChange = cboRestColorChange
          end
          object edtBegin: TEdit
            Left = 40
            Top = 215
            Width = 57
            Height = 20
            TabOrder = 9
            OnExit = edtBeginExit
            OnKeyDown = edtBeginKeyDown
          end
          object edtEnd: TEdit
            Left = 120
            Top = 215
            Width = 57
            Height = 20
            TabOrder = 10
            OnExit = edtEndExit
            OnKeyDown = edtEndKeyDown
          end
          object cboWeekRest: TColorBox
            Left = 81
            Top = 53
            Width = 96
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 11
            OnChange = cboWeekRestChange
          end
        end
        object tbTwo: TTabSheet
          Caption = #26102#38388#26684#24335
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object memMain: TMemo
            Left = 0
            Top = 29
            Width = 125
            Height = 227
            Align = alClient
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 0
          end
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 125
            Height = 29
            Align = alTop
            BevelInner = bvSpace
            BevelOuter = bvNone
            TabOrder = 1
            object btnSet: TSpeedButton
              Left = 10
              Top = 4
              Width = 33
              Height = 22
              Caption = #24212#29992
              Flat = True
              OnClick = btnSetClick
            end
          end
        end
        object tbThree: TTabSheet
          Caption = #24110#21161
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MemHelp: TMemo
            Left = 0
            Top = 0
            Width = 125
            Height = 22
            Align = alClient
            Lines.Strings = (
              '[S:??] '#34920#31034#23545#36215#22987#26102#38388#30340#26684#24335#21270
              '[E:??] '#34920#31034#23545#32467#26463#26102#38388#30340#26684#24335#21270
              ''
              '?? '#21462#20540
              'yyyy,yy '#35199#25991#24180' yyyyy '#20013#25991#24180
              'm,mm '#35199#25991#26376' mmmm '#20013#25991#26376' mmm '#30701#26085#26399#26684#24335
              'd,dd '#26085' ddd '#26143#26399#31616#31216' dddd '#26143#26399#20840#31216' ddddd '#30701#26085#26399#26684#24335#20840#31216#9'dddddd '#38271#26085#26399#26684#24335#20840#31216#9
              'h,hh '#23567#26102
              'n,nn '#20998#38047
              ''
              #20197#19978#20960#31181#37117#21487#20197#32452#21512' ('#38500#20102#20013#25991#24180','#20013#25991#26376')'
              #21015':[S:yyyy-mm-dd]'
              ''
              'Minute=[S:nn]'
              'Hour=[S:hh]'
              'Day=[S:ddd]'
              'Week=[S:dd]-[E:dd]'
              'Month=[S:yyyyy]'#24180'[S:mmmm] <-'#20013#25991#24180','#20013#25991#26376#35201#36825#26679#32452#21512
              'Quarter=[S:mm]'
              'HalfYear=[S:mm]'
              'Year=[S:mm]')
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
      end
    end
  end
  object ImageList1: TImageList
    Left = 8
    Top = 384
    Bitmap = {
      494C010101000800080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A4787400A67A
      7500A67A7500A67A7500A67A7500A67A7500A67A7500A67A7500A67A7500A67A
      7500A67A75009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A77B7500FAE7
      C400FAE5BE00FAE2B900FAE1B400F9DFAE00F9DDAA00F9DAA600F8D9A200F8D8
      9F00F8D79C009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB7E7700FBEA
      CC00FBE8C700FBE6C000FAE3BB00FAE1B500A67B7600A67B7600A67B7600A67B
      7600F8D8A0009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B0827A00FCEE
      D500FCECCF00FBEAC900FAE7C400FAE4BE00FAE2B800FAE0B300F9DEAE00F9DC
      A900F8DBA5009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B4877B00FCF1
      DC00A67B7600FCEDD100A67B7600FBE7C500A67B7600FAE3BB00A67B7600FAE0
      B000F9DDAC009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BA8C7E00FDF5
      E500FCF2DF00FCEFDA00FCEED400FCEBCE00FBE8C800FBE6C300FAE4BD00FAE2
      B700F9E0B2009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0928100FEF7
      EC00A67B7600A67B7600A67B7600A67B7600A67B7600FCEACA00FAE8C500FAE5
      BF00FAE3BA009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6978300FEFA
      F200FEF8EE00FDF6E900FDF4E400FCF2DE00FDEFD900FCEED300FBEBCD00FBE8
      C700FAE6C1009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CB9C8600FEFD
      F800A67B7600A67B7600A67B7600A67B7600A67B7600FCF0DB00FCEED500FCEC
      D000FBEACA009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D1A08800FFFE
      FD00FFFDFA00FFFBF600FEFAF100FEF8ED00FEF5E800FDF4E300FDF1DD00F8E1
      C300F3DDBA009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D5A58A00FFFF
      FF00A67B7600A67B7600A67B7600A67B7600A67B7600FDF7EA00FDF5E500E5D7
      C400C4BCAC009A6D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D9A88B00FFFF
      FF00A67B7600FFFFFF00FEFEFC00FFFDF900A67B7600FEFAF100B3817500B381
      7500B3817500B381750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCAB8D00FFFF
      FF00A67B7600A67B7600A67B7600A67B7600A67B7600FFFCF700B3817500FFD1
      7F00F5B55C00CA90780000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCAB8D00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FEFFFE00FFFEFC00B3817500F7C6
      8300CA9078000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DCAB8D00DAA4
      8200DAA48200DAA48200DAA48200DAA48200DAA48200DAA48200B3817500CA90
      7800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C007000000000000C00F00000000000000000000000000000000000000000000
      000000000000}
  end
  object PmuList: TPopupMenu
    Left = 40
    Top = 384
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 72
    Top = 384
  end
end
