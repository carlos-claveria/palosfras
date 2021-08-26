unit uMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfMsg = class(TForm)
    lMsg: TLabel;
    pb: TProgressBar;
  private
    { Private declarations }
  public
    procedure Muestra(msg : string);
    procedure Cierra;
    procedure Gau(n : LongInt);
    procedure Add;
  end;

var
  fMsg: TfMsg;

implementation

procedure TfMsg.Add;
begin
     pb.position := (pb.position + 1);
end;     

procedure TfMsg.Gau(n : LongInt);
begin
     if (n > 0) then
        pb.visible := TRUE
     else
        pb.visible := FALSE;
        
     pb.max     := n;
     pb.position := 0;
     application.processmessages;
     
end;

procedure TfMsg.Muestra(msg : string);
begin
     lMsg.Caption := msg;
     pb.position := 0;
     
     if pb.max = 0 then 
        pb.visible := FALSE
     else
        pb.visible := TRUE;
        
     Show;
     Update;
     screen.cursor := crHourGlass;
     application.processmessages;
     
end;
procedure TfMsg.Cierra;
begin
     Close;
     pb.max := 0;
     pb.position := 0;
     screen.cursor := crDefault;
     application.processmessages;
end;     
     
     

{$R *.DFM}

end.
