import 'package:copycat_base/data/repositories/clipboard.dart';
import 'package:copycat_base/domain/sources/clipboard.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/enums/clip_type.dart';
import 'package:copycat_base/enums/platform_os.dart';
import 'package:copycat_base/common/paginated_results.dart';
import 'package:copycat_base/enums/sort.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeClipboardSource implements ClipboardSource {
  int getLatestCalled = 0;
  int decryptPendingCalled = 0;
  ClipboardItem? latestItem;

  FakeClipboardSource({this.latestItem});

  @override
  Future<ClipboardItem> create(ClipboardItem item) async => item;

  @override
  Future<bool> delete(ClipboardItem item) async => true;

  @override
  Future<void> deleteAll() async {}

  @override
  Future<ClipboardItem?> get({int? id, String? serverId}) async => null;

  @override
  Future<PaginatedResult<ClipboardItem>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    Set<TextCategory>? textCategories,
    Set<ClipItemType>? types,
    int? collectionId,
    ClipboardSortKey? sortBy,
    SortOrder order = SortOrder.desc,
    DateTime? from,
    DateTime? to,
  }) async => PaginatedResult(results: const [], hasMore: false);

  @override
  Future<ClipboardItem> update(ClipboardItem item) async => item;

  @override
  Future<ClipboardItem?> getLatest() async {
    getLatestCalled++;
    return latestItem;
  }

  @override
  Future<void> decryptPending() async {
    decryptPendingCalled++;
  }
}

void main() {
  group('ClipboardRepositoryCloudImpl', () {
    test('getLatest delegates to remote source and decrypts', () async {
      final item = ClipboardItem(
        created: DateTime.now(),
        modified: DateTime.now(),
        type: ClipItemType.text,
        os: PlatformOS.linux,
      );
      final source = FakeClipboardSource(latestItem: item);
      final repo = ClipboardRepositoryCloudImpl(source);

      final result = await repo.getLatest();
      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Should not fail'), (r) {
        expect(r, equals(item));
      });
      expect(source.getLatestCalled, 1);
    });

    test('decryptPending delegates to remote source', () async {
      final source = FakeClipboardSource();
      final repo = ClipboardRepositoryCloudImpl(source);
      final result = await repo.decryptPending();
      expect(result.isRight(), isTrue);
      expect(source.decryptPendingCalled, 1);
    });
  });
}
