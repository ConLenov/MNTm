object memform: Tmemform
  Left = 342
  Top = 210
  BorderStyle = bsNone
  Caption = 'memform'
  ClientHeight = 473
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDblClick = FormDblClick
  PixelsPerInch = 96
  TextHeight = 13
  object memname: TLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 29
    Caption = #1055#1072#1084#1103#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object physmemall: TLabel
    Left = 424
    Top = 8
    Width = 33
    Height = 20
    Caption = 'phys'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object physmemloadc: TLabel
    Left = 8
    Top = 224
    Width = 93
    Height = 16
    Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object physmemload: TLabel
    Left = 8
    Top = 248
    Width = 40
    Height = 24
    Caption = 'phys'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object physmemavac: TLabel
    Left = 128
    Top = 224
    Width = 63
    Height = 16
    Caption = #1044#1086#1089#1090#1091#1087#1085#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object physmemava: TLabel
    Left = 128
    Top = 248
    Width = 40
    Height = 24
    Caption = 'phys'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object memstruct: TGauge
    Left = 8
    Top = 168
    Width = 513
    Height = 49
    BackColor = clBtnFace
    Color = 11408011
    ForeColor = 11408011
    Font.Charset = BALTIC_CHARSET
    Font.Color = clBtnFace
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Progress = 0
  end
  object virtmemc: TLabel
    Left = 8
    Top = 288
    Width = 66
    Height = 16
    Caption = #1042#1099#1076#1077#1083#1077#1085#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object virtmemload: TLabel
    Left = 8
    Top = 312
    Width = 102
    Height = 24
    Caption = 'virtmemload'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object virtmemall: TLabel
    Left = 96
    Top = 312
    Width = 116
    Height = 24
    Caption = 'virtmemall'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 400
    Top = 240
  end
  object Timepercent: TTimer
    OnTimer = TimepercentTimer
    Left = 448
    Top = 240
  end
end
