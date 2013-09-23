//
//  BaseChannelViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ZXingWidgetController.h"

@interface BaseChannelViewController : UIViewController <ZXingDelegate>

- (void)tapLeftBarButton;
- (void)tapRightBarButton;

@end