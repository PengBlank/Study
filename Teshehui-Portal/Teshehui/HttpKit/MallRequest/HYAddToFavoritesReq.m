//
//  HYAddToFavoritesReq.m
//  Teshehui
//
//  Created by Kris on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAddToFavoritesReq.h"
#import "HYAddToFavoritesResponse.h"
#import "JSONKit_HY.h"
#import "HYMallCartShopInfo.h"

@implementation HYAddToFavoritesReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"collect/addUserCollectBatch.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.products.count > 0)
        {
            //取出所有的productSKUId和productCode
            NSMutableArray *collectProductSKUList = [NSMutableArray array];
            
            for (NSInteger i = 0; i < self.products.count; ++i)
            {
                HYMallCartShopInfo *model = self.products[i];
                NSArray *goodsArr = model.goods;
                for (NSInteger j = 0; j < goodsArr.count; j++)
                {
                    NSMutableDictionary *idDict = [NSMutableDictionary dictionary];
                    HYMallCartProduct *model = goodsArr[j];
                    [idDict setObject:model.productSKUId forKey:@"productSKUCode"];
                    [idDict setObject:model.productId forKey:@"productCode"];
                    [collectProductSKUList addObject:idDict];
                }
            }
            NSDictionary *dict = @{@"userId":self.userId,
                                   @"collectProductSKUList":collectProductSKUList};
          
            if ([dict JSONString].length > 0)
            {
                [newDic setObject:[dict JSONString] forKey:@"data"];
            }
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAddToFavoritesResponse *respose = [[HYAddToFavoritesResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
