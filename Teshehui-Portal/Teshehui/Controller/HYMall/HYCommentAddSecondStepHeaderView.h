//
//  HYCommentAddSecondStepHeaderView.h
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCommentAddSecondStepViewController.h"

@protocol CommentAddSecondStepHeaderViewDelegate <NSObject>

- (void)toChangeBtnState:(BOOL)isEnable;
- (void)toUpContentViewFrame;
- (void)toDownContentViewFrame;

@end

@interface HYCommentAddSecondStepHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *textNumber;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceHoldLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

// 点亮星星数量
@property (nonatomic, assign) NSInteger descStarNumber;
@property (nonatomic, assign) NSInteger seviceStarNumber;
@property (nonatomic, assign) NSInteger speedStarNumber;
@property (nonatomic, strong) HYCommentAddSecondStepViewController<CommentAddSecondStepHeaderViewDelegate>*delegate;



- (instancetype)initMyNib;

@end
