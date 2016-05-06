//
//  HYMallAfterSaleDeliver.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallAfterSaleDeliver <NSObject>
@end

@interface HYMallAfterSaleDeliver : JSONModel

@property (nonatomic, copy) NSString *returnFlowDetailId;
@property (nonatomic, copy) NSString *deliveryName;
@property (nonatomic, copy) NSString *deliveryCode;
@property (nonatomic, copy) NSString *deliveryNo;
@property (nonatomic, copy) NSString *freightFee;
@property (nonatomic, copy) NSString *createTime;

@end
