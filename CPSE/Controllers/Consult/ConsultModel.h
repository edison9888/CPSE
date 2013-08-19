//
//  ConsultModel.h
//  CPSE
//
//  Created by Lei Perry on 8/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface ConsultModel : NSObject

@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly) NSString *user;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSString *time;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end