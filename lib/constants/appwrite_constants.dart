class AppwriteConstants {
  static const String databaseId = '6482cc2c91bacc773876';
  static const String projectId = '6482c97f5c8afb81e467';
  static const String endPoint = 'https://192.168.43.253:443/v1';

  static const String usersCollection = '6482cc3c3ed88324957e';
  static const String memoriesCollection = '6482cc639ea5db4e9457';
  static const String imageBucket = '6482cc9ad1db7b3153fa';
  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imageBucket/files/$imageId/view?project=$projectId&mode=admin';
}
