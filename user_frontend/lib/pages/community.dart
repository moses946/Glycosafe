import 'package:flutter/material.dart';
import 'package:glycosafe_v1/components/article.dart';
import 'package:glycosafe_v1/components/article_datastructure.dart';
import 'package:glycosafe_v1/components/bottomnav.dart';
import 'package:glycosafe_v1/providers/themeprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Articles",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: isDarkTheme ? Colors.white : Colors.black)),
      ),
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      body: SafeArea(
        child: Stack(children: [
          ArticleListPage(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomNav(),
          )
        ]),
      ),
    );
  }
}

class ArticleListPage extends StatelessWidget {
  final List<Article> articles = [
    Article(
      imageUrl: 'assets/images/fruit.jpg',
      title: 'Can you really eat too much fruits?',
      description:
          'Fruit has long been a recommended source of calories, fiber, and a host  of nutrients. However, is there such a thing as overeating fruit?',
      fullText:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ac nibh interdum, efficitur ipsum aliquam, tincidunt risus. Integer congue, risus a posuere ornare, felis orci consectetur sem, ut lacinia nisi ante placerat eros. Donec vel mattis turpis. Cras semper odio eu leo consectetur condimentum. Maecenas vitae sem id lectus ullamcorper consequat. Donec consectetur gravida mauris, eu scelerisque diam varius quis.\n\n Suspendisse malesuada pretium lectus in pulvinar. Curabitur vel facilisis neque, eu commodo lacus. Maecenas malesuada turpis at justo rutrum, eu rhoncus nibh aliquet.Suspendisse potenti. Donec vestibulum lorem at diam euismod volutpat. Proin sollicitudin massa elit, in fringilla enim facilisis eget. In at leo convallis, laoreet urna id, ullamcorper libero. Sed laoreet enim turpis, vitae tempus purus tristique non. Aenean gravida ipsum ac orci pretium volutpat. Donec ut tempus leo. Morbi aliquam leo et odio auctor vestibulum. Donec vel nulla rhoncus, sodales magna sit amet, hendrerit augue. Praesent id ultricies augue, at commodo felis. Proin sit amet egestas ligula. Donec lobortis sem vel urna dapibus, eu cursus ligula tincidunt. Suspendisse nec vestibulum justo. Maecenas aliquam at leo ut molestie. Nunc eget felis a ipsum lobortis condimentum in id orci. Curabitur porttitor nisl justo, at dapibus velit blandit sed.\n\nIn lobortis velit arcu, id molestie sem vestibulum sit amet. Proin lobortis feugiat dolor, vitae cursus magna dapibus et. In nec felis orci. Fusce rhoncus porttitor fringilla. Donec maximus risus eget dolor sodales vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque in sagittis nisi. In ac augue malesuada, aliquet dolor eget, euismod mauris. Quisque eget ipsum consequat, elementum ex id, bibendum ligula. Nam quis dapibus enim. Nulla suscipit lacinia fringilla. Duis bibendum, quam nec interdum facilisis, justo turpis euismod orci, ut ornare dolor odio at justo. Cras vitae dapibus dolor. Suspendisse at gravida leo, eu venenatis odio. Praesent dignissim sem nibh, volutpat efficitur est finibus ac.\n\nMaecenas condimentum eleifend ante, finibus laoreet quam scelerisque facilisis. Nam tristique ac nibh a sollicitudin. Nullam sit amet leo porta, vestibulum massa eu, tincidunt libero. In tristique augue facilisis ipsum venenatis, ut vulputate nunc consequat. Duis imperdiet enim libero, a tempor quam pulvinar tempus. Aliquam non ultrices felis. Duis ultrices mauris elit, at pellentesque velit euismod sed. Aliquam porta eu ex tincidunt pharetra.\n\nNunc vitae blandit tortor. Phasellus aliquet eget nisi ac faucibus. Proin imperdiet nunc id imperdiet euismod. Mauris efficitur vel quam ac imperdiet. Donec euismod massa et dolor scelerisque, eget imperdiet lacus vestibulum. Fusce eleifend fermentum magna, in facilisis massa luctus in. Etiam egestas nec mi non molestie. Vestibulum id rutrum neque. Duis placerat semper sapien ac rhoncus. Etiam ultrices mauris lorem, quis congue ante lobortis sit amet. Curabitur eu sollicitudin est. Mauris commodo, arcu nec efficitur laoreet, enim leo finibus tellus, vitae ullamcorper tortor libero vel tortor. Curabitur in ligula sit amet urna ultricies lobortis. Donec semper diam purus, sed semper turpis condimentum a. Donec finibus leo nisl, at dignissim arcu tempus et. Morbi sagittis dui sit amet auctor aliquet.\n\nMaecenas at eleifend tortor. Cras eu tellus nulla. Donec nec leo interdum leo efficitur ultricies. Suspendisse gravida lorem vel velit sollicitudin facilisis ac cursus est. Nulla dapibus tempor laoreet. Maecenas dictum mauris vitae posuere malesuada. Phasellus sagittis justo eget consequat porttitor.\n\nNam sit amet nulla nunc. Morbi vehicula nisi nec leo semper, vel lobortis ipsum consectetur. Aenean urna purus, aliquet eu commodo in, vulputate eu lectus. Ut imperdiet tincidunt efficitur. Nulla sit amet posuere turpis. Sed ullamcorper ligula orci, vel suscipit enim tempus eu. Pellentesque vestibulum nibh metus, et ultrices libero consequat id. Donec mattis eget enim in congue. In dui tellus, tincidunt eu sagittis elementum, mollis non nulla.\n\nAliquam suscipit molestie metus, id congue dui porta ac. Etiam dignissim vulputate metus eu tristique. Sed commodo in elit dignissim condimentum. Maecenas gravida congue magna. Etiam elementum purus imperdiet ligula elementum, a maximus urna dictum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin laoreet enim sed dolor porta consequat blandit euismod massa. Praesent elementum lectus et vestibulum pharetra. Praesent hendrerit felis quis diam auctor laoreet. Fusce vestibulum libero vitae lorem pellentesque viverra in quis velit.",
    ),
    Article(
      imageUrl: 'assets/images/salad.png',
      title: 'What is a healthy, balanced diet for Diabetes?',
      description:
          'There is no specific diet for diabetes. But the foods you eat not only make a difference to how you manage your diabetes, but also to how well you feel and how much energy you have.',
      fullText:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ac nibh interdum, efficitur ipsum aliquam, tincidunt risus. Integer congue, risus a posuere ornare, felis orci consectetur sem, ut lacinia nisi ante placerat eros. Donec vel mattis turpis. Cras semper odio eu leo consectetur condimentum. Maecenas vitae sem id lectus ullamcorper consequat. Donec consectetur gravida mauris, eu scelerisque diam varius quis.\n\n Suspendisse malesuada pretium lectus in pulvinar. Curabitur vel facilisis neque, eu commodo lacus. Maecenas malesuada turpis at justo rutrum, eu rhoncus nibh aliquet.Suspendisse potenti. Donec vestibulum lorem at diam euismod volutpat. Proin sollicitudin massa elit, in fringilla enim facilisis eget. In at leo convallis, laoreet urna id, ullamcorper libero. Sed laoreet enim turpis, vitae tempus purus tristique non. Aenean gravida ipsum ac orci pretium volutpat. Donec ut tempus leo. Morbi aliquam leo et odio auctor vestibulum. Donec vel nulla rhoncus, sodales magna sit amet, hendrerit augue. Praesent id ultricies augue, at commodo felis. Proin sit amet egestas ligula. Donec lobortis sem vel urna dapibus, eu cursus ligula tincidunt. Suspendisse nec vestibulum justo. Maecenas aliquam at leo ut molestie. Nunc eget felis a ipsum lobortis condimentum in id orci. Curabitur porttitor nisl justo, at dapibus velit blandit sed.\n\nIn lobortis velit arcu, id molestie sem vestibulum sit amet. Proin lobortis feugiat dolor, vitae cursus magna dapibus et. In nec felis orci. Fusce rhoncus porttitor fringilla. Donec maximus risus eget dolor sodales vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque in sagittis nisi. In ac augue malesuada, aliquet dolor eget, euismod mauris. Quisque eget ipsum consequat, elementum ex id, bibendum ligula. Nam quis dapibus enim. Nulla suscipit lacinia fringilla. Duis bibendum, quam nec interdum facilisis, justo turpis euismod orci, ut ornare dolor odio at justo. Cras vitae dapibus dolor. Suspendisse at gravida leo, eu venenatis odio. Praesent dignissim sem nibh, volutpat efficitur est finibus ac.\n\nMaecenas condimentum eleifend ante, finibus laoreet quam scelerisque facilisis. Nam tristique ac nibh a sollicitudin. Nullam sit amet leo porta, vestibulum massa eu, tincidunt libero. In tristique augue facilisis ipsum venenatis, ut vulputate nunc consequat. Duis imperdiet enim libero, a tempor quam pulvinar tempus. Aliquam non ultrices felis. Duis ultrices mauris elit, at pellentesque velit euismod sed. Aliquam porta eu ex tincidunt pharetra.\n\nNunc vitae blandit tortor. Phasellus aliquet eget nisi ac faucibus. Proin imperdiet nunc id imperdiet euismod. Mauris efficitur vel quam ac imperdiet. Donec euismod massa et dolor scelerisque, eget imperdiet lacus vestibulum. Fusce eleifend fermentum magna, in facilisis massa luctus in. Etiam egestas nec mi non molestie. Vestibulum id rutrum neque. Duis placerat semper sapien ac rhoncus. Etiam ultrices mauris lorem, quis congue ante lobortis sit amet. Curabitur eu sollicitudin est. Mauris commodo, arcu nec efficitur laoreet, enim leo finibus tellus, vitae ullamcorper tortor libero vel tortor. Curabitur in ligula sit amet urna ultricies lobortis. Donec semper diam purus, sed semper turpis condimentum a. Donec finibus leo nisl, at dignissim arcu tempus et. Morbi sagittis dui sit amet auctor aliquet.\n\nMaecenas at eleifend tortor. Cras eu tellus nulla. Donec nec leo interdum leo efficitur ultricies. Suspendisse gravida lorem vel velit sollicitudin facilisis ac cursus est. Nulla dapibus tempor laoreet. Maecenas dictum mauris vitae posuere malesuada. Phasellus sagittis justo eget consequat porttitor.\n\nNam sit amet nulla nunc. Morbi vehicula nisi nec leo semper, vel lobortis ipsum consectetur. Aenean urna purus, aliquet eu commodo in, vulputate eu lectus. Ut imperdiet tincidunt efficitur. Nulla sit amet posuere turpis. Sed ullamcorper ligula orci, vel suscipit enim tempus eu. Pellentesque vestibulum nibh metus, et ultrices libero consequat id. Donec mattis eget enim in congue. In dui tellus, tincidunt eu sagittis elementum, mollis non nulla.\n\nAliquam suscipit molestie metus, id congue dui porta ac. Etiam dignissim vulputate metus eu tristique. Sed commodo in elit dignissim condimentum. Maecenas gravida congue magna. Etiam elementum purus imperdiet ligula elementum, a maximus urna dictum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin laoreet enim sed dolor porta consequat blandit euismod massa. Praesent elementum lectus et vestibulum pharetra. Praesent hendrerit felis quis diam auctor laoreet. Fusce vestibulum libero vitae lorem pellentesque viverra in quis velit.",
    ),
    Article(
      imageUrl: 'assets/images/tips.png',
      title: '10 tips for healthy eating with diabetes.',
      description:
          'There are different types of diabetes, and no two people with diabetes are the same. So there isn’t a one-size-fits-all \'diabetes diet\' for everyone with diabetes. But we’ve come up with tips that you can use to help you make healthier food choices. ',
      fullText:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ac nibh interdum, efficitur ipsum aliquam, tincidunt risus. Integer congue, risus a posuere ornare, felis orci consectetur sem, ut lacinia nisi ante placerat eros. Donec vel mattis turpis. Cras semper odio eu leo consectetur condimentum. Maecenas vitae sem id lectus ullamcorper consequat. Donec consectetur gravida mauris, eu scelerisque diam varius quis.\n\n Suspendisse malesuada pretium lectus in pulvinar. Curabitur vel facilisis neque, eu commodo lacus. Maecenas malesuada turpis at justo rutrum, eu rhoncus nibh aliquet.Suspendisse potenti. Donec vestibulum lorem at diam euismod volutpat. Proin sollicitudin massa elit, in fringilla enim facilisis eget. In at leo convallis, laoreet urna id, ullamcorper libero. Sed laoreet enim turpis, vitae tempus purus tristique non. Aenean gravida ipsum ac orci pretium volutpat. Donec ut tempus leo. Morbi aliquam leo et odio auctor vestibulum. Donec vel nulla rhoncus, sodales magna sit amet, hendrerit augue. Praesent id ultricies augue, at commodo felis. Proin sit amet egestas ligula. Donec lobortis sem vel urna dapibus, eu cursus ligula tincidunt. Suspendisse nec vestibulum justo. Maecenas aliquam at leo ut molestie. Nunc eget felis a ipsum lobortis condimentum in id orci. Curabitur porttitor nisl justo, at dapibus velit blandit sed.\n\nIn lobortis velit arcu, id molestie sem vestibulum sit amet. Proin lobortis feugiat dolor, vitae cursus magna dapibus et. In nec felis orci. Fusce rhoncus porttitor fringilla. Donec maximus risus eget dolor sodales vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque in sagittis nisi. In ac augue malesuada, aliquet dolor eget, euismod mauris. Quisque eget ipsum consequat, elementum ex id, bibendum ligula. Nam quis dapibus enim. Nulla suscipit lacinia fringilla. Duis bibendum, quam nec interdum facilisis, justo turpis euismod orci, ut ornare dolor odio at justo. Cras vitae dapibus dolor. Suspendisse at gravida leo, eu venenatis odio. Praesent dignissim sem nibh, volutpat efficitur est finibus ac.\n\nMaecenas condimentum eleifend ante, finibus laoreet quam scelerisque facilisis. Nam tristique ac nibh a sollicitudin. Nullam sit amet leo porta, vestibulum massa eu, tincidunt libero. In tristique augue facilisis ipsum venenatis, ut vulputate nunc consequat. Duis imperdiet enim libero, a tempor quam pulvinar tempus. Aliquam non ultrices felis. Duis ultrices mauris elit, at pellentesque velit euismod sed. Aliquam porta eu ex tincidunt pharetra.\n\nNunc vitae blandit tortor. Phasellus aliquet eget nisi ac faucibus. Proin imperdiet nunc id imperdiet euismod. Mauris efficitur vel quam ac imperdiet. Donec euismod massa et dolor scelerisque, eget imperdiet lacus vestibulum. Fusce eleifend fermentum magna, in facilisis massa luctus in. Etiam egestas nec mi non molestie. Vestibulum id rutrum neque. Duis placerat semper sapien ac rhoncus. Etiam ultrices mauris lorem, quis congue ante lobortis sit amet. Curabitur eu sollicitudin est. Mauris commodo, arcu nec efficitur laoreet, enim leo finibus tellus, vitae ullamcorper tortor libero vel tortor. Curabitur in ligula sit amet urna ultricies lobortis. Donec semper diam purus, sed semper turpis condimentum a. Donec finibus leo nisl, at dignissim arcu tempus et. Morbi sagittis dui sit amet auctor aliquet.\n\nMaecenas at eleifend tortor. Cras eu tellus nulla. Donec nec leo interdum leo efficitur ultricies. Suspendisse gravida lorem vel velit sollicitudin facilisis ac cursus est. Nulla dapibus tempor laoreet. Maecenas dictum mauris vitae posuere malesuada. Phasellus sagittis justo eget consequat porttitor.\n\nNam sit amet nulla nunc. Morbi vehicula nisi nec leo semper, vel lobortis ipsum consectetur. Aenean urna purus, aliquet eu commodo in, vulputate eu lectus. Ut imperdiet tincidunt efficitur. Nulla sit amet posuere turpis. Sed ullamcorper ligula orci, vel suscipit enim tempus eu. Pellentesque vestibulum nibh metus, et ultrices libero consequat id. Donec mattis eget enim in congue. In dui tellus, tincidunt eu sagittis elementum, mollis non nulla.\n\nAliquam suscipit molestie metus, id congue dui porta ac. Etiam dignissim vulputate metus eu tristique. Sed commodo in elit dignissim condimentum. Maecenas gravida congue magna. Etiam elementum purus imperdiet ligula elementum, a maximus urna dictum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin laoreet enim sed dolor porta consequat blandit euismod massa. Praesent elementum lectus et vestibulum pharetra. Praesent hendrerit felis quis diam auctor laoreet. Fusce vestibulum libero vitae lorem pellentesque viverra in quis velit.",
    ),
  ];

  ArticleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length + 1,
      itemBuilder: (context, index) {
        if (index < articles.length) {
          final article = articles[index];
          return ArticleCard(article: article);
        } else {
          return const SizedBox(
            height: 100,
          );
        }
      },
    );
  }
}
