//
//  HYFlightOrderResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderResponse.h"

@implementation HYFlightOrderResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *datas = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        if (datas.count > 0)
        {
            NSDictionary *data = datas[0];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                self.filghtOrder = [[HYFlightOrder alloc] initWithDictionary:data error:nil];
            }
            
        }
    }
    
    return self;
}

@end
