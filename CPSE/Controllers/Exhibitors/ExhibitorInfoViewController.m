//
//  ExhibitorInfoViewController.m
//  CPSE
//
//  Created by Lei Perry on 7/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ExhibitorInfoViewController.h"

@interface ExhibitorInfoViewController ()
{
    NSInteger _id;
}
@end

@implementation ExhibitorInfoViewController

- (id)initWithId:(NSInteger)exhibitorId {
    if (self = [super init]) {
        _id = exhibitorId;
    }
    return self;
}

@end