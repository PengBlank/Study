//
//  HYMslselectionInfo.h
//  Teshehui
//
//  Created by ichina on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
@interface HYMslselectionInfo : JSONModel

@property(nonatomic,copy)NSString* region_id;

@property(nonatomic,copy)NSString* region_name;

@property(nonatomic,copy)NSString* parent_id;
@property (nonatomic, strong)NSString *area_id;
@end
