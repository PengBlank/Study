//
//  HYPassengers.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPassengers.h"
#import "NSDate+Addition.h"

@implementation HYPassengers

- (instancetype)copy
{
    HYPassengers *passender = [[HYPassengers alloc] init];
    passender.isSelected = self.isSelected;
    passender.isChildren = self.isChildren;
    passender.buyChildren = self.buyChildren;
    passender.type = self.type;
    passender.name = self.name;
    passender.cardID = self.cardID;
    
    passender.passengerId = self.passengerId;
    passender.id_card_type_id = self.id_card_type_id;
    passender.cardName = self.cardName;
    passender.sex = self.sex;
    passender.is_adult = self.is_adult;
    passender.phone = self.phone;
    passender.country = self.country;
    passender.birthday = self.birthday;
    passender.tripDate = self.tripDate;
    
    passender.email = self.email;
    
    return passender;
}

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        _isSelected = NO;
        _isChildren = NO;
        _buyChildren = NO;
        
        _type = Undefined;
        
        self.name = GETOBJECTFORKEY(data, @"realName", [NSString class]);
        self.cardID = GETOBJECTFORKEY(data, @"certificateNumber", [NSString class]);
        
        //针对机票订单的时候服务器字段名不对
        if (!self.cardID)
        {
            self.cardID = GETOBJECTFORKEY(data, @"idcard", [NSString class]);
        }
        
        self.passengerId = GETOBJECTFORKEY(data, @"contactId", [NSString class]);
        self.id_card_type_id = GETOBJECTFORKEY(data, @"certificateCode", [NSString class]);
        self.cardName = GETOBJECTFORKEY(data, @"certificateName", [NSString class]);
        self.sex = GETOBJECTFORKEY(data, @"sex", [NSString class]);
        self.is_adult = GETOBJECTFORKEY(data, @"is_adult", [NSString class]);
        self.phone = GETOBJECTFORKEY(data, @"phone", [NSString class]);
        
        NSString *c = GETOBJECTFORKEY(data, @"country", [NSString class]);
        if (!c || [c isEqualToString:@"0"])
        {
            c = @"1";  //中国
        }
        self.country = c;
        
        self.birthday = GETOBJECTFORKEY(data, @"birthday", [NSString class]);
        
        //如果生日为空，则通过身份证计算出来
        if ([self.birthday length] <= 0)
        {
            if ([self.cardID length] == 18)
            {
                NSString *strYear = [self.cardID substringWithRange:NSMakeRange(6, 4)];  // 年份
                NSString *strMonth = [self.cardID substringWithRange:NSMakeRange(10, 2)];  //月份
                NSString *strDay = [self.cardID substringWithRange:NSMakeRange(12, 2)];  //日
                
                self.birthday = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
            }
            else if ([self.cardID length] == 15)
            {
                NSString *strYear = [self.cardID substringWithRange:NSMakeRange(6, 2)];  // 年份
                NSString *strMonth = [self.cardID substringWithRange:NSMakeRange(8, 2)];  //月份
                NSString *strDay = [self.cardID substringWithRange:NSMakeRange(10, 2)];  //日
                
                self.birthday = [NSString stringWithFormat:@"%19@-%@-%@",strYear,strMonth,strDay];
            }
        }
        self.email = GETOBJECTFORKEY(data, @"email", [NSString class]);
    }
    
    return self;
}

- (PassengerAgeType)type
{
    if (_type == Undefined)
    {
        _type = [self checkTypeWithBirthday:self.birthday];
        self.isChildren = (self.type>Adult);
        self.buyChildren = self.isChildren;
    }
    return _type;
}

- (void)setTripDate:(NSString *)tripDate
{
    if (tripDate!=_tripDate)
    {
        _tripDate = [tripDate copy];
        _type = Undefined;
    }
}
- (void)setBirthday:(NSString *)birthday
{
    if (birthday != _birthday)
    {
        _birthday =  [birthday copy];
        _type = Undefined;
    }
}

- (PassengerAgeType)checkTypeWithBirthday:(NSString *)birthday
{
    PassengerAgeType type = Adult;
    if ([birthday length] > 0)
    {
        NSDate *date = [NSDate dateFromString:birthday];
        if (date)
        {
            NSDate *now = nil;
            
            //根据用户机票预定的出行日期判断
            if (self.tripDate)
            {
                now = [NSDate dateFromString:self.tripDate];
            }
            
            if (!now)
            {
                now = [NSDate date];
            }
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

            unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
            
            NSDateComponents *comps = [gregorian components:unitFlags
                                                   fromDate:date
                                                     toDate:now
                                                    options:0];
            
            NSInteger year = [comps year];
            NSInteger month = [comps month];
            NSInteger day = [comps day];
            
            //判断12周岁
            if (year<2 || (year==2 && ((month+day)<=0)))
            {
                type = Baby;
            }
            else if (year<12)  // || (year==12 && ((month+day)<=0)
            {
                type = Children;
            }
        }
    }
    
    return type;
}

@end
