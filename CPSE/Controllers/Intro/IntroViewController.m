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
        
        vc1.title = NSLocalizedString(@"Brief Info", nil);
        vc2.title = NSLocalizedString(@"Scope of Exhibits", nil);
        vc3.title = NSLocalizedString(@"Contact Us", nil);
        vc4.title = NSLocalizedString(@"How to come", nil);
        
        self.viewControllers = @[vc1, vc2, vc3, vc4];
    }
    return self;
}

@end