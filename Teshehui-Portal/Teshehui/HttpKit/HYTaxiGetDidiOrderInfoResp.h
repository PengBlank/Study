//
//  HYTaxiGetDidiOrderInfoResp.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYTaxiOrderView.h"

@interface HYTaxiGetDidiOrderInfoResp : CQBaseResponse

@property (nonatomic, strong) HYTaxiOrderView *orderView;

@end
