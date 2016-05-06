//
//  SlashView.h
//  Demo
//
//  Created by jonas on 9/18/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Addtion.h"

@interface SlashView : UIView
{
    UIImageView* imageView;
    int index;
    UIView* panelView;
    UIView* progressView;
    UIImageView* progressImage;
    UIButton* leftButton;
    UIButton* rightButton;
    UIImageView* wordImageView;
    BOOL prev;
    BOOL next;
    
    BOOL _is4InchScreen;
}
-(void)beginAnimate;
-(void)pauseAnimate;
-(void)resumeAnimate;
@end
