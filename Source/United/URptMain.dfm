object fmRptMain: TfmRptMain
  Left = 634
  Top = 450
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'fmRptMain'
  ClientHeight = 261
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000078888888888880007FFFFFFFFFFF80007FF
    00FF00FFF80007FF00F00FFFF80007FF0000FFFFF80007FF000FFFFFF80007FF
    0000FFFFF80007FF00FF0FFFF80007FF00FF0FFFF80007FF00FF0FF0000007FF
    0000FFF7880007FFFFFFFFF7800007FFFFFFFFF700000777777777770000FFFF
    0000800100008001000080010000800100008001000080010000800100008001
    0000800100008001000080010000800100008003000080070000800F0000}
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnBut: TPanel
    Left = 0
    Top = 223
    Width = 382
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = -4
      Top = 0
      Width = 386
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibGen: TButton
        Left = 109
        Top = 5
        Width = 90
        Height = 25
        Hint = 'Сформировать'
        Anchors = [akRight, akBottom]
        Caption = 'Сформировать'
        TabOrder = 0
        OnClick = bibGenClick
      end
      object bibClose: TButton
        Left = 304
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Закрыть'
        Anchors = [akRight, akBottom]
        Caption = 'Закрыть'
        TabOrder = 2
        OnClick = bibCloseClick
      end
      object bibBreak: TButton
        Left = 207
        Top = 5
        Width = 90
        Height = 25
        Hint = 'Прервать выполнение'
        Anchors = [akRight, akBottom]
        Caption = 'Прервать'
        Enabled = False
        TabOrder = 1
        OnClick = bibBreakClick
      end
      object bibClear: TButton
        Left = 12
        Top = 5
        Width = 90
        Height = 25
        Hint = 'Очистить'
        Anchors = [akRight, akBottom]
        Caption = 'Очистить'
        TabOrder = 3
        Visible = False
        OnClick = bibClearClick
      end
    end
  end
  object cbInString: TCheckBox
    Left = 8
    Top = 204
    Width = 137
    Height = 17
    Caption = 'По вхождению строки'
    TabOrder = 1
    Visible = False
  end
  object IBTran: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 72
    Top = 105
  end
  object Mainqr: TIBQuery
    Transaction = IBTran
    BufferChunks = 1000
    CachedUpdates = False
    Left = 32
    Top = 104
  end
end
