//
//  ExhibitorViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorViewController.h"
#import "ExhibitorsByAlphabetViewController.h"
#import "ExhibitorsByAreaViewController.h"
#import "ExhibitorsByIndustryViewController.h"

@interface ExhibitorViewController ()

@end

@implementation ExhibitorViewController

- (id)init {
    if (self = [super init]) {
        ExhibitorsByAlphabetViewController *vc1 = [[ExhibitorsByAlphabetViewController alloc] init];
        ExhibitorsByIndustryViewController *vc2 = [[ExhibitorsByIndustryViewController alloc] init];
        ExhibitorsByAreaViewController *vc3 = [[ExhibitorsByAreaViewController alloc] init];
        
        vc1.title = @"按字母搜索";
        vc2.title = @"按行业搜索";
        vc3.title = @"按地区搜索";
        
        self.viewControllers = @[vc1, vc2, vc3];
    }
    return self;
}

@end