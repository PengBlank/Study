//
//  HYMobileInfo.h
//  Teshehui
//
//  Created by HYZB on 14-10-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TelphoneType)
{
    Phone  = 1,
    Work,
    Home,
    Fax,
    Other
};

@interface HYTelNumberInfo : NSObject
{
    NSString *_desc;
}
@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) TelphoneType type;
@property (nonatomic, copy, readonly) NSString *desc;

@end
