unit devloc;

interface

uses Classes;

procedure creadevloc;

const
devloc_file  = 'cnf_devloc.ini';
adevloc_num = 56;
adevloc : array[1..adevloc_num] of string = 
(
'[3082]',
'cxNavigator_DeleteRecordQuestion="�Borrar registro?"',
'cxNavigatorHint_Append="A�adir registro"',
'cxNavigatorHint_Cancel="Cancelar edici�n"',
'cxNavigatorHint_Delete="Borrar registro"',
'cxNavigatorHint_Edit="Editar registro"',
'cxNavigatorHint_Filter="Filtrar datos"',
'cxNavigatorHint_First="Primer registro"',
'cxNavigatorHint_GotoBookmark="Ir a marca"',
'cxNavigatorHint_Insert="Insertar registro"',
'cxNavigatorHint_Last="�ltimo registro"',
'cxNavigatorHint_Next="Siguiente registro"',
'xNavigatorHint_NextPage="Siguiente p�gina"',
'cxNavigatorHint_Post="Validar edici�n"',
'cxNavigatorHint_Prior="Registgro anterior"',
'cxNavigatorHint_PriorPage="P�gina anterior"',
'cxNavigatorHint_Refresh="Refrescar datos"',
'cxNavigatorHint_SaveBookmark="Guardar marca"',
'cxNavigatorInfoPanelDefaultDisplayMask="[RecordIndex] de [RecordCount]"',
'cxSBlobButtonCancel="&Cancelar"',
'cxSBlobButtonClose="&Cerrar"',
'cxSDateError="Fecha Incorrecta"',
'cxSDateFifth="quinto"',
'cxSDateFirst="primero"',
'cxSDateFourth="cuarto"',
'cxSDateFriday="viernes"',
'cxSDateMonday="lunes"',
'cxSDateNow="ahora"',
'cxSDatePopupClear="Borrar"',
'cxSDatePopupNow="Ahora"',
'cxSDatePopupToday="Hoy"',
'cxSDateSaturday="s�bado"',
'cxSDateSecond="segundo"',
'cxSDateSeventh="s�ptimo"',
'cxSDateSixth="sexto"',
'cxSDateSunday="domingo"',
'cxSDateThird="tercero"',
'cxSDateThursday="jueves"',
'cxSDateToday="hoy"',
'cxSDateTuesday="ma�ana"',
'cxSDateWednesday="mi�rcoles"',
'cxSDateYesterday="ayer"',
'cxSEditButtonCancel="Cancelar"',
'cxSEditCheckBoxChecked="Verdadero"',
'cxSEditCheckBoxUnchecked="Falso"',
'cxSEditDateConvertError="No puedo convertir la fecha"',
'cxSEditNumericValueConvertError="No puede convertir a n�mero."',
'cxSEditPopupCircularReferencingError="No se permiten referencias circulares."',
'cxSMenuItemCaptionCopy="&Copiar"',
'cxSMenuItemCaptionCut="Co&rtar"',
'cxSMenuItemCaptionDelete="&Eliminar"',
'cxSMenuItemCaptionLoad="&Cargar..."',
'cxSMenuItemCaptionPaste="&Pegar"',
'cxSMenuItemCaptionSave="G&uargar como ..."',
'cxSSpinEditInvalidNumericValue="valor num�rico incorrecto."',
'scxLockedStateText="Espere por favor..."'
);

implementation

uses smKernel;

procedure creadevloc;
var
  x : TextFile;
  i : integer;
begin
   assign(x, smKernel._Path+devloc_file);
   rewrite(x);
   
   for i := 1 to adevloc_num do WriteLN(x,adevloc[i]);

   closefile(x);
   
end;



end.
