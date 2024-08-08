*!*	SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADITIVE

*!*	* --- Crear un objeto FoxBarcodeQR y la imagen de código de barras QR Code
*!*	LOCAL loFbc, lcQRImage
*!*	loFbc = CREATEOBJECT("FoxBarcodeQR")
*!*	lcQRImage = loFbc.QRBarcodeImage("http://vfpx.codeplex.com/wikipage?title=FoxBarcode",, 6,2)
LOCAL lcMiTexto, lcMiArchivoImagen, loQR, lcQR_Imagen
 
  lcMiTexto = "EDUARTCH#TORRES#CHUPILLON#eduartch@hotmail.com#952677319#CHICLAYO#PERU#"
 
  lcMiArchivoImagen = Sys(5) + Curdir() + "MiImagenQR.PNG"
 
  SET PROCEDURE TO d:\capass\FOXBARCODEQR ADDITIVE
 
  loQR = CreateObject("FoxBarCodeQR")
 
  lcQR_Imagen = loQR.QRBarCodeImage(lcMiTexto, lcMiArchivoImagen, 6, 2)
 
  SET PROCEDURE TO
 
RETURN