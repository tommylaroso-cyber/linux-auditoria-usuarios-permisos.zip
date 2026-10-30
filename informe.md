# Informe: Auditoría básica de usuarios y permisos en Linux

**Fecha:** 29-10-2026
**Sistema:** Kali Linux en VMware Workstation (VM de laboratorio, sin exposición a red externa)
**Autor:** Tomás

## 1. Objetivo
Revisar cuentas, grupos, permisos de archivos y servicios de una VM propia, identificar riesgos básicos y proponer una medida correctiva para cada uno.

## 2. Alcance y método
Auditoría de **solo lectura**: no se modificó ninguna configuración del sistema. Se usaron comandos nativos de Linux (ver `comandos.txt`), revisados uno a uno y luego repetidos con `scripts/auditoria.sh`, cuya salida completa está en `resultados.txt`. Para generar hallazgos controlados se crearon antes dos cuentas y un archivo ficticios con `scripts/preparar_lab.sh`.

No incluye pruebas de intrusión, análisis de red externa ni Lynis.

## 3. Resumen
Se identificaron **6 hallazgos** (2 de severidad Media, 4 de Baja) y **3 puntos informativos**. No se encontraron cuentas sin contraseña, cuentas adicionales con UID 0, permisos incorrectos en archivos críticos del sistema ni puertos en escucha.

## 4. Hallazgos

| N° | Hallazgo | Evidencia | Riesgo | Severidad |
|---|---|---|---|---|
| 1 | `/tmp/archivo_publico.txt` con permisos 777 (creado a propósito) | `06_archivos_permisos_777.png` | Cualquier usuario puede leer, modificar o ejecutar el archivo | Media |
| 2 | `usuario_prueba` (creada a propósito) pertenece al grupo `sudo`; su contraseña está bloqueada | `04_estado_passwords_y_grupo_sudo.png`, `05b_grupo_kali_trusted.png` | Hoy no puede iniciar sesión, pero si se le asigna contraseña obtiene control total | Media |
| 3 | `exempleado` (creada a propósito) con `/bin/bash` y carpeta home; cuenta bloqueada | `01_passwd_final.png`, `04_estado_passwords_y_grupo_sudo.png` | Cuenta olvidada que conserva shell de login y datos | Baja |
| 4 | Regla `%kali-trusted ALL=(ALL:ALL) NOPASSWD: ALL` en `/etc/sudoers.d/kali-grant-root`; el grupo está vacío | `05_sudoers_y_permisos_etc.png`, `05b_grupo_kali_trusted.png` | Quien se agregue a ese grupo obtiene root sin contraseña | Baja |
| 5 | Zip del laboratorio y copias en `~/.cache/vmware/drag_and_drop/` con escritura para otros usuarios | `06_archivos_permisos_777.png` | Modificación por otros usuarios locales; solo existe el usuario `kali` | Baja |
| 6 | Paquete `rsh-redone-client` instalado (`rsh` y `rlogin`, protocolos sin cifrado), con binarios SUID | `07_suid_33_binarios.png`, `07b_rsh_y_postgresql.png` | Cliente de protocolo inseguro; no hay servidor `rsh` ni puerto 514 en escucha | Baja |

### Puntos informativos (sin acción requerida)

| Punto | Evidencia | Comentario |
|---|---|---|
| Cuenta `postgres` con `/bin/bash`; servicio PostgreSQL inactivo y contraseña bloqueada | `02_cuentas_con_shell.png`, `07b_rsh_y_postgresql.png` | Configuración habitual en Debian/Kali; no se recomienda cambiar el shell mientras el servicio esté desactivado |
| 33 binarios SUID, todos en `/usr/bin`, `/usr/sbin` y `/usr/lib` | `07_suid_33_binarios.png` | Ninguno en `/home`, `/tmp` u `/opt`. Incluye binarios estándar (`sudo`, `su`, `passwd`, `mount`) y propios de Kali (`kismet_cap_*`, `chrome-sandbox`) |
| La contraseña de `kali` no vence (máximo 99999 días) y el usuario pertenece a grupos como `adm` y `wireshark` | `04_estado_passwords_y_grupo_sudo.png`, `05b_grupo_kali_trusted.png` | Valores por defecto de Kali, aceptables en una VM de laboratorio |

### Revisiones sin hallazgos

| Revisión | Resultado | Evidencia |
|---|---|---|
| Cuentas con UID 0 | Solo `root` | `03_uid0_y_sin_password.png` |
| Cuentas sin contraseña | Ninguna | `03_uid0_y_sin_password.png` |
| Permisos de `/etc/passwd`, `/etc/group`, `/etc/shadow`, `/etc/sudoers` | 644, 644, 640, 440 (correctos) | `05_sudoers_y_permisos_etc.png` |
| Servicios en ejecución | 20, todos del sistema o del escritorio; ninguno de red (SSH, web, base de datos) | `08_servicios_activos.png` |
| Puertos TCP/UDP en escucha | Ninguno | `09_puertos_en_escucha.png` |

## 5. Recomendaciones

Los comandos son de referencia y **no se aplicaron** en este laboratorio, salvo la limpieza final de los elementos ficticios. En un sistema real se aplicarían solo después de entender el impacto y de que el responsable del sistema los autorice.

| Hallazgo | Medida correctiva | Comando de referencia |
|---|---|---|
| 1 | Dar el permiso mínimo necesario o eliminar el archivo | `chmod 644 /tmp/archivo_publico.txt` |
| 2 | Quitar sudo a quien no lo necesita (mínimo privilegio) | `sudo deluser usuario_prueba sudo` |
| 3 | Eliminar la cuenta si ya no se usa, o quitarle el shell | `sudo usermod -s /usr/sbin/nologin exempleado` |
| 4 | Mantener vacío el grupo `kali-trusted`; en un servidor, eliminar la regla y validar con `visudo -c` | `sudo rm /etc/sudoers.d/kali-grant-root` (solo en un servidor) |
| 5 | Restringir permisos de escritura a otros | `chmod 644 ~/Escritorio/*.zip` |
| 6 | Desinstalar el cliente si no se usa | `sudo apt remove rsh-redone-client` |

## 6. Conclusiones


Con esta auditoría practiqué cómo revisar de forma ordenada las cuentas, los permisos y los servicios de un sistema Linux, usando solo comandos nativos y sin modificar nada. Los hallazgos más relevantes fueron el archivo con permisos 777 y la cuenta con acceso a sudo, ambos creados a propósito para el ejercicio, y la regla de sudo sin contraseña que trae Kali por defecto.

Aprendí que la severidad no depende solo de lo que se ve a primera vista: `usuario_prueba` tiene sudo, pero como su contraseña está bloqueada, el riesgo real es menor de lo que parecía, y por eso la clasifiqué como Media y no como Alta. También vi que una distribución pensada para pentesting trae configuraciones que serían inadecuadas en un servidor (reglas NOPASSWD, muchos binarios SUID), pero que son razonables en un laboratorio.

Como mejora para un próximo laboratorio, me gustaría complementar la revisión manual con Lynis y comparar resultados.

## 7. Limitaciones
Es una VM de laboratorio con hallazgos creados a propósito y una distribución de pentesting, por lo que los resultados no son representativos de un servidor real. La revisión fue puntual, de una sola fecha, y no se ejecutó Lynis. En un entorno real habría que priorizar según el negocio y validar cada cambio antes de aplicarlo.
