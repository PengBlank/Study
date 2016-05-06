//
//  HYMallCartShopUpdateRequest.h
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMallCartShopUpdateRequest : CQBaseRequest

@property(nonatomic, copy) NSString *productSKUId;
@property(nonatomic, copy) NSString *quantity;
@property(nonatomic, copy) NSString *editType;
@property(nonatomic, copy) NSString *anotherSKUId;

@end
