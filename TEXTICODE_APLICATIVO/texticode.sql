-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-03-2026 a las 00:43:00
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `texticode`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobantes`
--

CREATE TABLE `comprobantes` (
  `Id_Comprobante` int(11) NOT NULL COMMENT 'Identificador único del comprobante.',
  `Id_Usuario` int(11) NOT NULL COMMENT 'Persona que crea el comprobante',
  `Id_Orden` int(11) NOT NULL COMMENT 'Numero de orden',
  `Estado` enum('Entregado','Pendiente') NOT NULL DEFAULT 'Pendiente' COMMENT 'Estado del comprobante',
  `Fecha_Limite` date DEFAULT current_timestamp() COMMENT 'Fecha de generación del comprobante. No debe ser pasada.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla que gestiona los comprobantes generados en el sistema.';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `material`
--

CREATE TABLE `material` (
  `Id_Producto` int(11) NOT NULL COMMENT 'Identificador único del producto',
  `Nombre_Producto` varchar(100) NOT NULL COMMENT 'Nombre del producto',
  `Categoria` varchar(80) NOT NULL COMMENT 'Categoría del producto',
  `Stock_Actual` int(11) NOT NULL DEFAULT 0 COMMENT 'Cantidad actual disponible en inventario',
  `Unidad` varchar(30) NOT NULL COMMENT 'Unidad de medida del producto (metros, unidades, etc.)',
  `Stock_Minimo` int(11) NOT NULL DEFAULT 0 COMMENT 'No puede ser menor a 0',
  `Stock_Maximo` int(11) NOT NULL DEFAULT 0 COMMENT 'Cantidad máxima permitida en inventario',
  `Fecha` datetime DEFAULT current_timestamp() COMMENT 'Fecha de generación del comprobante. Debe ser actual.' CHECK (`Stock_Minimo` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla que almacena los productos registrados en el sistema';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden_material`
--

