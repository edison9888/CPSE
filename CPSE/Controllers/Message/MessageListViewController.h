//
//  NewsInfoViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"

@interface MessageListViewController : BaseChannelViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (id)initWithId:(NSUInteger)id andType:(NSString *)type;

@end