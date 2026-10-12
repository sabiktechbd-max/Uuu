import 'package:flutter_test/flutter_test.dart';
import 'package:private_agent/services/shizuku_service.dart';

void main() {
  group('Shizuku command safety allowlist', () {
    test('permits only explicitly listed non-destructive toggles', () {
      expect(ShizukuService.isAllowedCommand('svc wifi enable'), isTrue);
      expect(ShizukuService.isAllowedCommand('svc wifi disable'), isTrue);
      expect(
        ShizukuService.isAllowedCommand('cmd bluetooth_manager enable'),
        isTrue,
      );
      expect(
        ShizukuService.isAllowedCommand('cmd bluetooth_manager disable'),
        isTrue,
      );
    });

    test('rejects arbitrary and destructive shell commands', () {
      expect(ShizukuService.isAllowedCommand('pm clear com.example.app'), isFalse);
      expect(ShizukuService.isAllowedCommand('am force-stop com.example.app'), isFalse);
      expect(ShizukuService.isAllowedCommand('id; rm -rf /'), isFalse);
      expect(ShizukuService.isAllowedCommand(''), isFalse);
      expect(ShizukuService.isAllowedCommand(' svc wifi enable '), isTrue);
    });
  });
}
