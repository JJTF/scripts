clear all

global ruta0 "C:\Users\dechdi_temp50\OneDrive - Ministerio de la Producción\JOSUE\sitradoc\base_bruta\20.05.25"
global ruta1 "C:\Users\dechdi_temp50\OneDrive - Ministerio de la Producción\JOSUE\sitradoc\base_limpia\20.05.25"
global ruta2 "C:\Users\dechdi_temp50\OneDrive - Ministerio de la Producción\JOSUE\sitradoc\base_final"

import excel using "$ruta0\REPORTE_DOCUMENTOS_PENDIENTES_DPCHDI.xls", firstrow clear
                           
* Crear una nueva variable que contenga el número de celdas no vacías
gen num_filled_cells = .
* Iterar sobre las observaciones y contar las celdas no vacías
qui forval i = 1/`=_N' {
    local count = 0
    foreach var of varlist A-R {
        if (!missing(`var'[`i'])) local count = `count' + 1
    }
    replace num_filled_cells = `count' in `i'
}
* Encontrar el máximo número de celdas no vacías
qui sum num_filled_cells
//local max_filled_cells = r(max)
* Eliminar las filas que no tienen el máximo número de celdas no vacías
//drop if num_filled_cells < `max_filled_cells'
drop if num_filled_cells <= 2 
drop num_filled_cells
foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}
tempfile REPORTE_DPCHDI
save `REPORTE_DPCHDI',replace
* usar la primera fila
export excel "`REPORTE_DPCHDI'.xlsx", replace
import excel using "`REPORTE_DPCHDI'.xlsx", firstrow clear

keep NROREGISTRO CLASEDOCUMENTO RAZONSOCIAL NROPROCTUPA ASUNTO INGRESOOFICINA DEPENDENCIA INGRESOTRABAJADOR TRABAJADORESPENDIENTES
duplicates drop NROREGISTRO, force
gen seq = string(_n)
replace NROREGISTRO=seq if NROREGISTRO==""
drop seq
tempfile reporte_dpchdi
save `reporte_dpchdi',replace
import excel using "$ruta0\SEG_EXPEDIENTES_DPCHDI.xls", firstrow clear
* Crear una nueva variable que contenga el número de celdas no vacías
gen num_filled_cells = .
* Iterar sobre las observaciones y contar las celdas no vacías
qui forval i = 1/`=_N' {
    local count = 0
    foreach var of varlist A-AG {
        if (!missing(`var'[`i'])) local count = `count' + 1
    }
    replace num_filled_cells = `count' in `i'
}
* Encontrar el máximo número de celdas no vacías
qui sum num_filled_cells
//local max_filled_cells = r(max)
* Eliminar las filas que no tienen el máximo número de celdas no vacías
//drop if num_filled_cells < `max_filled_cells'
drop if num_filled_cells <= 2 
drop num_filled_cells
foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}
tempfile SEG_DPCHDI
save `SEG_DPCHDI',replace
* usar la primera fila
export excel "`SEG_DPCHDI'.xlsx", replace
import excel using "`SEG_DPCHDI'.xlsx", firstrow clear

