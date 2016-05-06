//
//  HYLuckyPrize.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYLuckyPrize : JSONModel

@property (nonatomic, copy) NSString* pID;
@property (nonatomic, copy) NSString* prizeCode;
@property (nonatomic, copy) NSString* lotteryCode;
@property (nonatomic, copy) NSString* prizeName;
@property (nonatomic, copy) NSString* prizeGrade;
@property (nonatomic, copy) NSString* prizePrice;
@property (nonatomic, copy) NSString* prizeQuantity;
@property (nonatomic, copy) NSString* prizeRest;
@property (nonatomic, copy) NSString* prizeInfo;
@property (nonatomic, copy) NSString* prizeImage;
@property (nonatomic, copy) NSString* prizeMsg;
@property (nonatomic, copy) NSString* prizeAlertMsg;

@end

/*
 id	int	奖品id
 prizeCode	STRING	奖品编号
 lotteryCode	STRING	所属抽奖活动
 prizeName	STRING	奖品名称
 prizeGrade	int	奖品等级
 prizeQuantity	int	奖品数量
 prizeRest	int	剩余数量
 prizeInfo	STRING	奖品说明
 prizeImage	STRING	奖品图片
 prizeMsg	STRING	中奖发送的短信模版
 prizeAlertMsg	STRING	中奖后立即显示的信息
*/