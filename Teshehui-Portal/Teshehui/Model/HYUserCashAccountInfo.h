//
//  HYUserCashAccountInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYUserCashAccountInfo : JSONModel

@property (nonatomic, copy) NSString *currencyTypeCode;   //币种
@property (nonatomic, copy) NSString *balance;            //余额
@property (nonatomic, copy) NSString *canExtractBalance;  //可提现
@property (nonatomic, copy) NSString *noExtractBalance;   //不可提现

@end
