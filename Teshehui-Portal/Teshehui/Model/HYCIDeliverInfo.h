//
//  HYCarDeliverInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYCIDeliverInfo : JSONModel

@property (nonatomic, strong) NSString *deliveryDate;
@property (nonatomic, strong) NSString *addressseeName;
@property (nonatomic, strong) NSString *addressseeMobilephone;
@property (nonatomic, strong) NSString *addresseeProvince;
@property (nonatomic, strong) NSString *addresseeCity;
@property (nonatomic, strong) NSString *addresseeTown;
@property (nonatomic, strong) NSString *addresseeDetails;
@property (nonatomic, strong) NSString *insuredAddresseeDetails;

@end
