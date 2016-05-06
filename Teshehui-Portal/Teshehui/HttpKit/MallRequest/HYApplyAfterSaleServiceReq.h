//
//  HYApplyAfterSaleServiceReq.h
//  Teshehui
//
//  Created by Kris on 15/10/14.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYApplyAfterSaleServiceReq : CQBaseRequest

@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *contactProvinceCode;
@property (nonatomic, copy) NSString *contactCityCode;
@property (nonatomic, copy) NSString *contactRegionCode;
@property (nonatomic, copy) NSString *contactPostCode;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *orderItemId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger operationType;
@property (nonatomic, copy) NSArray *thumbPicArray;

@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, copy) NSString *returnFlowCode;
@property (nonatomic, copy) NSString *delProofId;
@property (nonatomic, copy) NSString *returnFlowDetailId;

@end
