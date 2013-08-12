//
//  ExhibitorListViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelViewController.h"

@interface ExhibitorListViewController : BaseChannelViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) UIViewController *owner;
@property (nonatomic, strong) UITableView *table;

- (id)initWithAction:(NSString *)action;
- (void)setData:(NSArray *)data;

@end