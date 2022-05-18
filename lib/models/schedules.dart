class Schedule {
  final scheduleId;
  final String? walletAddress;
  final vestedAmount;
  final withdrawalAmount;
  final withdrawalAvailable;
  final withdrawalDateTime;
  final vestedDateTime;

  Schedule({
    this.scheduleId,
    this.walletAddress,
    this.vestedAmount,
    this.vestedDateTime,
    this.withdrawalAmount,
    this.withdrawalAvailable,
    this.withdrawalDateTime,
  });
}
