//
//  BannerViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/14/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BannerViewController.h"
#import "UIColor+BR.h"

@interface BannerViewController ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation BannerViewController

- (void)loadView {
    [super loadView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.center = CGPointMake(160, 130);
    [self.view addSubview:_pageControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 185)];
    v.backgroundColor = [UIColor colorWithHex:0xd03044];
    [_scrollView addSubview:v];
    
    v = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 185)];
    v.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:v];
    
    v = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 320, 185)];
    v.backgroundColor = [UIColor purpleColor];
    [_scrollView addSubview:v];
    
    v = [[UIView alloc] initWithFrame:CGRectMake(960, 0, 320, 185)];
    v.backgroundColor = [UIColor cyanColor];
    [_scrollView addSubview:v];
    
    _scrollView.contentSize = CGSizeMake(320*4, 185);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

@end