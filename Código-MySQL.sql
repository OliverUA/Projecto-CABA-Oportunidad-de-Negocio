
# Corregir fechas

UPDATE hab2020  
SET FechaHabilitacion = STR_TO_DATE(FechaHabilitacion, '%m/%d/%Y');

UPDATE hab2021 
SET FechaHabilitacion = STR_TO_DATE(FechaHabilitacion, '%m/%d/%Y');

UPDATE hab19 
SET Fecha_Habilitacion = STR_TO_DATE(Fecha_Habilitacion, '%m/%d/%Y');

UPDATE hab17a18
SET Fecha_Habilitacion = STR_TO_DATE(Fecha_Habilitacion, '%m/%d/%Y');

# En una base de datos ajena hubiera creado una tabla temporal o un CTE pero aca la queria limpiar permanentemente en la base de datos local.

update `Estimacion Poblacional Ambos`
set 
    `1` = round(`1`*1000, 0),
    `2` = round(`2`*1000, 0),
    `3` = round(`3`*1000, 0),
    `4` = round(`4`*1000, 0),
    `5` = round(`5`*1000, 0),
    `6` = round(`6`*1000, 0),
    `7` = round(`7`*1000, 0),
    `8` = round(`8`*1000, 0),
    `9` = round(`9`*1000, 0), 
    `10` = round(`10`*1000, 0), 
    `11` = round(`11`*1000, 0), 
    `12` = round(`12`*1000, 0), 
    `13` = round(`13`*1000, 0), 
    `14` = round(`14`*1000, 0), 
    `15` = round(`15`*1000, 0) 
;

update `Estimacion Poblacional Hombres`
set 
    `1` = round(`1`*1000, 0),
    `2` = round(`2`*1000, 0),
    `3` = round(`3`*1000, 0),
    `4` = round(`4`*1000, 0),
    `5` = round(`5`*1000, 0),
    `6` = round(`6`*1000, 0),
    `7` = round(`7`*1000, 0),
    `8` = round(`8`*1000, 0),
    `9` = round(`9`*1000, 0), 
    `10` = round(`10`*1000, 0), 
    `11` = round(`11`*1000, 0), 
    `12` = round(`12`*1000, 0), 
    `13` = round(`13`*1000, 0), 
    `14` = round(`14`*1000, 0), 
    `15` = round(`15`*1000, 0) 
;

update `Estimacion Poblacional Mujeres`
set 
    `1` = round(`1`*1000, 0),
    `2` = round(`2`*1000, 0),
    `3` = round(`3`*1000, 0),
    `4` = round(`4`*1000, 0),
    `5` = round(`5`*1000, 0),
    `6` = round(`6`*1000, 0),
    `7` = round(`7`*1000, 0),
    `8` = round(`8`*1000, 0),
    `9` = round(`9`*1000, 0), 
    `10` = round(`10`*1000, 0), 
    `11` = round(`11`*1000, 0), 
    `12` = round(`12`*1000, 0), 
    `13` = round(`13`*1000, 0), 
    `14` = round(`14`*1000, 0), 
    `15` = round(`15`*1000, 0) 

;

ALTER TABLE hab2021 ADD Seccion INT NULL;

# Crear tablas temporales 

DROP TABLE IF EXISTS habs;
CREATE TEMPORARY TABLE habs
SELECT * 
FROM ( select 
         fecha_habilitacion, 
         descripcion_rubro, 
         Seccion 
       from hab17a18 as hab17a18
       union
       select 
         fecha_habilitacion, 
         descripcion_rubro, 
         Seccion 
       from hab19 as hab17a19
       union
       select 
         FechaHabilitacion as fecha_habilitacion, 
         DescripcionRubro as descripcion_rubro, 
         Seccion from hab2020 as hab17a20
       union
       select 
         FechaHabilitacion as fecha_habilitacion, 
         DescripcionRubro as descripcion_rubro, 
         Seccion from hab2021 as hab17a21) as habis;

DROP TABLE IF EXISTS salario;
CREATE TEMPORARY TABLE salario
SELECT *
FROM `Salario Promedio`
WHERE zona_prov = "CAPITAL FEDERAL"
ORDER BY fecha DESC;

DROP TABLE IF EXISTS Alquileres;
CREATE TABLE Alquileres
Select Año, Mes, Ambientes, Belgrano, Caballito, Palermo, Recoleta
from Alquiler;

update Alquileres
set 
    `Belgrano` = round(`Belgrano`*1000, 0),
    `Caballito` = round(`Caballito`*1000, 0),
    `Palermo` = round(`Palermo`*1000, 0),
    `Recoleta` = round(`Recoleta`*1000, 0)
;


# Años con más habilitacioens comerciales

SELECT YEAR(fecha_habilitacion) as Año, COUNT(descripcion_rubro) as Cantidad
FROM habs
GROUP BY YEAR(fecha_habilitacion)
ORDER BY cantidad DESC;

# Mes con más habilitacioens comerciales

SELECT MONTH(fecha_habilitacion) as mes, COUNT(descripcion_rubro) as Cantidad
FROM habs
GROUP BY MONTH(fecha_habilitacion)
ORDER BY cantidad DESC;

# Secciones con mas con más habilitaciones comerciales desde 2017 hasta fines de 2021.

select Seccion, COUNT(Seccion) as total
from habs
GROUP BY Seccion
ORDER BY total DESC
LIMIT 10;


# 10 tipos de rubros con mas habilitaciones comerciales desde 2017 hasta fines de 2021.

select descripcion_rubro, COUNT(descripcion_rubro) as total
from habs
GROUP BY descripcion_rubro
ORDER BY total DESC
LIMIT 10;

# Cantidad de habilitaciones por seccion de Comercios minoristas de bebidas en general envasadas.

select DISTINCT Seccion, total
from( select 
         descripcion_rubro, 
         Seccion, 
         count(Seccion) OVER(PARTITION BY Seccion ORDER BY Seccion DESC) as total
      from habs
      where descripcion_rubro = "COM.MIN.DE BEBIDAS EN GENERAL ENVASADAS"
      ORDER BY total desc) as der
;

# Cantidad de habilitaciones por seccion de COM.MIN.DE ARTIC. PERSONALES Y PARA REGALOS.

select DISTINCT Seccion, total
from( select 
         descripcion_rubro, 
         Seccion, 
         count(Seccion) OVER(PARTITION BY Seccion ORDER BY Seccion DESC) as total
      from habs
      where descripcion_rubro = "COM.MIN.DE ARTIC. PERSONALES Y PARA REGALOS"
      ORDER BY total desc) as der
;

# Cantidad de habilitaciones por seccion de COM.MIN.DE ROPA CONFECCION., LENCERIA, BLANCO,MANTEL.TEXT. EN GRAL.Y PIELES.

select DISTINCT Seccion, total
from( select 
         descripcion_rubro, 
         Seccion, 
         count(Seccion) OVER(PARTITION BY Seccion ORDER BY Seccion DESC) as total
      from habs
      where descripcion_rubro = "COM.MIN.DE ROPA CONFECCION., LENCERIA, BLANCO,MANTEL.TEXT. EN GRAL.Y PIELES"
      ORDER BY total desc) as der
;

#-

