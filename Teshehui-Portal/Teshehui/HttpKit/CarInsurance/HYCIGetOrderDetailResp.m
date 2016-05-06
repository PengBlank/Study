//
//  HYCIGetOrderDetailResp.m
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetOrderDetailResp.h"

@implementation HYCIGetOrderDetailResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        if (data.count > 0)
        {
            self.orderInfo = [[HYCIOrderDetail alloc] initWithDictionary:data
                                                                   error:nil];
        }
    }
    
    return self;
}


@end
