SET TALK OFF

gnVal1 = 10

gnVal2 = 20

gnVal3 = 30

gnVal4 = 15

gnMin = getavg(gnVal1, gnVal2, gnVal3, gnVal4)

? 'Average value is '

?? gnMin



* This user-defined function permits up to 9 parameters to be passed.

* It uses the PCOUNT( ) function to determine how many

* were passed and returns the average value.



FUNCTION getavg

Lparameters  gnPara1,gnPara2,gnPara3,gnPara4

IF PCOUNT( ) = 0

   RETURN 0

ENDIF

gnResult = 0

FOR gnCount = 1 to PARAMETERS( )

   gcCompare = 'gnPara' +(STR(gnCount,1))

   gnResult = gnResult + EVAL(gcCompare)

ENDFOR

gnResult = gnResult / (gnCount - 1)

RETURN gnResult
