//
//  PraiseRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "PraiseRequest.h"

@implementation PraiseRequest
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserId]
                   forKey:@"UserId"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.CommentId)]
                   forKey:@"CommentId"];

    }

    
    return newDic;
}
@end
