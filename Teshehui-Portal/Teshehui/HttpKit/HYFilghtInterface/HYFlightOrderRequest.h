//
//  HYFlightOrderRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 机票预定接口
 */

#import "CQBaseRequest.h"
#import "HYFlightOrderResponse.h"
#import "HYFlightSKU.h"
#import "HYFlightDetailInfo.h"

@interface HYFlightOrderRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *user_id;  //商城用户ID
//@property (nonatomic, copy) NSString *tel;  //联系人电话
//@property (nonatomic, copy) NSString *passengers;  //乘机人姓名  "张三|李四|王二麻子"
//@property (nonatomic, copy) NSString *passenger_id_cards;  //乘机人身份证号  "360702198908190424|360702198908190425|360702198908190427"
//@property (nonatomic, copy) NSString *cabin_code;  //舱位号
//@property (nonatomic, copy) NSString *flight_no;  //航班号
//@property (nonatomic, copy) NSString *org_airport;  //出发机场三字码
//@property (nonatomic, copy) NSString *dst_airport;  //到达机场三字码
//@property (nonatomic, copy) NSString *date;  //出发日期  时间戳

//可选字段
//@property (nonatomic, copy) NSString *pass_type;  //证件类型 “1|2|3”  默认1 具体参考商城证件类型接口
//@property (nonatomic, copy) NSString *is_children;  //乘客类型 ”0|1|0” 0成人  1儿童
//@property (nonatomic, copy) NSString *birthday;  //出生年月日 “1988-10-10|1989-11-11”
//@property (nonatomic, copy) NSString *gender;  //性别 “0|1|2” 0-未知 1-男 2-女 默认0
//@property (nonatomic, copy) NSString *country;  //国别 “1|1|2”  默认1 对应参照
//@property (nonatomic, copy) NSString *phone;  //各个乘客的联系电话 “181xxxx2005|135xxxx7497”
//@property (nonatomic, copy) NSString *email;  //联系邮箱

//@property (nonatomic, copy) NSString *jounery;  //是否打印行程单 “0|1|0”，0-不打印 1-打印  默认 0
//@property (nonatomic, copy) NSString *contact; //行程单收件联系人(如打印行程单，则必填)
//@property (nonatomic, copy) NSString *journey_tel;  //程单收件联系人电话(如打印行程单，则必填)
//@property (nonatomic, copy) NSString *province; //行程单收件省名(如打印行程单，则必填)
//@property (nonatomic, copy) NSString *city;  //行程单收件市名(如打印行程单，则必填)
//@property (nonatomic, copy) NSString *address;  //行程单收件地址详细(如打印行程单，则必填)
//@property (nonatomic, copy) NSString *zip_code;  //行程单收件地址邮编
//@property (nonatomic, assign) int cabin_level;  //航班舱位销售级别(默认0) 0特价 1普通
//@property (nonatomic, copy) NSString *is_enterprise;  //归属哪个企业用户

/**** 信用卡信息 *****/
//@property (nonatomic, copy) NSString *card_number;  //信用卡卡号：使用信用卡加密
//@property (nonatomic, copy) NSString *card_number_pre;  //卡号前六位数：使用信用卡加密
//@property (nonatomic, copy) NSString *card_type;  //信用卡卡种 对应参照
//@property (nonatomic, copy) NSString *validity; // 有效日期，yyyyMM（年4位+月2位）使用信用卡加密
//@property (nonatomic, copy) NSString *card_holder;  //持卡人：使用信用卡加密
//@property (nonatomic, copy) NSString *id_card_type;  //持卡人证件类型：默认0使用信用卡加密
//@property (nonatomic, copy) NSString *id_card_number;  //持卡人证件号：使用信用卡加密
//@property (nonatomic, copy) NSString *cvv2no;  //检查码：使用信用卡加密
//@property (nonatomic, copy) NSString *card_mobile;  //支付通协议号/手机支付手机号


//新的参数，原参数先留下等逻辑对接
//必须
@property (nonatomic, strong) NSString * userAddressId;
@property (nonatomic, strong) NSString * contactName;
@property (nonatomic, strong) NSString * contactPhone;
@property (nonatomic, strong) NSArray * guestItems;
@property (nonatomic, strong) HYFlightSKU * cabin;
@property (nonatomic, strong) HYFlightDetailInfo *flight;

//可选
@property (nonatomic, assign) CGFloat itemTotalAmount;
@property (nonatomic, assign) CGFloat orderTbAmount;
@property (nonatomic, assign) CGFloat deliveryFee;
@property (nonatomic, assign) CGFloat discountAmount;
@property (nonatomic, strong) NSString *discountDescription;
@property (nonatomic, assign) NSInteger isNeedInvoice;
@property (nonatomic, strong) NSString *invoiceType;
@property (nonatomic, strong) NSString *invoiceTitle;
@property (nonatomic, strong) NSString *contactEmail;
@property (nonatomic, assign) BOOL isNeenJourney;
@property (nonatomic, strong) NSString *creditCardType;
@property (nonatomic, strong) NSString *creditCardNumber;
@property (nonatomic, strong) NSString *creditCardSeriesCode;
@property (nonatomic, strong) NSString *creditCardEffectiveDate;
@property (nonatomic, strong) NSString *creditCardHolderName;
@property (nonatomic, strong) NSString *creditCardHolderIDCardType;
@property (nonatomic, strong) NSString *creditCardHolderIDCardNumber;
@property (nonatomic, strong) NSString *creditCardHolderMobile;
@property (nonatomic, strong) NSString *isEnterprise;
@property (nonatomic, strong) NSString *remark;
@end
