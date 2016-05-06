//
//  HYGetMslselectionResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMslselectionInfo.h"

@interface HYGetMslselectionResponse : CQBaseResponse

@property(nonatomic,strong)NSMutableArray *selectionArray;
@end
