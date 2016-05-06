//
//  HYLuckyStatusInfo.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYLuckyPrize.h"
#import "HYLuckyCards.h"

@interface HYLuckyStatusInfo : JSONModel

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* userRealName;
@property (nonatomic, copy) NSString* userMembershipNum;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* userCode;
@property (nonatomic, copy) NSString* takeCardTime;
@property (nonatomic, copy) NSString* currentRank;
@property (nonatomic, copy) NSString* cardRules;
@property (nonatomic, copy) NSString* lotteryCode;
@property (nonatomic, copy) NSString* lotteryTypeCode;

@property (nonatomic, strong) HYLuckyPrize* prizes;
@property (nonatomic, strong) NSArray<HYLuckyCards>* cards;

@end


/*
 userName	STRING	用户名
 userId	int	用户id
 userCode	STRING	用户编号
 takeCardTime	long	用户拿牌时间(时间戳)
 currentRank	int	当前排名
 cardRules	int	牌面：
 0:散牌；1:1对；2:两对；3:三条；4:顺子；5:同花；6:葫芦；7:四条；8:同花顺
 lotteryCode	int	抽奖活动编号
 lotteryTypeCode	int	抽奖活动类型编号
*/