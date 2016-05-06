//
//  HYMallChannelGoods.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMallChannelGoods : JSONModel

@property (nonatomic, copy) NSString* productId;
@property (nonatomic, copy) NSString* productName;
@property (nonatomic, copy) NSString* productCode;
@property (nonatomic, copy) NSString* tshPrice;
@property (nonatomic, copy) NSString* points;
@property (nonatomic, copy) NSString* marketPrice;
@property (nonatomic, copy) NSString* storeCount;

@property (nonatomic, copy) NSString *pictureUrl;

@end
