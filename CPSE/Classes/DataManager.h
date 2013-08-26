//
//  DataManager.h
//  CPSE
//
//  Created by Lei Perry on 7/8/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Account.h"

@interface DataManager : NSObject

+ (DataManager *)sharedManager;

@property (nonatomic, strong) Account *currentAccount;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password popViewController:(UIViewController *)viewController;

- (NSString *)parseText:(NSString *)s;

+ (NSString *)encodeUrl:(NSString *)url;
@end