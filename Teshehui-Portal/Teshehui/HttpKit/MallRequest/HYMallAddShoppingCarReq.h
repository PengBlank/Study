//
//  HYMallAddOrdersResquest.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallAddOrdersResponse.h"

@interface HYMallAddShoppingCarReq : CQBaseRequest

@property(nonatomic, copy) NSString *productSKUId;
@property(nonatomic, assign) NSInteger quantity;

@end
/*
http://www.teshehui.com/api/cart/add?spec_id=35&quantity=3
*/