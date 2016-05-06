//
//  HYGetPolicyListResponse.h
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPolicyType.h"

@interface HYGetPolicyListResponse : CQBaseResponse

@property (nonatomic, copy) NSArray *dataList;

@end
