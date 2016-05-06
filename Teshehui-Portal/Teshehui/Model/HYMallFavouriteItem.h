//
//  HYMallFavouriteItem.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMallFavouriteItem : JSONModel

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productPicUrl;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storeName;

@end
