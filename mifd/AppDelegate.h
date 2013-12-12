//
//  AppDelegate.h
//  mifd
//
//  Created by 이종현 on 2013. 11. 19..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
typedef enum SocialAccountType  {
    SocialAccountTypeFacebook = 1,
    SocialAccountTypeTwitter = 2
} SocialAccountType;
@property (strong, nonatomic) UIWindow *window;
- (void)getTwitterAccountOnCompletion:(void (^)(ACAccount *))completionHandler;
@end
