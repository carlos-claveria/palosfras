unit crono;

interface
type
   TCron = record
      tstart,
      tclick,
      tstop,
      tdif   : TDateTime;
      procedure start;
      procedure stop;
      
      function  dif   : string;
      function pdif   : string;
      function click  : string;
      
   end;


implementation
uses SysUtils,DateUtils;

procedure TCron.start;
begin
  tstart := now;
  tclick := tstart;
  tstop  := tstart;
end;
procedure TCron.stop;
begin
  tstop := now;
  tdif  := tstop-tstart;
end;
function TCron.dif : string;
begin
  if MinutesBetween(tstop,tstart) > 59 then
     result := FormatDateTime('[hhh nn:ss zzz]', tdif)
  else
     result := FormatDateTime('[nn:ss zzz]', tdif);
end;

function TCron.pdif : string;
begin
  tstop := now;
  tdif  := tstop-tstart;
  
  result := dif;
end;

function TCron.click : string;
begin
  tstop  := now;
  tdif   := tstop-tclick;
  tclick := Now;
  
  result := dif;
end;

end. 
