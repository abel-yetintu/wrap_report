import 'package:flutter/material.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/services/news_api.dart';

class SearchNewsProvider extends ChangeNotifier {
  final NewsApi _newsApi = NewsApi();

  List<Article>? _articles;
  List<Article>? get articles => _articles;

  ApiException? _apiException;
  ApiException? get apiException => _apiException;

  bool isLoading = false;

  void searchNews(String keyWord) async {
    try {
      isLoading = true;
      notifyListeners();
      _articles = await _newsApi.search(keyWord: keyWord);
      _apiException = null;
      isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _apiException = e;
      _articles = [];
      isLoading = false;
      notifyListeners();
    }
  }
}
