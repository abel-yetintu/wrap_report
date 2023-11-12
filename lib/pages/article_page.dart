// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrap_report/models/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wrap_report/providers/saved_articles_provider.dart';
import 'package:wrap_report/shared/constants.dart';

class ArticlePage extends StatelessWidget {
  final Article article;
  const ArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {

    final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse(article.url));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
        title: Text(article.source.name, style: const TextStyle(color: Constants.colorWhite, fontWeight: FontWeight.w800),),
      ),
      body: WebViewWidget(controller: controller),
      floatingActionButton: Builder(
        builder: (context) {
          return SizedBox(
            height: 80,
            width: 60,
            child: FloatingActionButton(
              backgroundColor: Constants.primaryColor,
              child: const Icon(Icons.favorite, color: Constants.colorWhite, size: 32,),
              onPressed: () async {
                var reult = await Provider.of<SavedArticlesProvider>(context, listen: false).insertArticle(article);
                if(reult != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Article saved.', style: TextStyle(color: Constants.colorWhite),), backgroundColor: Constants.primaryColor, duration: Duration(seconds: 1),));
                }
              }
            ),
          );
        }
      ),
    );
  }
}
