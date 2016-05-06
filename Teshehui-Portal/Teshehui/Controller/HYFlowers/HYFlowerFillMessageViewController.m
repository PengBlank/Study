//
//  HYFlowerFillMessageViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-9.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerFillMessageViewController.h"
#import "SAMTextView.h"
#import "NSString+Addition.h"

#define MaxLength 60

@interface HYFlowerFillMessageViewController ()<UITextViewDelegate>
{
    SAMTextView *_textView;
    UILabel *_textCountLabel;
}

@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation HYFlowerFillMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"填写留言";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat textViewHeight = self.view.frame.size.height-320;
    _textView = [[SAMTextView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.frame)-20, textViewHeight)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize: 16];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.backgroundColor = [UIColor clearColor];
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    _textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-70, textViewHeight+13, 60, 20)];
    _textCountLabel.font = [UIFont systemFontOfSize:15.0];
    _textCountLabel.text = [NSString stringWithFormat:@"0/%d", MaxLength];
    _textCountLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    _textCountLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_textCountLabel];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setFrame:CGRectMake(CGRectGetMinX(_textCountLabel.frame)-75, textViewHeight+8, 54, 30)];

    [_checkBtn setImage:[UIImage imageNamed:@"checkbox_selected"]
               forState:UIControlStateSelected];
    [_checkBtn setImage:[UIImage imageNamed:@"checkbox_unselected"]
               forState:UIControlStateNormal];
    [_checkBtn setTitle:@"署名" forState:UIControlStateNormal];
    [_checkBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_checkBtn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0]
                    forState:UIControlStateNormal];
    [_checkBtn addTarget:self
                  action:@selector(signatureSetting:)
        forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn setSelected:YES];
    [self.view addSubview:_checkBtn];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 48, 30);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [completeBtn addTarget:self
                    action:@selector(editComplete:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *_completeItem = [[UIBarButtonItem alloc] initWithCustomView:completeBtn];
    self.navigationItem.rightBarButtonItem = _completeItem;
    
    if (!self.message)
        _textView.placeholder = @"在这输入您的留言";
    else
    {
        NSInteger count = [self.message calculateCountWord];//字符个数
        if (count>MaxLength)
        {
            count = MaxLength;
            self.message = [self.message substringWithChiniseCount:MaxLength];
        }
        _textCountLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)count, MaxLength];
        _textView.text = self.message;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger count = [textView.text calculateCountWord];//字符个数
    if (count>MaxLength)
    {
        count = MaxLength;
        textView.text = [textView.text substringWithChiniseCount:MaxLength];
    }
    _textCountLabel.text = [NSString stringWithFormat:@"%ld/%d", count, MaxLength];
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSInteger count = [result calculateCountWord];
//    if (count > MaxLength)
//    {
//        return NO;
//    }
//    _textCountLabel.text = [NSString stringWithFormat:@"%ld/%d", count, MaxLength];
//    return YES;
//}

#pragma mark private methods
- (void)signatureSetting:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)editComplete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didFinishedMessage:needSig:)])
    {
        [self.delegate didFinishedMessage:_textView.text needSig:self.checkBtn.isSelected];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
