//
//  HYMyInfoInputViewController.m
//  Teshehui
//
//  Created by HYZB on 15/12/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyInfoInputViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "NSString+Addition.h"

@interface HYMyInfoInputViewController ()<UITextFieldDelegate>
{
    UITextField *_inputField;
    UILabel *_descLab;
}

@property (nonatomic, strong) UIBarButtonItem *doneItemBar;

@end

@implementation HYMyInfoInputViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:.91f alpha:1.0f];
    self.view = view;
    
    UIView *inputBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 46)];
    inputBgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         frame.size.width,
                                                                         1.0)];
    topLine.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                               topCapHeight:0];
    [inputBgView addSubview:topLine];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                            45.0,
                                                                            frame.size.width,
                                                                            1.0)];
    bottomLine.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    [inputBgView addSubview:bottomLine];
    
    
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 24)];
    _inputField.keyboardType = UIKeyboardTypeDefault;
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.font = [UIFont systemFontOfSize:16];
    _inputField.returnKeyType = UIReturnKeyDone;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputField.delegate = self;
    [inputBgView addSubview:_inputField];
    
    [self.view addSubview:inputBgView];
    
    _descLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, frame.size.width-40, 40)];
    _descLab.backgroundColor = [UIColor clearColor];
    _descLab.font = [UIFont systemFontOfSize:14];
    _descLab.lineBreakMode = NSLineBreakByCharWrapping;
    _descLab.numberOfLines = 2;
    _descLab.textColor = [UIColor grayColor];
    [self.view addSubview:_descLab];
    
    self.navigationItem.rightBarButtonItem = self.doneItemBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (self.editType)
    {
        case NickNameEdit:
            self.title = @"修改昵称";
            _inputField.placeholder = @"请输入昵称";
            _descLab.text = @"4-12个字符，可由中英文，数字，下划线组成，1个汉子算2个字符";
            break;
        case EmailEdit:
            self.title = @"修改邮箱";
            _inputField.placeholder = @"请输入邮箱";
            _descLab.text = @"由名称（英文字母，数字，下划线），@，后缀组成";
            break;
        default:
            break;
    }
    
    if (self.text)
    {
        _inputField.text = self.text;
    }
}


#pragma mark setter/getter
- (UIBarButtonItem *)doneItemBar
{
    if (!_doneItemBar)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 40)];
        [btn setTitle:@"确定"
             forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:[UIColor grayColor]
                  forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(doneEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        _doneItemBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    
    return _doneItemBar;
}

#pragma mark private methods
- (void)checkTextVaildName:(NSString *)text err:(NSError **)err
{
    NSInteger length = [text calculateUnicharCount];
    
    if (0 == length)
    {
        *err = [NSError errorWithDomain:@"请完善昵称"
                                   code:0
                               userInfo:nil];
    }
    else if (length < 4 || length > 12)
    {
        *err = [NSError errorWithDomain:@"不正确的昵称格式"
                                   code:0
                               userInfo:nil];
    }
    else
    {
        
        NSString *regex = @"^[A-Za-z0-9_\u4e00-\u9fa5]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if (![pred evaluateWithObject:text])
        {
            *err = [NSError errorWithDomain:@"不正确的昵称格式"
                                       code:0
                                   userInfo:nil];
        }
    }
}

- (void)checkTextVaildEmail:(NSString *)text err:(NSError **)err
{
    if ([text length] > 0)
    {
        NSString *regex = @"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if (![pred evaluateWithObject:text])
        {
            *err = [NSError errorWithDomain:@"不正确的电子邮箱格式"
                                       code:0
                                   userInfo:nil];
        }
    }
    else
    {
        *err = [NSError errorWithDomain:@"请完善电子邮箱"
                                   code:0
                               userInfo:nil];
    }
}

- (void)doneEvent:(id)sender
{
    NSError *err = nil;
    _inputField.text =  [_inputField.text
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *text = _inputField.text;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    switch (self.editType)
    {
        case EmailEdit:
            [self checkTextVaildEmail:text
                                  err:&err];
            break;
        case NickNameEdit:
            [self checkTextVaildName:text
                                  err:&err];
            break;
        default:
            break;
    }
    
    if (!err)
    {
        if ([self.delegate respondsToSelector:@selector(didEditFinished:type:)])
        {
            [self.delegate didEditFinished:text
                                      type:self.editType];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                       message:err.domain
                             cancelButtonTitle:nil
                             otherButtonTitles:@[@"确定"]
                                       handler:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
