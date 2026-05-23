import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/word_pos.dart';
import '../../../core/debouncer.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../../commons/svg_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/search_box.dart';
import 'widgets/vocabulary_item.dart';
import '../../../utils/l10n.dart';
import '../../../utils/global_values.dart';

class VocabularyScreen extends StatefulWidget {
  final int? wordId;

  const VocabularyScreen({super.key, this.wordId});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  bool _showSearch = false;
  final List<WordPos> _selectedPos = [];
  final List<WordStatus> _selectedStatus = [];
  String? _selectedLetter;
  String _searchText = '';
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return BlocConsumer<VocabularyBloc, VocabularyState>(
      listener: (context, state) { _showWordDetails(); },
      builder: (context, state) {
        final words = _getFilteredWords(state.words);
        final starredWords = state.words.where((w) => w.status == WordStatus.star).toList();
        final masteredCount = state.words.where((w) => w.status == WordStatus.mastered).length;

        return BasePage(
          title: L10n.tr(context, 'vocabulary'),
          actions: [
            SvgButton(
              svg: _showSearch ? Assets.svgClose : Assets.svgSearch,
              onPressed: _onShowSearch,
            )
          ],
          padding: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats bar: hiển thị tổng quan từ vựng từ Hive local (VocabularyBloc)
                _buildStatsBar(
                  context,
                  total: state.words.length,
                  starred: starredWords.length,
                  mastered: masteredCount,
                ),
                const SizedBox(height: 8),
                // Nút Start Review: chỉ hiện khi có từ starred, navigate thẳng đến /flashcards
                if (starredWords.isNotEmpty) ...[
                  _buildStartReviewButton(context, starredWords),
                  const SizedBox(height: 8),
                ],
                SearchBox(
                  showSearch: _showSearch,
                  selectedPos: _selectedPos,
                  selectedLetter: _selectedLetter,
                  selectedStatus: _selectedStatus,
                  onSelectPos: _onSelectPos,
                  onSelectLetter: _onSelectLetter,
                  onClearFilters: _onClearFilters,
                  onSearch: _onSearch,
                  onSelectStatus: _onSelectStatus,
                ),
                GestureDetector(
                  onTap: _onShowSearch,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _getFilterLabel(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return Column(
                        children: [
                          VocabularyItem(word: word),
                          if (index == 1) ...[
                            BannerAdWidget(
                              paddingHorizontal: 16,
                              paddingVertical: 8,
                              isPremium: isPremium,
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Stats bar: Total / ★ Studying / ✓ Mastered
  /// Data từ VocabularyBloc (local Hive — không gọi API)
  Widget _buildStatsBar(BuildContext context, {
    required int total,
    required int starred,
    required int mastered,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, label: L10n.tr(context, 'total'), value: total.toString(), icon: Icons.library_books_outlined),
          _buildStatDivider(colorScheme),
          _buildStatItem(context, label: L10n.tr(context, 'studying'), value: starred.toString(), icon: Icons.star_rounded,
              iconColor: colorScheme.tertiary),
          _buildStatDivider(colorScheme),
          _buildStatItem(context, label: L10n.tr(context, 'mastered'), value: mastered.toString(), icon: Icons.check_circle_rounded,
              iconColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor ?? colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(ColorScheme colorScheme) {
    return Container(
      height: 28,
      width: 1,
      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.15),
    );
  }

  /// Nút Start Review — navigate trực tiếp đến FlashCardScreen với starred words
  Widget _buildStartReviewButton(BuildContext context, List<Word> starredWords) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return RoundedButton(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      onPressed: () {
        context.push(RoutePaths.flashcards, extra: {'words': starredWords});
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, color: colorScheme.onPrimary, size: 20),
          const SizedBox(width: 6),
          Text(
            '${L10n.tr(context, "start_review")}  (${starredWords.length})',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showWordDetails();
    _listenNotificationsBloc();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GlobalValues.startupLogs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(L10n.tr(context, 'startup_errors')),
            content: SingleChildScrollView(
              child: Text(GlobalValues.startupLogs.join('\n\n')),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(L10n.tr(context, 'ok')))
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void _onShowSearch() => setState(() { _showSearch = !_showSearch; });

  void _onSelectPos(WordPos pos) {
    setState(() {
      if (_selectedPos.contains(pos)) { _selectedPos.remove(pos); }
      else { _selectedPos.add(pos); }
    });
  }

  void _onSelectLetter(String? letter) => setState(() { _selectedLetter = letter; });

  void _onSelectStatus(WordStatus status) {
    setState(() {
      if (_selectedStatus.contains(status)) { _selectedStatus.remove(status); }
      else { _selectedStatus.add(status); }
    });
  }

  void _onClearFilters() {
    setState(() {
      _selectedPos.clear();
      _selectedLetter = null;
      _selectedStatus.clear();
      _searchText = '';
      _showSearch = false;
    });
  }

  /// Search với debounce 300ms — dùng Debouncer từ lib/core/debouncer.dart
  void _onSearch(String text) {
    _debouncer(() {
      setState(() { _searchText = text; });
    });
  }

  List<Word> _getFilteredWords(List<Word> words) {
    return words.where((word) {
      final pos = word.pos.split(', ');
      final containsPos = _selectedPos.isEmpty || pos.any((p) => _selectedPos.contains(WordPos.fromString(p)));
      final containsLetter = _selectedLetter == null || word.word.toLowerCase().startsWith(_selectedLetter!.toLowerCase());
      final containsSearchText = _searchText.isEmpty || word.word.toLowerCase().contains(_searchText.toLowerCase());
      final containsStatus = _selectedStatus.isEmpty || _selectedStatus.contains(word.status);
      return containsPos && containsLetter && containsSearchText && containsStatus;
    }).toList();
  }

  void _showWordDetails() {
    final notificationsBloc = context.read<NotificationsBloc>();
    final wordId = widget.wordId ?? notificationsBloc.state.wordIdFromNotification;
    if (wordId != null) {
      context.read<NotificationsBloc>().add(const NotificationsEvent.clearWordIdFromNotification());
      final word = context.read<VocabularyBloc>().state.words.firstWhere((element) => element.index == wordId);
      context.push(RoutePaths.wordDetails, extra: {'word': word});
    }
  }

  void _listenNotificationsBloc() {
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.stream.listen((state) {
      if (state.wordIdFromNotification != null) { _showWordDetails(); }
    });
  }

  String _getFilterLabel() {
    final letter = _selectedLetter != null ? 'letter: ${_selectedLetter?.toLowerCase()}' : '';
    final pos = _selectedPos.isNotEmpty ? 'pos: ${_selectedPos.map((e) => e.name).join(', ')}' : '';
    final status = _selectedStatus.isNotEmpty ? 'status: ${_selectedStatus.map((e) => e.name).join(', ')}' : '';
    final search = _searchText.isNotEmpty ? 'search: $_searchText' : '';
    if (letter.isEmpty && pos.isEmpty && status.isEmpty && search.isEmpty) return 'All words';
    String result = '';
    if (letter.isNotEmpty) result += letter;
    if (pos.isNotEmpty) { if (result.isNotEmpty) result += ', '; result += pos; }
    if (status.isNotEmpty) { if (result.isNotEmpty) result += ', '; result += status; }
    if (search.isNotEmpty) { if (result.isNotEmpty) result += ', '; result += search; }
    return result;
  }
}
