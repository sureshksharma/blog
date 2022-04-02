class Posts {
  String image, description, date, time;
  Posts({
    required this.image,
    required this.description,
    required this.date,
    required this.time,
  });

  static Posts fromMap(Map<String, dynamic> map) {
    return Posts(
        image: map['image'],
        description: map['description'],
        date: map['date'],
        time: map['time']);
  }
}
