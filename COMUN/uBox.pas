unit uBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, StdCtrls, cxButtons, Menus, cxGraphics,
  cxLookAndFeels;

type
  Tbox = class(TForm)
    btnSi: TcxButton;
    btnNo: TcxButton;
    m: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSiClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
  private
    lOk : boolean;
  public
    function Mos( st : string ) : boolean;
  end;

var
  box: Tbox;
const
   MAX_CHAR = 352;  
   LEN_LINE = 44;

implementation

{$R *.dfm}

function TBox.Mos( st : string ) : boolean;
var
   nl,z : integer;
begin
   lOk := FALSE;
   m.Lines.Clear;
   nl := (MAX_CHAR-length(st)) div (LEN_LINE*2);
   for z := 1 to nl do m.Lines.Add('');
   m.Lines.Add(st);
   ShowModal;
   result := lOk;
end;

procedure Tbox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      VK_RETURN, ord('S'), ord ('s') : btnSiClick(self);
      VK_ESCAPE, ord('N'), ord('n')  : btnNoClick(self);
   end;                                     
end;

procedure Tbox.btnSiClick(Sender: TObject);
begin
    lOk := TRUE;
    Close;
end;

procedure Tbox.btnNoClick(Sender: TObject);
begin
     lOk := FALSE;
     Close;
end;

end.
