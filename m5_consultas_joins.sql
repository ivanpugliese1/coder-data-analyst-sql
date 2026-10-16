-- -------------------------------------------------
-- Un cliente y un producto sin ventas, para que el
-- LEFT JOIN ... IS NULL tenga casos que detectar.
-- -------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = 6)
    INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (6, 'Sofía Díaz', 'sofia@mail.com', 'La Plata', '2024-03-20');

IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = 7)
    INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
    VALUES (7, 'Webcam Full HD', 2, 75.00, 20, 1);
GO


-- Consulta 1: VISTA BASE (INNER JOIN)
-- Propósito: cruzar ventas con clientes, productos y categorías en una sola fila por venta.
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
-- Hallazgo: las 10 ventas cruzaron sin perder ninguna; Computación concentra el 76,8 % de la facturación (4.950 de 6.444) y Buenos Aires es la ciudad que más venta tiene en base a dinero (2.640, 41 %)


-- Consulta 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca compraron, para que CRM los contacte.
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de los 6 clientes registrados nunca compró (Sofía Díaz, registrada el 20/03/2024, después de la última venta cargada); CRM puede iniciar con ella una campaña de primera compra.


-- Consulta 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Propósito: identificar artículos del catálogo sin movimiento, para que Producto decida qué hacer con ellos.
SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de los 7 productos del catálogo no tiene ventas (Webcam Full HD, Accesorios, precio 75,00); Producto debería revisar su precio, su visibilidad o la conveniencia de mantener 20 unidades en stock.


-- Consulta 4: CONSOLIDADO POR CANAL (UNION ALL)
-- Propósito: comparar la facturación de dos períodos de marzo de 2024.
SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Periodo A (05-10 mar)' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Periodo B (11-15 mar)' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;
-- Hallazgo: el Periodo A factura 3.620 contra 2.824 del Periodo B (56,2 % del total); la diferencia se explica sobre todo por una única venta de 2 laptops por 2.400 el 05/03.