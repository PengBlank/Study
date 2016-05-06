//
//  CQAttCity.m
//  Teshehui
//
//  Created by ChengQian on 13-11-13.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYHotelCityInfo.h"
#import "JSONKit_HY.h"
#import "PinYin.h"
#import "HYHotelCityListRequest.h"

#import "HYHotelDistrictInfo.h"
#import "HYHotelCommercialInfo.h"

@interface HYHotelCityInfo ()

@property (nonatomic, strong) NSArray *districtList;
@property (nonatomic, strong) NSArray *commercialList;

@end

@implementation HYHotelCityInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.cityId = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.cityName = GETOBJECTFORKEY(data, @"name", [NSString class]);
        NSString *h = GETOBJECTFORKEY(data, @"hot", [NSString class]);
        self.hot = [h integerValue];
        self.pinyin = GETOBJECTFORKEY(data, @"english_name", [NSString class]);
        
        NSString *f = @"#";
        if ([self.pinyin length] > 0)
        {
            f = [self.pinyin substringToIndex:1];
            f = [f uppercaseString];
        }
        else
        {
            PTChineseNameInfo *cni = [PinYin quickConvert:self.cityName];
            self.pinyin = cni.pinyinLong;
            f = cni.pinyinIndex;
        }
        
        self.pinyinIndex = f;
        
        
        //行政区
        NSArray *districList = GETOBJECTFORKEY(data, @"districList", [NSArray class]);;
        NSMutableArray *muTempDistricts = [[NSMutableArray alloc] initWithCapacity:[districList count]];
        
        HYHotelDistrictInfo *unkownDis = [[HYHotelDistrictInfo alloc] init];
        unkownDis.name = @"不限";
        [muTempDistricts addObject:unkownDis];
        
        for (NSDictionary *d in districList)
        {
            HYHotelDistrictInfo *c = [[HYHotelDistrictInfo alloc] initWithDataInfo:d];
            [muTempDistricts addObject:c];
        }
        
        self.districtList = [muTempDistricts copy];
        
        //商业区
        NSArray *commercialList = GETOBJECTFORKEY(data, @"commercialList", [NSArray class]);;
        NSMutableArray *muTempDowntowns = [[NSMutableArray alloc] initWithCapacity:[commercialList count]];
        
        HYHotelCommercialInfo *unkownDown = [[HYHotelCommercialInfo alloc] init];
        unkownDown.name = @"不限";
        [muTempDowntowns addObject:unkownDown];
        
        for (NSDictionary *d in commercialList)
        {
            HYHotelCommercialInfo *c = [[HYHotelCommercialInfo alloc] initWithDataInfo:d];
            [muTempDowntowns addObject:c];
        }
        
        self.commercialList = [muTempDowntowns copy];
    }
    
    return self;
}

- (void)updateInfo
{
    NSArray *all = [HYHotelCityInfo getAllAttCityInfo];
    
    for (HYHotelCityInfo *city in all)
    {
        if ([city.cityName isEqualToString:self.cityName])
        {
            self.cityId = city.cityId;
            self.cityName = city.cityName;
            self.pinyin = city.pinyin;
            self.pinyinIndex = city.pinyinIndex;
            self.countryId = city.countryId;
            self.provinceId = city.provinceId;
            self.hot = city.hot;
            
            self.districtList = city.districtList;
            self.commercialList = city.commercialList;
            break;
        }
    }
}

+ (HYHotelCityInfo *)getWithCityName:(NSString *)cityName; //在本地数据中查
{
    NSArray *all = [HYHotelCityInfo getAllAttCityInfo];
    
    for (HYHotelCityInfo *city in all)
    {
        if ([city.cityName isEqualToString:cityName])
        {
            return city;
        }
    }
    
    return nil;
}

+ (NSArray *)getAllAttCityInfo
{
    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [string  stringByAppendingPathComponent:@"hotel_city.plist"];
    NSArray *citys = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *p in citys)
    {
        NSArray *citys = [p objectForKey:@"cityList"];
        
        for (NSDictionary *d in citys)
        {
            HYHotelCityInfo *c = [[HYHotelCityInfo alloc] initWithDataInfo:d];
            [muArray addObject:c];
        }
    }
    
    return muArray;
}

+ (void)updateHotelCityWithCallback:(void (^)(BOOL, BOOL))callback
{
    NSInteger version = 20150910;
    
    //取本地版本号
    version = [[NSUserDefaults standardUserDefaults] integerForKey:@"hotelCityVersion"];
    
    HYHotelCityListRequest *request = [[HYHotelCityListRequest alloc] init];
    request.dataVersion = version;
    [request sendReuqest:^(id result, NSError *error)
    {
        BOOL hasChange = NO;
        
        if ([result isKindOfClass:[CQBaseResponse class]])
        {
            NSDictionary *dic = [[(CQBaseResponse *)result jsonDic] objectForKey:@"data"];
            if (dic != nil && ![dic isEqual:[NSNull null]])
            {
                NSArray *list = [dic objectForKey:@"provinceList"];
                
                hasChange = (list.count > 0);
                
                if (hasChange)
                {
                    NSNumber *newV = [dic objectForKey:@"version"];
                    [[NSUserDefaults standardUserDefaults] setObject:newV forKey:@"hotelCityVersion"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSString* string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString* fileName = [string  stringByAppendingPathComponent:@"hotel_city.plist"];
                    [list writeToFile:fileName atomically:NO];
                }
            }
            
        }
        callback(YES, hasChange);
    }];
}

+ (void)registerDefaultCitys
{
    NSNumber *v = [[NSUserDefaults standardUserDefaults] objectForKey:@"hotelCityVersion"];
    if (!v)
    {
        NSNumber *newV = @20150910;
        [[NSUserDefaults standardUserDefaults] setObject:newV forKey:@"hotelCityVersion"];
        
        NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"hotel_city" ofType:@"plist"];
        NSString* toPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        toPath = [toPath  stringByAppendingPathComponent:@"hotel_city.plist"];
        NSError *error = nil;
        @try
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:toPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:toPath error:&error];
            }
            [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
        }
        @catch (NSException *exception) {
            //
            DebugNSLog(@"error at load default city infos: %@", exception.description);
        }
    }
}

@end
