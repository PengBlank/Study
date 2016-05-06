//
//  HYPublicView.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-28.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPublicView.h"
#import "HYAddCardSubmitBackgroundView.h"
#import "HYSearchNumberCell.h"
#import "HYCardSummaryInfo.h"
#import "UIView+Style.h"
#import "UIImage+ResizableUtil.h"
#import "HYStrokeField.h"

#define kMultiPubTag 1001
#define kSinglePubTag 1002

#define textFont [UIFont systemFontOfSize:20.0]
#define textFontPhone [UIFont systemFontOfSize:14.0]

@implementation HYPublicView

+ (instancetype)instanceView
{
    NSString *name = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"HYPublicView_phone" : @"HYPublicView_pad";
    HYPublicView *view = [[[UINib nibWithNibName:name bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    return view;
}

- (void)awakeFromNib
{
    UIImage *btnbg = [UIImage imageNamed:@"order_list_select"];
    btnbg = [btnbg utilResizableImageWithCapInsets:UIEdgeInsetsMake(5, 3, 5, 23)];
    [_allSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [_allSelectBtn setBackgroundImage:btnbg forState:UIControlStateNormal];
    
    UIImage * btn_n = [UIImage imageNamed:@"orderlist_btn"];
    btn_n = [btn_n stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [_allSubmitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_allSubmitBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    
    [_singleSelectBtn setBackgroundImage:btnbg forState:UIControlStateNormal];
    [_singleSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    
    [_singleSubmitBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    
    //自动补全
    _autoCompleteWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    _autoCompleteWrapper.backgroundColor = [UIColor clearColor];
    _autoCompleteWrapper.clipsToBounds = YES;
    [_autoCompleteWrapper addBorder:1 borderColor:[UIColor grayColor]];
    [self addSubview:_autoCompleteWrapper];
    
    _autoCompleteTable = [[UITableView alloc] initWithFrame:CGRectZero];
    _autoCompleteTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _autoCompleteTable.delegate = self;
    _autoCompleteTable.dataSource = self;
    _autoCompleteTable.rowHeight = 25;
    if ([_autoCompleteTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_autoCompleteTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [_autoCompleteWrapper addSubview:_autoCompleteTable];
    
    _autoCompleteWrapper.hidden = YES;
}


- (void)resetSelectBtn
{
    [_allSelectBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_allSelectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_singleSelectBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_singleSelectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)layoutTextField:(BOOL)move
{
    float offset = 0;
    
    BOOL ispad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        offset = 64;
    }
    
    if (move)
    {
        if (_activeField == _numberField &&
            isLandscape)
        {
            offset = -100;
        }
        if (_activeField == _numberField &&
            !ispad)
        {
            offset = -150;
        }
        if (_activeField == _toField && !ispad)
        {
            offset = -50;
        }
        if (_activeField == _toField && ispad && isLandscape)
        {
//            offset = -100;
        }
    }
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         CGRect frame = self.frame;
         frame.origin.y = offset;
         self.frame = frame;
     } completion:nil];
}

- (void)keyboardHide
{
    [self layoutTextField:NO];
    
    _activeField = nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[self showAutoCompleteTableWithField:textField];
    _activeField = textField;
    [self layoutTextField:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[self showAutoCompleteTableWithField:textField];
    
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < result.length; i++) {
        unichar c = [result characterAtIndex:i];
        if (![set characterIsMember:c])
        {
            return NO;
        }
    }
    if (result.length != 0)
    {
        if (textField == _fromField)
        {
            NSString *toNumber = _toField.noSpaceText;
            if ([self.delegate respondsToSelector:@selector(didGetNumber:endNumber:)])
            {
                [self.delegate didGetNumber:result endNumber:toNumber];
            }
        }
        else if (textField == _toField)
        {
            NSString *fromNumber = _fromField.noSpaceText;
            if ([self.delegate respondsToSelector:@selector(didGetNumber:endNumber:)])
            {
                [self.delegate didGetNumber:fromNumber endNumber:result];
            }
        }
        else if (textField == _numberField)
        {
            //[self searchWithNumber:fromNumber endNumber:result withField:textField];
            [self.delegate didGetSigleNumber:result];
        }
    }
    else
    {
        //[self hideAutoCompleteField];
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideAutoCompleteField];
    self.searchNumbers = nil;
    //[self layoutTextField:NO];
}

#pragma mark AutoCompleteTable
- (void)showAutoCompleteTableWithField:(UITextField *)field
{
    float height = 0;
    float maxh = 150;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGRect f = [self.window convertRect:field.frame fromView:field.superview];
        maxh = CGRectGetHeight(self.window.frame) - CGRectGetMaxY(f) - 216;
    }
    if (self.searchNumbers.count > 0)
    {
        height = self.searchNumbers.count * 25;
        height = height > maxh ? maxh : height;
    }
    CGRect tframe = [self convertRect:field.frame fromView:field.superview];
    CGRect frame = CGRectMake(CGRectGetMinX(tframe), CGRectGetMaxY(tframe), CGRectGetWidth(tframe) + 20, height);
    _autoCompleteWrapper.frame = frame;
    _autoCompleteTable.frame = _autoCompleteWrapper.bounds;
    
    if (_autoCompleteWrapper.hidden)
    {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = .25;
        [_autoCompleteWrapper.layer addAnimation:animation forKey:nil];
        _autoCompleteWrapper.hidden = NO;
    }
}

- (void)hideAutoCompleteField
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = .25;
    [_autoCompleteWrapper.layer addAnimation:animation forKey:nil];
    _autoCompleteWrapper.hidden = YES;
}

- (void)setNumberSearchResult:(NSArray *)numbers
{
    self.searchNumbers = numbers;
    [self showAutoCompleteTableWithField:_activeField];
    [self.autoCompleteTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"autoComplete";
    HYSearchNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[HYSearchNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (indexPath.row < self.searchNumbers.count)
    {
        id cardInfo = [self.searchNumbers objectAtIndex:indexPath.row];
        NSString *number;
        if ([cardInfo isKindOfClass:[NSDictionary class]]) {
            number = [cardInfo objectForKey:@"number"];
        } else if ([cardInfo isKindOfClass:[HYCardSummaryInfo class]]) {
            number = [cardInfo number];
        }
        cell.numberLabel.text = number;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.searchNumbers.count)
    {
        id cardInfo = [self.searchNumbers objectAtIndex:indexPath.row];
        NSString *number;
        if ([cardInfo isKindOfClass:[NSDictionary class]]) {
            number = [cardInfo objectForKey:@"number"];
        } else if ([cardInfo isKindOfClass:[HYCardSummaryInfo class]]) {
            number = [cardInfo number];
        }
        if (_activeField)
        {
            _activeField.text = number;
            [_activeField resignFirstResponder];
            [self hideAutoCompleteField];
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_autoCompleteWrapper.hidden == NO)
    {
        CGPoint location = [gestureRecognizer locationInView:self.autoCompleteWrapper];
        if (CGRectContainsPoint(_autoCompleteWrapper.bounds, location))
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)getNumber:(NSString *__autoreleasing *)number
{
    NSString *t = _numberField.noSpaceText;
    if (t.length > 0)
    {
        *number = t;
    }
}

- (void)getNumber:(NSString *__autoreleasing *)number endNumber:(NSString *__autoreleasing *)endNumber
{
    NSString *t = _fromField.noSpaceText;
    NSString *d = _toField.noSpaceText;
    if (t.length > 0)
    {
        *number = t;
    }
    if (d.length > 0)
    {
        *endNumber = d;
    }
}

- (void)resetNumber
{
    _fromField.text = nil;
    _toField.text = nil;
    _numberField.text = nil;
}

- (void)setAgencyName:(NSString *)agencyName
{
    if (_agencyName != agencyName)
    {
        _agencyLbl.text = agencyName;
        _agency2Label.text = agencyName;
        _agencyName = agencyName;
    }
}

- (void)setTitleName1:(NSString *)titleName1
{
    if (_titleName1 != titleName1)
    {
        _titleLab1.text = titleName1;
    }
}

- (void)setTitleName2:(NSString *)titleName2
{
    if (_titleName2 != titleName2)
    {
        _titleLab2.text = titleName2;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
