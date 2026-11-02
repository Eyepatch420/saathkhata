import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // 'code' is a unique tile identifier; 'locale' is the Flutter locale to apply.
  // Bhojpuri (bho) and Maithili (mai) have their own arb files; the high-traffic
  // UI is translated and the long tail falls back to Hindi within those files.
  static const List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English', 'code': 'en', 'locale': 'en'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'code': 'hi', 'locale': 'hi'},
    {'name': 'Bengali', 'native': 'বাংলা', 'code': 'bn', 'locale': 'bn'},
    {'name': 'Marathi', 'native': 'मराठी', 'code': 'mr', 'locale': 'mr'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'code': 'ta', 'locale': 'ta'},
    {'name': 'Telugu', 'native': 'తెలుగు', 'code': 'te', 'locale': 'te'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'code': 'kn', 'locale': 'kn'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી', 'code': 'gu', 'locale': 'gu'},
    {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ', 'code': 'pa', 'locale': 'pa'},
    {'name': 'Malayalam', 'native': 'മലയാളം', 'code': 'ml', 'locale': 'ml'},
    {'name': 'Bhojpuri', 'native': 'भोजपुरी', 'code': 'bho', 'locale': 'bho'},
    {'name': 'Maithili', 'native': 'मैथिली', 'code': 'mai', 'locale': 'mai'},
  ];

  String? _selectedCode;

  String _getLocalizedLanguageName(String code, AppLocalizations l10n) {
    return switch (code) {
      'en' => l10n.languageEnglish,
      'hi' => l10n.languageHindi,
      'bn' => l10n.languageBengali,
      'mr' => l10n.languageMarathi,
      'ta' => l10n.languageTamil,
      'te' => l10n.languageTelugu,
      'kn' => l10n.languageKannada,
      'gu' => l10n.languageGujarati,
      'pa' => l10n.languagePunjabi,
      'ml' => l10n.languageMalayalam,
      'bho' => l10n.languageBhojpuri,
      'mai' => l10n.languageMaithili,
      _ => l10n.unknownLanguage,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedCode == null) {
      final currentLocale = context.read<LocaleProvider>().locale.languageCode;
      // Pre-select the canonical tile for the active locale (first match).
      final match = _languages.firstWhere(
        (l) => l['code'] == currentLocale,
        orElse: () => _languages.firstWhere(
          (l) => l['locale'] == currentLocale,
          orElse: () => _languages.first,
        ),
      );
      _selectedCode = match['code'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(l10n.chooseLanguage, style: AppTypography.h1),
              Text(
                l10n.chooseYourLanguageHindi,
                style: AppTypography.h3.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2,
                  ),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = _selectedCode == lang['code'];
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedCode = lang['code']);
                        // Apply locale immediately so the app reacts globally.
                        context.read<LocaleProvider>().setLocale(
                          Locale(lang['locale']!),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lang['native']!,
                              style: AppTypography.labelLarge.copyWith(
                                fontSize: 16,
                                color: isSelected ? AppColors.primary : null,
                              ),
                            ),
                            Text(
                              _getLocalizedLanguageName(lang['code']!, l10n),
                              style: AppTypography.bodySmall.copyWith(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.7)
                                    : AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedCode == null
                      ? null
                      : () => context.go(AppRouter.onboarding),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.3,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.continueButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
