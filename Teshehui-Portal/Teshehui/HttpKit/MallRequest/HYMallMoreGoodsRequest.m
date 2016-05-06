//
//  HYMallMoreGoodsRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallMoreGoodsRequest.h"
#import "YYCache.h"

@implementation HYMallMoreGoodsRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"index/getMoreProgramContent.action"];
        self.httpMethod = @"POST";
        self.boardCode = @"08";
        self.pageSize = 6;
        
        //tag
        YYCache *cache = [[YYCache alloc] initWithName:@"interestCache"];
        NSArray *cacheTags = (NSArray *)[cache objectForKey:@"items"];
        if ([cacheTags count])
        {
            self.tags = [cacheTags componentsJoinedByString:@","];
        }
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (_pageSize > 0)
        {
            [newDic setObject:[NSString stringWithFormat:@"%d", (int)self.pageSize]
                       forKey:@"pageSize"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%d", (int)self.pageNo]
                   forKey:@"pageNo"];
        
        if (self.boardCode)
        {
            [newDic setObject:self.boardCode
                       forKey:@"boardCode"];
        }
        
        if (self.tags)
        {
            [newDic setObject:self.tags
                       forKey:@"tags"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallMoreGoodsResponse *respose = [[HYMallMoreGoodsResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
