class Entry {
  final int id;
  final int month;
  final int day;
  final String? title;
  final String? quote;
  final String? quoteSource;
  final String? body;
  final String? closing;

  const Entry({
    required this.id,
    required this.month,
    required this.day,
    this.title,
    this.quote,
    this.quoteSource,
    this.body,
    this.closing,
  });

  factory Entry.fromMap(Map<String, dynamic> map) => Entry(
        id: map['id'] as int,
        month: map['month'] as int,
        day: map['day'] as int,
        title: map['title'] as String?,
        quote: map['quote'] as String?,
        quoteSource: map['quote_source'] as String?,
        body: map['body'] as String?,
        closing: map['closing'] as String?,
      );
}
