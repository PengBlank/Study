//
//  HYMallAfterSaleInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallAfterSaleDetailInfo.h"

@interface HYMallAfterSaleInfo : JSONModel

@property (nonatomic, copy) NSString *returnFlowCode;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusShowName;
@property (nonatomic, copy) NSString *buyerId;
@property (nonatomic, copy) NSString *buyerName;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *contactProvinceCode;
@property (nonatomic, copy) NSString *contactProvinceName;
@property (nonatomic, copy) NSString *contactCityCode;
@property (nonatomic, copy) NSString *contactCityName;
@property (nonatomic, copy) NSString *contactRegionCode;
@property (nonatomic, copy) NSString *contactRegionName;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, copy) NSString *contactPostcode;
//@property (nonatomic, strong) NSString *remark;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *storeCode;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *supplierCode;
@property (nonatomic, copy) NSString *supplierName;
@property (nonatomic, copy) NSString *operationType;
@property (nonatomic, copy) NSString *operationTypeName;
@property (nonatomic, copy) NSString *receiverContactMobile;

@property (nonatomic, strong) NSArray<HYMallAfterSaleDetailInfo> *detailInfo;

//便捷方法
@property (nonatomic, strong) HYMallAfterSaleDetailInfo<Ignore> *useDetail;

@end
