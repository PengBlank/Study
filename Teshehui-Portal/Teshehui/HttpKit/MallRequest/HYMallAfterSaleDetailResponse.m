//
//  HYMallAfterSaleDetailResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallAfterSaleDetailResponse.h"

@implementation HYMallAfterSaleDetailResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if (data != nil)
        {
            HYMallAfterSaleInfo *returnInfo = [[HYMallAfterSaleInfo alloc] initWithDictionary:data error:nil];
            self.afterSaleInfo = returnInfo;
        }
    }
    
    return self;
}

@end
