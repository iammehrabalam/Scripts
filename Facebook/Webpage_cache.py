import mechanize
from bs4 import BeautifulSoup as bs
import requests
import getpass
url="https://developers.facebook.com/tools/debug/og/object/"

email=raw_input('Enter your  facebook username or email:: ')
password=getpass.getpass("Enter password:: ")
webpage=raw_input('Enter your webpage url you want cache or scrape:: ')
# Browser option
br=mechanize.Browser()
br.set_handle_equiv(True)
#br.set_handle_gzip(True)
br.set_handle_redirect(True)
br.set_handle_referer(True)
br.set_handle_robots(False)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]
br.open("https://www.facebook.com/")
br.select_form(nr=0)
br.form["email"]=email
br.form["pass"]=password
nm=br.submit()

print nm.geturl()
br.open(url)

br.select_form(nr=0)
br.form['q']=webpage

r=br.submit(name='rescrape')

print r

