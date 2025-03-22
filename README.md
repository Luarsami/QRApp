# QRApp - Aplicación iOS con Flutter

## Descripción

QRApp es una aplicación iOS que utiliza un módulo Flutter integrado mediante Flutter Channels. Esto permite la comunicación entre el código nativo de iOS (Swift/Objective-C) y Flutter (Dart).

## Estructura del Proyecto

El proyecto está organizado de la siguiente manera:

- **ios/**: Contiene el código nativo de la aplicación iOS.
  - `QRApp.xcworkspace`: Espacio de trabajo de Xcode.
  - `QRApp.xcodeproj`: Proyecto de Xcode.
  - `Podfile`: Configuración de dependencias de CocoaPods.
- **flutter\_module/**: Contiene el módulo Flutter.
  - `lib/`: Código fuente principal en Dart.
  - `pubspec.yaml`: Archivo de configuración de dependencias de Flutter.

## Configuración y Ejecución

1. Instalar dependencias de Flutter:
   ```sh
   cd flutter_module
   flutter pub get
   ```
2. Instalar dependencias de iOS:
   ```sh
   cd ios
   pod install
   ```
3. Abrir y ejecutar en Xcode:
   ```sh
   open QRApp.xcworkspace
   ```
4. Compilar y correr la aplicación desde Xcode en un simulador o dispositivo físico.

### Nota:

Si Xcode no detecta correctamente Flutter, usar los siguientes comandos:

```sh
cd flutter_module

flutter clean
flutter pub get
flutter build ios-framework --no-debug --output=./build/ios-framework

mkdir -p .ios/Flutter/Release
cp -R build/ios-framework/Release/Flutter.xcframework .ios/Flutter/Release/

cd ../ios
pod install --repo-update
```

También  dentro de Xcode, abrir QRApp.xcodeproj > Build Phases > Link Binary With Libraries > Agrega Flutter.xcframework

## Fastlane

Para automatizar la construcción y distribución, hemos configurado Fastlane.

### Instalación de Fastlane

Si no tienes Fastlane instalado, puedes hacerlo con:

```sh
sudo gem install fastlane -NV
```

### Uso de Fastlane

Desde la carpeta `ios/`, ejecutar:

```sh
fastlane ios beta
```

Esto compilará y enviará la app a TestFlight.

### Configuración

El archivo `Fastfile` se encuentra en `ios/fastlane/Fastfile` y contiene los scripts de automatización.

