# Auditoría básica de usuarios y permisos en Linux

Laboratorio de práctica de **solo lectura** sobre una VM propia con Kali Linux en VMware Workstation. Se revisan cuentas, grupos, permisos de archivos y servicios activos, y se documentan los riesgos con su medida correctiva.

> Todo se hizo en una VM de laboratorio. Las cuentas y el archivo débiles son ficticios, se crearon a propósito y se eliminaron al final.

## Resultado en breve

6 hallazgos (2 Media, 4 Baja), 3 puntos informativos y 5 revisiones sin hallazgos. Detalle en [`informe.md`](informe.md).

## Contenido del repositorio

```
├── README.md          Guía del laboratorio
├── comandos.txt       Comandos usados y qué buscar en cada uno
├── resultados.txt     Salida real de la auditoría (generada por scripts/auditoria.sh)
├── informe.md         Hallazgos, riesgos, recomendaciones y conclusiones
├── capturas/          Evidencia (índice en capturas/LEEME.md)
└── scripts/
    ├── preparar_lab.sh   Crea hallazgos ficticios
    ├── auditoria.sh      Auditoría de solo lectura
    └── limpieza.sh       Elimina lo creado por preparar_lab.sh
```

## Entorno

| Elemento | Detalle |
|---|---|
| Hipervisor | VMware Workstation |
| Sistema | Kali Linux (basada en Debian; los comandos también sirven en Ubuntu) |
| Red | Sin exposición a red externa |
| Herramientas | Comandos nativos de Linux |

## Pasos realizados

1. Snapshot de la VM.
2. `sudo bash scripts/preparar_lab.sh` para crear los hallazgos ficticios.
3. Auditoría manual con los comandos de `comandos.txt`, con capturas de cada paso.
4. `sudo bash scripts/auditoria.sh` para repetir la revisión y generar `resultados.txt`.
5. Registro de hallazgos y recomendaciones en `informe.md`.
6. `sudo bash scripts/limpieza.sh` para dejar el sistema como estaba.

## Habilidades demostradas

Administración de usuarios y grupos, permisos POSIX, principio de mínimo privilegio, revisión de servicios y puertos, interpretación de severidad según el contexto y documentación de hallazgos.

## Advertencia

Los comandos correctivos del informe son de referencia y no se aplicaron sobre el sistema. En un sistema real no se cambia ninguna configuración sin entender sus efectos.
