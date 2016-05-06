//
//  GetOrderListRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "GetOrderListRequest.h"

@implementation GetOrderListRequest
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.UserId]
                   forKey:@"UserId"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.PageSize)]
                   forKey:@"PageSize"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.PageIndex)]
                   forKey:@"PageIndex"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.Status)]
                   forKey:@"Status"];
        
        
    }
    
    return newDic;
}
@end
