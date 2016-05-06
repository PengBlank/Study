//
//  HYTaxiCancelOrderResp.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiCancelOrderResp.h"

@implementation HYTaxiCancelResult

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation HYTaxiCancelOrderResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.cancelResult = [[HYTaxiCancelResult alloc] initWithDictionary:data error:nil];
    }
    return self;
}

@end
