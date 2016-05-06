//
//  HYMyDesireDetailResponse.m
//  Teshehui
//
//  Created by HYZB on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireDetailResponse.h"
#import "HYMyDesireDetailModel.h"

@implementation HYMyDesireDetailResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.data = [[HYMyDesireDetailModel alloc] initWithDictionary:data error:nil];
    }
    return self;
}

@end
