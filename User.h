//
//  User.h
//  mifd
//
//  Created by 이종현 on 2013. 11. 27..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, retain) NSString *screenName;
@property (nonatomic, assign) NSString *uuid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image;

-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
