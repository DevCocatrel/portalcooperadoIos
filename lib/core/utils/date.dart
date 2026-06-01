String normalizeDate(String date) {
  final containsDash = date.contains("-");

  if (containsDash) {
    final dateSplit = date.split("-");

    return "${dateSplit[2]}/${dateSplit[1]}/${dateSplit[0]}";
  }

  return date;
}
