//
//  EventModel.h
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface EventModel : NSObject

@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSDate *endTime;
@property (nonatomic, readonly) EventType eventType;

@property (nonatomic, readonly) NSString *dateExpression;
@property (nonatomic, readonly) NSString *timeExpression;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end