//
//  HYMallFinishOrderRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallSubmitOrderResponse.h"

@interface HYMallSubmitOrderRequest : CQBaseRequest

//必须参数
//@property (nonatomic, copy) NSString* store_id;  //要结算购物车中哪家商家的商品，传一个store_id添加一个新订单，传多个店铺ID批量添加订单，例如12,13,14,15传多个store_id(goods为cart的时候)
//@property (nonatomic, copy) NSString* consignee;  //收货人
//@property (nonatomic, copy) NSString* region_id;  //最下级地址ID
//@property (nonatomic, copy) NSString* region_name;  //地址名称(如 中国	广东省	深圳  用\t制表符分隔)
//@property (nonatomic, copy) NSString* addr_id;  //
//@property (nonatomic, copy) NSString* address;  //地址详细
//@property (nonatomic, copy) NSString* zipcode;  //邮编

////可选参数
//@property (nonatomic, copy) NSString* goods;  //要结算购物车哪些商品,   可选 "cart", "groupbuy"，默认cart(结算购物车)
//@property (nonatomic, copy) NSString* spec_id;  //要结算的商品规格ID 多个用 , 隔开
//@property (nonatomic, copy) NSString* groupbuy_id;  //要结算的团购商品(goods为groupbuy的时候)
//@property (nonatomic, copy) NSString* save_address;  //是否保存收货地址 0不保存  1保存
//@property (nonatomic, strong) NSDictionary *shipping_id;  //用户选择的物流 shipping_id[store_id]
//@property (nonatomic, strong) NSDictionary *postscript;  //订单附注(用户填写) postscript[store_id]
//@property (nonatomic, copy) NSString* address_options;  //已保存的收货地址(收货地址ID)
//@property (nonatomic, copy) NSString* phone_tel;  //电话号码
//@property (nonatomic, copy) NSString* phone_mob;  //手机（和电话中必填一项）

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *itemTotalAmount;      //商品总金额
@property (nonatomic, assign) NSInteger orderTbAmount;        //订单现金券总金额
@property (nonatomic, copy) NSString *orderTotalAmount;     //订单总金额
@property (nonatomic, copy) NSString *discountAmount;       //优惠金额
@property (nonatomic, copy) NSString *discountDescription;  //优惠描述
@property (nonatomic, assign) BOOL isNeedInvoice;        //是否需要发票
@property (nonatomic, assign) NSInteger invoiceType;          //发票类型
@property (nonatomic, copy) NSString *invoiceTitle;         //发票抬头
@property (nonatomic, copy) NSString *userAddressId;        //用户收货地址编号
@property (nonatomic, assign) BOOL isCommonlyAddress;    //是否常用地址
@property (nonatomic, copy) NSString *storeOrderItemPOList; //店铺商品信息
@property (nonatomic, copy) NSString *deliveryFee;          //订单总运费
@property (nonatomic, copy) NSString *orderPayAmount;     //用于校验的促销后的价格 + 运费

/**
 * 海淘增加参数
 */
@property (nonatomic, copy) NSString *idCard;//身份证号码
@property (nonatomic, copy) NSString *realName;//真实姓名


+ (instancetype)requestWithStoreList:(NSArray *)storelist isSelectExpress:(BOOL*)isselect;

@end