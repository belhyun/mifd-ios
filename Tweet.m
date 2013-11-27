//
//  Tweet.m
//  mifd
//
//  Created by 이종현 on 2013. 11. 27..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self =  [super init];
    if(self){
        self.createdAt = [dictionary objectForKey:@"created_at"];
        self.text = [dictionary objectForKey:@"text"];
        self.retweetCount = [[dictionary objectForKey:@"retweet_count"] integerValue];
        self.favoriteCount = [[dictionary objectForKey:@"favorite_count"] integerValue];
        self.score = [[dictionary objectForKey:@"score"] integerValue];
        self.uuid = [dictionary objectForKey:@"uuid"];
        self.user = [[User alloc]initWithDictionary:[dictionary objectForKey:@"user"]];
    }
    return self;
}
@end
