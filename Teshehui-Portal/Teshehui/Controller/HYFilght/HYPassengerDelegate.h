//
//  HYPassengerDelegate.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYPassengers;

typedef enum _PassengerType
{
    Unknow = 1,
    Passenger,
    HotelGuest
}PassengerType;

@protocol HYPassengerDelegate <NSObject>

@optional
- (void)didSelectPassengers:(NSArray *)passengers;
- (void)didUpdatePassengers:(NSArray *)passengers;
- (void)didUpdateWithPassenger:(HYPassengers *)passenger;
- (void)didDeletePassenger:(HYPassengers *)passenger;

@end
