//
//  HYMallCartShopInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 购物车信息
 */

#import "CQResponseResolve.h"
#import "HYMallCartProduct.h"
#import "HYExpressInfo.h"

@interface HYMallCartShopInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *amount_points;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSArray *goods;
@property (nonatomic, copy) NSString *store_id;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isNavEdit;

@property (nonatomic, copy) NSString *guestbook;  //卖家留言
@property (nonatomic, strong) HYExpressInfo *expressInfo;  //快递信息

@property (nonatomic, copy, readonly) NSString *totalPrice;  //总价
@property (nonatomic, assign, readonly) NSInteger totalPoint;  //总现金券

// 海淘增加字段
// supplierType：01   普通类型    06    海淘类型（String）
@property (nonatomic, strong) NSString *supplierType;

//新增
@property (nonatomic, copy) NSString *messageToStore;

- (id)copy;

@end
/*
 "store_name": "特奢汇",
 "amount": 446072,
 "amount_points": 0,
 "quantity": 7,
 "goods": []
"store_id": 82
 */