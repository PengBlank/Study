//
//  HYGetUpdateInfoResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYGetUpdateInfoResponse : CQBaseResponse

@property (nonatomic, assign) BOOL force_update; //是否强制更新
@property (nonatomic, copy) NSString *version_no;  //版本号
@property (nonatomic, copy) NSString *version_name;  //版本号
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;

@end