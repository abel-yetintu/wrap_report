import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/shared/constants.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  const ArticleCard({super.key, required this.article,});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('d MMM, y').format(article.publishedAt);
    return SizedBox(
      height: 175,
      child: Card(
        margin: const EdgeInsets.only(right: 4, left: 4),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.hardEdge,
        color: Constants.accentColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source.name,
                      style: const TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      article.description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Image.network(
                article.image,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
