# coder-data-analyst-sql

# SQL Server — Base de datos de ventas tecnológicas

Tercera entrega del curso de SQL de Coderhouse, realizada como parte
de mi formación en Data Analytics.

El proyecto implementa una base de datos de ejemplo para registrar
categorías, clientes, productos y ventas de una tienda tecnológica.

## Archivo principal

`ventas_tech_db.sql` contiene cuatro secciones:

1. Eliminación de tablas existentes.
2. Creación de tablas y restricciones.
3. Inserción de datos de ejemplo.
4. Validación del contenido y de los conteos.

## Tablas y registros esperados

| Tabla | Contenido | Registros |
|---|---|---:|
| categorias | Categorías de productos | 4 |
| clientes | Datos de clientes | 5 |
| productos | Productos, precios y stock | 6 |
| ventas | Registros de ventas | 10 |

## Relaciones

- Cada producto puede estar asociado a una categoría.
- Cada registro de venta puede estar asociado a un cliente y a un producto.
- Las claves foráneas verifican que los identificadores informados
  existan en sus tablas de referencia.

## Cómo ejecutar el proyecto

1. Descargar o clonar este repositorio.
2. Abrir SSMS y conectarse a una instancia de SQL Server.
3. Crear una base de datos llamada `ventas_tech_db`, si no existe.
4. Abrir el archivo `ventas_tech_db.sql`.
5. Verificar que el script utilice la base `ventas_tech_db`.
6. Ejecutar el archivo completo con F5, sin seleccionar un fragmento.
7. Revisar que la pestaña Mensajes no muestre errores.
8. Comprobar los resultados de la sección de validación.

## Validación

La sección 4 muestra los registros de las cuatro tablas con
`SELECT *` 

los valores esperados: 4 categorías, 5 clientes, 6 productos y 10 ventas.

## Reejecución

El script elimina las cuatro tablas y las recrea con los datos
de ejemplo en cada ejecución.

Esto permite repetir el ejercicio sin acumular registros.
Los datos adicionales cargados en esas tablas se eliminan.

## Autor

Iván Pugliese.
