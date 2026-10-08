# SQL Server — Ejercicios de Data Analytics

Repositorio de ejercicios del curso de SQL de Coderhouse, realizados como parte de mi formación en Data Analytics.

El proyecto utiliza una base de datos de ejemplo de ventas de productos tecnológicos. La actividad de M3 implementa las tablas y carga los datos; la pre-entrega de M4 utiliza esa información para responder preguntas de negocio del equipo comercial de RetailPro.

## Tecnologías y requisitos

- Microsoft SQL Server 2016 o posterior.
- SQL Server Management Studio (SSMS).
- Transact-SQL (T-SQL).
- Una base de datos llamada `ventas_tech_db`.

## Contenido del repositorio

| Módulo | Archivo | Objetivo |
|---|---|---|
| M3 | [ventas_tech_db.sql](ventas_tech_db.sql) | Crear las tablas, cargar los datos y validar los registros. |
| M4 | [m4_consultas_negocio.sql](m4_consultas_negocio.sql) | Obtener métricas mensuales, rankings de productos y clientes recurrentes. |

## M3 — Estructura y carga de datos

### Objetivo

Implementar las tablas de categorías, clientes, productos y ventas, con sus claves primarias, claves foráneas y restricciones. Cargar datos de ejemplo y comprobar el contenido de cada tabla.

### Secciones del script

1. **Eliminación de tablas:** elimina las tablas existentes, respetando sus dependencias.
2. **Creación de tablas:** define columnas, tipos de datos y restricciones.
3. **Inserción de datos:** carga los registros del ejercicio.
4. **Validación:** muestra el contenido de las cuatro tablas mediante `SELECT *`.

### Datos esperados

| Tabla | Contenido | Registros |
|---|---|---:|
| categorias | Categorías de productos | 4 |
| clientes | Datos de clientes | 5 |
| productos | Productos, precios y stock | 6 |
| ventas | Registros de ventas | 10 |

Los productos pueden estar asociados a una categoría. Las ventas pueden estar asociadas a un cliente y a un producto. Las claves foráneas verifican que los identificadores no nulos informados existan en sus tablas de referencia.

### Reejecución

El script elimina las cuatro tablas y las recrea con los datos de ejemplo en cada ejecución. Esto permite repetir el ejercicio sin acumular registros, pero elimina cualquier dato adicional cargado en esas tablas.

## M4 — Consultas SQL de negocio

### Objetivo

Extraer métricas comerciales para RetailPro mediante consultas que utilizan únicamente la tabla `ventas`. En esta etapa se trabaja con IDs de productos y clientes, sin utilizar `JOIN`.

### Consultas incluidas

| Consulta | Pregunta de negocio | Elementos utilizados |
|---|---|---|
| Resumen ejecutivo mensual | ¿Cuánto se facturó, cuántos pedidos hubo y cuál fue el ticket promedio de cada mes? | `MONTH`, `SUM`, `COUNT`, `AVG`, `CAST`, `GROUP BY`. |
| Ranking de productos | ¿Qué cinco productos generaron más facturación y cuántas unidades se vendieron de cada uno? | `TOP 5`, `SUM`, `GROUP BY`, `ORDER BY`. |
| Clientes recurrentes | ¿Qué clientes realizaron más de un pedido y cuánto gastaron? | `COUNT`, `SUM`, `GROUP BY`, `HAVING`. |
| Comparación con el promedio mensual | ¿Qué meses quedaron por encima, por debajo o iguales al promedio de facturación mensual? | CTE con `WITH`, subconsultas, `AVG`, `CASE WHEN`. |

La facturación se calcula como `cantidad * precio_unitario`. Para esta entrega, cada fila de `ventas` se considera un pedido.

### Resultados esperados con los datos de M3

- Marzo de 2024: facturación de **6.444,00**, **10 pedidos** y ticket promedio de **644,40**.
- Producto 1: líder de facturación, con **3.600,00** y **3 unidades vendidas**; representa aproximadamente el **55,87 %** del total.
- Los **5 clientes** tienen **2 pedidos** cada uno y cumplen el criterio de recurrencia. El cliente 1 lidera el gasto acumulado con **2.640,00**.

El archivo termina con un bloque de comentarios que documenta estos tres hallazgos.

### Alcance del análisis mensual

Todos los registros de ventas corresponden a marzo de 2024. Por eso, marzo coincide con el promedio mensual y recibe la etiqueta **Igual al promedio**. Se contempla explícitamente la igualdad para evitar clasificarla como un valor por debajo del promedio.

El agrupamiento usa `MONTH(fecha_venta)`, tal como solicita la consigna. Si se incorporan ventas de distintos años, deberá incluirse también el año para no combinar meses de años diferentes. El promedio considera únicamente los meses presentes en los datos.

La moneda no está especificada en la base de ejemplo. Los importes se presentan sin símbolo monetario.

## Cómo ejecutar los ejercicios

1. Descargar o clonar el repositorio.
2. Abrir SSMS y conectarse a una instancia de SQL Server.
3. Crear la base de datos `ventas_tech_db`, si todavía no existe.
4. Abrir `ventas_tech_db.sql` y seleccionar `ventas_tech_db` en el desplegable de bases de datos del editor. Este script utiliza la base seleccionada; no la crea ni incluye una instrucción `USE`.
5. Ejecutar el script completo con **F5**, sin seleccionar un fragmento. Revisar la pestaña Mensajes y comprobar que los cuatro `SELECT` devuelvan **4, 5, 6 y 10 filas**, respectivamente.
6. Abrir `m4_consultas_negocio.sql`. El archivo comienza con `USE ventas_tech_db;`; ajustar ese nombre si se utiliza una base distinta.
7. Ejecutar el archivo completo con **F5** y revisar sus cuatro conjuntos de resultados. Las consultas de M4 no modifican los datos.

Para ejecutar una consulta por separado, seleccionar todo su bloque. En la consulta 4, incluir desde `WITH` hasta el final del `SELECT` siguiente: la CTE y la consulta que la utiliza forman una sola instrucción.

## Autor

Iván Pugliese.
