//
//  MemberCardPayRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface MemberCardPayRequest : CQBaseRequest

@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *payType; //支付方式  0代表充值卡支付
@property (nonatomic,strong) NSString *cardNo; //会员卡号
@property (nonatomic,strong) NSString *orId; //桌球城订单号

@end
