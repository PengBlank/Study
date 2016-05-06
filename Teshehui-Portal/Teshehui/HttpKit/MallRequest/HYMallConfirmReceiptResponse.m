//
//  HYMallConfirmReceiptResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallConfirmReceiptResponse.h"

@implementation HYMallConfirmReceiptResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        self.confireComplte = [GETOBJECTFORKEY(dictionary, @"data", [NSString class]) boolValue];
    }
    
    return self;
}


@end
