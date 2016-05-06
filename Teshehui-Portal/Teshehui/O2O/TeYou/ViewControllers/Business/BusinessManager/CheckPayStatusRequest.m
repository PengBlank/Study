//
//  CheckPayStatusRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CheckPayStatusRequest.h"

@implementation CheckPayStatusRequest
- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.OrderNo]
                   forKey:@"OrderNo"];
        
        [newDic setObject:[NSString stringWithFormat:@"%@", self.Type]
                   forKey:@"Type"];
        
    }
    
    return newDic;
}
@end
