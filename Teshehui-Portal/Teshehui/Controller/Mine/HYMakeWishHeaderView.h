//
//  HYMakeWIshHeaderView.h
//  Teshehui
//
//  Created by HYZB on 15/11/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMakeWishHeaderViewDelegate <NSObject>

- (void)confirmBtnSetting;

@end

@interface HYMakeWishHeaderView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UILabel *namePlaceHolderLab;
@property (nonatomic, strong) UILabel *nameTextViewNumberLab;
@property (weak, nonatomic) IBOutlet UIView *nameBottomView;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *descPlaceHolderLab;
@property (nonatomic, strong) UILabel *descTextViewNumberLab;
@property (weak, nonatomic) IBOutlet UIView *descBottomView;

@property (nonatomic, weak) id <HYMakeWishHeaderViewDelegate>delegate;

@end
