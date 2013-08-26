//
//  AdUriModel.m
//  CPSE
//
//  Created by Lei Perry on 8/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AdUriModel.h"

@implementation AdUriModel

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _imageUrl = attributes[@"img"];
        NSString *type = attributes[@"uritype"];
        if ([type isEqualToString:@"id"]) {
            _uriType = AdUriTypeExhibitorId;
            _linkId = attributes[@"url"];
        }
        else if ([type isEqualToString:@"url"]) {
            _uriType = AdUriTypeExhibitorUrl;
            _linkUrl = attributes[@"url"];
        }
    }
    return self;
}

@end