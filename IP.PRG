camino = FULLPATH('d:\psysn\conexion.txt')
IF FILE(camino)  && verificar si el archivo existe?
   gnErrFile = FOPEN(camino,12)&&si es así,abrir para leer y   escribir
   sserver = FGETS(gnErrFile)
   sdatabase = FGETS(gnErrFile)
ENDIF 
