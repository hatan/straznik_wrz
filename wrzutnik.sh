#!/bin/bash
cd /home/pi/wrzutnik
wget http://3rm.pl/wrzutnik/wrz/test/1
sleep 5
wget http://3rm.pl/wrzutnik/wrz/prefs
sleep 5
diff -q old_1 1 1>/dev/null
if [[ $? == "0" ]]
then
  echo "Serwer stoi"
else
  echo "Serwer lezy!!!"
  mutt -s "SERWER LEZY!!! HALO!!! RATUNKU!!!!" jacek.kozal@gmail.com -c styroslaw@gmail.com < /dev/null
fi
rm 1
diff -q old_prefs prefs 1>/dev/null
if [[ $? == "0" ]]
then
  echo "OK!"
else
  echo "Cos sie zmienilo"
  mutt -s "Config zrzutnika sie zjebal albo sie zmienilo albo nie wiem ratunku!!!!" jacek.kozal@gmail.com -c styroslaw@gmail.com -a /home/pi/wrzutnik/prefs < /dev/null
fi
rm prefs
wget --post-data "" http://3rm.pl/wrzutnik/wrz/search/dupa
if [ ! -f dupa ]; then
    echo "File not found!"
    mutt -s "Wyszukiwarka sie zjebala!!!! ALARM!!! RATUNKU!!!" jacek.kozal@gmail.com -c styroslaw@gmail.com < /dev/null
fi

cat dupa | jq '.data[].link' | grep wrzuta > towget &&  head -n 1 towget | tr --delete '"' | parallel --gnu "wget -O wrzut.plik {}"

if [ -s wrzut.plik ]
then
   echo "Wrzuta dziala!"
else
   echo "cos sie nie pobralo!"
   mutt -s "WRZUTA sie zjebala, nie idzie nic pobrac z pierwszego linka" jacek.kozal@gmail.com -c styroslaw@gmail.com -a /home/pi/wrzutnik/dupa < /dev/null
fi

cat dupa | jq '.data[].link' | grep chomikuj > towget &&  head -n 1 towget | tr --delete '"' | parallel --gnu 'curl {} -o chomik.plik'

if [ -s chomik.plik ]
then
   echo "Chomik dziala!"
else
   echo "cos sie nie pobralo!"
   mutt -s "CHOMIK sie zjebal, nie idzie nic pobrac z pierwszego linka" jacek.kozal@gmail.com -c styroslaw@gmail.com -a /home/pi/wrzutnik/dupa < /dev/null
fi

rm chomik.plik
rm dupa
rm wrzut.plik
rm towget


