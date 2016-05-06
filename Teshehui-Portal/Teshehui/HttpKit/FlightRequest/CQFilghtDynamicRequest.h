//
//  CQFilghtDynamic.h
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"

/*
 航班动态订制
 */

@interface CQFilghtDynamicRequest : CQFilghtBaseRequest

/*
 http://dynamic.bnx6688.com/DynamicBook/?UserID=80000000001&Mobile=13082658742&planDepartDt=2013-09-27&flightNo=MU5122&departCity=PEK&arriveCity=SHA
 
 UserID		会员号
 Mobile		订制手机号
 planDepartDt		起飞日期（xxxx-xx-xx）
 flightNo		航班号
 departCity		出发城市三字码
 arriveCity		到达城市三字码
 
 获取以上参数就像查询航班一样，只是列表不用那么多内容。主要显示出航班号，起飞日期和城市名称即可。
 */

//必须参数
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, copy) NSString *Mobile;
@property (nonatomic, copy) NSString *planDepartDt;
@property (nonatomic, copy) NSString *flightNo;
@property (nonatomic, copy) NSString *departCity;
@property (nonatomic, copy) NSString *arriveCity;

@end
