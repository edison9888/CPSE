//
//  CalendarViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CalendarViewController.h"
#import "EventListViewController.h"
#import "EventModel.h"

@interface CalendarViewController ()
{
    UIView *_loadingView;
    NSMutableArray *_eventList;
}
@end

@implementation CalendarViewController

- (id)init {
    if (self = [super init]) {
        EventListViewController *vc1 = [[EventListViewController alloc] init];
        EventListViewController *vc2 = [[EventListViewController alloc] init];
        EventListViewController *vc3 = [[EventListViewController alloc] init];
        EventListViewController *vc4 = [[EventListViewController alloc] init];
        EventListViewController *vc5 = [[EventListViewController alloc] init];
        
        vc1.title = @"全部";
        vc2.title = @"10.2号";
        vc3.title = @"10.3号";
        vc4.title = @"10.4号";
        vc5.title = @"10.5号";
        
        self.viewControllers = @[vc1, vc2, vc3, vc4, vc5];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(70, 0, 44, 44);
    [_loadingView addSubview:indicator];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 220, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"正在努力加载数据";
    [_loadingView addSubview:label];
    [indicator startAnimating];
    [self.view addSubview:_loadingView];
    
    [AFClient getPath:@"api.php?action=eventlist"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  _eventList = [NSMutableArray array];
                  NSArray *array = [JSON valueForKeyPath:@"data"];
                  [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                      EventModel *event = [[EventModel alloc] initWithAttributes:obj];
                      [_eventList addObject:event];
                  }];
                  
                  
                  // update ui
                  [_loadingView removeFromSuperview];
                  
                  EventListViewController *vc = self.viewControllers[0];
                  vc.data = _eventList;
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

@end