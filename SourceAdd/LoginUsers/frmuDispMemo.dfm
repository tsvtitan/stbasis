object frmDispMemo: TfrmDispMemo
  Left = 290
  Top = 244
  Width = 461
  Height = 298
  BorderStyle = bsSizeToolWin
  Caption = 'frmDispMemo'
  Color = clBtnFace
  UseDockManager = True
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 453
    Height = 271
    Align = alClient
    Lines.Strings = (
      'Memo')
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
end
