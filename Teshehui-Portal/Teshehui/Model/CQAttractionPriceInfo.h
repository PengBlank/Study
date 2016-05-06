//
//  CQAttractionPriceInfo.h
//  Teshehui
//
//  Created by ChengQian on 13-12-27.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface CQAttractionPriceInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *policyId;	//价格策略id
@property (nonatomic, copy) NSString *policyName	;	//价格策略名称
@property (nonatomic, copy) NSString *remark	;	//门票说明
@property (nonatomic, copy) NSString *price	;	//门市价格

@property (nonatomic, copy) NSString *tcPrice	;	//同程价格
@property (nonatomic, copy) NSString *pMode	;	//支付方式
@property (nonatomic, copy) NSString *gMode	;	//取票方式
@property (nonatomic, copy) NSString *minT	;	//最小票数
@property (nonatomic, copy) NSString *maxT	;	//最大票数
@property (nonatomic, copy) NSString *dpPrize	;	//最大可用现金券
@property (nonatomic, copy) NSString *orderUrl	;	//预订跳转
@property (nonatomic, copy) NSString *realName;	//	是否实名制

//本地数据
@property (nonatomic, assign) int buyCount;	//购买的张数  默认1

//未解析完整

/*
 sceneryList	data	+	价格搜索列表	XmlNode
 scenery	sceneryList	+	价格详情	XmlNode
 sceneryId	scenery	1	景区id	string
 policy	scenery	+	价格列表	XmlNode
 p	policy	+	价格明细	XmlNode
 policyId	p	1	价格策略id	int
 policyName	p	1	价格策略名称	string
 remark	p	1	门票说明	string
 price	p	1	门市价格	decimal	单位：元
 tcPrice	p	1	同程价格	decimal	单位：元
 pMode	p	1	支付方式	int	支付方式 0：景区现付 1：在线支付 3：其他支付
 gMode	p	1	取票方式	string
 minT	p	1	最小票数	int
 maxT	p	1	最大票数	int
 dpPrize	p	1	最大可用现金券	string	单位：元
 orderUrl	p	1	预订跳转	string
 realName	p	1	是否实名制 	int	是否支持实名制[1：是 0：否]
 useCard	scenery	1	是否使用二代身份证 	int	是否使用身份证[1：是 0：否]
 ticketId	pItem	1	门票类型Id	int
 ticketName	pItem	1	门票类型名称	string
 notice	scenery	+	购票须知列表	XmlNode
 n	notice	+	购票须知明细	XmlNode
 nType	n	1	类型	int
 nTypeName	n	1	类型名称	string
 nInfo	n	+	须知列表	XmlNode
 info	nInfo	+	须知明细	XmlNode
 nId	info	1	须知排序	int
 nName	info	1	须知名称	string
 nContent	info	1	须知内容	string
 ahead	scenery	+	提前预订列表	XmlNode
 day	ahead	1	提前预订天数	Int
 time	ahead	1	提前预订时间	String	格式:HH:mm
 */
@end