keep NROREGISTRO RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN FECHAINGRESOOFICINA DEPENDENCIA TRABAJADOR ESTADO UBICACION FECHAFINALIZACIÓN DIASFUERADEPLAZO INFORMACIÓNSOLICITADA CANAL DÍASTRANSCURRIDOS DÍASPORVENCER
duplicates drop NROREGISTRO, force
gen seq = string(_n)
replace NROREGISTRO=seq if NROREGISTRO==""
drop seq
tempfile expediente_dpchdi
save `expediente_dpchdi',replace
use `expediente_dpchdi'
merge 1:1 NROREGISTRO using `reporte_dpchdi', force 
replace UBICACION=TRABAJADORESPENDIENTES if UBICACION==""
replace RAZÓNSOCIAL="DOCUMENTO INTERNO" if RAZÓNSOCIAL==""
keep NROREGISTRO RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN FECHAINGRESOOFICINA ESTADO FECHAFINALIZACIÓN DIASFUERADEPLAZO CANAL DÍASTRANSCURRIDOS DÍASPORVENCER CLASEDOCUMENTO INGRESOTRABAJADOR UBICACION DEPENDENCIA
replace UBICACION = lower(UBICACION)
replace UBICACION="Zoraida Quispe" if strmatch(UBICACION,"*quispe ore*")
replace UBICACION="Secretaria DPCHDI" if strmatch(UBICACION,"*baquijano montes*")
replace UBICACION="Alan Garcia" if strmatch(UBICACION,"*garcia aragon*")
replace UBICACION="Director DPCHDI" if strmatch(UBICACION,"*director*")
replace UBICACION="Cinthia Rojo" if strmatch(UBICACION,"*rojo lopez*")
replace UBICACION="Sara Ruiz" if strmatch(UBICACION,"*ruiz farfan*")
replace UBICACION="Elizabeth Lucano" if strmatch(UBICACION,"*lucano urioste*")
replace UBICACION="Ricardo Paredes" if strmatch(UBICACION,"*paredes valverde*")
replace UBICACION="Ruben Canales" if strmatch(UBICACION,"*canales salvatierra*")
replace UBICACION="Jennifer Chacon" if strmatch(UBICACION,"*chacon tapia*")
replace UBICACION="Dayana Salas" if strmatch(UBICACION,"*salas manrique*")
replace DEPENDENCIA="DPCHDI"
gen CONDICION="ATENDIDO" if FECHAFINALIZACIÓN!=""
replace CONDICION="PENDIENTE" if FECHAFINALIZACIÓN==""
gen TUPA_="SI" if NROPROCTUPA!=" "
replace TUPA_="NO" if NROPROCTUPA==" "
gen ESTADO_OLD="SIN PLAZO" if TUPA_=="NO"
replace ESTADO_OLD="VENCIDO" if TUPA_=="SI" & ESTADO=="VENCIDO"
replace ESTADO_OLD="EN PROCESO" if TUPA_=="SI" & strmatch(ESTADO,"*PENDIENTE*")
tostring NROPROCTUPA,replace
save dpchdi,replace
export excel using "$ruta1\dpchdi_20_05.xlsx",first(variables) replace

**-------------------------------------------------------------------------------------------------------
**-------------------------------------------------------------------------------------------------------
clear all
import excel using "$ruta0\REPORTE_DOCUMENTOS_PENDIENTES_DGPCHDI.xls", firstrow clear
* Crear una nueva variable que contenga el número de celdas no vacías
gen num_filled_cells = .
* Iterar sobre las observaciones y contar las celdas no vacías
qui forval i = 1/`=_N' {
    local count = 0
    foreach var of varlist A-R {
        if (!missing(`var'[`i'])) local count = `count' + 1
    }
    replace num_filled_cells = `count' in `i'
}
* Encontrar el máximo número de celdas no vacías
qui sum num_filled_cells
//local max_filled_cells = r(max)
* Eliminar las filas que no tienen el máximo número de celdas no vacías
//drop if num_filled_cells < `max_filled_cells'
drop if num_filled_cells <= 2 
drop num_filled_cells
foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}
tempfile REPORTE_DGPCHDI
save `REPORTE_DGPCHDI',replace
* usar la primera fila
export excel "`REPORTE_DGPCHDI'.xlsx", replace
import excel using "`REPORTE_DGPCHDI'.xlsx", firstrow clear

