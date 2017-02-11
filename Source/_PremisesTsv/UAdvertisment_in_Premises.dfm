object fmAdvertisment_in_Premises: TfmAdvertisment_in_Premises
  Left = 509
  Top = 328
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Назначение рекламы'
  ClientHeight = 323
  ClientWidth = 482
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 490
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pn: TPanel
    Left = 0
    Top = 0
    Width = 482
    Height = 288
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 288
    Width = 482
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object bibOk: TButton
      Left = 323
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = bibOkClick
    end
    object bibCancel: TButton
      Left = 403
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Отмена'
      TabOrder = 1
      OnClick = bibCancelClick
    end
  end
  object IBTran: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 168
    Top = 169
  end
  object Mainqr: TIBQuery
    Transaction = IBTran
    BufferChunks = 50
    CachedUpdates = False
    ParamCheck = False
    Left = 136
    Top = 168
  end
  object ds: TDataSource
    AutoEdit = False
    DataSet = CDS
    Left = 104
    Top = 168
  end
  object IBUpd: TIBUpdateSQL
    Left = 200
    Top = 169
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP'
    Left = 104
    Top = 112
  end
  object DSP: TDataSetProvider
    DataSet = Mainqr
    Constraints = True
    Left = 160
    Top = 112
  end
end
