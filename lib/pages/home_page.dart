import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wrap_report/pages/saved_articles.dart';
import 'package:wrap_report/pages/search.dart';
import 'package:wrap_report/pages/top_headlines.dart';
import 'package:wrap_report/providers/saved_articles_provider.dart';
import 'package:wrap_report/providers/search_news_provider.dart';
import 'package:wrap_report/providers/top_headlines_provider.dart';
import 'package:wrap_report/shared/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentPageIndex = 0;
  final List<Widget> _pageList = const [TopHeadlinesPage(), SearchPage(), SavedArticlesPage()];

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<TopHeadlinesProvider>(create: (context) => TopHeadlinesProvider()),
        ChangeNotifierProvider<SearchNewsProvider>(create: (context) => SearchNewsProvider()),
        ChangeNotifierProvider<SavedArticlesProvider>(create: (context) => SavedArticlesProvider(),)
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Constants.primaryColor,
          title: const Text('Wrap Report', style: TextStyle(color: Constants.colorWhite, fontWeight: FontWeight.w800),),
        ),
        body: _pageList[_currentPageIndex],
        bottomNavigationBar: Container(
          color: Constants.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              backgroundColor: Constants.primaryColor,
              color: Constants.colorWhite,
              activeColor: Constants.colorWhite,
              tabBackgroundColor: Constants.secondaryColor,
              padding: const EdgeInsets.all(10),
              gap: 8,
              selectedIndex: _currentPageIndex,
              onTabChange: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.newspaper,
                  text: 'Top Headlines',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.favorite_outline_outlined,
                  text: 'Saved Articles',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
