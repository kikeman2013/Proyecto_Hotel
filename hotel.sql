-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 07-06-2019 a las 14:36:57
-- Versión del servidor: 5.7.24
-- Versión de PHP: 7.2.14

SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: "hotel"
--
CREATE DATABASE IF NOT EXISTS "hotel" DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE hotel;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `actualizar_estancia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_estancia` (IN `nombre_old` VARCHAR(255), IN `id_hab_old` INT, IN `nombre` VARCHAR(255), IN `id_hab` INT, IN `dias` INT)  BEGIN
	DECLARE exit handler for sqlexception
  	BEGIN
    		rollback;
  	END; 
    START TRANSACTION; 
	SELECT cli_id INTO @idcliold FROM cliente WHERE cli_nombre LIKE nombre_old;
    SELECT cli_id INTO @idcli FROM cliente WHERE cli_nombre LIKE nombre;
    IF EXISTS (SELECT * FROM estancia WHERE (cli_id = @idcliold)AND(hab_codigo = id_hab_old))THEN
    
    SELECT th.tip_hab_descripcion INTO @tipohab FROM tipo_habitacion as th
    LEFT JOIN habitacion AS h ON (h.tip_hab_codigo = th.tip_hab_codigo)
    WHERE(h.hab_codigo = id_hab);	
    
    SELECT consultar_precio(@tipohab , dias) INTO @total;
    
    SET @horas = dias*24;
    SELECT ADDDATE(CURDATE(), INTERVAL @horas DAY_HOUR) INTO @salida;
    
    UPDATE estancia
    SET cli_id = @idcli , hab_codigo = id_hab , est_fechasalida = @salida ,est_total = @total
    WHERE(cli_id = @idcliold)AND(hab_codigo = id_hab_old);
   
   
     UPDATE habitacion
   set hab_disponible = 'disponible'
   WHERE hab_codigo = id_hab_old;
   
    UPDATE habitacion
   set hab_disponible = 'NO disponible'
   WHERE hab_codigo = id_hab;
 ELSE
 	UPDATE habitacion
    SET hab_disponible = null;
   END IF;  
   COMMIT;
END$$

DROP PROCEDURE IF EXISTS `actualizar_mobiliario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_mobiliario` (IN `nombre` VARCHAR(255), IN `precio` INT, IN `codigo` INT)  BEGIN
	DECLARE exit handler for sqlexception
  	BEGIN
    		rollback;
  	END; 
    START TRANSACTION;
    
    IF EXISTS(SELECT * 
    FROM mobiliario 
    WHERE mob_codigo = codigo ) THEN
		UPDATE mobiliario
        SET mob_nombre = nombre, mob_precio = precio
        WHERE mob_codigo = codigo;
    ELSE
    	UPDATE mobiliario
        SET mob_nombre = null
        WHERE mob_codigo = codigo;
    END IF;
    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `actualizar_sesion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_sesion` (`cadena` VARCHAR(255))  BEGIN
    	UPDATE sesiones
        SET ses_ultima_actividad = NOW()
        WHERE ses_cadena like cadena;
              
	END$$

DROP PROCEDURE IF EXISTS `actualizar_usuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_usuario` (IN `nombre` VARCHAR(255), IN `pwd` CHAR(32), IN `id` INT)  BEGIN
	DECLARE exit handler for sqlexception
  	BEGIN
    		rollback;
  	END;    
    START TRANSACTION;    
    IF EXISTS(SELECT * 
    FROM usuarios 
    WHERE usr_id = id) THEN	
	IF (pwd LIKE 'vacio')  THEN
     	SELECT usr_pwd INTO @pwd FROM usuarios WHERE (usr_id = id);
        UPDATE usuarios
        SET usr_login = nombre , usr_pwd = @pwd
        WHERE usr_id = id;
	ELSE 
		UPDATE usuarios
        	SET usr_login = nombre , usr_pwd = pwd
        	WHERE usr_id = id;
	END IF;
    ELSE
    	UPDATE usuarios
        SET usr_login = null
        WHERE usr_id = id;       
    END IF;
    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `agregar_habitacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_habitacion` (`tipo` VARCHAR(255))  BEGIN
	SELECT tip_hab_codigo into @tipoid FROM tipo_habitacion WHERE tip_hab_descripcion like tipo;
	INSERT INTO habitacion(ho_codigo , tip_hab_codigo) VALUES (1 , @tipoid);
END$$

DROP PROCEDURE IF EXISTS `agregar_habmob`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_habmob` (`idhab` INT, `nombremob` VARCHAR(255))  BEGIN
	SELECT mob_codigo into @mobid FROM mobiliario WHERE mob_nombre like nombremob ;
	INSERT INTO habitacion_mobiliario(hab_codigo , mob_codigo) VALUES (idhab , @mobid);
END$$

DROP PROCEDURE IF EXISTS `eliminar_estancia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_estancia` (`nombre_cli` VARCHAR(255), `id_hab` INT, `fechallegada` DATETIME)  BEGIN
	SELECT cli_id INTO @idcli FROM cliente WHERE cli_nombre LIKE nombre_cli;
    DELETE FROM estancia
    WHERE(cli_id = @idcli )AND(hab_codigo = id_hab)AND(est_fechallegada = fechallegada);
    UPDATE habitacion
    SET hab_disponible = 'disponible'
    WHERE hab_codigo = id_hab;
    
END$$

DROP PROCEDURE IF EXISTS `eliminar_habitacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_habitacion` (`codigo` INT)  BEGIN
	IF EXISTS(SELECT * 
    FROM habitacion_mobiliario 
    WHERE hab_codigo = codigo) THEN
    	DELETE FROM habitacion_mobiliario WHERE hab_codigo = codigo;		   
 END IF;    
    IF EXISTS(SELECT * 
    FROM habitacion 
    WHERE hab_codigo = codigo) THEN
    DELETE FROM habitacion WHERE hab_codigo = codigo;
 END IF;
END$$

DROP PROCEDURE IF EXISTS `eliminar_habmob`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_habmob` (`codigo` INT, `nombremob` VARCHAR(255))  BEGIN
	SELECT mob_codigo into @mobid FROM mobiliario WHERE mob_nombre like nombremob;
	IF EXISTS(SELECT * 
    FROM habitacion_mobiliario 
    WHERE (hab_codigo = codigo)AND(mob_codigo = @mobid) ) THEN
    	DELETE FROM habitacion_mobiliario WHERE (hab_codigo = codigo)AND(mob_codigo = @mobid);		   
 END IF;    
END$$

DROP PROCEDURE IF EXISTS `eliminar_mobiliario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_mobiliario` (`codigo` INT)  BEGIN
	IF EXISTS(SELECT * 
    FROM mobiliario 
    WHERE mob_codigo = codigo) THEN
    	DELETE FROM habitacion_mobiliario WHERE mob_codigo = codigo;
		DELETE FROM mobiliario WHERE mob_codigo = codigo;   
    END IF;
END$$

DROP PROCEDURE IF EXISTS `eliminar_usuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_usuario` (IN `id` INT)  BEGIN
	IF EXISTS(SELECT * 
    FROM roles_usuarios 
    WHERE usr_id = id) THEN
    	DELETE FROM roles_usuarios WHERE usr_id =id;
    END IF;
    IF EXISTS(SELECT * 
    FROM usuarios 
    WHERE usr_id = id)THEN
   	 DELETE FROM usuarios WHERE usr_id=id;
     END IF;
END$$

DROP PROCEDURE IF EXISTS `fin_sesion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fin_sesion` (`cadena` VARCHAR(255))  BEGIN
    	UPDATE sesiones
        SET ses_fin = NOW()
        WHERE ses_cadena like cadena;
              
	END$$

