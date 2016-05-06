//
//  HYRedpacketInfo.h
//  Teshehui
//
//  Created by HYZB on 15/1/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 红包信息
 */

#import "CQResponseResolve.h"

//typedef enum _RedpacketStatus
//{
//    Unreceive = 200,  //未领取
//    Received,  //已领取
//    Expired,  //过期
//    Empty  //领取完
//}RedpacketStatus;

typedef NS_ENUM(NSInteger,RedpacketStatus) {
    RPStatusExpired = -1,
    RPStatusUnrecivie = 0,
    RPStatusReceived = 1,
    RPStatusEmpty = 2
} ;

typedef NS_ENUM(NSInteger,RedpacketRecvStatus) {
    RPRecvUnreceive = 200,
    RPRecvReceived = 203,
    RPRecvExpired = 202,
    RPRecvEmpty = 201
};

// -1 已过期
// 0 未领取
// 1 已领取

@interface HYRedpacketInfo : NSObject<CQResponseResolve>

@property (nonatomic, assign) int rpID;
@property (nonatomic, assign) int total_amount;
@property (nonatomic, copy) NSString *code;  //查看详情使用
@property (nonatomic, copy) NSString *receive_code;  //领红包使用
@property (nonatomic, copy) NSString *greetings;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *short_title;
@property (nonatomic, assign) NSInteger isRandom;  //是否随机/平分

//@property (nonatomic, copy) NSString *expired;
@property (nonatomic, assign) NSInteger is_luck;
@property (nonatomic, assign) NSInteger luck_quantity;
@property (nonatomic, assign) NSInteger luck_quantuty_used;

@property (nonatomic, assign) RedpacketStatus status;
@property (nonatomic, assign) RedpacketRecvStatus recv_status;

@property (nonatomic, copy) NSString *luck_password;

@property (nonatomic, assign) NSInteger packet_type;
@property (nonatomic, assign) NSInteger luck_amount_used;
@property (nonatomic, strong) NSString *receive_user_name;  //
@property (nonatomic, strong) NSString *send_user_name; //发送人

@property (nonatomic, strong) NSString *phone_mob;

@property (nonatomic, assign) NSInteger receive_total_amount;   //领取人领取到的具体数值

@end


/*
 items->id	INT	红包ID
 items->total_amount	INT	红包现金券数
 items->greetings	STRING	祝福语
 items->created	STRING	红包派送时间
 items->title	STRING	长标题
 items->short_title	STRING	短标题
 items->is_luck	INT	是否是拼手气红包，1：是 0：否
 items->expired	STRING	正常，已过期
 items->luck_quantity	INT	拼手气红包总个数
 items->luck_quantuty_used	INT	已领拼手气红包个数
 total_send_quantity	INT	发出现金券红包个数
 total_send_points	INT	发出现金券总数
*/