//
//  HYLuckyList.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYLuckyInfo.h"

@interface HYLuckyListReq : CQBaseRequest

@property (nonatomic, strong) NSString *actType;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *lotteryTypeCode;
@property (nonatomic, strong) NSString *lotteryStatus;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;

@end


@interface HYLuckyListResp : CQBaseResponse

@property (nonatomic, strong) NSArray *luckyList;

@end

/*
 b)	抽奖活动列表
 4. API地址： http://115.29.14.227:28080/lottery
 5. 请求参数
 参数名称	参数类型	参数说明	必填
 version	STRING	版本号	是
 actType	STRING	操作类型：findLotteries	是
 lotteryCode	STRING	抽奖活动编号	否
 lotteryTypeCode	STRING	关联抽奖类型编号	否
 lotteryStatus	int	抽奖状态：-1=所有；0=已结束；1=进行中；2=预告  （默认1)	否
 page	int	页码(默认1)	否
 pageSize	int	每页数量(默认20)	否
 6. API返回

 参数名称	参数类型	参数说明
 id	int	抽奖类型id
 lotteryCode	STRING	抽奖编号
 lotteryName	STRING	抽奖名称
 lotteryTypeCode	STRING	抽奖类型编号
 lotteryTypeName	STRING	抽奖类型名称
 lotteryRules	STRING	抽奖规则说明
 lotteryInfo	STRING	抽奖详情
 lotteryImage	STRING	抽奖图片
 lotteryValidity	int	抽奖启用与否 0:关闭 1:启用
 lotteryStatus	int	抽奖状态：0=已结束；1=进行中；2=预告
 startTime	Long	抽奖开始时间
 endTime	Long	抽奖结束时间
 lotteryTime	Long	抽奖开奖时间
*/