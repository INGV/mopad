#!/usr/bin/python2.7
import cgi
import cgitb; cgitb.enable() # Optional; for debugging only

#  from art import *
#  Art=text2art("TEST",font='block',chr_ignore=True)
print('Content-Type: text/plain')
print('')
print('This is my test!')
#  print(Art)

arguments = cgi.FieldStorage()
for i in arguments.keys():
 print arguments[i].name, '=', arguments[i].value

print arguments['a'].value

