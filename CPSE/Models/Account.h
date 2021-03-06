//
//  Account.h
//  CPSE
//
//  Created by Lei Perry on 7/31/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Account : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSString *name;
@property (readonly) NSString *type;
@property (readonly) NSString *email;
@property (readonly) NSString *qcUrl;

@property (strong) NSString *cardNumber;
@property (strong) NSString *qrCodeImageUrl;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end