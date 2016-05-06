//
//  HYGoodCategoryResponse.m
//  Teshehui
//
//  Created by RayXiang on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodCategoryResponse.h"

@interface HYGoodCategoryResponse ()

//@property (nonatomic, strong) NSArray *categoryArray;

@end

@implementation HYGoodCategoryResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *result = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
//        NSArray *category = GETOBJECTFORKEY(result, @"childCategoryList", [NSArray class]);
//        
//        NSMutableArray *muArray = [[NSMutableArray alloc] init];
//        for (id obj in category)
//        {
//            if ([obj isKindOfClass:[NSDictionary class]])
//            {
//                NSDictionary *d = (NSDictionary *)obj;
//                HYMallCategoryInfo *fType = [[HYMallCategoryInfo alloc] initWithDataInfo:d];
//                [muArray addObject:fType];
//            }
//        }
//        
//        if ([muArray count] > 0)
//        {
//            self.categoryArray = [muArray copy];
//        }
        
        NSError *err;
        self.category = [[HYMallCategoryInfo alloc] initWithDictionary:result error:&err];
        
    }
    
    return self;
}

@end
