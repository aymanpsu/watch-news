import 'package:flutter/material.dart';
import '../../../../helpers/app_genric_styles.dart';
import 'horizontal_recent_news_card_item.dart';
import '../../../../services/news_service.dart';
import '../../../../models/news.dart';
import '../../../../pages/news_details_page.dart';

class HorizontalRecentNewsList extends StatefulWidget {
  const HorizontalRecentNewsList({Key? key}) : super(key: key);

  @override
  State<HorizontalRecentNewsList> createState() => _HorizontalRecentNewsListState();
}

class _HorizontalRecentNewsListState extends State<HorizontalRecentNewsList> {
  late NewsService newsService;

  @override
  void initState() {
    super.initState();
    newsService = NewsService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: newsService.fetchRecentNews(1, 8),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          News news = snapshot.data!;
          return _buildListView(news);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget _buildListView(News news) {
    return ListView.builder(
      padding: AppGenricStyles.paddingForList,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewsDetailsPage(
                  newsImage: news.articles[index].urlToImage,
                  newsTitle: news.articles[index].title,
                  newesDatePublished: news.articles[index].publishedAt,
                  newsDescription: news.articles[index].description,
                  newsUrl: news.articles[index].url,
                  newsContent: news.articles[index].content,
                ),
              ),
            );
          },
          child: HorizontalRecentNewsCardItem(
            newsImage: news.articles[index].urlToImage,
            newsTitle: news.articles[index].title,
            newesDatePublished: news.articles[index].publishedAt,
            newsSource: news.articles[index].source.name,
          ),
        );
      }),
      itemCount: news.articles.length,
    );
  }
}
