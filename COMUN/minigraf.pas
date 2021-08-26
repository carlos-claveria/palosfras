unit minigraf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls,silKernel;

type
  
  T_graf = class(TFrame)
    shp01: TShape;
    shp02: TShape;
    shp03: TShape;
    shp04: TShape;
    shp05: TShape;
    shp06: TShape;
    shp07: TShape;
    shp08: TShape;
    shp09: TShape;
    shp10: TShape;
    shp11: TShape;
    shp12: TShape;
    shp13: TShape;
    shp14: TShape;
    shp15: TShape;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lMAX: TLabel;
    lMIN: TLabel;
    shp17: TShape;
    shp18: TShape;
    shp19: TShape;
    shp20: TShape;
    shp21: TShape;
    shp22: TShape;
    shp23: TShape;
    shp24: TShape;
    shp16: TShape;
    lb1: TLabel;
    lb2: TLabel;
    lb3: TLabel;
    lb4: TLabel;
    lb5: TLabel;
  private
    { Private declarations }
  public
    abar : array[1..24] of Tshape;
    procedure graf(a : TListaHorasDia);
  end;

const
   _DISPEN = clRed;
   _DISBRU = $00A4D9B1;
   _ENAPEN = clBlack;
   _ENABRU = clBlack;

implementation
uses Math;                      


procedure T_graf.graf(a: TListaHorasDia);
var
   i,
   mx,
   mn   : integer;
begin
   abar[ 1] := Shp01;
   abar[ 2] := Shp02;
   abar[ 3] := Shp03;
   abar[ 4] := Shp04;
   abar[ 5] := Shp05;
   abar[ 6] := Shp06;
   abar[ 7] := Shp07;
   abar[ 8] := Shp08;
   abar[ 9] := Shp09;
   abar[10] := Shp10;
   abar[11] := Shp11;
   abar[12] := Shp12;
   abar[13] := Shp13;
   abar[14] := Shp14;
   abar[15] := Shp15;
   abar[16] := Shp16;
   abar[17] := Shp17;
   abar[18] := Shp18;
   abar[19] := Shp19;
   abar[20] := Shp20;
   abar[21] := Shp21;
   abar[22] := Shp22;
   abar[23] := Shp23;
   abar[24] := Shp24;
                  
   mx := -1;

   for i := 1 to 24 do begin

   if a[i] > mx then mx := a[i];

   mn := 0;

   end;
   
   mn := 0;
   
   if mx = 0 then mx := 1;

   lmax.Caption := inttostr(mx);
   

   for i := 1 to 24  do begin
   
      if a[i] = -1 then begin
      
        abar[i].Pen.Color   := _DISPEN;
        abar[i].Brush.Color := _DISBRU; 
        abar[i].Hint        := '';
        abar[i].Height      := 40;
        abar[i].Top         := 12;
        
      end
      else begin 

        abar[i].Pen.Color   := _ENAPEN;
        abar[i].Brush.Color := _ENABRU; 
        abar[i].Hint        := inttostr(a[i]);
       
        abar[i].Height      := a[i] * 40 div mx;
        abar[i].Top         := 12 + (40-abar[i].Height);
      
     end;
      
   end;

   


end;

{$R *.dfm}

end.
