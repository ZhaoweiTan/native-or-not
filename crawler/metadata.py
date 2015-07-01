  from bs4 import BeautifulSoup
import re,urlparse,urllib,os,time,csv

ID = [0] * 700
place = [0] * 700
native = [0] * 700
other = [0] * 700
age = [0] * 700
sex = [0] * 700
onset = [0] * 700
method = [0] * 700
residence = [0] * 700
years = [0] * 700

page = 'http://accent.gmu.edu/browse_language.php?function=find&language=english'
content = urllib.urlopen(page).read()
soup = BeautifulSoup(content)
i = 1
for s in soup.find('div',{'class':'content'}).findAll('p'):
	#print s.a['href'][46:]
	ID[i] = s.a['href'][46:]

	page2 = 'http://accent.gmu.edu/browse_language.php?function=detail&speakerid=' + str(ID[i])
	content2 = urllib.urlopen(page2).read()
	soup2 = BeautifulSoup(content2)
	bio = soup2.find('ul',{'class':'bio'}).findAll('li')
	
	#birth place
	tmp = str(bio[0])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('<a')
	#print tmp[pos1+6: pos2-1]
	place[i] = tmp[pos1+6: pos2-1]

	#native language
	native[i] = bio[1].a.string

	#other language(s)
	tmp = str(bio[2])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('</li')
	#print tmp[pos1 + 5: pos2]
	other[i] = tmp[pos1 + 5: pos2]

	#age and sex
	tmp = str(bio[3])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('</li')
	tmpp = tmp[pos1+6: pos2-1]
	pos3 = tmpp.find(',')
	#print tmpp[:pos3]
	#print tmpp[pos3+2:]
	age[i] = tmpp[:pos3]
	sex[i] = tmpp[pos3+2:]


	#age of onset
	tmp = str(bio[4])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('</li')
	#print tmp[pos1+6: pos2]
	onset[i] = tmp[pos1+6: pos2]

	#learning method
	tmp = str(bio[5])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('</li')
	#print tmp[pos1+6: pos2]
	method[i] = tmp[pos1+6: pos2]

	#english residence
	tmp = str(bio[6])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('</li')
	#print tmp[pos1+6: pos2]
	residence[i] = tmp[pos1+6: pos2]

	#years of residence
	tmp = str(bio[7])
	pos1 = tmp.find('</em>')
	pos2 = tmp.find('</li')
	#print tmp[pos1+6: pos2]
	years[i] = tmp[pos1+6: pos2]

	i = i + 1
	


with open('english.csv', 'w') as csvfile:
	fieldnames = ['Number', 'ID', 'Birth Place', 'Native Language', 'Other Language(s)', 'Age', 'Sex', 'Age of Onset', 'Learning Method', 'English Residence', 'Length of Residence']
	writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
	writer.writeheader()
	for i in range(1, 562):
		writer.writerow({'Number':i, 'ID':ID[i], 'Birth Place':place[i], 'Native Language':native[i], 'Other Language(s)':other[i], 'Age':age[i], 'Sex':sex[i], 'Age of Onset':onset[i], 'Learning Method':method[i], 'English Residence':residence[i], 'Length of Residence':years[i]})
