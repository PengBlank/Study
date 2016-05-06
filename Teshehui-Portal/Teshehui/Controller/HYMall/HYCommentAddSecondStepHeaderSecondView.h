//
//  HYCommentAddSecondStepHeaderSecondView.h
//  Teshehui
//
//  Created by HYZB on 15/10/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCommentAddSecondStepViewController.h"

@protocol HYCommitDelegate <NSObject>

- (void)changeBtnState:(BOOL)isEnable;

@end

@interface HYCommentAddSecondStepHeaderSecondView : UIView

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *textViewNumber;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceHoldeLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic, strong) HYCommentAddSecondStepViewController<HYCommitDelegate>*delegate;


// 点亮星星数量
//@property (nonatomic, assign) NSInteger descStarNumber;
//@property (nonatomic, assign) NSInteger seviceStarNumber;
//@property (nonatomic, assign) NSInteger speedStarNumber;

- (void)setDescstarLight:(NSInteger)descStarNumber andSeviceStarLight:(NSInteger)seviceStarNumber andSpeedStarLight:(NSInteger)speedStarNumber;


@end
