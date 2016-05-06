//
//  UIButton+Common.m
//  Coding_iOS
//
//  Created by ??? on 14-8-5.
//  Copyright (c) 2014年 ???. All rights reserved.
//

#import "UIButton+Common.h"
#import "NSString+Common.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "UIView+Frame.h"
#import "DefineConfig.h"
@implementation UIButton (Common)
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn.titleLabel setMinimumScaleFactor:0.5];
    
    CGFloat titleWidth = [title getWidthWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreen_Width, 30)] +20;
    btn.frame = CGRectMake(0, 0, titleWidth, 30);
    
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}
+ (UIButton *)buttonWithTitle_ForNav:(NSString *)title{
    return [UIButton buttonWithTitle:title titleColor:[UIColor colorWithHexString:@"0x3bbd79"]];
}
+ (UIButton *)buttonWithUserStyle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn userNameStyle];
    return btn;
}

- (void)frameToFitTitle{
    CGRect frame = self.frame;
    CGFloat titleWidth = [self.titleLabel.text getWidthWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(kScreen_Width, frame.size.height)];
    frame.size.width = titleWidth;
    [self setFrame:frame];
}

- (void)userNameStyle{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
//    [self setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
}
- (void)setUserTitle:(NSString *)aUserName{
    [self setTitle:aUserName forState:UIControlStateNormal];
    [self frameToFitTitle];
}
- (void)setUserTitle:(NSString *)aUserName font:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    [self setTitle:aUserName forState:UIControlStateNormal];
    CGRect frame = self.frame;
    CGFloat titleWidth = [self.titleLabel.text getWidthWithFont:font constrainedToSize:CGSizeMake(kScreen_Width, frame.size.height)];
    if (titleWidth > maxWidth) {
        titleWidth = maxWidth;
//        self.titleLabel.minimumScaleFactor = 0.5;
//        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    [self setWidth:titleWidth];
    [self.titleLabel setWidth:titleWidth];
}

- (void)layoutButtonWithEdgeInsetsStyle:(TYButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    

    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case TYButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-space/2.0, 0);
        }
            break;
        case TYButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case TYButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWidth, 0, 0);
        }
            break;
        case TYButtonEdgeInsetsStyleRight:
        {
            if (labelWidth > self.width - imageWidth) {
                labelWidth = self.width - imageWidth;
            }
          
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-space/2.0 + 10, 0, imageWidth+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
//- (void)configFollowBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell{
////    对于自己，要隐藏
//    if ([Login isLoginUserGlobalKey:curUser.global_key]) {
//        self.hidden = YES;
//        return;
//    }else{
//        self.hidden = NO;
//    }
//    
//    NSString *imageName;
//    if (curUser.followed.boolValue) {
//        if (curUser.follow.boolValue) {
//            imageName = @"btn_followed_both";
//        }else{
//            imageName = @"btn_followed_yes";
//        }
//    }else{
//        imageName = @"btn_followed_not";
//    }
////    if (fromCell) {
////        imageName = [imageName stringByAppendingString:@"_cell"];
////    }
//    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}
//+ (UIButton *)btnFollowWithUser:(User *)curUser{
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 32)];
//    [btn configFollowBtnWithUser:curUser fromCell:NO];
//    return btn;
//}
//
//- (void)configPriMsgBtnWithUser:(User *)curUser fromCell:(BOOL)fromCell{
////    对于自己，要隐藏
//    if ([Login isLoginUserGlobalKey:curUser.global_key]) {
//        self.hidden = YES;
//        return;
//    }else{
//        self.hidden = NO;
//    }
//    
//    NSString *imageName;
//    if (curUser.followed.boolValue && !fromCell) {
//        imageName = @"btn_privateMsg_friend";
//    }else{
//        imageName = @"btn_privateMsg_stranger";
//    }
//    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}
//+ (UIButton *)btnPriMsgWithUser:(User *)curUser{
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 32)];
//    [btn configPriMsgBtnWithUser:curUser fromCell:NO];
//    return btn;
//}

@end
