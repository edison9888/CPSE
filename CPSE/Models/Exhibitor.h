//
//  Exhibitor.h
//  CPSE
//
//  Created by Lei Perry on 9/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Exhibitor : NSObject

@property (readonly) NSString *logo;
@property (readonly) NSString *name;
@property (readonly) NSString *product;
@property (readonly) NSString *area;
@property (readonly) NSString *location;
@property (readonly) NSString *email;
@property (readonly) NSString *phone;
@property (readonly) NSString *address;

@property (readonly) NSString *description;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end