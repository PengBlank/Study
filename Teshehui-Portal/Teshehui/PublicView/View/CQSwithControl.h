//
//  CQSwithControl.h
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQSwithControl : UIControl

@property (nonatomic, assign) BOOL on;
@property (nonatomic, copy) NSString *offText;
@property (nonatomic, copy) NSString *onText;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *offColor;

@property (nonatomic, strong) UIImage *knobImage;
@property (nonatomic, strong) UIImage *bgImage;

/*
 * Set whether the switch is on or off. Optionally animate the change
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

/*
 *	Detects whether the switch is on or off
 *
 *	@return	BOOL YES if switch is on. NO if switch is off
 */
- (BOOL)isOn;

@end
