//
//  CQFilghtPolicyResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtPolicyResponse.h"

@implementation CQFilghtPolicyResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(dictionary, @"DataList", [NSArray class]);
        
        if ([array count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array)
            {
                CQFilghtPolicy *policy = [[CQFilghtPolicy alloc] initWithDataInfo:dic];
                [muArray addObject:policy];
            }
            self.policys = muArray;
        }
    }
    
    return self;
}


@end
