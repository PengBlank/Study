//
//  HYCIGetCarFillInfoListResp.m
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetCarFillInfoListResp.h"

@implementation HYCIGetCarFillInfoListResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        self.sessionId = GETOBJECTFORKEY(data, @"sessionId", [NSString class]);
        self.packageTypeMap = GETOBJECTFORKEY(data, @"packageTypeMap", [NSDictionary class]);
        
        NSArray *list = GETOBJECTFORKEY(data, @"additionalInputCategoryList", [NSArray class]);
        if (!list)
        {
            list = GETOBJECTFORKEY(data, @"inputCategoryList", [NSArray class]);
        }
        
        if ([list count] > 0)
        {
            NSDictionary *carInfo = [list objectAtIndex:0];
            
            self.infoKey = GETOBJECTFORKEY(carInfo, @"inputCategoryValue", [NSString class]);
            
            NSArray *infoList = GETOBJECTFORKEY(carInfo, @"inputList", [NSArray class]);
            
            //人为排序
            NSArray *sortArr = [NSArray arrayWithObjects:
                                     @"vehicleFrameNo",
                                     @"vehicleModelName",
                                     @"engineNo",
                                     @"seats",
                                     @"firstRegisterDate",
                                     @"vehicleId",
                                     @"specialCarFlag",
                                     @"specialCarDate",
                                     @"vehicleInvoiceNo",
                                     @"vehicleInvoiceDate",
                                     @"isOcr",
                                     nil];
            
            NSMutableArray *tempShowArr = [[NSMutableArray alloc] init];
            if ([infoList count])
            {
                self.carInfoAllList = [HYCICarInfoFillType arrayOfModelsFromDictionaries:infoList];
                BOOL hasVechleId = NO;
                for (HYCICarInfoFillType *info in self.carInfoAllList)
                {
                    if ([info.name isEqualToString:@"vehicleId"])
                    {
                        hasVechleId = info.value.length > 0;
                        break;
                    }
                }
                for (NSString *key in sortArr)
                {
                    for (HYCICarInfoFillType *info in self.carInfoAllList)
                    {
                        if ([info.name isEqualToString:key])
                        {
                            if ([info.name isEqualToString:@"vehicleModelName"])  //品牌
                            {
                                info.inputType = @"100";  //下拉
                                if (!hasVechleId)
                                {
                                    self.vichelSearchKey = info.value;
                                    info.value = nil;
                                }
                            }
                            if (info.inputType.intValue!=30 && ![info.name isEqualToString:@"specialCarDate"] )  //隐藏
                            {
                                [tempShowArr addObject:info];
                            }
                            
                        }
                    }
                }
                
                self.carInfoShowList = [tempShowArr copy];
            }
        }
    }
    
    return self;
}

@end
