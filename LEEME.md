# Índice de capturas

| Archivo | Comando / contenido | Qué demuestra |
|---|---|---|
| `00_escritorio_kali.png` | Escritorio de la VM en VMware Workstation | Entorno de laboratorio |
| `01a_passwd_inicio.png` | `cat /etc/passwd` (inicio) | Cuentas de sistema con `nologin` |
| `01_passwd_final.png` | `cat /etc/passwd` (final) | Aparecen `kali`, `usuario_prueba` y `exempleado` |
| `02_cuentas_con_shell.png` | `grep -E '/bin/(bash\|sh\|zsh)$' /etc/passwd` | 5 cuentas con shell: `root`, `postgres`, `kali`, `usuario_prueba`, `exempleado` |
| `03_uid0_y_sin_password.png` | `awk` sobre `/etc/passwd` y `/etc/shadow` | Solo `root` tiene UID 0; ninguna cuenta sin contraseña (arriba se ve un intento previo de `grep` con error de tipeo, sin relevancia) |
| `04_estado_passwords_y_grupo_sudo.png` | `sudo passwd -S -a` y `getent group sudo` | `kali` activa; `usuario_prueba` y `exempleado` bloqueadas; sudo = `kali`, `usuario_prueba` |
| `05_sudoers_y_permisos_etc.png` | `ls -l /etc/sudoers.d/`, `grep NOPASSWD`, `ls -l` de archivos críticos | Reglas NOPASSWD y permisos correctos de passwd, shadow, group y sudoers |
| `05b_grupo_kali_trusted.png` | `getent group kali-trusted`, `id kali`, `id usuario_prueba` | Grupo `kali-trusted` vacío; pertenencia a grupos |
| `06_archivos_permisos_777.png` | `find -perm -0002` y `ls -l` | `/tmp/archivo_publico.txt` con 777 y zip con escritura para otros |
| `07_suid_33_binarios.png` | `find -perm -4000` y `wc -l` | 33 binarios SUID en rutas del sistema |
| `07b_rsh_y_postgresql.png` | `dpkg -S` y `systemctl is-active postgresql` | `rsh-redone-client` instalado; PostgreSQL inactivo |
| `08_servicios_activos.png` | `systemctl list-units --type=service --state=running` | 20 servicios, ninguno de red |
| `09_puertos_en_escucha.png` | `sudo ss -tulpn` y `wc -l` | Sin puertos en escucha (solo encabezado) |
| `10_script_auditoria.png` | `sudo bash scripts/auditoria.sh` | Ejecución del script y generación de `resultados.txt` |

No se ejecutó Lynis en este laboratorio.
