import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/sample_passage_response.dart';
import '../../../data/models/saved_lesson.dart';
import '../../../utils/l10n.dart';
import '../../commons/base_page.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import 'ai_lesson_detail_screen.dart';
import 'new_ai_lesson_screen.dart';

class AiLessonScreen extends StatefulWidget {
  const AiLessonScreen({super.key});

  @override
  State<AiLessonScreen> createState() => _AiLessonScreenState();
}

class _AiLessonScreenState extends State<AiLessonScreen> {
  late Future<List<SavedLesson>> _lessonsFuture;
  final SavedLessonsRepository _repo = SavedLessonsRepository();
  int? _lastUserId;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-reload when user changes (account switch)
    final currentUserId = context.read<AuthCubit>().state.user?.id;
    if (_lastUserId != null && _lastUserId != currentUserId) {
      _loadLessons();
    }
    _lastUserId = currentUserId;
  }

  void _loadLessons() {
    _lessonsFuture = _repo.getAll();
  }

  void _refresh() {
    setState(() => _loadLessons());
  }

  Future<void> _deleteLesson(String id) async {
    await _repo.delete(id);
    _refresh();
  }

  void _openDetail(SavedLesson lesson) {
    final selectedWords = lesson.words
        .map((w) => SelectedWord(
              word: w.word,
              level: w.level,
              category: w.category,
              pos: w.pos,
              definition: w.definition,
              definitionVi: w.definitionVi,
              shortMeaningVi: w.shortMeaningVi,
              example: w.example,
              phoneticText: w.phoneticText,
              phoneticAmText: w.phoneticAmText,
              phoneticUrl: w.phoneticUrl,
              phoneticAmUrl: w.phoneticAmUrl,
            ))
        .toList();

    Navigator.of(context, rootNavigator: true)
        .push(
          MaterialPageRoute(
            builder: (_) => AiLessonDetailScreen(
              title: lesson.title,
              passage: lesson.passage,
              passageVi: lesson.passageVi,
              selectedWords: selectedWords,
              imageBase64: lesson.imageBase64,
            ),
          ),
        )
        .then((_) => _refresh());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.user?.id != curr.user?.id,
      listener: (context, state) {
        // Account changed — reload lessons
        _refresh();
      },
      child: Scaffold(
      body: BasePage(
        title: L10n.tr(context, 'ai_lessons'),
        child: FutureBuilder<List<SavedLesson>>(
          future: _lessonsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final lessons = snapshot.data ?? [];

            if (lessons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.smart_toy_outlined,
                        size: 80, color: colorScheme.primary.withAlpha(80)),
                    const SizedBox(height: 16),
                    Text(
                      L10n.tr(context, 'no_ai_lessons'),
                      style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(120)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      L10n.tr(context, 'create_lesson_desc'),
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 96),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _LessonCard(
                    lesson: lesson,
                    onTap: () => _openDetail(lesson),
                    onDelete: () => _deleteLesson(lesson.id),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(
                MaterialPageRoute(
                    builder: (_) => const NewAiLessonScreen()),
              )
              .then((_) => _refresh());
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final SavedLesson lesson;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _LessonCard({
    required this.lesson,
    required this.onTap,
    required this.onDelete,
  });

  // Generate a deterministic gradient from lesson.id
  static const List<List<Color>> _gradients = [
    [Color(0xFF6C63FF), Color(0xFF3A86FF)], // purple-blue
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)], // red-orange
    [Color(0xFF11998E), Color(0xFF38EF7D)], // teal-green
    [Color(0xFFFC5C7D), Color(0xFF6A3093)], // pink-purple
    [Color(0xFF4ECDC4), Color(0xFF44A08D)], // mint
    [Color(0xFFF7971E), Color(0xFFFFD200)], // yellow-orange
  ];

  List<Color> get _gradient {
    final hash = lesson.id.codeUnits.fold(0, (a, b) => a + b);
    return _gradients[hash % _gradients.length];
  }

  String get _initials {
    final words = lesson.title.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = lesson.imageBase64 != null && lesson.imageBase64!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: hasImage
              ? _buildImageCard(context, textTheme, colorScheme)
              : _buildCompactCard(context, textTheme, colorScheme),
        ),
      ),
    );
  }

  // ── Layout 1: Card with 16:9 image header ─────────────────────────────────
  Widget _buildImageCard(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image header with gradient overlay
        Stack(
          children: [
            SizedBox(
              height: 145,
              width: double.infinity,
              child: Image.memory(
                _base64ToBytes(lesson.imageBase64!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildGradientPlaceholder(height: 160),
              ),
            ),
            // Gradient overlay from bottom
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Title on image
            Positioned(
              bottom: 12,
              left: 14,
              right: 40,
              child: Text(
                lesson.title,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black.withValues(alpha: 0.5))],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Delete button
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.delete_outline, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Bottom info row
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 6),
          child: Row(
            children: [
              _WordCountChip(count: lesson.wordCount, colorScheme: colorScheme, textTheme: textTheme),
              const Spacer(),
              Text(
                _formatDate(lesson.createdAt),
                style: textTheme.labelSmall?.copyWith(color: Colors.grey[500]),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.grey[400]),
            ],
          ),
        ),
      ],
    );
  }

  // ── Layout 2: Compact card without image ──────────────────────────────────
  Widget _buildCompactCard(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lesson.title,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.delete_outline, size: 18, color: Colors.grey[400]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.passagePreview,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[600], height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _WordCountChip(count: lesson.wordCount, colorScheme: colorScheme, textTheme: textTheme),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.grey[400]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientPlaceholder({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  static Uint8List _base64ToBytes(String base64Str) {
    // Remove data URI prefix if present (data:image/png;base64,...)
    final cleaned = base64Str.contains(',') ? base64Str.split(',').last : base64Str;
    return base64Decode(cleaned);
  }
}

class _WordCountChip extends StatelessWidget {
  final int count;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WordCountChip({required this.count, required this.colorScheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 13, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            '$count words',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}



