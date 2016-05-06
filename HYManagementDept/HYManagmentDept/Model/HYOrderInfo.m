//
//  HYOrderInfo.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYOrderInfo.h"

@implementation HYOrderInfo

- (id)initWithData:(NSDictionary *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        self.type     = GETOBJECTFORKEY(data, @"type", [NSString class]);
    }
    
    return self;
}

@end
