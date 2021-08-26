unit idioma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,
  cxPropertiesStore, StdCtrls, cxClasses;

type
  Tlan = class(TForm)
    login: TcxPropertiesStore;
    Label1: TLabel;
 
    procedure lenguaChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure LanMainChangeLanguage(Sender: TObject);
    procedure UpdateStrings;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  FICMAP = 'IMGMAP.GIF';
  
var
  lan: Tlan;

// ----------------------------------------------------------------------------
	_ENTORNOSA: string      = 'Error al actualizar variables de entorno.'; (*  *) // TSI: Localized (Don't modify!)
	_ENTORNOES: string      = ''; (* Debe declarar la variable de entorno %s [escritura]. *) // TSI: Localized (Don't modify!)
	_ENTORNOLE: string      = ''; (* Debe declarar la variable de entorno %s [lectura]. *) // TSI: Localized (Don't modify!)
	_CONFIGERR: string      = 'Error abriendo la tabla de configuraci�n. Verifique usuario y contrase�a.'; 

	_NOLIC: string          = 'No consta licencia de este producto.';
	_NOBD: string           = 'Se produjo un error al abrir la BD: %s';
	_YAESTA: string         = 'ALBALOGIN ya se encuentra en ejecuci�n.';
	_BMSG: string           = '"conectado el " dd "de" mmm "de" yyyy "a las" hh:nn';
	_HAYCON: string         = 'Deber� cerrar los m�dulos activos (%d) antes de cambiar de usuario';
	_MODCON: string         = 'Se han conectado %d m�dulos de Albatros';
	_CLAVEOK: string        = 'Clave actualizada.';
	_NOCON: string          = 'Las claves introducidas no son coincidentes.'; 
	_NOESTA: string         = 'No se encuentra el usuario o clave incorrecta.';

	_NOCONF: string         = ''; (* No encuentro el fichero de configuraci�n en %s *) // TSI: Localized (Don't modify!)
	_MALCONF: string        = ''; (* Los datos del fichero de conexi�n son incorrectos: [%s] *) // TSI: Localized (Don't modify!)
	_EXMANAGER: string      = ''; (* Gestor de Excepciones [ *) // TSI: Localized (Don't modify!)
   
   _REVISEVAL: string      = 'Revise los valores.';
   _BUSCANDO: string       = 'Buscando...';
   _PROCESANDO: string     = 'Procesando...';
   _NOFIC: string          = 'No encuentrp el fichero %s';
   _NOENCONT_A: string     = '<no encontrada>';
   _NOENCONT_O: string     = '<no encontrado>';
   
   
   _PENDIENTE: string      = 'Pendiente';
   _ENCARGA:   string      = 'En Carga';
   _LEIDO:     string      = 'Leido';

   _CONSOLAUSR: string     = 'Operador de Consola';
   _ALBALOGIN: string      = 'Debe ejecutar primero ALBALOGIN.';
   _NOBASICO: string       = 'Este m�dulo no est� incluido en la versi�n b�sica. Consulte a su proveedor.';
   _TITLIS: string         = 'Titulo del Listado';
   _EMISION: string        = 'Emisi�n : ';
   _ACEPTAR: string        = 'Pulse [Aceptar] para continuar.';
   _REVISEVALOR: string    = 'Revise los valores introducidos.';
   _ESTIMA01: string       = 'En caso de estimaci�n: �Igualar lectura actual a lectura anterior?';
   _CANCAMBIOS: string     = '�Cancelar los cambios?';
   _CONSHISTO: string      = 'Accediendo al Hist�rico...';
   _ACTERROR: string       = 'Error al actualizar la tabla.';
   _CONSOLAOP: string      = 'Operador de Consola';
   _SUPTERMINAL: string    = 'Los terminales existentes superan los permitidos por la licencia.';
   _MAXTERMINAL: string    = 'El n�mero m�ximo de terminales permitidos en esta licencia es de %d.';
   _EXISTEEMISION: string  = 'Ya existe la emisi�n %d con %d lecturas. �Actualizar?';
   _ERRFECHA: string       = 'Error en el formato de fecha %s';

   _IMPORTAR: string       = 'importar';
   _EXPORTAR: string       = 'exportar';
   _DEBEEMIS: string       = 'Debe seleccionar la emisi�n a %s.';
   _FALTAEMIS: string      = 'Debe tener seleccionada una emisi�n';
   _NOESEMIS: string       = 'No encuentro la emisi�n %s.';
   
   _LECPROC: string        = 'Procesadas %d lecturas.';
   _DETALTAS: string       = 'Se han detectado %d lecturas sin optimizar, debe de acceder al optimizador de rutas';
   _SELFIC: string         = 'Debe seleccionar un fichero.';
   _NOAPL: string          = 'No se encuentra la aplicaci�n %s en %s';
   _BORMARCAS: string      = '�Atenci�n!, este proceso elimina las marcas que indican que estas lecturas est�n cargadas en el TPL %d. �Desea continuar?';
   _LECENHIS: string       = 'Existen %d lecturas en el historico, proceso cancelado.';
   _LECNOHIS: string       = 'No existen lecturas de la emision %d en el hist�rico. �Continuar?';
   _LECPEND: string        = 'Existen %d lecturas pendientes de leer, proceso cancelado.';
   _HISINS: string         = 'Se han insertado %d lecturas en el historico. �Eliminar la emisi�n?';
   _PELIEMI : string       = '�Eliminar la emisi�n %s?';
   _EMISELIM: string       = 'Emisi�n eliminada';
   
   _RUTNOACT: string       = 'No puede actualizar existiendo elementos en el �rea de trabajo';
   _RUTDESCARTA: string    = 'Descartar significa deshacer todos los cambios hechos hasta el momento. �Es lo que desea?';
   _RUTUNICA: string       = 'El segmento de carga debe ser una �nica ruta.';
   _RUTEMISLEIDA: string   = 'Debe seleccionar una emisi�n ya le�da.';

   _REFDEL: string         = 'Existen referencias de los valores borrados en otras tablas, se cancela el proceso';
   _NOPARTE: string        = 'No existe el parte de trabajo.';
   _NOMAP: string          = 'No hay localizaci�n para esta direcci�n.';
   _REINICIE: string       = 'Para que los cambios efectuados tengan efecto debe de cerrar la aplicaci�n y volver a abrirla.';
   _FALTACONTR: string     = 'No est�n instalados los controladores para esta acci�n.';
   _NOEXPORT: string       = 'Las lecturas integradas con SILECO / ALBATROS no precisan exportaci�n.';
   _REINI   : string       = 'Debe reiniciar la aplicaci�n';
   _GRABAR  : string       = '�Grabar cambios?';
   
   

    
// ----------------------------------------------------------------------------
  

implementation

{$R *.dfm}

procedure Tlan.lenguaChange(Sender: TObject);
begin
   Close;
end;

procedure Tlan.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then Close;
end;

procedure Tlan.FormCreate(Sender: TObject);
begin
  UpdateStrings;
end;

procedure Tlan.LanMainChangeLanguage(Sender: TObject);
begin
  UpdateStrings;
end;

procedure Tlan.UpdateStrings;
begin
{
  _EXMANAGER := LanMain.GetTextOrDefault('str_EXMANAGER' (* 'Gestor de Excepciones [' *) );
  _MALCONF := LanMain.GetTextOrDefault('str_MALCONF' (* 'Los datos del fichero de conexi�n son incorrectos: [%s]' *) );
  _NOCONF := LanMain.GetTextOrDefault('str_NOCONF' (* 'No encuentro el fichero de configuraci�n en %s' *) );
  _NOESTA := LanMain.GetTextOrDefault('str_NOESTA' (* 'No se encuetra el usuario o clave incorrecta.' *) );
  _NOCON := LanMain.GetTextOrDefault('str_NOCON' (* 'Las claves introducidas no son coincidentes.' *) );
  _CLAVEOK := LanMain.GetTextOrDefault('str_CLAVEOK' (* 'Clave actualizada.' *) );
  _MODCON := LanMain.GetTextOrDefault('str_MODCON' (* 'Se han conectado %d m�dulos de Albatros' *) );
  _HAYCON := LanMain.GetTextOrDefault('str_HAYCON' (* 'Deber� cerrar los m�dulos activos (%d) antes de cambiar de usuario' *) );
  _BMSG := LanMain.GetTextOrDefault('str_BMSG' (* ' "conectado el " dd "de" mmm "de" yyyy "a las" hh:nn' *) );
  _YAESTA := LanMain.GetTextOrDefault('str_YAESTA' (* 'ALBALOGIN ya se encuentra en ejecuci�n.' *) );
  _NOBD := LanMain.GetTextOrDefault('str_NOBD' (* 'Se produjo un error al abrir la BD: %s' *) );
  _NOLIC := LanMain.GetTextOrDefault('str_NOLIC' (* 'No consta licencia de este producto.' *) );
  _CONFIGERR := LanMain.GetTextOrDefault('str_CONFIGERR' (* 'Error abriendo la tabla de configuraci�n. Verifique usuario y contrase�a.' *) );
  _ENTORNOLE := LanMain.GetTextOrDefault('str_ENTORNOLE' (* 'Debe declarar la variable de entorno %s [lectura].' *) );
  _ENTORNOES := LanMain.GetTextOrDefault('str_ENTORNOES' (* 'Debe declarar la variable de entorno %s [escritura].' *) );
  _ENTORNOSA := LanMain.GetTextOrDefault('str_ENTORNOSA' (* 'Error al actualizar variables de entorno.' *) );
}
end;

procedure Tlan.BitBtn1Click(Sender: TObject);
begin
   //LanMain.EditProperty(stCaptions);
end;

end.


