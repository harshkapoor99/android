# guftagu_mobile

The Guftagu mobile application project in flutter

## Build

#### Generate assets + fonts code + riverpod code

- `dart run build_runner build`

#### _Note: It is required to build generated codes before build_

_The generated files are ignored for development convenience, only commit if need to reduce CI time_

## Dev

#### Keep generating assets + fonts code + riverpod code on code change

- `dart run build_runner watch`

_PS: generated files are at **lib/gen**_

#### Generate app icons 

 - `dart run flutter_launcher_icons`

<!-- #### Generate native splash icon 

 - `dart run flutter_native_splash:create` -->

<!-- #### Generate hive code

- `flutter packages pub run build_runner build` -->