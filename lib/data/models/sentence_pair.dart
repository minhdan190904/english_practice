/// A paired English-Vietnamese sentence from an AI-generated passage.
class SentencePair {
  final String en;
  final String vi;

  const SentencePair({required this.en, required this.vi});

  factory SentencePair.fromJson(Map<String, dynamic> json) => SentencePair(
        en: json['en'] ?? '',
        vi: json['vi'] ?? '',
      );

  Map<String, dynamic> toJson() => {'en': en, 'vi': vi};
}
