import 'package:flutter/material.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/services/news_api.dart';
import 'package:wrap_report/shared/news_categories.dart';

class TopHeadlinesProvider extends ChangeNotifier {
  final NewsApi _newsApi = NewsApi();

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  ApiException? _apiException;
  ApiException? get apiException => _apiException;

  bool isLoading = true;

  int selectedIndex = 0;

  void getTopHeadlines(NewsCategories newsCategory) async {
    try {
      isLoading = true;
      notifyListeners();
      _articles = await _newsApi.getTopHeadlines(newsCategory: newsCategory);
      _apiException = null;
      isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      isLoading = false;
      _articles = [];
      _apiException = e;
      notifyListeners();
    }
  }
}
