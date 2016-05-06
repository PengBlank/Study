//
//  HYMallSearchGoodResponse.m
//  Teshehui
//
//  Created by HYZB on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallSearchGoodResponse.h"

@implementation HYMallSearchGoodResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        //商品
        NSDictionary *goodsData = GETOBJECTFORKEY(data, @"pagePO", NSDictionary);
        NSArray *goods = GETOBJECTFORKEY(goodsData, @"items", NSArray);
        
        self.totalCount = [[goodsData objectForKey:@"totalCount"] integerValue];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in goods)
        {
            HYProductListSummary *GoodListInfo = [[HYProductListSummary alloc] initWithJsonData:obj];
            [muArray addObject:GoodListInfo];
        }
        
        self.searchGoodArray = [muArray copy];
        
        //子类
        NSArray *sub = GETOBJECTFORKEY(data, @"productCategoryArray", NSArray);
        self.subCategroy = [HYMallCategoryInfo arrayOfModelsFromDictionaries:sub];
        
        //当前选中的sku
        NSArray *curCategoryJson = GETOBJECTFORKEY(data, @"selectedCategoryArray", NSArray);
        NSArray *curCategoryArray = [HYMallCategoryInfo arrayOfModelsFromDictionaries:curCategoryJson];
        self.curCategroy = [curCategoryArray lastObject];
        
        if ([curCategoryArray count] > 1)
        {
            self.parentCategroy = [curCategoryArray objectAtIndex:curCategoryArray.count-2];
        }
        
        //筛选价格的范围
        NSDictionary *priceRangDic = GETOBJECTFORKEY(data, @"priceAttribute", NSDictionary);
        NSArray *priceArr = GETOBJECTFORKEY(priceRangDic, @"productAttibuteArray", NSArray);
        if ([priceArr count])
        {
            self.priceRangDesc = priceArr[0];
        }
        
        NSDictionary *brandInfo = GETOBJECTFORKEY(data, @"brandAttribute", NSDictionary);

        self.brandInfo = [[HYBrandSummary alloc ] initWithDictionary:brandInfo
                                                               error:nil];
        
        //brand stroy
        NSDictionary *brandBo = GETOBJECTFORKEY(data, @"brandBo", [NSDictionary class]);
        self.brandBo = [[HYMallBrandStory alloc]initWithDictionary:brandBo
                                                             error:nil];
    }
    
    return self;
}

@end
