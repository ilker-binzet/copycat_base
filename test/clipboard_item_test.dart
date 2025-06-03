import 'dart:io';

import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/enums/clip_type.dart';
import 'package:copycat_base/enums/platform_os.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClipboardItem.cleanUp', () {
    test('does nothing when localPath is null', () async {
      final item = ClipboardItem(
        created: DateTime.now(),
        modified: DateTime.now(),
        type: ClipItemType.text,
        os: PlatformOS.linux,
      );

      await item.cleanUp();
    });

    test('deletes existing file at localPath', () async {
      final tempDir = await Directory.systemTemp.createTemp('clipboard_test');
      final tempFile = File('${tempDir.path}/sample.txt');
      await tempFile.writeAsString('hello');

      final item = ClipboardItem(
        created: DateTime.now(),
        modified: DateTime.now(),
        type: ClipItemType.file,
        os: PlatformOS.linux,
        localPath: tempFile.path,
      );

      expect(await tempFile.exists(), isTrue);
      await item.cleanUp();
      expect(await tempFile.exists(), isFalse);

      await tempDir.delete(recursive: true);
    });
  });
}
