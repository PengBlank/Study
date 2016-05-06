//
//  HYCheckDidiOrderResponse.m
//  Teshehui
//
//  Created by Kris on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCheckDidiOrderResponse.h"

@implementation HYCheckDidiOrderResponse

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        if (data.count > 0)
        {
            self.isOrderUnFinished = [data[0] boolValue];
        }
    }
    return self;
}

@end
