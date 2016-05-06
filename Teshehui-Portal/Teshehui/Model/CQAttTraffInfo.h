//
//  CQAttTraffInfo.h
//  Teshehui
//
//  Created by ChengQian on 13-12-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface CQAttTraffInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *longitude;	//
@property (nonatomic, copy) NSString *latitude	;	//
@property (nonatomic, copy) NSString *sceneryId	;	//
@property (nonatomic, copy) NSString *traffic	;	//交通指南

@end
