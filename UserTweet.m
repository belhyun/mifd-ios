//
//  UserTweet.m
//  mifd
//
//  Created by 이종현 on 2013. 12. 20..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "UserTweet.h"

@implementation UserTweet
-(NSMutableArray *) getUserTweets:(NSDictionary *)dictionary{
    for(id key in dictionary){
        UserTweet *userTweet = [[UserTweet alloc]init];
        userTweet.tweetUuid = [dictionary objectForKey:@"tweet_uuid"];
        userTweet.type = [dictionary objectForKey:@"type"];
        userTweet.userDesc = [dictionary objectForKey:@"user_desc"];
        [self.userTweets addObject:userTweet];
    }
    return self.userTweets;
}
@end
