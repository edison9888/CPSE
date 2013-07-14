//
//  AppDelegate.m
//  CPSE
//
//  Created by Lei Perry on 7/8/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MobClick.h"
#import "UMSocial.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:kUMengAppKey];
    [UMSocialData setAppKey:kUMengAppKey];
    
    [self setupUserDefaults];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:[HomeViewController sharedHome]];
    UINavigationBar *navigationBar = [_navigationController navigationBar];
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UMSocialSnsService applicationDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)setupUserDefaults {
}

@end