//
//  MainTableViewController.h
//  mifd
//
//  Created by 이종현 on 2013. 11. 20..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MainTableViewCell.h"
#import "Tweet.h"
#import "UserTweet.h"
#import "TTTAttributedLabel.h"
#import "MifdKeychainItemWrapper.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface MainTableViewController : UITableViewController <MBProgressHUDDelegate, TTTAttributedLabelDelegate, UIWebViewDelegate>
-(Boolean) isDefinedEle:(NSArray *)array :(NSInteger) tag;
-(void) expandRow:(UITapGestureRecognizer *)gr;
-(void) fetchTweets;
-(void) closeWebView;
-(NSMutableAttributedString *)getText:(Tweet *)tweet;
@property (assign, nonatomic) int curPage;
@property (assign, nonatomic) int totalPage;
@property (assign, nonatomic) int totalCount;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end
