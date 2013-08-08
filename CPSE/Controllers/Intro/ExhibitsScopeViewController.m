//
//  ExhibitsScopeViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitsScopeViewController.h"

@interface ExhibitsScopeViewController ()

@end

@implementation ExhibitsScopeViewController

- (void)loadView {
    [super loadView];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];
    
    UIImage *image = [UIImage imageNamed:@"exhibitors-areas-range"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [scrollView addSubview:imageView];
    scrollView.contentSize = image.size;
}

@end