//
//  HYGetPayNORequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 获取支付的银行流水号
 */
#import "CQBaseRequest.h"
#import "HYGetPayNOResponse.h"

@interface HYGetPayNORequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *orderId;  //订单id
@property (nonatomic, copy) NSString *orderCode;  //支付方式
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *walletAmount;
@property (nonatomic, copy) NSString *orderAmount;

@end


/*
 {"userId":"16665","userName":"李帅军","orderId":"734","orderCode":"M665CMGS06193625","walletAmount":"0","channelCode":"ZGYLMALLIPHONE","notifyUrl":"www.baidu.com","returnUrl":""}
*/