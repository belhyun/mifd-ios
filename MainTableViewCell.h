//
//  MainTableViewCell.h
//  mifd
//
//  Created by 이종현 on 2013. 11. 20..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainTableViewCellDelegate <NSObject>
@end

@interface MainTableViewCell : UITableViewCell
@property int itemId;
@property (assign) id<MainTableViewCellDelegate> delegate;
@end
