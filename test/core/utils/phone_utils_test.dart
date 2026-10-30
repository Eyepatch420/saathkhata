import 'package:flutter_test/flutter_test.dart';
import 'package:saath_khata/core/utils/phone_utils.dart';

/// The OTP endpoints match users on exactly 10 digits. Anything a keyboard,
/// clipboard, autofill or deep link adds — `+91`, spaces, dashes, a trunk zero —
/// must be removed before the number ever reaches the wire.
void main() {
  group('normalizeIndianPhone', () {
    test('keeps a plain 10-digit number untouched', () {
      expect(normalizeIndianPhone('9650263185'), '9650263185');
    });

    test('strips the +91 country code', () {
      expect(normalizeIndianPhone('+919650263185'), '9650263185');
    });

    test('strips spaces, dashes and parentheses', () {
      expect(normalizeIndianPhone('+91 96502 63185'), '9650263185');
      expect(normalizeIndianPhone('91-96502-63185'), '9650263185');
      expect(normalizeIndianPhone('(91) 96502 63185'), '9650263185');
      expect(normalizeIndianPhone('  9650263185  '), '9650263185');
    });

    test('strips a leading trunk zero', () {
      expect(normalizeIndianPhone('09650263185'), '9650263185');
    });

    test('never produces a double country code', () {
      for (final input in ['+919650263185', '919650263185', '09650263185']) {
        expect(normalizeIndianPhone(input), '9650263185', reason: input);
      }
    });

    test('leaves junk for validation to reject', () {
      expect(normalizeIndianPhone('12345'), '12345');
      expect(normalizeIndianPhone(''), '');
      expect(isValidIndianPhone('12345'), isFalse);
      expect(isValidIndianPhone('5876543210'), isFalse);
    });
  });

  group('isValidIndianPhone', () {
    test('accepts every formatted form of a real number', () {
      for (final input in [
        '9650263185',
        '+91 96502 63185',
        '+919650263185',
        '09650263185',
        '91-96502-63185',
      ]) {
        expect(isValidIndianPhone(input), isTrue, reason: input);
      }
    });
  });

  group('formatIndianPhone', () {
    test('always renders one +91 and the 10 digits', () {
      expect(formatIndianPhone('9650263185'), '+91 9650263185');
      expect(formatIndianPhone('+919650263185'), '+91 9650263185');
    });
  });
}
