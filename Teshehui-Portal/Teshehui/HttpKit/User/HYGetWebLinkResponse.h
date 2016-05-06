//
//  HYAboutResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYGetWebLinkResponse : CQBaseResponse

@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *infoStr;

@end
