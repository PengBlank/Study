//
//  HYCIQuoteResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQuoteResponse.h"

@implementation HYCIQuoteResponse


- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        self.runAreaFlag = NO;
        self.driverFlag = NO;
        
        NSDictionary *data = GETOBJECTFORKEY(self.jsonDic, @"data", [NSDictionary class]);
        
        NSSet *insureKeys = [NSSet setWithObjects:@"luxury", @"affordable", @"optional", @"null", nil];
        
        NSArray *additionList = GETOBJECTFORKEY(data, @"additionalInputCategoryList", NSArray);
        
        //检测数组有效性的时候，不能只检测对象的有效性，需要检测长度
        if ([additionList count])
        {
            NSDictionary *carInfo = [additionList objectAtIndex:0];
            
            NSArray *infoList = GETOBJECTFORKEY(carInfo, @"inputList", [NSArray class]);
            if ([infoList count] > 0)
            {
                self.additionList = [HYCICarInfoFillType arrayOfModelsFromDictionaries:infoList];
            }
        }
        
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
            
            //是否可使用指省
            else if ([inputCategoryValue isEqualToString:@"runAreaType"])
            {
                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
                for (HYCICarInfoFillType*filltype in inputModels)
                {
                    if ([filltype.name isEqualToString:@"isRunAreaFlag"])
                    {
                        self.runAreaFlag = filltype.value.boolValue;
                    }
                    else if ([filltype.name isEqualToString:@"runArea"])
                    {
                        self.runAreaInfo = filltype;
                    }
                }
            }
            
            //是否可使用指驾
            else if ([inputCategoryValue isEqualToString:@"driverInfoFlag"])
            {
                NSArray *inputList = GETOBJECTFORKEY(dict, @"inputList", NSArray);
                NSArray *inputModels = [HYCICarInfoFillType arrayOfModelsFromDictionaries:inputList];
                if (inputModels.count > 0)
                {
                    self.driverFlag = [[(HYCICarInfoFillType*)[inputModels objectAtIndex:0] value]
                                       boolValue];
                }
            }
        }
        
        self.points = [GETOBJECTFORKEY(data, @"points", NSString) floatValue
                       ];
    }
    return self;
}

@end
