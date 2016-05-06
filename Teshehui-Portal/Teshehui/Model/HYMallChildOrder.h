//
//  HYMallChildOrder.h
//  Teshehui
//
//  Created by Kris on 15/10/2.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallOrderItem.h"
#import "HYAddressInfo.h"

@protocol HYMallChildOrder <NSObject>

@end

@interface HYMallChildOrder : JSONModel

@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *orderShowStatus;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderTbAmount;
@property (nonatomic, copy) NSString *orderPayAmount;
@property (nonatomic, copy) NSString *orderActualAmount;
@property (nonatomic, copy) NSString *creationTime;
@property (nonatomic, assign) NSInteger status;

/**
 * 是否是海淘商品  1是 2否  (默认为 2 )
 */
@property (nonatomic, assign) NSInteger isSears;

@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSArray<HYMallOrderItem>  *orderItemPOList;
@property (nonatomic, copy) NSArray<HYMallOrderItem>  *returnOrderItemPOList;
@property (nonatomic, strong) HYAddressInfo  *deliveryAddressPO;

@property (nonatomic, assign) HYOrderGoodsEvaluationStatus isEvaluable;

@end

/*
 "storeId": "39994",
 "storeName": "xinz",
 "supplierCode": "39994",
 "supplierName": "xinz",
 "quantity": 1,
 "orderItemPOList": [
 {
 "specification": "颜色:灰色,尺码XXXL",
 "isCanApplyGuijiupei": 1,
 "guijiupeiId": 0,
 "businessType": "01",
 "orderItemId": 635,
 "productId": 48134,
 "productCode": "070400106233",
 "productName": "大闸蟹",
 "productSKUId": 327944,
 "productSKUCode": "070400106233001",
 "price": 105,
 "points": 95,
 "quantity": 1,
 "pictureBigUrl": "http://image.teshehui.com/goods/33/070400106233/070400106233001/sk1_20150001.jpg"
 }
 ],
 "orderId": 568,
 "orderCode": "M665CMET42168162_1",
 "parentOrderCode": "M665CMET42168162",
 "businessType": "01",
 "status": 10,
 "orderShowStatus": "待付款",
 "isDelete": 0,
 "buyerId": 16665,
 "buyerNick": "李帅军",
 "buyerMobile": "13803923026",
 "discountAmount": 0,
 "itemTotalAmount": 105,
 "orderTbAmount": 95,
 "orderTotalAmount": 106,
 "orderPayAmount": 106,
 "deliveryFee": 1,
 "creationTime": "2015-10-04 16:45:06",
 "updatedTime": "2015-10-04 16:45:06",
 "pointConsumptionType": 1,
 "orderType": 1

*/