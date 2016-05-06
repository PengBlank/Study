//
//  HYUserPortraitRequest.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYUserPortraitResponse.h"

@interface HYUserPortraitRequest : CQBaseRequest

@property (nonatomic, strong) UIImage *portrait;

@end
