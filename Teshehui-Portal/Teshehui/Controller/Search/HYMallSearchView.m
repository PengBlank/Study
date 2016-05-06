//
//  HYMallSearchView.m
//  Teshehui
//
//  Created by HYZB on 16/3/31.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallSearchView.h"

@interface HYMallSearchView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchv;


@end


@implementation HYMallSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UITextField *search = [[UITextField alloc] init];
    _search = search;
    search.delegate = self;
    [search addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [search addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    [search addTarget:self action:@selector(textFieldBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:search];
    search.clearButtonMode = UITextFieldViewModeWhileEditing;
    search.layer.borderWidth = 0.5;
    search.layer.borderColor = [UIColor colorWithWhite:.83 alpha:0.6].CGColor;
    search.layer.cornerRadius = 4.0;
    search.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [_search becomeFirstResponder];
    
    UIImage *img = [UIImage imageNamed:@"i_search"];
    UIImageView *searchv = [[UIImageView alloc] initWithImage:img];
    _searchv = searchv;
    searchv.contentMode = UIViewContentModeCenter;
    searchv.frame = CGRectMake(0, 0, 30, 30);
    search.leftView = searchv;
    search.leftViewMode = UITextFieldViewModeAlways;
    search.returnKeyType = UIReturnKeySearch;
}

- (void)layoutSubviews
{
    _search.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    
    _searchv.frame = CGRectMake(0, 0, 30, 30);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *key = textField.text;
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self.delegate respondsToSelector:@selector(searchWithKey:)])
    {
        if (key.length > 0)
        {
            [self.delegate searchWithKey:key];
        }
        else
        {
            self.search.text = _search.placeholder;
            [self.delegate searchWithKey:_search.placeholder];
        }
    }
    
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField
{
    NSString *result = textField.text;
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (result.length > 0)
    {
        if ([self.delegate respondsToSelector:@selector(getSuggestWithString:)])
        {
            [self.delegate getSuggestWithString:result];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(hiddenSuggestController)])
        {
            [self.delegate hiddenSuggestController];
        }
    }
}

- (void)textFieldEndEdit:(UITextField *)text
{
    if ([self.delegate respondsToSelector:@selector(hiddenSuggestview)])
    {
        [self.delegate hiddenSuggestview];
    }
}

- (void)textFieldBeginEdit:(UITextField *)field
{
    if ([self.delegate respondsToSelector:@selector(filterViewControllerIsShow)])
    {
        [self.delegate filterViewControllerIsShow];
    }
}

@end
