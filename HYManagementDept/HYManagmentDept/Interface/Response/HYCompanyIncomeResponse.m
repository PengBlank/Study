//
//  HYAgencyIncomeResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCompanyIncomeResponse.h"
#import "HYCompanyIncomeInfo.h"

@interface HYCompanyIncomeResponse ()


@end

@implementation HYCompanyIncomeResponse

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
                    HYCompanyIncomeInfo *a = [[HYCompanyIncomeInfo alloc] \
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