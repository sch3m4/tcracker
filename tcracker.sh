#!/bin/bash
#

echo -e "\n"
echo -e "############################"
echo -e "#                          #"
echo -e "#      ~ SafetyBits ~      #"
echo -e "#                          #"
echo -e "# Simple TrueCrypt Cracker #"
echo -e "#          v0.1b           #"
echo -e "#                          #"
echo -e "# ~~~~~~~~~~~~~~~~~~~~~~~  #"
echo -e "#                          #"
echo -e "# Written by: Chema Garcia #"
echo -e "#   chema@safetybits.net   #"
echo -e "#   http://safetybits.net  #"
echo -e "#                          #"
echo -e "############################"

if [ ! $# -eq 2 ]
then
	echo -e "\nUse: $0 <volume_path> <dictionary>\n"
	exit 0
fi

TRUECRYPT="`which truecrypt`"
if [ `echo $TRUECRYPT | grep -c "^/"` -eq 0 ]
then
	echo -e "\n[!] 'truecrypt' not found!\n"
	exit 1
fi

IFSaux="$IFS"
IFS="
"

echo -e "\n[+] Started!\n"
for i in `cat $2`
do
	RES="`$TRUECRYPT --text --non-interactive --mount --mount-options=ro --filesystem=none -p "$i" "$1" 2>&1`"

	if [ $? -eq 0 ]
	then
		echo -e "\n[+] KEY FOUND! ==> $i\n"
		$TRUECRYPT --text --non-interactive --volume-properties "$1"

		echo -e "[+] Demounting...\c"
		$TRUECRYPT --text --non-interactive -d "$1"
		echo "OK"

		break
	elif [ `echo "$RES" | grep -ic "create ioctl failed"` -ge 1 ]
	then
		echo -e "\n[+] POSSIBLE KEY FOUND! ==> $i"
		echo -e "\t- Still working..."
	fi

done

IFS="$IFSaux"

echo -e "\n[+] Finished!\n"

unset IFSaux RES TRUECRYPT i
exit 0