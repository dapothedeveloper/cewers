class AlertsModel {
  final List<String> video;
  final List<String> picture;
  final bool isEmailSent;
  final bool isSmsSent;
  final String id;
  final String userId;
  final String priority;
  final String location;
  final String alertType;
  final String comment;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String landmark;
  final String localGovernment;
  final String community;
  AlertsModel(
    this.id,
    this.userId,
    this.alertType,
    this.priority,
    this.location,
    this.landmark,
    this.comment,
    this.localGovernment,
    this.community,
    this.status,
    this.video,
    this.picture,
    this.isSmsSent,
    this.isEmailSent,
    this.createdAt,
    this.updatedAt,
  );

  factory AlertsModel.fromJson(dynamic json) {
    List<String> pictures = List.from(json["pictures"]);
    // print(json);
    List<String> videos = List.from(json["videos"]);
    // print(json["userId"]);
    // print(json["userId"]["_id"]);
    return AlertsModel(
      json["_id"] as String,
      json["userId"] is Map
          ? json["userId"]["_id"] as String
          : json["userId"] as String,
      json["alertType"] as String,
      json["priority"] as String,
      json["location"] as String,
      json["landmark"] as String,
      json["comment"] as String,
      json["localGovernment"] as String,
      json["community"] as String,
      json["approvalStatus"] as String,
      videos,
      pictures,
      json["isSmsSent"] as bool,
      json["isEmailSent"] as bool,
      DateTime.parse(json["createdAt"]),
      DateTime.parse(json["updatedAt"]),
    );
  }
}
