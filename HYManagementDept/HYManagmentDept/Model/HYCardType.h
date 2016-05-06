//
//  HYCardType.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-3.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCardType : NSObject

@property (nonatomic, assign) NSInteger card_id;
@property (nonatomic, copy) NSString *card_name;

- (id)initWithDataInfo:(NSDictionary *)data;

@end
