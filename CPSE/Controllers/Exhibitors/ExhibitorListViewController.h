//
//  ExhibitorListViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"

@interface ExhibitorListViewController : BaseChannelViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithAction:(NSString *)action;

@end