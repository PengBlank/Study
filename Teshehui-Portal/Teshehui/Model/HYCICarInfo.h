//
//  HYCarInfo.h
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYCICarInfo : JSONModel

@property (nonatomic, copy) NSString *vehicleModelName;  //品牌
@property (nonatomic, copy) NSString *vehicleId;  //品牌
@property (nonatomic, copy) NSString *engineNo;  //发动机号
@property (nonatomic, copy) NSString *seats;  //座位数
@property (nonatomic, copy) NSString *firstRegisterDate;   //注册登记日期
@property (nonatomic, strong) NSString *specialCarFlag;   //是否过户车 1为是
@property (nonatomic, strong) NSString *specialCarDate;   //非过户车为空
@property (nonatomic, copy) NSString *owner;  //车主
@property (nonatomic, copy) NSString *ownerId;  //车主身份证
@property (nonatomic, strong) NSString *vehicleFrameNo; //车架号
@property (nonatomic, strong) NSString *cityId; //车架号
@property (nonatomic, strong) NSString *licenseNo; //车牌号
@property (nonatomic, strong) NSString *noLicenseFlag;  //是否是新车 0 为新车
@property (nonatomic, strong) NSString *vehicleInvoiceNo;   //发票
@property (nonatomic, strong) NSString *vehicleInvoiceDate;


+ (HYCICarInfo *)carInfoWithInputFillTypes:(NSArray *)fillTypes;
@end
