import urllib


for i in range (60, 562):
	urllib.urlretrieve ("http://chnm.gmu.edu/accent/soundtracks/english"+str(i)+".mp3", "english/english"+str(i)+".mp3")
	# the first "english" refers to the language you crawl, the second refers to the folder you want to save and the third indicates the name of the recording you wanna save
