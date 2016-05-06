//
//  HYCustomerServiceCell.h
//  Teshehui
//
//  Created by HYZB on 15/4/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *联系客服的cell
 */

#import "HYBaseLineCell.h"

typedef enum _CustomerServiceType
{
    OnlineService  =  1,
    callService
}CustomerServiceType;

@protocol HYCustomerServiceCellDelegate <NSObject>

@optional
- (void)didConnectCustomerServiceWithTpye:(CustomerServiceType)type;

@end

@interface HYCustomerServiceCell : HYBaseLineCell

@property (nonatomic, weak) id<HYCustomerServiceCellDelegate> delegate;

@end
