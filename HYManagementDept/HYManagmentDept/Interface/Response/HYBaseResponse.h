//
//  HYBaseResponse.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBaseResponse : NSObject

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *rspDesc;


@property (nonatomic, assign) NSInteger total;

@property (nonatomic, readonly, strong) NSDictionary *jsonDic;

- (id)initWithJsonDictionary:(NSDictionary*)dictionary;

@end
