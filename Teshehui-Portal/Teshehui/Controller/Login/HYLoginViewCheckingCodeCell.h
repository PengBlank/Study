//
//  HYLoginViewCheckingCodeCell.h
//  Teshehui
//
//  Created by HYZB on 16/2/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLoginViewBaseCell.h"

@interface HYLoginViewCheckingCodeCell : HYLoginViewBaseCell

@property (nonatomic, strong) UITextField *codeTextField;
//@property (nonatomic, strong) UIButton *forgetBtn;

+ (HYLoginViewCheckingCodeCell *)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithType:(LoginType)type checkingCode:(NSString *)checkingCode password:(NSString *)password;

@end
