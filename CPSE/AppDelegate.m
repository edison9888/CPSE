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
#import "WXApi.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:kUMengAppKey];
    [UMSocialData setAppKey:kUMengAppKey];
    [WXApi registerApp:@"wx93998aae889ae36b"];
    
    [self setupUserDefaults];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:[HomeViewController sharedHome]];
    UINavigationBar *navigationBar = [_navigationController navigationBar];
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    if ([UserDefaults boolForKey:kUCAppRunningFirstTime]) {
        [UserDefaults setBool:NO forKey:kUCAppRunningFirstTime];
        [UserDefaults synchronize];
        
        _welcomeController = [[WelcomeViewController alloc] init];
        [self.window addSubview:_welcomeController.view];
    }
    
    // auto login
    if ([UserDefaults boolForKey:kUCLoginRememberMe] && !isEmpty([UserDefaults stringForKey:kUCLoginUsername])) {
        [DataMgr loginWithUsername:[UserDefaults stringForKey:kUCLoginUsername]
                          password:[UserDefaults stringForKey:kUCLoginPassword]
               gotoAccountPageFrom:nil];
    }
    
    //notification reg
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UMSocialSnsService applicationDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)setupUserDefaults {
    NSDictionary *dict = @{kUCLoginRememberMe: @YES,
                           kUCAppRunningFirstTime: @YES};
    [UserDefaults registerDefaults:dict];
    [UserDefaults synchronize];
}

@end