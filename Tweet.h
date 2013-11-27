//
//  Tweet.h
//  mifd
//
//  Created by 이종현 on 2013. 11. 27..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) User *user;

-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
