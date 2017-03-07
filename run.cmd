@echo off

cd src/api

dotnet restore

dotnet publish -r win10-x64 --output bin/dist/win

cd ../app

CMD /C npm install

CMD /C npm start
