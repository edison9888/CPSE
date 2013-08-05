//
//  IntroViewController.m
//  CPSE
//
//  Created by Lei Perry on 8/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "IntroViewController.h"
#import "ExhibitsInfoViewController.h"
#import "ExhibitsScopeViewController.h"
#import "ContactsInfoViewController.h"
#import "TrafficInfoViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)init {
    if (self = [super init]) {
        ExhibitsInfoViewController *vc1 = [[ExhibitsInfoViewController alloc] init];
        ExhibitsScopeViewController *vc2 = [[ExhibitsScopeViewController alloc] init];
        ContactsInfoViewController *vc3 = [[ContactsInfoViewController alloc] init];
        TrafficInfoViewController *vc4 = [[TrafficInfoViewController alloc] init];
        
        vc1.title = @"基本信息";
        vc2.title = @"参展范围";
        vc3.title = @"联系方式";
        vc4.title = @"交通信息";
        
        self.viewControllers = @[vc1, vc2, vc3, vc4];
    }
    return self;
}

@end