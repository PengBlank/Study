//
//  HYMallGuijiupeiDescriptionCell.h
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYIndemnityinfo.h"

@interface HYMallGuijiupeiDescriptionCell : HYBaseLineCell

@property (nonatomic, strong) HYIndemnityinfo *descriptionData;
@property (nonatomic, copy) void (^didClickImage)(NSInteger idx);

@end
