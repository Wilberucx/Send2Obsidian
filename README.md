# Obsidian Quick-Capture Tool

![Una demostración visual de la herramienta](.github/readme-images/Send2Obsidian%20imágenes.excalidraw.png)

Una herramienta ligera y potente para Windows que te permite capturar una imagen del portapapeles (o simplemente una idea) y crear una nueva nota en tu vault de Obsidian con un solo clic. **Totalmente personalizable y sin ventanas de terminal molestas.**

---

## ✨ Características Principales

-   **Captura de Imagen Instantánea:** Guarda una imagen del portapapeles directamente en tu carpeta de assets y la incrusta en una nueva nota.
-   **Captura de Texto Rápida:** Si no hay imagen, crea una nota limpia lista para tus pensamientos.
-   **Sistema de Plantillas Avanzado:** Usa tus propias plantillas de Obsidian para definir la estructura y el frontmatter de cada nueva nota.
-   **Nombres de Archivo Dinámicos:** Personaliza completamente cómo se nombran tus notas e imágenes usando formatos de fecha/hora a tu gusto.
-   **Ejecución 100% Silenciosa:** Se ejecuta en segundo plano para una experiencia fluida, sin interrupciones.
-   **Configuración Gráfica e Intuitiva:** Un asistente te guía para seleccionar carpetas y definir tus preferencias, sin necesidad de editar código.
-   **Totalmente Portátil:** La herramienta funciona desde cualquier ubicación en tu PC.

## 📋 Requisitos

-   **Sistema Operativo:** Windows 10 o Windows 11.
-   **Software:** PowerShell 5.1+ (instalado por defecto en Windows) y [Obsidian](https://obsidian.md/).

## 🚀 Instalación y Configuración

Sigue estos pasos para tener la herramienta funcionando en menos de 2 minutos.

**1. Descargar la Herramienta**
   - Ve a la sección [**Releases**](https://github.com/Wilberucx/Send2Obsidian/releases/tag/tool) de este repositorio y descarga el último archivo `.zip`.
   - Descomprime el archivo `.zip` en una ubicación permanente de tu ordenador (ej. `C:\Herramientas\Obsidian-Quick-Capture`).

**2. Ejecutar la Configuración Inicial**
   - Dentro de la carpeta, haz doble clic en el archivo `Configurar.ps1`.
     - *Nota: Puede que necesites hacer clic derecho > "Ejecutar con PowerShell". Si Windows bloquea la ejecución, abre PowerShell como administrador y ejecuta: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`, luego presiona 'S' para confirmar.*
   - Un asistente gráfico te guiará para:
     1.  Seleccionar las **carpetas** de tu vault (raíz, assets y notas).
     2.  Decidir si quieres usar una **plantilla de Obsidian** (¡recomendado!).
     3.  Definir los **formatos de nombre** para tus notas e imágenes.
   - Al finalizar, se creará un archivo `config.json` con tus preferencias.

**3. Crear el Acceso Directo**
   - Haz clic derecho sobre el archivo `Lanzador.vbs` y selecciona **Crear acceso directo**.
   - Mueve este acceso directo a tu escritorio o anclálo a tu barra de tareas.
   - Renómbralo a algo como "Captura Rápida a Obsidian".

**4. Asignar el Icono Personalizado (Opcional pero recomendado)**
   - Haz clic derecho sobre el **acceso directo** y selecciona **Propiedades**.
   - En la pestaña "Acceso directo", haz clic en `Cambiar icono...` > `Aceptar` en la advertencia.
   - Haz clic en `Examinar...`, navega a la carpeta de la herramienta y selecciona el archivo `icon.ico`.
   - `Aceptar` > `Aplicar` > `Aceptar`.

¡Tu herramienta está lista para la acción!

## 💡 Uso Diario

1.  Copia una imagen a tu portapapeles (la forma más rápida es `Win + Shift + S`).
2.  Haz doble clic en tu acceso directo.
3.  ¡Magia! Se abrirá tu editor de texto con la nueva nota, creada a partir de tu plantilla, con la imagen ya incrustada.

## 🔧 Personalización Avanzada (El Poder de las Plantillas)

La verdadera flexibilidad de esta herramienta reside en su sistema de plantillas.

### 1. Plantillas de Nombres y Timestamps

Durante la configuración (`Configurar.ps1`), puedes definir patrones exactos para los nombres de tus archivos.
-   **Formato de Timestamp:** Define cómo se formatea la fecha. Usa la [notación de formato de .NET](https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings).
  - Ejemplos: `yyyy-MM-dd`, `yyyyMMddHHmmss`, `'Semana'-ww`.
-   **Plantillas de Nombres:** Define la estructura del nombre usando `{{timestamp}}` como marcador de posición.
  - Ejemplos: `Nota - {{timestamp}}.md`, `Captura_{{timestamp}}.png`.

### 2. Plantillas de Contenido de Obsidian

Puedes indicarle a la herramienta que use una de tus plantillas de Obsidian para dar formato a cada nueva nota.

**Cómo funciona:**
1.  **Crea tu plantilla en Obsidian.** Diseña un archivo `.md` en tu vault.
2.  **Usa los placeholders especiales:** La herramienta buscará y reemplazará estos marcadores en tu plantilla:
    -   `{{timestamp}}`: La marca de tiempo completa (con tu formato personalizado).
    -   `{{date}}`: La fecha actual (ej. `2023-10-27`).
    -   `{{time}}`: La hora actual (ej. `15:30`).
    -   `{{image_link}}`: **(El más importante)** Aquí se insertará el wikilink de la imagen (`![[...]]`). Si no hay imagen en el portapapeles, este placeholder se eliminará, dejando tu nota limpia.
3.  **Configura la herramienta:** Ejecuta `Configurar.ps1`, di que sí a usar una plantilla y selecciónala.

#### Plantilla de Ejemplo

Puedes descargar una plantilla de ejemplo lista para usar desde esta carpeta del repositorio: [`/Templates/Ejemplo de Plantilla de Captura.md`](/Templates/Ejemplo%20de%20Plantilla%20de%20Captura.md).

```markdown
---
created: {{timestamp}}
tags: [inbox, captura]
aliases: ["Captura del {{date}}"]
---

# Nueva Captura

{{image_link}}

## Notas Adicionales:

- 

## Tareas:

- [ ] Revisar esta captura
```

## 📂 Estructura del Proyecto

```
.
├── .github/                 # Recursos para el README
│   └── readme-images/
│       └── ...
├── Templates/                 # Plantillas de ejemplo para los usuarios
│   └── Ejemplo de Plantilla de Captura.md
├── 📜 Configurar.ps1         # Asistente de configuración
├── 📜 Send2Obsidian.ps1      # Lógica principal de la herramienta
├── 🚀 Lanzador.vbs           # Ejecutable silencioso (para el acceso directo)
├── 🎨 icon.ico               # Icono personalizado
├── 📄 .gitignore             # Ignora archivos de configuración local
├── 📄 LICENSE                # Licencia del proyecto
└── 📄 README.md               # Esta guía
```

## 📜 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.
