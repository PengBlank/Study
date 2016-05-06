//
//  HYCommentAddOneStepResponse.m
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCommentAddOneStepResponse.h"


@implementation HYCommentAddOneStepResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(info, @"items", [NSArray class]);
        
        self.dataList = [HYCommentAddOneStepModel arrayOfModelsFromDictionaries:items];
        self.totalCount = [GETOBJECTFORKEY(info, @"totalCount", [NSString class]) integerValue];
    }
    return self;
}


@end
