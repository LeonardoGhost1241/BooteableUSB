#!/bin/bash
#Crear USB booteable con dd (estilo Rufus en terminal)

set -e  # detener el script si hay un error

echo "=== Crear USB Booteable con dd ==="

# Pedir la ISO
read -p "Ruta de la ISO: " iso
if [[ ! -f "$iso" ]]; then
    echo "[!] La ISO no existe: $iso"
    exit 1
fi

#Ver dispositivos de bloque disposnibles 
echo
echo "=== Discos disponibles ==="
lsblk -dpno NAME,SIZE | grep -v "loop"
echo

# Pedir el dispositivo USB
read -p "Dispositivo USB (ejemplo: /dev/sdb): " usb
if [[ ! -b "$usb" ]]; then
    echo "[!] El dispositivo no existe: $usb"
    exit 1
fi

# Confirmación de seguridad
echo
read -p "[!!!] Esto borrará TODO en $usb. ¿Estás seguro? (yes/no): " resp
if [[ "$resp" != "yes" ]]; then
    echo "Cancelado."
    exit 1
fi

# Desmontar particiones del USB
echo "[*] Desmontando particiones de $usb..."
sudo umount ${usb}?* 2>/dev/null || true

# Escribir la ISO con dd
echo "[*] Escribiendo la ISO en $usb..."
sudo dd if="$iso" of="$usb" bs=4M status=progress oflag=sync

# Sincronizar buffers
sync

echo "[✔] Proceso completado. Ya puedes extraer el USB"
