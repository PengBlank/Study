//
//  HYRowDataResponse.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYRowDataResponse : HYBaseResponse
{
    NSArray *_dataArray;
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger page;

- (id)initWithJsonDictionary:(NSDictionary *)dictionary;
@end
