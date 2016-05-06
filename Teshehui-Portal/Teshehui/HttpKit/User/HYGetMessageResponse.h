//
//  HYGetMessageResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMessageInfo.h"

@interface HYGetMessageResponse : CQBaseResponse

@property(nonatomic,strong)NSMutableArray* MessageArray;

@property(nonatomic,assign)NSInteger totalItems;

@end
