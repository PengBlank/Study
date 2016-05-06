//
//  HYGetMessageRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYGetMessageRequest : CQBaseRequest

@property(nonatomic,copy)NSString* page;
@property(nonatomic,copy)NSString* num_per_page;

@end
