class ItemModel {
  String imageUrl;
  String title;
  String subtitle;

  ItemModel(
      {required this.imageUrl, required this.subtitle, required this.title});

  factory ItemModel.fromJson(json) => ItemModel(
        imageUrl: json['imageUrl'],
        title: json['title'],
        subtitle: json['subtitle'],
      );
}
