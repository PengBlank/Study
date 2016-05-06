//
//  HYGetCommentResponse.m
//  Teshehui
//
//  Created by HYZB on 15/10/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetCommentResponse.h"

@implementation HYGetCommentResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *info = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(info, @"items", [NSArray class]);
        
        self.dataList = [HYGetCommentModel arrayOfModelsFromDictionaries:items];
    }
    return self;
}


@end
