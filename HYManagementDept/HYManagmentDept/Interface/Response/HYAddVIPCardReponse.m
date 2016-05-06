//
//  HYAddVIPCardReponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAddVIPCardReponse.h"

@interface HYAddVIPCardReponse ()

@property (nonatomic, assign) NSInteger count;  //返回批量添加成功的总数，返回0则没有批量添加成功

@end

@implementation HYAddVIPCardReponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            id count = [self.jsonDic objectForKey:@"count"];
            if ([count respondsToSelector:@selector(integerValue)])
            {
                self.count = [count integerValue];
            }
            else {
                self.count = 0;
            }
        }
    }
    
    return self;
}

@end
