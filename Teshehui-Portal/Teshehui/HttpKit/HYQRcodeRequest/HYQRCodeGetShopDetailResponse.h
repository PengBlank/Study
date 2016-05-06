//
//  HYQRCodeGetShopDetailResponse.h
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYQRCodeShopDetail : JSONModel

@property (nonatomic, assign) int store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *owner_name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *merchant_brief;
@property (nonatomic, copy) NSString *merchant_description;
@property (nonatomic, strong) NSArray *img_url;

@end


@interface HYQRCodeGetShopDetailResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSString *shopDetail;

@end
