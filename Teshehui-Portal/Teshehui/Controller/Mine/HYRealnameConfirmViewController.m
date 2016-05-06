//
//  HYRealnameConfirmViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRealnameConfirmViewController.h"
#import "HYLoginV2InputCell.h"
#import "HYRealNameConfirmReq.h"
#import "HYRealNameResponse.h"
#import "HYLoginV2InputCell.h"
#import "METoast.h"
#import "HYRealnameProtocolViewController.h"

@interface HYRealnameConfirmViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>
{
    HYRealNameConfirmReq *_confirmReq;
    
    BOOL _agreeInsurance;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *idNum;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation HYRealnameConfirmViewController

- (void)dealloc
{
    [_confirmReq cancel];
    _confirmReq = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"实名登记";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0f];
    
    CGRect bounds = [UIScreen mainScreen].bounds;

    //tableview
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.frame = CGRectMake(0, 10, bounds.size.width, TFScalePoint(96));
    _tableview.sectionFooterHeight = 10;
    _tableview.sectionHeaderHeight = 10;
    _tableview.rowHeight = TFScalePoint(48);
    [_tableview registerClass:[HYLoginV2InputCell class] forCellReuseIdentifier:@"input"];
    
    //button
    [_checkbox setImage:[UIImage imageNamed:@"infoofmine_checkBox2"] forState:UIControlStateNormal];
//    [_checkbox setImage:[UIImage imageNamed:@"infoofmine_checkBox2"] forState:UIControlStateSelected];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"我已阅读并同意用户协议" ];
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(7, 4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, 4)];
    [_checkbox setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_checkbox setAttributedTitle:attrStr forState:UIControlStateNormal];
    [_checkbox addTarget:self action:@selector(jumpToProtocol:) forControlEvents:UIControlEventTouchUpInside];
    _checkbox.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(13.0f)];
    _checkbox.frame = CGRectMake(5, TFScalePoint(110), 200, 30);
    _checkbox.selected = YES;
    
//    UIButton *protocol = [UIButton buttonWithType:UIButtonTypeCustom];
//    [protocol addTarget:self action:@selector(jumpToProtocol) forControlEvents:UIControlEventTouchUpInside];
//    protocol.frame = CGRectMake(170, 0, 30, 30);
//    [_checkbox addSubview:protocol];
    
    UIImage *image = [[UIImage imageNamed:@"myinfo_saveBtn"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    [_confirmBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(toConfirm) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(14)];
    _confirmBtn.frame = CGRectMake(TFScalePoint(20), CGRectGetMaxY(_checkbox.frame)+TFScalePoint(10), TFScalePoint(280), 40);
}

#pragma mark  tableview deleage
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        HYLoginV2InputCell *input = [tableView dequeueReusableCellWithIdentifier:@"input" forIndexPath:indexPath];
        input.textLabel.text = @"真实姓名";
        input.textField.delegate = self;
        input.textField.tag = 101;
        return input;
    }else
    {
        HYLoginV2InputCell *input = [tableView dequeueReusableCellWithIdentifier:@"input" forIndexPath:indexPath];
        input.textLabel.text = @"身份证号码";
        input.textField.delegate = self;
        input.textField.tag = 102;
        return input;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark private methods
- (void)toConfirm
{
    [self.view endEditing:YES];
    
    if (!_isLoading)
    {
        NSString* str;
        BOOL isOk = YES;
        if ([_realname length] <= 0 ) {
            str = @"真实姓名不能为空";
            isOk = NO;
        }
        else if ([_idNum length]<=0)
        {
            str = @"证件号码不能为空";
            isOk = NO;
        }
        
        if (isOk)
        {
            _isLoading = YES;
            if (!_confirmReq)
            {
                _confirmReq = [[HYRealNameConfirmReq alloc] init];
            }
            _confirmReq.realName = _realname;
            _confirmReq.certificateNumber = _idNum;
            [HYLoadHubView show];
            __weak typeof(self) b_self = self;
            [_confirmReq sendReuqest:^(id result, NSError *error) {
                [HYLoadHubView dismiss];
                if (result && [result isKindOfClass:[HYRealNameResponse class]])
                {
                    HYRealNameResponse *response = (HYRealNameResponse *)result;
                    if (200 == response.status)
                    {
                        [METoast toastWithMessage:@"实名登记成功" andCompleteBlock:^{
                            [b_self.navigationController popViewControllerAnimated:YES];
                            if ([b_self.delegate respondsToSelector:@selector(updateUserInfo)])
                            {
                                [b_self.delegate updateUserInfo];
                            }
                        }];
                    }else
                    {
                        [METoast toastWithMessage:response.suggestMsg];
                    }
                }
                b_self.isLoading = NO;
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:str
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
}

#pragma mark - text delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = UIReturnKeyDone;
    switch (textField.tag) {
        case 102:
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            self.realname = textField.text;
            break;
        case 102:
            self.idNum = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10 && buttonIndex!= alertView.cancelButtonIndex)
    {
        [self checkProtocol:nil];
    }
}

#pragma mark private methods
-(void)checkProtocol:(id)sender
{
//    HYCheckInsuranceViewController *vc = [[HYCheckInsuranceViewController alloc] init];
//    vc.delegate = self;
//    vc.isAgree = _agreeInsurance;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didAgreeInsurance
{
    _agreeInsurance = YES;
    [_checkbox setSelected:YES];
}

- (void)jumpToProtocol:(UIButton *)sender
{
    sender.selected = YES;
    
    if (sender.selected)
    {
        HYRealnameProtocolViewController *vc = [HYRealnameProtocolViewController new];
        vc.title = @"用户协议";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
