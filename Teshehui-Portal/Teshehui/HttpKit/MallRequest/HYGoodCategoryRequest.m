//
//  HYGoodCategoryRequest.m
//  Teshehui
//
//  Created by RayXiang on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodCategoryRequest.h"

@implementation HYGoodCategoryRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"category/queryCategory.action"];
        self.httpMethod = @"GET";  //需要缓存
//        self.num_per_page = 10;
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.page]
//                   forKey:@"page"];
//        [newDic setObject:[NSString stringWithFormat:@"%d", self.num_per_page]
//                   forKey:@"num_per_page"];
        if (self.businessType)
        {
            [newDic setObject:self.businessType
                       forKey:@"businessType"];
        }
        if (_category_id.length > 0)
        {
            [newDic setObject:_category_id forKey:@"categoryId"];
        }
        
        [newDic setObject:@(_level) forKey:@"level"];
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGoodCategoryResponse *respose = [[HYGoodCategoryResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
