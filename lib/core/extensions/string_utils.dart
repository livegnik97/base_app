extension StringUtils on String {
  bool containsPlusUltra(String term) {
    final String withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    final String withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    String thisCad = toString().trim();
    String termCad = term.trim();

    for (int i = 0; i < withDia.length; i++) {
      thisCad = thisCad.replaceAll(withDia[i], withoutDia[i]);
      termCad = termCad.replaceAll(withDia[i], withoutDia[i]);
    }

    thisCad = thisCad.toLowerCase();
    termCad = termCad.toLowerCase();

    bool isContains = thisCad.contains(termCad);
    if (isContains) return true;

    final List<String> words = termCad.split(' ');
    int count = 0;
    int total = words.length;
    for (int i = 0; i < words.length; i++) {
      if (words[i].isEmpty) {
        total--;
        continue;
      }
      if (thisCad.contains(words[i])) {
        count++;
      } else {
        if (_compareWithVariants(words[i], thisCad)) {
          count++;
        }
      }
    }
    if (count > 0 && count >= total * 0.5) {
      return true;
    }
    return false;
  }

  bool _compareWithVariants(String word, String thisCad) {
    final String variantsSource = 'bvccsszznmiy';
    final String variantsDestiny = 'vbszczcsmnyi';
    for (int i = 0; i < variantsSource.length; i++) {
      if (thisCad
          .replaceAll(variantsSource[i], variantsDestiny[i])
          .contains(word.replaceAll(variantsSource[i], variantsDestiny[i]))) {
        return true;
      }
    }
    return false;
  }
}
