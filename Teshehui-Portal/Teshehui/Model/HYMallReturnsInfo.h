//
//  HYMallReturnsInfo.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  退货信息
 */
#import "HYMallOrderSummary.h"

typedef enum
{
    HYRefund_MerchantVerifing  = 0, //0
    HYRefund_MerchantVerified,
    HYRefund_MerchantRefused,
    HYRefund_MerchantRecieved,
    HYRefund_MerchantResend,
    HYRefund_BuyerRecieved,
    HYRefund_BuyerSent,         //6
    HYRefund_Refunding,         //7
    HYRefund_Refunded,         //8
    HYRefund_Unkown = -1
} HYRefundStatus;

//HYRefundStatus refundStatusWithInt(NSInteger status);

@interface HYMallReturnsInfo : HYMallOrderSummary

@property (nonatomic, copy) NSString *refund_id;  //订单退/换货申请ID
@property (nonatomic, copy) NSString *return_sn;  //订单退/换货申请编号
@property (nonatomic, copy) NSString *buyer_id;  //买家ID
@property (nonatomic, copy) NSString *seller_user_name;  //卖家用户名
@property (nonatomic, assign) NSInteger refund_type;  //退换货类型 1 退货  2：换货
@property (nonatomic, copy) NSString *refund_desc;  //问题描述
@property (nonatomic, assign) int refund_status;  //退换货状态 0：待商家确认1：商家已确认2：商家拒绝3：买家已寄回商品4：卖家已重新发货5：买家已确认收货6：买家已寄出商品
@property (nonatomic, strong) NSArray  *attachments;  //凭证图片
@property (nonatomic, copy) NSString *invoice_no;
@property (nonatomic, copy) NSString *express_company;
@property (nonatomic, assign) NSTimeInterval ship_time;  //买家退换货发货时间
@property (nonatomic, copy) NSString *seller_express_company;  //卖家发货快递公司
@property (nonatomic, copy) NSString *seller_invoice_no;  //卖家发货快递单号
@property (nonatomic, copy) NSString *seller_ship_time;  //卖家发货时间
@property (nonatomic, copy) NSString *buyer_confirm_time;  //买家确认收货时间(仅换货)
@property (nonatomic, assign) NSTimeInterval created;  //退换货申请创建时间
@property (nonatomic, strong) NSString *return_to;
@property (nonatomic, strong) NSString *return_to_tel;
@property (nonatomic, strong) NSString *return_to_name;
@property (nonatomic, copy) NSString *exchange_order_id;
@property (nonatomic, copy) NSString *refund_remark;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) HYRefundStatus refundStatus;



@end
