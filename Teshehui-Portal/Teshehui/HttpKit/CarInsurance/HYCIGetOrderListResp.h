//
//  HYCIGetOrderListResp.h
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCIOrderDetail.h"

@interface HYCIGetOrderListResp : CQBaseResponse

@property (nonatomic, strong) NSArray *orderList;

@end
