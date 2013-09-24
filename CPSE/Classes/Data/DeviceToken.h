//
//  DeviceToken.h
//  CPSE
//
//  Created by Ji Jim on 9/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceToken : NSObject

@property (nonatomic) int deviceTokenId;
@property (nonatomic) NSString* deviceToken;
@property (nonatomic) NSString* status;
@property (nonatomic) NSDate* createdTime;

@end
