unit silKernel;

interface
uses db;

type
   /// Para la estadística de lecturas
   TListaHorasDia  = array[1..24] of LongInt;
   TListaDiasSem   = array[1..7]  of LongInt;
   TListaDiasMes   = array[1..31] of LongInt;
   
  
   /// Tipos de lector soportados 
   TTipoLector = (esPDA,esTABLET);

   /// Tipos de contadores incluidos en la selección: Sólo vía radio, sólo lectura 
   /// manual o todos.
   /// []  : indica que no se realicen consultas sobre posibles contadores radio
   /// aumentando así el rendimiento. Este valor se activa mediandte la variable
   /// de entorno 'ContRadio' = 'N'
   TTipoCarga  = set of (crRadio,crManual,crHistorico);



  TEmis    = record
             CPOBLA   : integer;
             ANO      : integer;
             PERIODO  : integer;
             BLOQUE   : integer;
             DESC     : string;
             class operator Equal(a, b: TEmis): Boolean; 
   end;

   TEmisHelper = record helper for TEmis
      function  ToString    : string;
      function  ToFString   : string;
      
      function  ToTable(t : TDataSet) : Boolean;
      function  FromTable(t : TDataSet) : Boolean;
      
      function  IsEmis      : Boolean;
      function  Completa(st : string; CPOBLA : integer = 1) : string;
      
      function  IsNull      : Boolean;
      procedure SetNull;
      procedure Clon(x : TEmis);
      
      
   end;
   
   // ------------------------------------------------------------------------
   
   TTPL     = record
            ID       : Integer;
            MODELO   : string;
            PATH     : string;
   end;

   TTPLHelper = record helper for TTPL
      function  IsNull      : Boolean;
      procedure SetNull;
   end;
   
   // ------------------------------------------------------------------------
function Direc(q : TDataSet)  : string;  
function Nombre(q : TDataSet) : string;
function PonIncidencia(anterior,actual : integer) : integer;
function _m3(anterior,actual : integer) : integer;



/// Resta los valores de una lista ordenada de enteros teniendo en cuenta
/// que pueden haber valores ignorables lectura (-1)
procedure RestaLista( var x : array of integer);

                    

implementation
uses math,sysutils,classes,dateUtils,smKernel;

// Example implementation of Add
class operator TEmis.Equal(a, b: TEmis): boolean;
begin
   Result := True;

   if (a.IsNull) and (b.IsNull) then Exit;

   result := (a.CPOBLA = b.CPOBLA)     and 
             (a.ANO = b.ANO)           and 
             (a.PERIODO = b.PERIODO)   and
             (a.BLOQUE = b.BLOQUE);
end;

function TTPLHelper.IsNull : boolean;
begin
   Result := (Self.ID = -1);
end;

procedure TTPLHelper.SetNull;
begin
   Self.ID := -1;
end;

procedure TEmisHelper.Clon(x : TEmis);
begin
   self.CPOBLA  := x.CPOBLA;
   self.ANO     := x.ANO;
   self.PERIODO := x.PERIODO;
   self.BLOQUE  := x.BLOQUE;
   Self.DESC    := x.DESC;
end;

procedure TEmisHelper.SetNull;
begin
  Self.CPOBLA := -1;
end;

function TEmisHelper.ToFString : string;
begin
   Result := '';
   try
      if Self.CPOBLA > 999 then 
         Result := smkernel.strzero(Self.CPOBLA,5)
      else
         Result := smkernel.strzero(Self.CPOBLA,3);

      Result := Result + '.' + IntToStr(Self.ANO);
      Result := Result + '.' + smKernel.strzero(Self.PERIODO,2);
      Result := Result + '.' + smKernel.strzero(Self.BLOQUE,3);

   except
     Result := '';
   end;
end;

function TEmisHelper.ToString : string;
begin
   Result := '';
   try
      Result := IntToStr(Self.CPOBLA);
      Result := Result + '.' + IntToStr(Self.ANO);
      Result := Result + '.' + IntToStr(Self.PERIODO);
      Result := Result + '.' + IntToStr(Self.BLOQUE);
   except
     Result := '';
   end;
end;

function TEmisHelper.IsEmis : boolean;
begin
   try
      result := (Self.CPOBLA > 0) and (Self.ANO > 1900) and (Self.ANO < 2050) and
                (Self.PERIODO > 0) and (Self.PERIODO < 99) and (Self.BLOQUE >= 0) and  
                (Self.BLOQUE <= 999);
   except
      result := False;
   end;


end;

function TEmisHelper.Completa(st: string; CPOBLA: Integer = 1) : string;
var
   _elementos : TStringList;
begin
   result := '';

   st := Trim(st);

   if (st = '') or (not smKernel.stInSet(st,['0'..'9','.'])) then begin
      Self.SetNull;
      Exit;   
   end;

   _elementos := TStringList.Create;
   try
      _elementos.Clear;
      aElem(_elementos,st,'.');
      case _elementos.Count of
        // SOLO EL PERIODO  o SOLO EL AÑO
        1: begin 
              if (StrToInt(_elementos[0]) > 999) then begin
                  Self.CPOBLA  := CPOBLA;
                  Self.ANO     := StrToInt(_elementos[0]);
                  Self.PERIODO := MonthOf(now);
                  Self.BLOQUE  := 0;
              end 
              else begin
                  Self.CPOBLA  := CPOBLA;
                  Self.ANO     := YearOf(now);
                  Self.PERIODO := StrToInt(_elementos[0]);
                  Self.BLOQUE  := 0;
              end;
           end;
        // AÑO Y PERIODO
        2: begin
              Self.CPOBLA  := CPOBLA;
              Self.ANO     := StrToInt(_elementos[0]);
              Self.PERIODO := StrToInt(_elementos[1]);
              Self.BLOQUE  := 0;
           end;
        // AÑO, PERIODO Y BLOQUE     
        3: begin
              Self.CPOBLA  := CPOBLA;
              Self.ANO     := StrToInt(_elementos[0]);
              Self.PERIODO := StrToInt(_elementos[1]);
              Self.BLOQUE  := StrToInt(_elementos[2]);
           end;
        // COMPLETO
        4: begin
              Self.CPOBLA  := StrToInt(_elementos[0]);
              Self.ANO     := StrToInt(_elementos[1]);
              Self.PERIODO := StrToInt(_elementos[2]);
              Self.BLOQUE  := StrToInt(_elementos[3]);
           end;
      end;  

      Result := Self.ToString; 
  
   finally
     _elementos.Free;
   end;
   
