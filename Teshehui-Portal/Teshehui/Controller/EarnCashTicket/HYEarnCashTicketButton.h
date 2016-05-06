//
//  HYEarnCashTicketButton.h
//  Teshehui
//
//  Created by HYZB on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYGetTranscationTypeResponse.h"

@interface HYEarnCashTicketButton : UIButton
{
    UILabel *_descLab;
}
/** 图标 */
@property (nonatomic, strong) UIImageView *iconImgV;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;
/** 类型 */
@property (nonatomic, strong) HYBusinessType *type;

@end
