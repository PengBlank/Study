//
//  HYHotelSKU.m
//  Teshehui
//
//  Created by Kris on 15/5/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelSKU.h"

@implementation HYHotelSKU

- (BOOL)isPrePay
{
    return (self.productTypeCode.integerValue == 3 );
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    NSDictionary *expanded = GETOBJECTFORKEY(dict, @"expandedResponse", NSDictionary);
    if (expanded)
    {
        NSMutableDictionary *fullDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [fullDict addEntriesFromDictionary:expanded];
        return [super initWithDictionary:fullDict error:err];
    }
    else
    {
        return [super initWithDictionary:dict error:err];
    }
}

@end
