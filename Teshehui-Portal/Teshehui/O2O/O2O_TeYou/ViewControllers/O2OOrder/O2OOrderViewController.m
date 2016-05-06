//
//  O2OOrderViewController.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "O2OOrderViewController.h"
#import "O2OOrderCell.h"

#import "UIColor+expanded.h"

#import "BusinessOrderViewController.h" // 实体店订单
#import "SceneOrderViewController.h"    // 场景订单
#import "TravelOrdelViewController.h"   // 旅游订单
#import "BilliardOrderViewController.h" // 桌球订单


@interface O2OOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    NSArray *_nameArray; // 标题数组
    NSArray *_imageArray; // 图片名
}
@end

static NSString *cellId = @"cellId";

@implementation O2OOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠商家订单";
    _nameArray = @[@[@"实体店订单",@"场景订单"],@[@"桌球订单"],@[@"旅游订单"]];
    _imageArray = @[@[@"ico_entityshoporder",@"ico_senceorder"],@[@"ico_tabletennis"],@[@"ico_travel"]];
    
    [self createUI];
    
}
#pragma mark - 创建UI
- (void)createUI
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.scrollEnabled = NO;
    [_myTableView registerNib:[UINib nibWithNibName:@"O2OOrderCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:_myTableView];
}

#pragma mark - UITableView Delegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    O2OOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSString *title = _nameArray[indexPath.section][indexPath.row];
    NSString *imageName = _imageArray[indexPath.section][indexPath.row];
    [cell refreshUIWithImage:imageName Title:title IndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.00001;
    }
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            // 实体店订单
            BusinessOrderViewController *tmpCtrl = [[BusinessOrderViewController alloc] init];
            [self.navigationController pushViewController:tmpCtrl animated:YES];
        }else
        {// 场景订单
            SceneOrderViewController *vc = [[SceneOrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1)
    {// 桌球订单
        BilliardOrderViewController *tmpCtrl = [[BilliardOrderViewController alloc] init];
        [self.navigationController pushViewController:tmpCtrl animated:YES];
    }else if (indexPath.section == 2)
    {// 旅游
        TravelOrdelViewController *tmpCtrl = [[TravelOrdelViewController alloc] init];
        [self.navigationController pushViewController:tmpCtrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
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
