inherited fmRBQuery: TfmRBQuery
  Left = 419
  Top = 160
  Width = 580
  Height = 427
  Caption = ''
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    007000000000000000070000000000000000700000000000000B070000000000
    0000B070000000000BBFBB070000000000FB00000000000000BFB07000000000
    000BFB070000000FBFBFBFB070000000FBFB000000000000BFBFB07000000000
    0BFBFB07000000000FFFBFF07000000000FBFFBF07000000000000000000F9FF
    0000F8FF0000FC7F0000FC3F0000F01F0000F00F0000F80F0000F81F0000C00F
    0000C0070000E00F0000E01F0000F00F0000F0070000F8030000F8030000}
  PixelsPerInch = 96
  TextHeight = 13
  object spl: TSplitter [0]
    Left = 0
    Top = 96
    Width = 572
    Height = 3
    Cursor = crSizeNS
    Align = alTop
  end
  inherited pnBackGrid: TPanel
    Top = 127
    Width = 572
    Height = 234
    TabOrder = 2
    inherited pnBut: TPanel
      Left = 488
      Height = 234
      Visible = False
      inherited pnModal: TPanel
        Height = 133
      end
    end
    inherited pnGrid: TPanel
      Width = 488
      Height = 234
    end
  end
  inherited pnFind: TPanel
    Top = 99
    Width = 572
    TabOrder = 1
    inherited Label1: TLabel
      Top = 5
      Anchors = [akLeft, akBottom]
    end
    inherited edSearch: TEdit
      Top = 2
      Anchors = [akLeft, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Top = 361
    Width = 572
    TabOrder = 3
    inherited bibOk: TButton
      Left = 409
    end
    inherited bibClose: TButton
      Left = 491
    end
  end
  object pnSqlExecute: TPanel [4]
    Left = 0
    Top = 0
    Width = 572
    Height = 96
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    Constraints.MinHeight = 80
    TabOrder = 0
    object grbSqlExecute: TGroupBox
      Left = 5
      Top = 5
      Width = 562
      Height = 86
      Align = alClient
      Caption = ' SQL запрос  '
      TabOrder = 0
      object pnSqlExecuteBut: TPanel
        Left = 479
        Top = 15
        Width = 81
        Height = 69
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object bibSqlExecute: TButton
          Left = 1
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Выполнить'
          TabOrder = 0
          OnClick = bibSqlExecuteClick
        end
      end
      object pnSqlExecuteMemo: TPanel
        Left = 2
        Top = 15
        Width = 477
        Height = 69
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object meExecute: TMemo
          Left = 5
          Top = 5
          Width = 467
          Height = 59
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnKeyDown = FormKeyDown
        end
      end
    end
  end
  inherited ds: TDataSource
    Top = 136
  end
  inherited Mainqr: TIBQuery
    Top = 136
  end
  inherited IBTran: TIBTransaction
    Top = 137
  end
  inherited pmGrid: TPopupMenu
    Top = 137
  end
  inherited IBUpd: TIBUpdateSQL
    Top = 137
  end
  object pmAction: TPopupMenu
    OnPopup = pmActionPopup
    Left = 128
    Top = 199
    object miSaveSructureXML: TMenuItem
      Caption = 'Сохранить структуру в XML'
      OnClick = miSaveSructureXMLClick
    end
    object miSaveSructureWithDataXML: TMenuItem
      Caption = 'Сохранить структуру вместе с данными в XML'
      OnClick = miSaveSructureXMLClick
    end
  end
  object sd: TSaveDialog
    Options = [ofEnableSizing]
    Left = 96
    Top = 199
  end
  object cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 199
  end
end
