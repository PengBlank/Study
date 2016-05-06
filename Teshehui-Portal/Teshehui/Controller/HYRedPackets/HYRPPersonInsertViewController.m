//
//  HYRPPersonInsertViewController.m
//  Teshehui
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPPersonInsertViewController.h"
#import "UIImage+Addition.h"
#import "HYRedPacketNormalSendViewController.h"
#import "HYCheckIsMemberReq.h"

@interface HYRPPersonInsertViewController ()
<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIButton *completeBtn;
@property (nonatomic, weak) IBOutlet UITextField *nameField;

@property (nonatomic, strong) HYCheckIsMemberReq *checkRequest;

@end

@implementation HYRPPersonInsertViewController

- (void)dealloc
{
    [_checkRequest cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"输入手机号码";
    
    UIImage *btn = [[UIImage imageNamed:@"redpacket_index_btn.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIImage *btn_d = [[UIImage imageNamed:@"redpacket_index_btn_d.png"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.completeBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [self.completeBtn setBackgroundImage:btn_d forState:UIControlStateHighlighted];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completeAction:(id)sender
{
    NSString *name = self.nameField.text;
    NSString *err = nil;
    if (name.length <= 0)
    {
        err = @"请输入对方的手机号码";
    }
    if (err) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.checkRequest = [[HYCheckIsMemberReq alloc] init];
    self.checkRequest.type = @"1";
    self.checkRequest.user_name = name;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [self.checkRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            HYRedPacketNormalSendViewController *vc = [[HYRedPacketNormalSendViewController alloc] initWithNibName:@"HYRedPacketNormalSendViewController" bundle:nil];
            vc.mob_phone = name;
            [b_self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (result.length > 11 && ![string isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
