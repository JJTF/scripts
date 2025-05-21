#Pasos previos:
#instalar pip install selenium
#entrar a cmd y digitar python luego aceptar
#poner el comando "pip install PyAutoGUI" en cmd
#import pyautogui
#pyautogui.displayMousePosition() 
#asigNo registra

 
import pyautogui as robot
import time
import pyperclip
p1 = 30, 167 # abrir chrome
p2 = 500,94 # posicion para navegar en chrome
p3 = 1307,55 # maximizar chrome
p4 = 782, 246 # asignar buscar por RZ
# Se escribe automatico la RZ
p5 = 700,328 # seleccionar buscar
p6 = 406, 266 # click la entrada al ruc
p8 = 652,237 #doble click para resaltar
p9 = 126,753 #coordenada del excel abierto
pchrome = 171,755 #coordenada del chrome

def abrir(pos,click=1):
    robot.moveTo(pos)
    robot.click(clicks=click)
    
from selenium import webdriver

#wd = r"C:\Users\Administrador\AppData\Local\Programs\Python\Python39\Lib\site-packages\selenium\chromedriver.exe"
wd = r"D:\Programas antes C\Python native\Lib\site-packages\selenium\chromedriver.exe"
from selenium import webdriver
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
options = Options()


options.add_argument("--disable-notifications")
options.add_argument("--disable-infobars")
options.add_argument("--mute-audio")
driver = webdriver.Chrome(executable_path=wd, options=options)
driver.get("https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias")
time.sleep(6)


import os
import re
import pandas as pd
os.chdir(r"D:\INDECOPI\bases_xlsx")
# Aqui poner el archivo excel. Este debe tener una columna de proveedor sucio (la primera)
# y se debe colocar el cursor en la segunda columna fila 2 (luego del encabezado)
f = pd.read_excel('nombre.xlsx')
a = f['name_variable'].values

def change(t):
    t = t.lower()
    t = re.sub('á','a',t)
    t = re.sub('é','e',t)
    t = re.sub('í','i',t)
    t = re.sub('ó','o',t)
    t = re.sub('ú','u',t)
    t = re.sub(',','',t)
    t = re.sub('-','',t)
    t = re.sub('/','',t)
    #t = re.sub(r'(','',t)
    #t = re.sub(r')','',t)
    t = re.sub("'",'',t)
    t = re.sub('"','',t)
    return t
    
b = []
for i in range(0,len(a)):
    h = change(a[i])
    b.append(h)

for i in b:
    try:
        driver.find_element(By.ID, "btnPorRazonSocial").click()
        driver.find_element(By.ID, "txtNombreRazonSocial").send_keys(i)
        driver.find_element(By.ID, "btnAceptar").click()
        time.sleep(3)
        driver.find_element(By.CSS_SELECTOR, ".list-group-item:nth-child(1) > .list-group-item-heading:nth-child(2)").click()
        time.sleep(2)
        z = driver.find_elements(By.XPATH, "//h4[contains(@class, 'list-group-item-heading')]")
        pyperclip.copy(z[1].text)
        abrir(p9)
        robot.hotkey("ctrl","v")
        robot.hotkey('enter')
        abrir(pchrome)
        driver.find_element(By.XPATH,'//button[contains(@class,"btn btn-danger btnNuevaConsulta")]').click()
    except:
        abrir(p9)
        robot.typewrite('No registra')
        robot.hotkey('enter')
        abrir(pchrome)
        driver.get("https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias")
        time.sleep(6)
        
