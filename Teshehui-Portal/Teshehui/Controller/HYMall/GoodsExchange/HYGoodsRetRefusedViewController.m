//
//  HYGoodsRetRefusedViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetRefusedViewController.h"

@interface HYGoodsRetRefusedViewController ()<UIActionSheetDelegate>

@end

@implementation HYGoodsRetRefusedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = self.tableView.frame;
    frame.size.height -= 44;
    self.tableView.frame = frame;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:footer];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:footer.bounds];
    bg.image = [UIImage imageNamed:@"g_ret_foot_bg.png"];
    [footer addSubview:bg];
    
    UIImage *apply = [UIImage imageNamed:@"g_ret_apply.png"];
    CGFloat x = CGRectGetMidX(footer.bounds) - apply.size.width/2;
    CGFloat y = CGRectGetMidY(footer.bounds) - apply.size.height/2;
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, apply.size.width, apply.size.height)];
    [applyBtn setTitle:@"我要维权" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [applyBtn setBackgroundImage:apply forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(connactMe:)
       forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:applyBtn];
    
    [self.view addSubview:footer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - private methods
- (void)connactMe:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"特奢汇客服竭诚为您服务"
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拨打电话 400-806-6528", nil];
    [action showInView:self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [self progressCell];
    }
    if (indexPath.row == 1) {
        return (UITableViewCell *)[self statCell];
    }
    if (indexPath.row == 2) {
        NSString *remark = self.returnsInfo.remark;
        
        NSDictionary *info = nil;
        if ([remark length] > 0)
        {
            info = [[NSDictionary alloc]initWithObjectsAndKeys:remark, @"拒绝理由", nil];
        }
        else
        {
            info = [[NSDictionary alloc]initWithObjectsAndKeys:@"无", @"拒绝理由", nil];
        }
        
        return (UITableViewCell *)[self infoCellWithInfo:info];
    }
    if (indexPath.row == 3) {
        return (UITableViewCell *)[self serviceTypeCell];
    }
    if (indexPath.row == 4) {
        return [self numCell];
    }
    if (indexPath.row == 5) {
        return (UITableViewCell *)[self detailCell];
    }
    if (indexPath.row == 6) {
        return (UITableViewCell *)[self photoCell];
    }
    if (indexPath.row == 7) {
        return (UITableViewCell *)[self warningCellWithWarning:[self warning]];
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (NSString *)warning
{
    return @"温馨提示: 您提交的退货申请卖家未同意退货, 建议您进行平台维权。";
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

@end
