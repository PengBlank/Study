//
//  HYCommentAddSecondStepHeaderView.m
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCommentAddSecondStepHeaderView.h"

#import "NSString+Addition.h"

#define MAX_LIMIT_NUMS 200

@interface HYCommentAddSecondStepHeaderView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *descStarBGView;
@property (weak, nonatomic) IBOutlet UIView *serviceStarBGView;
@property (weak, nonatomic) IBOutlet UIView *speedStarBGView;
// 是否激活评论提交按钮
@property (nonatomic, assign) BOOL isEnable;


@end

@implementation HYCommentAddSecondStepHeaderView

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initMyNib
{
    NSArray *subViews = [[NSBundle mainBundle]
                         loadNibNamed:@"HYCommentAddSecondStepHeaderView" owner:nil options:nil];
    if (subViews.count > 0)
    {
        return subViews[0];
    }
    else
    {
        return nil;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _descStarNumber = 0;
    _seviceStarNumber = 0;
    _speedStarNumber = 0;
    
    
    _descTextView.delegate = self;
    
    self.descStarBGView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    self.serviceStarBGView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    self.speedStarBGView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(beginDesc) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow
{
    if ([[UIScreen mainScreen] bounds].size.height < 667) {
        [self.delegate toUpContentViewFrame];
    }
}

- (void)keyboardWillHide
{
    if ([[UIScreen mainScreen] bounds].size.height < 667) {
        [self.delegate toDownContentViewFrame];
    }
}


#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textViewPlaceHoldLabel.hidden = YES;
    
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
    _textNumber.text = [NSString stringWithFormat:@"%ld/200", _descTextView.text.length];
    
    [self isChangeCommentCommitBtnState];
}

//- (void)beginDesc
//{
//    
//    _textNumber.text = [NSString stringWithFormat:@"%ld/200", _descTextView.text.length];
//
//    _textViewPlaceHoldLabel.hidden = YES;
//    [self isChangeCommentCommitBtnState];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - starClicked
- (IBAction)descStarClicked:(UIButton *)sender
{
    
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
    [self isChangeCommentCommitBtnState];
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
    [self isChangeCommentCommitBtnState];
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
    [self isChangeCommentCommitBtnState];
}

#pragma mark - ----判断需不需要改变控制器导航栏的提交按钮状态----
- (void)isChangeCommentCommitBtnState
{
    if (_descTextView.text.length > 0 && _descStarNumber > 0 && _seviceStarNumber > 0 && _speedStarNumber > 0) {
        _isEnable = YES;
    } else {
        _isEnable = NO;
    }
    [self.delegate toChangeBtnState:_isEnable];
}

@end
