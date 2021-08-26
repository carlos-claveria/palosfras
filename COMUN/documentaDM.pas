{*
  Guarda en la tabla DOCUMENT.DB una relación de todas las llamadas SQL generadas por los componentes UNIDAC.
  El campo descripción puede ser modificado mediante la utilidad DOCDM.EXE que se encuentra dentro de la carpeta SMTOOLS. 
  También se puede obtener un informe con los datos de la tabla.
  
  @author Carlos Clavería
  @version 1.0 OCT-2011
}  
unit documentaDM;

interface
uses classes,VirtualTable,DB,SysUtils,Uni,Variants;

procedure Documenta(DM : TDataModule);

const
   /// Nombre del fichero generado por Documenta.
   DOCFILE = 'DOCUMENT.DB';

implementation
{*
   Realiza la documentación del DataModule.
   Desde cualcuier parte de la aplicación que tenga declarada la unit del datamodule : 
   DoocumentaDM.Documenta(DataMod);
   El fichero será generado en la carpeta del ejecutable.    
      
   @param DM Nombre del DataModule
}     
procedure Documenta(DM : TDataModule);
var
   i : integer;
   t : TVirtualTable;
begin
   try
      t := TVirtualTable.Create(nil);
      t.FieldDefs.Add('DATAMODULE',ftString,20,TRUE);
      t.FieldDefs.Add('NOMBRE',ftString,20,TRUE);
      t.FieldDefs.Add('CLASE',ftString,20,TRUE);
      t.FieldDefs.Add('SQLTEXT',ftMemo);
      t.FieldDefs.Add('DESCRIPCION',ftMemo);
      t.IndexFieldNames := 'DATAMODULE;NOMBRE';
      if fileexists(DOCFILE) then t.LoadFromFile(DOCFILE);
      t.Open;
      t.Filter := format('DATAMODULE = ''%s''',[DM.Name]);
      t.Filtered := TRUE;
      //  QUITO DE LA TABLA LOS ELIMINADOS
      if t.RecordCount > 0 then begin
         t.First;
         while not t.eof do begin
            if (dm.FindComponent(t.FieldByName('CLASE').AsString) = nil) then t.Delete;
            t.Next;
         end;
      end;
      
      for i := 0 to DM.ComponentCount-1 do
         if DM.Components[i] is TUniQuery then begin
            if t.Locate('DATAMODULE;NOMBRE',VarArrayOf([DM.Name,TUniQuery(DM.Components[i]).Name]),[]) then begin
               t.Edit;
               t.FieldByName('SQLTEXT').AsString := TUniQuery(DM.Components[i]).SQL.Text;
            end
            else begin
               t.Insert;
               t.FieldByName('DATAMODULE').AsString := DM.Name;
               t.FieldByName('NOMBRE').AsString     := TUniQuery(DM.Components[i]).Name;
               t.FieldByName('CLASE').AsString      := 'TUniQuery';
               t.FieldByName('SQLTEXT').AsString := TUniQuery(DM.Components[i]).SQL.Text;
            end;
            t.Post;
         end
         else
         if DM.Components[i] is TUniSQL then begin
            if t.Locate('DATAMODULE;NOMBRE',VarArrayOf([DM.Name,TUniSQL(DM.Components[i]).Name]),[]) then begin
               t.Edit;
               t.FieldByName('SQLTEXT').AsString := TUniSQL(DM.Components[i]).SQL.Text;
            end
            else begin
               t.Insert;
               t.FieldByName('DATAMODULE').AsString := DM.Name;
               t.FieldByName('NOMBRE').AsString     := TUniSQL(DM.Components[i]).Name;
               t.FieldByName('CLASE').AsString      := 'TUniSQL';
               t.FieldByName('SQLTEXT').AsString := TUniSQL(DM.Components[i]).SQL.Text;
            end;
            t.Post;
         end
         else
         if DM.Components[i] is TUniTable then begin
            if t.Locate('DATAMODULE;NOMBRE',VarArrayOf([DM.Name,TUniTable(DM.Components[i]).Name]),[]) then begin
               t.Edit;
               t.FieldByName('SQLTEXT').AsString := format('SELECT * FROM %s',[TUniTable(DM.Components[i]).TableName]);
            end
            else begin
               t.Insert;
               t.FieldByName('DATAMODULE').AsString := DM.Name;
               t.FieldByName('NOMBRE').AsString     := TUniTable(DM.Components[i]).Name;
               t.FieldByName('CLASE').AsString      := 'TUniTable';
               t.FieldByName('SQLTEXT').AsString := format('SELECT * FROM %s',[TUniTable(DM.Components[i]).TableName]);
            end;
            t.Post;
         end
   finally
        t.Close;
        t.SaveToFile(DOCFILE);
   end;

end;

end.
