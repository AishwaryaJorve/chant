class DailyQuote {
  final String quote;
  final String author;

  const DailyQuote({
    required this.quote,
    required this.author,
  });
}

class DailyQuotes {
  static const List<DailyQuote> quotes = [
    DailyQuote(
      quote: 'Peace comes from within. Do not seek it without.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'The journey of a thousand miles begins with one step.',
      author: 'Lao Tzu'
    ),
    DailyQuote(
      quote: 'Quiet the mind, and the soul will speak.',
      author: 'Ma Jaya Sati Bhagavati'
    ),
    DailyQuote(
      quote: 'To understand everything is to forgive everything.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'Breathing in, I calm body and mind. Breathing out, I smile.',
      author: 'Thich Nhat Hanh'
    ),
    DailyQuote(
      quote: 'The present moment is filled with joy and happiness. If you are attentive, you will see it.',
      author: 'Thich Nhat Hanh'
    ),
    DailyQuote(
      quote: 'Look within. Be still. Free from fear and attachment.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'Your work is to discover your world and then with all your heart give yourself to it.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'Be where you are; otherwise you will miss your life.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'What you think, you become. What you feel, you attract. What you imagine, you create.',
      author: 'Buddha'
    ),
    // Add more quotes here...
    DailyQuote(
      quote: 'The mind is everything. What you think you become.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'Those who are free of resentful thoughts surely find peace.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'Every morning we are born again. What we do today matters most.',
      author: 'Buddha'
    ),
    DailyQuote(
      quote: 'Meditation is not a way of making your mind quiet. It is a way of entering into the quiet that is already there.',
      author: 'Deepak Chopra'
    ),
    DailyQuote(
      quote: 'The only way to live is by accepting each minute as an unrepeatable miracle.',
      author: 'Tara Brach'
    ),
  ];

  static DailyQuote getQuoteOfDay() {
    final dayOfYear = DateTime.now().difference(DateTime(2024, 1, 1)).inDays;
    return quotes[dayOfYear % quotes.length];
  }
} 