unit uDM;

interface

uses
  SysUtils, Classes, uGDM, DB, DBClient, TConnect, MemDS, DBAccess, Uni,
  Datasnap.Provider;

type
  TDM = class(TDataModule)
    LC: TLocalConnection;
    q: TUniQuery;
    i: TUniSQL;
    xAbonados: TUniQuery;
    xOT: TUniQuery;
    qCabecera: TUniQuery;
    qCabeceraIDREC: TLargeintField;
    qCabeceraSERIE: TStringField;
    qCabeceraNUMREC: TLargeintField;
    qCabeceraTASA: TStringField;
    qCabeceraCPOBLA: TLargeintField;
    qCabeceraANO: TLargeintField;
    qCabeceraPERIODO: TLargeintField;
    qCabeceraBLOQUE: TLargeintField;
    qCabeceraIDCO: TLargeintField;
    qCabeceraCCONTRI: TStringField;
    qCabeceraFECHA: TDateTimeField;
    qCabeceraPERSONA: TStringField;
    qCabeceraNIF: TStringField;
    qCabeceraDIRECCION: TStringField;
    qCabeceraPOBLACION: TStringField;
    qCabeceraPAIS: TStringField;
    qCabeceraOT: TStringField;
    qCabeceraBONIFICACION: TFloatField;
    qCabeceraTOTAL: TFloatField;
    qCabeceraDOMICILIACION: TStringField;
    qCabeceraTITULARCCC: TStringField;
    qCabeceraESTADO: TStringField;
    qCabeceraSUBESTADO: TStringField;
    qCabeceraIDREMESA: TStringField;
    qCabeceraMOMENTO: TStringField;
    qCabeceraMOMENTOBLQ: TStringField;
    qCabeceraFPAGO: TDateTimeField;
    qCabeceraEFECHA: TDateTimeField;
    qCabeceraETASAS: TFloatField;
    qCabeceraEFNOTIF: TDateTimeField;
    qCabeceraGFECHA: TDateTimeField;
    qCabeceraGTASAS: TFloatField;
    qCabeceraGFNOTIF: TDateTimeField;
    qCabeceraIFECHA: TDateTimeField;
    qCabeceraITASAS: TFloatField;
    qCabeceraIFNOTIF: TDateTimeField;
    qCabeceraABONO: TLargeintField;
    qCabeceraRECTIF: TLargeintField;
    qCabeceraAUDI: TStringField;
    qCabeceraGASTOS: TFloatField;
    qCabeceraIDPAGO: TLargeintField;
    qCabeceraTPCRECARGO: TFloatField;
    qCabeceraNUEVOMOM: TStringField;
    qCabeceraFNUEVOMOM: TDateTimeField;
    qCabeceraCFECHA: TDateTimeField;
    qCabeceraCTASAS: TLargeintField;
    qCabeceraPROVIDENCIA: TStringField;
    qCabeceraFPROVIDENCIA: TDateTimeField;
    qCabeceraIDEXP: TLargeintField;
    qCabeceraREMESA63: TStringField;
    qCabeceraPOLIZA: TStringField;
    qCabeceraCONTADOR: TStringField;
    qCabeceraLECANTE: TLargeintField;
    qCabeceraFLECANTE: TDateTimeField;
    qCabeceraLECACTU: TLargeintField;
    qCabeceraFLECACTU: TDateTimeField;
    qCabeceraM3: TLargeintField;
    qCabeceraINCACTU: TLargeintField;
    qCabeceraCBONIF: TLargeintField;
    qCabeceraDOTACIONES: TLargeintField;
    qCabeceraSINCANON: TFloatField;
    qCabeceraCANONLIQ: TStringField;
    qCabeceraNEWTOTAL: TFloatField;
    qCabeceraCANON: TFloatField;
    qCabeceraAPAGAR: TFloatField;
    qCabeceraSUMA: TLargeintField;
    qCabeceraREFEXTERNA: TStringField;
    qCabeceraIDPP: TLargeintField;
    xOTIDCO: TLargeintField;
    xOTOT: TStringField;
    pAbonados: TDataSetProvider;
    pOT: TDataSetProvider;
    qAbonados: TClientDataSet;
    qOT: TClientDataSet;
    qAbonadosCCONTRI: TStringField;
    qAbonadosCPOBLA: TLargeintField;
    qAbonadosCCALLE: TLargeintField;
    qAbonadosTIPO: TStringField;
    qAbonadosAPELLIDOS: TStringField;
    qAbonadosNOMBRE: TStringField;
    qAbonadosNIF: TStringField;
    qAbonadosSIG: TStringField;
    qAbonadosCALLE: TStringField;
    qAbonadosADIC: TStringField;
    qAbonadosNUM: TStringField;
    qAbonadosBIS: TStringField;
    qAbonadosESCALERA: TStringField;
    qAbonadosPISO: TStringField;
    qAbonadosPUERTA: TStringField;
    qAbonadosNUMLOCAL: TStringField;
    qAbonadosCPOSTAL: TStringField;
    qAbonadosPOBLACION: TStringField;
    qAbonadosPROVINCIA: TStringField;
    qAbonadosCODPAIS: TStringField;
    qAbonadosREPRES: TStringField;
    qAbonadosRNIF: TStringField;
    qAbonadosDIRREPRES: TStringField;
    qAbonadosPOBREPRES: TStringField;
    qAbonadosTELEFONO1: TStringField;
    qAbonadosTELEFONO2: TStringField;
    qAbonadosEMAIL: TStringField;
    qAbonadosFALTA: TDateTimeField;
    qAbonadosFACTURAR: TStringField;
    qAbonadosIDEX01: TStringField;
    qAbonadosIDEX02: TStringField;
    qAbonadosFAX: TStringField;
    qAbonadosTEXTO: TMemoField;
    qAbonadosINE: TStringField;
    qAbonadosCONTABLE: TStringField;
    qAbonadosCONTAPRO: TStringField;
    qAbonadosSALDO: TFloatField;
    qAbonadosxxpersona: TIntegerField;
    qAbonadosxxpercontacto: TIntegerField;
    qAbonadosxxdomicilio: TIntegerField;
    qOTIDCO: TLargeintField;
    qOTOT: TStringField;
  private
    { Private declarations }
  public
            
  end;

var
    DM : TDM ;

implementation


{$R *.dfm}

end.