keep NROREGISTRO CLASEDOCUMENTO RAZONSOCIAL NROPROCTUPA ASUNTO INGRESOOFICINA DEPENDENCIA INGRESOTRABAJADOR TRABAJADORESPENDIENTES
duplicates drop NROREGISTRO, force
gen seq = string(_n)
replace NROREGISTRO=seq if NROREGISTRO==""
drop seq
tempfile reporte_dgpchdi
save `reporte_dgpchdi',replace

*-------------------------------------------------------------
import excel using "$ruta0\SEG_EXPEDIENTES_DGPCHDI.xls", firstrow clear

* Crear una nueva variable que contenga el número de celdas no vacías
gen num_filled_cells = .
* Iterar sobre las observaciones y contar las celdas no vacías
qui forval i = 1/`=_N' {
    local count = 0
    foreach var of varlist A-AG {
        if (!missing(`var'[`i'])) local count = `count' + 1
    }
    replace num_filled_cells = `count' in `i'
}
* Encontrar el máximo número de celdas no vacías
qui sum num_filled_cells
local max_filled_cells = r(max)
* Eliminar las filas que no tienen el máximo número de celdas no vacías
//drop if num_filled_cells < `max_filled_cells'
drop if num_filled_cells <= 2 
drop num_filled_cells
foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}
tempfile SEG_DGPCHDI
save `SEG_DGPCHDI',replace
* usar la primera fila
export excel "`SEG_DGPCHDI'.xlsx", replace
import excel using "`SEG_DGPCHDI'.xlsx", firstrow clear
keep NROREGISTRO RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN FECHAINGRESOOFICINA DEPENDENCIA TRABAJADOR ESTADO UBICACION FECHAFINALIZACIÓN DIASFUERADEPLAZO INFORMACIÓNSOLICITADA CANAL DÍASTRANSCURRIDOS DÍASPORVENCER 
duplicates drop NROREGISTRO, force
gen seq = string(_n)
replace NROREGISTRO=seq if NROREGISTRO==""
drop seq
tempfile expediente_dgpchdi
save `expediente_dgpchdi',replace
use `expediente_dgpchdi'
merge 1:1 NROREGISTRO using `reporte_dgpchdi', force 
replace UBICACION=TRABAJADORESPENDIENTES if UBICACION==""
replace RAZÓNSOCIAL="DOCUMENTO INTERNO" if RAZÓNSOCIAL==""
keep NROREGISTRO RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN FECHAINGRESOOFICINA ESTADO FECHAFINALIZACIÓN DIASFUERADEPLAZO CANAL DÍASTRANSCURRIDOS DÍASPORVENCER CLASEDOCUMENTO INGRESOTRABAJADOR UBICACION DEPENDENCIA
replace UBICACION = lower(UBICACION)
replace UBICACION="Javier Aguilar" if strmatch(UBICACION,"*jacinto aguilar*")
replace UBICACION="Barbara Alcantara" if strmatch(UBICACION,"*alcantara alvarez*")
replace UBICACION="Anthony More" if strmatch(UBICACION,"*more garcia*")
replace UBICACION="Maricela Lynch" if strmatch(UBICACION,"*lynch*")
replace UBICACION="Deysi Razo" if strmatch(UBICACION,"*razo blas*")
replace UBICACION="Maria Baquijano" if strmatch(UBICACION,"*baquijano montes*")
replace UBICACION="Secretaria DGPCHDI" if strmatch(UBICACION,"*soto soto*")
replace UBICACION="Director DGPCHDI" if strmatch(UBICACION,"*director*")
replace DEPENDENCIA="DGPCHDI"
gen CONDICION="ATENDIDO" if FECHAFINALIZACIÓN!=""
replace CONDICION="PENDIENTE" if FECHAFINALIZACIÓN==""
gen TUPA_="SI" if NROPROCTUPA!=""
replace TUPA_="NO" if NROPROCTUPA==""
gen ESTADO_OLD="SIN PLAZO" if TUPA_=="NO"
replace ESTADO_OLD="VENCIDO" if TUPA_=="SI" & ESTADO=="VENCIDO"
replace ESTADO_OLD="EN PROCESO" if TUPA_=="SI" & strmatch(ESTADO,"*PENDIENTE*")
tostring NROPROCTUPA,replace
tostring DÍASTRANSCURRIDOS,replace
tostring DÍASPORVENCER,replace
save dgpchdi,replace
export excel using "$ruta1\dgpchdi_20_05.xlsx",first(variables) replace

*-----------------------------------------------------

clear all

import excel using "$ruta0\REPORTE_DOCUMENTOS_PENDIENTES_DECHDI.xls", firstrow clear
* Crear una nueva variable que contenga el número de celdas no vacías
gen num_filled_cells = .
* Iterar sobre las observaciones y contar las celdas no vacías
qui forval i = 1/`=_N' {
    local count = 0
    foreach var of varlist A-R {
        if (!missing(`var'[`i'])) local count = `count' + 1
    }
    replace num_filled_cells = `count' in `i'
}
* Encontrar el máximo número de celdas no vacías
qui sum num_filled_cells
//local max_filled_cells = r(max)
* Eliminar las filas que no tienen el máximo número de celdas no vacías
//drop if num_filled_cells < `max_filled_cells'
drop if num_filled_cells <= 2 
drop num_filled_cells
foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}

