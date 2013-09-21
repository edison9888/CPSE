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

@synthesize database = _database;

+ (DataManager *)sharedManager {
    static DataManager* _instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[DataManager alloc] init];
    });
    return _instance;
}

+ (void)initialize {
    // database path
    NSString *appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [appDirectory stringByAppendingPathComponent: @"db.sqlite"];
	
    // copy to document if not exist
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"db.sqlite" ofType:nil];
        DLog(@"bundle db file: %@", file);
        NSError *error;
        if (![fileManager copyItemAtPath:file toPath:path error:&error])
            DLog(@"Error copying database to document: %@", [error description]);
    }
}

- (FMDatabase *)database {
    if (_database == nil) {
        NSString *appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [appDirectory stringByAppendingPathComponent: @"db.sqlite"];
        _database = [FMDatabase databaseWithPath:path];
        [_database open];
    }
    return _database;
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
                      
                      [self updateAccountInfo:dict];
                      
                      
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

- (void)updateAccountInfo:(NSDictionary *)dict {
    // get card # from qc_url
    NSURL *url = [NSURL URLWithString:dict[@"qc_url"]];
    NSString *webData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{8})<"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:webData options:0 range:NSMakeRange(0, [webData length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *cardNo = [webData substringWithRange:NSMakeRange(rangeOfFirstMatch.location, rangeOfFirstMatch.length-1)];
        DataMgr.currentAccount.cardNumber = cardNo;
    }
    
    // get QR code image url
    regex = [NSRegularExpression regularExpressionWithPattern:@"src=([^\\s]+)\\s{1}height="
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    rangeOfFirstMatch = [regex rangeOfFirstMatchInString:webData options:0 range:NSMakeRange(0, [webData length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *url = [webData substringWithRange:NSMakeRange(rangeOfFirstMatch.location+4, rangeOfFirstMatch.length-12)];
        DLog(@"url=%@", url);
        DataMgr.currentAccount.qrCodeImageUrl = url;
    }
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