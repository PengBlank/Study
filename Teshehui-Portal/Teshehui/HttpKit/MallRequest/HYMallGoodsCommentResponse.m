//
//  HYMallGoodsCommendResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodsCommentResponse.h"

@implementation HYMallGoodsCommentResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSNumber *result = GETOBJECTFORKEY(data, @"result", [NSNumber class]);
        self.result = [result boolValue];
    }
    
    return self;
}

@end
