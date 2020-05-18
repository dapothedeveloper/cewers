class MediaUploadModel {
  final int timeStamp;
  final String filePath;
  final String fileName;
  final String alertDescription;
  final String coordinates;
  MediaUploadModel(this.filePath, this.timeStamp, this.fileName,
      this.alertDescription, this.coordinates);
}
