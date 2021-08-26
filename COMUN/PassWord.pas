unit PASSWORD;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    cancela : boolean;
  end;


implementation

{$R *.dfm}

procedure TPasswordDlg.CancelBtnClick(Sender: TObject);
begin
   cancela := true;
end;

procedure TPasswordDlg.FormCreate(Sender: TObject);
begin
   cancela := true;
end;

procedure TPasswordDlg.OKBtnClick(Sender: TObject);
begin
   cancela := false;
end;

end.
 
