import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wrap_report/models/article.dart';
import 'package:wrap_report/pages/article_page.dart';
import 'package:wrap_report/providers/saved_articles_provider.dart';
import 'package:wrap_report/providers/top_headlines_provider.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/shared/news_categories.dart';
import 'package:wrap_report/shared/constants.dart';
import 'package:wrap_report/widgets/article_card.dart';
import 'package:wrap_report/widgets/error_widget.dart';

class TopHeadlinesPage extends StatefulWidget {
  const TopHeadlinesPage({super.key});

  @override
  State<TopHeadlinesPage> createState() => _TopHeadlinesPageState();
}

class _TopHeadlinesPageState extends State<TopHeadlinesPage> {

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<TopHeadlinesProvider>(context, listen: false);
    var selectedIndex = Provider.of<TopHeadlinesProvider>(context, listen: false).selectedIndex;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(provider.articles.isEmpty) {
        provider.getTopHeadlines(NewsCategories.values[selectedIndex]);
      } 
    });   
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = Provider.of<TopHeadlinesProvider>(context, listen: false).selectedIndex;

    return Container(
      color: Constants.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          children: [
            const Text(
              'Discover News from around the world',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold,
                  color: Constants.colorWhite
                ),
            ),
            const SizedBox(
              height: 8,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Widget>.generate(
                    NewsCategories.values.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                            labelPadding: const EdgeInsets.fromLTRB(0,0,4,0),
                            padding: const EdgeInsets.fromLTRB(2,0,4,0),
                            avatar: Icon(NewsCategories.values[index].icon,),
                            backgroundColor: Constants.accentColor,
                            selectedColor: const Color.fromARGB(255, 118, 145, 170),
                            labelStyle: const TextStyle(color: Colors.black),
                            label: Text(NewsCategories.values[index].name),
                            selected: selectedIndex == index,
                            onSelected: (value) {
                                if(selectedIndex != index || Provider.of<TopHeadlinesProvider>(context, listen: false).apiException != null){
                                  Provider.of<TopHeadlinesProvider>(context, listen: false).getTopHeadlines(NewsCategories.values[index]);
                                  Provider.of<TopHeadlinesProvider>(context, listen: false).selectedIndex = index;
                                  setState(() {}); 
                                } 
                            },
                        ),
                    )
                  ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Consumer<TopHeadlinesProvider>(
              builder: (context, provider, child) {
                List<Article> articles = provider.articles;
                return provider.isLoading ? 
                  const Expanded (child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 100.0),
                      child: SpinKitSpinningLines(
                        color: Constants.accentColor,
                        size: 50,
                      ),
                    ),
                  )) 
                  : provider.apiException == null ? 
                  Expanded(
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 12), child: ArticleCard(article: articles[index])),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: Provider.of<SavedArticlesProvider>(context, listen: false),
                                child: ArticlePage(article: articles[index])
                                )
                              )
                            );
                          },
                        );
                      },
                    ),
                  ): 
                  Expanded(child: ErrorMessage(apiException: provider.apiException ?? BadRequestException(message: 'Nothing loaded yet'), icon: Icons.sentiment_dissatisfied));
             },
            )
          ],
        ),
      ),
    );
  }
}
