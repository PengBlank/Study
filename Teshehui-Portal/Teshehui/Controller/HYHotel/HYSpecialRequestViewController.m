//
//  HYSpecialRequestViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYSpecialRequestViewController.h"

@interface HYSpecialRequestViewController ()
{
    UITextView *_textView;
}
@end

@implementation HYSpecialRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame)-20, 200)];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:15.0f];
    _textView.backgroundColor = [UIColor clearColor];
    if (_content)
    {
        _textView.text = _content;
    }
    [self.view addSubview:_textView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    [backButton setTitle:@"完成" forState:UIControlStateNormal];
    [backButton setTitleColor:self.navBarTitleColor
                     forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(complete:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = leftBarItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"special_request", nil);
    [_textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window)
    {
        [_textView removeFromSuperview];
        _textView = nil;
        
        self.view = nil;
    }
}

- (void)complete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(specialInputComplete:)])
    {
        [self.delegate specialInputComplete:_textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
