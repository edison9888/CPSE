//
//  EventModel.m
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "EventModel.h"

static NSDateFormatter* dateFormatter = nil;

@implementation EventModel

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        if (nil == dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"M.d号";
            dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        
        _id = [attributes[@"id"] intValue];
        _name = @"";
        _startTime = [[NSDate alloc] initWithTimeIntervalSince1970:[attributes[@"date_time_start"] intValue]];
        _endTime = [[NSDate alloc] initWithTimeIntervalSince1970:[attributes[@"date_time_end"] intValue]];
    }
    return self;
}

- (NSString *)dateExpression {
    return [dateFormatter stringFromDate:_startTime];
}

@end