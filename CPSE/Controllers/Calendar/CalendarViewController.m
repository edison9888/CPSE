//
//  CalendarViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CalendarViewController.h"
#import "EventListViewController.h"

@interface CalendarViewController ()

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

@end