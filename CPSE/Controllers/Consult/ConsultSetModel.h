//
//  ConsultSetModel.h
//  CPSE
//
//  Created by Lei Perry on 8/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ConsultModel.h"

@interface ConsultSetModel : NSObject

@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly) ConsultModel *question;
@property (nonatomic, readonly) NSArray *replies;

- (id)initWithId:(NSUInteger)id andAttributes:(NSDictionary *)attributes;

@end