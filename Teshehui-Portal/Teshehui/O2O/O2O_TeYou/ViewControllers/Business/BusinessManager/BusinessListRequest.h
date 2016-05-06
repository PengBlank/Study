//
//  BusinessListRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "BusinessListInfo.h"
@interface BusinessListRequest : CQBaseRequest

//参数列表
@property (nonatomic, strong) NSString* cityName;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger CategoryId;
@property (nonatomic, assign) NSInteger AreaId;
@property (nonatomic, assign) NSInteger sortType;   //0离我最近 1最新发布

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *lontitude;

@end
