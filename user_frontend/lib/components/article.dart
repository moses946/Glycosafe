import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/article_datastructure.dart';
import 'package:glycosafe_v1/components/full_article.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/themeprovider.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    var isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkMode;

    var textColor = isDarkTheme ? Colors.white : Colors.black;
    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => FullArticleBottomSheet(article: article),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.asset(article.imageUrl,
                  fit: BoxFit.fill,
                  height: 130,
                  width: MediaQuery.of(context).size.width - 20),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 10, right: 5, bottom: 5),
              child: Text(
                article.title,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 8.0, top: 0, bottom: 15),
              child: Text(
                article.description,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
