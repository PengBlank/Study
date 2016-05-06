//
//  CQGetFilghtDynamicDetailResponse.h
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseResponse.h"
#import "CQFilghtDycDetail.h"

@interface CQGetFilghtDynamicDetailResponse : CQBaseResponse

@property (nonatomic, strong) CQFilghtDycDetail *dycDetail;

@end
