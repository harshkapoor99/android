# guftagu_mobile

The Guftagu mobile application project in flutter

## Localisation Status

- [x] English
- [x] Hindi
- [ ] Bengali
- [ ] Marathi
- [ ] Tamil
- [ ] Telugu
- [ ] Gujarati
- [ ] Kannada
- [ ] Odia
- [ ] Urdu
- [ ] Malayalam
- [ ] Spanish
- [ ] Arabic
- [ ] Mandarin Chinese
- [ ] French
- [ ] German
- [ ] Portuguese
- [ ] Japanese
- [ ] Russian
- [ ] Korean


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

#### Generate locales 

 - `flutter gen-l10n  --no-synthetic-package --arb-dir=lib/l10n --output-dir=lib/gen/l10n --template-arb-file=intl_en.arb --no-use-escaping --no-nullable-getter --output-localization-file=app_localizations.gen.dart`

<!-- #### Generate native splash icon 

 - `dart run flutter_native_splash:create` -->

<!-- #### Generate hive code

- `flutter packages pub run build_runner build` -->