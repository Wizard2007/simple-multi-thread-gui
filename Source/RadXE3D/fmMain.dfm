object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Simple parser'
  ClientHeight = 415
  ClientWidth = 682
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 682
    Height = 415
    ActivePage = tsGetEngineerList
    Align = alClient
    TabOrder = 0
    object tsGetEngineerList: TTabSheet
      Caption = 'ParserSettings'
      object gGetEngineerUrls: TGauge
        AlignWithMargins = True
        Left = 3
        Top = 24
        Width = 668
        Height = 16
        Align = alTop
        Progress = 0
        ExplicitTop = -1
      end
      object grpErrorUrlList: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 98
        Width = 668
        Height = 46
        Align = alTop
        Caption = 'Error Url List'
        TabOrder = 0
        object edtErrorUrlList: TEdit
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 629
          Height = 23
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 21
        end
        object btnSelectErrorUrlList: TButton
          AlignWithMargins = True
          Left = 640
          Top = 18
          Width = 23
          Height = 23
          Action = aSelectErrorUrlList
          Align = alRight
          TabOrder = 1
        end
      end
      object grpUrlList: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 46
        Width = 668
        Height = 46
        Align = alTop
        Caption = 'Url List'
        TabOrder = 1
        object edtUrlList: TEdit
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 629
          Height = 23
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 21
        end
        object btnSelectUrlList: TButton
          AlignWithMargins = True
          Left = 640
          Top = 18
          Width = 23
          Height = 23
          Action = aSelectUrlLsit
          Align = alRight
          TabOrder = 1
        end
      end
      object gpbThreadCount: TGroupBox
        Left = 0
        Top = 147
        Width = 674
        Height = 44
        Align = alTop
        Caption = 'Thread Count'
        TabOrder = 2
        object edtTreadCount: TSpinEdit
          Left = 8
          Top = 16
          Width = 121
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object tbMain: TToolBar
        Left = 0
        Top = 0
        Width = 674
        Height = 21
        ButtonHeight = 21
        ButtonWidth = 69
        Caption = 'tbMain'
        ShowCaptions = True
        TabOrder = 3
        object btnGetUrlList: TToolButton
          Left = 0
          Top = 0
          Action = aGetUrlList
        end
        object btnGetInfo: TToolButton
          Left = 69
          Top = 0
          Action = aGetInfo
        end
        object btnSaveParams: TToolButton
          Left = 138
          Top = 0
          Action = aSaveParams
          Marked = True
        end
      end
      object grpMaxPageCount: TGroupBox
        Left = 0
        Top = 191
        Width = 674
        Height = 44
        Align = alTop
        Caption = 'Max page count'
        TabOrder = 4
        object edtMaxPageCount: TSpinEdit
          Left = 8
          Top = 16
          Width = 121
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object grpStep: TGroupBox
        Left = 0
        Top = 235
        Width = 674
        Height = 44
        Align = alTop
        Caption = 'Step for get task in threads'
        TabOrder = 5
        object edtStep: TSpinEdit
          Left = 8
          Top = 16
          Width = 121
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
    end
  end
  object alMain: TActionList
    Left = 280
    Top = 192
    object aGetUrlList: TAction
      Caption = 'Get Url List'
      OnExecute = aGetUrlListExecute
    end
    object aSelectUrlLsit: TAction
      Caption = '...'
      OnExecute = aSelectUrlLsitExecute
    end
    object aSelectErrorUrlList: TAction
      Caption = '...'
      OnExecute = aSelectErrorUrlListExecute
    end
    object aSaveParams: TAction
      Caption = 'Save Params'
      OnExecute = aSaveParamsExecute
    end
    object aGetInfo: TAction
      Caption = 'Get Info'
      OnExecute = aGetInfoExecute
    end
  end
  object fodUrlList: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'csv'
        FileMask = '*.csv'
      end>
    Options = []
    Left = 320
    Top = 256
  end
  object fodErrorUrlList: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'csv'
        FileMask = '*.csv'
      end>
    Options = []
    Left = 360
    Top = 304
  end
end
