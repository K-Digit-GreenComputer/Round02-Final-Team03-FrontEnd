import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readme_app/view/page/book_viwer/components/book_drawer_no_membership.dart';
import '../../../../core/constants/colours.dart';
import '../../../../core/constants/hs_style_icons.dart';
import '../../../../core/constants/jh_style_icons.dart';
import '../../../../util/epub/src/helpers/epub_document.dart';
import '../../../../util/epub/src/ui/epub_view.dart';
import '../components/book_drawer.dart';

class BookViwerPage extends StatefulWidget {
  BookViwerPage({Key? key}) : super(key: key);

  @override
  _BookViwerPageState createState() => _BookViwerPageState();
}

/// 책 받아오기
class _BookViwerPageState extends State<BookViwerPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Epub demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: EpubBookContent()),
      );
}

class EpubBookContent extends StatefulWidget {
  EpubBookContent({Key? key}) : super(key: key);

  @override
  _MyEpubBook createState() => _MyEpubBook();
}

class _MyEpubBook extends State<EpubBookContent> {
  late EpubController _epubReaderController;
  bool _isBookMark = true;
  bool _membership = true;
  double _currentSliderValue = 100;
  double _fontSize = 18.0;
  bool _showAppBarAndBottomSheet = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _epubReaderController = EpubController(
      document: EpubDocument.openAsset('assets/epubs/test3.epub'),
    );
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _membership == false
          ? BookDrawerNoMembership(scaffoldKey: _scaffoldKey)
          : BookDrawer(scaffoldKey: _scaffoldKey),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showAppBarAndBottomSheet = !_showAppBarAndBottomSheet;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAppBar(), /// Appbar
            buildBookmark(), /// 북마크
            Expanded(
              // 책내용
              child: Center(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: buildEpubView()),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
            buildBottomSheet() /// BottomSheet
          ],
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Visibility(
      visible: _showAppBarAndBottomSheet,
      child: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 120,
            color: Colours.app_sub_white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 5.0, right: 5.0),
                          child: Slider(
                            thumbColor: Colours.app_main,
                            inactiveColor: Colours.app_sub_grey,
                            activeColor: Colours.app_main,
                            value: _currentSliderValue,
                            max: 100,
                            divisions: 100,
                            label: _currentSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("100%"),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: IconButton(
                              onPressed: () {
                                print("북마크 보관함으로 이동");
                              },
                              icon: JHicons.bookBox),
                        ),
                        Container(
                          child: IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState?.openEndDrawer();
                              },
                              icon: JHicons.hambuger),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Visibility buildBookmark() {
    return Visibility(
      visible: _isBookMark,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            child: JHicons.bookmark25,
          ),
        ),
      ),
    );
  }

  EpubView buildEpubView() {
    return EpubView(
      controller: _epubReaderController,
      builders: EpubViewBuilders<DefaultBuilderOptions>(
        options: DefaultBuilderOptions(
          textStyle: TextStyle(
            height: 1.25,
            fontSize: _fontSize,
            color: Colors.black87,
            fontFamily: "NanumGothic",
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Visibility(
      visible: _showAppBarAndBottomSheet,
      child: AppBar(
        backgroundColor: Colours.app_sub_white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(child: JHicons.back),
            SizedBox(),
            Container(
              child: Text(
                "스즈메의 문단속",
                style: TextStyle(
                    color: Colours.app_sub_black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
