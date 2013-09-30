//
//  WelcomeViewController.m
//  CPSE
//
//  Created by Lei Perry on 9/4/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation WelcomeViewController

- (void)loadView {
    [super loadView];
 
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(320*4, CGRectGetHeight(rect));
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, 320, 44)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 4;
    [self.view addSubview:_pageControl];
    
    for (int i=1; i<=4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*(i-1), 0, 320, CGRectGetHeight(self.view.bounds))];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome-%d-%d", i, (int)CGRectGetHeight(rect)]];
        [_scrollView addSubview:imageView];
        
        if (i == 4) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEnter)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:gesture];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)tapToEnter {
    [UIView animateWithDuration:.75
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                     }];
}

#pragma mark - UIScrollViewDelegate
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

#pragma mark - rotation control
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end