tempfile REPORTE_DECHDI
save `REPORTE_DECHDI',replace
* usar la primera fila
export excel "`REPORTE_DECHDI'.xlsx", replace
import excel using "`REPORTE_DECHDI'.xlsx", firstrow clear

keep NROREGISTRO CLASEDOCUMENTO RAZONSOCIAL NROPROCTUPA ASUNTO INGRESOOFICINA DEPENDENCIA INGRESOTRABAJADOR TRABAJADORESPENDIENTES
duplicates drop NROREGISTRO, force
gen seq = string(_n)
replace NROREGISTRO=seq if NROREGISTRO==""
drop seq
tempfile reporte_dechdi
save `reporte_dechdi',replace

import excel using "$ruta0\SEG_EXPEDIENTES_DECHDI.xls", firstrow clear
* Crear una nueva variable que contenga el número de celdas no vacías
gen num_filled_cells = .
* Iterar sobre las observaciones y contar las celdas no vacías
qui forval i = 1/`=_N' {
    local count = 0
    foreach var of varlist A-AG {
        if (!missing(`var'[`i'])) local count = `count' + 1
    }
    replace num_filled_cells = `count' in `i'
}
* Encontrar el máximo número de celdas no vacías
qui sum num_filled_cells
local max_filled_cells = r(max)
* Eliminar las filas que no tienen el máximo número de celdas no vacías
//drop if num_filled_cells < `max_filled_cells'
drop if num_filled_cells <= 2 
drop num_filled_cells
foreach var of varlist * {
    capture assert missing(`var')
    if !_rc drop `var'
}
tempfile SEG_DECHDI
save `SEG_DECHDI',replace
* usar la primera fila
export excel "`SEG_DECHDI'.xlsx", replace
import excel using "`SEG_DECHDI'.xlsx", firstrow clear

keep NROREGISTRO RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN FECHAINGRESOOFICINA DEPENDENCIA TRABAJADOR ESTADO UBICACION FECHAFINALIZACIÓN DIASFUERADEPLAZO INFORMACIÓNSOLICITADA CANAL DÍASTRANSCURRIDOS DÍASPORVENCER 
duplicates drop NROREGISTRO, force
gen seq = string(_n)
replace NROREGISTRO=seq if NROREGISTRO==""
drop seq
tempfile expediente_dechdi
save `expediente_dechdi',replace
use `expediente_dechdi'
merge 1:1 NROREGISTRO using `reporte_dechdi', force 
replace UBICACION=TRABAJADORESPENDIENTES if UBICACION==""
replace RAZÓNSOCIAL="DOCUMENTO INTERNO" if RAZÓNSOCIAL==""
keep NROREGISTRO RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN FECHAINGRESOOFICINA ESTADO FECHAFINALIZACIÓN DIASFUERADEPLAZO CANAL DÍASTRANSCURRIDOS DÍASPORVENCER CLASEDOCUMENTO INGRESOTRABAJADOR UBICACION DEPENDENCIA
replace UBICACION = lower(UBICACION)

replace UBICACION="Liliana Cerna" if strmatch(UBICACION,"*cerna meza*")
replace UBICACION="Dayana Salas" if strmatch(UBICACION,"*salas manrique*")
replace UBICACION="Leonardo Santos" if strmatch(UBICACION,"*santos fernandez*")
replace UBICACION="Maricela Lynch" if strmatch(UBICACION,"*lynch*")
replace UBICACION="Martha Dominguez" if strmatch(UBICACION,"*martha del carmen*")
replace UBICACION="Mayra Horna" if strmatch(UBICACION,"*horna montalvo*")
replace UBICACION="Steve Chuquilin" if strmatch(UBICACION,"*chuquilin rojas*")
replace UBICACION="Sofia Trinidad" if strmatch(UBICACION,"*trinidad gonzalo*")
replace UBICACION="Isabel Fiestas" if strmatch(UBICACION,"*fiestas valverde*")
replace UBICACION="Fabricio Luizar" if strmatch(UBICACION,"*luizar serna*")
replace UBICACION="Elsa Valdiviezo" if strmatch(UBICACION,"*valdiviezo salas*")
replace UBICACION="Director DECHDI" if strmatch(UBICACION,"*director*")
replace UBICACION="Carol Zambrano" if strmatch(UBICACION,"*zambrano capcha*")
replace UBICACION="Luis Valderrama" if strmatch(UBICACION,"*valderrama la rosa*")
replace UBICACION="Jocabed Canchari" if strmatch(UBICACION,"*canchari soto*")
replace UBICACION="Flor Velasco" if strmatch(UBICACION,"*velasco lagunas*")
replace UBICACION="Pedro Encinas" if strmatch(UBICACION,"*encinas principe*") 
replace UBICACION="Josué Tapia" if strmatch(UBICACION,"*tapia felipe*") 
replace UBICACION="Jaime de la Torre" if strmatch(UBICACION,"*de la torre obregon*") 
replace UBICACION="Luis Sanchez" if strmatch(UBICACION,"*sanchez tacunan*") 
replace UBICACION="Alan Garcia" if strmatch(UBICACION,"*garcia aragon*")


replace UBICACION="Diana Zerpa" if strmatch(UBICACION,"*zerpa zegarra*") 
replace UBICACION="Luis Sanchez" if strmatch(UBICACION,"*Sanchez Tacunan*") 
replace UBICACION="Katherine Fernandez" if strmatch(UBICACION,"*fernandez valdivieso*") 
replace UBICACION="Giselle Baca" if strmatch(UBICACION,"*baca monge*") 
replace UBICACION="Hugo Diaz" if strmatch(UBICACION,"*diaz diaz*")
replace UBICACION="Kenyi Huamanzana" if strmatch(UBICACION,"*huamanzana hilarion*")
replace UBICACION="Jhony Alegre" if strmatch(UBICACION,"*alegre moreno*")
replace UBICACION="Rocio Amaya" if strmatch(UBICACION,"*amaya suarez*")
replace UBICACION="Silvia Vasquez" if strmatch(UBICACION,"*vasquez veintemilla*")
replace UBICACION="Sofia Torres" if strmatch(UBICACION,"*torres tueros*")
replace UBICACION="Viviana Arevalo" if strmatch(UBICACION,"*arevalo sanchez*")

replace DEPENDENCIA="DECHDI"
gen CONDICION="ATENDIDO" if FECHAFINALIZACIÓN!=""
replace CONDICION="PENDIENTE" if FECHAFINALIZACIÓN==""
gen TUPA_="SI" if NROPROCTUPA!=""
replace TUPA_="NO" if NROPROCTUPA==""
gen ESTADO_OLD="SIN PLAZO" if TUPA_=="NO"
replace ESTADO_OLD="VENCIDO" if TUPA_=="SI" & ESTADO=="VENCIDO"
replace ESTADO_OLD="EN PROCESO" if TUPA_=="SI" & strmatch(ESTADO,"*PENDIENTE*")
tostring NROPROCTUPA,replace
save dechdi,replace
export excel using "$ruta1\dechdi_20_05.xlsx",first(variables) replace


//---------------------------------------------------
use dgpchdi
append using dpchdi
append using dechdi
//ultimas modificaciones
gen TIPO_DOC="Documento externo" if RAZÓNSOCIAL!="DOCUMENTO INTERNO"
replace TIPO_DOC="Documento interno" if TIPO_DOC==""
replace TUPA_="TUPA" if TUPA_=="SI"
replace TUPA_="OTROS" if TUPA_=="NO"
gen FECHAINGRESOOFICINA_date = date(FECHAINGRESOOFICINA, "DMY")
gen INGRESOTRABAJADOR_date = date(INGRESOTRABAJADOR, "DMY")
replace FECHAINGRESOOFICINA_date=INGRESOTRABAJADOR_date if FECHAINGRESOOFICINA_date==.
gen año = year(FECHAINGRESOOFICINA_date)
format FECHAINGRESOOFICINA_date %td

//format FECHAINGRESOOFICINA_date %fmt
//gen FECHAINGRESOOFICINA_date_2 = date("FECHAINGRESOOFICINA_date", "DMY")
//gen FECHAINGRESOOFICINA_date_2 = date(FECHAINGRESOOFICINA_date, "DMY")


//format FECHAINGRESOOFICINA_date %tc


// Generar la columna DG con la condición
gen DG = ""
replace DG = "SI" if FECHAINGRESOOFICINA_date >= date("22dec2022", "DMY")
// Reemplazar los valores vacíos con "no"
replace DG = "NO" if DG == ""
replace DG = "NO" if FECHAINGRESOOFICINA_date==.
replace FECHAINGRESOOFICINA_date=date("20dec2024", "DMY") if FECHAINGRESOOFICINA_date==.
format INGRESOTRABAJADOR_date %td
//replace FECHAINGRESOOFICINA_date = date(FECHAINGRESOOFICINA, "DMY")
replace TUPA="OTROS" if NROPROCTUPA==""
destring DÍASPORVENCER,replace
replace DÍASPORVENCER=0 if DÍASPORVENCER==.
gen ALERTA_TUPA="Prioridad 1" if DÍASPORVENCER==3 & DÍASPORVENCER!=0 & TUPA_=="TUPA"
replace ALERTA_TUPA="Prioridad 2" if DÍASPORVENCER>3 & DÍASPORVENCER<=7 & TUPA_=="TUPA"
replace ALERTA_TUPA="Prioridad 3" if DÍASPORVENCER>7 & TUPA_=="TUPA"


replace ESTADO_OLD="POR ATENDER" if  ESTADO_OLD=="EN PROCESO"
replace ESTADO_OLD="POR ATENDER" if  ESTADO_OLD==""
replace CANAL="SITRADOC"  if CANAL==""




gen ASUNTO_2=""
replace ASUNTO_2="Asociación temporal LMCE" if NROPROCTUPA=="015"
replace ASUNTO_2="Otorgamiento licencia planta procesamiento" if NROPROCTUPA=="027"
replace ASUNTO_2="Otorgamiento permiso pesca menor y mayor escala nacional" if NROPROCTUPA=="005"
replace ASUNTO_2="Cambio titularidad permiso pesca EP nacional" if NROPROCTUPA=="010"
replace ASUNTO_2="Autorización incremento flota" if NROPROCTUPA=="002"
replace ASUNTO_2="Acceso a la información" if NROPROCTUPA=="001"
replace ASUNTO_2="Otorgamiento autorización plantas procesamiento" if NROPROCTUPA=="024"
replace ASUNTO_2="Cambio titularidad licencia operación" if NROPROCTUPA=="029"
replace ASUNTO_2="Suspensión voluntaria permiso pesca" if NROPROCTUPA=="011"
replace ASUNTO_2="Nominación automática" if NROPROCTUPA=="069"
replace ASUNTO_2="Modificación atributos titular de EP" if NROPROCTUPA=="008"
replace ASUNTO_2="Autorización EP extranjera transbordo" if NROPROCTUPA=="019"
replace ASUNTO_2="Autorización investigación pesquera" if NROPROCTUPA=="022"
replace ASUNTO_2="Ampliación plazo autorización de instalación plantas" if NROPROCTUPA=="025"
replace ASUNTO_2="Modificación permiso de pesca cambio atributos EP" if NROPROCTUPA=="009"
replace ASUNTO_2="Permiso de pesca EP extranjera" if NROPROCTUPA=="017"
replace ASUNTO_2="Autorización colecta" if NROPROCTUPA=="023"
replace ASUNTO_2="Reconsideración" if NROPROCTUPA=="064"
replace ASUNTO_2="Nominación individual o grupal" if NROPROCTUPA=="014"
replace ASUNTO_2="Autorización exportación/importación fines distintos a CHI-CHD" if NROPROCTUPA=="020"
replace ASUNTO_2="Asociación o incorporación PMCE a otra EP" if NROPROCTUPA=="012"
replace ASUNTO_2="Incorporación definitiva PMCE merluza a otra EP" if NROPROCTUPA=="013"
replace ASUNTO_2="Certificado de origen cites" if NROPROCTUPA=="021"
replace ASUNTO_2="Modificación relación EP nominadas" if NROPROCTUPA=="016"
replace ASUNTO_2="Certificado procedencia y AOL" if NROPROCTUPA=="091"
replace ASUNTO_2="Ampliación plazo ejecución AIF" if NROPROCTUPA=="003"
replace ASUNTO_2="Modificación permiso pesca aumento bodega vía AIF" if NROPROCTUPA=="007"
replace ASUNTO_2="Suspensión voluntaria licencia operación" if NROPROCTUPA=="030"
replace ASUNTO_2="Autorización instalación planta procesamiento pesquero" if NROPROCTUPA=="028"
replace ASUNTO_2="Cambio titular licencia operación planta" if NROPROCTUPA=="082"
replace ASUNTO_2="Cambio titularidad de la AIF" if NROPROCTUPA=="004"
replace ASUNTO_2="Ampliación permiso pesca vía incremento flota" if NROPROCTUPA=="006"
replace ASUNTO_2="Cambio titularidad permiso pesca EP artesanal" if NROPROCTUPA=="032"
replace ASUNTO_2="Autorización operación acuarios comerciales" if NROPROCTUPA=="018"
replace ASUNTO_2="Cambio titularidad licencia operación planta" if NROPROCTUPA=="031"
replace ASUNTO_2="Certificado cites de exportación" if NROPROCTUPA=="040"
replace ASUNTO_2="Modificación impactos ambientales negativos" if NROPROCTUPA=="047"


gen asunto_lower = lower(ASUNTO)
replace asunto_lower = subinstr(asunto_lower, "°", "", .)
replace asunto_lower = subinstr(asunto_lower, "´", "", .)
replace asunto_lower = subinstr(asunto_lower, "`", "", .)
replace NROPROCTUPA="renovacion" if strmatch(asunto_lower, "*renovacion automática*")|strmatch(asunto_lower, "*renovacion de permiso de pesca*")|strmatch(asunto_lower, "*renovacion permiso de pesca*")


save general_20_05,replace
export excel using "$ruta2\general_20_05_prueba.xlsx",first(variables) replace


// traducir
unicode analyze "general_27_02.dta"
unicode encoding set "ISO-8859-10"
unicode translate "general_27_02.dta",transutf8 
use general_27_02
export delimited "general_09_02_final.csv",delimiter(",") replace












