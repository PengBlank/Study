//
//  CQAttractionPriceInfo.m
//  Teshehui
//
//  Created by ChengQian on 13-12-27.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQAttractionPriceInfo.h"

@implementation CQAttractionPriceInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.buyCount = 1;
        self.policyId = GETOBJECTFORKEY(data, @"policyId", [NSString class]);
        self.policyName = GETOBJECTFORKEY(data, @"policyName", [NSString class]);
        self.remark = GETOBJECTFORKEY(data, @"remark", [NSString class]);
        self.price = GETOBJECTFORKEY(data, @"price", [NSString class]);
        self.tcPrice = GETOBJECTFORKEY(data, @"tcPrice", [NSString class]);
        self.pMode = GETOBJECTFORKEY(data, @"pMode", [NSString class]);
        self.gMode = GETOBJECTFORKEY(data, @"gMode", [NSString class]);
        self.minT = GETOBJECTFORKEY(data, @"minT", [NSString class]);
        self.maxT = GETOBJECTFORKEY(data, @"maxT", [NSString class]);
        self.dpPrize = GETOBJECTFORKEY(data, @"dpPrize", [NSString class]);
        self.orderUrl = GETOBJECTFORKEY(data, @"orderUrl", [NSString class]);
        self.realName = GETOBJECTFORKEY(data, @"realName", [NSString class]);
    }
    
    return self;
}

@end
