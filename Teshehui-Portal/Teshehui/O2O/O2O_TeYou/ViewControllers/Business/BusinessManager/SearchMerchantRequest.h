//
//  SearchMerchantRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface SearchMerchantRequest : CQBaseRequest
//参数列表
@property (nonatomic, strong) NSString  *MerchantName  ;
@property (nonatomic, strong) NSString  *City;
@property (nonatomic, assign) NSInteger PageIndex;
@property (nonatomic, assign) NSInteger PageSize;
@property (nonatomic, assign) NSInteger CategoryId;
@property (nonatomic, assign) NSInteger AreaId;
@property (nonatomic, assign) NSInteger SortType;

@property (nonatomic, assign) double    Latitude;
@property (nonatomic, assign) double    Longitude;

@end
