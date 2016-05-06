//
//  HYPopUpView.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYPopUpDirection) {
    HYPopUpFromBottom
};

//@protocol HYPopUpViewDelegate <NSObject>
//
//
//@end

@interface HYPopUpView : UIView
{
}

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, assign) CGFloat dimAlpha;

- (instancetype)initWithSize:(CGSize)size;

@property (nonatomic, assign) HYPopUpDirection popDirection;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

//@property (nonatomic, weak) id<HYPopUpViewDelegate> delegate;

@end
