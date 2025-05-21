import pandas as pd
import spacy
from spacy.lang.es import Spanish
from spacy.pipeline import EntityRuler
from tqdm import tqdm, trange
import os
import re
import warnings
from win32com.client import Dispatch

#en esta sección poner las rutas
ruta = r"D:\INDECOPI\Python CEMI"
dicc_1 = "Conductas comercio dicc.xlsx"
excel = r"D:\INDECOPI\Python CEMI\restantes.xlsx"
hoja = "Sheet1" #nombre de la pestaña del excel
var_a_nlp = "Conducta_1" #poner el nombre de la columna a limpiar
var_cleaned_1 = 'Conducta_limpia' #nombre de la columna de conducta limpia (estará al final)
new_excel = 'comercio_07-05-21.xlsx' #nombre de la base de cada sector
nombrefinal = 'base conducta limpia.xlsx' #nombre del excel final

var_nlp = var_a_nlp + "_2"
new_excel_r = os.path.join(ruta,new_excel)
db=pd.read_excel(excel,sheet_name=hoja)
values={'NaN':'Ninguna'}
db=db.fillna(value=values)
db=db.reset_index()
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

db[var_nlp]=preprocess(db[var_a_nlp])
def find_proveedor(sentence,diccionario):
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
    patterns1=df1.to_dict(orient='records')
    patterns2=df2.to_dict(orient='records')
    patterns3=df3.to_dict(orient='records')
    patterns4=df4.to_dict(orient='records')
    patterns5=df5.to_dict(orient='records')
    patterns6=df6.to_dict(orient='records')
    patterns7=df7.to_dict(orient='records')
    patterns8=df8.to_dict(orient='records')
    patterns=patterns1+patterns2+patterns3+patterns4+patterns5+patterns6+patterns7+patterns8
    nlp = Spanish()
    ruler = EntityRuler(nlp)
    patterns=patterns1+patterns2+patterns3+patterns4+patterns5+patterns6+patterns7+patterns8
    ruler.add_patterns(patterns)
    nlp.add_pipe(ruler)
   
    if (sentence=='' or  sentence==' ' or sentence=='no hay datos' or pd.isnull(sentence)==True):
       result=['No encontrado']
      
    else:
        a,b = 'áéíóúü','aeiouu'
        trans = str.maketrans(a,b)
        sentence=sentence.lower().translate(trans)
        sentence=sentence.replace('.',' ')
        sentence=sentence.replace('-',' ')
        sentence=re.sub(u'^(?<![a-z A-Z])',' ', sentence)
        doc = nlp(sentence)
        label= list(set([ent.label_ for ent in doc.ents]))
        
        if label!=[]:
            result=label
        else: result=['No encontrado']
    
    print(result)
    return result

print('lo último')
db[var_cleaned_1]=db.apply(lambda x: find_proveedor(x[var_nlp],dicc_1)[0],axis=1)
db_dir=db[db[var_cleaned_1]=='No encontrado']
db = db.drop('index', axis=1)
db = db.drop('Conducta_1_2', axis=1)
db.to_excel(nombrefinal,index=False,engine="xlsxwriter")



