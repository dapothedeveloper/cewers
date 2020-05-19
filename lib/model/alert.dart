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
  final String createdAt;
  final String updatedAt;

  AlertsModel(
    this.id,
    this.userId,
    this.alertType,
    this.priority,
    this.location,
    this.comment,
    this.video,
    this.picture,
    this.isSmsSent,
    this.isEmailSent,
    this.createdAt,
    this.updatedAt,
  );

  factory AlertsModel.fromJson(dynamic json) {
    return AlertsModel(
      json["_id"] as String,
      json["userId"] as String,
      json["alertType"] as String,
      json["priority"] as String,
      json["location"] as String,
      json["comment"] as String,
      json["video"] as List<dynamic>,
      json["picture"] as List<dynamic>,
      json["isSmsSent"] as bool,
      json["isEmailSent"] as bool,
      json["createdAt"] as String,
      json["updatedAt"] as String,
    );
  }
}
