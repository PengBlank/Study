//
//  HYRPPasswordRecvViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPPasswordRecvViewController.h"
#import "UIImage+Addition.h"
#import "HYRecvRedpacketReq.h"
#import "HYLoadHubView.h"
#import "HYRedpacketDetailViewController.h"
#import "HYRPRecvFailedResultViewController.h"

@interface HYRPPasswordRecvViewController ()<UITextFieldDelegate>
{
    UITextField *_psdTF;
    UIButton *_recvBtn;
    
    HYRecvRedpacketReq *_request;
    
    BOOL _isLoading;
}
@end

@implementation HYRPPasswordRecvViewController

- (void)dealloc
{
    [_request cancel];
    _request = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    _isLoading = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _psdTF.text = nil;
    [_psdTF becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        if (textField.text.length <= 1)
        {
            [_recvBtn setEnabled:NO];
        }
        
        return YES;
    }
    
    //过滤非数字
//    string = [string stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])];
    [_recvBtn setEnabled:(textField.text.length + string.length > 0)];
    
    if ([textField.text length] >= 8)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark private methods
- (void)initView
{
    self.title = @"红包特令";
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //bgView.contentMode = UIViewContentModeTop;
    bgView.image = [UIImage imageWithNamedAutoLayout:@"t_teling"];
    [self.view addSubview:bgView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:TFRectMake(80, 40, 160, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.text = @"输入特令";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:title];

    _psdTF = [[UITextField alloc] initWithFrame:TFRectMake(37, 90, 246, 77)];
    _psdTF.keyboardType = UIKeyboardTypeNumberPad;
    _psdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _psdTF.font = [UIFont boldSystemFontOfSize:40];
    _psdTF.returnKeyType = UIReturnKeyDone;
    _psdTF.textAlignment = NSTextAlignmentCenter;
    _psdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _psdTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _psdTF.background = [[UIImage imageWithNamedAutoLayout:@"t_teling_input"] stretchableImageWithLeftCapWidth:50
                                                                                                  topCapHeight:0];
    _psdTF.delegate = self;
    [self.view addSubview:_psdTF];
    
    _recvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recvBtn setFrame:TFRectMake(37, 190, 246, 42)];
    [_recvBtn setTitle:@"芝麻开门"
              forState:UIControlStateNormal];
    [_recvBtn setTitleColor:[UIColor colorWithRed:113.0/255.0
                                            green:0
                                             blue:0.0/255.0
                                            alpha:1.0]
                   forState:UIControlStateNormal];
    [_recvBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_teling_btn"] stretchableImageWithLeftCapWidth:20
                                                                                                         topCapHeight:0]
                        forState:UIControlStateNormal];
    [_recvBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"t_teling_btn_d"] stretchableImageWithLeftCapWidth:20
                                                                                                           topCapHeight:0]
                        forState:UIControlStateHighlighted];
    [_recvBtn addTarget:self
                 action:@selector(recvRedpacket:)
       forControlEvents:UIControlEventTouchUpInside];
    [_recvBtn setEnabled:NO];
    [self.view addSubview:_recvBtn];
    
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapAction)];
    [self.view addGestureRecognizer:editTap];
}

- (void)editTapAction
{
    [self.view endEditing:YES];
}

- (void)recvRedpacket:(id)sender
{
    if ([_psdTF.text length] > 0 && !_isLoading)
    {
        [HYLoadHubView show];
        _request = [[HYRecvRedpacketReq alloc] init];
        _request.luck_password = _psdTF.text;
        _isLoading = YES;
        __weak typeof(self) b_self = self;
        
        [_request sendReuqest:^(CQBaseResponse* result, NSError *error)
         {
             [HYLoadHubView dismiss];
             _isLoading = NO;
             
             HYRecvRedpacketResp *resp = (HYRecvRedpacketResp *)result;
             
             if (result && result.status == 200)
             {
                 HYRedpacketDetailViewController *vc = [[HYRedpacketDetailViewController alloc] initWithNibName:@"HYRedpacketDetailViewController" bundle:nil];
                 vc.redpacket = resp.packetInfo;
                 vc.isRecvPacket = YES;
                 [b_self.navigationController pushViewController:vc
                                                        animated:YES];
             }
             else
             {
                 if (result.status == 201 ||
                     result.status == 202 ||
                     result.status == 203)
                 {
                     HYRPRecvFailedResultViewController *vc = [[HYRPRecvFailedResultViewController alloc] initWithNibName:@"HYRPRecvFailedResultViewController" bundle:nil];
                     vc.redpacket = resp.packetInfo;
                     vc.redpacket.recv_status = result.status;
                     vc.recv = resp.recv;
                     [b_self.navigationController pushViewController:vc
                                                            animated:YES];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:error.domain
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
             }
         }];
    }
}

@end
