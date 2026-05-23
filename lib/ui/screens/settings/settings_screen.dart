import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'bloc/settings_bloc.dart';
import 'widgets/profile_field.dart';
import 'widgets/theme_item.dart';
import '../../../utils/l10n.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const seeks = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.red,
  ];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  WordStatus _status = WordStatus.unknown;
  bool _isSelectingTheme = false;
  bool _interacted = false;
  late final ScrollController _scrollController;
  static const int _timerPeriod = 8000;
  static const int _duration = 7000;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isGrantedNotificationsPermission = context.watch<NotificationsBloc>().state.isNotificationsGranted;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    final authState = context.watch<AuthCubit>().state;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settingsSnapshot = state.settingsSnapshot;
        return BasePage(
          title: L10n.tr(context, "settings"),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            if (authState.user != null && !authState.user!.isAnonymous)
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: authState.user?.photoURL != null
                                        ? NetworkImage(authState.user!.photoURL!)
                                        : null,
                                    child: authState.user?.photoURL == null
                                        ? const Icon(Icons.person, size: 30)
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          authState.user?.displayName ?? 'No Name',
                                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          authState.user?.email ?? '',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.logout),
                                    onPressed: () {
                                      context.read<AuthCubit>().signOut();
                                    },
                                  )
                                ],
                              )
                            else
                              RoundedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : () => _onSyncWithGoogle(context),
                                borderRadius: 16,
                                child: authState.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.sync),
                                          const SizedBox(width: 8),
                                          Text(L10n.tr(context, "sync_with_google")),
                                        ],
                                      ),
                              ),
                            const SizedBox(height: 24),
                            VocabularyItem(
                              word: Words.sampleWord,
                              onMastered: _onMastered,
                              onStar: _onStar,
                              viewOnly: true,
                            ),
                            Text(
                              L10n.tr(context, "color"),
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 72,
                        child: GestureDetector(
                          onPanDown: (_) {
                            setState(() {
                              _interacted = true;
                            });
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: SettingsScreen.seeks.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _onChangeColor(context, SettingsScreen.seeks[index].value),
                                child: Container(
                                  width: 60,
                                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color:
                                    ColorScheme.fromSeed(
                                      seedColor: SettingsScreen.seeks[index],
                                      brightness: brightness,
                                    ).primaryContainer,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              L10n.tr(context, "theme"),
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: _isSelectingTheme ? 160 : 65,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.2), width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: !_isSelectingTheme
                                  ? ThemeItem(
                                      themeMode: ThemeMode.values[settingsSnapshot.themeMode],
                                      onPress: () {
                                        setState(() {
                                          _isSelectingTheme = true;
                                        });
                                      },
                                    )
                                  : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 8,
                                        children: ThemeMode.values.map((themeMode) {
                                          return Column(
                                            children: [
                                              ThemeItem(
                                                themeMode: themeMode,
                                                onPress: () => _onChangeTheme(context, themeMode.index),
                                                hasDivider: themeMode != ThemeMode.values.last,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            // Language Selector
                            Text(
                              L10n.tr(context, "language"),
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildLanguageTile(context, settingsSnapshot.locale, colorScheme, textTheme),
                            const SizedBox(height: 16),
                            ProfileField(
                              onPressed: _openContactMail,
                              title: L10n.tr(context, "contact_us"),
                              value: L10n.tr(context, "contact_us_desc"),
                            ),
                            Divider(),
                            ProfileField(
                              onPressed: _openTermsOfUse,
                              title: L10n.tr(context, "terms_of_use"),
                            ),
                            Divider(),
                            ProfileField(
                              onPressed: _openPrivacyPolicy,
                              title: L10n.tr(context, "privacy_policy"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (!isGrantedNotificationsPermission)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RoundedButton(
                    onPressed: _openNotificationsSettings,
                    borderRadius: 16,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgNotifications,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(L10n.tr(context, "enable_notifications")),
                      ],
                    ),
                  ),
                ),
              BannerAdWidget(
                isPremium: isPremium,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: _duration),
        curve: Curves.easeInOut,
      );
      Timer.periodic(const Duration(milliseconds: _timerPeriod), (timer) {
        if (_interacted) {
          timer.cancel();
        } else {
          if (_scrollController.position.pixels > 0) {
            _scrollController.animateTo(0, duration: const Duration(milliseconds: _duration), curve: Curves.easeInOut);
          } else {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: _duration),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onChangeTheme(BuildContext context, int? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _isSelectingTheme = false;
    });
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(
            themeMode: value,
          ),
        );
  }

  void _onChangeColor(BuildContext context, int value) {
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(
            seek: value,
          ),
        );
  }

  void _onChangeLocale(BuildContext context, String locale) {
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(locale: locale),
        );
  }

  Widget _buildLanguageTile(BuildContext context, String currentLocale, ColorScheme colorScheme, TextTheme textTheme) {
    final isVi = currentLocale == 'vi';
    return GestureDetector(
      onTap: () => _onChangeLocale(context, isVi ? 'en' : 'vi'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.2), width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              isVi ? '🇻🇳' : '🇬🇧',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVi ? 'Tiếng Việt' : 'English',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  isVi ? 'Giải thích ngữ pháp bằng tiếng Việt' : 'Grammar explained in English',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.swap_horiz_rounded,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSyncWithGoogle(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    final result = await authCubit.linkWithGoogle();

    if (!context.mounted) return;

    switch (result) {
      case LinkResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.tr(context, "sync_success")),
            backgroundColor: Colors.green,
          ),
        );
        break;
      case LinkResult.credentialAlreadyInUse:
        _showAccountConflictDialog(context);
        break;
      case LinkResult.cancelled:
        break;
      case LinkResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authCubit.state.errorMessage ?? L10n.tr(context, "sync_error")),
            backgroundColor: Colors.red,
          ),
        );
        break;
    }
  }

  void _showAccountConflictDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.cloud_download, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                L10n.tr(context, "account_conflict_title"),
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          L10n.tr(context, "account_conflict_message"),
          style: textTheme.bodyMedium,
        ),
        actions: [
          // Option 1: Load existing data
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().signInWithGoogle();
              },
              icon: const Icon(Icons.cloud_download),
              label: Text(L10n.tr(context, "load_existing_data")),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Option 2: Use different Gmail
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final authCubit = context.read<AuthCubit>();
                final result = await authCubit.linkWithDifferentGoogle();
                if (context.mounted && result == LinkResult.credentialAlreadyInUse) {
                  _showAccountConflictDialog(context);
                }
              },
              icon: const Icon(Icons.switch_account),
              label: Text(L10n.tr(context, "use_different_gmail")),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Option 3: Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(L10n.tr(context, "go_back")),
            ),
          ),
        ],
      ),
    );
  }

  void _openNotificationsSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _onMastered() {
    if (_status == WordStatus.mastered) {
      setState(() {
        _status = WordStatus.unknown;
      });
    } else {
      setState(() {
        _status = WordStatus.mastered;
      });
    }
  }

  void _onStar() {
    if (_status == WordStatus.star) {
      setState(() {
        _status = WordStatus.unknown;
      });
    } else {
      setState(() {
        _status = WordStatus.star;
      });
    }
  }

  void _openContactMail() async {
    final contactEmail = const String.fromEnvironment("CONTACT_EMAIL");
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      query: 'subject=Feedback For English Handbook',
    );
    await launchUrl(emailLaunchUri);
  }

  void _openTermsOfUse() async {
    final termsOfUseUrl = const String.fromEnvironment("TERMS_OF_USE_URL");
    await launchUrl(Uri.parse(termsOfUseUrl));
  }

  void _openPrivacyPolicy() async {
    final privacyPolicyUrl = const String.fromEnvironment("PRIVACY_POLICY_URL");
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }
}
