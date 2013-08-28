//
//  ConsultSetModel.m
//  CPSE
//
//  Created by Lei Perry on 8/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultSetModel.h"

@implementation ConsultSetModel

- (id)initWithId:(NSUInteger)id andAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _id = id;
        _question = [[ConsultModel alloc] initWithAttributes:attributes];
        
        NSMutableArray *array = [NSMutableArray array];
        NSArray *replies = attributes[@"replay"];
        if (!isEmpty(replies) && [replies count] > 0) {
            for (NSDictionary *dict in replies) {
                ConsultModel *item = [[ConsultModel alloc] initWithAttributes:dict];
                [array addObject:item];
            }
        }
        _replies = array;
    }
    return self;
}

@end