DROP PROCEDURE IF EXISTS `nueva_sesion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `nueva_sesion` (IN `cadena` VARCHAR(255), IN `ip` VARCHAR(255), IN `so` VARCHAR(255), IN `usuario` VARCHAR(255))  BEGIN
SELECT usr_id INTO @idusr FROM usuarios WHERE usr_login LIKE usuario;
    	INSERT INTO	sesiones(ses_cadena,ses_inicio,ses_ultima_actividad,ses_ip,ses_so,usr_id)      
         VALUES(cadena,NOW(),NOW(), ip , so , @idusr);
              
	END$$

DROP PROCEDURE IF EXISTS `registrar_estancia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_estancia` (IN `nombre_cli` VARCHAR(255), IN `apellido_cli` VARCHAR(255), IN `dias` INT, IN `id_hab` INT)  BEGIN
    IF NOT EXISTS (SELECT * FROM cliente WHERE (cli_nombre LIKE nombre_cli)AND(cli_apellido LIKE apellido_cli))THEN
    
    INSERT INTO cliente (cli_nombre , cli_apellido , tip_cli_codigo )
    VALUES(nombre_cli , apellido_cli , 1);
    END IF;
    
    SELECT cli_id INTO @idcli FROM cliente
    WHERE(cli_nombre LIKE nombre_cli)AND(cli_apellido LIKE apellido_cli);
     
    SET @horas = dias*24;
    SELECT ADDDATE(CURDATE(), INTERVAL @horas DAY_HOUR) INTO @salida;

	SELECT th.tip_hab_descripcion INTO @tipohab FROM tipo_habitacion as th
    LEFT JOIN habitacion AS h ON (h.tip_hab_codigo = th.tip_hab_codigo)
    WHERE(h.hab_codigo = id_hab);
		
    SELECT consultar_precio(@tipohab , dias) INTO @total;

		
    INSERT INTO estancia(est_fechallegada , est_fechasalida , cli_id , hab_codigo , est_total)VALUES (NOW(),@salida , @idcli , id_hab,@total);
    
    UPDATE habitacion 
    SET hab_disponible='No disponible'
    WHERE hab_codigo = id_hab;
    
END$$

DROP PROCEDURE IF EXISTS `registrar_mobiliario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_mobiliario` (`nombre` VARCHAR(255), `precio` VARCHAR(255))  BEGIN
    INSERT INTO mobiliario(mob_nombre ,  mob_precio)VALUES
    		(nombre , precio);
            
END$$

DROP PROCEDURE IF EXISTS `registrar_usuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_usuario` (`nombre` VARCHAR(255), `pwd` CHAR(32), `tipo` VARCHAR(255), `cadena` VARCHAR(255))  BEGIN
	SELECT rol_id INTO @idrol FROM roles WHERE rol_nombre like tipo;
	SELECT ses_id INTO @idses FROM sesiones WHERE ses_cadena like cadena;
    INSERT INTO usuarios(usr_login , usr_pwd , usr_fcreacion , ses_id)VALUES
    		(nombre , pwd , NOW() , @idses);
            
    SELECT usr_id INTO @idusr FROM usuarios WHERE (usr_login like nombre) AND (usr_pwd like pwd);   
    
    INSERT INTO roles_usuarios(rol_id , usr_id , ru_fecha , ses_id)VALUES
    		(@idrol , @idusr , NOW() , @idses);
END$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `consultar_precio`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `consultar_precio` (`tipo_habitacion` VARCHAR(255), `dias` INT) RETURNS INT(11) BEGIN
    	SELECT tip_hab_codigo INTO @idhab FROM tipo_habitacion WHERE (tip_hab_descripcion like tipo_habitacion);        
        SELECT tip_hab_precio INTO @precio FROM tipo_habitacion WHERE (tip_hab_codigo = @idhab);
        SET @total = @precio * dias;        
   RETURN @total;     
END$$

DROP FUNCTION IF EXISTS `dias`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `dias` (`fechallegada` DATETIME, `fechasalida` DATETIME) RETURNS INT(11) BEGIN
	SELECT DATEDIFF(fechasalida,fechallegada) INTO @dias;	
        
RETURN @dias;
END$$

DROP FUNCTION IF EXISTS `ses_id`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ses_id` (`cadena` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
	IF EXISTS(SELECT *  FROM sesiones 
    					WHERE ses_cadena like cadena) THEN
		SELECT ses_id INTO @idses 
    	FROM sesiones 
    	WHERE ses_cadena like cadena;
    END IF;

RETURN @idses;
END$$

DROP FUNCTION IF EXISTS `tipo_usuario`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `tipo_usuario` (`usuario` VARCHAR(255), `pwd` CHAR(255)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
SET @usr =usuario;
SET @pwd = pwd;
IF EXISTS(SELECT * FROM usuarios WHERE (usr_login LIKE @usr) AND (usr_pwd LIKE @pwd)) THEN
	SELECT usr_id INTO @idusr FROM usuarios WHERE (usr_login like @usr)AND (usr_pwd like @pwd);     
    SELECT rol_id INTO @idrol FROM roles_usuarios WHERE usr_id = @idusr;
    SELECT rol_nombre into @rol FROM roles WHERE rol_id = @idrol;
    ELSE SET @rol = NULL;
END IF;
RETURN @rol;
END$$

DROP FUNCTION IF EXISTS `usr_id`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `usr_id` (`usuario` VARCHAR(255), `pwd` CHAR(35)) RETURNS INT(11) BEGIN
SET @rol = NULL;
IF EXISTS(SELECT * FROM usuarios WHERE (usr_login like usuario)AND (usr_pwd like pwd)) THEN
	SELECT usr_id INTO @idusr FROM usuarios WHERE (usr_login like usuario)AND (usr_pwd like pwd);     
    
END IF;
RETURN @idusr;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "cliente"
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE "cliente" ;

--
-- Volcado de datos para la tabla "cliente"
--

SET IDENTITY_INSERT "cliente" ON ;
INSERT INTO "cliente" ("cli_id", "cli_nombre", "cli_apellido", "tip_cli_codigo") VALUES
(1, 'Juan', 'Lira', 1),
(2, 'Martin', 'Peres', 1),
(3, 'Pedro', 'Palacios', 1),
(4, 'Ivan', 'Ochoa', 1),
(5, 'Mario', 'Silva', 5),
(8, 'Pancho', 'Villa', 1),
(7, 'Andre', 'Salvador', 1),
(9, 'Maria', 'Meraz', 1);

SET IDENTITY_INSERT "cliente" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "estancia"
--

DROP TABLE IF EXISTS `estancia`;
CREATE TABLE "estancia" ;

--
-- Volcado de datos para la tabla "estancia"
--

SET IDENTITY_INSERT "estancia" ON ;
INSERT INTO "estancia" ("est_fechallegada", "est_fechasalida", "hab_codigo", "cli_id", "est_total") VALUES
('2019-06-02 20:52:00', '2019-06-19 00:00:00', 3, 1, 10400),
('2019-06-02 20:52:00', '2019-06-14 00:00:00', 2, 3, 6400),
('2019-06-06 19:08:23', '2019-06-12 00:00:00', 8, 8, 5000),
('2019-06-07 05:04:22', '2019-06-12 00:00:00', 6, 7, 5000),
('2019-06-07 05:29:45', '2019-06-13 00:00:00', 5, 4, 6000);

SET IDENTITY_INSERT "estancia" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "habitacion"
--

DROP TABLE IF EXISTS `habitacion`;
CREATE TABLE "habitacion" ;

--
-- Volcado de datos para la tabla "habitacion"
--

SET IDENTITY_INSERT "habitacion" ON ;
INSERT INTO "habitacion" ("hab_codigo", "tip_hab_codigo", "ho_codigo", "hab_disponible") VALUES
(1, 1, 1, 'disponible'),
(2, 1, 1, 'NO disponible'),
(3, 1, 1, 'NO disponible'),
(4, 1, 1, 'disponible'),
(5, 2, 1, 'No disponible'),
(6, 2, 1, 'NO disponible'),
(7, 2, 1, 'disponible'),
(8, 2, 1, 'NO disponible'),
(9, 3, 1, 'disponible'),
(10, 3, 1, 'disponible'),
(11, 3, 1, 'disponible'),
(12, 3, 1, 'disponible');

SET IDENTITY_INSERT "habitacion" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "habitacion_mobiliario"
--

DROP TABLE IF EXISTS `habitacion_mobiliario`;
CREATE TABLE "habitacion_mobiliario" ;

--
-- Volcado de datos para la tabla "habitacion_mobiliario"
--

SET IDENTITY_INSERT "habitacion_mobiliario" ON ;
INSERT INTO "habitacion_mobiliario" ("hab_codigo", "mob_codigo") VALUES
(1, 1),
(1, 3),
(1, 3),
(1, 7),
(2, 1),
(2, 3),
(2, 3),
(2, 7),
(3, 1),
(3, 3),
(3, 3),
(3, 7),
(4, 1),
(4, 3),
(4, 3),
(4, 7),
(5, 1),
(5, 3),
(5, 3),
(5, 4),
(5, 5),
(5, 7),
(5, 7),
(6, 1),
(6, 3),
(6, 3),
(6, 4),
(6, 5),
(6, 7),
(6, 7),
(7, 1),
(7, 3),
(7, 3),
(7, 4),
(7, 5),
(7, 7),
(7, 7),
(8, 1),
(8, 3),
(8, 3),
(8, 4),
(8, 5),
(8, 7),
(8, 7),
(9, 1),
(9, 1),
(9, 3),
(9, 3),
(9, 4),
(9, 5),
(9, 7),
(9, 7),
(9, 7),
(10, 1),
(10, 1),
(10, 3),
(10, 3),
(10, 4),
(10, 5),
(10, 7),
(10, 7),
(10, 7),
(11, 1),
(11, 1),
(11, 3),
(11, 3),
(11, 4),
(11, 5),
(11, 7),
(11, 7),
(11, 7),
(12, 1),
(12, 1),
(12, 3),
(12, 3),
(12, 4),
(12, 5),
(12, 7),
(12, 7),
(12, 7);

SET IDENTITY_INSERT "habitacion_mobiliario" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "hotel"
--

DROP TABLE IF EXISTS `hotel`;
CREATE TABLE "hotel" ;

--
-- Volcado de datos para la tabla "hotel"
--

SET IDENTITY_INSERT "hotel" ON ;
INSERT INTO "hotel" ("ho_codigo", "ho_nombre", "ho_direccion", "ho_telefono", "ses_id") VALUES
(1, 'Don Pancho', 'BLV. Revolucion', '7321111', 1);

SET IDENTITY_INSERT "hotel" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "mobiliario"
--

DROP TABLE IF EXISTS `mobiliario`;
CREATE TABLE "mobiliario" ;

--
-- Volcado de datos para la tabla "mobiliario"
--

SET IDENTITY_INSERT "mobiliario" ON ;
INSERT INTO "mobiliario" ("mob_codigo", "mob_precio", "mob_nombre") VALUES
(1, 9999, 'Television'),
(3, 1500, 'Lampara'),
(4, 12000, 'Refrigerador'),
(5, 2000, 'plancha'),
(6, 4000, 'Caja fuerte'),
(7, 2500, 'Cajonera');

SET IDENTITY_INSERT "mobiliario" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "permisos"
--

DROP TABLE IF EXISTS `permisos`;
CREATE TABLE "permisos" ;

--
-- Volcado de datos para la tabla "permisos"
--

SET IDENTITY_INSERT "permisos" ON ;
INSERT INTO "permisos" ("perm_id", "perm_permisos", "perm_fcreacion", "ses_id", "rol_id") VALUES
(1, 'FFF', '2019-06-02 20:51:58', 1, 1),
(2, 'FF0', '2019-06-02 20:51:58', 1, 2),
(3, 'F00', '2019-06-02 20:51:58', 1, 3);

SET IDENTITY_INSERT "permisos" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "roles"
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE "roles" ;

--
-- Volcado de datos para la tabla "roles"
--

SET IDENTITY_INSERT "roles" ON ;
INSERT INTO "roles" ("rol_id", "rol_nombre", "ses_id") VALUES
(1, 'Administrador', 1),
(2, 'Moderador', 1),
(3, 'Normal', 1);

SET IDENTITY_INSERT "roles" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "roles_usuarios"
--

DROP TABLE IF EXISTS `roles_usuarios`;
CREATE TABLE "roles_usuarios" ;

--
-- Volcado de datos para la tabla "roles_usuarios"
--

SET IDENTITY_INSERT "roles_usuarios" ON ;
INSERT INTO "roles_usuarios" ("ru_id", "ru_fecha", "rol_id", "usr_id", "ses_id") VALUES
(1, '2019-06-02 20:51:58', 1, 1, 1),
(2, '2019-06-03 14:22:50', 1, 2, 1),
(3, '2019-06-03 14:22:50', 2, 3, 1),
(4, '2019-06-03 14:22:50', 3, 4, 1),
(6, '2019-06-05 14:01:13', 1, 6, 35),
(8, '2019-06-07 04:58:11', 3, 9, 266);

SET IDENTITY_INSERT "roles_usuarios" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "sesiones"
--

DROP TABLE IF EXISTS `sesiones`;
CREATE TABLE "sesiones" ;

--
-- Volcado de datos para la tabla "sesiones"
--

SET IDENTITY_INSERT "sesiones" ON ;
INSERT INTO "sesiones" ("ses_id", "ses_cadena", "ses_inicio", "ses_ultima_actividad", "ses_fin", "ses_ip", "ses_so", "usr_id") VALUES
(1, 'qwertyuiop', '2019-06-02 20:51:58', '2019-06-02 20:51:58', NULL, '127.0.0.1', '1', NULL),
(2, '3d5133ec', '2019-06-04 01:37:24', '2019-06-04 01:37:24', '2019-06-04 01:37:25', '192.168.1.72', 'Windows 10', 1),
(8, 'c7c283cb', '2019-06-04 01:46:36', '2019-06-04 01:46:36', NULL, '192.168.1.72', 'Windows 10', 3),
(7, '3998b694', '2019-06-04 01:44:01', '2019-06-04 01:44:01', NULL, '192.168.1.72', 'Windows 10', 4),
(6, '51f45f7b', '2019-06-04 01:43:07', '2019-06-04 01:43:07', NULL, '192.168.1.72', 'Windows 10', 4),
(9, 'c870c627', '2019-06-04 13:48:31', '2019-06-04 13:48:31', '2019-06-04 13:48:55', '127.0.0.1', 'Windows 10', 1),
(10, '233da1f4', '2019-06-04 13:51:30', '2019-06-04 13:51:30', NULL, '127.0.0.1', 'Windows 10', 4),
(11, 'dae1e80c', '2019-06-04 20:36:44', '2019-06-04 20:36:44', NULL, '192.168.1.72', 'Windows 10', 1),
(12, '11c569f4', '2019-06-04 20:40:44', '2019-06-04 20:40:44', NULL, '192.168.1.72', 'Windows 10', 1),
(13, '73c65418', '2019-06-04 21:59:14', '2019-06-04 21:59:14', NULL, '192.168.1.72', 'Windows 10', 1),
(14, '92434075', '2019-06-04 22:00:21', '2019-06-04 22:00:21', NULL, '192.168.1.72', 'Windows 10', 1),
(15, '8d56fcee', '2019-06-04 22:01:32', '2019-06-04 22:01:32', '2019-06-04 22:02:00', '192.168.1.72', 'Windows 10', 1),
(16, '699e086a', '2019-06-04 22:05:13', '2019-06-04 22:05:13', NULL, '192.168.1.72', 'Windows 10', 1),
(17, '378404cd', '2019-06-04 22:05:47', '2019-06-04 22:05:47', NULL, '192.168.1.72', 'Windows 10', 1),
(18, 'd9e276a0', '2019-06-04 22:07:24', '2019-06-04 22:07:24', NULL, '192.168.1.72', 'Windows 10', 1),
(19, '4886bbf0', '2019-06-04 23:41:26', '2019-06-04 23:41:26', NULL, '192.168.1.72', 'Windows 10', 1),
(20, 'a54e4a5e', '2019-06-04 23:42:33', '2019-06-04 23:42:33', NULL, '192.168.1.72', 'Windows 10', 1),
(21, 'cc98dc42', '2019-06-04 23:43:07', '2019-06-04 23:43:07', '2019-06-04 23:43:29', '192.168.1.72', 'Windows 10', 1),
(22, 'cf9484ed', '2019-06-04 23:44:17', '2019-06-04 23:44:17', NULL, '192.168.1.72', 'Windows 10', 2),
(23, '22664d87', '2019-06-04 23:45:47', '2019-06-04 23:45:47', '2019-06-04 23:46:12', '192.168.1.72', 'Windows 10', 1),
(24, '265eb98c', '2019-06-04 23:47:33', '2019-06-04 23:47:33', '2019-06-04 23:47:44', '192.168.1.72', 'Windows 10', 2),
(25, '2c344341', '2019-06-04 23:50:57', '2019-06-04 23:50:57', NULL, '192.168.1.72', 'Windows 10', 3),
(26, '416ec4db', '2019-06-04 23:52:22', '2019-06-04 23:52:22', NULL, '192.168.1.72', 'Windows 10', 3),
(27, 'bc896825', '2019-06-04 23:53:13', '2019-06-04 23:53:13', NULL, '192.168.1.72', 'Windows 10', 3),
(28, '062b7c4b', '2019-06-04 23:53:59', '2019-06-04 23:53:59', '2019-06-04 23:54:02', '192.168.1.72', 'Windows 10', 1),
(29, '088d2324', '2019-06-04 23:54:13', '2019-06-04 23:54:13', NULL, '192.168.1.72', 'Windows 10', 3),
(30, '50ca38d3', '2019-06-04 23:55:15', '2019-06-04 23:55:15', NULL, '192.168.1.72', 'Windows 10', 3),
(31, '76c61430', '2019-06-04 23:55:29', '2019-06-04 23:56:36', '2019-06-04 23:57:03', '192.168.1.72', 'Windows 10', 1),
(32, '386feaff', '2019-06-04 23:57:26', '2019-06-04 23:57:26', '2019-06-04 23:57:35', '192.168.1.72', 'Windows 10', 1),
(33, '3a6991b2', '2019-06-05 00:00:39', '2019-06-05 00:00:42', '2019-06-05 00:00:46', '192.168.1.72', 'Windows 10', 1),
(34, 'b4ea9bc0', '2019-06-05 14:00:01', '2019-06-05 14:00:01', NULL, '192.168.1.69', 'Windows 10', NULL),
(35, '67dc5de5', '2019-06-05 14:00:20', '2019-06-07 09:34:43', '2019-06-05 14:01:20', '192.168.1.69', 'Windows 10', 2),
(36, 'e9f8722b', '2019-06-05 14:01:31', '2019-06-05 14:02:17', NULL, '192.168.1.69', 'Windows 10', 6),
(37, '955ee761', '2019-06-05 14:08:45', '2019-06-05 14:08:45', '2019-06-05 14:09:09', '192.168.1.69', 'Windows 10', 1),
(38, 'dc8957c0', '2019-06-05 14:15:42', '2019-06-05 14:15:42', NULL, '192.168.1.69', 'Windows 10', 3),
(39, 'deaddddc', '2019-06-05 14:16:47', '2019-06-05 14:16:47', '2019-06-05 14:16:52', '192.168.1.69', 'Windows 10', 2),
(40, 'cebe47f2', '2019-06-05 14:18:48', '2019-06-05 14:18:48', NULL, '192.168.1.69', 'Windows 10', 4),
(41, 'd4790ffe', '2019-06-05 14:20:19', '2019-06-05 14:20:19', '2019-06-05 14:20:23', '192.168.1.69', 'Windows 10', 4),
(42, 'c3b6b405', '2019-06-05 14:23:51', '2019-06-05 14:24:06', '2019-06-05 14:24:09', '192.168.1.69', 'Windows 10', 6),
(43, 'cf3851de', '2019-06-05 14:27:41', '2019-06-05 14:27:46', '2019-06-05 14:27:49', '192.168.1.69', 'Windows 10', 6),
(44, '66e1344e', '2019-06-05 14:28:05', '2019-06-05 14:28:14', '2019-06-05 14:28:16', '192.168.1.69', 'Windows 10', 1),
(45, 'ef58127e', '2019-06-05 14:48:45', '2019-06-05 14:48:45', NULL, '192.168.1.69', 'Windows 10', 6),
(46, '889d0665', '2019-06-05 14:48:51', '2019-06-07 04:57:25', NULL, '192.168.1.69', 'Windows 10', 6),
(47, '4d0f7bda', '2019-06-05 15:29:02', '2019-06-05 15:29:02', '2019-06-05 15:29:14', '192.168.1.69', 'Windows 10', 6),
(48, 'c8c95695', '2019-06-05 15:31:57', '2019-06-05 15:31:57', NULL, '192.168.1.69', 'Windows 10', 6),
(49, '3fe8ec95', '2019-06-05 15:32:29', '2019-06-05 15:32:29', '2019-06-05 15:33:22', '192.168.1.69', 'Windows 10', 6),
(50, '15c2775c', '2019-06-05 16:05:43', '2019-06-05 16:05:43', '2019-06-05 16:06:05', '192.168.1.69', 'Windows 10', 6),
(51, '3f5ba8fc', '2019-06-05 16:16:53', '2019-06-05 16:17:03', '2019-06-05 16:18:00', '192.168.1.69', 'Windows 10', 6),
(52, 'b0edb675', '2019-06-05 16:18:11', '2019-06-05 16:18:11', NULL, '192.168.1.69', 'Windows 10', 6),
(53, 'c4503f3f', '2019-06-05 16:19:22', '2019-06-05 16:20:09', '2019-06-05 16:20:12', '192.168.1.69', 'Windows 10', 6),
(54, 'e247a073', '2019-06-05 16:20:55', '2019-06-05 16:20:55', '2019-06-05 16:21:08', '192.168.1.69', 'Windows 10', 1),
(55, '2f299d1c', '2019-06-05 16:49:27', '2019-06-05 16:49:27', NULL, '192.168.1.69', 'Windows 10', 6),
(56, 'f660e0d5', '2019-06-05 16:50:07', '2019-06-05 16:50:07', '2019-06-05 16:50:19', '192.168.1.69', 'Windows 10', 6),
(57, '47f7f0dc', '2019-06-05 16:51:05', '2019-06-05 16:51:05', NULL, '192.168.1.69', 'Windows 10', 6),
(58, 'd321fb91', '2019-06-05 16:51:38', '2019-06-05 16:51:38', '2019-06-05 16:52:17', '192.168.1.69', 'Windows 10', 6),
(59, '515d96e9', '2019-06-05 17:05:17', '2019-06-05 17:05:58', NULL, '192.168.1.69', 'Windows 10', 6),
(60, '8198baf2', '2019-06-05 17:08:36', '2019-06-05 17:10:36', '2019-06-05 17:11:49', '192.168.1.69', 'Windows 10', 6),
(61, '34cb22cf', '2019-06-05 17:26:51', '2019-06-05 17:26:51', NULL, '192.168.1.69', 'Windows 10', 6),
(62, '4eb340cc', '2019-06-05 17:27:38', '2019-06-05 17:27:38', '2019-06-05 17:27:56', '192.168.1.69', 'Windows 10', 6),
(63, 'c17daa2a', '2019-06-05 18:27:25', '2019-06-05 18:27:25', NULL, '192.168.1.69', 'Windows 10', 6),
(64, '5b776ff9', '2019-06-05 18:31:57', '2019-06-05 18:31:57', NULL, '192.168.1.69', 'Windows 10', 2),
(65, '471b01b1', '2019-06-05 18:32:27', '2019-06-05 18:32:27', NULL, '192.168.1.69', 'Windows 10', 6),
(66, '06a86278', '2019-06-05 18:37:38', '2019-06-05 18:37:38', NULL, '192.168.1.69', 'Windows 10', 6),
(67, 'cff8fe13', '2019-06-05 18:37:41', '2019-06-05 18:37:41', '2019-06-05 19:00:35', '192.168.1.69', 'Windows 10', 6),
(68, '8008524e', '2019-06-05 19:03:27', '2019-06-05 19:03:27', NULL, '192.168.1.69', 'Windows 10', 6),
(69, '204bce14', '2019-06-05 19:04:43', '2019-06-05 19:04:43', NULL, '192.168.1.69', 'Windows 10', 1),
(70, '8332c5ba', '2019-06-05 19:04:43', '2019-06-05 19:04:43', NULL, '192.168.1.69', 'Windows 10', 1),
(71, 'd6f9f093', '2019-06-05 19:04:44', '2019-06-05 19:04:44', '2019-06-05 19:05:31', '192.168.1.69', 'Windows 10', 1),
(72, 'd05b5e32', '2019-06-05 19:07:06', '2019-06-05 19:07:06', NULL, '192.168.1.69', 'Windows 10', 6),
(73, '76c43f67', '2019-06-05 19:11:55', '2019-06-05 19:11:55', NULL, '192.168.1.69', 'Windows 10', 6),
(74, 'b6f5aa59', '2019-06-05 19:12:41', '2019-06-05 19:12:41', '2019-06-05 19:12:51', '192.168.1.69', 'Windows 10', 1),
(75, 'c86ef758', '2019-06-05 19:13:47', '2019-06-05 19:13:47', NULL, '192.168.1.69', 'Windows 10', NULL),
(76, '810cc613', '2019-06-05 19:13:54', '2019-06-05 19:13:54', NULL, '192.168.1.69', 'Windows 10', 1),
(77, '679b4793', '2019-06-05 19:14:25', '2019-06-05 19:14:25', NULL, '192.168.1.69', 'Windows 10', 1),
(78, '6c881976', '2019-06-05 19:18:29', '2019-06-05 19:18:29', NULL, '192.168.1.69', 'Windows 10', 6),
(79, '27158207', '2019-06-05 19:19:16', '2019-06-05 19:19:16', '2019-06-05 19:19:40', '192.168.1.69', 'Windows 10', 6),
(80, 'd7370af9', '2019-06-05 19:20:03', '2019-06-05 19:20:03', '2019-06-05 19:20:17', '192.168.1.69', 'Windows 10', 6),
(81, 'a3389860', '2019-06-05 19:22:57', '2019-06-05 19:22:57', NULL, '192.168.1.69', 'Windows 10', 6),
(82, '1fb1dcf4', '2019-06-05 19:24:17', '2019-06-05 19:24:17', NULL, '192.168.1.69', 'Windows 10', 6),
(83, '87442581', '2019-06-05 19:29:20', '2019-06-05 19:29:20', '2019-06-05 19:29:44', '192.168.1.69', 'Windows 10', 6),
(84, '59fa34aa', '2019-06-05 19:30:33', '2019-06-05 19:30:33', '2019-06-05 19:30:56', '192.168.1.69', 'Windows 10', 6),
(85, '0a17375b', '2019-06-05 19:32:21', '2019-06-05 19:32:21', '2019-06-05 19:32:30', '192.168.1.69', 'Windows 10', 6),
(86, 'd507f2dc', '2019-06-05 19:32:52', '2019-06-05 19:32:52', '2019-06-05 19:33:44', '192.168.1.69', 'Windows 10', 6),
(87, '586a340f', '2019-06-05 19:34:48', '2019-06-05 19:34:48', '2019-06-05 19:35:33', '192.168.1.69', 'Windows 10', 6),
(88, 'cbf7d893', '2019-06-05 19:35:55', '2019-06-05 19:35:55', NULL, '192.168.1.69', 'Windows 10', 6),
(89, '03451cbd', '2019-06-05 19:36:51', '2019-06-05 19:36:51', '2019-06-05 19:39:20', '192.168.1.69', 'Windows 10', 6),
(90, 'dc097fa9', '2019-06-05 19:39:43', '2019-06-05 19:39:43', '2019-06-05 19:39:53', '192.168.1.69', 'Windows 10', 6),
(91, '846eeca1', '2019-06-05 19:41:38', '2019-06-05 19:41:38', NULL, '192.168.1.69', 'Windows 10', 6),
(92, 'f20bd975', '2019-06-05 19:43:04', '2019-06-05 19:43:04', '2019-06-05 19:43:13', '192.168.1.69', 'Windows 10', 6),
(93, 'aeecbad3', '2019-06-05 19:45:19', '2019-06-05 19:45:19', NULL, '192.168.1.69', 'Windows 10', 6),
(94, '96df8a8f', '2019-06-05 19:48:43', '2019-06-05 19:48:43', '2019-06-05 19:48:49', '192.168.1.69', 'Windows 10', 6),
(95, '3e394557', '2019-06-05 19:49:21', '2019-06-05 19:49:21', '2019-06-05 19:49:25', '192.168.1.69', 'Windows 10', 6),
(96, '7abe1fad', '2019-06-05 19:52:33', '2019-06-05 19:52:33', NULL, '192.168.1.69', 'Windows 10', 6),
(97, '3e66c1a7', '2019-06-05 19:58:45', '2019-06-05 19:58:45', '2019-06-05 19:58:55', '192.168.1.69', 'Windows 10', 6),
(98, '95324bb8', '2019-06-05 19:59:08', '2019-06-05 19:59:08', '2019-06-05 19:59:13', '192.168.1.69', 'Windows 10', 6),
(99, 'fd20b48c', '2019-06-05 19:59:36', '2019-06-05 19:59:36', NULL, '192.168.1.69', 'Windows 10', 6),
(100, '9c472b20', '2019-06-05 20:00:02', '2019-06-05 20:00:02', NULL, '192.168.1.69', 'Windows 10', 6),
(101, '54f6f87c', '2019-06-05 20:04:52', '2019-06-05 20:04:52', '2019-06-05 20:05:10', '192.168.1.69', 'Windows 10', 6),
(102, 'eb841f05', '2019-06-05 22:13:41', '2019-06-05 22:14:03', NULL, '192.168.1.72', 'Windows 10', 6),
(103, 'a0b42d63', '2019-06-05 22:24:24', '2019-06-05 22:24:30', '2019-06-05 22:24:38', '192.168.1.72', 'Windows 10', 1),
(104, '4030649f', '2019-06-05 22:25:11', '2019-06-05 22:26:51', NULL, '192.168.1.72', 'Windows 10', 6),
(105, '848fdc15', '2019-06-05 22:50:32', '2019-06-05 22:50:32', NULL, '192.168.1.72', 'Windows 10', 1),
(106, '7911e475', '2019-06-05 22:53:19', '2019-06-05 22:53:19', NULL, '192.168.1.72', 'Windows 10', 6),
(107, '5d96c073', '2019-06-05 22:54:16', '2019-06-05 22:54:16', NULL, '192.168.1.72', 'Windows 10', 6),
(108, 'bf2c15b7', '2019-06-05 22:56:26', '2019-06-05 22:56:26', NULL, '192.168.1.72', 'Windows 10', 6),
(109, 'e1da824e', '2019-06-05 22:57:07', '2019-06-05 22:57:07', NULL, '192.168.1.72', 'Windows 10', 6),
(110, 'a3ce5937', '2019-06-05 22:58:02', '2019-06-05 22:58:02', NULL, '192.168.1.72', 'Windows 10', 6),
(111, 'e7a61585', '2019-06-05 22:58:26', '2019-06-05 22:58:26', NULL, '192.168.1.72', 'Windows 10', 6),
(112, '768cc91f', '2019-06-05 23:05:02', '2019-06-05 23:06:47', '2019-06-05 23:07:31', '192.168.1.72', 'Windows 10', 6),
(113, 'e58248ec', '2019-06-05 23:12:42', '2019-06-05 23:12:42', '2019-06-05 23:15:48', '192.168.1.72', 'Windows 10', 6),
(114, 'a3b3e9fc', '2019-06-05 23:16:01', '2019-06-05 23:16:05', NULL, '192.168.1.72', 'Windows 10', 1),
(115, '29a9446a', '2019-06-05 23:18:34', '2019-06-05 23:19:14', '2019-06-05 23:19:18', '192.168.1.72', 'Windows 10', 6),
(116, '9eb8d104', '2019-06-06 00:02:07', '2019-06-06 00:02:07', '2019-06-06 00:04:04', '192.168.1.72', 'Windows 10', 6),
(117, '7ac7a669', '2019-06-06 00:09:56', '2019-06-06 00:10:35', '2019-06-06 00:10:47', '192.168.1.72', 'Windows 10', 6),
(118, 'a42d69e7', '2019-06-06 00:11:46', '2019-06-06 00:12:04', NULL, '192.168.1.72', 'Windows 10', 6),
(119, 'feed5284', '2019-06-06 00:13:44', '2019-06-06 00:14:20', '2019-06-06 00:14:41', '192.168.1.72', 'Windows 10', 6),
(120, '7279e42e', '2019-06-06 00:36:46', '2019-06-06 00:36:46', '2019-06-06 00:36:58', '192.168.1.72', 'Windows 10', 6),
(121, '4473683d', '2019-06-06 00:39:15', '2019-06-06 00:39:15', '2019-06-06 00:39:20', '192.168.1.72', 'Windows 10', 6),
(122, 'da599e81', '2019-06-06 00:46:57', '2019-06-06 00:46:57', '2019-06-06 00:47:06', '192.168.1.72', 'Windows 10', 6),
(123, '40258916', '2019-06-06 19:07:39', '2019-06-06 19:09:22', NULL, '192.168.1.98', 'Windows 10', 6),
(124, '9c51de20', '2019-06-06 19:35:11', '2019-06-06 19:35:11', NULL, '192.168.1.98', 'Windows 10', NULL),
(125, 'a5e6741e', '2019-06-06 19:51:10', '2019-06-06 19:51:10', NULL, '192.168.1.98', 'Windows 10', 6),
(126, 'd48226cf', '2019-06-06 19:54:22', '2019-06-06 19:54:22', NULL, '192.168.1.98', 'Windows 10', 6),
(127, '9429b404', '2019-06-06 19:54:26', '2019-06-06 19:54:26', NULL, '192.168.1.98', 'Windows 10', 6),
(128, 'de4221d4', '2019-06-06 19:56:02', '2019-06-06 19:56:02', NULL, '192.168.1.98', 'Windows 10', 6),
(129, 'eefdb68b', '2019-06-06 20:15:01', '2019-06-06 20:15:01', NULL, '192.168.1.98', 'Windows 10', 6),
(130, 'eac4b110', '2019-06-06 20:16:27', '2019-06-06 20:16:27', NULL, '192.168.1.98', 'Windows 10', 6),
(131, 'dd064c8e', '2019-06-06 20:18:22', '2019-06-06 20:18:22', '2019-06-06 20:18:42', '192.168.1.98', 'Windows 10', 6),
(132, '47e906c3', '2019-06-06 20:21:53', '2019-06-06 20:21:53', '2019-06-06 20:22:20', '192.168.1.98', 'Windows 10', 6),
(133, '30c3a201', '2019-06-06 20:38:35', '2019-06-06 20:38:35', NULL, '192.168.1.98', 'Windows 10', 6),
(134, 'd9dac1b6', '2019-06-06 21:11:06', '2019-06-06 21:11:06', NULL, '192.168.1.98', 'Windows 10', 6),
(135, 'f0502b65', '2019-06-06 21:16:02', '2019-06-06 21:16:02', NULL, '192.168.1.98', 'Windows 10', 6),
(136, '3b43b97e', '2019-06-06 21:18:15', '2019-06-06 21:18:15', NULL, '192.168.1.98', 'Windows 10', 6),
(137, '0327b7e4', '2019-06-06 21:21:56', '2019-06-06 21:21:56', NULL, '192.168.1.98', 'Windows 10', 6),
(138, '2eadf058', '2019-06-06 21:28:07', '2019-06-06 21:28:07', '2019-06-06 21:28:26', '192.168.1.98', 'Windows 10', 6),
(139, 'e2388c23', '2019-06-06 21:29:37', '2019-06-06 21:29:37', '2019-06-06 21:29:53', '192.168.1.98', 'Windows 10', 6),
(140, '503c6256', '2019-06-06 21:31:46', '2019-06-06 21:31:46', NULL, '192.168.1.98', 'Windows 10', 6),
(141, 'dc13c3b6', '2019-06-06 21:33:19', '2019-06-06 21:33:19', '2019-06-06 21:33:45', '192.168.1.98', 'Windows 10', 6),
(142, '5bbc5584', '2019-06-06 21:37:29', '2019-06-06 21:37:29', NULL, '192.168.1.98', 'Windows 10', 6),
(143, '27e44c25', '2019-06-06 21:39:02', '2019-06-06 21:39:02', NULL, '192.168.1.98', 'Windows 10', 6),
(144, 'd22e5307', '2019-06-06 21:40:41', '2019-06-06 21:40:41', '2019-06-06 21:40:58', '192.168.1.98', 'Windows 10', 6),
(145, '80cec5cc', '2019-06-06 21:41:18', '2019-06-06 21:41:18', NULL, '192.168.1.98', 'Windows 10', 4),
(146, '8582f4a8', '2019-06-06 21:43:10', '2019-06-06 21:43:10', NULL, '192.168.1.98', 'Windows 10', 4),
(147, '831e6687', '2019-06-06 21:48:44', '2019-06-06 21:48:44', NULL, '192.168.1.98', 'Windows 10', 4),
(148, 'd2ba10df', '2019-06-06 21:49:36', '2019-06-06 21:49:36', NULL, '192.168.1.98', 'Windows 10', 4),
(149, '336ea81f', '2019-06-06 21:56:25', '2019-06-06 21:56:25', NULL, '192.168.1.98', 'Windows 10', 4),
(150, '9f206351', '2019-06-06 21:58:19', '2019-06-06 21:58:19', NULL, '192.168.1.98', 'Windows 10', 4),
(151, '0b942daf', '2019-06-06 21:59:34', '2019-06-06 21:59:34', NULL, '192.168.1.98', 'Windows 10', 4),
(152, '908d3397', '2019-06-06 22:12:29', '2019-06-06 22:12:29', NULL, '192.168.1.98', 'Windows 10', 4),
(153, '5dc53dca', '2019-06-06 22:15:05', '2019-06-06 22:15:05', NULL, '192.168.1.98', 'Windows 10', 4),
(154, '7e077779', '2019-06-06 22:18:38', '2019-06-06 22:18:38', NULL, '192.168.1.98', 'Windows 10', 4),
(155, '6eb71e4a', '2019-06-06 22:19:22', '2019-06-06 22:19:22', NULL, '192.168.1.98', 'Windows 10', 4),
(156, '9ea27f54', '2019-06-06 22:20:19', '2019-06-06 22:20:19', NULL, '192.168.1.98', 'Windows 10', 3),
(157, 'aa1bb1fb', '2019-06-06 22:22:19', '2019-06-06 22:22:19', NULL, '192.168.1.98', 'Windows 10', 3),
(158, 'e4d1daae', '2019-06-06 22:22:49', '2019-06-06 22:22:49', NULL, '192.168.1.98', 'Windows 10', 3),
(159, 'cd950384', '2019-06-06 22:24:48', '2019-06-06 22:24:48', NULL, '192.168.1.98', 'Windows 10', 3),
(160, '48accbb0', '2019-06-06 22:27:11', '2019-06-06 22:27:11', NULL, '192.168.1.98', 'Windows 10', 3),
(161, '2f4b8dd9', '2019-06-06 22:27:39', '2019-06-06 22:27:39', NULL, '192.168.1.98', 'Windows 10', 3),
(162, '138ddc4c', '2019-06-06 22:28:59', '2019-06-06 22:28:59', '2019-06-06 22:29:03', '192.168.1.98', 'Windows 10', 3),
(163, '4c0658a0', '2019-06-06 22:29:14', '2019-06-06 22:29:14', NULL, '192.168.1.98', 'Windows 10', 4),
(164, 'e297fe9c', '2019-06-06 22:30:02', '2019-06-06 22:30:02', NULL, '192.168.1.98', 'Windows 10', 4),
(165, '15a27e05', '2019-06-06 23:59:38', '2019-06-06 23:59:38', '2019-06-06 23:59:42', '192.168.1.98', 'Windows 10', 6),
(166, '6fa8b58a', '2019-06-06 23:59:49', '2019-06-06 23:59:49', NULL, '192.168.1.98', 'Windows 10', 3),
(167, '9a30cb74', '2019-06-07 00:00:10', '2019-06-07 00:00:10', NULL, '192.168.1.98', 'Windows 10', 4),
(168, 'd1332d2d', '2019-06-07 00:05:40', '2019-06-07 00:05:40', NULL, '192.168.1.98', 'Windows 10', 4),
(169, '5260f085', '2019-06-07 00:06:49', '2019-06-07 00:06:49', NULL, '192.168.1.98', 'Windows 10', 4),
(170, 'f6278be4', '2019-06-07 00:10:06', '2019-06-07 00:10:06', NULL, '192.168.1.98', 'Windows 10', 4),
(171, 'f0ac12f6', '2019-06-07 00:12:28', '2019-06-07 00:12:28', NULL, '192.168.1.98', 'Windows 10', 4),
(172, 'c55b5d56', '2019-06-07 00:13:08', '2019-06-07 00:13:08', NULL, '192.168.1.98', 'Windows 10', 4),
(173, '54c3470b', '2019-06-07 00:16:53', '2019-06-07 00:16:53', NULL, '192.168.1.98', 'Windows 10', 4),
(174, '479ecdc0', '2019-06-07 00:20:49', '2019-06-07 00:20:49', NULL, '192.168.1.98', 'Windows 10', 4),
(175, '4035d2eb', '2019-06-07 00:20:54', '2019-06-07 00:20:54', NULL, '192.168.1.98', 'Windows 10', 4),
(176, 'aee121d4', '2019-06-07 00:23:31', '2019-06-07 00:23:31', NULL, '192.168.1.98', 'Windows 10', 4),
(177, '1d06c18b', '2019-06-07 00:24:32', '2019-06-07 00:24:32', NULL, '192.168.1.98', 'Windows 10', 4),
(178, '2d04445c', '2019-06-07 00:25:34', '2019-06-07 00:25:34', '2019-06-07 00:25:39', '192.168.1.98', 'Windows 10', 4),
(179, 'a489bed5', '2019-06-07 00:25:44', '2019-06-07 00:25:44', NULL, '192.168.1.98', 'Windows 10', 3),
(180, 'e81d8e84', '2019-06-07 00:27:19', '2019-06-07 00:27:19', '2019-06-07 00:27:26', '192.168.1.98', 'Windows 10', 4),
(181, '62ec2109', '2019-06-07 00:27:34', '2019-06-07 00:27:34', NULL, '192.168.1.98', 'Windows 10', 3),
(182, '76e7b909', '2019-06-07 00:29:47', '2019-06-07 00:29:47', '2019-06-07 00:29:58', '192.168.1.98', 'Windows 10', 4),
(183, 'c8e1e420', '2019-06-07 00:30:03', '2019-06-07 00:30:03', '2019-06-07 00:30:12', '192.168.1.98', 'Windows 10', 3),
(184, '315e4624', '2019-06-07 00:33:58', '2019-06-07 00:33:58', NULL, '192.168.1.98', 'Windows 10', 6),
(185, 'ecb2a10b', '2019-06-07 00:48:39', '2019-06-07 00:48:39', NULL, '192.168.1.98', 'Windows 10', 2),
(186, '1de37157', '2019-06-07 00:49:37', '2019-06-07 00:49:37', NULL, '192.168.1.98', 'Windows 10', 2),
(187, 'eda1b24a', '2019-06-07 00:49:42', '2019-06-07 00:49:42', '2019-06-07 00:49:50', '192.168.1.98', 'Windows 10', 2),
(188, 'b9688f9f', '2019-06-07 00:49:55', '2019-06-07 00:49:55', '2019-06-07 00:50:08', '192.168.1.98', 'Windows 10', 4),
(189, 'e50b936d', '2019-06-07 00:51:56', '2019-06-07 00:51:56', NULL, '192.168.1.98', 'Windows 10', 4),
(190, 'efb0889e', '2019-06-07 00:52:00', '2019-06-07 00:52:00', NULL, '192.168.1.98', 'Windows 10', 4),
(191, '109ddf1b', '2019-06-07 00:52:41', '2019-06-07 00:52:41', '2019-06-07 00:52:57', '192.168.1.98', 'Windows 10', 6),
(192, '6d988d23', '2019-06-07 00:53:03', '2019-06-07 00:53:03', '2019-06-07 00:53:10', '192.168.1.98', 'Windows 10', 3),
(193, '5da725f6', '2019-06-07 00:53:21', '2019-06-07 00:53:21', NULL, '192.168.1.98', 'Windows 10', 4),
(194, '1124e5dd', '2019-06-07 00:54:11', '2019-06-07 00:54:11', '2019-06-07 00:54:30', '192.168.1.98', 'Windows 10', 4),
(195, 'eec6d586', '2019-06-07 00:54:34', '2019-06-07 00:54:34', '2019-06-07 00:54:38', '192.168.1.98', 'Windows 10', 6),
(196, '5683c1f2', '2019-06-07 00:54:49', '2019-06-07 00:54:49', '2019-06-07 00:54:51', '192.168.1.98', 'Windows 10', 3),
(197, '5085fc8e', '2019-06-07 00:55:28', '2019-06-07 00:55:28', NULL, '192.168.1.98', 'Windows 10', 4),
(198, 'be9ffcea', '2019-06-07 00:57:32', '2019-06-07 00:57:32', '2019-06-07 00:58:12', '192.168.1.98', 'Windows 10', 4),
(199, '485899bb', '2019-06-07 01:01:37', '2019-06-07 01:01:37', '2019-06-07 01:01:51', '192.168.1.98', 'Windows 10', 4),
(200, '5218c33e', '2019-06-07 01:01:56', '2019-06-07 01:01:56', '2019-06-07 01:02:24', '192.168.1.98', 'Windows 10', 3),
(201, '49afbe0a', '2019-06-07 01:03:20', '2019-06-07 01:03:20', NULL, '192.168.1.98', 'Windows 10', 6),
(202, 'eaaa9ab4', '2019-06-07 01:09:26', '2019-06-07 01:09:26', NULL, '192.168.1.98', 'Windows 10', 4),
(203, 'b731a6f6', '2019-06-07 01:11:16', '2019-06-07 01:11:16', '2019-06-07 01:12:37', '192.168.1.98', 'Windows 10', 6),
(204, '163dee1f', '2019-06-07 01:13:35', '2019-06-07 01:13:35', '2019-06-07 01:13:41', '192.168.1.98', 'Windows 10', 6),
(205, '2e2b5c88', '2019-06-07 01:14:25', '2019-06-07 01:14:25', NULL, '192.168.1.98', 'Windows 10', 6),
(206, '7fce420e', '2019-06-07 01:16:34', '2019-06-07 01:16:34', '2019-06-07 01:16:38', '192.168.1.98', 'Windows 10', 6),
(207, '3924836a', '2019-06-07 01:16:58', '2019-06-07 01:16:58', NULL, '192.168.1.98', 'Windows 10', 6),
(208, '57418f12', '2019-06-07 01:17:01', '2019-06-07 01:17:01', NULL, '192.168.1.98', 'Windows 10', 6),
(209, '6e16a8cb', '2019-06-07 01:17:02', '2019-06-07 01:17:02', NULL, '192.168.1.98', 'Windows 10', 6),
(210, '289a5575', '2019-06-07 01:17:05', '2019-06-07 01:17:05', NULL, '192.168.1.98', 'Windows 10', 6),
(211, '5101c539', '2019-06-07 01:17:12', '2019-06-07 01:17:12', NULL, '192.168.1.98', 'Windows 10', 6),
(212, 'e2da1c3a', '2019-06-07 01:17:19', '2019-06-07 01:17:19', NULL, '192.168.1.98', 'Windows 10', 6),
(213, '08eeec4b', '2019-06-07 01:17:21', '2019-06-07 01:17:21', NULL, '192.168.1.98', 'Windows 10', 6),
(214, '9e575213', '2019-06-07 01:17:37', '2019-06-07 01:17:37', NULL, '192.168.1.98', 'Windows 10', 6),
(215, '3d54fb36', '2019-06-07 01:17:41', '2019-06-07 01:17:41', NULL, '192.168.1.98', 'Windows 10', 6),
(216, 'ff923272', '2019-06-07 01:18:04', '2019-06-07 01:18:04', '2019-06-07 01:18:07', '192.168.1.98', 'Windows 10', 6),
(217, 'e08e9573', '2019-06-07 01:21:23', '2019-06-07 01:21:23', '2019-06-07 01:21:29', '192.168.1.98', 'Windows 10', 6),
(218, 'a83b8c9c', '2019-06-07 01:22:23', '2019-06-07 01:22:23', '2019-06-07 01:22:32', '192.168.1.98', 'Windows 10', 6),
(219, '4c32b845', '2019-06-07 01:25:59', '2019-06-07 01:25:59', '2019-06-07 01:26:07', '192.168.1.98', 'Windows 10', 6),
(220, '0a0f9325', '2019-06-07 01:29:09', '2019-06-07 01:29:09', NULL, '192.168.1.98', 'Windows 10', 6),
(221, '4642231a', '2019-06-07 01:31:07', '2019-06-07 01:31:07', '2019-06-07 01:31:15', '192.168.1.98', 'Windows 10', 6),
(222, '0be6c02c', '2019-06-07 01:31:45', '2019-06-07 01:31:45', NULL, '192.168.1.98', 'Windows 10', 6),
(223, '6dd2e3e8', '2019-06-07 01:32:23', '2019-06-07 01:32:23', NULL, '192.168.1.98', 'Windows 10', 6),
(224, '226d63c4', '2019-06-07 01:32:47', '2019-06-07 01:32:47', NULL, '192.168.1.98', 'Windows 10', 6),
(225, 'c59379af', '2019-06-07 01:33:19', '2019-06-07 01:33:19', NULL, '192.168.1.98', 'Windows 10', 6),
(226, '4f348edc', '2019-06-07 01:33:37', '2019-06-07 01:33:37', NULL, '192.168.1.98', 'Windows 10', 6),
(227, '0d985db8', '2019-06-07 01:34:37', '2019-06-07 01:34:37', '2019-06-07 01:34:40', '192.168.1.98', 'Windows 10', 6),
(228, 'dac007ee', '2019-06-07 01:36:29', '2019-06-07 01:36:29', NULL, '192.168.1.98', 'Windows 10', 6),
(229, '7e3b5fe2', '2019-06-07 01:37:55', '2019-06-07 01:37:55', NULL, '192.168.1.98', 'Windows 10', 6),
(230, 'b48553fe', '2019-06-07 01:38:20', '2019-06-07 01:38:20', NULL, '192.168.1.98', 'Windows 10', 6),
(231, '98129730', '2019-06-07 01:39:05', '2019-06-07 01:39:05', '2019-06-07 01:39:41', '192.168.1.98', 'Windows 10', 6),
(232, 'ee50a5fd', '2019-06-07 01:44:03', '2019-06-07 01:44:03', NULL, '192.168.1.98', 'Windows 10', 6),
(233, '3d2e3f38', '2019-06-07 01:44:28', '2019-06-07 01:44:28', '2019-06-07 01:44:32', '192.168.1.98', 'Windows 10', 6),
(234, 'ad423592', '2019-06-07 01:46:21', '2019-06-07 01:46:21', NULL, '192.168.1.98', 'Windows 10', 6),
(235, '65296140', '2019-06-07 01:47:46', '2019-06-07 01:47:46', NULL, '192.168.1.98', 'Windows 10', 6),
(236, '5f5cae3e', '2019-06-07 01:50:22', '2019-06-07 01:50:22', NULL, '192.168.1.98', 'Windows 10', 4),
(237, '8f3f26bd', '2019-06-07 01:50:29', '2019-06-07 01:50:37', NULL, '192.168.1.98', 'Windows 10', 4),
(238, 'f6c5719e', '2019-06-07 01:50:54', '2019-06-07 01:50:54', '2019-06-07 01:51:02', '192.168.1.98', 'Windows 10', 6),
(239, '6ad8185f', '2019-06-07 01:51:06', '2019-06-07 01:51:06', '2019-06-07 01:51:09', '192.168.1.98', 'Windows 10', 3),
(240, '4567ba59', '2019-06-07 01:51:14', '2019-06-07 01:51:14', '2019-06-07 01:51:18', '192.168.1.98', 'Windows 10', 4),
(241, '33acf8ef', '2019-06-07 01:52:16', '2019-06-07 01:52:16', NULL, '192.168.1.98', 'Windows 10', 6),
(242, '45fc075f', '2019-06-07 01:53:11', '2019-06-07 01:53:11', NULL, '192.168.1.98', 'Windows 10', 6),
(243, '9956c7a0', '2019-06-07 01:54:37', '2019-06-07 01:54:37', NULL, '192.168.1.98', 'Windows 10', 6),
(244, 'ffa6ecc8', '2019-06-07 01:55:23', '2019-06-07 01:55:23', '2019-06-07 01:57:41', '192.168.1.98', 'Windows 10', 6),
(245, '246027ba', '2019-06-07 02:20:53', '2019-06-07 02:20:53', '2019-06-07 02:21:07', '192.168.1.98', 'Windows 10', 6),
(246, 'f06e0035', '2019-06-07 03:18:48', '2019-06-07 03:18:48', '2019-06-07 03:21:02', '192.168.1.98', 'Windows 10', 6),
(247, '4ee0b23d', '2019-06-07 03:27:03', '2019-06-07 03:27:03', NULL, '192.168.1.98', 'Windows 10', 6),
(248, '6bf6295a', '2019-06-07 03:31:49', '2019-06-07 03:31:49', '2019-06-07 03:33:54', '192.168.1.98', 'Windows 10', 6),
(249, '4d307216', '2019-06-07 03:40:44', '2019-06-07 03:40:44', '2019-06-07 03:41:33', '192.168.1.98', 'Windows 10', 6),
(250, 'e5d277fc', '2019-06-07 03:44:38', '2019-06-07 03:44:38', NULL, '192.168.1.98', 'Windows 10', 6),
(251, '0d54bc89', '2019-06-07 03:47:45', '2019-06-07 03:47:45', NULL, '192.168.1.98', 'Windows 10', 6),
(252, '9d5b1c97', '2019-06-07 03:51:01', '2019-06-07 03:51:01', NULL, '192.168.1.98', 'Windows 10', 6),
(253, '3b9e0e7a', '2019-06-07 03:52:34', '2019-06-07 03:52:34', NULL, '192.168.1.98', 'Windows 10', 6),
(254, 'bc2a3dd9', '2019-06-07 04:07:52', '2019-06-07 04:07:52', '2019-06-07 04:08:59', '192.168.1.98', 'Windows 10', 6),
(255, '9d03e40a', '2019-06-07 04:18:28', '2019-06-07 04:18:28', '2019-06-07 04:19:55', '192.168.1.98', 'Windows 10', 6),
(256, 'c4a542f6', '2019-06-07 04:20:50', '2019-06-07 04:20:50', '2019-06-07 04:20:59', '192.168.1.98', 'Windows 10', 1),
(257, '32ffb8ed', '2019-06-07 04:21:36', '2019-06-07 04:21:36', '2019-06-07 04:22:01', '192.168.1.98', 'Windows 10', 1),
(258, '23845720', '2019-06-07 04:22:29', '2019-06-07 04:22:29', '2019-06-07 04:22:39', '192.168.1.98', 'Windows 10', 1),
(259, '91d4b695', '2019-06-07 04:23:09', '2019-06-07 04:23:09', '2019-06-07 04:23:24', '192.168.1.98', 'Windows 10', 6),
(260, '82b47b94', '2019-06-07 04:24:55', '2019-06-07 04:24:55', '2019-06-07 04:25:20', '192.168.1.98', 'Windows 10', 6),
(261, '066f1150', '2019-06-07 04:29:21', '2019-06-07 04:29:21', NULL, '192.168.1.98', 'Windows 10', 6),
(262, 'b71eefda', '2019-06-07 04:29:25', '2019-06-07 04:29:25', '2019-06-07 04:31:14', '192.168.1.98', 'Windows 10', 6),
(263, 'a1aed20e', '2019-06-07 04:36:24', '2019-06-07 04:36:24', '2019-06-07 04:38:17', '192.168.1.98', 'Windows 10', 6),
(264, '40aa7a1a', '2019-06-07 04:46:04', '2019-06-07 04:46:04', '2019-06-07 04:46:34', '192.168.1.98', 'Windows 10', 1),
(265, 'a6a5d390', '2019-06-07 04:53:29', '2019-06-07 04:53:29', NULL, '192.168.1.98', 'Windows 10', 2),
(266, 'c7be45c5', '2019-06-07 04:57:21', '2019-06-07 09:05:40', '2019-06-07 05:06:21', '192.168.1.98', 'Windows 10', 6),
(267, '055b1c34', '2019-06-07 05:09:57', '2019-06-07 05:09:57', '2019-06-07 05:10:56', '192.168.1.98', 'Windows 10', 6),
(268, 'a125befa', '2019-06-07 05:17:32', '2019-06-07 05:17:32', '2019-06-07 05:17:58', '192.168.1.98', 'Windows 10', 6),
(269, '4407193d', '2019-06-07 05:18:30', '2019-06-07 05:18:30', '2019-06-07 05:18:41', '192.168.1.98', 'Windows 10', 4),
(270, 'd95ac145', '2019-06-07 05:19:01', '2019-06-07 05:19:01', '2019-06-07 05:19:04', '192.168.1.98', 'Windows 10', 4),
(271, '1b651bca', '2019-06-07 05:19:10', '2019-06-07 05:19:10', '2019-06-07 05:19:15', '192.168.1.98', 'Windows 10', 1),
(272, '008b1408', '2019-06-07 05:21:48', '2019-06-07 05:25:59', '2019-06-07 05:26:02', '192.168.1.98', 'Windows 10', 4),
(273, 'c3f93030', '2019-06-07 05:26:14', '2019-06-07 05:26:39', '2019-06-07 05:27:24', '192.168.1.98', 'Windows 10', 4),
(274, '24efcff6', '2019-06-07 05:28:49', '2019-06-07 05:29:03', '2019-06-07 05:29:06', '192.168.1.98', 'Windows 10', 4),
(275, 'b75dd303', '2019-06-07 05:29:30', '2019-06-07 05:29:45', '2019-06-07 05:29:55', '192.168.1.98', 'Windows 10', 4),
(276, 'e2697eb7', '2019-06-07 06:28:08', '2019-06-07 06:28:08', '2019-06-07 06:29:20', '192.168.1.98', 'Windows 10', 1),
(277, '572e86b6', '2019-06-07 06:29:28', '2019-06-07 06:29:28', '2019-06-07 06:29:35', '192.168.1.98', 'Windows 10', 3),
(278, '072dca1c', '2019-06-07 06:29:45', '2019-06-07 06:31:27', NULL, '192.168.1.98', 'Windows 10', 4),
(279, '0bad9c97', '2019-06-07 06:34:14', '2019-06-07 06:34:14', '2019-06-07 06:34:23', '192.168.1.98', 'Windows 10', 1),
(280, '39fcaa30', '2019-06-07 06:35:41', '2019-06-07 06:35:41', '2019-06-07 06:36:02', '192.168.1.98', 'Windows 10', 1),
(281, '32b1a3d2', '2019-06-07 06:36:32', '2019-06-07 06:36:32', '2019-06-07 06:37:22', '192.168.1.98', 'Windows 10', 1),
(282, '9d66cb53', '2019-06-07 06:40:12', '2019-06-07 06:40:12', '2019-06-07 06:40:54', '192.168.1.98', 'Windows 10', 1),
(283, '190cd97a', '2019-06-07 06:41:56', '2019-06-07 06:41:56', '2019-06-07 06:42:37', '192.168.1.98', 'Windows 10', 1),
(284, '23fec07e', '2019-06-07 06:45:07', '2019-06-07 06:47:19', '2019-06-07 06:48:19', '192.168.1.98', 'Windows 10', 1),
(285, '27264118', '2019-06-07 06:48:55', '2019-06-07 06:48:55', '2019-06-07 06:49:56', '192.168.1.98', 'Windows 10', 1),
(286, '701e3fa4', '2019-06-07 07:24:42', '2019-06-07 07:24:42', '2019-06-07 07:24:48', '192.168.1.98', 'Windows 10', 1),
(287, '0ed9cc87', '2019-06-07 08:59:45', '2019-06-07 08:59:58', '2019-06-07 09:01:21', '192.168.1.98', 'Windows 10', 1),
(288, '1629ef9e', '2019-06-07 09:01:57', '2019-06-07 09:02:26', '2019-06-07 09:03:48', '192.168.1.98', 'Windows 10', 6),
(289, 'c67e3a02', '2019-06-07 09:04:08', '2019-06-07 09:08:33', '2019-06-07 09:09:55', '192.168.1.98', 'Windows 10', 1),
(290, 'd63a9189', '2019-06-07 09:10:05', '2019-06-07 09:10:28', '2019-06-07 09:11:02', '192.168.1.98', 'Windows 10', 1),
(291, '1ba24a12', '2019-06-07 09:11:33', '2019-06-07 09:15:55', '2019-06-07 09:16:33', '192.168.1.98', 'Windows 10', 1),
(292, '265b2b06', '2019-06-07 09:16:49', '2019-06-07 09:17:02', '2019-06-07 09:27:52', '192.168.1.98', 'Windows 10', 1);

SET IDENTITY_INSERT "sesiones" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "tipo_cliente"
--

DROP TABLE IF EXISTS `tipo_cliente`;
CREATE TABLE "tipo_cliente" ;

--
-- Volcado de datos para la tabla "tipo_cliente"
--

SET IDENTITY_INSERT "tipo_cliente" ON ;
INSERT INTO "tipo_cliente" ("tip_cli_codigo", "tip_cli_descripcion") VALUES
(1, 'Primera vez'),
(2, 'Cada año'),
(3, 'Ocasional'),
(4, 'Familiar'),
(5, 'Frecuente');

SET IDENTITY_INSERT "tipo_cliente" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "tipo_habitacion"
--

DROP TABLE IF EXISTS `tipo_habitacion`;
CREATE TABLE "tipo_habitacion" ;

--
-- Volcado de datos para la tabla "tipo_habitacion"
--

SET IDENTITY_INSERT "tipo_habitacion" ON ;
INSERT INTO "tipo_habitacion" ("tip_hab_codigo", "tip_hab_descripcion", "tip_hab_capacidad", "tip_hab_precio") VALUES
(1, 'personal', 1, 800),
(2, 'pareja', 2, 1000),
(3, 'familiar', 5, 2000);

SET IDENTITY_INSERT "tipo_habitacion" OFF;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla "usuarios"
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE "usuarios" ;

--
-- Volcado de datos para la tabla "usuarios"
--

SET IDENTITY_INSERT "usuarios" ON ;
INSERT INTO "usuarios" ("usr_id", "usr_login", "usr_pwd", "usr_fcreacion", "ses_id") VALUES
(1, 'kikeman', '8998', '2019-06-02 20:51:58', 1),
(2, 'adm_hotel', 'administrador', '2019-06-03 14:22:50', 1),
(3, 'mod_hotel', 'moderador', '2019-06-03 14:22:50', 1),
(4, 'usr_hotel', 'usuario', '2019-06-03 14:22:50', 1),
(6, 'andre', '123456', '2019-06-05 14:01:13', 35),
(9, 'trabajadora', '1234', '2019-06-07 04:58:11', 266);

SET IDENTITY_INSERT "usuarios" OFF;

--
-- Disparadores "usuarios"
--
DROP TRIGGER IF EXISTS `t_delete_usr`;
DELIMITER $$
CREATE TRIGGER `t_delete_usr` AFTER DELETE ON `usuarios` FOR EACH ROW BEGIN
	UPDATE sesiones
    SET ses_ultima_actividad = NOW()
    WHERE ses_id = OLD.ses_id;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `t_insert_usr`;
DELIMITER $$
CREATE TRIGGER `t_insert_usr` AFTER INSERT ON `usuarios` FOR EACH ROW BEGIN
	UPDATE sesiones
    SET ses_ultima_actividad = NOW()
    WHERE ses_id = NEW.ses_id;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `t_update_usr`;
DELIMITER $$
CREATE TRIGGER `t_update_usr` AFTER UPDATE ON `usuarios` FOR EACH ROW BEGIN
	UPDATE sesiones
    SET ses_ultima_actividad = NOW()
    WHERE ses_id = OLD.ses_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista "vactestancia"
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vactestancia`;
CREATE TABLE IF NOT EXISTS `vactestancia` (
`cli_nombre` varchar(255)
,`hab_codigo` int(11)
,`est_fechallegada` datetime
,`est_fechasalida` datetime
,`est_total` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista "vactest_cboxclientes"
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vactest_cboxclientes`;
CREATE TABLE IF NOT EXISTS `vactest_cboxclientes` (
`cli_nombre` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista "vacthab"
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vacthab`;
CREATE TABLE IF NOT EXISTS `vacthab` (
`hab_codigo` int(11)
,`tip_hab_descripcion` varchar(255)
,`tip_hab_capacidad` int(11)
,`tip_hab_precio` int(11)
,`hab_disponible` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista "vacthab_mob"
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vacthab_mob`;
CREATE TABLE IF NOT EXISTS `vacthab_mob` (
`hab_codigo` int(11)
,`mob_nombre` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura para la vista "vactestancia"
--
DROP TABLE IF EXISTS `vactestancia`;

CREATE VIEW "hotel"."vactestancia"  AS  select "cli"."cli_nombre" AS "cli_nombre","hab"."hab_codigo" AS "hab_codigo","est"."est_fechallegada" AS "est_fechallegada","est"."est_fechasalida" AS "est_fechasalida","est"."est_total" AS "est_total" from (("hotel"."cliente" "cli" left join "hotel"."estancia" "est" on(("cli"."cli_id" = "est"."cli_id"))) left join "hotel"."habitacion" "hab" on(("est"."hab_codigo" = "hab"."hab_codigo"))) where (now() between "est"."est_fechallegada" and "est"."est_fechasalida") ;

-- --------------------------------------------------------

--
-- Estructura para la vista "vactest_cboxclientes"
--
DROP TABLE IF EXISTS `vactest_cboxclientes`;

CREATE VIEW "hotel"."vactest_cboxclientes"  AS  select "cli"."cli_nombre" AS "cli_nombre" from ("hotel"."cliente" "cli" left join "hotel"."estancia" "est" on(("cli"."cli_id" = "est"."cli_id"))) where (now() between "est"."est_fechallegada" and "est"."est_fechasalida") ;

-- --------------------------------------------------------

--
-- Estructura para la vista "vacthab"
--
DROP TABLE IF EXISTS `vacthab`;

CREATE VIEW "hotel"."vacthab"  AS  select "h"."hab_codigo" AS "hab_codigo","th"."tip_hab_descripcion" AS "tip_hab_descripcion","th"."tip_hab_capacidad" AS "tip_hab_capacidad","th"."tip_hab_precio" AS "tip_hab_precio","h"."hab_disponible" AS "hab_disponible" from ("hotel"."habitacion" "h" left join "hotel"."tipo_habitacion" "th" on(("h"."tip_hab_codigo" = "th"."tip_hab_codigo"))) order by "h"."hab_codigo" ;

-- --------------------------------------------------------

--
-- Estructura para la vista "vacthab_mob"
--
DROP TABLE IF EXISTS `vacthab_mob`;

CREATE VIEW "hotel"."vacthab_mob"  AS  select "hm"."hab_codigo" AS "hab_codigo","m"."mob_nombre" AS "mob_nombre" from ("hotel"."habitacion_mobiliario" "hm" left join "hotel"."mobiliario" "m" on(("hm"."mob_codigo" = "m"."mob_codigo"))) order by "hm"."hab_codigo" ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
