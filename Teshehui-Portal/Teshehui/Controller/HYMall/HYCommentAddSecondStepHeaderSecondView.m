//
//  HYCommentAddSecondStepHeaderSecondView.m
//  Teshehui
//
//  Created by HYZB on 15/10/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCommentAddSecondStepHeaderSecondView.h"
#import "NSString+Addition.h"

#define MAX_LIMIT_NUMS 200

@interface HYCommentAddSecondStepHeaderSecondView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *descStarbgView;
@property (weak, nonatomic) IBOutlet UIView *serviceStarbgView;
@property (weak, nonatomic) IBOutlet UIView *sppedStarbgView;
// 是否激活追加评论的提交按钮
@property (nonatomic, assign) BOOL isEnable;

@end

@implementation HYCommentAddSecondStepHeaderSecondView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    _descStarNumber = 0;
//    _seviceStarNumber = 0;
//    _speedStarNumber = 0;
    
    _commentTextView.delegate = self;
    
    self.descStarbgView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    self.serviceStarbgView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    self.sppedStarbgView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    
}

#pragma mark - ---设置点亮星星颗数---
- (void)setDescstarLight:(NSInteger)descStarNumber andSeviceStarLight:(NSInteger)seviceStarNumber andSpeedStarLight:(NSInteger)speedStarNumber
{
    NSInteger d = descStarNumber+11;
    NSInteger s = seviceStarNumber+21;
    NSInteger sp = speedStarNumber+31;
    for (NSInteger i=11; i < d; i++) {
        UIButton *descBtn = (UIButton *)[self viewWithTag:i];
        descBtn.selected = YES;
    }
    for (NSInteger j=21; j < s; j++) {
        UIButton *seviceBtn = (UIButton *)[self viewWithTag:j];
        seviceBtn.selected = YES;
    }
    for (NSInteger k=31; k < sp; k++) {
        UIButton *speedBtn = (UIButton *)[self viewWithTag:k];
        speedBtn.selected = YES;
    }

}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textViewPlaceHoldeLabel.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (result.length > 200 && ![text isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _textViewNumber.text = [NSString stringWithFormat:@"%lu/200", _commentTextView.text.length];
    if (_commentTextView.text.length > 0) {
        _isEnable = YES;
    } else {
        _isEnable = NO;
    }
    [self.delegate changeBtnState:(BOOL)_isEnable];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


#pragma mark - starClicked
#if 0
- (IBAction)descStarClicked:(UIButton *)sender {
    UIButton *btn = (UIButton *)[self viewWithTag:sender.tag];
    
    if (btn.selected == NO) {
        btn.selected = YES;
        if (btn.tag > 11) {
            for (NSInteger i=11; i < btn.tag; i++) {
                UIButton *btn = (UIButton *)[self viewWithTag:i];
                btn.selected = YES;
            }
        }
        _descStarNumber = btn.tag - 10;
        
    } else {
        
        if (btn.tag == 15) {
            btn.selected = NO;
            _descStarNumber = btn.tag - 11;
        }
        
        if (btn.tag < 15)
        {
            NSInteger t = btn.tag + 1;
            UIButton *b = (UIButton *)[self viewWithTag:t];
            if (b.selected == NO) {
                btn.selected = NO;
                _descStarNumber = (btn.tag - 10) - 1;
            } else {
                for (NSInteger i=15; i > btn.tag; i--)
                {
                    UIButton *btn = (UIButton *)[self viewWithTag:i];
                    btn.selected = NO;
                    _descStarNumber = btn.tag - 11;
                }
            }
        }
    }
}

- (IBAction)serviceStarClicked:(UIButton *)sender {
    UIButton *btn = (UIButton *)[self viewWithTag:sender.tag];
    
    if (btn.selected == NO) {
        btn.selected = YES;
        if (btn.tag > 21) {
            for (NSInteger i=21; i < btn.tag; i++) {
                UIButton *btn = (UIButton *)[self viewWithTag:i];
                btn.selected = YES;
            }
        }
        _seviceStarNumber = btn.tag - 20;
    }
    else
    {
        
        if (btn.tag == 25) {
            btn.selected = NO;
            _seviceStarNumber = btn.tag - 21;
        }
        
        if (btn.tag < 25)
        {
            NSInteger t = btn.tag + 1;
            UIButton *b = (UIButton *)[self viewWithTag:t];
            if (b.selected == NO) {
                btn.selected = NO;
                _seviceStarNumber = (btn.tag - 20) - 1;
            } else {
                for (NSInteger i=25; i > btn.tag; i--)
                {
                    UIButton *btn = (UIButton *)[self viewWithTag:i];
                    btn.selected = NO;
                    _seviceStarNumber = btn.tag - 21;
                }
            }
        }
    }
}

- (IBAction)speedStarClicked:(UIButton *)sender {
    UIButton *btn = (UIButton *)[self viewWithTag:sender.tag];
    
    if (btn.selected == NO) {
        btn.selected = YES;
        if (btn.tag > 31) {
            for (NSInteger i=31; i < btn.tag; i++) {
                UIButton *btn = (UIButton *)[self viewWithTag:i];
                btn.selected = YES;
            }
        }
        _speedStarNumber = btn.tag - 30;
    }
    else
    {
        
        if (btn.tag == 35) {
            btn.selected = NO;
            _speedStarNumber = btn.tag - 31;
        }
        
        if (btn.tag < 35)
        {
            NSInteger t = btn.tag + 1;
            UIButton *b = (UIButton *)[self viewWithTag:t];
            if (b.selected == NO) {
                btn.selected = NO;
                _speedStarNumber = (btn.tag - 30) - 1;
            } else {
                for (NSInteger i=35; i > btn.tag; i--)
                {
                    UIButton *btn = (UIButton *)[self viewWithTag:i];
                    btn.selected = NO;
                    _speedStarNumber = btn.tag - 31;
                }
            }
        }
    }
}
#endif


@end
