# cross-platform-desktop

Simple cross-platform desktop to demonstrate how .Net Core can be used in an Electron application.

## demos

[Windows](https://raw.githubusercontent.com/figueiredorui/cross-platform-desktop/master/dist/cross-platform-desktop%20Setup%201.0.0.exe)

[MacOs](https://raw.githubusercontent.com/figueiredorui/cross-platform-desktop/master/dist/mac/cross-platform-desktop-1.0.0.dmg)

## run

### Install prerequisites


#### Windows
​
Download and install the latest [.NET Core SDK for Windows](https://dotnetcli.blob.core.windows.net/dotnet/Sdk/rel-1.0.0/dotnet-dev-win-x64.latest.exe)

```bash
run.cmd
```
​
#### MacOS
​
In order to use .NET Core on MacOS, we first need to install the latest version of OpenSSL. The easiest way to get this is from [http://brew.sh/](http://brew.sh/)
​
After installing brew, do the following:
```bash 
brew update
brew install openssl
mkdir -p /usr/local/lib
ln -s /usr/local/opt/openssl/lib/libcrypto.1.0.0.dylib /usr/local/lib/
ln -s /usr/local/opt/openssl/lib/libssl.1.0.0.dylib /usr/local/lib/ 
```
    
Then download and install the latest [.NET Core SDK for MacOS](https://dotnetcli.blob.core.windows.net/dotnet/Sdk/rel-1.0.0/dotnet-dev-osx-x64.latest.pkg)

```bash
./run.sh
```

## build distributables

```bash
npm run dist
```

