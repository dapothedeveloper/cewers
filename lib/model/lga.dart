class LocalGovernmentModel {
  final String name;
  final List<String> communities;

  LocalGovernmentModel(this.name, this.communities);
  factory LocalGovernmentModel.fromJson(dynamic json) {
    // List.castFrom(source)
    List<String> list = List.from(json["communities"]);
    return LocalGovernmentModel(json["name"] as String, list);
  }
}
