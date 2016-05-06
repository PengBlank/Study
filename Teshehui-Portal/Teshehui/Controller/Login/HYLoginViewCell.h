//
//  HYLoginViewCell.h
//  Teshehui
//
//  Created by HYZB on 16/2/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLoginViewBaseCell.h"

@protocol HYLoginViewCellDelegate <NSObject>

- (void)validateAction;

@end

@interface HYLoginViewCell : HYLoginViewBaseCell
{
    NSUInteger _count;
    NSTimer *_timer;
}
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) LoginType *type;

+ (HYLoginViewCell *)cellWithTableView:(UITableView *)tableView;
- (void)setDataWithType:(LoginType)type phoneNum:(NSString *)phoneNum cardNum:(NSString *)cardNum;
- (void)startTiming;

@end
