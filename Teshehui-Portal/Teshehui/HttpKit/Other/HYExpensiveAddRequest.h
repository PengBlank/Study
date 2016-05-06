//
//  HYExpensiveAddRequest.h
//  Teshehui
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYExpensiveAddResponse.h"

@interface HYExpensiveAddRequest : CQBaseRequest

@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, strong) NSString *productSkuCode;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *compare_url;
@property (nonatomic, strong) NSArray *imgs;

@end
