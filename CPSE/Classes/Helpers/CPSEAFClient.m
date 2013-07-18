//
//  CPSEAFClient.m
//  CPSE
//
//  Created by Lei Perry on 7/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CPSEAFClient.h"
#import "AFJSONRequestOperation.h"

@implementation CPSEAFClient

+ (CPSEAFClient *)sharedClient {
    static CPSEAFClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CPSEAFClient alloc] initWithBaseURL:[NSURL URLWithString:StagingApiBase]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end