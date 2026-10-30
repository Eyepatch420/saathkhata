/// Canonical phone-number handling for the OTP flow.
///
/// The API stores and matches numbers as exactly 10 Indian digits. A number can
/// reach the app from a keyboard, an SMS autofill, a deep link or a stored
/// profile carrying a country code (`+91`), spaces, dashes or a leading trunk
/// zero — none of which belong in a request body. Normalising in one place keeps
/// send and verify byte-identical for the same human number.
library;

final RegExp _nonDigit = RegExp(r'\D');
final RegExp _indianMobile = RegExp(r'^[6-9]\d{9}$');

/// `+91 96502 63185` → `9650263185`.
///
/// Only a recognisable Indian country code (`91`) or trunk prefix (`0`) is
/// removed. Anything else is returned with its non-digits stripped, so the
/// caller's validation rejects it instead of the app silently sending a
/// mangled number.
String normalizeIndianPhone(String input) {
  var digits = input.trim().replaceAll(_nonDigit, '');
  if (digits.length == 11 && digits.startsWith('0')) {
    digits = digits.substring(1);
  } else if (digits.length == 12 && digits.startsWith('91')) {
    digits = digits.substring(2);
  }
  return digits;
}

/// True when [input] normalises to a valid 10-digit Indian mobile number.
bool isValidIndianPhone(String input) =>
    _indianMobile.hasMatch(normalizeIndianPhone(input));

/// Display form with the country code: `9650263185` → `+91 9650263185`.
String formatIndianPhone(String input) => '+91 ${normalizeIndianPhone(input)}';
