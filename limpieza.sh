#!/bin/bash
# Elimina lo creado por preparar_lab.sh. Ejecutar SOLO en la VM de práctica.
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo"; exit 1; }
userdel -r usuario_prueba 2>/dev/null
userdel -r exempleado 2>/dev/null
rm -f /tmp/archivo_publico.txt
echo "Limpieza terminada."
