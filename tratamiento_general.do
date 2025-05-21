clear all

global ruta0 "C:\Users\josue\OneDrive - Ministerio de la Producción\JOSUE\prueba_bases"
//import excel using "$ruta0\SEG_EXPEDIENTES_DECHDI.xls", firstrow clear
foreach report in DECHDI DPCHDI DGPCHDI{
	import excel using "$ruta0\SEG_EXPEDIENTES_`report'.xls", firstrow clear
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
tempfile REPORTE_`report'
save `REPORTE_`report'',replace
* usar la primera fila
export excel "$ruta0\REPORTE_`report'.xlsx", replace
//import excel using "`REPORTE_DECHDI'.xlsx", firstrow clear
}
import excel using "$ruta0\REPORTE_DECHDI.xlsx", firstrow clear
gen DIRECCION="DECHDI"
duplicates drop NROREGISTRO, force
save base_dechdi,replace
import excel using "$ruta0\REPORTE_DPCHDI.xlsx", firstrow clear
gen DIRECCION="DPCHDI"
duplicates drop NROREGISTRO, force
save base_dpchdi,replace
import excel using "$ruta0\REPORTE_DGPCHDI.xlsx", firstrow clear
gen DIRECCION="DGPCHDI"
duplicates drop NROREGISTRO, force
save base_dgpchdi,replace
*unir bases de datos
append using base_dechdi,force
append using base_dpchdi,force
tab DIRECCION,missing
*guardar base final
save "$ruta0\prueba_1",replace
//Código para eliminar duplicados priorizando "DGPCHDI"
clear all
use "$ruta0\prueba_1"
//nueva etapa para ver que registros se repiten
*Paso 1: Contar en cuántas direcciones aparece cada NROREGISTRO
bysort NROREGISTRO (DIRECCION): gen unique_dirs = cond(_n == 1, 1, 0)
bysort NROREGISTRO (DIRECCION): replace unique_dirs = unique_dirs[_n-1] + 1 if _n > 1
*Paso 2: Clasificar registros según cuántas direcciones aparecen
gen flag_2_dirs = (unique_dirs == 2)
gen flag_3_dirs = (unique_dirs == 3)
*Paso 3: Contar los duplicados entre 2 y 3 direcciones
count if flag_2_dirs == 1
count if flag_3_dirs == 1
*Paso 4: eliminar duplicados
drop if flag_2_dirs==1 | flag_3_dirs==1
*Este paso no es necesario: Paso 4: Listar los registros duplicados por dirección
list NROREGISTRO DIRECCION if flag_2_dirs == 1, sepby(NROREGISTRO)
list NROREGISTRO DIRECCION if flag_3_dirs == 1, sepby(NROREGISTRO)
*********
****** eliminar los duplicados y conservar únicamente los registros únicos en la dirección DECHDI
*Paso 1: Identificar en cuántas direcciones aparece cada NROREGISTRO
bysort NROREGISTRO (DIRECCION): gen unique_dirs_1 = cond(_n == 1, 1, 0)
bysort NROREGISTRO (DIRECCION): replace unique_dirs_1 = unique_dirs[_n-1] + 1 if _n > 1

*Paso 2: Marcar registros a eliminar
gen to_delete = 1 if unique_dirs_1 > 1 & DIRECCION != "DECHDI"
replace to_delete = 0 if DIRECCION == "DECHDI"

*Paso 3: Eliminar los registros no deseados
drop if to_delete == 1

*****
* Paso 1: Identificar cuántas direcciones aparecen por cada NROREGISTRO
bysort NROREGISTRO (DIRECCION): gen unique_dirs = _N

* Paso 2: Marcar los registros a eliminar
gen to_delete = 1 if unique_dirs > 1 & DIRECCION != "DECHDI"
replace to_delete = 0 if DIRECCION == "DECHDI"

* Paso 3: Eliminar los registros no deseados
drop if to_delete == 1

*****

*Paso 4: Verificar que solo quedaron registros únicos en DECHDI
tab DIRECCION
duplicates report NROREGISTRO
* Eliminar la variable de banderas ya que no se necesita más
drop dup_flag unique_dirs flag_2_dirs flag_3_dirs to_delete unique_dirs_1

//Si quieres eliminar duplicados de cualquier otra dirección después de "DGPCHDI"
*duplicates drop NROREGISTRO, force

**otro procedimiento****
//1. Contar los valores duplicados de "NROREGISTRO"
duplicates report NROREGISTRO
//Contar exactamente cuántas veces se repiten
bysort NROREGISTRO: gen freq = _N
//solo los duplicados
list NROREGISTRO freq if freq > 1, sepby(NROREGISTRO)
//Contar solo los registros duplicados (excluyendo los únicos)
egen tag = tag(NROREGISTRO)
count if tag == 1

*******************************************
keep NROREGISTRO TIPOPERSONA RAZÓNSOCIAL NROPROCTUPA ASUNTO FECHARECEPCIÓN ///
DIASPARAATENCIÓN FECHAMÁXIMADEATENCIÓN ESTADO ESTADOOFICINA UBICACION FECHAFINALIZACIÓN ///
DIASFUERADEPLAZO OBSERVACIÓN CANAL DÍASTRANSCURRIDOS DÍASPORVENCER DIASHABILES ///
DIRECCION
*********************************************************


// Definir fecha final como hoy
gen fecha_final = daily("`c(current_date)'", "DMY")

// Convertir las fechas a formato numérico
gen fecha_inicial_num = date(FECHARECEPCIÓN, "DMY")
format fecha_inicial_num fecha_final %td

save "$ruta0\prueba_2.dta",replace
clear all
use "$ruta0\prueba_2.dta"

clear
set obs 160   // 16 feriados por 10 años aprox.

gen feriado = .
gen motivo = ""

local pos = 1
forvalues year = 2010/2025 {
    foreach day in "01jan" "01may" "29jun" "28jul" "29jul" "30aug" "08oct" "01nov" "08dec" "25dec" {
        replace feriado = date("`day'`year'", "DMY") in `pos'
        replace motivo = "`day' `year'" in `pos'
        local pos = `pos' + 1
    }
}

format feriado %td
save "$ruta0\feriados.dta", replace
use "$ruta0\prueba_2.dta", clear
merge m:1 fecha_inicial_num using "$ruta0/feriados.dta", nogen



// Crear una variable que cuente los días hábiles
gen dias_habiles = 0

forvalues i = 1/`=_N' {
    local f1 = fecha_inicial_num[`i']
    local f2 = fecha_final[`i']
    local dias = 0

    forvalues f = `f1'/`f2' {
        if !inlist(dow(`f'), 6, 0) & !inlist(`f', feriado) {
            local dias = `dias' + 1
        }
    }

    replace dias_habiles = `dias' in `i'
}

// Filtrar solo los registros con estado "pendiente"
keep if estado == "pendiente"
