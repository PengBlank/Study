//
//  HYMallConfirmReceipt.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 确认收货
 */
#import "CQBaseRequest.h"
#import "HYMallConfirmReceiptResponse.h"

@interface HYMallConfirmReceipt : CQBaseRequest

@property(nonatomic, copy) NSString* order_id;

@end
