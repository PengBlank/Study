//
//  HistoryOrderRequest.h
//  Teshehui
//
//  Created by wujianming on 15/11/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQBaseRequest.h"

@interface BuyGoodsRequest : CQBaseRequest

@property (nonatomic, copy) NSString *merId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *uId;

@property (nonatomic, copy) NSArray *buyList;

@end
