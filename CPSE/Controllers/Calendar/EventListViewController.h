//
//  EventListViewController.h
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface EventListViewController : UITableViewController

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) UIViewController *ownerController;

@end