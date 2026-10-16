# SQL Server — Ejercicios de Data Analytics

Repositorio de ejercicios del curso de SQL de Coderhouse, realizados como parte de mi formación en Data Analytics.

El proyecto utiliza una base de datos de ejemplo de ventas de productos tecnológicos. La actividad de M3 implementa las tablas y carga los datos; la pre-entrega de M4 utiliza esa información para responder preguntas de negocio del equipo comercial de RetailPro.


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

## M5 — Consultas con JOINs

### Objetivo

Cruzar las tablas del esquema de M3 para obtener la vista enriquecida que necesita Power BI (ventas con cliente, producto, categoría y ciudad en una sola consulta) y responder dos preguntas puntuales: qué clientes nunca compraron (área de CRM) y qué productos del catálogo no tienen movimiento (área de Producto).

### Consultas incluidas

| Consulta                  | Pregunta de negocio                                                                          | Elementos utilizados                                  |
| ------------------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| 1. Vista base             | ¿Cómo se ve cada venta con cliente, ciudad, producto, categoría y total en una sola fila?    | `INNER JOIN` encadenado (4 tablas), alias, `ORDER BY`. |
| 2. Clientes sin ventas    | ¿Qué clientes registrados nunca compraron? (CRM)                                             | `LEFT JOIN`, `WHERE ... IS NULL`.                     |
| 3. Productos sin ventas   | ¿Qué productos del catálogo no tienen ninguna venta? (Producto)                              | `LEFT JOIN` (2 tablas), `WHERE ... IS NULL`.          |
| 4. Consolidado por canal  | ¿Cuánto se facturó en cada período de marzo?                                                 | `UNION ALL`, valor literal, subconsulta, `GROUP BY`.  |

Cada consulta está precedida por un comentario con su propósito y seguida por un comentario `-- Hallazgo:` que interpreta el resultado en términos de negocio.

### Datos de prueba

La base de M3 no tiene clientes sin compras ni productos sin ventas, por lo que las consultas 2 y 3 devolverían 0 filas. Por eso el script de M5 incluye, al principio, un bloque que agrega un cliente (`Sofía Díaz`, id 6) y un producto (`Webcam Full HD`, id 7) sin ventas. El bloque usa `IF NOT EXISTS`, así que puede ejecutarse varias veces sin generar claves duplicadas.

Con estos registros, las tablas pasan a tener **6 clientes** y **7 productos**. Las consultas de M4 no se ven afectadas, porque trabajan únicamente sobre `ventas`.

### Resultados esperados

- **Consulta 1:** 10 filas, una por venta. La facturación total suma **6.444,00**. Computación concentra **4.950,00** (76,8 %) y Buenos Aires es la ciudad con mayor facturación, con **2.640,00** (41 %).
- **Consulta 2:** 1 cliente sin compras (Sofía Díaz, registrada el 20/03/2024).
- **Consulta 3:** 1 producto sin ventas (Webcam Full HD, categoría Accesorios, precio 75,00).
- **Consulta 4:** 2 filas. El Periodo A (05–10 de marzo) factura **3.620,00** y el Periodo B (11–15 de marzo) **2.824,00**.

### Decisiones de diseño

- **Cadena de JOINs:** `categorias` no se relaciona directamente con `ventas`; se llega a ella a través de `productos` (`ventas → productos → categorias`).
- **Precio de la venta:** el total usa `ventas.precio_unitario` (precio al momento de vender) y no `productos.precio` (precio actual del catálogo).
- **`IS NULL` sobre la clave primaria:** en las consultas 2 y 3 se evalúa `ventas.id_venta`, que nunca es nulo en una venta real. Así, un `NULL` indica con certeza que no hubo coincidencia.
- **Canal simulado:** el esquema no tiene una columna de canal. En la consulta 4 la etiqueta se crea como valor literal en cada `SELECT`, y el criterio de separación es el período (hasta el 10/03 y desde el 11/03).
- **`UNION ALL` en lugar de `UNION`:** para que ninguna venta se elimine por coincidir con otra en todos sus valores.
- **`INNER JOIN` y valores nulos:** `ventas.id_cliente` e `id_producto` admiten `NULL`. Una venta sin cliente o sin producto quedaría fuera de la consulta 1. Con los datos actuales no ocurre.

## Cómo ejecutar los ejercicios

1. Descargar o clonar el repositorio.
2. Abrir SSMS y conectarse a una instancia de SQL Server.
3. Crear la base de datos `ventas_tech_db`, si todavía no existe.
4. Abrir `ventas_tech_db.sql` y seleccionar `ventas_tech_db` en el desplegable de bases de datos del editor. Este script utiliza la base seleccionada; no la crea ni incluye una instrucción `USE`.
5. Ejecutar el script completo con **F5**, sin seleccionar un fragmento. Revisar la pestaña Mensajes y comprobar que los cuatro `SELECT` devuelvan **4, 5, 6 y 10 filas**, respectivamente.
6. Abrir `m4_consultas_negocio.sql`. El archivo comienza con `USE ventas_tech_db;`; ajustar ese nombre si se utiliza una base distinta.
7. Ejecutar el archivo completo con **F5** y revisar sus cuatro conjuntos de resultados. Las consultas de M4 no modifican los datos.
8. Abrir `m5_consultas_joins.sql`. El archivo comienza con `USE ventas_tech_db;` y con el bloque de datos de prueba; ajustar el nombre de la base si se utiliza una distinta.
9. Ejecutar el archivo completo con **F5** y revisar sus resultados: **10, 1, 1 y 2 filas**, respectivamente. A diferencia de M4, este archivo inserta dos registros de prueba (un cliente y un producto).

Para ejecutar una consulta por separado, seleccionar todo su bloque. En la consulta 4 de M4, incluir desde `WITH` hasta el final del `SELECT` siguiente: la CTE y la consulta que la utiliza forman una sola instrucción. En M5, la consulta 4 también debe seleccionarse completa, incluida la subconsulta con `UNION ALL` y el `GROUP BY` final.

Si se vuelve a ejecutar `ventas_tech_db.sql`, los registros de prueba de M5 se eliminan junto con el resto de las tablas; se reinsertan al ejecutar de nuevo `m5_consultas_joins.sql`.

## Autor

Iván Pugliese.
