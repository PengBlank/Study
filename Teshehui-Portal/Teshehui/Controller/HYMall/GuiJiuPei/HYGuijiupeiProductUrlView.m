//
//  HYGuijiupeiProductUrlView.m
//  Teshehui
//
//  Created by Kris on 15/10/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGuijiupeiProductUrlView.h"

@interface HYGuijiupeiProductUrlView ()

@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


@end

@implementation HYGuijiupeiProductUrlView

- (instancetype)initMyNib
{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"HYGuijiupeiProductUrlView" owner:nil options:nil];

    return views.count > 0 ? views[0] : nil;
}

-(void)awakeFromNib
{
    _contentView.backgroundColor = [UIColor colorWithWhite:.94 alpha:1.0];
    _contentView.userInteractionEnabled = YES;
    _closeBtn.userInteractionEnabled = YES;
}

- (IBAction)close:(id)sender
{
    [self removeFromSuperview];
}

@end
