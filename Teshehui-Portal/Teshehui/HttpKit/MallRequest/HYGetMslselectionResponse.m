//
//  HYGetMslselectionResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetMslselectionResponse.h"

@implementation HYGetMslselectionResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *result = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
//        NSMutableArray *muArray = [[NSMutableArray alloc] init];
//        for (id obj in result)
//        {
//            if ([obj isKindOfClass:[NSDictionary class]])
//            {
//                NSDictionary *d = (NSDictionary *)obj;
//                HYMslselectionInfo *fType = [[HYMslselectionInfo alloc] initWithDataInfo:d];
//                [muArray addObject:fType];
//            }
//        }
//        
//        if ([muArray count] > 0)
//        {
//            self.MslselectionArray = [muArray copy];
//        }
        
        self.selectionArray = [HYMslselectionInfo arrayOfModelsFromDictionaries:result];
    }
    
    return self;
}
@end
