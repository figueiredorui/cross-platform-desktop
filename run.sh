#!/bin/sh

cd src/api

dotnet restore

dotnet publish -r osx.10.11-x64 --output bin/dist/osx

cd ../app

CMD /C npm install

CMD /C npm start
