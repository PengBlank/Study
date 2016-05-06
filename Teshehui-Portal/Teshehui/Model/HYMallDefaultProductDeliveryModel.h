//
//  HYMallDefaultProductDeliveryModel.h
//  Teshehui
//
//  Created by HYZB on 15/12/31.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMallDefaultProductDeliveryModel : JSONModel

@property (nonatomic, copy) NSString *deliveryId;
@property (nonatomic, copy) NSString *deliveryName;
@property (nonatomic, copy) NSString *isMajor;
@property (nonatomic, copy) NSString *deliveryFee;
@property (nonatomic, copy) NSString *isAvailable;
@property (nonatomic, copy) NSString *storeId;

/*
 "具体参数data":{
 "id":"配送方式标识",
 "deliveryName":"配送方式名称",
 "isMajor":"是否为默认配送方式：0否，1是",
 "deliveryFee":"配送方式费用",
 "isAvailable":"配送方式是否启用：0否，1是",
 "storeId":"店铺ID"
 }
 */

@end
