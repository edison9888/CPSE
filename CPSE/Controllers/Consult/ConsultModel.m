//
//  ConsultModel.m
//  CPSE
//
//  Created by Lei Perry on 8/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultModel.h"

@implementation ConsultModel

static NSDateFormatter* refFormatter = nil;

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        if (nil == refFormatter) {
            refFormatter = [[NSDateFormatter alloc] init];
            refFormatter.dateFormat = @"yyyy-MM-dd";
            refFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        
        _id = [attributes[@"id"] intValue];
        _user = attributes[@"user_name"];
        _content = attributes[@"content"];
        
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[attributes[@"add_time"] intValue]];
        _time = [refFormatter stringFromDate:date];
    }
    return self;
}

@end