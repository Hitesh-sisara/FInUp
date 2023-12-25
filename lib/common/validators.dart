String? _validateBillDate(int? value, String label) {
  if (value == null || value < 1 || value > 31) {
    return "$label must be a 2-digit integer between 1 and 31.";
  }
  return null; // Validation passes
}
