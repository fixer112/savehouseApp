class Activity {
  final int id;
  final String summary;
  final String by;
  final String createdAt;

  Activity({this.createdAt, this.id, this.by, this.summary});

  factory Activity.fromMap(Map data) => Activity(
        id: data['id'],
        summary: data['summary'],
        by: data['by'],
        createdAt: data['created_at'],
      );
}
