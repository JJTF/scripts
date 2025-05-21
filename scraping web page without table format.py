from bs4 import BeautifulSoup
import requests
import pandas as pd
r=requests.get("https://www.paginasamarillas.com.pe/servicios/conservas-de-pescado")
soup=BeautifulSoup(r.content,"html.parser")
titulos=soup.find_all('span', attrs={"class":"semibold"})
titulos2=[i.text for i in titulos]
df=pd.DataFrame({"titulos":titulos2})

df.to_excel(r'D:\Sanipes\excel\proveedores_conservas.xlsx', index=False)

//span[@class="semibold"]


website="https://www.paginasamarillas.com.pe/servicios/conservas-de-pescado"
result=requests.get(website)
content=result.txt
soup=BeautifulSoup(content,'lxml')
print(soup.prettify())


