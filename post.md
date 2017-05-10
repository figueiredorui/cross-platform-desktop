# How to build a cross-platform desktop application with Electron and .Net Core

In this tutorial we'll show how to create a simple cross-platform desktop to demonstrate how .Net Core can be used in an Electron application. To accomplish that we are going to create a .Net Core console application and an Electron application and show how to combine both.

At the end of the tutorial, we'll have a distributable package of the application.

## Development tools and prerequisites

This tutorial focuses on creating a simple cross-platform desktop to demonstrate how .Net Core can be used in an Electron application and therefore requires basic understanding of the following technologies:

### Electron

Electron is a popular tool for building desktop apps for different platforms (OSX, Windows, Linux) with web technologies (HTML, CSS, JS). We'll use NPM to download Electron.

### AngularJS

AngularJS is a structural framework for dynamic web apps. It lets you use HTML as your template language and lets you extend HTML's syntax to express your application's components clearly and succinctly. AngularJS's data binding and dependency injection eliminate much of the code you would otherwise have to write. And it all happens within the browser, making it an ideal partner with any server technology. We'll use NPM to download AngularJS.

### .Net Core

.NET Core is the new big thing in the .NET universe that allows to build cross-platform apps on Windows, Mac and Linux. To start developing using .Net Core we need first to install .NET Core SDK.

#### Windows

