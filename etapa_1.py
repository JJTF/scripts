######instalar pip install openpyxl
######pip install xlsxwriter


#IMPORTAR LIBRERIAS
import pandas as pd
import spacy 
from spacy.lang.es import Spanish
from spacy.pipeline import EntityRuler
from tqdm import tqdm, trange
import os
import re
import warnings
from win32com.client import Dispatch

#QUE SE CAMBIARÁN
ruta = r"D:\INDECOPI\Python CEMI"
dicc_1 = "Proveedores comercio dicc no bancos.xlsx"
excel = r"D:\INDECOPI\Python CEMI\restantes.xlsx"
hoja = "Sheet1"
var_a_nlp = "Proveedorx"
var_cleaned_1 = 'Proveedor_C'
new_excel = 'restantes.xlsx'

#APARTIR DE ACA SE HACE SOLO
var_nlp = var_a_nlp + "_2"
new_excel_r = os.path.join(ruta,new_excel)

#CARGAR EL DATASET POR HOJA A PROCESAR
db=pd.read_excel(excel,sheet_name=hoja)
values={'NaN':'Ninguna'}
db=db.fillna(value=values)
db=db.reset_index()

#FRAMES
#frames = [db_, db_1, db_2]
#dbx = pd.concat(frames)
#dbx=dbx.reset_index()

def preprocess(text):
    nlp = Spanish()
    result= []
    for i in trange(0,len(text)):
        text[i]=str(text[i])
        text[i]=re.sub(u'^(¿@?<.,#-_![a-z A-Z])',' ',text[i])
        text[i]=text[i].lower()
        text[i]=text[i].replace("@",' ')
        text[i]=text[i].replace("#",' ')
        text[i]=text[i].replace("-",' ')
        text[i]=text[i].replace("_",' ')
        text[i]=text[i].replace("¿",' ')
        text[i]=text[i].replace("!",' ')
        text[i]=text[i].replace("?",' ')
        text[i]=text[i].replace(".",' ')
        #text[i]=text[i].replace("´",' ')
        text[i]=text[i].replace("'",' ')
        text[i]=text[i].replace("/",' ')
        a,b = 'áéíóúü','aeiouu'
        trans = str.maketrans(a,b)
        text[i]=text[i].translate(trans)
        text[i]=text[i].strip()
        doc=nlp(text[i])
        t=[token.text for token in doc if not token.is_punct]
        result.append(' '.join(list(t)))
    return result

#PROCESANDO PROVEEDORES
db[var_nlp]=preprocess(db[var_a_nlp])

#Funcion encontrar proveedor
def find_proveedor(sentence,diccionario):
    #Esta funcion esta implementada para 3 posibles nombres de una sola entidad ejemplo:
    #Banco de Crédito de Perú: BCP, BCP-Banco de credito, banco de credito
    df=pd.read_excel(diccionario)
    df1=df[['label','pattern']]
    df2=df[['label','pattern.1']]
    df2=df2.rename(columns={'pattern.1':'pattern'}, inplace = False)
    df3=df[['label','pattern.2']]
    df3=df3.rename(columns={'pattern.2':'pattern'}, inplace = False)
    df4=df[['label','pattern.3']]
    df4=df4.rename(columns={'pattern.3':'pattern'}, inplace = False)
    df5=df[['label','pattern.4']]
    df5=df5.rename(columns={'pattern.4':'pattern'}, inplace = False)
    df6=df[['label','pattern.5']]
    df6=df6.rename(columns={'pattern.5':'pattern'}, inplace = False)
    df7=df[['label','pattern.6']]
    df7=df6.rename(columns={'pattern.6':'pattern'}, inplace = False)
    df8=df[['label','pattern.7']]
    df8=df6.rename(columns={'pattern.7':'pattern'}, inplace = False)
    #Crear los diccionarios
    patterns1=df1.to_dict(orient='records')
    patterns2=df2.to_dict(orient='records')
    patterns3=df3.to_dict(orient='records')
    patterns4=df4.to_dict(orient='records')
    patterns5=df5.to_dict(orient='records')
    patterns6=df6.to_dict(orient='records')
    patterns7=df7.to_dict(orient='records')
    patterns8=df8.to_dict(orient='records')
    patterns=patterns1+patterns2+patterns3+patterns4+patterns5+patterns6+patterns7+patterns8
    
    #Crear el objeto NLP
    nlp = Spanish()
    #ruler = EntityRuler(nlp)
    ruler = nlp.add_pipe("entity_ruler")
    ruler.add_patterns(patterns)
    #patterns=patterns1+patterns2+patterns3+patterns4+patterns5+patterns6+patterns7+patterns8
    #ruler.add_patterns(patterns)
    nlp.add_pipe('ruler')

    #Preprocesar la entrada

    a,b = 'áéíóúü','aeiouu'
    trans = str.maketrans(a,b)
    sentence=sentence.lower().translate(trans)
    doc = nlp(sentence)


    if (sentence=='' or  sentence==' ' or sentence=='Por definir' or sentence=='Por Definir' or
       sentence=='no hay datos ' or pd.isnull(sentence)==True):
        result=['No encontrado']
    #Devuelve la etiqueta real de la entidad
    else:
        
        #sentence=sentence.replace('.',' ')
        #sentence=sentence.replace('-',' ')
        #sentence=re.sub(u'^(?<![a-z A-Z])',' ', sentence)
        
        label= list(set([ent.label_ for ent in doc.ents]))
        #label no establecida
        if label!=[]:
            result=label
        else: result=['No encontrado']
    print(result)
    return result # solo retornar result 

#eJEMPLO, AQUI para CARGAR UN DICCIONARIO EL ARCHIVO DEBE ESTAR EN EL MISMO DIRECTORIO DEL NOTEBOOK y EN 
#FORMATO EXCEL
#find_proveedor('americá movil',dicc)

#APLICAR LA FUNCION find_proveedor
db[var_cleaned_1]=db.apply(lambda x: find_proveedor(x[var_nlp],dicc_1)[0],axis=1)
db_dir=db[db[var_cleaned_1]=='No encontrado']
db.drop(db[db[var_cleaned_1]=='No encontrado'].index, inplace=True)

db_dir[var_cleaned_1]=db_dir.apply(lambda x: find_proveedor(x['Hecho'],dicc_1)[0],axis=1)

frames = [db,db_dir]
result = pd.concat(frames)

#Asignar ruc y Razon Social
ruc=pd.read_excel(dicc_1, sheet_name='RUC')
result_merge=pd.merge(result, ruc, left_on='Proveedor_C', right_on='Nombre Comercial', how='left').drop('Nombre Comercial', axis=1)
result_merge = result_merge.drop('Proveedorx', axis=1)
result_merge = result_merge.drop('Proveedorx_2', axis=1)
#Asignar Razon social
result_merge.to_excel(new_excel,index=False,engine="xlsxwriter")
xl = Dispatch("Excel.Application")
xl.Visible = True # otherwise excel is hidden
wb = xl.Workbooks.Open(new_excel_r)


