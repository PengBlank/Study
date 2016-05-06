//
//  HYLoginViewInviteCodeCell.h
//  Teshehui
//
//  Created by HYZB on 16/2/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLoginViewBaseCell.h"

@interface HYLoginViewInviteCodeCell : HYLoginViewBaseCell

@property (nonatomic, strong) UITextField *inviteTextField;
@property (nonatomic, strong) UIButton *askBtn;
//@property (nonatomic, strong) UILabel *declareLabel;

+ (HYLoginViewInviteCodeCell *)cellWithTableView:(UITableView *)tableView;
//- (void)setupFrame;

@end
