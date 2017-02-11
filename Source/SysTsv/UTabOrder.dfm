object fmTabOrder: TfmTabOrder
  Left = 258
  Top = 145
  Width = 350
  Height = 264
  ActiveControl = clbList
  BorderIcons = [biSystemMenu]
  Caption = 'Порядок перехода'
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 203
    Width = 342
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 157
      Top = 0
      Width = 185
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TBitBtn
        Left = 21
        Top = 3
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 3
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
  end
  object pnTabOrder: TPanel
    Left = 0
    Top = 0
    Width = 342
    Height = 203
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object gbTabOrder: TGroupBox
      Left = 5
      Top = 5
      Width = 332
      Height = 193
      Align = alClient
      Caption = ' Список компонентов '
      TabOrder = 0
      object pnList: TPanel
        Left = 2
        Top = 15
        Width = 328
        Height = 176
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        TabOrder = 0
        object pnListR: TPanel
          Left = 283
          Top = 4
          Width = 41
          Height = 168
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object btUp: TBitBtn
            Left = 0
            Top = 4
            Width = 40
            Height = 25
            TabOrder = 0
            OnClick = btUpClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              8888888888888888888888888888888888888888888888888888888880000088
              8888888880666088888888888066608888888888806660888888880000666000
              0888888066666660888888880666660888888888806660888888888888060888
              8888888888808888888888888888888888888888888888888888}
          end
          object btDown: TBitBtn
            Left = 0
            Top = 36
            Width = 40
            Height = 25
            TabOrder = 1
            OnClick = btDownClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              8888888888888888888888888888888888888888888888888888888888808888
              8888888888060888888888888066608888888888066666088888888066666660
              8888880000666000088888888066608888888888806660888888888880666088
              8888888880000088888888888888888888888888888888888888}
          end
        end
        object Panel1: TPanel
          Left = 4
          Top = 4
          Width = 279
          Height = 168
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object clbList: TCheckListBox
            Left = 5
            Top = 5
            Width = 269
            Height = 139
            Align = alClient
            Flat = False
            ItemHeight = 13
            TabOrder = 0
            OnClick = clbListClick
            OnDragDrop = clbListDragDrop
            OnDragOver = clbListDragOver
            OnDrawItem = clbListDrawItem
            OnEndDrag = clbListEndDrag
            OnMouseMove = clbListMouseMove
          end
          object Panel4: TPanel
            Left = 5
            Top = 144
            Width = 269
            Height = 19
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object chbViewComponent: TCheckBox
              Left = 0
              Top = 2
              Width = 145
              Height = 17
              Caption = 'Выделять компонент'
              TabOrder = 0
            end
          end
        end
      end
    end
  end
end
