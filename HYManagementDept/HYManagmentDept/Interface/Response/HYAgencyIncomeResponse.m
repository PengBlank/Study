//
//  HYAgencyIncomeResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyIncomeResponse.h"
#import "HYAgencyIncomeInfo.h"

@interface HYAgencyIncomeResponse ()

//@property (nonatomic, strong) NSArray *incomeList;

@end

@implementation HYAgencyIncomeResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            NSArray *array = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
            if (array && array.count > 0) {
                NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
                for (NSDictionary *data in array)
                {
                    HYAgencyIncomeInfo *a = [[HYAgencyIncomeInfo alloc] \
                                              initWithData:\
                                              data];
                    [muArray addObject:a];
                }
                
                self.dataArray = [muArray copy];
            }
        }
    }
    
    return self;
}

@end
