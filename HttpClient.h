//
//  HttpClient.h
//  mifd
//
//  Created by 이종현 on 2013. 11. 26..
//  Copyright (c) 2013년 belhyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#define RANK @"http://14.63.198.222:3000/api/v1/tweets/rank"

@interface HttpClient : AFHTTPRequestOperationManager
+(HttpClient *)sharedClient;
+(void)downloadingServerImageFromUrl:(UIImageView*)imgView AndUrl:(NSString*)strUrl;
@end
