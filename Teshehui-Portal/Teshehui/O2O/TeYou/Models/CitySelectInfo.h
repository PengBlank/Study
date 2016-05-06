//
//  CitySelectInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySelectInfo : NSObject
@property (nonatomic, assign) NSInteger             Level;
@property (nonatomic, assign) NSInteger             OrzId;
@property (nonatomic, assign) NSInteger             ParentId;
@property (nonatomic, assign) NSInteger             Sort;

@property (nonatomic, strong) NSString              *Name;
@property (nonatomic, strong) NSMutableArray        *SubAdress;
@end
