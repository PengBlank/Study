//
//  HYApplyAfterSaleServiceListReq.h
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYApplyAfterSaleServiceListReq : CQBaseRequest

@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *orderCode;

@end
