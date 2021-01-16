class MediaUploadModel {
  final int timeStamp;
  final String filePath;
  final String fileName;
  final String alertDescription;
  final String coordinates;
  final bool isAudio;
  MediaUploadModel(this.filePath, this.timeStamp, this.fileName,
      this.alertDescription, this.coordinates,
      [this.isAudio = false]);
}
