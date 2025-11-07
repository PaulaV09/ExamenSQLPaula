-- 1. Productos más vendidos (pizza, panzarottis, bebidas, etc.)
SELECT 
    p.nombreProducto AS Producto,
    SUM(pp.cantidadPedidoProducto) AS TotalVendidos
FROM PedidosProductos pp
JOIN Productos p ON pp.idProducto = p.idProducto
GROUP BY p.nombreProducto
ORDER BY TotalVendidos DESC;

-- 2. Total de ingresos generados por cada combo
SELECT 
    c.nombreCombo AS Combo,
    SUM(pc.cantidadPedidoCombo * c.precioCombo) AS IngresosTotales
FROM PedidosCombos pc
JOIN Combos c ON pc.idCombo = c.idCombo
GROUP BY c.nombreCombo
ORDER BY IngresosTotales DESC;

-- 3. Pedidos realizados para recoger vs. comer en la pizzería
SELECT 
    CASE WHEN isRecoger = 1 THEN 'Para recoger' ELSE 'En el lugar' END AS TipoPedido,
    COUNT(*) AS TotalPedidos
FROM Pedidos
GROUP BY isRecoger;

-- 4. Adiciones más solicitadas en pedidos personalizados
SELECT 
    a.nombreAdicion,
    SUM(pa.cantidadPedidoAdicion) AS TotalSolicitudes
FROM PedidosAdiciones pa
JOIN Adiciones a ON pa.idAdicion = a.idAdicion
GROUP BY a.nombreAdicion
ORDER BY TotalSolicitudes DESC;

-- 5. Cantidad total de productos vendidos por categoría
SELECT 
    tp.nombreTipoProducto AS Categoria,
    SUM(pp.cantidadPedidoProducto) AS TotalVendidos
FROM PedidosProductos pp
JOIN Productos p ON pp.idProducto = p.idProducto
JOIN TipoProducto tp ON p.idTipoProducto = tp.idTipoProducto
GROUP BY tp.nombreTipoProducto;

-- 6. Promedio de pizzas pedidas por cliente
SELECT 
    c.nombresClientes,
    AVG(pp.cantidadPedidoProducto) AS PromedioPizzas
FROM PedidosProductos pp
JOIN Productos p ON pp.idProducto = p.idProducto
JOIN TipoProducto tp ON p.idTipoProducto = tp.idTipoProducto
JOIN Pedidos pe ON pp.idPedido = pe.idPedido
JOIN Clientes c ON pe.idCliente = c.idCliente
WHERE tp.nombreTipoProducto = 'Pizzas'
GROUP BY c.idCliente;

-- 7. Total de ventas por día de la semana (si se tuviera una columna fecha)
SELECT 
    DAYNAME(fechaPedido) AS DiaSemana,
    SUM(precioPedidoTotal) AS VentasTotales
FROM Pedidos
GROUP BY DiaSemana
ORDER BY VentasTotales DESC;

-- 8. Cantidad de panzarottis vendidos con extra queso
SELECT 
    SUM(pp.cantidadPedidoProducto) AS TotalPanzarottisExtraQueso
FROM PedidosProductos pp
JOIN Productos p ON pp.idProducto = p.idProducto
JOIN TipoProducto tp ON p.idTipoProducto = tp.idTipoProducto
JOIN PedidosAdiciones pa ON pa.idPedido = pp.idPedido
JOIN Adiciones a ON pa.idAdicion = a.idAdicion
WHERE tp.nombreTipoProducto = 'Panzarottis'
  AND a.nombreAdicion LIKE '%queso%';

-- 9. Pedidos que incluyen bebidas como parte de un combo
SELECT DISTINCT pc.idPedido
FROM PedidosCombos pc
JOIN ProductosCombos pco ON pc.idCombo = pco.idCombo
JOIN Productos p ON pco.idProducto = p.idProducto
JOIN TipoProducto tp ON p.idTipoProducto = tp.idTipoProducto
WHERE tp.nombreTipoProducto = 'Bebidas';

-- 10. Clientes que han realizado más de 5 pedidos en el último mes
SELECT 
    c.nombresClientes,
    COUNT(p.idPedido) AS TotalPedidos
FROM Pedidos p
JOIN Clientes c ON p.idCliente = c.idCliente
WHERE p.fechaPedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.idCliente
HAVING TotalPedidos > 5;

