//
//  CommentListRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CommentListRequest.h"

@implementation CommentListRequest

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {

        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserId]
                       forKey:@"UserId"];

        [newDic setObject:[NSString stringWithFormat:@"%@", self.MerId]
                       forKey:@"MerId"];
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.Type)]
                   forKey:@"Type"];
       
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.PageIndex)]
                   forKey:@"pageIndex"];
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.PageSize)]
                   forKey:@"pageSize"];
    }
    
    return newDic;
}

@end
