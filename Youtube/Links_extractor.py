import requests
from bs4 import BeautifulSoup
import re

url_flip=raw_input("Enter YouTube Link:: ")

filename=raw_input("Enter name of text file in which link will be save:: ")

r=requests.get(url_flip)

s=BeautifulSoup(r.text)

f=open(filename+'.txt','w')

for link in s.findAll('a',{'class':'pl-video-title-link'}):

        href=link.get('href')

        f.write('http://www.youtube.com'+href+'\n')

f.close()

raw_input("Your Youtube links are store in "+filename+".txt in current directory"+ "\nEnter to exit")

 
