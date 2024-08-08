local lcPath, ;
 loForm
* Write the current contents of CODE to a file.
lcPath = addbs(sys(2023)) + trim(NAME)
strtofile(CODE, lcPath)
* Create a form with the desired characteristics for
* the PRG window.
loForm = createobject('Form')
with loForm
 .Caption = trim(NAME)
 .Width = _screen.Width - 50
 .Height = _screen.Height - 50
 .FontName = 'Courier New'
 .FontSize = 10
endwith
* Edit the code in a PRG window, then put the results
* back into CODE.
modify command (lcPath) window (loForm.Name)
replace CODE with filetostr(lcPath)
erase (lcPath)
