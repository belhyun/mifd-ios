//
//  UserSnsTableViewController.h
//  mifd
//
//  Created by 이종현 on 2013. 12. 12..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MifdKeychainItemWrapper.h"

@interface UserSnsTableViewController : UITableViewController<MBProgressHUDDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) MBProgressHUD *HUD;
@end
