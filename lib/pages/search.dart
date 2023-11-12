import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wrap_report/pages/article_page.dart';
import 'package:wrap_report/providers/saved_articles_provider.dart';
import 'package:wrap_report/providers/search_news_provider.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/shared/constants.dart';
import 'package:wrap_report/widgets/article_card.dart';
import 'package:wrap_report/widgets/error_widget.dart';

class SearchPage extends StatelessWidget {

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          children: [
            TextField(
              cursorColor: Constants.secondaryColor,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Please Enter a search term first', style: TextStyle(color: Constants.secondaryColor),), backgroundColor: Constants.accentColor, duration: Duration(seconds: 2)));
                } else {
                  Provider.of<SearchNewsProvider>(context, listen: false).searchNews(value);
                }
              },
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Constants.accentColor,
                  hintText: 'Enter a search term',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Constants.secondaryColor,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Constants.accentColor, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Constants.secondaryColor, width: 2))),
            ),
            const SizedBox(height: 16.0,),
            Consumer<SearchNewsProvider>(
              builder: (context, provider, child) {
                return provider.isLoading ? 
                  const Expanded(
                    child: Center(child: Padding(
                      padding: EdgeInsets.only(bottom: 100.0),
                      child: SpinKitSpinningLines(
                        color: Constants.accentColor,
                        size: 50,
                        ),
                      )
                    ),
                  ) 
                  : provider.apiException != null ?
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ErrorMessage(apiException: provider.apiException!, icon: Icons.sentiment_dissatisfied),
                  )) 
                  : provider.articles != null && provider.articles!.isEmpty ?
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ErrorMessage(apiException: BadRequestException(message: 'No Articles Found'), icon: Icons.feed_outlined),
                  )) 
                  : provider.articles != null ?
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.articles!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 12), child: ArticleCard(article: provider.articles![index])),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: Provider.of<SavedArticlesProvider>(context, listen: false),
                                child: ArticlePage(article: provider.articles![index])
                                )
                              )
                            );
                          },
                        );
                      },
                    )
                  ):
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ErrorMessage(apiException: FetchDataException(message: 'Search for articles'), icon: Icons.location_searching),
                  ));
              },
            )
          ],
        ),
      ),
    );
  }
}