CREATE TABLE `orden_material` (
  `Id_Orden` int(11) NOT NULL COMMENT 'Id de la Orden',
  `Id_Producto` int(11) NOT NULL COMMENT 'Id del producto',
  `Cantidad_Usada` int(11) NOT NULL COMMENT 'Cantidad usada en la orden'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla puente';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden_produccion`
--

CREATE TABLE `orden_produccion` (
  `Id_Orden` int(11) NOT NULL COMMENT 'Identificador único de la orden de producción',
  `Id_Cliente` int(11) NOT NULL COMMENT 'Cliente que solicita la orden',
  `Id_Producto` int(11) NOT NULL COMMENT 'Producto a fabricar',
  `Cantidad` int(11) NOT NULL COMMENT 'Cantidad a producir',
  `Prioridad` enum('Baja','Media','Alta') NOT NULL DEFAULT 'Media' COMMENT 'Nivel de prioridad',
  `Fecha_Limite` date NOT NULL COMMENT 'La fecha no puede ser anterior al dia vigente',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del producto',
  `Estado` enum('En Proceso','Completada','Cancelada') NOT NULL DEFAULT 'En Proceso' COMMENT 'Estado de la orden' CHECK (`Cantidad` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla que almacena las órdenes de producción';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `Id_Rol` int(11) NOT NULL,
  `Nombre_Rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `Id_Usuario` int(11) NOT NULL COMMENT 'Identificador único del usuario',
  `Id_Rol` int(11) NOT NULL COMMENT 'Rol asignado al usuario (clave foránea)',
  `Nombre_Completo` varchar(100) NOT NULL COMMENT 'Nombre completo del usuario',
  `Nombre_Usuario` varchar(50) NOT NULL COMMENT 'Nombre de usuario para iniciar sesión',
  `Correo` varchar(120) NOT NULL COMMENT 'Correo electrónico del usuario',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Número de teléfono del usuario',
  `Direccion` varchar(150) DEFAULT NULL COMMENT 'Dirección de residencia del usuario',
  `Estado` enum('activo','inactivo') NOT NULL DEFAULT 'activo' COMMENT 'Usuarios dispobibles',
  `Contrasena` varchar(255) NOT NULL COMMENT 'Contraseña del usuario (almacenada encriptada)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla que almacena los usuarios del sistema y su rol asociado';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_orden`
--

CREATE TABLE `usuario_orden` (
  `Id_Usuario` int(11) NOT NULL COMMENT 'Id del Usuario',
  `Id_Orden` int(11) NOT NULL COMMENT 'Id de la Orden',
  `Funcion` varchar(50) DEFAULT NULL COMMENT 'Funcionalidad de la orden'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD PRIMARY KEY (`Id_Comprobante`),
  ADD KEY `Id_Usuario` (`Id_Usuario`),
  ADD KEY `Id_Orden` (`Id_Orden`);

--
-- Indices de la tabla `material`
--
ALTER TABLE `material`
  ADD PRIMARY KEY (`Id_Producto`),
  ADD UNIQUE KEY `Nombre_Producto` (`Nombre_Producto`);

--
-- Indices de la tabla `orden_material`
--
ALTER TABLE `orden_material`
  ADD PRIMARY KEY (`Id_Orden`,`Id_Producto`),
  ADD KEY `Id_Producto` (`Id_Producto`);

--
-- Indices de la tabla `orden_produccion`
--
ALTER TABLE `orden_produccion`
  ADD PRIMARY KEY (`Id_Orden`),
  ADD KEY `Id_Cliente` (`Id_Cliente`),
  ADD KEY `Id_Producto` (`Id_Producto`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`Id_Rol`),
  ADD UNIQUE KEY `Nombre_Rol` (`Nombre_Rol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`Id_Usuario`),
  ADD UNIQUE KEY `Nombre_Usuario` (`Nombre_Usuario`),
  ADD UNIQUE KEY `Correo` (`Correo`),
  ADD KEY `Id_Rol` (`Id_Rol`);

--
-- Indices de la tabla `usuario_orden`
--
ALTER TABLE `usuario_orden`
  ADD PRIMARY KEY (`Id_Usuario`,`Id_Orden`),
  ADD KEY `Id_Orden` (`Id_Orden`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  MODIFY `Id_Comprobante` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único del comprobante.';

--
-- AUTO_INCREMENT de la tabla `material`
--
ALTER TABLE `material`
  MODIFY `Id_Producto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único del producto';

--
-- AUTO_INCREMENT de la tabla `orden_produccion`
--
ALTER TABLE `orden_produccion`
  MODIFY `Id_Orden` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único de la orden de producción';

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `Id_Rol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único del usuario';

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD CONSTRAINT `comprobantes_ibfk_1` FOREIGN KEY (`Id_Usuario`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `comprobantes_ibfk_2` FOREIGN KEY (`Id_Orden`) REFERENCES `orden_produccion` (`Id_Orden`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `orden_material`
--
ALTER TABLE `orden_material`
  ADD CONSTRAINT `orden_material_ibfk_1` FOREIGN KEY (`Id_Orden`) REFERENCES `orden_produccion` (`Id_Orden`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orden_material_ibfk_2` FOREIGN KEY (`Id_Producto`) REFERENCES `material` (`Id_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `orden_produccion`
--
ALTER TABLE `orden_produccion`
  ADD CONSTRAINT `orden_produccion_ibfk_1` FOREIGN KEY (`Id_Cliente`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orden_produccion_ibfk_2` FOREIGN KEY (`Id_Producto`) REFERENCES `material` (`Id_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`Id_Rol`) REFERENCES `rol` (`Id_Rol`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_orden`
--
ALTER TABLE `usuario_orden`
  ADD CONSTRAINT `usuario_orden_ibfk_1` FOREIGN KEY (`Id_Usuario`) REFERENCES `usuario` (`Id_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuario_orden_ibfk_2` FOREIGN KEY (`Id_Orden`) REFERENCES `orden_produccion` (`Id_Orden`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
