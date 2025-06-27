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
   - Descomprime el archivo `.zip` en una ubicación permanente de tu ordenador (ej. `C:\Program Files\Send2Obsidian`).

**2. Ejecutar la Configuración Inicial**
   - Dentro de la carpeta descomprimida, busca el archivo `Configurar(Admin).bat`.
   - Haz **doble clic** en él.
   - Windows te pedirá permisos de administrador. Haz clic en **"Sí"**.
   - Se abrirá el asistente gráfico que te guiará para:
     1.  Seleccionar las **carpetas** de tu vault
         1. Carpeta de raíz (Tu Vault)
         2. assets, donde quieres guardar las imágenes
         3. Donde normalmente almacenas tus capturas (fleeting notes, capturas, inbox, etc)
     2.  Decidir si quieres usar una **plantilla de Obsidian** (¡recomendado!). Cada cambio que hagas en tu plantilla seleccionada dentro de tu obsidian se verá reflejada en tus capturas con la herramienta, por lo que es recomendable que designes una especialmente para la herramienta.
     3.  Definir los **formatos de nombre** para tus notas e imágenes.
   - Sigue los pasos y, al finalizar, se creará un archivo `config.json` con tus preferencias.

**3. Crear el Acceso Directo**
   - Haz clic derecho sobre el archivo `Lanzador.vbs` y selecciona **Crear acceso directo**.
   - Mueve este acceso directo a tu escritorio.
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
1.  **Crea tu plantilla en Obsidian.** Diseña una plantilla en tu carpeta de plantillas (si la tienes), recomendable especialmente para la herramienta por lo que puedes crear una copia de tu plantilla designada para tus capturas y designarle un nombre para identificar fácilemente en tu configuración S2O. 
2.  **Usa los placeholders especiales:** La herramienta buscará y reemplazará estos marcadores en tu plantilla:
    -   `{{timestamp}}`: La marca de tiempo completa (con tu formato personalizado).
    -   `{{date}}`: La fecha actual (ej. `2023-10-27`).
    -   `{{time}}`: La hora actual (ej. `15:30`).
    -   `{{image_link}}`: **(El más importante)** Aquí se insertará el wikilink de la imagen (`![[...]]`). Si no hay imagen en el portapapeles, este placeholder se eliminará, dejando tu nota limpia.
3.  **Configura la herramienta:** Ejecuta `Configurar.ps1`, di que sí a usar una plantilla y selecciónala.

#### Plantilla de Ejemplo

Puedes descargar una plantilla de ejemplo lista para usar desde esta carpeta del repositorio: [`/Templates/Ejemplo de Plantilla de Captura.md`](https://github.com/Wilberucx/Send2Obsidian/blob/main/Template.md).

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


