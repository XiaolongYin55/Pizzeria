import 'package:flutter/material.dart';

class CarouselAndSocialLinks extends StatefulWidget {
  final List<String> images;

  CarouselAndSocialLinks({required this.images});

  @override
  _CarouselAndSocialLinksState createState() => _CarouselAndSocialLinksState();
}

class _CarouselAndSocialLinksState extends State<CarouselAndSocialLinks> {
  late PageController _pageController;
  int _currentPage = 1; // 开始于1，是因为0是虚拟最后一页，1是实际的第一页

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.6, // 设置视口占比为0.6
    );
    _startAutoPageChange();
  }

  void _startAutoPageChange() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoPageChange();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: PageView.builder(
            itemCount: widget.images.length + 2, // +2是因为添加了虚拟的第一页和最后一页
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              if (index == 0) {
                // 从虚拟最后一页翻到真实最后一页
                Future.microtask(() => _pageController.jumpToPage(widget.images.length));
              } else if (index == widget.images.length + 1) {
                // 从虚拟第一页翻到真实第一页
                Future.microtask(() => _pageController.jumpToPage(1));
              }
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildImage(widget.images.last); // 虚拟的最后一页，显示实际最后一张图片
              } else if (index == widget.images.length + 1) {
                return _buildImage(widget.images.first); // 虚拟的第一页，显示实际第一张图片
              } else {
                return _buildImage(widget.images[index - 1]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String asset) {
    int imageIndex = widget.images.indexOf(asset);
    return Transform.scale(
      scale: imageIndex == (_currentPage - 1) ? 1 : 0.8, // 当前页全尺寸，其他页缩小
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10), // 添加水平间距
        child: Image.asset(
          asset,
          fit: BoxFit.cover, // 更改为 cover 以填满容器
        ),
      ),
    );
  }
}
