//
//  DataManager.m
//  CPSE
//
//  Created by Lei Perry on 7/8/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "DataManager.h"
#import "GTMNSString+HTML.h"
#import "AccountInfoViewController.h"

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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password gotoAccountPageFrom:(UIViewController *)viewController {
    NSString *path = [NSString stringWithFormat:@"api.php?action=login&username=%@&pwd=%@&type=user", [DataManager encodeUrl:username], [DataManager encodeUrl:password]];
    [AFClient getPath:path
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
                      [UserDefaults synchronize];
                      
                      DataMgr.currentAccount = [[Account alloc] initWithAttributes:dict];
                      if (viewController) {
                          AccountInfoViewController *vc = [[AccountInfoViewController alloc] initWithAccount:DataMgr.currentAccount];
                          vc.title = @"用户中心";
                          [viewController.navigationController pushViewController:vc animated:YES];
                          
                          NSMutableArray *vcs = [NSMutableArray arrayWithArray:viewController.navigationController.viewControllers];
                          [vcs removeObjectIdenticalTo:viewController];
                          viewController.navigationController.viewControllers = vcs;
                      }
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"error: %@", [error description]);
              }];
}

- (NSString *)parseText:(NSString *)s {
    // replace <p></p>
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<p(.*?)>(.*?)<\\/p>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    s = [regex stringByReplacingMatchesInString:s
                                        options:0
                                          range:NSMakeRange(0, [s length])
                                   withTemplate:@"$2\n"];
    
    // replace <span/>
    regex = [NSRegularExpression regularExpressionWithPattern:@"<span(.*?)>(.*?)<\\/span>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    s = [regex stringByReplacingMatchesInString:s
                                        options:0
                                          range:NSMakeRange(0, [s length])
                                   withTemplate:@"$2"];
    // replace <br>, <br/>
    regex = [NSRegularExpression regularExpressionWithPattern:@"<br\\s*\\/?>"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    s = [regex stringByReplacingMatchesInString:s
                                        options:0
                                          range:NSMakeRange(0, [s length])
                                   withTemplate:@"\n"];
    
    s = [s stringByStrippingHTML];
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return s;
}

- (NSString *)normalizeHtml:(NSString *)s {
    // replace <p></p>
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<p(.*?)>(.*?)<\\/p>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    s = [regex stringByReplacingMatchesInString:s
                                        options:0
                                          range:NSMakeRange(0, [s length])
                                   withTemplate:@"$2<br/>"];
    
    // replace inline style
    regex = [NSRegularExpression regularExpressionWithPattern:@"(font-size:[^;]*;)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    s = [regex stringByReplacingMatchesInString:s
                                        options:0
                                          range:NSMakeRange(0, [s length])
                                   withTemplate:@""];
    
    // replace <div/>
    regex = [NSRegularExpression regularExpressionWithPattern:@"<div(.*?)>(.*?)<\\/div>"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    s = [regex stringByReplacingMatchesInString:s
                                        options:0
                                          range:NSMakeRange(0, [s length])
                                   withTemplate:@"$2<br/>"];

    DLog(@"html=%@", s);
    return s;
}

+ (NSString *)encodeUrl:(NSString *)url {
    if (url == nil) {
        return @"";
    }
    return  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                    (__bridge CFStringRef) url,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));

}

@end