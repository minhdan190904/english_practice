import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class Phonetic extends StatefulWidget {
  final String phonetic;
  final String phoneticText;
  final Color backgroundColor;

  /// Optional label (e.g. "UK", "US") shown next to the phonetic text
  final String? label;

  /// If true, uses a smaller, more compact layout
  final bool compact;

  const Phonetic({
    super.key,
    required this.phonetic,
    required this.phoneticText,
    this.backgroundColor = Colors.transparent,
    this.label,
    this.compact = false,
  });

  /// Static method to play phonetic audio from any widget
  static final AudioPlayer _staticPlayer = AudioPlayer();
  static final Map<String, LockCachingAudioSource> _staticCache = {};

  static Future<void> playSound(String url) async {
    try {
      if (!_staticCache.containsKey(url)) {
        _staticCache[url] = LockCachingAudioSource(Uri.parse(url));
      }
      await _staticPlayer.setAudioSource(_staticCache[url]!);
      await _staticPlayer.play();
    } catch (e) {
      debugPrint('skip');
    }
  }

  @override
  State<Phonetic> createState() => _PhoneticState();
}

class _PhoneticState extends State<Phonetic> {

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return _buildCompact(context);
    }
    return _buildDefault(context);
  }

  /// Default (original) layout — large speaker button with background color
  Widget _buildDefault(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgButton(
          svg: Assets.svgVolumeUp,
          backgroundColor: widget.backgroundColor,
          color: Colors.white,
          size: 24,
          padding: const EdgeInsets.all(8),
          onPressed: _playSound,
        ),
        const SizedBox(width: 8),
        SelectableText(
          widget.phoneticText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Compact layout — small icon, text, optional label (UK/US)
  Widget _buildCompact(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _playSound,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phonetic text
            Text(
              widget.phoneticText,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 4),
            // Small speaker icon
            Icon(
              Icons.volume_up_rounded,
              size: 16,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
            // Label (UK/US)
            if (widget.label != null) ...[
              const SizedBox(width: 2),
              Text(
                widget.label!,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _playSound() async {
    Phonetic.playSound(widget.phonetic);
  }
}
