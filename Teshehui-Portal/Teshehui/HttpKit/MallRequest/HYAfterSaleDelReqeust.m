//
//  HYAfterSaleDelReqeust.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/15.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleDelReqeust.h"

@implementation HYAfterSaleDelReqeust

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/afterSeller/deleteReturnFlow.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.flowCode)
        {
            [newDic setObject:self.flowCode forKey:@"returnFlowCode"];
        }
        
    }
    
    return newDic;
}

@end
