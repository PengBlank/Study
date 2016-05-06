//
//  HYLuckyPrizeReq.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 获取抽奖奖品
 */
#import "CQBaseRequest.h"
#import "HYLuckyPrize.h"

@interface HYLuckyPrizeReq : CQBaseRequest

@property (nonatomic, strong) NSString *actType;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;

@end


@interface HYLuckyPrizeResp : CQBaseResponse

@property (nonatomic, strong) NSArray *prizeList;

@end

/*
 c)	奖品列表查询
 7. API地址： http://115.29.14.227:28080/lottery
 8. 请求参数
 参数名称	参数类型	参数说明	必填
 version	STRING	版本号	是
 actType	STRING	操作类型：findLotteyPrizes	是
 lotteryCode	STRING	抽奖活动编号	是
 page	int	页码(默认1)	否
 pageSize	int	每页数量(默认20)	否
 9. API返回   
 Json格式：
 参数名称	参数类型	参数说明
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