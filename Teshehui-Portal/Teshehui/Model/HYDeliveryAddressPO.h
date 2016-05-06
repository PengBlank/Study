//
//  HYDeliveryAddressPOList.h
//  Teshehui
//
//  Created by Kris on 15/6/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
@protocol
HYDeliveryAddressPO
@end

@interface HYDeliveryAddressPO : JSONModel
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *remark;

@end

//{
//    "type":2,
//    "realName":"",
//    "mobile":"",
//    "postCode":"",
//    "address":"",
//    "remark":""
//}