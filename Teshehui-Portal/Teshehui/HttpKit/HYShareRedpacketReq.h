//
//  HYShareRedpacketReq.h
//  Teshehui
//
//  Created by Charse on 15/12/30.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 *  分享红包接口
 */
#import "CQBaseRequest.h"

@interface HYShareRedpacketReq : CQBaseRequest

@property (nonatomic, assign) NSInteger total_amount;
@property (nonatomic, assign) NSInteger luck_qunatity;
@property (nonatomic, assign) NSInteger packet_type;
@property (nonatomic, copy) NSString *greetings;

@end


@interface HYShareRedpacketResp : CQBaseResponse

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_url;
@property (nonatomic, copy) NSString *greetings;
@property (nonatomic, copy) NSString *red_packet_url;

@end