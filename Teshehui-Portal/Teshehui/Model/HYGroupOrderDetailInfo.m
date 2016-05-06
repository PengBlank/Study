//
//  HYGroupOrderDetailInfo.m
//  Teshehui
//
//  Created by HYZB on 2014/12/18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGroupOrderDetailInfo.h"

@implementation HYGroupOrderDetailInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.itemName = GETOBJECTFORKEY(data, @"productName", [NSString class]);
        self.itemNumber = GETOBJECTFORKEY(data, @"quantity", [NSString class]);
        self.provider = GETOBJECTFORKEY(data, @"provider", [NSString class]);
        self.originalPrice = GETOBJECTFORKEY(data, @"originalPrice", [NSString class]);
        self.discountPrice = GETOBJECTFORKEY(data, @"discountPrice", [NSString class]);
        self.itemId = GETOBJECTFORKEY(data, @"itemId", [NSString class]);
        self.itemType = GETOBJECTFORKEY(data, @"itemType", [NSString class]);
        self.catCode = GETOBJECTFORKEY(data, @"catCode", [NSString class]);
        self.brandCode = GETOBJECTFORKEY(data, @"brandCode", [NSString class]);
        self.itemDescription = GETOBJECTFORKEY(data, @"itemDescription", [NSString class]);
    }
    
    return self;
}
/*
orderItemPOList":[
{
    "productName":"潮州府砂锅粥代金券",
    "quantity":5
}
 */
@end
