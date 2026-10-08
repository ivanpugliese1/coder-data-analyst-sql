
-- ==================================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- ==================================================
SELECT 
	MONTH(fecha_venta) AS mes, --> Extrae el número de mes de cada fecha.
	SUM(cantidad * precio_unitario) AS total_facturado, --> En este caso especifico, dentro de cada grupo se suman los importes de cada pedido.
	COUNT(*) AS cantidad_pedidos, --> Cuenta las filas.
	CAST(AVG(cantidad * precio_unitario) AS DECIMAL(18,2)) AS ticket_promedio --> Calculamos el promedio de los importes de los pedidos y los CASTEAMOS a 2 decimales
FROM ventas -- ¿De donde salen los datos? --> de la tabla de ventas.
GROUP BY MONTH(fecha_venta) --> Agrupa las ventas que tengan el mismo número de mes, por ejemplo, junta todos los pedidos de marzo y calcula sus metricas en conjunto. UN RESUTADO POR GRUPO Y NO CADA FILA INDIVIDUAL.
ORDER BY mes; --> Ordena de menor a mayor, por mes en este caso.

-- ==================================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- ==================================================
SELECT TOP 5
	id_producto,
	SUM(cantidad) AS unidades_vendidas,
	SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto --> Reune las ventas de cada producto, por ejemplo: el producto 1 aparece en dos ventas (la 1 y la 7), luego de agrupar suma las unidades y el total facturado de ambas ventas.
ORDER BY total_facturado DESC, id_producto ASC; --> El DESC ordena desde el que mas facturo hasta el que menos facturo, con el ASC en el id_producto resuelve la cuestion de que dos productos facturen lo mismo, aparecera el de menor ID.

-- ==================================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- ==================================================
SELECT 
	id_cliente,
	COUNT(*) AS cantidad_pedidos, --> Cuento cuantos pedidos pertenecen a cada cliente.
	SUM(cantidad * precio_unitario) AS total_gastado
FROM VENTAS
GROUP BY id_cliente --> Agrupo todos los pedidos de cada cliente.
HAVING COUNT(*) > 1 --> De todos los grupos que formaste, conserva unicamente los que tengan mas de un pedido. Se usa siempre despues de agrupar. 
ORDER BY total_gastado DESC, id_cliente ASC;

-- ==================================================
-- CONSULTA 4 - MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO
-- ==================================================
WITH facturacion_mensual AS (
	SELECT 
		MONTH(fecha_venta) AS mes,
		SUM(cantidad * precio_unitario) AS total_facturado
	FROM ventas
	GROUP BY MONTH(fecha_venta)
) --> En este bloque construimos el resumen mensual para poder consultarlo en la siguiente instruccion.

SELECT
	mes,
	total_facturado,
	CASE
		WHEN total_facturado > (
			SELECT
				AVG(total_facturado) --> Aca devolvemos el promedio de los totales mensuales de "facturacion_mensual"
			FROM facturacion_mensual
		) THEN N'Por encima'

		WHEN total_facturado < (
			SELECT 
				AVG(total_facturado) --> Aca devolvemos el promedio de los totales mensuales de "facturacion_mensual"
			FROM facturacion_mensual
		) THEN N'Por debajo'

		ELSE N'Igual al promedio'
	END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;

-- ==================================================
-- BLOQUE DE CIERRE - TRES HALLAZGOS DE NEGOCIO
-- ==================================================

-- 1. Marzo de 2024 registra 10 pedidos, una facturación de 6444.00 y un ticket promedio de 644.40. Es el único mes con ventas en la base.

-- 2. El producto 1 lidera la facturación con 3600.00 y 3 unidades vendidas. Representa aproximadamente el 55.87% de la facturación total. (Sale de dividir 3.600 por 6.444 * 100)

-- 3. Los 5 clientes tienen 2 pedidos cada uno y cumplen el criterio de recurrencia. El cliente 1 lidera el gasto acumulado con 2640.00.