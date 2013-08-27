//
//  HomeViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/13/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"
#import "BannerViewController.h"

@interface HomeViewController : BaseChannelViewController <BannerViewControllerDelegate>

+ (HomeViewController *)sharedHome;

@end