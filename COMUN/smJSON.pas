unit smJSON;
 
interface
uses JSON,DB,DateUtils, SysUtils,IdCoder, IdCoderMIME, idGlobal;

function datetime2JSON( const dt : TDateTime) : string;
function date2JSON( const dt : TDate) : string;
function time2JSON( const dt : TTime) : string;

function JSON2datetime( const JSONdt : string) : TDateTime;
function dataSet2JSON( d : TDataSet; soloactual : boolean = true; poner : string = '') : string;

var
   ErJSON  : boolean;
   

implementation
uses strutils,comun;

function dataSet2JSON( d : TDataSet; soloactual : boolean = true; poner : string = '') : string;
var
   i        : integer;
   esArray  : boolean;
   BM       : TBookMark;
   nf       : string;
   Bytes    : TIdBytes;
   z        : variant;
   x        : TFormatSettings;
begin
   result  := '';
   BM      := nil;
   esArray := false;
   ErJSON  := true;
   
   
   if (not d.Active) or d.Eof  then exit;

   d.DisableControls;
   
   // Convertir todas las filas.
   if not soloactual then begin
      BM := d.GetBookmark;
      d.First;
      esArray := (d.RecordCount > 1);
   end;

   if (length(poner) > 0) and (RightStr(poner,1) <> ',') then poner := poner +',';

   x.DecimalSeparator := '.';
   
   try

     while not d.eof do begin
       result := result + '{'+poner;
       for i := 0 to d.Fields.Count -1 do begin
       
         nf := d.Fields[i].FieldName;

         if d.Fields[i].IsNull then
             result := result + format('"%s":"null",',[nf])
         else
         if d.Fields[i].IsBlob then begin
             z := d.Fields[i].Value;
             SetLength(Bytes, sizeof(z));
             Move(z, Bytes[0],sizeof(z));
             result := result + format('"%s":"%s",',[nf,TIdEncoderMIME.EncodeBytes(Bytes)]);         
         end
         else
         case d.Fields[i].DataType of
         
              ftFixedChar, 
              ftWideString,
              ftMemo,
              ftString     : begin
                                 result := result + format('"%s":"%s",',[nf,comun.EscapeValue(d.Fields[i].AsString)]);
              end;
              
              ftDate       : begin
                                 result := result + format('"%s":"%s",',[nf,date2JSON(d.Fields[i].AsDateTime)]);
              end;
              
              ftTime       : begin
                                 result := result + format('"%s":"%s",',[nf,time2JSON(d.Fields[i].AsDateTime)]);
              end;
              
              ftDateTime   : begin
                                 result := result + format('"%s":"%s",',[nf,datetime2JSON(d.Fields[i].AsDateTime)]);
              end;
              
              ftLongWord, 
              ftShortint,
              ftSmallint, 
              ftInteger, 
              ftWord,
              ftAutoInc,
              ftLargeInt   : begin
                                result := result + format('"%s":%d,',[nf,datetime2JSON(d.Fields[i].AsLargeInt)]);
             
              end;

              ftFloat, 
              ftCurrency, 
              ftBCD        : begin
                                result := result + format('"%s":%g,',[nf,datetime2JSON(d.Fields[i].AsFloat)],x);
              end;

              ftBoolean    : begin
                                result := result + format('"%s":"%s",',[nf,ifthen(d.Fields[i].AsBoolean,'true','false')]);
              
              end;

              else           begin
                                 try
                                    result := result + format('"%s":"%s",',[nf,d.Fields[i].AsString]);
                                 except
                                    on e : exception do begin
                                       result := result + format('"%s":"%s",',[nf,e.Message]);
                                       ErJSON := true;
                                    end;
                                 end;
              end;
              
         end;
         
       end;

       result := LeftStr(result,length(result)-1); // quito la coma final
       result := result + '},';
       
       if soloactual then break;
       d.Next;
     end; 

     result := LeftStr(result,length(result)-1); // quito la coma final
     if esArray then result := '['+result+']';
     

     
   finally
     if not soloactual then d.GotoBookmark(BM);
     d.EnableControls;
   end;

end;

function datetime2JSON( const dt : TDateTime) : string;
var
   y,m,d,h,n,s,ms : word;
begin
   DecodeDateTime(dt,y,m,d,h,n,s,ms);
   result := format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.3dZ',[y,m,d,h,n,s,ms]);
end;

function date2JSON( const dt : TDate) : string;
var
   y,m,d,h,n,s,ms : word;
begin
   DecodeDateTime(dt,y,m,d,h,n,s,ms);
   result := format('%.4d-%.2d-%.2d',[y,m,d]);
end;

function time2JSON( const dt : TTime) : string;
var
   y,m,d,h,n,s,ms : word;
begin
   DecodeDateTime(dt,y,m,d,h,n,s,ms);
   result := format('%.2d:%.2d:%.2d.%.3dZ',[h,n,s,ms]);
end;

function JSON2datetime( const JSONdt : string) : TDateTime;
var
   y,m,d,h,n,s,ms : word;
begin
  y  := StrToInt(Copy(JSONdt,  1, 4));
  m  := StrToInt(Copy(JSONdt,  6, 2));
  d  := StrToInt(Copy(JSONdt,  9, 2));
  h  := StrToInt(Copy(JSONdt, 12, 2));
  n  := StrToInt(Copy(JSONdt, 15, 2));
  s  := StrToInt(Copy(JSONdt, 18, 2));
  ms := StrToInt(Copy(JSONdt, 21, 3));

  Result := EncodeDateTime(y,m,d,h,n,s,ms);
end; 

end.
