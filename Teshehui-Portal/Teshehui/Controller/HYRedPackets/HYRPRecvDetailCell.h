//
//  HYRPRecvDetailCell.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYRedpacketRecv.h"

@interface HYRPRecvDetailCell : HYBaseLineCell

@property (nonatomic, strong) HYRedpacketRecv *recv;

@property (nonatomic, strong) UILabel *statusLab;

@end
