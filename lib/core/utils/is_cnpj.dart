isCNPJ(String cnpj) {
  // Remove non-numeric characters
  cnpj = cnpj.replaceAll(RegExp(r'\D'), '');

  // Check if the CNPJ is valid
  if (cnpj.length != 14) return false;

  // Check if the CNPJ is a simple CNPJ (all digits are the same)
  if (RegExp(r'^(.)\1*$').hasMatch(cnpj)) return false;

  return true;
}
