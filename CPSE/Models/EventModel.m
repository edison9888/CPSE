//
//  EventModel.m
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "EventModel.h"

static NSDateFormatter *dateFormatter = nil;
static NSDateFormatter *timeFormatter = nil;

@implementation EventModel

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        if (nil == dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = NSLocalizedString(@"EVENT_formatter", nil);
            dateFormatter.locale = [NSLocale currentLocale];
        }
        if (nil == timeFormatter) {
            timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"hh:mm";
            timeFormatter.locale = [NSLocale currentLocale];
        }
        
        _id = [attributes[@"id"] intValue];
        _description = attributes[@"description"];
        _startTime = [[NSDate alloc] initWithTimeIntervalSince1970:[attributes[@"date_time_start"] intValue]];
        _endTime = [[NSDate alloc] initWithTimeIntervalSince1970:[attributes[@"date_time_end"] intValue]];
        
        _eventType = [attributes[@"type"] intValue];
    }
    return self;
}

- (NSString *)dateExpression {
    return [dateFormatter stringFromDate:_startTime];
}

- (NSString *)timeExpression {
    return [NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:_startTime]];
}

@end