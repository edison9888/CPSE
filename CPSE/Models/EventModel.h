//
//  EventModel.h
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface EventModel : NSObject

@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSDate *endTime;

@property (nonatomic, readonly) NSString *dateExpression;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end