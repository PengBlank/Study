//
//  CQHotelCity.m
//  Teshehui
//
//  Created by ChengQian on 13-11-5.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYCountryInfo.h"
#import "JSONKit_HY.h"
#import "PinYin.h"

@implementation HYCountryInfo

+ (NSArray *)getAllCountries
{
    NSError *error = NULL;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countries"
                                                     ofType:@"txt"];
    NSString *countriesStr = [[NSString alloc] initWithContentsOfFile:path
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
    if (countriesStr)
    {
        NSDictionary *countries = [countriesStr objectFromJSONString];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];

        NSMutableArray *allKeys = [[countries allKeys] mutableCopy];
        for (NSString *key in allKeys)
        {
            HYCountryInfo *c = [[HYCountryInfo alloc] init];
            c.countryId = key;
            c.countryName = [countries objectForKey:key];
            
            if (!c.pinyin)
            {
                //转拼英
                PTChineseNameInfo *cni = [PinYin quickConvert:c.countryName];
                c.pinyin = cni.pinyinLong;
                c.pinyinIndex = cni.pinyinIndex;
            }
            
            [muArray addObject:c];
        }
        
        return muArray;
    }
    
    return nil;
}

+ (HYCountryInfo *)countryWithId:(NSString *)contryId
{
    HYCountryInfo *c = nil;
    
    NSError *error = NULL;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countries"
                                                     ofType:@"txt"];
    NSString *countriesStr = [[NSString alloc] initWithContentsOfFile:path
                                                             encoding:NSUTF8StringEncoding
                                                                error:&error];
    if (countriesStr)
    {
        NSDictionary *countries = [countriesStr objectFromJSONString];
        
        NSMutableArray *allKeys = [[countries allKeys] mutableCopy];
        for (NSString *key in allKeys)
        {
            if ([key isEqualToString:contryId])
            {
                c = [[HYCountryInfo alloc] init];
                c.countryId = key;
                c.countryName = [countries objectForKey:key];
                break;
            }
        }
    }
    
    return c;
}

@end
