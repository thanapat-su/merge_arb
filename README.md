Codegen that merges multiple ARB files into a single ARB file.

## Features

Flutter app only support one ARB file for string localization. With this codegen, you can split your string localization into multiple ARB files.

## Getting started

```shell
flutter pub add --dev merge_arb build_runner
```

## Usage

Create ARB files in `lib/l10n` directory. For example, `lib/l10n/en.arb`, `lib/l10n/id.arb`, etc.

