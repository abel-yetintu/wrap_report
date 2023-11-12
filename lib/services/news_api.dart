// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/shared/news_categories.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  static const apiKey = '##########';
  static const baseUrl = 'https://gnews.io/api/v4/';
  static const int TIME_OUT_DURATION = 20;

  Future<List<Article>> getTopHeadlines({required NewsCategories newsCategory}) async {
    try {
      Uri uri = Uri.parse('$baseUrl/top-headlines?apikey=$apiKey&category=${newsCategory.name.toLowerCase()}&lang=en');
      var response = await http.get(uri).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No internet connection');
    } on FormatException {
      throw FetchDataException(message: 'Error occured while converting format.');
    } on TimeoutException {
      throw ApiNotRespondingException(message: 'Api not responding');
    }
  }

  Future<List<Article>> search({required String keyWord}) async {
    try {
      Uri uri = Uri.parse('$baseUrl/search?apikey=$apiKey&q=$keyWord&lang=en');
      var response = await http.get(uri).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No internet connection');
    } on FormatException {
      throw FetchDataException(message: 'Error occured while converting format.');
    } on TimeoutException {
      throw ApiNotRespondingException(message: 'Api not responding');
    }
  }

  List<Article> _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return NewsApiResponse.fromJson(jsonDecode(response.body)).articles;
      case 400:
        throw BadRequestException(message: 'Your request is invalid');
      case 401:
        throw UnAuthorizedException(message: 'Unauthorized, attempt failed.');
      case 403:
        throw ForbiddenException(message: 'You have reached your daily quota, the next reset is at 00:00 UTC.');
      case 429:
        throw BadRequestException(message: 'You have made more requests per second than you are allowed.'); 
      case 500:
        throw BadRequestException(message: 'Internal Server Error -- We had a problem with our server. Try again later.');  
      default:
        throw FetchDataException(message: 'Service Unavailable. Error occured with code: ${response.statusCode}');
    }
  }
}