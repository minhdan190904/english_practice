import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ui/screens/settings/bloc/settings_bloc.dart';

class L10n {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'color': 'Color',
      'theme': 'Theme',
      'language': 'Language',
      'contact_us': 'Contact Us',
      'contact_us_desc': 'If you have any questions or suggestions, please contact us for support. We will respond as soon as possible.',
      'terms_of_use': 'Terms of Use',
      'privacy_policy': 'Privacy Policy',
      'enable_notifications': 'Enable Notifications',
      'sign_in_with_google': 'Sign in with Google',
      'sign_out': 'Sign out',
      
      'home': 'Home',
      'review': 'Review',
      'vocabulary': 'Vocabulary',
      'grammar': 'Grammar',
      'progress': 'Progress',
      'ai_lesson': 'AI Lesson',
      
      'mastered': 'Mastered',
      'learning': 'Learning',
      'new': 'New',
      'total': 'Total',
      'studying': 'Studying',
      'start_review': 'Start Review',
      'schedule': 'Schedule',
      'start_flashcards': 'Start Flashcards',
      'ai_lessons': 'AI Lessons',
      'no_ai_lessons': 'No AI lessons yet.',
      'create_lesson_desc': 'Create a lesson from a topic or your own text.',
      'new_lesson': 'New Lesson',
      'grammar_progress': 'Grammar Progress',
      'streak': 'Streak',
      'vocabulary_stats': 'Vocabulary Stats',
      'lessons_completed': 'Lessons Completed',
      'keep_up_the_good_work': 'Keep up the good work!',
      'study_at_least_5_mins': 'Study at least 5 minutes a day to keep the streak going! Small steps lead to big results. 🚀',
      'longest_streak': 'Longest Streak',
      'streaks': 'Streaks',
    },
    'vi': {
      'settings': 'Cài đặt',
      'color': 'Màu sắc',
      'theme': 'Giao diện',
      'language': 'Ngôn ngữ',
      'contact_us': 'Liên hệ hỗ trợ',
      'contact_us_desc': 'Nếu bạn có câu hỏi hoặc góp ý, vui lòng liên hệ với chúng tôi. Chúng tôi sẽ phản hồi sớm nhất có thể.',
      'terms_of_use': 'Điều khoản sử dụng',
      'privacy_policy': 'Chính sách bảo mật',
      'enable_notifications': 'Bật thông báo',
      'sign_in_with_google': 'Đăng nhập Google',
      'sign_out': 'Đăng xuất',
      
      'home': 'Trang chủ',
      'review': 'Ôn tập',
      'vocabulary': 'Từ vựng',
      'grammar': 'Ngữ pháp',
      'progress': 'Tiến độ',
      'ai_lesson': 'AI Dạy',
      
      'mastered': 'Đã thuộc',
      'learning': 'Đang học',
      'new': 'Từ mới',
      'total': 'Tổng số',
      'studying': 'Đang ôn tập',
      'start_review': 'Bắt đầu ôn tập',
      'schedule': 'Lên lịch',
      'start_flashcards': 'Bắt đầu Flashcards',
      'ai_lessons': 'AI Bài Học',
      'no_ai_lessons': 'Chưa có bài học AI nào.',
      'create_lesson_desc': 'Tạo một bài học từ chủ đề hoặc đoạn văn của riêng bạn.',
      'new_lesson': 'Bài học mới',
      'grammar_progress': 'Tiến độ ngữ pháp',
      'streak': 'Chuỗi học tập',
      'vocabulary_stats': 'Thống kê từ vựng',
      'lessons_completed': 'Bài học hoàn thành',
      'keep_up_the_good_work': 'Tiếp tục phát huy nhé!',
      'study_at_least_5_mins': 'Học ít nhất 5 phút mỗi ngày để duy trì chuỗi! Những bước đi nhỏ tạo nên kết quả lớn. 🚀',
      'longest_streak': 'Chuỗi dài nhất',
      'streaks': 'Ngày',
    },
  };

  static String tr(BuildContext context, String key) {
    final locale = context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final dict = _localizedValues[locale] ?? _localizedValues['en']!;
    return dict[key] ?? _localizedValues['en']?[key] ?? key;
  }
}
