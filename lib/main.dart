import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'configs/di.dart';
import 'data/repositories/oxford_words_repository.dart';
import 'navigation/app_router.dart';
import 'ui/blocs/iap/iap_bloc.dart';
import 'ui/blocs/translate/translate_cubit.dart';
import 'ui/screens/settings/bloc/settings_bloc.dart';
import 'utils/ad/consent_manager.dart';
import 'utils/global_values.dart';
import 'utils/local_notifications_tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final brightness = SchedulerBinding.instance.window.platformBrightness;
  final isDarkMode = brightness == Brightness.dark;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ),
  );

  Future<T> runStep<T>(String name, Future<T> Function() action) async {
    debugPrint('Startup: $name - start');
    try {
      final result = await action();
      debugPrint('Startup: $name - done');
      return result;
    } catch (e, stack) {
      debugPrint('Startup: $name - error: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  await runStep('Firebase.initializeApp', () => Firebase.initializeApp());
  await runStep(
    'Initializers (ads, notifications, DI, globals)',
    () => Future.wait([
      runStep('MobileAds.initialize', () => MobileAds.instance.initialize()),
      runStep(
        'LocalNotificationsTools.initialize',
        () => LocalNotificationsTools().initialize(
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
          onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
        ),
      ),
      runStep('DI.init', () => DI().init()),
      runStep('GlobalValues.init', () => GlobalValues.init()),
    ]),
  );

  ConsentManager.gatherConsent((consentError) {
    if (consentError != null) {
      debugPrint("Consent error: ${consentError.errorCode}: ${consentError.message}");
    }
    MobileAds.instance.initialize();
  });

  await runStep('OxfordWordsRepository.initData', () => DI().sl<OxfordWordsRepository>().initData());

  if (appFlavor != 'production' || kDebugMode) {
    debugPrint('setAnalyticsCollectionEnabled false');
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  } else {
    debugPrint('setAnalyticsCollectionEnabled true');
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    FirebaseAnalytics.instance.setConsent(
      analyticsStorageConsentGranted: true,
      adPersonalizationSignalsConsentGranted: true,
      adStorageConsentGranted: true,
      adUserDataConsentGranted: true,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  tz.initializeTimeZones();
  final currentTimeZone = await runStep('FlutterTimezone.getLocalTimezone', () => FlutterTimezone.getLocalTimezone());
  runStep('tz.setLocalLocation', () async {
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DI().sl<SettingsBloc>(),
        ),
        BlocProvider(
          create: (context) => DI().sl<IapBloc>(),
        ),
        BlocProvider(
          create: (context) => DI().sl<TranslateCubit>(),
        ),
      ],
      child: App(),
    ),
  );
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
  debugPrint('onDidReceiveNotificationResponse: ${notificationResponse.payload}');
  final id = int.tryParse(notificationResponse.payload ?? '');
  AppRouter.rootNavigatorKey.currentContext?.go(RoutePaths.vocabulary, extra: {'wordId': id});
}

void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  debugPrint('onDidReceiveBackgroundNotificationResponse: ${notificationResponse.payload}');
  final id = int.tryParse(notificationResponse.payload ?? '');
  AppRouter.rootNavigatorKey.currentContext?.go(RoutePaths.vocabulary, extra: {'wordId': id});
}
