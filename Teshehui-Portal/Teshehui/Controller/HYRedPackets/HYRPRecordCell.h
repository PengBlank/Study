//
//  HYRPRecordCell.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYRedpacketInfo.h"

@interface HYRPRecordCell : HYBaseLineCell

@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, strong) HYRedpacketInfo *redpacket;

@end
