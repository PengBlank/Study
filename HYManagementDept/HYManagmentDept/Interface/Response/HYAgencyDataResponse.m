//
//  HYAgencyDataResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyDataResponse.h"
#import "HYAgencyDataInfo.h"

@implementation HYAgencyDataResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            NSArray *array = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
            
            if ([array count] > 0)
            {
                NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
                for (NSDictionary *data in array)
                {
                    HYAgencyDataInfo *a = [[HYAgencyDataInfo alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.agencyDataList = [muArray copy];
            }
        }
    }
    
    return self;
}

@end
