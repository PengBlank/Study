//
//  HYGroupOrderDetailInfo.h
//  Teshehui
//
//  Created by HYZB on 2014/12/18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYGroupOrderDetailInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *provider;
@property (nonatomic, copy) NSString *originalPrice;
@property (nonatomic, copy) NSString *discountPrice;
@property (nonatomic, copy) NSString *itemNumber;
@property (nonatomic, copy) NSString *itemType;
@property (nonatomic, copy) NSString *catCode;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *itemDescription;

@end

/*
 itemId	INT	商品ID(预留)
 itemName	STRING	商品名称
 provider	STRING	供应商(预留)
 originalPrice	DOUBLE	原价(预留)
 discountPrice	DOUBLE	在该订单中的实际价格(预留)
 itemNumber	NUMBER	商品数量
 itemType	STRING	商品类型(预留)
 catCode	STRING	基本类型(预留)
 brandCode	STRING	品牌ID(预留)
 itemDescription	STRING	商品描述(预留)
*/