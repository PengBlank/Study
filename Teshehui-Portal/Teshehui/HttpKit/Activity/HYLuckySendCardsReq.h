//
//  HYLuckySendCardsReq.h
//  Teshehui
//
//  Created by HYZB on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *抽奖发牌
 */
#import "CQBaseRequest.h"
#import "HYLuckyCards.h"
#import "HYLuckyPrize.h"

@interface HYLuckySendCardsReq : CQBaseRequest

@property (nonatomic, strong) NSString *actType;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *lotteryTypeCode;
@property (nonatomic, assign) NSInteger cardCount;

@end

@interface HYLuckySendCardsResp : CQBaseResponse

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userCode;
@property (nonatomic, strong) NSString *takeCardTime;
@property (nonatomic, strong) NSString *currentRank;
@property (nonatomic, strong) NSString *cardRules;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *lotteryTypeCode;
@property (nonatomic, strong) HYLuckyPrize *prizes;
@property (nonatomic, strong) NSArray<HYLuckyCards> *cardsList;

@end
/*
 a)	用户抽牌
 1. API地址： http://115.29.14.227:28080/ShowHandServlet
 2. 请求参数
 参数名称	参数类型	参数说明	必填
 userId	STRING	用户id	是
 userName	STRING	用户名	是
 version	STRING	版本号	是
 actType	STRING	操作类型：getUserCard=抽牌或查询用户的牌；	是  //getAllCard=查询所有用户的牌
 howRound	int	第几轮抽奖(0为新一轮抽奖)	是
 howTime	STRING	抽第几次牌(0为新一次的抽牌)	是
 cardCount	int	抽几张牌(默认5张)	否
 ifSort	int	是否排名次 0:否；1:是；   (默认0,默认按抽牌时间排序)	否
 page	int	页码(默认1)	否
 pageCount	int	每页数量(默认20)	否
*/

/*
 userName	STRING	用户名
 userId	STRING	用户id
 userCode	STRING	用户编号
 takeCardTime	long	用户拿牌时间(时间戳)
 currentRank	int	当前排名
 cardRules	int	牌面：
 0:散牌；1:1对；2:两对；3:三条；4:顺子；5:同花；6:葫芦；7:四条；8:同花顺
 howRound	int	第几轮抽奖
 howTime	int	第几次抽的牌
 bigCardNum	int	玩家最大的牌点数
 
 cards	List	玩家手中的牌
 cards(玩家手中的牌)
 type	int	花色：0=黑桃；1=红桃；2=梅花；3=方块
 num	int	点数：0=2；1=3；2=4；3=5；4=6；5=7；6=8；7=9；8=10；9=J；10=Q；11=K；12=A
 count	int	牌序号0-51
 */