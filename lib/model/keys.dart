class SingleKeyModel {
  final String key;
  SingleKeyModel(this.key);
  factory SingleKeyModel.forOnesignal(dynamic json) {
    return SingleKeyModel(json["oneSignalKey"] as String);
  }
}
