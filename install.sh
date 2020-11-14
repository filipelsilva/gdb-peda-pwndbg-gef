#!/bin/sh

echo "[+] Checking for required dependencies..."
if command -v git >/dev/null 2>&1 ; then
	echo "[-] Git found!"
else
	echo "[-] Git not found! Aborting..."
	echo "[-] Please install git and try again."
fi

if [ -f ~/.gdbinit ] || [ -h ~/.gdbinit ]; then
	echo "[+] backing up gdbinit file"
	cp ~/.gdbinit ~/.gdbinit.back_up
fi

# download peda and decide whether to overwrite if exists
if [ -d ~/peda ] || [ -h ~/.peda ]; then
	echo "[-] PEDA found"
	read -p "skip download to continue? (enter 'y' or 'n') " skip_peda

	if [ $skip_peda = 'n' ]; then
		rm -rf ~/peda
		git clone https://github.com/longld/peda.git ~/.gdb_plugins/peda
	else
		echo "PEDA skipped"
	fi
else
	echo "[+] Downloading PEDA..."
	git clone https://github.com/longld/peda.git ~/.gdb_plugins/peda
fi


# download pwndbg
if [ -d ~/pwndbg ] || [ -h ~/.pwndbg ]; then
	echo "[-] Pwndbg found"
	read -p "skip download to continue? (enter 'y' or 'n') " skip_pwndbg

	if [ $skip_pwndbg = 'n' ]; then
		rm -rf ~/pwndbg
		git clone https://github.com/pwndbg/pwndbg.git ~/.gdb_plugins/pwndbg

		cd ~/.gdb_plugins/pwndbg
		./setup.sh
	else
		echo "Pwndbg skipped"
	fi
else
	echo "[+] Downloading Pwndbg..."
	git clone https://github.com/pwndbg/pwndbg.git ~/.gdb_plugins/pwndbg

	cd ~/.gdb_plugins/pwndbg
	./setup.sh
fi


# download gef
echo "[+] Downloading GEF..."
git clone https://github.com/hugsy/gef.git ~/.gdb_plugins/gef


echo "[+] Setting .gdbinit..."
cp ~/.gdb_peda_pwndbg_gef/gdbinit ~/.gdbinit

{
	echo "[+] Creating files..."
	sudo cp ~/.gdb_peda_pwndbg_gef/gdb-peda /usr/bin/gdb-peda &&\
		sudo cp ~/.gdb_peda_pwndbg_gef/gdb-pwndbg /usr/bin/gdb-pwndbg &&\
		sudo cp ~/.gdb_peda_pwndbg_gef/gdb-gef /usr/bin/gdb-gef
	} || {
		echo "[-] Permission denied"
			exit
		}

	{
		echo "[+] Setting permissions..."
		sudo chmod +x /usr/bin/gdb-*
	} || {
		echo "[-] Permission denied"
			exit
		}

	echo "[+] Done"
