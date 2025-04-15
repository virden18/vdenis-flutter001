class Quote {
  final String companyName;
  final double stockPrice;
  final double changePercentage;
  final DateTime lastUpdated;

  const Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    required this.lastUpdated,
  });
}