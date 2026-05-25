import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../configs/di.dart';
import '../../../../generated/assets.dart';
import '../../../commons/svg_button.dart';

class Phonetic extends StatefulWidget {
  final String phonetic;
  final String phoneticText;
  final Color backgroundColor;

  const Phonetic({
    super.key,
    required this.phonetic,
    required this.phoneticText,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<Phonetic> createState() => _PhoneticState();
}

class _PhoneticState extends State<Phonetic> {
  final _player = DI().sl<AudioPlayer>();
  static final Map<String, LockCachingAudioSource> _audioCache = {};

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgButton(
          svg: Assets.svgVolumeUp,
          backgroundColor: widget.backgroundColor,
          color: Colors.white,
          size: 24, // Tăng kích thước từ 20 lên 24
          padding: const EdgeInsets.all(8), // Tăng vùng tap lên 8
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

  void _playSound() async {
    try {
      final url = widget.phonetic;
      if (!_audioCache.containsKey(url)) {
        _audioCache[url] = LockCachingAudioSource(Uri.parse(url));
      }
      await _player.setAudioSource(_audioCache[url]!);
      await _player.play();
    } catch (e) {
      debugPrint('skip');
    }
  }
}
