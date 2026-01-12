import 'package:flutter/material.dart';
import 'dart:async';

class ResponsiveCarousel extends StatefulWidget {
  final List<String> imageAssets;
  final Duration autoPlayDuration;
  final bool enableAutoPlay;
  final bool showIndicators;
  final bool enableInfiniteScroll;
  final EdgeInsets margin;
  final double? aspectRatio;

  const ResponsiveCarousel({
    Key? key,
    required this.imageAssets,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.enableAutoPlay = true,
    this.showIndicators = true,
    this.enableInfiniteScroll = true,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.aspectRatio,
  }) : super(key: key);

  @override
  State<ResponsiveCarousel> createState() => _ResponsiveCarouselState();
}

class _ResponsiveCarouselState extends State<ResponsiveCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _indicatorAnimationController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.enableInfiniteScroll ? 1000 : 0,
      viewportFraction: 0.85, // Shows part of adjacent slides
    );
    
    _indicatorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.enableAutoPlay && widget.imageAssets.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (!_isUserInteracting && mounted && _pageController.hasClients) {
        _nextPage();
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  void _nextPage() {
    if (_pageController.hasClients) {
      final nextPage = widget.enableInfiniteScroll 
          ? _pageController.page!.round() + 1
          : (_currentPage + 1) % widget.imageAssets.length;
      
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  int _getActualIndex(int pageIndex) {
    if (!widget.enableInfiniteScroll) return pageIndex;
    return pageIndex % widget.imageAssets.length;
  }

  double _getCarouselHeight(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Responsive height calculation
    if (widget.aspectRatio != null) {
      return (screenWidth - widget.margin.horizontal) / widget.aspectRatio!;
    }
    
    // Adaptive height based on screen size
    if (screenWidth < 400) {
      // Small phones
      return screenHeight * 0.15;
    } else if (screenWidth < 600) {
      // Regular phones
      return screenHeight * 0.18;
    } else if (screenWidth < 900) {
      // Tablets
      return screenHeight * 0.35;
    } else {
      // Large tablets/desktop
      return screenHeight * 0.4;
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final carouselHeight = _getCarouselHeight(context);
    final borderRadius = screenWidth < 400 ? 12.0 : 16.0;

    return Container(
      margin: widget.margin,
      child: Column(
        children: [
          // Main Carousel
          SizedBox(
            height: carouselHeight,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  _isUserInteracting = true;
                  _stopAutoPlay();
                } else if (notification is ScrollEndNotification) {
                  _isUserInteracting = false;
                  if (widget.enableAutoPlay) {
                    _startAutoPlay();
                  }
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.enableInfiniteScroll ? null : widget.imageAssets.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = _getActualIndex(index);
                  });
                  _indicatorAnimationController.forward().then((_) {
                    _indicatorAnimationController.reset();
                  });
                },
                itemBuilder: (context, index) {
                  final actualIndex = _getActualIndex(index);
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                      }
                      
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          // margin: EdgeInsets.symmetric(
                          //   horizontal: screenWidth < 400 ? 2.0 : 4.0,
                          //   vertical: 8.0,
                          // ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Image with loading and error handling
                                _buildCarouselImage(
                                  widget.imageAssets[actualIndex],
                                  actualIndex,
                                ),
                                // Gradient overlay for better text readability
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                                // Optional slide counter
                                // if (widget.imageAssets.length > 1)
                                //   Positioned(
                                //     top: 12,
                                //     right: 12,
                                //     child: Container(
                                //       padding: const EdgeInsets.symmetric(
                                //         horizontal: 8,
                                //         vertical: 4,
                                //       ),
                                //       decoration: BoxDecoration(
                                //         color: Colors.black.withOpacity(0.6),
                                //         borderRadius: BorderRadius.circular(12),
                                //       ),
                                //       child: Text(
                                //         '${actualIndex + 1}/${widget.imageAssets.length}',
                                //         style: const TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w500,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          // Indicators
          if (widget.showIndicators && widget.imageAssets.length > 1) ...[
            SizedBox(height: screenWidth < 400 ? 12 : 16),
            _buildIndicators(context, screenWidth),
          ],
        ],
      ),
    );
  }

  Widget _buildCarouselImage(String imageUrl, int index) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return Container(
          color: Colors.grey[100],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Image not available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndicators(BuildContext context, double screenWidth) {
    final indicatorSize = screenWidth < 400 ? 6.0 : 8.0;
    final activeIndicatorWidth = screenWidth < 400 ? 24.0 : 32.0;
    
    return AnimatedBuilder(
      animation: _indicatorAnimationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageAssets.length,
            (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: indicatorSize,
                width: isActive ? activeIndicatorWidth : indicatorSize,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(indicatorSize / 2),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}