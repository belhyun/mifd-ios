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
    self.userTweets = [[NSMutableArray alloc]init];
    for(id obj in dictionary){
        UserTweet *userTweet = [[UserTweet alloc]init];
        userTweet.tweetUuid = [obj objectForKey:@"tweet_uuid"];
        userTweet.type = [obj objectForKey:@"type"];
        userTweet.userDesc = [obj objectForKey:@"user_desc"];
        [self.userTweets addObject:userTweet];
    }
    return self.userTweets;
}
@end
