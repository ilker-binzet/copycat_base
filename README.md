# CopyCat Base

This package provides the core logic used by the [CopyCat Clipboard App](https://github.com/raj457036/copycat_clipboard). It contains the database models, repositories and business logic that power clipboard capture and synchronisation.

## Directory overview

- **lib/bloc/** – BLoC/Cubit implementations that manage application state such as clipboard persistance, sync and authentication.
- **lib/common/** – Shared utility classes (failure wrappers, logging helpers).
- **lib/constants/** – String and style constants used throughout the app.
- **lib/data/** – Concrete implementations of repositories, services and data sources.
- **lib/db/** – Isar database collections and helpers.
- **lib/domain/** – Domain models and abstract repository interfaces.
- **lib/di/** – Dependency injection configuration using `injectable` and `get_it`.
- **lib/enums/** – Enum definitions used across the codebase.
- **lib/l10n/** – Localization resources.
- **lib/utils/** and **lib/widgets/** – Misc utilities and reusable widgets.

## Dependency injection

All dependencies are registered using `injectable`. To initialise the micro package inside a host application call:

```dart
import 'package:copycat_base/di/di.dart';

Future<void> main() async {
  await initModules();
  // runApp(...);
}
```

`initModules()` pre-resolves the required `Isar` database, storage and other services so that they can be retrieved from `get_it`.

## Clipboard capture & sync flow

1. `ClipboardService` listens to system clipboard changes via `ClipboardWatcher` and `super_clipboard`.
2. `OfflinePersistanceCubit` converts captured `ClipItem`s into `ClipboardItem` models and stores them in the local Isar database through the repository layer. Manual paste actions mark the item with `userIntent`.
3. `SyncManagerCubit` periodically synchronises local data with the remote source through `SyncRepository`. It downloads remote changes, uploads local ones and updates `SyncStatus` with the last sync time.
4. Additional cubits such as `CloudPersistanceCubit` or `DriveSetupCubit` handle uploading/downloading of files when cloud features are enabled.

## Development

Run tests with:

```bash
flutter test
```

Generate localization files after editing ARB resources with:

```bash
flutter gen-l10n
```

Both commands require the Flutter SDK and will update the generated files in `lib/l10n/generated/`.
