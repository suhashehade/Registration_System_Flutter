class Currency {
  final String name;
  final String symbol;
  final double rate;

  Currency({required this.name, required this.symbol, required this.rate});

  Map<String, dynamic> toMap() {
    return {"name": name, "symbol": symbol, "rate": rate};
  }
}
