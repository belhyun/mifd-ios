//
//  MifdKeychainItemWrapper.m
//  mifd
//
//  Created by 이종현 on 2013. 12. 12..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import "MifdKeychainItemWrapper.h"

@interface MifdKeychainItemWrapper ()

@end

@implementation MifdKeychainItemWrapper


+(MifdKeychainItemWrapper *)sharedClient{
    static MifdKeychainItemWrapper *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[MifdKeychainItemWrapper alloc]initWithIdentifier:@"mifd" accessGroup:nil];
        [_sharedClient setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];

    });
    return _sharedClient;
}

@end
