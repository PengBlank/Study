//
//  CheckUserCommentRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/14.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CheckUserCommentRequest.h"

@implementation CheckUserCommentRequest

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.MerId]
                   forKey:@"MerId"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserId]
                   forKey:@"UserId"];
  
    }
    
    return newDic;
}

@end
