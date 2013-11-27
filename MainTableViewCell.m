//
//  MainTableViewCell.m
//  mifd
//
//  Created by 이종현 on 2013. 11. 20..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void)setFrame:(CGRect)frame {
    if (self.superview){
        float cellWidth = 500.0;
        //frame.origin.x = (self.superview.frame.size.width - cellWidth) / 2;
        frame.origin.x = -20;
        frame.size.width = cellWidth;
    }
    [super setFrame:frame];
}
*/
@end
