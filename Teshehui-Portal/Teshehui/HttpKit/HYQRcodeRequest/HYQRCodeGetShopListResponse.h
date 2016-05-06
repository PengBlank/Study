//
//  HYQRCodeGetShopListResponse.h
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYQRCodeShop : NSObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *merchant_brief;
@property (nonatomic, copy) NSString *merchant_description;
@property (nonatomic, strong) NSString *merchant_cate_name;
@property (nonatomic, strong) NSString *business_hours_start;
@property (nonatomic, strong) NSString *business_hours_end;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat lontitude;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSArray *img_url;

@end


@interface HYQRCodeGetShopListResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *shopList;

@end
