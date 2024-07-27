# FeriadosChile

Se nos pidio utilizar una Api para poder marcar presencia de su nueva área de 
desarrollo. Utilizamos la Api de Feriados legales de Chile (https://apis.digital.gob.cl/fl/#inicio), 
además de utilizar Widgets, dependencias de Flutter, persistencia de datos, un botón para compartir información,

## Video:

(Poner video aquí)

## La API
La API de Feriados Legales de Chile permite ver todos los feriados del año. Estos están almacenados con strings, booleanos y listas.
Esta información es extraida y almacenada en un JSON, para su futura lectura.

## Botón Compartir
La acción de compartir puesta en esta aplicación hace que se comparta un mensaje con la cantidad de días faltantes para el siguente feriado.

## Persistencia de Datos
Utilizando SharedPreferences, se genera el archivo JSON, y todos los datos de la API son almacenados en el JSON, y desde la pagina se extraen los días y meses 
del presente año de la API, y se almacenan en un JSON. Este archivo JSON queda guardado en el telefono, haciendo que no haga falta una conexión a internet 
para conocer los feriados. (Hasta el año que viene)

## Paleta de Colores Utilizado

![Paleta FeriadosChile](https://github.com/user-attachments/assets/662380ab-5a5b-4d7e-9100-0b04a8d79834)
