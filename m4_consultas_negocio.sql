
-- ==================================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- ==================================================
SELECT 
	MONTH(fecha_venta) AS mes, 
	SUM(cantidad * precio_unitario) AS total_facturado, 
	COUNT(*) AS cantidad_pedidos, 
	CAST(AVG(cantidad * precio_unitario) AS DECIMAL(18,2)) AS ticket_promedio -
FROM ventas 
GROUP BY MONTH(fecha_venta) 
ORDER BY mes; 

-- ==================================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- ==================================================
SELECT TOP 5
	id_producto,
	SUM(cantidad) AS unidades_vendidas,
	SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto 
ORDER BY total_facturado DESC, id_producto ASC; 

-- ==================================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- ==================================================
SELECT 
	id_cliente,
	COUNT(*) AS cantidad_pedidos, 
	SUM(cantidad * precio_unitario) AS total_gastado
FROM VENTAS
GROUP BY id_cliente 
HAVING COUNT(*) > 1 
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
) 

SELECT
	mes,
	total_facturado,
	CASE
		WHEN total_facturado > (
			SELECT
				AVG(total_facturado) 
			FROM facturacion_mensual
		) THEN N'Por encima'

		WHEN total_facturado < (
			SELECT 
				AVG(total_facturado) 
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
