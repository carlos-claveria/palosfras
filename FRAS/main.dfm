object fMain: TfMain
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'FACTURAS EN PALOS DE LA FRONTERA'
  ClientHeight = 549
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object stat1: TStatusBar
    AlignWithMargins = True
    Left = 3
    Top = 527
    Width = 899
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 899
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnSal: TButton
      AlignWithMargins = True
      Left = 821
      Top = 3
      Width = 75
      Height = 40
      Align = alRight
      Caption = 'SALIR'
      TabOrder = 0
      OnClick = btnSalClick
    end
    object btnCab: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 40
      Align = alLeft
      Caption = 'CABECERA'
      TabOrder = 1
      OnClick = btnCabClick
    end
    object btnAbos: TButton
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 75
      Height = 40
      Align = alLeft
      Caption = 'NOMBRES'
      TabOrder = 2
      OnClick = btnAbosClick
    end
  end
  object m: TMemo
    Left = 0
    Top = 160
    Width = 905
    Height = 364
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
