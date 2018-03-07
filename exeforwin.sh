#!/bin/sh

lovefile="metalbug.love"
exefile="metalbug.exe"
zipfile="metalbug.zip"

zip -9 -r $lovefile . -x "./Winexe/*" ".git/*" 

cat Winexe/love.exe $lovefile > Winexe/${exefile}

zip -r $zipfile Winexe

