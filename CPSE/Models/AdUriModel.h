//
//  AdUriModel.h
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface AdUriModel : NSObject

@property (readonly) NSString *imageUrl;
@property (readonly) AdUriType uriType;
@property (readonly) NSString *linkUrl;
@property (readonly) NSString *linkId;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end