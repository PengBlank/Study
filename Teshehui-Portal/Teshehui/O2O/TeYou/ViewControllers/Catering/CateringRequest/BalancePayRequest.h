//
//  BalancePayRequest.h
//  Teshehui
//
//  Created by apple_administrator on 16/3/4.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface BalancePayRequest : CQBaseRequest
@property (nonatomic, strong) NSString *merid;
@property (nonatomic, strong) NSString *payee; //这个参数还是传商家Id
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *cardno;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *hard_Ware;
@property (nonatomic, strong) NSString *istsh;
@property (nonatomic, strong) NSString *payeename;//商家名字
@property (nonatomic, assign) double   amount;
@end
