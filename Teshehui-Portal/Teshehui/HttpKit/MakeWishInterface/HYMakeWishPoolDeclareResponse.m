//
//  HYMakeWishPoolDeclareResponse.m
//  Teshehui
//
//  Created by HYZB on 16/3/30.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMakeWishPoolDeclareResponse.h"

@implementation HYMakeWishPoolDeclareResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.b5m_tips = data[@"b5m_tips"];
    }
    
    return self;
}

@end
