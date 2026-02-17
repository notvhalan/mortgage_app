class StampDutyBreakdown {
  final double totalDuty;
  final List<StampDutyBand> bands;

  StampDutyBreakdown({
    required this.totalDuty,
    required this.bands,
  });
}

class StampDutyBand {
  final double threshold;
  final double rate;
  final double amount;

  StampDutyBand({
    required this.threshold,
    required this.rate,
    required this.amount,
  });
}
