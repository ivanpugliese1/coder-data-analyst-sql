# Análisis de ventas con SQL Server

Proyecto académico de Data Analytics desarrollado para Coderhouse. Utiliza una base de ventas de productos tecnológicos para practicar modelado relacional, consultas SQL e interpretación de resultados comerciales.

**Autor:** Iván Pugliese  
**Base de datos:** `ventas_tech_db`  
**Repositorio:** [coder-data-analyst-sql](https://github.com/ivanpugliese1/coder-data-analyst-sql)

## Objetivo del proyecto

Transformar los registros de ventas en información útil para responder preguntas comerciales:

- ¿Cuánto se factura por mes y cuál es el ticket promedio?
- ¿Qué productos generan mayor facturación y cuántas unidades se venden?
- ¿Qué clientes realizan más de un pedido?
- ¿Cómo se relacionan las ventas con los clientes, los productos y las categorías?
- ¿Qué conclusiones están respaldadas por los datos y qué decisiones necesitan información adicional?

El proyecto también incorpora una revisión crítica de propuestas generadas con inteligencia artificial, tanto sobre las consultas como sobre su interpretación.

## Herramientas utilizadas

| Herramienta | Uso en el proyecto |
| --- | --- |
| Microsoft SQL Server | Motor de base de datos para almacenar las tablas y ejecutar las consultas. |
| SQL Server Management Studio (SSMS) | Entorno para crear la base, abrir los scripts, ejecutarlos y revisar resultados. |
| SQL / Transact-SQL (T-SQL) | Lenguaje utilizado para definir tablas, cargar datos, filtrar, agrupar y relacionar información. |
| GitHub | Organización y publicación de los scripts y de la documentación. |
| ChatGPT | Apoyo para revisar consultas y proponer interpretaciones, sujetas a evaluación crítica y verificación. |

## Modelo de datos y alcance

La base utilizada en estas entregas se organiza en cuatro tablas:

| Tabla | Contenido | Relación utilizada |
| --- | --- | --- |
| `clientes` | Identificador, nombre y ciudad de cada cliente. | `clientes.id_cliente` → `ventas.id_cliente`. |
| `categorias` | Identificador, nombre y descripción de las categorías. | `categorias.id_categoria` → `productos.id_categoria`. |
| `productos` | Identificador, nombre y categoría de cada producto. | `productos.id_producto` → `ventas.id_producto`. |
| `ventas` | Cliente, producto, fecha, cantidad y precio unitario de la operación. | Tabla utilizada para calcular los indicadores comerciales. |

Las relaciones permiten conectar un cliente con varias ventas, un producto con varias ventas y una categoría con varios productos.

**Unidad de análisis:** el archivo de M4 establece expresamente que, para esta entrega, cada fila de `ventas` se considera un pedido. Por eso, `COUNT(*)` representa la cantidad de pedidos y `AVG(cantidad * precio_unitario)` representa su ticket promedio.

Si el modelo se amplía para registrar un pedido en varias filas —por ejemplo, una por producto—, estos indicadores deberán recalcularse a nivel de pedido.

## Archivos y orden de ejecución

| Orden | Archivo | Propósito |
| --- | --- | --- |
| 1 | `ventas_tech_db.sql` | Preparación inicial de la base: creación de tablas y carga de los datos de práctica de M3. |
| 2 | `m4_consultas_negocio.sql` | Métricas mensuales, ranking de productos, clientes recurrentes y comparación con el promedio mensual. |
| 3 | `m5_consultas_joins.sql` | Cruce de tablas con JOIN y combinación de resultados mediante UNION ALL. |
| — | `README.md` | Descripción, instrucciones de ejecución y evaluación crítica del análisis. |

M4 y M5 consultan la base preparada en M3. El orden anterior permite seguir las entregas de forma progresiva.

## Cómo ejecutar los scripts SQL

### 1. Preparar el entorno

Se necesita una instancia de **SQL Server** disponible y **SSMS** instalado. SSMS es la aplicación cliente: también debe existir un motor de SQL Server al cual conectarse.

La cuenta utilizada debe tener permisos para crear la base y sus tablas durante la preparación inicial, insertar los datos y ejecutar las consultas.

### 2. Obtener los archivos

Desde el repositorio, utilizar **Code → Download ZIP** y descomprimir los archivos.

Si se utiliza Git, también se puede descargar el proyecto con:

```bash
git clone https://github.com/ivanpugliese1/coder-data-analyst-sql.git
cd coder-data-analyst-sql
```

### 3. Conectarse desde SSMS

1. Abrir SQL Server Management Studio.
2. Conectarse al motor de base de datos usando el nombre de la instancia y el método de autenticación configurados en el equipo.
3. Abrir `ventas_tech_db.sql` mediante **Archivo → Abrir → Archivo**, o con **Ctrl + O**.
4. Ejecutar el script con **F5** o con el botón **Ejecutar**.
5. Revisar la pestaña **Mensajes** y actualizar el Explorador de objetos para comprobar que la base y las tablas estén disponibles.

Si no hay texto seleccionado, F5 ejecuta todo el contenido del editor. Si se selecciona una parte, ejecuta solamente esa selección.

Para una base ya preparada, continuar con las consultas de M4 y M5. Antes de repetir el script inicial, revisar sus instrucciones de creación y carga para evitar recrear objetos o cargar datos nuevamente.

### 4. Verificar la base y los datos

En una nueva consulta, ejecutar:

```sql
USE ventas_tech_db;
GO

SELECT DB_NAME() AS base_actual;

SELECT 'clientes' AS tabla, COUNT(*) AS cantidad_filas
FROM clientes
UNION ALL
SELECT 'categorias', COUNT(*)
FROM categorias
UNION ALL
SELECT 'productos', COUNT(*)
FROM productos
UNION ALL
SELECT 'ventas', COUNT(*)
FROM ventas;
```

En el conjunto de práctica analizado, `ventas` contiene **10 registros**.

### 5. Ejecutar las consultas de M4 y M5

1. Abrir `m4_consultas_negocio.sql`.
2. Confirmar que la consulta utilice `ventas_tech_db`.
3. Ejecutar el archivo completo o seleccionar una consulta y presionar **F5**.
4. Revisar las tablas de resultados y la pestaña **Mensajes**.
5. Repetir el procedimiento con `m5_consultas_joins.sql`.

Para establecer la base activa en una ventana de consulta:

```sql
USE ventas_tech_db;
GO
```

`GO` separa lotes de instrucciones en herramientas como SSMS; no forma parte del lenguaje T-SQL que ejecuta el motor.

## Indicadores y consultas de negocio

| Indicador o consulta | Cálculo o criterio | Interpretación |
| --- | --- | --- |
| Importe de un pedido | `cantidad * precio_unitario` | Valor del registro, usando el precio guardado en la venta. |
| Facturación total | `SUM(cantidad * precio_unitario)` | Suma de los importes del grupo analizado. |
| Cantidad de pedidos | `COUNT(*)` | Cantidad de filas, bajo el supuesto de un pedido por fila. |
| Ticket promedio | `AVG(cantidad * precio_unitario)` | Importe promedio por pedido en este modelo. |
| Unidades vendidas | `SUM(cantidad)` | Volumen vendido de cada producto. |
| Ranking de productos | `TOP 5` ordenado por facturación descendente | Cinco productos con mayor facturación; los empates se ordenan por identificador. |
| Clientes recurrentes | `GROUP BY id_cliente HAVING COUNT(*) > 1` | Clientes con más de un pedido en los datos disponibles. |
| Comparación mensual | CTE con totales mensuales y `CASE` | Clasifica cada mes respecto del promedio de los totales mensuales. |

El uso de `v.precio_unitario` conserva el precio registrado en la operación. Para reproducir el importe histórico de una venta, no corresponde sustituirlo por un precio actual del catálogo.

## Resultados del conjunto de práctica

El archivo de M4 identifica el período analizado como **marzo de 2024**. Los resultados compartidos muestran:

| Indicador | Resultado |
| --- | ---: |
| Facturación total | 6.444,00 |
| Cantidad de pedidos | 10 |
| Ticket promedio | 644,40 |
| Meses con ventas en el conjunto analizado | 1 |

El ranking por facturación es el siguiente:

| ID de producto | Unidades vendidas | Facturación | Participación en la facturación total |
| --- | ---: | ---: | ---: |
| 1 | 3 | 3.600,00 | 55,87 % |
| 3 | 3 | 1.350,00 | 20,95 % |
| 5 | 3 | 390,00 | 6,05 % |
| 6 | 4 | 380,00 | 5,90 % |
| 2 | 13 | 364,00 | 5,65 % |

Los porcentajes se calculan sobre 6.444,00 y se redondean a dos decimales. Estos valores corresponden al conjunto de práctica revisado; si los datos cambian, los resultados también pueden cambiar.

## Tres hallazgos comerciales revisados

1. **Los productos 1 y 3 concentran el 76,82 % de la facturación.** Generan 4.950,00 en conjunto. Identifico una concentración relevante que merece seguimiento; para decidir acciones de disponibilidad o diversificación, revisaría el historial de ventas, los márgenes y las existencias.

2. **El producto 2 lidera las unidades vendidas dentro del TOP 5, con un aporte de facturación del 5,65 %.** Sus 13 unidades generan 364,00. Su importe promedio por unidad es 28,00, frente a 1.200,00 del producto 1. Evaluaría su función comercial y su margen antes de proponer promociones o ventas complementarias. El ranking mostrado no permite afirmar que sea el más vendido en unidades de todo el catálogo.

3. **El TOP 5 reúne el 94,41 % de la facturación total.** Los cinco productos suman 6.084,00 y los productos restantes aportan 360,00, equivalentes al 5,59 %. Agregaría una revisión de estos últimos para distinguir entre baja demanda, menor disponibilidad, incorporación reciente o menor precio. Los resultados actuales no permiten determinar cuál de esas explicaciones corresponde.cuál fue el ticket promedio de cada mes? | `MONTH`, `SUM`, `COUNT`, `AVG`, `CAST`, `GROUP BY`. |
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
