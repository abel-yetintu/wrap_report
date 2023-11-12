import 'package:flutter/material.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/services/database_helper.dart';

class SavedArticlesProvider extends ChangeNotifier {
  final _databaseHelper = DatabaseHelper();

  Future<List<Article>> getAllArticles() async {
    return await _databaseHelper.getAllArticles();
  }

  Future<int> insertArticle(Article article) async {
    final result = await _databaseHelper.insertArticle(article);
    notifyListeners();
    return result;
  }

  Future<int> deleteArticle(Article article) async {
    final result = await _databaseHelper.deleteArticle(article);
    notifyListeners();
    return result;
  }
}
