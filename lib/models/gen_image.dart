class GenImage {
  final String id;
  final String url;
  final bool selected;

  GenImage({required this.id, required this.url, required this.selected});

  factory GenImage.fromMap(Map<String, dynamic> json) =>
      GenImage(id: json["_id"], url: json["url"], selected: json["selected"]);

  Map<String, dynamic> toMap() => {"_id": id, "url": url, "selected": selected};
}
