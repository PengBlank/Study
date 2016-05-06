//
//  HYVIPListResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPListResponse.h"
#import "HYVIPMemberInfo.h"

@interface HYVIPListResponse ()

@end

@implementation HYVIPListResponse

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
                    HYVIPMemberInfo *a = [[HYVIPMemberInfo alloc] \
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
