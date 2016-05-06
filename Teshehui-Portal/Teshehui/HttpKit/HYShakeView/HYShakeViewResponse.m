//
//  HYShakeViewResponse.m
//  Teshehui
//
//  Created by HYZB on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeViewResponse.h"
#import "HYShakeViewModel.h"

@implementation HYShakeViewResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.shakeModel = [[HYShakeViewModel alloc] initWithDictionary:data error:nil];
    }
    return self;
}

@end
