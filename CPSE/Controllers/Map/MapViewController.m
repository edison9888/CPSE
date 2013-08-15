//
//  MapViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/6/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "MapViewController.h"
#import "UIColor+BR.h"
#import "UIView+JMNoise.h"
#import "PZPhotoView.h"

@interface MapViewController () <PZPhotoViewDelegate>
{
    PZPhotoView *_scrollView;
    NSString *_imageFile;
}
@end

@implementation MapViewController

- (id)initWithMapFile:(NSString *)imageFile {
    if (self = [super init]) {
        _imageFile = imageFile;
    }
    return self;
}

- (void)dealloc {
    _scrollView = nil;
}

- (void)loadView {
    self.view = _scrollView = [[PZPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.photoViewDelegate = self;
    self.view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view applyNoiseWithOpacity:.05];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView startWaiting];

    __block UIImage *image = [UIImage imageNamed:_imageFile];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_scrollView stopWaiting];
        [_scrollView displayImage:image];
    });
}

#pragma mark - PZPhotoViewDelegate
- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
    // toggle full screen
    if (self.navigationController.navigationBar.alpha == 0.0) {
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            self.navigationController.navigationBar.alpha = 1.0;
            self.navigationController.toolbar.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            self.navigationController.navigationBar.alpha = 0.0;
            self.navigationController.toolbar.alpha = 0.0;
            [_scrollView setFrame:[UIScreen mainScreen].bounds];
            [_scrollView.superview setFrame:[UIScreen mainScreen].bounds];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView {
}

- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView {
}

- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView {
}

#pragma mark - rotation control
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end