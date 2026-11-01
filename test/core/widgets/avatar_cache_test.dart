import 'package:flutter_test/flutter_test.dart';
import 'package:app_despesas/core/widgets/app_avatar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AvatarCacheService', () {
    test('getLocalAvatar deve retornar null para userId nulo ou vazio', () async {
      expect(await AvatarCacheService.getLocalAvatar(null), isNull);
      expect(await AvatarCacheService.getLocalAvatar(''), isNull);
    });

    test('deleteLocalAvatar deve lidar com userId nulo ou vazio com segurança', () async {
      await expectLater(AvatarCacheService.deleteLocalAvatar(null), completes);
      await expectLater(AvatarCacheService.deleteLocalAvatar(''), completes);
    });

    test('notifyAvatarChanged deve incrementar avatarUpdateNotifier reativamente', () {
      final initialVal = AvatarCacheService.avatarUpdateNotifier.value;
      AvatarCacheService.notifyAvatarChanged();
      expect(AvatarCacheService.avatarUpdateNotifier.value, initialVal + 1);
    });
  });
}
