//
//  HYBatchCheckProductStockReq.h
//  Teshehui
//
//  Created by Kris on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYBatchCheckProductStockReq : CQBaseRequest

@property (nonatomic, copy) NSArray *products;

@end
