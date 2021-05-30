## Sin crear una nueva imagen

Instrucciones para arrancar un entorno de Sonar (edición Comunidad) con plugins que queramos probar.

Salvo los volúmenes, intento no crear ninguna otra imagen intermedia. La idea es usar directamente las imágenes principales ofrecidas por [SonarQube](https://hub.docker.com/_/sonarqube) y por [Postgres](https://hub.docker.com/_/postgres/).

Pasos:

1. Crear volumen base de datos, elastic search y extensiones (plugins):

   ```shell
   docker volume create sonar-data
   docker volume create sonar-search
   docker volume create sonar-plugins
   ```

1. Recolectar los plugins y grabarlos en el volumen de plugins.
   
   Para elegir una lista de plugins diferentes modificar el script `download-plugins`.

   ```shell
   ./download-plugins.sh
   ```

   Al finalizar tendremos los plugins que queremos usar como parte del volumen `sonar-plugins`.

1. Arrancar y detener el entorno:

   ```shell
   docker-compose up
   ```

   Para detener basta con lanzar `docker-compose up`.

   Al usar volúmenes, la información persiste entre dos ejecuciones.


*LIMPIAR:* Borrar los volúmenes:

   ```shell
   docker volume rm sonar-data
   docker volume rm sonar-search
   docker volume rm sonar-plugins
   ```

## Creando una imagen

Porque queramos desplegar en Cloud, distribuirla ...

   ```shell
   docker build -t nimio/sonarqube:8.9-community .
   ```

Para probarla: `docker run -it --rm -p 9000:9000 nimio/sonarqube:8.9-community`.
