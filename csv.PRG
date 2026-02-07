lcFileName = "D:\PsysTr\PLEDepEduarEIRL\importar.csv"
USE (lcFileName) EXCLUSIVE 
lnFields = FCOUNT()
DIMENSION laFields[lnFields,2]
FOR ii = 1 TO lnFields 
	laFields[ii,1] = ' '
	laFields[ii,2] =  0
ENDFOR
*
SCAN ALL 
	FOR ii = 1 TO lnFields
		laFields[ii,1] = FIELD(ii)
		laFields[ii,2] = MAX(laFields[ii,2],LEN(ALLTRIM(FIELD(ii))))
	ENDFOR
ENDSCAN 
*
FOR ii = 1 TO lnFields
	lcRun = "ALTER table CVSIMPORT ALTER COLUMN " + laFileds[ii,1] + " c(" + TRANSFORM(laFields[ii,2])+")"
	&lcRun
ENDFOR