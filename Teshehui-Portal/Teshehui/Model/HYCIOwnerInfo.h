//
//  HYCIOwnerInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

/*
 "cityId": "城市标识",
 "owerName": "车主姓名",
 "plateNumber": "车牌号",
 "ownerIdNo": "车主身份证号",
 "email": "联系邮箱",
 "mobilePhone": "联系人手机号"
 */

@interface HYCIOwnerInfo : JSONModel

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *ownerIdNo;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *ownerMobilephone;
@property (nonatomic, assign) NSInteger isNewCar;

@end
