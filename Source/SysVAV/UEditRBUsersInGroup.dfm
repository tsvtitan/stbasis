inherited fmEditRBUsersInGroup: TfmEditRBUsersInGroup
  Left = 191
  Top = 161
  Caption = ''
  ClientHeight = 252
  ClientWidth = 595
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 214
    Width = 595
    TabOrder = 1
    inherited Panel2: TPanel
      Left = 410
    end
  end
  inherited cbInString: TCheckBox
    Left = 4
    Top = 308
    TabOrder = 0
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 595
    Height = 214
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnSrc: TPanel
      Left = 0
      Top = 0
      Width = 273
      Height = 214
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
    end
    object pnMan: TPanel
      Left = 273
      Top = 0
      Width = 80
      Height = 214
      Align = alLeft
      TabOrder = 1
      object BitBtn1: TBitBtn
        Left = 5
        Top = 32
        Width = 70
        Height = 25
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object BitBtn2: TBitBtn
        Left = 5
        Top = 64
        Width = 70
        Height = 25
        Caption = '>>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object BitBtn3: TBitBtn
        Left = 5
        Top = 96
        Width = 70
        Height = 25
        Caption = '<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object BitBtn4: TBitBtn
        Left = 5
        Top = 128
        Width = 70
        Height = 25
        Caption = '<<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
    object pnDst: TPanel
      Left = 353
      Top = 0
      Width = 242
      Height = 214
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  inherited IBTran: TIBTransaction
    Left = 0
    Top = 1
  end
  object MainQr: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 112
    Top = 8
  end
  object DataSource1: TDataSource
    Left = 144
    Top = 8
  end
  object MemDSrc: TRxMemoryData
    FieldDefs = <>
    Left = 112
    Top = 40
  end
  object MemDDst: TRxMemoryData
    FieldDefs = <>
    Left = 152
    Top = 40
  end
  object DSSrc: TDataSource
    DataSet = MemDSrc
    Left = 112
    Top = 72
  end
  object DSDst: TDataSource
    DataSet = MemDDst
    Left = 152
    Top = 72
  end
end
