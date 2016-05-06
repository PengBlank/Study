//
//  HYLuckyCheckOtherReq.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 查看所有用户的牌
 */
#import "CQBaseRequest.h"
#import "HYLuckyStatusInfo.h"

@interface HYLuckyCheckOtherReq : CQBaseRequest

@property (nonatomic, strong) NSString *actType;
@property (nonatomic, strong) NSString *queryAll;
@property (nonatomic, strong) NSString *queryTime;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *lotteryTypeCode;
@property (nonatomic, assign) NSInteger ifSort;
@property (nonatomic, assign) NSInteger ifLotteryRank;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;

@end

@interface HYLuckyCheckOtherResp : CQBaseResponse

@property (nonatomic, strong) NSArray *items;

@end

/*
 16. API地址： http://115.29.14.227:28080/showHand
 17. 请求参数
 
 参数名称	参数类型	参数说明	必填
 version	STRING	版本号	是
 actType	STRING	操作类型：getUserCards	是
 userId	STRING	操作类型：getUserCards	是
 lotteryCode	STRING	抽奖活动编号  （返回对应抽奖的内容）	二选一
 lotteryTypeCode	STRING	抽奖类型编号  （返回该抽奖类型最新抽奖的内容）
 ifSort	int	是否排名次 0:否；1:是；   (默认0,默认按抽牌时间排序)	否
 page	int	页码(默认1)	否
 pageCount	int	每页数量(默认20)	否
 
 新增queryAll参数，值为0或1，0为查所有用户抽的牌信息（瞄瞄别人），1为查当前登陆用户抽的牌
 新增queryTime参数，当前时间戳（毫秒数） ，瞄瞄别人时需要，解决翻页偶尔出现重复记录问题
*/