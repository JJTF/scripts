import fitz
import os
ruta="D:\Sanipes"
os.chdir(ruta)
pdf_doc="sanipes.pdf"
doc=fitz.open(pdf_doc)
print("nun pág:", doc.pageCount)
print('metadatos:', doc.metadata)
pagina=doc.loadPage(0)
text=pagina.getText("text")
print('hello world')
print(text)