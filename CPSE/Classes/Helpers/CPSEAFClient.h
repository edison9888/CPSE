//
//  CPSEAFClient.h
//  CPSE
//
//  Created by Lei Perry on 7/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CPSEAFClient : AFHTTPClient

+ (CPSEAFClient *)sharedClient;

@end