extension StringExt on String {
  String toTitleCase() => replaceAllMapped(RegExp(r"\b\w"), (m) => m.group(0)!.toUpperCase());
}
