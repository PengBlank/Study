//
//  HYSearchHotKeyRequest.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYSearchHotKeyResponse.h"

@interface HYSearchHotKeyRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger liveServiceNumber;

@end
