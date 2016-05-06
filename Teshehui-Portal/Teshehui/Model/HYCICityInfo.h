//
//  HYCICityInfo.h
//  Teshehui
//
//  Created by HYZB on 15/7/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYCICityInfo : JSONModel

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *regionEnName;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *children;

@end


/*
 "id":"33",
 "regionName":"安徽",
 "regionEnName":null,
 "parentId":null,
 "children":null
*/