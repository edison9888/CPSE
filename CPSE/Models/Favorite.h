//
//  Favorite.h
//  CPSE
//
//  Created by Lei Perry on 9/23/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Favorite : NSObject

@property NSUInteger id;
@property NSString *title;
@property FavoriteType type;

- (id)initWithId:(NSUInteger)id title:(NSString *)title type:(FavoriteType)type;

@end