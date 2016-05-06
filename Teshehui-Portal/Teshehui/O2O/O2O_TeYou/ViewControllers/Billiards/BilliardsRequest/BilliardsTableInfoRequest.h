//
//  BilliardsTableInfoRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//
/**
 *  获取球桌信息
 *
 */
#import "CQBaseRequest.h"

@interface BilliardsTableInfoRequest : CQBaseRequest

@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *btId; //球台ID
@property (nonatomic,strong) NSString *UId; //球台ID
@end
