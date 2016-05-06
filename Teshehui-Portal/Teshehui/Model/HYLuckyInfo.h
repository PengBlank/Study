//
//  HYLuckyInfo.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYLuckyInfo : JSONModel

@property (nonatomic, copy) NSString* luckyID;
@property (nonatomic, copy) NSString* lotteryCode;
@property (nonatomic, copy) NSString* lotteryName;
@property (nonatomic, copy) NSString* lotteryTypeCode;
@property (nonatomic, copy) NSString* lotteryTypeName;
@property (nonatomic, copy) NSString* lotteryRules;
@property (nonatomic, copy) NSString* lotteryInfo;
@property (nonatomic, copy) NSString* lotteryDisclaimer;
@property (nonatomic, copy) NSString* lotteryImage;
@property (nonatomic, copy) NSString* lotteryValidity;
@property (nonatomic, copy) NSString* lotteryStatus;
@property (nonatomic, copy) NSString* startTime;
@property (nonatomic, copy) NSString* endTime;
@property (nonatomic, copy) NSString* lotteryTime;

@end


/*
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