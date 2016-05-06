//
//  BilliardsOpenTableRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 *  开台请求
 *
 */
#import "CQBaseRequest.h"

@interface BilliardsOpenTableRequest : CQBaseRequest

#pragma mark - 开台/获取球台列表
@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *btId; //球台ID
@property (nonatomic,strong) NSString *uId; //特奢汇用户ID
@property (nonatomic,strong) NSString *mobile; //特奢汇用户手机号

#pragma mark - 购买商品
@property (nonatomic,strong) NSString *goLd; //商品ID
@property (nonatomic,strong) NSString *orId; //订单ID

#pragma mark - 获取订单列表
@property (nonatomic,strong) NSString *status; //订单状态（0：未支付，1：已支付）
@property (nonatomic,strong) NSString *pageSize; //每页条数
@property (nonatomic,strong) NSString *pageIndex; //当前页码

#pragma mark - 充值卡结算
@property (nonatomic,strong) NSString *payType;//支付方式（0：充值卡支付）

@end
