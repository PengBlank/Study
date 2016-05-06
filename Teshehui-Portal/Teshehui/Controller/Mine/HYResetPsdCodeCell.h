//
//  HYResetPsdCodeCell.h
//  Teshehui
//
//  Created by Kris on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2CodeCell.h"
#import "HYTextField.h"

@protocol HYResetPsdCodeCellDelegate <NSObject>

@optional
- (void)tellDelegateAuthStatus:(BOOL)status;

@end


@interface HYResetPsdCodeCell : HYBaseLineCell
{
    NSUInteger _count;
    NSTimer *_timer;
}
@property(nonatomic,strong) UILabel* nameLab;
@property(nonatomic,strong) UILabel* textLab;
@property(nonatomic,copy) NSString* mobilePhone;
@property(nonatomic,strong) HYTextField* textField;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, weak) id<HYResetPsdCodeCellDelegate> delegate;


- (void)startTiming;

@end
