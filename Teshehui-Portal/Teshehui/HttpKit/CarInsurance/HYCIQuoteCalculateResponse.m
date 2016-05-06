//
//  HYCIQuoteCalculateResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQuoteCalculateResponse.h"
#import "HYCICarInfoFillType.h"

@implementation HYCIQuoteCalculateResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(self.jsonDic, @"data", [NSDictionary class]);
        
        NSSet *insureKeys = [NSSet setWithObjects:@"luxury", @"affordable", @"optional", @"null", nil];
        
        NSArray *categoryList = GETOBJECTFORKEY(data, @"inputCategoryList", NSArray);
        for (NSDictionary *dict in categoryList)
        {
            NSString *inputCategoryValue = GETOBJECTFORKEY(dict, @"inputCategoryValue", NSString);
            
            //报价
            if ([insureKeys containsObject:inputCategoryValue])
            {
                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
                self.quoteList = inputModels;
            }
            
            //交强险
            else if ([inputCategoryValue isEqualToString:@"force"])
            {
                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
                self.forceList = inputModels;
            }
            
            //起保日期
            else if ([inputCategoryValue isEqualToString:@"deadline"])
            {
                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
                self.dateList = inputModels;
            }
            
//            //是否可使用指省
//            else if ([inputCategoryValue isEqualToString:@"runAreaType"])
//            {
//                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
//                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
//                if (inputModels.count > 0)
//                {
//                    self.runAreaFlag = [[(HYCICarInfoFillType*)[inputModels objectAtIndex:0] value]
//                                        boolValue];
//                }
//            }
//            
//            //是否可使用指驾
//            else if ([inputCategoryValue isEqualToString:@"driverInfoFlag"])
//            {
//                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
//                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
//                if (inputModels.count > 0)
//                {
//                    self.driverFlag = [[(HYCICarInfoFillType*)[inputModels objectAtIndex:0] value]
//                                       boolValue];
//                }
//            }
        }
        
        self.points = [GETOBJECTFORKEY(data, @"points", NSString) floatValue
                       ];
    }
    return self;
}

@end
