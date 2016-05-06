//
//  HYProductDetailGuessYouLikeResponse.m
//  Teshehui
//
//  Created by Kris on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailGuessYouLikeResponse.h"

@implementation HYProductDetailGuessYouLikeResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *dataInfo = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if ([dataInfo count] > 0)
        {
            self.dataList = [HYMallGuessYouLikeModel arrayOfModelsFromDictionaries:dataInfo];
        }
    }
    
    return self;
}

@end
