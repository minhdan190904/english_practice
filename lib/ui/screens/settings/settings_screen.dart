import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';

import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'bloc/settings_bloc.dart';
import 'widgets/profile_field.dart';
import 'widgets/theme_item.dart';
import '../../../utils/l10n.dart';
import '../../../navigation/app_router.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../blocs/auth/auth_cubit.dart';

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
                            // ─── Profile Card ───────────────────────
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primaryContainer.withValues(alpha: 0.5),
                                    colorScheme.secondaryContainer.withValues(alpha: 0.3),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.12),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Avatar + Info + ID Badge
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: colorScheme.primary.withValues(alpha: 0.3),
                                            width: 2.5,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundColor: colorScheme.surfaceContainerHighest,
                                          backgroundImage: authState.user?.avatarUrl != null
                                              ? NetworkImage(authState.user!.avatarUrl!)
                                              : null,
                                          child: authState.user?.avatarUrl == null
                                              ? Icon(Icons.person_rounded, size: 28, color: colorScheme.onSurfaceVariant)
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (authState.hasGoogleLinked && authState.user != null) ...[
                                              Text(
                                                authState.user?.displayName ?? 'User',
                                                style: textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                authState.user?.email ?? '',
                                                style: textTheme.bodySmall?.copyWith(
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ] else ...[
                                              Text(
                                                L10n.tr(context, 'guest_account'),
                                                style: textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                L10n.tr(context, 'not_synced'),
                                                style: textTheme.bodySmall?.copyWith(
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      // ID Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'ID: ${authState.user?.id ?? "..."}',
                                          style: textTheme.labelMedium?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  // ─── Action Buttons ───
                                  if (!authState.hasGoogleLinked) ...[
                                    // NOT linked → 2 buttons: "Liên kết Google" + "Chuyển tài khoản"
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: FilledButton.icon(
                                        onPressed: authState.isLoading
                                            ? null
                                            : () => _onLinkGoogle(context),
                                        icon: authState.isLoading
                                            ? const SizedBox(
                                                width: 18, height: 18,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                            : SvgPicture.asset(
                                                'assets/svg/google.svg',
                                                width: 18,
                                                height: 18,
                                              ),
                                        label: Text(
                                          L10n.tr(context, 'link_google'),
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: OutlinedButton.icon(
                                        onPressed: authState.isLoading
                                            ? null
                                            : () => _onSwitchAccount(context),
                                        icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                                        label: Text(
                                          L10n.tr(context, 'switch_account'),
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    // LINKED → 1 button: "Chuyển tài khoản"
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: OutlinedButton.icon(
                                        onPressed: authState.isLoading
                                            ? null
                                            : () => _onSwitchAccount(context),
                                        icon: authState.isLoading
                                            ? const SizedBox(
                                                width: 18, height: 18,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                            : const Icon(Icons.swap_horiz_rounded, size: 20),
                                        label: Text(
                                          L10n.tr(context, 'switch_account'),
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                                        ),
                                      ),
                                    ),
                                  ],
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
              const BannerAdWidget(),
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

  /// "Liên kết Google" — attaches Google to CURRENT account (keeps same ID)
  Future<void> _onLinkGoogle(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    // Step 1: Google Sign-In → get Firebase ID token
    final firebaseIdToken = await authCubit.getFirebaseIdToken();
    if (firebaseIdToken == null || !context.mounted) return;

    // Step 2: Check if Google account already exists on backend
    final checkResult = await authCubit.checkGoogle(firebaseIdToken);
    if (checkResult == null || !context.mounted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi kết nối. Vui lòng thử lại.'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (!checkResult.exists) {
      // Google is new → link it to current account directly
      final result = await authCubit.linkGoogle(firebaseIdToken);
      if (!context.mounted) return;
      if (result == SyncResult.success) {
        context.go(RoutePaths.postAuth, extra: {'mode': 'login'});
      }
    } else {
      // Google already linked to another account → show conflict dialog
      _showLinkConflictDialog(context, firebaseIdToken, checkResult);
    }
  }

  /// "Chuyển tài khoản" — switch to a DIFFERENT account via Google
  /// If Google exists on server → login as that account
  /// If Google is new → create a brand new independent account
  Future<void> _onSwitchAccount(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    // Force new account picker
    final firebaseIdToken = await authCubit.getFirebaseIdToken(forceNewAccount: true);
    if (firebaseIdToken == null || !context.mounted) return;

    // Check if this Google account exists on backend
    final checkResult = await authCubit.checkGoogle(firebaseIdToken);
    if (checkResult == null || !context.mounted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi kết nối. Vui lòng thử lại.'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (checkResult.exists) {
      // Google already linked to an account → switch to it
      _showSwitchConfirmDialog(context, firebaseIdToken, checkResult);
    } else {
      // Google is new → create a new independent account
      _showCreateNewAccountDialog(context, firebaseIdToken);
    }
  }

  /// Conflict dialog: user tried to "Liên kết" but Google is already used
  void _showLinkConflictDialog(BuildContext context, String firebaseIdToken, CheckGoogleResult checkResult) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isVi = context.read<SettingsBloc>().state.settingsSnapshot.locale == 'vi';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isVi ? 'Google đã được sử dụng' : 'Google Already Used',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isVi
                  ? 'Tài khoản Google này đã được liên kết với tài khoản khác:'
                  : 'This Google account is already linked to another account:',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            _buildUserInfoCard(context, checkResult),
          ],
        ),
        actions: [
          // Option 1: Switch to that account
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final authCubit = context.read<AuthCubit>();
                final result = await authCubit.switchToGoogleAccount(firebaseIdToken);
                if (!context.mounted) return;
                if (result == SyncResult.success) {
                  context.go(RoutePaths.postAuth, extra: {'mode': 'login'});
                }
              },
              icon: const Icon(Icons.login_rounded),
              label: Text(isVi ? 'Đăng nhập tài khoản này' : 'Login to this account'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Option 2: Pick a different Google
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (context.mounted) _onLinkGoogle(context);
              },
              icon: const Icon(Icons.swap_horiz_rounded),
              label: Text(isVi ? 'Chọn Google khác' : 'Choose different Google'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(isVi ? 'Hủy' : 'Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirm switching to an existing account
  void _showSwitchConfirmDialog(BuildContext context, String firebaseIdToken, CheckGoogleResult checkResult) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isVi = context.read<SettingsBloc>().state.settingsSnapshot.locale == 'vi';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.swap_horiz_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isVi ? 'Chuyển tài khoản' : 'Switch Account',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isVi
                  ? 'Bạn sẽ đăng nhập vào tài khoản:'
                  : 'You will login to this account:',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            _buildUserInfoCard(context, checkResult),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final authCubit = context.read<AuthCubit>();
                final result = await authCubit.switchToGoogleAccount(firebaseIdToken);
                if (!context.mounted) return;
                if (result == SyncResult.success) {
                  context.go(RoutePaths.postAuth, extra: {'mode': 'login'});
                }
              },
              icon: const Icon(Icons.login_rounded),
              label: Text(isVi ? 'Đăng nhập' : 'Login'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Choose different
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (!context.mounted) return;
                _onSwitchAccount(context);
              },
              icon: const Icon(Icons.switch_account_rounded),
              label: Text(isVi ? 'Chọn tài khoản khác' : 'Choose different'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(isVi ? 'Hủy' : 'Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirm creating a brand new account with this Google
  void _showCreateNewAccountDialog(BuildContext context, String firebaseIdToken) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isVi = context.read<SettingsBloc>().state.settingsSnapshot.locale == 'vi';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.person_add_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isVi ? 'Tạo tài khoản mới' : 'Create New Account',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          isVi
              ? 'Tài khoản Google này chưa tồn tại. Hệ thống sẽ tạo một tài khoản mới hoàn toàn riêng biệt.'
              : 'This Google account doesn\'t exist yet. A new independent account will be created.',
          style: textTheme.bodyMedium,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final authCubit = context.read<AuthCubit>();
                final result = await authCubit.createWithGoogle(firebaseIdToken);
                if (!context.mounted) return;
                if (result == SyncResult.success) {
                  context.go(RoutePaths.postAuth, extra: {'mode': 'login'});
                }
              },
              icon: const Icon(Icons.add_circle_rounded),
              label: Text(isVi ? 'Tạo tài khoản' : 'Create account'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(isVi ? 'Hủy' : 'Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable user info card for dialogs
  Widget _buildUserInfoCard(BuildContext context, CheckGoogleResult checkResult) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: checkResult.existingAvatarUrl != null
                ? NetworkImage(checkResult.existingAvatarUrl!)
                : null,
            child: checkResult.existingAvatarUrl == null
                ? const Icon(Icons.person, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkResult.existingDisplayName ?? 'User',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${checkResult.existingEmail ?? ''} • ID: ${checkResult.existingUserId ?? ''}',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
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
