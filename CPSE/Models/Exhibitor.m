//
//  Exhibitor.m
//  CPSE
//
//  Created by Lei Perry on 9/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Exhibitor.h"

@implementation Exhibitor

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _logo = attributes[@"logo"];
        _name = attributes[@"name"];
        _product = isEmpty(attributes[@"main_exhibit"]) ? @"" : attributes[@"main_exhibit"];
        _area = isEmpty(attributes[@"exhibits_area"]) ? @"" : attributes[@"exhibits_area"];
        _location = isEmpty(attributes[@"exhibitions"]) ? @"" : attributes[@"exhibitions"];
        _email = attributes[@"email"];
        _phone = attributes[@"phone"];
        _address = attributes[@"link_address"];
        
        _description = attributes[@"profile"];
    }
    return self;
}

@end