Download and install the latest [.NET Core SDK for Windows](https://dotnetcli.blob.core.windows.net/dotnet/Sdk/rel-1.0.0/dotnet-dev-win-x64.latest.exe)

#### MacOS

In order to use .NET Core on MacOS, we first need to install the latest version of OpenSSL. The easiest way to get this is from [http://brew.sh/](http://brew.sh/)

After installing brew, do the following:
```bash 
brew update
brew install openssl
mkdir -p /usr/local/lib
ln -s /usr/local/opt/openssl/lib/libcrypto.1.0.0.dylib /usr/local/lib/
ln -s /usr/local/opt/openssl/lib/libssl.1.0.0.dylib /usr/local/lib/ 
```
    
Then download and install the latest [.NET Core SDK for MacOS](https://dotnetcli.blob.core.windows.net/dotnet/Sdk/rel-1.0.0/dotnet-dev-osx-x64.latest.pkg)

## Getting Started

Let’s kick start our application by creating the folder structure. The folder structure for the project should look like the following

```
+-- assets - icons, images, etc.
+-- dist - distributable files
+-- src 
|   +-- api - .Net Core console application
|   +-- app - Electron + AngularJS
```

The source code is split in two folders, api and app. Let’s begin by creating the api - .Net Core console application.

### api - .Net Core console application

To create a console application we going to use the following dotnet command.

```bash
dotnet new console  
```

This command creates two files, program.cs and api.csproj.

```code
using System;

namespace api
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
```

```xml
<Project Sdk="Microsoft.NET.Sdk" ToolsVersion="15.0">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp1.1</TargetFramework>
  </PropertyGroup>

</Project>
```

This is a simple hello world console application. Let's run it executing commands below.

```bash
dotnet restore
dotnet run
```

Our console application has just compiled and launched, displaying 'Hello World!'. 
Up until now, everything we’ve done has resulted in a minimal .Net Core console application.

Now we going to turn it into a web api in three steps:

First, adding required packages to the api.csproj file

```xml
<ItemGroup>
    <PackageReference Include="Microsoft.NETCore.App">
      <Version>1.1.0</Version>
    </PackageReference>
    <PackageReference Include="Microsoft.AspNetCore.Mvc">
      <Version>1.1.0</Version>
    </PackageReference>
    <PackageReference Include="Microsoft.AspNetCore.Routing">
      <Version>1.1.0</Version>
    </PackageReference>
    <PackageReference Include="Microsoft.AspNetCore.Server.Kestrel">
      <Version>1.1.0</Version>
    </PackageReference>
</ItemGroup>
```
These packages need to be restored

```bash
dotnet restore
```
	
Second, replacing program.cs content with code bellow
```cs 	
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;

namespace api
{
    class Program
    {
        public static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseStartup<Startup>()
                .Build();

            host.Run();
        }
    }

    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Add framework services.
            services.AddMvc().AddJsonOptions(options =>
               {
                   //return json format with Camel Case
                   options.SerializerSettings.ContractResolver = new Newtonsoft.Json.Serialization.DefaultContractResolver();
               });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app)
        {
            app.UseMvc();
        }
    }
}
```
And last step, let's add a ContactsController.cs file inside a folder called Controllers and add file content below.

```cs
using System;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [Route("api/[controller]")]
    public class ContactsController : Controller
    {
        // GET api/contacts
        [HttpGet]
        public IActionResult Get()
        {
            var result = new [] {
                new { FirstName = "John", LastName = "Doe" },
                new { FirstName = "Mike", LastName = "Smith" }
            };

            return Ok(result);
        }
    }
}
```
We have just transformed a simple console application into a self-hosted web api. Let's run it and see the result.

```bash
dotnet run
```
We can see that the command has created a service and it's running on localhost port 5000. 
The service can be tested by opening the url http://localhost:5000/api/contacts on a browser where a json result is displayed.


#### Build an executable

.Net Core provides a feature called Self-contained application that allows to deploy applications by just copy files to the target host, without need to install any .Net runtime. Furthermore, we can deploy it on any platform (Windows, Linux, OSX).
All we need to do is to specify which runtimes we are supporting by adding the following line to the api.csproj file inside the <PropertyGroup> tag. For example we will be deploying for Windows 10 and MacOs.

```xml
<RuntimeIdentifiers>win10-x64;osx.10.11-x64</RuntimeIdentifiers>
```
The next step, we run the restore command followed by the publish command.

```bash
dotnet restore
// publish for windows
dotnet publish -r win10-x64 --output bin/dist/win
// publish for macos
dotnet publish -r osx.10.11-x64 --output bin/dist/osx
```
After running this commands an executable application can be found inside the api/bin/dist/{os} folder and by executing it we should see a console window displaying information about the service running on localhost port 5000. To test it we browse http://localhost:5000/api/contacts and should display contacts in json format.

The first part of this tutorial is completed. While leaving the console window open we'll now create the Electron application.

### app - electron + angularJs

First, let's move to the src/app path, where we need to create a package.json file that will reference Electron and AngularJS dependencies.

```Json
{
  "name": "cross-platform-desktop",
  "version": "1.0.0",
  "description": "cross-platform-desktop",
  "author": "",
  "repository": "",
  "main": "main.js",
  "devDependencies": {
    "electron": "^1.4.1"
  },
  "dependencies": {
    "angular": "^1.6.1"
  },
  "scripts": {
    "start": "electron ."
  }
}

```
and install these references

```bash
npm install
```

Next, we create a file main.js that's going to be our entry point for our application

```js
const electron = require('electron')
// Module to control application life.
const app = electron.app
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow

const path = require('path')
const url = require('url')

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 800, height: 600})

  // and load the index.html of the app.
  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'index.html'),
    protocol: 'file:',
    slashes: true
  }))

  // Open the DevTools.
  mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
})
// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
```

Next step is to create an index.html file to display contact details

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contacts App</title>
</head>
<body>
    <div class="container" ng-controller="ContactsCtrl as ctrl">
        <h1>{{ctrl.Title}}</h1>
        <p style="color: red" ng-show="ctrl.ErrorMessage">{{ctrl.ErrorMessage}}</p>
        <table >
            <thead>
                <tr>
                    <th style="min-width: 80px;">First name</th>
                    <th style="min-width: 80px;">Last name</th>
                </tr>
            </thead>
            <tbody>
                <tr ng-repeat="contact in ctrl.Contacts">
                    <td>{{ contact.FirstName }}</td>
                    <td>{{ contact.LastName }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
<script type="text/javascript" src="node_modules/angular/angular.min.js"></script>
<script type="text/javascript" src="app/app.js"></script>
</html>
```

Finally,  create an app.js file where we will initialize AngularJS, have a controller responsible for data binding and a service to fetch data from http://localhost:5000/api/contacts

```js
'use strict';

var app = angular.module('ContactsApp', []);

document.addEventListener('DOMContentLoaded', function () {
    angular.bootstrap(document, ['ContactsApp']);
});

app.controller('ContactsCtrl', function (ContactsService) {
    var ctrl = this;
    ctrl.Title = 'Contacts List';

    LoadContacts();

    function LoadContacts() {
        ContactsService.Get()
            .then(function (contacts) {
                ctrl.Contacts = contacts
            }, function (error) {
                ctrl.ErrorMessage = error
            });
    }
});

app.service('ContactsService', function ($http) {
    var svc = this;
    var apiUrl = 'http://localhost:5000/api';

    svc.Get = function () {
        return $http.get(apiUrl + '/contacts')
            .then(function success(response) {
                return response.data;
            });
    }
});
```

We got everything to run our Electron application using following command

```bash
npm start
```
An Electron window shows displaying contacts details returned from http://localhost:5000/api/contacts

### Combining the .Net Core console application and the Electron application.

So far we have two separated applications running the .Net Core console application and electron application.
Now, as a crucial step for this tutorial, we going to combine them into a single application. To accomplish this we going to tell Electron to start the console application on the background by adding the following code to the end of main.js file.

```js
const os = require('os');
var apiProcess = null;

function startApi() {
  var proc = require('child_process').spawn;
  //  run server
  var apipath = path.join(__dirname, '..\\api\\bin\\dist\\win\\api.exe')
  if (os.platform() === 'darwin') {
    apipath = path.join(__dirname, '..//api//bin//dist//osx//Api')
  }
  apiProcess = proc(apipath)

  apiProcess.stdout.on('data', (data) => {
    writeLog(`stdout: ${data}`);
    if (mainWindow == null) {
      createWindow();
    }
  });
}

//Kill process when electron exits
process.on('exit', function () {
  writeLog('exit');
  apiProcess.kill();
});

function writeLog(msg){
  console.log(msg);
}
```

and by replacing line 40 on main.js
```js
app.on('ready', createWindow)
```
with
```js
app.on('ready', startApi)
```
Now, make sure the console windows and the Electron window are closed before run the following command.

```bash
npm start
```

Finally, we see an Electron window with the contact list fetched.

## Distribution

As part of this tutorial we going to show how to distribute our application. First, we need to download the [electron-builder](https://github.com/electron-userland/electron-builder) library. electron-builder is a complete solution to package and build a ready for distribution Electron app for MacOS, Windows and Linux with “auto update” support out of the box.

Let's download electron-builder.

```bash
npm install electron-builder --save-dev
```

Next, we specify the build configuration in the package.json as follows:

```Json
"scripts": {
    "start": "electron .",
    "dist": "build"
  },
  "build": {
    "appId": "cross-platform-desktop",
    "directories": {
      "buildResources": "../../assets",
      "output": "../../dist"
    },
    "extraResources": {
      "from": "../api/bin/dist/",
      "to": "api/bin/dist/",
      "filter": [
        "**/*"
      ]
    },
    "mac": {
      "category": "cross-platform-desktop"
    },
    "win": {
      "target": [
        "nsis"
      ]
    }
  }
```
Using extraResources we specify extra files to be included in the package, in this case, we want to include the Self-contained application published before to api/bin/dist/ folder.

```bash
npm run dist
```

All done! Generated packages are available in /dist folder.

## Conclusion

In this tutorial, we have been able to build a cross-platform desktop application using Electron and .Net Core. The full implementation can be found on [Github](https://github.com/figueiredorui/cross-platform-desktop) including distributable packages for [Windows](https://raw.githubusercontent.com/figueiredorui/cross-platform-desktop/master/dist/cross-platform-desktop%20Setup%201.0.0.exe) and [MacOs](https://raw.githubusercontent.com/figueiredorui/cross-platform-desktop/master/dist/mac/cross-platform-desktop-1.0.0.dmg).

Up next

As a part 2 of this tutorial we going to add the ability of managing the contacts by storing them in a SqLite database using [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/).

Thoughts? Improvements? Problems? Feel free to drop a comment.