inherited ADSpeedGenDataFrm: TADSpeedGenDataFrm
  Left = 328
  Top = 236
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Generate Data'
  ClientHeight = 176
  ClientWidth = 390
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 142
    Width = 390
    inherited btnOk: TButton
      Left = 307
    end
    inherited btnCancel: TButton
      Left = 150
      Visible = False
    end
  end
  inherited pnlMain: TADGUIxFormsPanel
    Width = 390
    Height = 142
    inherited pnlGray: TADGUIxFormsPanel
      Width = 382
      Height = 134
      inherited pnlOptions: TADGUIxFormsPanel
        Width = 380
        Height = 109
        object Label1: TLabel
          Left = 11
          Top = 17
          Width = 220
          Height = 13
          Caption = 'Fill ADQA_Categories (with BLOBs) by records:'
        end
        object Label2: TLabel
          Left = 11
          Top = 48
          Width = 243
          Height = 13
          Caption = 'Fill ADQA_Products (no BLOBs) by records (1000 x)'
        end
        object Edit1: TEdit
          Left = 263
          Top = 14
          Width = 61
          Height = 21
          TabOrder = 0
          Text = '200'
        end
        object Button1: TButton
          Left = 333
          Top = 10
          Width = 36
          Height = 25
          Caption = 'Gen'
          TabOrder = 1
          OnClick = Button1Click
        end
        object ProgressBar1: TProgressBar
          Left = 11
          Top = 80
          Width = 357
          Height = 17
          Step = 1
          TabOrder = 4
        end
        object Edit2: TEdit
          Left = 263
          Top = 46
          Width = 61
          Height = 21
          TabOrder = 2
          Text = '200'
        end
        object Button2: TButton
          Left = 333
          Top = 42
          Width = 36
          Height = 25
          Caption = 'Gen'
          TabOrder = 3
          OnClick = Button2Click
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        Width = 380
        inherited lblTitle: TLabel
          Width = 288
          Caption = 'Enter number and press "Gen" to fill specified table'
        end
        inherited pnlTitleBottomLine: TADGUIxFormsPanel
          Width = 380
        end
      end
    end
  end
  object ADConnection1: TADConnection
    Left = 136
    Top = 104
  end
  object qInsLong: TADQuery
    Connection = ADConnection1
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      
        'INSERT INTO ADQA_Categories (CategoryID, CategoryName, Descripti' +
        'on)'
      'VALUES (:F1, :F2, :F3)')
    Left = 64
    Top = 104
    ParamData = <
      item
        Name = 'F1'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'F2'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'F3'
        DataType = ftDateTime
        ParamType = ptInput
      end>
  end
  object qDelLong: TADQuery
    Connection = ADConnection1
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'TRUNCATE TABLE ADQA_Categories')
    Left = 32
    Top = 104
  end
  object qDelSmall: TADQuery
    Connection = ADConnection1
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'TRUNCATE TABLE ADQA_Products')
    Left = 288
    Top = 104
  end
  object qInsSmall: TADQuery
    Connection = ADConnection1
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      
        'INSERT INTO ADQA_Products (ProductID, ProductName, FromDate, Sup' +
        'plierID, CategoryID,'
      
        '  QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, OnDate' +
        ')'
      'VALUES (:F1, :F2, :F3, :F4, :F5, :F6, :F7, :F8, :F9, :F10)')
    Left = 320
    Top = 104
    ParamData = <
      item
        Name = 'F1'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'F2'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'F3'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'F4'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'F5'
        ParamType = ptInput
      end
      item
        Name = 'F6'
        ParamType = ptInput
      end
      item
        Name = 'F7'
        ParamType = ptInput
      end
      item
        Name = 'F8'
        ParamType = ptInput
      end
      item
        Name = 'F9'
        ParamType = ptInput
      end
      item
        Name = 'F10'
        ParamType = ptInput
      end>
  end
  object ADPhysOraclDriverLink1: TADPhysOraclDriverLink
    Left = 168
    Top = 104
  end
  object ADGUIxWaitCursor1: TADGUIxWaitCursor
    Left = 232
    Top = 104
  end
  object ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink
    Left = 200
    Top = 104
  end
end
