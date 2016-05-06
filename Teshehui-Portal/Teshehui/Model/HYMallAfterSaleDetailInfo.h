//
//  HYMallAfterSaleDetailInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallAfterSaleDeliver.h"
#import "HYMallAfterSaleProof.h"

@protocol HYMallAfterSaleDetailInfo <NSObject>

@end

@interface HYMallAfterSaleDetailInfo : JSONModel

@property (nonatomic, copy) NSString *returnFlowDetailId;
@property (nonatomic, copy) NSString *orderItemId;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *specifications;
@property (nonatomic, copy) NSString *thumbnailPicUrl;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusShowName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, strong) NSArray<HYMallAfterSaleDeliver> *deliverItems;
@property (nonatomic, strong) NSArray<HYMallAfterSaleProof> *proof;

//
@property (nonatomic, readonly) HYMallAfterSaleProof<Ignore> *useProof;
@property (nonatomic, readonly) HYMallAfterSaleDeliver<Ignore> *userDeliver;

@end
