import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:readme_app/controller/cart_controller.dart';
import 'package:readme_app/core/constants/colours.dart';
import 'package:readme_app/core/constants/dimens.dart';
import 'package:readme_app/core/constants/move.dart';
import 'package:readme_app/core/constants/yh_style_icons.dart';
import 'package:readme_app/view/page/book_detail/book_detail_page/book_detail_page_view_model.dart';
import 'package:readme_app/view/page/book_detail/book_detail_page/components/book_detail_bottom_sheet.dart';
import 'package:readme_app/view/page/book_detail/book_detail_page/components/book_detail_info.dart';
import 'package:readme_app/view/page/book_detail/book_detail_page/components/book_detail_page_body.dart';
import 'package:readme_app/view/page/book_detail/book_detail_page/components/book_detail_page_cover.dart';

class BookDetailPage extends ConsumerWidget {
  BookDetailPage({required this.bookId, Key? key}) : super(key: key);
  int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BookDetailPageModel? model = ref.watch(bookDetailPageProvider(bookId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colours.app_sub_white,
            flexibleSpace: FlexibleSpaceBar(
              background: BookDetailPageCover(bookId: bookId),
            ),
            pinned: true,
            expandedHeight: 500,
            leadingWidth: 100,
            leading: Row(
              children: [
                IconButton(
                  icon: YhIcons.back,
                  onPressed: () {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeNavigationBar()));
                    if (Navigator.of(context).widget.pages.length > 1) {
                      Navigator.pop(context);
                      // Navigator.popUntil(context, ModalRoute.withName('/'));
                    } else {
                      Navigator.pushNamed(context, Move.navigationBar);
                    }
                  },
                ),
                IconButton(
                  icon: YhIcons.homeFill,
                  onPressed: () {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeNavigationBar()));
                    Navigator.pushNamed(context, Move.navigationBar);
                  },
                ),
              ],
            ),
            actions: [
              IconButton(
                  icon: YhIcons.cart,
                  onPressed: () {
                    Navigator.pushNamed(context, Move.cartPage);
                  }),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          BookDetailInfo(bookId:bookId),
                          BookDetailPageBody(bookId: bookId),
                          const Divider(
                            thickness: 2,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                model?.book.isHeart ?? false ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                size: 40,
              ),
              onPressed: () {
                // setState(() {
                //   isLiked = !isLiked;
                // });
              },
            ),
            SizedBox(width: 10),

            model?.user != null
                ?  SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    textStyle: TextStyle(color: Colors.white, fontSize: Dimens.font_sp20),
                    padding: EdgeInsets.all(5),
                  ),
                  child: const Text("바로보기"),
                  onPressed: () {
                    // TODO
                  }
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: TextStyle(color: Colors.white, fontSize: Dimens.font_sp20),
                        padding: EdgeInsets.all(5),
                      ),
                      child: const Text("장바구니"),
                      onPressed: () {
                        ref.read(cartControllerProvider).insert(bookId);
                      }
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(color: Colors.white, fontSize: Dimens.font_sp20),
                      padding: const EdgeInsets.all(5),
                    ),
                    child: const Text("구독 / 소장"),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => BookDetailBottomSheet(
                            model?.book.title ?? "",
                            model?.book.author ?? "",
                            model?.book.price ?? 0,
                            model?.book.id ?? 0,
                            model?.book.coverFile.fileUrl ?? "",)
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

