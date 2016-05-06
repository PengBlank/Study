//
//  HYLuckyRuleReq.h
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *查看自己当前抽奖情况
 */
#import "CQBaseRequest.h"
#import "HYLuckyStatusInfo.h"

@interface HYLuckyCheckStatusReq : CQBaseRequest

@property (nonatomic, strong) NSString *actType;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *lotteryTypeCode;

@end

@interface HYLuckyCheckStatusResp : CQBaseResponse

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *lotteryCode;
@property (nonatomic, copy) NSString *lotteryTypeCode;
@property (nonatomic, copy) NSString *lotteryNumber;
@property (nonatomic, copy) NSString *usedNumber;
@property (nonatomic, copy) NSString *alertMsg;

@property (nonatomic, strong) NSArray *userCardList;

@end

/*
 10. API地址： http://115.29.14.227:28080/showHand
 11. 请求参数
 参数名称	参数类型	参数说明	必填
 userId	STRING	用户id	是
 version	STRING	版本号	是
 actType	STRING	操作类型：userLotteryRule	是
 lotteryCode	STRING	抽奖活动编号  （返回对应抽奖的内容）	二选一
 lotteryTypeCode	STRING	抽奖类型编号  （返回该抽奖类型最新抽奖的内容）
 12. API返回

 参数名称	参数类型	参数说明
 userId	int	用户id
 userCode	STRING	用户编号
 lotteryTypeCode	STRING	抽奖类型编号
 lotteryCode	STRING	抽奖编号
 lotteryNumber	int	可抽奖次数
 usedNumber	int	已抽奖次数
 userCardList	List	用户抽过的牌
 userCardList(玩家手中的牌)
 userName	STRING	用户名
 userId	int	用户id
 userCode	STRING	用户编号
 takeCardTime	long	用户拿牌时间(时间戳)
 currentRank	int	当前排名
 cardRules	int	牌面：
 0:散牌；1:1对；2:两对；3:三条；4:顺子；5:同花；6:葫芦；7:四条；8:同花顺
 lotteryCode	int	抽奖活动编号
 lotteryTypeCode	int	抽奖活动类型编号
 prizes	List	玩家当前牌面所中奖项
 cards	List	玩家手中的牌
 prizes(玩家手中的牌)
 userId	int	中奖用户id
 userCardId	int	牌面id
 lotteryCode	STRING	抽奖编号
 prizeGrade	int	奖品等级
 prizeCode	STRING	获得奖品编号
 prizeName	STRING	获得奖品名称
 prizeInfo	STRING	奖品说明
 prizeImage	STRING	奖品图片
 cards(玩家手中的牌)
 type	int	花色：0=黑桃；1=红桃；2=梅花；3=方块
 num	int	点数：0=2；1=3；2=4；3=5；4=6；5=7；6=8；7=9；8=10；9=J；10=Q；11=K；12=A
 count	int	牌序号0-51
*/