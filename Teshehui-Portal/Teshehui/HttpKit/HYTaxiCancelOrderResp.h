//
//  HYTaxiCancelOrderResp.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYTaxiCancelResult : JSONModel

@property (nonatomic, strong) NSString *cancelResult;
@property (nonatomic, strong) NSString *cancelFee;
@property (nonatomic, strong) NSString *cancelFeeDescription;

@end

@interface HYTaxiCancelOrderResp : CQBaseResponse

@property (nonatomic, strong) HYTaxiCancelResult *cancelResult;

@end
