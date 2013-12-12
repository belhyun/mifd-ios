//
//  AppDelegate.m
//  mifd
//
//  Created by 이종현 on 2013. 11. 19..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"mainStoryBoard" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getTwitterAccountOnCompletion:(void (^)(ACAccount *))completionHandler {
    ACAccountStore *account = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if(granted == YES){
            NSArray *twitterAccounts = [account accountsWithAccountType:accountType];
            if(twitterAccounts == nil || [twitterAccounts count] == 0){
            }else{
                ACAccount *twitterAccount = [twitterAccounts objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setInteger:SocialAccountTypeTwitter forKey:@"user account"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                completionHandler(twitterAccount);
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}

@end
