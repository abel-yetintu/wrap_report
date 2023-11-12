
class NewsApiResponse {
    final int totalArticles;
    final List<Article> articles;

    NewsApiResponse({
        required this.totalArticles,
        required this.articles,
    });

    factory NewsApiResponse.fromJson(Map<String, dynamic> json) => NewsApiResponse(
        totalArticles: json["totalArticles"],
        articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalArticles": totalArticles,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    };
}

class Article {
    final String title;
    final String description;
    final String content;
    final String url;
    final String image;
    final DateTime publishedAt;
    final Source source;

    Article({
        required this.title,
        required this.description,
        required this.content,
        required this.url,
        required this.image,
        required this.publishedAt,
        required this.source,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        description: json["description"],
        content: json["content"],
        url: json["url"],
        image: json["image"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        source: Source.fromJson(json["source"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "content": content,
        "url": url,
        "image": image,
        "publishedAt": publishedAt.toIso8601String(),
        "source": source.toJson(),
    };

    factory Article.fromMap(Map<String, dynamic> map) => Article(
        title: map["title"],
        description: map["description"],
        content: map["content"],
        url: map["url"],
        image: map["image"],
        publishedAt: DateTime.parse(map["publishedAt"]),
        source: Source(name: map['source'], url: 'url'),
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "content": content,
        "url": url,
        "image": image,
        "publishedAt": publishedAt.toIso8601String(),
        "source": source.name,
    };
}

class Source {
    final String name;
    final String url;

    Source({
        required this.name,
        required this.url,
    });

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}