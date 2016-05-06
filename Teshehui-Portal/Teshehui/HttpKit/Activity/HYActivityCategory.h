//
//  HYActivityCategory.h
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYActivityCategory : NSObject

@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSArray *child;

- (id)initWithData:(NSDictionary *)data;

@end
