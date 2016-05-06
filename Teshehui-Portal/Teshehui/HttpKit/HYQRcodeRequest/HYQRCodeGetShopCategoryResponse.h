//
//  HYQRCodeGetShopCategoryResponse.h
//  Teshehui
//
//  Created by Kris on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"
@protocol
HYQRCodeGetShopCategory
@end

@interface HYQRCodeGetShopCategory : JSONModel

@property (nonatomic, strong) NSArray<HYQRCodeGetShopCategory> *items;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *category_name;
@property (nonatomic, copy) NSString *merchantNumber;

@end

@interface HYQRCodeGetShopCategoryResponse : CQBaseResponse
@property (nonatomic, strong, readonly) NSArray *shopCateList;
@end
