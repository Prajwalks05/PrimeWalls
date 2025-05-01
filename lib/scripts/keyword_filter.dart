// lib/utils/keyword_filter.dart

// Caesar cipher encoded list: each letter shifted -1 (a -> z, b -> a, etc.)
const List<String> encodedBannedKeywords = [
  'mtcd', 'mzjdc', 'rdw', 'oqrm', 'www', 'annaar', 'mrev', 'dqshsb',
  'edsehr', 'sgnmg', 'mhoook', 'otrrx', 'bnjb', 'chbj', 'odmhr', 'uzfhmz',
  'atsa', 'zrr', 'zmzk', 'ahjhmh', 'khmfhdqhd', 'gdmshz', 'aknvian', 'acrl',
  'rshoq', 'rshooqdq', 'nqfx', 'gzqcbnqc', 'renetcqdc', 'lzrtsazsdc',
  'hmbrds', 'mtcdr', 'rdmrtzm', 'dwokhbhs', 'snokdrr', 'tmcqdrs',
  'rcctcbd', 'kdvc', 'mhek', 'sddm', 'ctl', 'anzf', 'mztghsx',
  'kurt', 'jhmmy', 'zcutks', 'wwwuideor', 'bzmdekod', 'dqshcbz',
  'vds', 'gntfhqk', 'rdxy', 'okzxaoy', 'frrtsqhmf', 'ozmosdr',
  'annaahr', 'rlttr', 'drbnot'
];

// Decodes the Caesar cipher list by shifting each letter forward by 1.
List<String> getDecodedBannedKeywords() {
  return encodedBannedKeywords.map((word) {
    return String.fromCharCodes(word.runes.map((char) {
      if (char >= 65 && char <= 90) {
        // A-Z
        return char == 90 ? 65 : char + 1;
      } else if (char >= 97 && char <= 122) {
        // a-z
        return char == 122 ? 97 : char + 1;
      } else {
        return char; // non-alphabetic characters stay the same
      }
    }));
  }).toList();
}
