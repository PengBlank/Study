//
//  HYCIOrderDetailViewController.m
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIOrderDetailViewController.h"
#import "HYCITableViewConfirmExpandCell.h"
#import "HYCITableViewConfirmDetailCell.h"

@interface HYCIOrderDetailViewController ()
<UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYCIOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"投保确认";
    
    self.view.backgroundColor = [UIColor colorWithWhite:.97 alpha:1];
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableFooterView = [self tableFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewConfirmExpandCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"expandCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"inputCell"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table
#pragma mark - tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }
    else if (section == 1)
    {
        return 5;
    }
    else
    {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 5)];
    UIImageView *_lineView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, CGRectGetMaxY(header.bounds)-1, CGRectGetWidth(header.frame), 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [header addSubview:_lineView];
    return header;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 55;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HYCITableViewConfirmExpandCell *expandCell = [tableView dequeueReusableCellWithIdentifier:@"expandCell"];
        switch (indexPath.section)
        {
            case 0:
                expandCell.nameLab.text = @"被保人信息";
                break;
            case 1:
                expandCell.nameLab.text = @"车辆信息";
                break;
            case 2:
                expandCell.nameLab.text = @"保单信息";
                break;
            default:
                break;
        }
        expandCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return expandCell;
    }
    else
    {
        //详细信息
        HYCITableViewConfirmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!detailCell)
        {
            detailCell = [[HYCITableViewConfirmDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"detailCell"];
        }
        switch (indexPath.section)
        {
            case 0:
                [self configureRecipiCell:detailCell withIndexPath:indexPath];
                break;
            case 1:
                [self configureCarinfoCell:detailCell withIndexPath:indexPath];
                break;
            case 2:
                [self configurePolicyCell:detailCell withIndexPath:indexPath];
                break;
                break;
            default:
                break;
        }
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailCell;
    }
}

- (void)configureRecipiCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    HYCIPersonInfo *insuredInfo = self.order.insuredInfo;
    switch (path.row)
    {
        case 1:
            cell.textLabel.text = @"姓名:";
            cell.detailTextLabel.text = insuredInfo.name;
            break;
        case 2:
            cell.textLabel.text = @"手机号:";
            cell.detailTextLabel.text = insuredInfo.mobilephone;
            break;
        case 3:
            cell.textLabel.text = @"证件类型:";
            cell.detailTextLabel.text = @"身份证";
            break;
        case 4:
            cell.textLabel.text = @"证件号码:";
            cell.detailTextLabel.text = insuredInfo.idCardNo;
            break;
        case 5:
            cell.textLabel.text = @"电子邮箱";
            cell.detailTextLabel.text = insuredInfo.email;
            break;
        default:
            break;
    }
}

- (void)configureCarinfoCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    HYCICarInfo *insuredInfo = self.order.carInfo;
    switch (path.row)
    {
        case 1:
            cell.textLabel.text = @"车牌号:";
            cell.detailTextLabel.text = insuredInfo.licenseNo;
            break;
        case 2:
            cell.textLabel.text = @"登记日期:";
            cell.detailTextLabel.text = insuredInfo.firstRegisterDate;
            break;
        case 3:
            cell.textLabel.text = @"发动机号:";
            cell.detailTextLabel.text = insuredInfo.vehicleFrameNo;
            break;
        case 4:
            cell.textLabel.text = @"厂牌型号:";
            cell.detailTextLabel.text = insuredInfo.vehicleModelName;
            break;
        default:
            break;
    }
}

- (void)configurePolicyCell:(HYCITableViewConfirmDetailCell *)cell withIndexPath:(NSIndexPath *)path
{
    
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
