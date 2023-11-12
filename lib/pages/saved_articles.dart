import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/pages/article_page.dart';
import 'package:wrap_report/providers/saved_articles_provider.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/shared/constants.dart';
import 'package:wrap_report/widgets/article_card.dart';
import 'package:wrap_report/widgets/error_widget.dart';

class SavedArticlesPage extends StatelessWidget {
  const SavedArticlesPage({super.key});
  @override
  Widget build(BuildContext context) {

    void showDeleteDialog(Article article) {
      showDialog(
        context: context, 
        builder: (_) {
          return AlertDialog(
            backgroundColor: Constants.primaryColor,
            title: const Text('Delete Article', style: TextStyle(color: Constants.colorWhite),),
            content: const Text('Are you sure you want to delete this article?', style: TextStyle(color: Constants.colorWhite),),
            actions: [
              TextButton(
                child: const Text('Yes', style: TextStyle(color: Constants.colorWhite),),
                onPressed: () {
                  var result = Provider.of<SavedArticlesProvider>(context, listen: false).deleteArticle(article);
                  Navigator.pop(context);
                  result.then((value) {
                    if (value != 0) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Article Deleted.', style: TextStyle(color: Constants.secondaryColor),), backgroundColor: Constants.accentColor, duration: Duration(seconds: 1)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Failed to delete Article.', style: TextStyle(color: Constants.secondaryColor),), backgroundColor: Constants.accentColor, duration: Duration(seconds: 1)));
                    }
                  });
                },
              ),
              TextButton(
                child: const Text('NO', style: TextStyle(color: Constants.colorWhite),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
    }

    return Container(
      color: Constants.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Consumer<SavedArticlesProvider>(
          builder: (context, provider, child) {
            return FutureBuilder(
              initialData: const [],
              future: provider.getAllArticles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(
                    child: Padding(
                    padding: EdgeInsets.only(bottom: 100.0),
                    child: SpinKitSpinningLines(
                      color: Constants.accentColor,
                      size: 50,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final articles = snapshot.data as List<Article>;
                  if (articles.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      child: ErrorMessage(
                        apiException: FetchDataException(message: 'No saved Articles'), icon: Icons.feed_outlined
                      )
                    );
                  } else {
                    return ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(), 
                              children: [
                                SlidableAction(
                                  foregroundColor: Constants.colorWhite,
                                  label: 'Delete Article',
                                  backgroundColor: const Color.fromARGB(255, 181, 37, 37),
                                  icon: Icons.delete,
                                  borderRadius: BorderRadius.circular(12),
                                  onPressed: (context) {
                                    showDeleteDialog(articles[index]);
                                  },
                                )
                              ]
                            ),
                            child: GestureDetector(
                              child: ArticleCard(article: articles[index]),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider.value(
                                    value: Provider.of<SavedArticlesProvider>(context, listen: false),
                                    child: ArticlePage(article: articles[index])
                                    )
                                  )
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return SizedBox(
                      width: double.infinity,
                      child: ErrorMessage(
                        apiException: FetchDataException(message: snapshot.error.toString()), icon: Icons.sentiment_dissatisfied
                      )
                    );
                } 
              },
            );
          },
        ),
      ),
    );
  }
}