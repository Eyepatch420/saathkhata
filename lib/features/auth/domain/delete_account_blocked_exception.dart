class DeleteAccountBlocker {
  final String code;
  final String message;

  const DeleteAccountBlocker({required this.code, required this.message});

  factory DeleteAccountBlocker.fromJson(Map<String, dynamic> json) {
    return DeleteAccountBlocker(
      code: json['code'] as String? ?? 'UNKNOWN',
      message: json['message'] as String? ?? 'Unresolved item',
    );
  }
}

/// Thrown when the server refuses to delete the account because of
/// unresolved obligations (outstanding balance, active staff, etc).
class DeleteAccountBlockedException implements Exception {
  final List<DeleteAccountBlocker> blockers;

  const DeleteAccountBlockedException(this.blockers);

  @override
  String toString() => blockers.map((b) => b.message).join('\n');
}
