//
//  DataManager.m
//  CPSE
//
//  Created by Lei Perry on 7/8/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (DataManager *)sharedManager {
    static DataManager* _instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[DataManager alloc] init];
    });
    return _instance;
}

- (void)setCurrentAccount:(Account *)currentAccount {
    _currentAccount = currentAccount;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAccountChangeNotification object:self];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password popViewController:(UIViewController *)viewController {
    [AFClient getPath:[NSString stringWithFormat:@"api.php?action=login&username=%@&pwd=%@&type=user", username, password]
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, id JSON) {
                  if ([JSON[@"errno"] boolValue]) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:JSON[@"errmsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                  }
                  else {
                      NSDictionary *dict = JSON[@"data"];
                      [UserDefaults setValue:dict[@"username"] forKey:kUCLoginUsername];
                      [UserDefaults setValue:password forKey:kUCLoginPassword];
                      DataMgr.currentAccount = [[Account alloc] initWithAttributes:dict];
                      if (viewController)
                          [viewController.navigationController popViewControllerAnimated:YES];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

@end