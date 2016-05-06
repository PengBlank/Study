//
//  HYLoginViewInviteCodeCell.m
//  Teshehui
//
//  Created by HYZB on 16/2/19.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYLoginViewInviteCodeCell.h"
#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"
#import "HYGetRandomInviteCodeRequest.h"
#import "HYGetRandomInviteCodeResponse.h"

@interface HYLoginViewInviteCodeCell ()
<UIAlertViewDelegate>
{
    HYGetWebLinkRequest* _linkRequest;
    HYGetRandomInviteCodeRequest *_getRandomCodeRequest;
    
    CGRect frame;
}

@end


@implementation HYLoginViewInviteCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor clearColor];
//        self.backgroundView = nil;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, CGRectGetWidth(self.contentView.frame)-40, 20)];
        textField.font = [UIFont systemFontOfSize:15.0];
        self.inviteTextField = textField;
        [self.contentView addSubview:_inviteTextField];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIButton *askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"icon_login_newask"];
        [askBtn setBackgroundImage:img forState:UIControlStateNormal];
        askBtn.frame = TFRectMake(245, 10, 20, 20);
        [askBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:askBtn];
        _askBtn = askBtn;
        
        
//        UILabel *declareLabel = [[UILabel alloc] init];
//        declareLabel.font = [UIFont systemFontOfSize:11.0f];
//        declareLabel.text = @"未注册过的手机将自动创建特奢汇账户";
//        declareLabel.textColor = [UIColor grayColor];
//        [self.contentView addSubview:declareLabel];
//        _declareLabel = declareLabel;
    }
    return self;
}

+ (HYLoginViewInviteCodeCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *inviteCodeCellID = @"inviteCodeCellID";
    HYLoginViewInviteCodeCell *inviteCodeCell = [tableView dequeueReusableCellWithIdentifier:inviteCodeCellID];
    
    if (!inviteCodeCell)
    {
        inviteCodeCell = [[HYLoginViewInviteCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inviteCodeCellID];
        inviteCodeCell.inviteTextField.placeholder = @"请输入邀请码";
        inviteCodeCell.inviteTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    inviteCodeCell.inviteTextField.tag = 202;
    
    return inviteCodeCell;
}

#pragma mark - privateMethod
- (void)btnClick:(UIButton *)sender
{
    if (!_linkRequest)
    {
        _linkRequest = [[HYGetWebLinkRequest alloc] init];
    }
    [_linkRequest cancel];
    _linkRequest.type = InviteCodeInfo;
    
    [HYLoadHubView show];
    [_linkRequest sendReuqest:^(id result, NSError *error) {
        
        if (result && [result isKindOfClass:[HYGetWebLinkResponse class]])
        {
            [HYLoadHubView dismiss];
            HYGetWebLinkResponse *response = (HYGetWebLinkResponse *)result;
            if (response.status == 200)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"邀请码是加入特奢汇的凭证" message:response.infoStr delegate:self cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"获取随机邀请码",nil];
                
                [alert show];
            }
        }
    }];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.inviteTextField.frame = CGRectMake(TFScalePoint(20), self.lineView.frame.origin.y-30, TFScalePoint(250), 20);
    self.askBtn.frame = CGRectMake(CGRectGetMaxX(self.inviteTextField.frame)+10, self.lineView.frame.origin.y-30, 20, 20);
}

- (void)setCellHeight:(CGFloat)cellHeight
{
    [super setCellHeight:cellHeight];
    
    self.inviteTextField.frame = CGRectMake(TFScalePoint(20), self.lineView.frame.origin.y-30, TFScalePoint(250), 20);
    self.askBtn.frame = CGRectMake(CGRectGetMaxX(self.inviteTextField.frame)+10, self.lineView.frame.origin.y-30, 20, 20);
}

//- (void)setupFrame
//{
//    self.lineView.frame = CGRectMake(TFScalePoint(20), self.lineView.frame.origin.y-25, TFScalePoint(280), 0.5);
//    self.inviteTextField.frame = CGRectMake(TFScalePoint(20), self.lineView.frame.origin.y-30, TFScalePoint(250), 20);
//    self.askBtn.frame = CGRectMake(CGRectGetMaxX(self.inviteTextField.frame)+10, self.lineView.frame.origin.y-30, 20, 20);
//    self.declareLabel.frame = CGRectMake(TFScalePoint(20), self.lineView.frame.origin.y+5, 198, 20);
//}


#pragma mark - alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        if (!_getRandomCodeRequest)
        {
            _getRandomCodeRequest = [[HYGetRandomInviteCodeRequest alloc]init];
        }
        [_getRandomCodeRequest cancel];
        
        [HYLoadHubView show];
        
        WS(b_self)
        [_getRandomCodeRequest sendReuqest:^(HYGetRandomInviteCodeResponse *result, NSError *error) {
            [HYLoadHubView dismiss];
            
            if (result)
            {
                b_self.inviteTextField.text = result.invteCode;
                [b_self.inviteTextField.delegate textFieldDidEndEditing:b_self.inviteTextField];
            }
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

@end