-- 11. Ingresos totales generados por productos no elaborados
SELECT 
    SUM(pp.cantidadPedidoProducto * pr.precioProducto) AS TotalIngresosNoElaborados
FROM PedidosProductos pp
JOIN Productos pr ON pp.idProducto = pr.idProducto
JOIN TipoProducto tp ON pr.idTipoProducto = tp.idTipoProducto
WHERE tp.nombreTipoProducto IN ('Bebidas','Postres','Otros productos no elaborados');

-- 12. Promedio de adiciones por pedido
SELECT 
    AVG(cantidadAdiciones) AS PromedioAdiciones
FROM (
    SELECT 
        idPedido,
        SUM(cantidadPedidoAdicion) AS cantidadAdiciones
    FROM PedidosAdiciones
    GROUP BY idPedido
) AS sub;

-- 13. Total de combos vendidos en el último mes
SELECT 
    SUM(pc.cantidadPedidoCombo) AS TotalCombosVendidos
FROM PedidosCombos pc
JOIN Pedidos p ON pc.idPedido = p.idPedido
WHERE p.fechaPedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 14. Clientes con pedidos tanto para recoger como para consumir en el lugar
SELECT 
    c.idCliente,
    c.nombresClientes,
    COUNT(DISTINCT p.isRecoger) AS TiposPedidos
FROM Pedidos p
JOIN Clientes c ON p.idCliente = c.idCliente
GROUP BY c.idCliente
HAVING TiposPedidos = 2;

-- 15. Total de productos personalizados con adiciones
SELECT 
    COUNT(DISTINCT pa.idPedido) AS TotalPedidosConAdiciones
FROM PedidosAdiciones pa;

-- 16. Pedidos con más de 3 productos diferentes
SELECT 
    p.idPedido,
    COUNT(DISTINCT pp.idProducto) AS ProductosDiferentes
FROM PedidosProductos pp
JOIN Pedidos p ON pp.idPedido = p.idPedido
GROUP BY p.idPedido
HAVING ProductosDiferentes > 3;

-- 17. Promedio de ingresos generados por día
SELECT 
    fechaPedido,
    SUM(precioPedidoTotal) / COUNT(DISTINCT fechaPedido) AS PromedioDiario
FROM Pedidos
GROUP BY fechaPedido;

-- 18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
SELECT 
    c.nombresClientes,
    COUNT(DISTINCT p.idPedido) AS TotalPedidos,
    SUM(CASE WHEN tp.nombreTipoProducto = 'Pizzas' AND pa.idPedido IS NOT NULL THEN 1 ELSE 0 END) AS PedidosPizzasConAdiciones
FROM Pedidos p
JOIN Clientes c ON p.idCliente = c.idCliente
LEFT JOIN PedidosProductos pp ON p.idPedido = pp.idPedido
LEFT JOIN Productos pr ON pp.idProducto = pr.idProducto
LEFT JOIN TipoProducto tp ON pr.idTipoProducto = tp.idTipoProducto
LEFT JOIN PedidosAdiciones pa ON p.idPedido = pa.idPedido
GROUP BY c.idCliente
HAVING (PedidosPizzasConAdiciones / TotalPedidos) > 0.5;

-- 19. Porcentaje de ventas provenientes de productos no elaborados
SELECT 
    ROUND(
        (SUM(CASE WHEN tp.nombreTipoProducto IN ('Bebidas','Postres','Otros productos no elaborados') 
             THEN pr.precioProducto * pp.cantidadPedidoProducto ELSE 0 END)
        / SUM(pr.precioProducto * pp.cantidadPedidoProducto)) * 100, 2
    ) AS PorcentajeNoElaborados
FROM PedidosProductos pp
JOIN Productos pr ON pp.idProducto = pr.idProducto
JOIN TipoProducto tp ON pr.idTipoProducto = tp.idTipoProducto;

-- 20. Día de la semana con mayor número de pedidos para recoger
SELECT 
    DAYNAME(fechaPedido) AS DiaSemana,
    COUNT(*) AS TotalPedidosRecoger
FROM Pedidos
WHERE isRecoger = 1
GROUP BY DiaSemana
ORDER BY TotalPedidosRecoger DESC
LIMIT 1;
