object box: Tbox
  Left = 2492
  Top = 342
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Aviso'
  ClientHeight = 169
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object btnSi: TcxButton
    Left = 81
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Si'
    TabOrder = 0
    OnClick = btnSiClick
  end
  object btnNo: TcxButton
    Left = 161
    Top = 136
    Width = 75
    Height = 25
    Caption = 'No'
    TabOrder = 1
    OnClick = btnNoClick
  end
  object m: TMemo
    Left = 0
    Top = 0
    Width = 317
    Height = 130
    Margins.Top = 10
    Margins.Bottom = 10
    Align = alTop
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
