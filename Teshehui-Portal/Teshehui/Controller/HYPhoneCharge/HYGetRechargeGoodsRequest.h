//
//  HYGetRechargeGoodsRequest.h
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

/*
 //    商品类型编号（1=中国移动，2=中国联通，3=中国电信）
 typeId
 //    充值类型编号（2=话费充值 5=流量充值） 必填
 catalogId;
 //  充值话费时被充值的手机号码；充值流量时为空，表示 查询出所有的商品 选填
 mobilePhone;
 */

@interface HYGetRechargeGoodsRequest : CQBaseRequest

@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *catalogId;
@property (nonatomic, copy) NSString *mobilePhone;

@end
