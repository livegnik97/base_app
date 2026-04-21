// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';

extension StringUtils on String {
  String toPureString() {
    final String withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    final String withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    String thisCad = toString().trim();
    for (int i = 0; i < withDia.length; i++) {
      thisCad = thisCad.replaceAll(withDia[i], withoutDia[i]);
    }

    return thisCad;
  }

  bool containsPlusUltra(String term) {
    String thisCad = toPureString().toLowerCase();
    String termCad = term.toPureString().toLowerCase();

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

  bool get isImage =>
      lookupMimeType(this)?.toLowerCase().startsWith('image/') ?? false;

  bool get isVideo =>
      lookupMimeType(this)?.toLowerCase().startsWith('video/') ?? false;

  bool get isAudio =>
      lookupMimeType(this)?.toLowerCase().startsWith('audio/') ?? false;

  bool get isDigit => RegExp(r'^[0-9]+$').hasMatch(this);
}
