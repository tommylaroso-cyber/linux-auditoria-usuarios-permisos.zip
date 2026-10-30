#!/bin/bash
# Auditoría de SOLO LECTURA: no modifica nada. Guarda la salida en resultados.txt
# Uso: sudo bash auditoria.sh
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta con sudo"; exit 1; }
OUT="resultados.txt"
sec() { echo -e "\n=================== $1 ===================" >> "$OUT"; }
run() { echo -e "\n\$ $*" >> "$OUT"; eval "$*" >> "$OUT" 2>&1; }

echo "Auditoría - $(date) - $(hostname)" > "$OUT"

sec "1. CUENTAS DE USUARIO"
run "cat /etc/passwd"
run "grep -E '/bin/(bash|sh|zsh)$' /etc/passwd"
run "awk -F: '\$3 == 0 {print \$1}' /etc/passwd"
run "awk -F: '(\$2 == \"\") {print \$1}' /etc/shadow"
run "passwd -S -a"
run "last -n 10"
run "lastlog | grep -v 'Never'"

sec "2. GRUPOS Y PRIVILEGIOS"
run "getent group sudo"
run "ls -l /etc/sudoers.d/"
run "grep -v '^#' /etc/sudoers | grep -v '^\$'"
run "grep -rn NOPASSWD /etc/sudoers /etc/sudoers.d/"

sec "3. PERMISOS DE ARCHIVOS"
run "ls -l /etc/passwd /etc/shadow /etc/group /etc/sudoers"
run "find / -xdev -type f -perm -0002"
run "find / -xdev -type d -perm -0002 ! -perm -1000"
run "find / -xdev -type f -perm -4000"
run "find / -xdev \\( -nouser -o -nogroup \\)"

sec "4. SERVICIOS Y PUERTOS"
run "systemctl list-units --type=service --state=running --no-pager"
run "systemctl list-unit-files --type=service --state=enabled --no-pager"
run "ss -tulpn"

echo "Listo. Resultados en $OUT"
