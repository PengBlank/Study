//
//  HYFlightRTRules.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 退改签的对象
 */

#import "CQBaseRequest.h"
#import "CQResponseResolve.h"

@interface HYFlightRTRules : CQBaseRequest<CQResponseResolve>

@property (nonatomic, copy) NSString *Airline;
@property (nonatomic, copy) NSString *Cabin;
@property (nonatomic, copy) NSString *ChangeSdate;
@property (nonatomic, copy) NSString *ChangeEdate;
@property (nonatomic, copy) NSString *RefundSdate;
@property (nonatomic, copy) NSString *RefundEdate;
@property (nonatomic, copy) NSString *Change;
@property (nonatomic, copy) NSString *Refund;
@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, readonly, assign) CGFloat changeHeight;
@property (nonatomic, readonly, assign) CGFloat refundHeight;
@property (nonatomic, readonly, assign) CGFloat remarkHeight;
@end


/*
 Airline	STRING	航空公司二字码
 Cabin	STRING	舱位标识
 ChangeSdate DATETIME	改签开始时间
 ChangeEdate DATETIME	改签结束时间
 RefundSdate DATETIME	退票开始时间
 RefundEdate	DATETIME	退票结束时间
 Change STRING	改签说明
 Refund  STRING	退票说明
 Remark  STRING	备注
 */