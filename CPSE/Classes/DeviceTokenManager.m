//
//  DeviceTokenManager.m
//  CPSE
//
//  Created by Ji Jim on 9/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "DeviceTokenManager.h"
#import "DataManager.h"
#import "DeviceToken.h"

@implementation DeviceTokenManager

NSString *const STATUS_LOCAL_ADDED = @"LOCAL_ADDED";
NSString *const STATUS_SERVER_ADDED = @"SERVER_ADDED";

static NSDateFormatter *dateFormatter;
- (id)init
{
    if (self = [super init])
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
    return self;
}

-(void) dealWithDeviceToken: (NSData *)deviceTokenData{
    const unsigned *tokenBytes = [deviceTokenData bytes];
    NSString *deviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    DeviceToken *deviceToken = [self getDeviceTokenFromDB:deviceTokenString];
    if(deviceToken == nil){
        [self addDeviceTokenFromDB:deviceTokenString];
    }
    else{
        if([deviceToken.status isEqualToString:STATUS_SERVER_ADDED]){
            return;
        }
    }
    
    [self registerDeviceTokenToServer: deviceTokenString];
}

-(void) registerDeviceTokenToServer: (NSString *)deviceTokenString{
    NSString *path = [NSString stringWithFormat:@"api.php?action=saveDeviceToken&id=%@&device_type=ios", [DataManager encodeUrl:deviceTokenString]];
    [AFClient getPath:path
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      NSDictionary *dict = JSON[@"data"];
                      if([dict[@"errmsg"] rangeOfString:@"bla"].location == NSNotFound){
                          [self updateDeviceTokenFromDB:deviceTokenString];
                      }
                  }
                  else {
                      [self updateDeviceTokenFromDB:deviceTokenString];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

-(DeviceToken*) getDeviceTokenFromDB: (NSString *)deviceTokenString{
    FMResultSet *rs = [DataMgr.database executeQuery:@"SELECT * FROM DeviceToken WHERE DeviceToken=?", deviceTokenString];
    
    DeviceToken *deviceToken = nil;
    
    if ([rs next]) {
        deviceToken = [[DeviceToken alloc] init];
        deviceToken.deviceToken = [rs stringForColumn:@"DeviceToken"];
        deviceToken.status = [rs stringForColumn:@"Status"];
        deviceToken.createdTime = [dateFormatter dateFromString:[rs stringForColumn:@"createdTime"]];
        return deviceToken;
    }
    else{
        return nil;
    }
}

-(void) addDeviceTokenFromDB: (NSString *)deviceTokenString{
    [DataMgr.database executeUpdate:@"INSERT INTO DeviceToken (DeviceToken, Status, CreatedTime) VALUES(?,?,?)", deviceTokenString, STATUS_LOCAL_ADDED, [dateFormatter stringFromDate:[NSDate date]]];
}

-(void) updateDeviceTokenFromDB: (NSString *)deviceTokenString{
    [DataMgr.database executeUpdate:@"UPDATE DeviceToken SET Status=? WHERE DeviceToken=?", STATUS_SERVER_ADDED, deviceTokenString];
}

@end
