//
//  HYBatchCheckProductStockReq.m
//  Teshehui
//
//  Created by Kris on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBatchCheckProductStockReq.h"
#import "HYBatchCheckProductStockResponse.h"
#import "JSONKit_HY.h"
#import "HYMallCartShopInfo.h"

@implementation HYBatchCheckProductStockReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"productStock/batchCheckProductStock.action"];
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
                NSMutableDictionary *idDict = [NSMutableDictionary dictionary];
                HYMallCartProduct *model = self.products[i];
                [idDict setObject:model.productSKUId forKey:@"productSKUCode"];
                [idDict setObject:model.quantity forKey:@"quantity"];
                [collectProductSKUList addObject:idDict];
            }
            NSDictionary *dict = @{@"userId":self.userId,
                                   @"productSKUList":collectProductSKUList};
            
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
    HYBatchCheckProductStockResponse *respose = [[HYBatchCheckProductStockResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
