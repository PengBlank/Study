//
//  HYBatchCheckProductStockResponse.h
//  Teshehui
//
//  Created by Kris on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYBatchCheckProductStockResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *overStockedProductList;

@end

@interface HYProductStockCheck : JSONModel

@property (nonatomic, strong) NSString *stockId;
@property (nonatomic, strong) NSString *productSKUCode;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) NSInteger stock;

@end
