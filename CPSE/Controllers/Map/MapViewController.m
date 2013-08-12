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
    VenueType _venueType;
}
@end

@implementation MapViewController

- (id)initWithVenueType:(VenueType)venueType {
    if (self = [super init]) {
        _venueType = venueType;
    }
    return self;
}

- (void)dealloc {
    _image = nil;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scrollView startWaiting];
    if (_image == nil) {
        _image = [UIImage imageNamed:@"map.jpg"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_scrollView stopWaiting];
        [_scrollView displayImage:_image];
        
        if (_venueType != VenueTypeNone) {
            CGFloat scale = _scrollView.minimumZoomScale;
            CGPoint center = CGPointZero;
            switch (_venueType) {
                case VenueType1:
                    scale = .25;
                    center = CGPointMake(1835, 1385);
                    break;
                case VenueType6:
                    scale = .65;
                    center = CGPointMake(2320, 796);
                    break;
                case VenueType2:
                    scale = .4;
                    center = CGPointMake(710, 1900);
                    break;
                case VenueType3and4:
                    scale = .4;
                    center = CGPointMake(710, 600);
                    break;
                case VenueType5:
                    scale = .85;
                    center = CGPointMake(1374, 790);
                    break;
                case VenueType7and8:
                    scale = .45;
                    center = CGPointMake(2943, 706);
                    break;
                case VenueType9:
                    scale = .45;
                    center = CGPointMake(2943, 1405);
                    break;
                case VenueTypeGroundOn2ndFloor:
                case VenueType5On2ndFloor:
                case VenueType6On2ndFloor:
                default:
                    break;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [_scrollView updateZoomScale:scale withCenter:center];
            });
        }
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