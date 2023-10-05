#!/bin/bash

cat <<< """


███████╗███████╗██████╗ ██████╗ ██████╗ 
██╔════╝██╔════╝██╔══██╗╚════██╗╚════██╗
█████╗  ███████╗██████╔╝ █████╔╝ █████╔╝
██╔══╝  ╚════██║██╔═══╝  ╚═══██╗██╔═══╝ 
███████╗███████║██║     ██████╔╝███████╗
╚══════╝╚══════╝╚═╝     ╚═════╝ ╚══════╝
                                        

"""

FIRMWARE="${1}"

[[ -n "${1}" ]] || {
    echo -e "\t [*] specify path to firmware example: ./flash.sh /opt/firmware.bin"
    exit 1
}

[[ -f "${FIRMWARE}" ]] && [[ -r "${FIRMWARE}" ]] || {
    echo -e "\t [*] $FIRMWARE not found or not allowed to read"
    exit 1
}

progressBar() {
    local bar='████████████████████'
    local space='____________________'
    local current=${1}
    local total=${2}
    local position=$((100 * current / total))
    local barPosition=$((position / 5))
    echo -ne "\r|${bar:0:$barPosition}$(tput dim)${space:$barPosition:20}$(tput sgr0)| ${position}%"
}

progressBar 1 4
echo -e "\n"
sleep 1
[[ $(esptool.py 2>/dev/null) ]] || {
    echo -e "\t [*] esptool is not installed, install with pip install esptool\n"
    exit 1
}

progressBar 2 4
echo -e "\n"
echo -e "\t [*] erasing chip \n"
sleep 2
progressBar 3 4
echo -e "\n"
esptool.py --port /dev/ttyUSB0 erase_flash 2>/dev/null || {
    echo -e "\t [*] error when erasing chip \n"
}
sleep 2
echo -e "\n"
echo -e "\t [*] init firmware flash: $FIRMWARE"

esptool.py --chip esp32 --port /dev/ttyUSB0 write_flash -z 0x1000 "${FIRMWARE}"
echo -e "\n"
progressBar 4 4
echo -e "\n DONE ! \n"


