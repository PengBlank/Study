//
//  HYAfterSaleAddDeliveryRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/15.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
/**
 *  退换货 添加物流信息 退换货列表 退换货详情
 */
@interface HYAfterSaleAddDeliveryRequest : CQBaseRequest

@property (nonatomic, strong) NSString *returnFlowDetailId;
@property (nonatomic, strong) NSString *deliveryName;
@property (nonatomic, strong) NSString *deliveryCode;
@property (nonatomic, strong) NSString *deliveryNo;
@property (nonatomic, strong) NSString *freightFee;

@end




// /** 下单人id */
//Long userId;
//
///** 退换货单据详情ID */
//Long returnFlowDetailId;
//
///** 物流公司名称 */
//String deliveryName;
//
///** 物流公司编码 */
//String deliveryCode;
//
///** 物流单号　*/
//String deliveryNo;
//
///** 运费 */
//Double freightFee;

