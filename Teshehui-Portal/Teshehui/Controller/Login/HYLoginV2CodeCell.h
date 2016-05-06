//
//  HYLoginV2CodeCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "UITextFieldEx.h"

@interface HYLoginV2CodeCell : UITableViewCell
{
    NSUInteger _count;
    NSTimer *_timer;
}
@property (nonatomic, strong) UITextFieldEx *textField;
@property (nonatomic, strong) UIButton *codeBtn;


- (void)startTiming;

@end
