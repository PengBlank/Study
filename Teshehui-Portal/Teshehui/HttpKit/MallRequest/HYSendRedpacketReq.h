//
//  HYSendRedpacketReq.h
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *119)  派送红包
 */

#import "CQBaseRequest.h"
#import "HYRedpacketInfo.h"

@interface HYSendRedpacketReq : CQBaseRequest

@property (nonatomic, assign) NSInteger total_amount;
@property (nonatomic, assign) NSInteger packet_type;
@property (nonatomic, assign) NSInteger packet_low;
@property (nonatomic, assign) NSInteger packet_high;
@property (nonatomic, assign) NSInteger packet_avg;
@property (nonatomic, assign) NSInteger luck_quantity;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *greetings;
@property (nonatomic, copy) NSString *phone_num;

@end

@interface HYSendRedpacketRep : CQBaseResponse

@property (nonatomic, strong) HYRedpacketInfo *packetInfo;

@end


/*
 total_amount	INT	现金券赠送总额
 packet_type	INT	红包类型，1-平均，2-随机 3-特令红包/手气红包
 【packet_low】	INT	红包类型为2-随机    最低金额
 【packet_high】	INT	红包类型为2-随机    最高金额
 【packet_avg】	INT	红包平均金额，如果红包为平均发放
 greetings	STRING	祝福语
 phone_num	STRING	获赠者手机号码，多个用;隔开
 【luck_quantity】	INT	红包类型为 3-特令红包/手气红包
 手气红包个数
 【type】	INT	类型，1：手机号  2：会员卡号  3：会员名，默认为手机号
*/