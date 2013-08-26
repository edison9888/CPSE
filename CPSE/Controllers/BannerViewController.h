//
//  BannerViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/14/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AdUriModel.h"

@protocol BannerViewControllerDelegate <NSObject>

- (void)clickWithAdUri:(AdUriModel *)adUri;

@end

@interface BannerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) id<BannerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;

@end