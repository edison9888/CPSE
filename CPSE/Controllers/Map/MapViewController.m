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
    UIImage *_image;
}
@end

@implementation MapViewController

- (void)dealloc {
    _image = nil;
}

- (void)loadView {
    self.view = _scrollView = [[PZPhotoView alloc] init];
    _scrollView.photoViewDelegate = self;
    self.view.backgroundColor = [UIColor colorWithHex:0xff0000];
    [self.view applyNoiseWithOpacity:.05];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scrollView startWaiting];
    if (_image == nil) {
        _image = [UIImage imageNamed:@"map.jpg"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_scrollView stopWaiting];
        [_scrollView displayImage:_image];
    });
}

#pragma mark - PZPhotoViewDelegate
- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
    // toggle full screen
    if (self.navigationController.navigationBar.alpha == 0.0) {
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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

@end