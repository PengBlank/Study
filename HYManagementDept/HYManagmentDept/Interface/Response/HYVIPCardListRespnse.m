//
//  HYVIPCradListRespnse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYVIPCardListRespnse.h"
#import "HYVIPCardInfo.h"
#import "NSDictionary+Mapping.h"
@interface HYVIPCardListRespnse ()


@end

@implementation HYVIPCardListRespnse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
        if (array && array.count > 0) {
            NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
            for (NSDictionary *data in array)
            {
//                HYVIPCardInfo *a = [[HYVIPCardInfo alloc] \
//                                    initWithData:\
//                                    [data dictionaryWithMap:@{@"name":@"agency_name"}]];
                HYVIPCardInfo *a = [[HYVIPCardInfo alloc] initWithData:data];
                [muArray addObject:a];
            }
            
            self.dataArray = [muArray copy];
        }
    }
    
    return self;
}

@end
