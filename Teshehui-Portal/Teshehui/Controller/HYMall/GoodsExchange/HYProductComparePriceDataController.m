//
//  HYProductComparePriceDataController.m
//  Teshehui
//
//  Created by Kris on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductComparePriceDataController.h"
#import "HYComparePriceRequest.h"
#import "HYComparePriceResponse.h"

@interface HYProductComparePriceDataController ()
{
    HYComparePriceRequest *_comparePriceReq;
}
@end

@implementation HYProductComparePriceDataController

- (void)dealloc
{
    [_comparePriceReq cancel];
    _comparePriceReq = nil;
}

- (void)fetchComparePriceDataWithBlock:(ComparePriceData)block
{
    //获得比价信息
    [HYLoadHubView show];
    
    _comparePriceReq = [[HYComparePriceRequest alloc] init];
    _comparePriceReq.productId = self.productId;
    
    [_comparePriceReq sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        
        //数据有错的时候也应该callback
        if ([result isKindOfClass:[HYComparePriceResponse class]])
        {
            HYComparePriceResponse *response = (HYComparePriceResponse *)result;
            if (block)
            {
                block(response.comparePriceModel);
            }
//            b_self.comparePriceModel = response.comparePriceModel;
//            b_self.hasComparePriceData = YES;
//            [b_self.tableView reloadData];
        }
   
    }];
}

@end
