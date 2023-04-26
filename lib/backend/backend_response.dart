class Event {
  final String name;
  final String type;
  final String id;
  final String url;
  final DateTime dateTime;
  final List<Image> images;
  bool isFavourite;

  Event(
      {required this.name,
      required this.type,
      required this.id,
      required this.url,
      required this.dateTime,
      required this.images,
      this.isFavourite = false});

  factory Event.fromJson(Map<String, dynamic> json) {
    final String name = json.containsKey('name') ? json['name'] : '';
    final String type = json.containsKey('type') ? json['type'] : '';
    final String id = json.containsKey('id') ? json['id'] : '';
    final String url = json.containsKey('url') ? json['url'] : '';
    final Map<String, dynamic> datesJson = json.containsKey('dates') ? json['dates'] : {};
    final Map<String, dynamic> startDateJson = datesJson.containsKey('start') ? datesJson['start'] : {};
    final DateTime dateTime = startDateJson.containsKey('dateTime') ? DateTime.parse(startDateJson['dateTime']) : DateTime.now();
    final List<Image> images = json.containsKey('images') ? (json['images'] as List<dynamic>).map((e) => Image.fromJson(e)).toList() : <Image>[];

    return Event(name: name, type: type, id: id, url: url, dateTime: dateTime, images: images);
  }

  @override
  String toString() {
    return 'Event{name: $name, type: $type, id: $id, url: $url, dateTime: $dateTime, images: $images}';
  }
}

class Image {
  final String ratio;
  final String url;
  final num width;
  final num height;

  const Image({required this.ratio, required this.url, required this.height, required this.width});

  factory Image.fromJson(Map<String, dynamic> json) {
    final String ratio = json.containsKey('ratio') ? json['ratio'] : '';
    final String url = json.containsKey('url') ? json['url'] : '';
    final num width = json.containsKey('width') ? json['width'] : 100;
    final num height = json.containsKey('height') ? json['height'] : 100;

    return Image(ratio: ratio, url: url, height: height, width: width);
  }

  @override
  String toString() {
    return 'Image{ratio: $ratio, url: $url, width: $width, height: $height}';
  }
}
