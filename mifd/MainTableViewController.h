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

@interface MainTableViewController : UITableViewController <MBProgressHUDDelegate>
-(Boolean) isDefinedEle:(NSArray *)array :(NSInteger) tag;
-(void) expandRow:(UITapGestureRecognizer *)gr;
-(void) fetchTweets;
-(NSMutableAttributedString *)getText:(Tweet *)tweet;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end