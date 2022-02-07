import numpy as np
import pandas as pd
import os
import re
#dicc_1 = "Proveedores comercio dicc no bancos.xlsx"
ruta = r"D:\INDECOPI"
excel = r"D:\INDECOPI\Python_CEMI\Comercio_12-02-21.xlsx"
hoja = "Sheet1"
base=pd.read_excel(excel,hoja) 
#lista=['etiqueta ','jabon','registro sanitario',	'registro',	'Triclosán ',	'Triclocarbán ',	
       #'octogono',	'manual de uso',	'advertencia',	'indicacion',	'fecha de vencimiento',	
       #'vencimiento',	'lote',	'fecha de fabricacion',	'fabricacion',	'envoltura',	'colageno',	
       #'camu camu',	'camucamu',	'miel de abeja',	'stevia natural',	'stevia',	'natural',	
       #'producto natural',	'eucalipto',	'legible',	'identificacion',	'importador',	'adulterado',	
       #'alterado',	'composicion',	'componente',	'sanitario',	'triclosan',	'triclocarban',	'etiquet']
#lista=["asistente automatico","mensaje virtual", "robot","chatbot","interaccion automatica","respuesta automatica",
      #"robot virtual"]
#lista=['funeraria','Parque del Recuerdo','Funeraria Campo Fe','Funeraria Acuña','Funeraria San Isidro',
       #'Funeraria Santa Rosa','Pacífico Funeraria','Funeraria Agustin Merino','Funerarias Perú','Funeraria Jardines de la Paz','Funeraria Aranzabal','Funeraria Villar','Funeraria Hnos Bonilla',
       #'Funeraria León ','Funeraria Monsalve','Funeraria Melchorita III','Funeraria José de Arimatea','Funeraria Continental',
       #'Funeraria Santa Elena','Funeraria Benavides','Funeraria Soriano',
       #'Agencia Funeraria Vigil','Funeraria Pucusana','Funeraria Virgen de Cocharcas','Funeraria Lombardía''Funeraria Corporación Peruana',	'Funeraria San Roque ',
       #'Funeraria Auqui ',	'Funeraria Pimentel','Funeraria San Felipe ','Funeraria Tejada ','Funeraria Integral','Funeraria La Fe', 'Funeraria San Martín ',	'Funeraria Pimentel Comas',	'Gilmer Arboleda Funeraria',	'Funeraria Solano',
       #'Funeraria Malca',	'Funeraria Martinez',	'Funeraria Balcazar',	'Funeraria Luz Divina',	'Funeraria Los Pinos ',	'Funeraria Bohorquez',	'Funeraria Vida Eterna',
      # 'Funeraria Santa Cruz','Funeraria Mera',	'Funeraria Victorio',	'Agencia Funeraria el Angel',	'Funeraria Nizama',	'Funeraria Cruz de Motupe']
#lista=['oxigeno']
lista=['alcohol', 'alcol', 'alcohol en gel']


       #'bronco pulmonares','oximas','oximedic','gases ova sur','alquimedic','oxigeno san camilo','sainpesac','linde praxair','oxyman','inversiones oximax','air products peru','red perú industrial','oxiromero group','oxigeno rocinju','oxigeno romero','criogas','gas energy peru','femesa oxigeno medicinal',
       #'oxitecni','corporación indimaq','gases industriales san felipe','kiar oxygen','oxinsa gases','oxígeno christian','jedissa distribuidora medica','omega peru','penta gas',
       #'industria techni peru',	'inversiones pukaras',	'energy gases',	'gases fanox','oxitesa','oxiromero group','oxigeno medico','indugaser','oxigeno vital','anteroxigeno','ahseco peru','indura peru',
       #'peru medical','tecnogas','oxihen-oxigeno-equipos','medical air','gases industriales retis','oxibandi','industrias farco','oxigenos campoy','kiar oxygen',
       #'oxigeno rocinju','grupo c y m logistica','oxigeno santa clara'
#lista=["producto vencido","vencido","vencimiento","expiro", "expirada","expirado", "vencio","expiracion"]
#base['priorizacion']=base.Hecho.str.contains(r'(?i)cloro')
#base['priorizacion']=base.HECHO.str.contains(r'(?i)\w*discrimina\w*')
#base['priorizacion']=base.HECHO.str.contains(r'(?i)\w*intox\w*')
a="(?i)\w*"+lista[0] + "\w*"
base['priorizacion1']=base.Hecho.str.contains(a)
#base['priorizacion2']=base.PROVEEDOR_LEGAL.str.contains(a)
#print(base['priorizacion1','priorizacion2'])
for i in np.arange(0,len(lista),1):
  a="(?i)\w*"+lista[i] + "\w*"
  base.loc[(base.priorizacion1== False),'priorizacion1']=base.Hecho.str.contains(a)
  #base.loc[(base.priorizacion2== False),'priorizacion2']=base.PROVEEDOR_LEGAL.str.contains(a)
#print(base[['HECHO','PROVEEDOR_LEGAL','priorizacion1','priorizacion2']])
base.to_excel(r'D:\INDECOPI\busquedaalcohol.xlsx', index=False) 


#def prioridad(lista): 
#    for lista in lista:
#        base['priorizacion']=base.HECHO.str.contains('(?i)lista[a]')
#prioridad(lista)
#print(lista[0])
#print(lista[1])
#base['priorizacion']==True
#a="r'(?i)"+lista[0]+"'"
#print(a)


























#produce
import numpy as np
import pandas as pd
import os
import re
#dicc_1 = "Proveedores comercio dicc no bancos.xlsx"
ruta = r"D:\PRODUCE"
excel = r"D:\PRODUCE\base general.xlsx"
hoja = "Hoja1"
lista =['huamanchumo', "diamante", pacif ] 
base=pd.read_excel(excel,hoja) 
a="(?i)\w*"+lista[0] + "\w*"
base['encontrados']=base.ARMADOR.str.contains(a)
print(base['encontrados'])

for i in np.arange(0,len(lista),1):
  a="(?i)\w*"+lista[i] + "\w*"
  base.loc[(base.encontrados== False),'encontrados']=base.ARMADOR.str.contains(a)

print(base[['ARMADOR','encontrados']])

base.to_excel(r'D:\PRODUCE\busqueda1.xlsx', index=False) 





import numpy as np
import pandas as pd
import os
import re
ruta = r"D:\INDECOPI"
#dicc_1 = "Proveedores comercio dicc no bancos.xlsx"
excel = r"D:\INDECOPI\distribucion\RV37\04Ene2021\RV 37.xlsx"
excel2= r"D:\INDECOPI\Python_CEMI\Comercio_03-01-21.xlsx"
hoja2="Sheet1"
hoja = "PRINCIPAL"
lista=['alicorp' , 'galleta', 'alimento', 'objeto', 'extraño'] 

lista =['Pavo' , 'Jamonada', 'discrina', 'intox'] 
base=pd.read_excel(excel,hoja)
base=pd.read_excel(excel2,hoja)
base['priorizacion']=base.HECHO.str.contains(r'(?i)Pavo')

for i in np.arange(0,len(lista),1):
    if i==0:
        a="(?i)\w*"+lista[i] + "\w*"
        base['priorizacion']=base.HECHO.str.contains(a)
    else:
        a="(?i)\w*"+lista[i] + "\w*"
        if base['priorizacion']==False:
            replace base['priorizacion']=base.HECHO.str.contains(a) 
        else:
            pass






