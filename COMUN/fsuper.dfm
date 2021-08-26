object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = ' Acceso de supervisor'
  ClientHeight = 109
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lb21: TLabel
    Left = 8
    Top = 16
    Width = 101
    Height = 16
    Caption = 'Clave de acceso :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edpasswd: TcxTextEdit
    Left = 8
    Top = 38
    ParentFont = False
    Properties.EchoMode = eemPassword
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Width = 209
  end
  object cxCheckBox1: TcxCheckBox
    Left = 8
    Top = 75
    Caption = 'No pedir clave en esta sesi'#243'n.'
    TabOrder = 1
    Width = 209
  end
  object btn1: TcxButton
    Left = 261
    Top = 5
    Width = 86
    Height = 40
    Caption = 'Validar'
    Colors.Default = 12572622
    LookAndFeel.NativeStyle = False
    TabOrder = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btn2: TcxButton
    Left = 261
    Top = 65
    Width = 86
    Height = 40
    Caption = 'Cancelar'
    Colors.Default = 12369118
    LookAndFeel.NativeStyle = False
    TabOrder = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
end
