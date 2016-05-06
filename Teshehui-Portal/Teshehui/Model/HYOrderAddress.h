//
//  HYOrderAddress.h
//  Teshehui
//
//  Created by HYZB on 15/5/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYOrderAddress : NSObject

@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *region;
@property (nonatomic,strong) NSString *regionName;

- (NSString *)addressDesc;

-(id)initWithJson:(NSDictionary *)json;

@end
