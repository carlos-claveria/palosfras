# palosfras
migracion de facturas en palos de la Frontera

`facturdg 327658` 

```
tercero			nnnn	
ejercicio		yyyy
numfac			99999999
tipofac			(1,2,5) lo que mas 1 con diferencia
fechae y fechar normalemnte el mismo valor

```

`facplazo` 655312

```
numplazo		siempre 1
```

Creación de la tabla de  cabecera:

```
DROP TABLE IF EXISTS CABECERA;
CREATE TABLE CABECERA LIKE TCABREC;
ALTER TABLE CABECERA DROP PRIMARY KEY; 
ALTER TABLE cabecera ADD PRIMARY KEY (serie,ano,numrec,fecha);
INSERT INTO CABECERA (SERIE,NUMREC,TASA,CPOBLA,ANO,PERIODO,BLOQUE,IDCO,CCONTRI,FECHA,PERSONA,NIF,DIRECCION,BONIFICACION,TOTAL,DOMICILIACION,ESTADO,MOMENTO,MOMENTOBLQ,AUDI,SUMA)
SELECT DISTINCT 
			substr(g.seriefac,1,1) as serie,
			g.numfac as numrec,
			g.SERIEFAC as tasa,
			1 as cpobla,
			substr(g.perfac,1,4) as ano,
			substr(g.perfac,5,2) as periodo,
			g.TIPOFAC as bloque,
			g.contrato as idco,
			g.tercero as ccontri,
			cast(g.FECHAR  as date) as fecha,
			'-' as persona,
			'-' as nif,
			'-' as direccion,
			0 as bonificacion,
			cast(z.importe as decimal(11,2)) as total,
			if(z.medpago = 2,'ND','ES8200000000000000000000') AS domiciliacion,
			if(z.estado = 10,'C','P') AS estado,
			'VOL' as momento,
			'N' as momentoblq,
			'migracion' as audi,
			g.ejercicio as SUMA
FROM facturdg g, facplazo Z
WHERE G.SERIEFAC = z.SERIEFAC
AND g.EJERCICIO = z.EJERCICIO
AND g.NUMFAC = z.NUMFAC
AND z.importe <> 0
ORDER BY G.EJERCICIO,G.NUMFAC*1,g.SERIEFAC;

```

