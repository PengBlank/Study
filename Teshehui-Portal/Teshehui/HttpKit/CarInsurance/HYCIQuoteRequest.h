//
//  HYCIQuoteRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIBaseReq.h"

@interface HYCIQuoteRequest : HYCIBaseReq

@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *packageType;
@property (nonatomic, strong) NSArray *carInfoList;  //HYCICarInfoFillType 类型的数组

@end

/*
@interface HYCIQuoteParam : JSONModel

@property (nonatomic, copy) NSString *engineNo;     //发动机号
@property (nonatomic, copy) NSString *ownerName;    //车主
@property (nonatomic, copy) NSString *packageType;  //套餐类型 全面套餐：luxury    自由选择套餐：optional    经济实惠套餐：affordable
@property (nonatomic, copy) NSString *vehicleFrameNo;   //车架号 LDCA13R45B2041641
@property (nonatomic, copy) NSString *vehicleId;        //车 辆代码 XTAACD0004
@property (nonatomic, copy) NSString *firstRegisterDate;    //车辆登记日 2015-06-30
@property (nonatomic, copy) NSString *vehicleModelName; //车辆型号 :东风日产 1.6L 轩逸 自动档 2009款 XL 参考价：127800
@property (nonatomic, copy) NSString *seats;
@property (nonatomic, copy) NSString *ownerIdNo;
@property (nonatomic, copy) NSString *specialCarFlag;   //是否为过户车 0 : 1
@property (nonatomic, copy) NSString *specialCarDate;   //过户日期

@end
*/