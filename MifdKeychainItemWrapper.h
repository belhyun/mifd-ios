//
//  MifdKeychainItemWrapper.h
//  mifd
//
//  Created by 이종현 on 2013. 12. 12..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface MifdKeychainItemWrapper : KeychainItemWrapper
+(MifdKeychainItemWrapper *)sharedClient;
@end
