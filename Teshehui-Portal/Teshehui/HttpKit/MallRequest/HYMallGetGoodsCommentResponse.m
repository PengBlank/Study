//
//  HYMallGetGoodsCommentResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGetGoodsCommentResponse.h"
#import "HYMallGoodCommentInfo.h"

@implementation HYMallGetGoodsCommentResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *result = [dic objectForKey:@"items"];
        
        self.commentTotal = [GETOBJECTFORKEY(dic, @"totalCount", NSString) integerValue];
        
        self.commentArray = [HYMallGoodCommentInfo arrayOfModelsFromDictionaries:result];
    }
    
    return self;
}


@end
