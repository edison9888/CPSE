//
//  Account.m
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Account.h"

@implementation Account

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _id = [attributes[@"userid"] intValue];
        _name = attributes[@"username"];
        _type = attributes[@"type"];
        _email = attributes[@"email"];
        _qcUrl = attributes[@"qc_url"];
    }
    return self;
}

@end