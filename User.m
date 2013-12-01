//
//  User.m
//  mifd
//
//  Created by 이종현 on 2013. 11. 27..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "User.h"

@implementation User
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self =  [super init];
    if(self){
        self.name = [dictionary objectForKey:@"name"];
        self.screenName = [dictionary objectForKey:@"screen_name"];
        self.uuid = [dictionary objectForKey:@"uuid"];
        self.image = [dictionary objectForKey:@"image"];
    }
    return self;
}
@end
