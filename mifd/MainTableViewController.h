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
#import "TTTAttributedLabel.h"

@interface MainTableViewController : UITableViewController <MBProgressHUDDelegate, TTTAttributedLabelDelegate>
-(Boolean) isDefinedEle:(NSArray *)array :(NSInteger) tag;
-(void) expandRow:(UITapGestureRecognizer *)gr;
-(void) fetchTweets;
-(NSMutableAttributedString *)getText:(Tweet *)tweet;
@property (assign, nonatomic) int curPage;
@property (assign, nonatomic) int totalPage;
@property (assign, nonatomic) int totalCount;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end
