//
//  HYSearchHotKeyResponse.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYSearchHotKeyResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *hotKeys;
@property (nonatomic, strong) NSArray *serviceKeys;

@end

@interface HYSearchHotKey : JSONModel

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *sortNumber;
@property (nonatomic, strong) NSString *businessCode;

@end
