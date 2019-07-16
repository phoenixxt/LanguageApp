class RandomWordList {
  List<RandomWord> words;

  RandomWordList(final this.words);

  factory RandomWordList.fromJsonLikeStringList(List<dynamic> json) {
    return RandomWordList(json.map((word) => RandomWord(word)).toList());
  }
}

class RandomWord {

  String randomWord;

  RandomWord(final this.randomWord);

  RandomWord copyWith({String randomWord}) {
    return RandomWord(randomWord ?? this.randomWord);
  }
}