import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackpink/common/sample_data.dart';

class MyImageExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyImageExample(),
    );
  }
}

class MyImageExample extends StatefulWidget {
  @override
  _MyImageExampleState createState() => _MyImageExampleState();
}

class _MyImageExampleState extends State<MyImageExample> {
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 20;

  final ScrollController _controller = ScrollController();

  List<ColorInformation> _colors = [];
  int _nextPage = 1;
  bool _loading = true;
  bool _canLoadMore = true;

  @override
  void initState() {
    _controller.addListener(_onScroll);

    _getColors();

    super.initState();
  }

  Future<void> _getColors() async {
    _loading = true;

    final newColors =
        await getColorsFromServer(page: _nextPage, limit: _itemsPerPage);

    setState(() {
      _colors.addAll(newColors);

      _nextPage++;

      if (newColors.length < _itemsPerPage) {
        _canLoadMore = false;
      }

      _loading = false;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;

    final thresholdReached =
        _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      _getColors();
    }
  }

  Future<void> _refresh() async {
    _canLoadMore = true;
    _colors.clear();
    _nextPage = 1;
    await _getColors();
  }

  Widget _buildColorItem(BuildContext context, int index) {
    return ColorItem(_colors[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colors'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: _refresh,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6,
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                _buildColorItem,
                childCount: _colors.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _canLoadMore
                ? Container(
                    padding: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ColorItem extends StatelessWidget {
  final ColorInformation colorInfo;

  const ColorItem(this.colorInfo);

  Widget _buildTag() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.black12,
      child: Text(
        colorInfo.name,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: colorInfo.color,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 3),
            blurRadius: 4,
            spreadRadius: 0,
          )
        ],
      ),
      child: _buildTag(),
    );
  }
}
