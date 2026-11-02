import 'package:flutter/material.dart';

/// Shared accent for all membership screens (matches the Phase 3 design).
class MembershipTheme {
  static const Color purple = Color(0xFF6C3FB5);
  static const Color purpleDark = Color(0xFF4A2A8A);
  static const Color purpleSoft = Color(0xFFF1ECFA);

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF6C3FB5), Color(0xFF8E5BD6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
