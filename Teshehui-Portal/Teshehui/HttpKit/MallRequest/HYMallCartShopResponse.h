//
//  HYMallCartShopResponse.h
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallCartShopInfo.h"

@interface HYMallCartShopResponse : CQBaseResponse

@property(nonatomic, strong) NSMutableArray *productsArray;

@end
