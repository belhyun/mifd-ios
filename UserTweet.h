//
//  UserTweet.h
//  mifd
//
//  Created by 이종현 on 2013. 12. 20..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTweet : NSObject
@property (nonatomic, retain) NSString *tweetUuid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *userDesc;
@property (nonatomic, retain) NSMutableArray *userTweets;
-(NSMutableArray *)getUserTweets:(NSDictionary *)dictionary;
@end
