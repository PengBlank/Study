//
//  HYOrderReturnDetailResponse.m
//  Teshehui
//
//  Created by RayXiang on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYOrderReturnDetailResponse.h"
#import "HYMallReturnsInfo.h"

@interface HYOrderReturnDetailResponse ()
@property (nonatomic, strong) HYMallReturnsInfo *retInfo;
@end


@implementation HYOrderReturnDetailResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *returnInfo = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        HYMallReturnsInfo *retInfo = [[HYMallReturnsInfo alloc] initWithDictionary:returnInfo error:nil];
        self.retInfo = retInfo;
    }
    
    return self;
}

@end
