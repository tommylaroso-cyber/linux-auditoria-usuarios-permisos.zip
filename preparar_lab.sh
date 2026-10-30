#!/bin/bash
# Crea hallazgos FICTICIOS para el laboratorio. Ejecutar SOLO en la VM de práctica.
set -e
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo"; exit 1; }
useradd -m -s /bin/bash usuario_prueba
useradd -m -s /bin/bash exempleado
usermod -aG sudo usuario_prueba
echo "dato ficticio" > /tmp/archivo_publico.txt
chmod 777 /tmp/archivo_publico.txt
echo "Listo: usuario_prueba (sudo), exempleado (cuenta olvidada) y /tmp/archivo_publico.txt (777)."
