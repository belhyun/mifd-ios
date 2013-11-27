//
//  HttpClient.m
//  mifd
//
//  Created by 이종현 on 2013. 11. 26..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient
+(HttpClient *)sharedClient{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [HttpClient manager];
    });
    return _sharedClient;
}
@end
