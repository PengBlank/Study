//
//  HYMallSearchGoodRequest.m
//  Teshehui
//
//  Created by HYZB on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallSearchGoodsRequest.h"
#import  "HYMallSearchGoodResponse.h"
#import "JSONKit_HY.h"
#import "NSString+Addition.h"
#import "HYUserInfo.h"

@interface HYMallSearchGoodsRequest ()

@property (nonatomic,copy) NSString *reqParam;

@end

@implementation HYMallSearchGoodsRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/searchProduct.action"];
        self.httpMethod = @"POST";
        self.pageSize = 20;
        self.pageNo = 1;
        self.businessType = @"01";
    }
    
    return self;
}

- (id)initReqWithStoreId:(NSString *)storeid;
{
    if ([self init])
    {
        self.storeId = storeid;
    }
    
    return self;
}

- (id)initReqWithCategoryId:(NSString *)categoryId
{
    if ([self init])
    {
        self.categoryId = categoryId;
    }
    
    return self;
}

- (id)initReqWithBrandIds:(NSString *)brandIds
{
    if ([self init])
    {
        if (brandIds)
        {
            self.brandIds = [NSArray arrayWithObjects:brandIds, nil];
        }
    }
    return self;
}

- (id)initReqWithParamStr:(NSString *)paramStr
{
    if ([self init])
    {
        self.reqParam = paramStr;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        //先加入reqParam参数
        if ([self.reqParam length] > 0)
        {
            NSDictionary *dic = [self.reqParam urlParamToDic];
            
            [newDic addEntriesFromDictionary:dic];
        }
        
        if (self.keyword.length > 0)
        {
            [newDic setObject:self.keyword forKey:@"keyword"];
        }
        
        if ([self.highPrice length] > 0)
        {
            [newDic setObject:self.highPrice forKey:@"highPrice"];
        }
        else
        {
            [newDic removeObjectForKey:@"highPrice"];
        }
        
        if ([self.lowPrice length] > 0)
        {
            [newDic setObject:self.lowPrice forKey:@"lowPrice"];
        }
        else
        {
            [newDic removeObjectForKey:@"lowPrice"];
        }
    
        if (self.searchType.length > 0)
        {
            [newDic setObject:self.searchType forKey:@"searchType"];
        }
        
        if (self.keywordParseType.length > 0)
        {
            [newDic setObject:self.keywordParseType
                       forKey:@"keywordParseType"];
        }
        
        if (self.orderBy.length > 0)
        {
            [newDic setObject:self.orderBy forKey:@"orderBy"];
            
            if (!self.order)
            {
                self.order = @"1";
            }
            [newDic setObject:self.order forKey:@"order"];
        }
        
        //处理扩展参数
        //成员变量参数优先
        //成员变量中的参数很有可能会在筛选中被改变
        //所以这里先判断成员变量有没有,没有时才会使用reqParams中的参数
        //会从reqParams中取的参数有: categoryId, brandId
        
        NSMutableDictionary *expand = [NSMutableDictionary dictionary];
        //如果原来的reqParam参数中有expandedRequest
        NSArray *brands = nil;
        NSString *cateId = nil;
        NSString *storeId = nil;
        if ([self.reqParam length] > 0)
        {
            NSString *expandJson = [newDic objectForKey:@"expandedRequest"];
            NSDictionary *existCondition = [expandJson objectFromJSONString];
            if ([existCondition isKindOfClass:[NSDictionary class]])
            {
                //先全量加入原来的expandedRequest
                [expand addEntriesFromDictionary:existCondition];
                //取出各参数分别处理
                brands = [existCondition objectForKey:@"brandId"];
                cateId = [existCondition objectForKey:@"categoryId"];
                storeId = [existCondition objectForKey:@"storeId"];
            }
        }
        
        if ((!self.categoryId || self.categoryId.length == 0) && cateId)
        {
            self.categoryId = cateId;
        }
        if (self.categoryId.length > 0)
        {
            [expand setObject:_categoryId forKey:@"categoryId"];
        }
        
        if (brands.count > 0)
        {
            if (!self.brandIds)
            {
                self.brandIds = [NSArray array];
            }
            self.brandIds = [self.brandIds arrayByAddingObjectsFromArray:brands];
        }
        if (self.brandIds.count > 0)
        {
            [expand setObject:_brandIds forKey:@"brandId"];
        }
        
        if (!self.storeId && storeId)
        {
            self.storeId = storeId;
        }
        if (self.storeId.length > 0)
        {
            [expand setObject:_storeId forKey:@"storeId"];
        }
        
        if (expand.allKeys.count > 0)
        {
            NSString *expanjson = [expand JSONString];
            [newDic setObject:expanjson forKey:@"expandedRequest"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNo]
                   forKey:@"pageNo"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallSearchGoodResponse *respose = [[HYMallSearchGoodResponse alloc]
                                         initWithJsonDictionary:info];
    return respose;
}

@end