end;

function TEmisHelper.IsNull      : Boolean;
begin
   Result := (Self.CPOBLA = -1);
end;

function TEmisHelper.ToTable(t: TDataSet) : Boolean;
var
   bkState   : TDataSetState;
   
begin
  result := False;
  try
      bkState := t.State;
      
      if bkState in [dsInactive] then begin
         Exit;
      end;
      
      if bkState in [dsBrowse] then t.Edit;
      t.FieldByName('CPOBLA').AsInteger  := Self.CPOBLA;
      t.FieldByName('ANO').AsInteger     := Self.ANO;
      t.FieldByName('PERIODO').AsInteger := Self.PERIODO;
      t.FieldByName('BLOQUE').AsInteger  := Self.BLOQUE;


      // Puede fallar por que falten datos obligatorios
      try
         if bkState in [dsBrowse] then t.Post;
      except

      end;

      Result := True;
  except
      if t.State in [dsEdit,dsInsert] then t.Cancel;
      Exit;
  end;
end;

function TEmisHelper.FromTable(t: TDataSet) : Boolean;
begin
   Result := False;
   Self.CPOBLA := -1;


   if (t.FindField('CPOBLA') = nil)  then Exit;
   
   Self.CPOBLA    := t.FieldByName('CPOBLA').AsInteger;
   Self.ANO       := t.FieldByName('ANO').AsInteger;
   Self.PERIODO   := t.FieldByName('PERIODO').AsInteger;
   Self.BLOQUE    := t.FieldByName('BLOQUE').AsInteger;

end;

function _m3(anterior,actual : integer) : integer;
begin
     

     if anterior > actual then
         if anterior < 10000 then     // CONTADOR HABITUAL DE 4 DIGITOS
            actual   := actual+10000
         else
            actual   := actual + trunc(power(10,length(inttostr(anterior))));

     result := actual - anterior;
     
end;  

function PonIncidencia(anterior,actual : integer) : integer;
begin
   if anterior < actual then 
      result := 0
   else   
   if anterior > actual then
      result := 1
   else   
      result := 2;
end;

function Direc(q : TDataSet) : string;  
var
   sig,calle, numero,bis,escalera, piso, puerta,local : string; 
begin
     try
      sig := Trim(q.fieldbyname('SIG').AsString);
     except
      sig := '';
     end;


     try
      calle := Trim(q.fieldbyname('CALLE').AsString);
     except
      calle := '';
     end;

     try
      numero := Trim(q.fieldbyname('NUMERO').AsString);
     except
         try
            numero := Trim(q.fieldbyname('NUM').AsString);
         except
            numero := '';
         end;   
     end;
     
     try
      bis := Trim(q.fieldbyname('BIS').AsString);
     except
      bis := '';
     end;
     
     try
      escalera := Trim(q.fieldbyname('ESCALERA').AsString);
     except
      escalera := '';
     end;
     
     try
      piso := Trim(q.fieldbyname('PISO').AsString);
     except
      piso := '';
     end;

     try
       puerta := Trim(q.fieldbyname('PUERTA').AsString);
     except
      puerta := '';
     end;

     try
      local := Trim(q.fieldbyname('LOCAL').AsString);
     except
      local := '';
     end;
      
     result := iif(sig <> '',sig+' ','')            +
               calle                                +
               iif(numero    <> '',', '+numero,'')  + 
               iif(bis       <> '',' '+bis,'')      +
               iif(escalera  <> '',' '+escalera,'') +
               iif(piso      <> '',' '+ piso ,'')   +
               iif(puerta    <> '',' '+puerta,'')   +
               iif(local     <> '',' '+local,'');
end; 
// ----------------------------------------------------------------------------
function Nombre(q : TDataSet) : string;
var
   ape,nom : string;
begin
      ape := Trim(q.FieldByName('APELLIDOS').AsString);
      nom := Trim(q.FieldByName('NOMBRE').AsString);

   if (ape  = '') and  (nom <> '') then begin
      result := nom;
   end
   else begin
      result := ape;
  
      if nom <> '' then 
         result := result + ', ' + nom;
         
   end;
end;
// ----------------------------------------------------------------------------
procedure restaLista( var x : array of integer);
var
   i,
   max,min : integer;
begin
   i := High(x);

   if (SumInt(x) = -1*i) then Exit;
   
   max := -1;
   min := -1;
   
   while i >= 0 do begin
      min := -1;
      while x[i] = -1 do Dec(i);
      if i > -1 then begin
        if max = -1 then begin
           max := i;
        end
        else begin
           x[max] := x[max]- x[i];
           max := i;
           min := x[i];
        end;
        Dec(i);
      end;
   end;

   if min = -1 then x[max] := 0;

end;



end.     
