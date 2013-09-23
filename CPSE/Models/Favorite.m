//
//  Favorite.m
//  CPSE
//
//  Created by Lei Perry on 9/23/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite

- (id)initWithId:(NSUInteger)id title:(NSString *)title type:(FavoriteType)type {
    if (self = [super init]) {
        _id = id;
        _title = title;
        _type = type;
    }
    return self;
}

@end