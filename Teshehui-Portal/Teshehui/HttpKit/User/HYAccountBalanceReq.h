//
//  HYAccountBalanceReq.h
//  Teshehui
//
//  Created by Kris on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYAccountBalanceReq : CQBaseRequest

@property (nonatomic, assign) NSInteger tradeType;
@property (nonatomic, strong) NSString *pageNo;
@property (nonatomic, strong) NSString *pageSize;

@end
