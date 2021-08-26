object gMap: TgMap
  Left = 543
  Top = 382
  BorderIcons = [biMaximize]
  BorderStyle = bsToolWindow
  ClientHeight = 552
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object llat: TLabel
    Left = 71
    Top = 15
    Width = 24
    Height = 16
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object Image1: TImage
    Left = 8
    Top = 12
    Width = 48
    Height = 48
    AutoSize = True
    Center = True
  end
  object img: TImage
    Left = 0
    Top = 72
    Width = 640
    Height = 480
  end
  object llon: TLabel
    Left = 71
    Top = 39
    Width = 24
    Height = 16
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object cxButton1: TcxButton
    Left = 552
    Top = 17
    Width = 82
    Height = 34
    Caption = 'Salir'
    TabOrder = 0
    OnClick = cxButton1Click
  end
  object cte: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 256
    Top = 264
  end
end
