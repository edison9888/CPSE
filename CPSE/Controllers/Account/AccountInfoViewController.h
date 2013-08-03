//
//  ExhibitorInfoViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "BaseChannelViewController.h"

@interface AccountInfoViewController : BaseChannelViewController<UIWebViewDelegate>

//- (id)initWithId:(NSInteger)exhibitorId;

- (id)initWithId:(NSInteger)userId userName:(NSString*)userName ;

@end