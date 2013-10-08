//
//  CalendarViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "BaseChannelWithTabsViewController.h"
#import "CalendarViewController.h"
#import "EventListViewController.h"
#import "EventModel.h"
#import "MHTabBarController.h"

@interface CalendarViewController ()
{
    UIView *_loadingView;
    NSMutableArray *_eventList;
    MHTabBarController *_tabController;
}
@end

@implementation CalendarViewController

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(70, 0, 44, CGRectGetHeight(self.view.bounds));
    indicator.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_loadingView addSubview:indicator];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 206, CGRectGetHeight(self.view.bounds))];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = NSLocalizedString(@"Retrieving data", nil);
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [self.view addSubview:_loadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AFClient getPath:[NSString stringWithFormat:@"api.php?language_type=%@&action=eventlist", NSLocalizedString(@"language_type", nil)]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  NSMutableArray *dates = [NSMutableArray array];
                  
                  _eventList = [NSMutableArray array];
                  NSArray *array = [JSON valueForKeyPath:@"data"];
                  [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                      EventModel *event = [[EventModel alloc] initWithAttributes:obj];
                      [_eventList addObject:event];
                      
                      if ([dates indexOfObject:event.dateExpression] == NSNotFound)
                          [dates addObject:event.dateExpression];
                  }];
                  
                  // update ui
                  [_loadingView removeFromSuperview];
                  
                  _tabController = [[MHTabBarController alloc] init];
                  NSMutableArray *viewControllers = [NSMutableArray array];
                  
                  EventListViewController *vc = [[EventListViewController alloc] init];
                  vc.title = NSLocalizedString(@"All", nil);
                  vc.data = _eventList;
                  vc.ownerController = self;
                  [viewControllers addObject:vc];
                  
                  for (NSString *date in dates) {
                      vc = [[EventListViewController alloc] init];
                      vc.title = date;
                      vc.ownerController = self;
                      [viewControllers addObject:vc];
                      
                      // data
                      NSMutableArray *array = [NSMutableArray array];
                      for (EventModel *eventModel in _eventList) {
                          if ([eventModel.dateExpression isEqualToString:date])
                              [array addObject:eventModel];
                      }
                      vc.data = array;
                  }
                  
                  _tabController.viewControllers = viewControllers;
                  _tabController.view.frame = self.view.bounds;
                  [self.view addSubview:_tabController.view];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_tabController && [_tabController.viewControllers count]) {
        EventListViewController *vc = (EventListViewController *)_tabController.viewControllers[_tabController.selectedIndex];
        [vc.tableView deselectRowAtIndexPath:[vc.tableView indexPathForSelectedRow] animated:YES];
    }
}

@end