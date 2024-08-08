Public IPSocket
crlf=Chr(13)+Chr(10)
IPSocket = Createobject("MSWinsock.Winsock")
If Type('IPSocket')='O'
	IPAddress = IPSocket.LocalIP
	localhostname=IPSocket.localhostname
	remotehost=IPSocket.remotehost
	remotehostip=IPSocket.remotehostip
	Messagebox ("Local IP = " + IPAddress+crlf+"local host = "+localhostname;
		+crlf+"Remotehost = "+remotehost+crlf+"Remotehostip = "+remotehostip)
Else
	Messagebox('Unable to determine IP Address')
Endif
