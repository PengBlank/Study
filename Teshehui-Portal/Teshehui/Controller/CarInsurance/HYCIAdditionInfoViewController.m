//
//  HYCIAdditionInfoViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/1.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCIAdditionInfoViewController.h"
#import "HYCIFillCarInfoCell.h"
#import "HYCITableViewSelectCell.h"
#import "HYCICarInfo.h"
#import "HYCICarBrandListViewController.h"
#import "HYCIQuoteViewController.h"
#import "METoast.h"
#import "NSDate+Addition.h"

#import "HYDatePickerView.h"
#import "HYPickerToolView.h"
#import "HYLoadHubView.h"

@interface HYCIAdditionInfoViewController ()
<HYPickerToolViewDelegate,
HYDatePickerViewDelegate,
HYCIFillCarInfoCellDelegate,
HYCICarBrandListViewControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYPickerToolView *pickerView;
@property (nonatomic, strong) HYDatePickerView *datePickerView;

@end

@implementation HYCIAdditionInfoViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_pickerView dismissWithAnimation:YES];
    [_datePickerView dismissWithAnimation:YES];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:251.0/255.0
                                           green:251.0/255.0
                                            blue:251.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    if (CheckIOS7)
    {
        [tableview setSeparatorInset:UIEdgeInsetsMake(0, 2, 0, 2) ];
    }
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"信息补录";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"inputCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCITableViewSelectCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"selectCell"];
    
    {
        UIView * _footerView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(0, 0, 320, 60)];
        
        
        UIButton * nextBtn = [[UIButton alloc] initWithFrame:
                        CGRectMake(CGRectGetMidX(self.view.bounds)-85, 10, 170, 35)];
        [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[[UIImage imageNamed:@"ci_btn_on"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 2, 5, 2)]
                                forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[[UIImage imageNamed:@"ci_btn_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 2, 5, 2)]
                                forState:UIControlStateDisabled];
        [nextBtn addTarget:self
                         action:@selector(nextEvent)
               forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:nextBtn];
        
        self.tableView.tableFooterView = _footerView;
    }
    
    self.navigationItem.leftBarButtonItem = self.backItemBar;
}

- (void)backToRootViewController:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextEvent
{
    if (self.additionInputCallback)
    {
        self.additionInputCallback(self.additionInfoList);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HYPickerToolViewDelegate
- (void)selectComplete:(HYPickerToolView *)pickerView
{
    if (pickerView.tag < [_additionInfoList count])
    {
        NSString *str = [pickerView.dataSouce objectAtIndex:pickerView.currentIndex];
        HYCICarInfoFillType *type = [self.additionInfoList objectAtIndex:pickerView.tag];
        type.value = str;
        [self.tableView reloadData];
    }
}

#pragma mark - HYDatePickerViewDelegate
- (void)didSelectDate:(NSDate *)date
{
    if (self.datePickerView.tag < [self.additionInfoList count])
    {
        HYCICarInfoFillType *type = [self.additionInfoList objectAtIndex:self.datePickerView.tag];
        type.value = [date timeDescription];
        [self.tableView reloadData];
    }
}

#pragma mark setter/getter
- (HYPickerToolView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[HYPickerToolView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 260)];
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (HYDatePickerView *)datePickerView
{
    if (!_datePickerView)
    {
        _datePickerView = [[HYDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 260)];
        _datePickerView.delegate = self;
    }
    
    return _datePickerView;
}

#pragma mark - HYCICarBrandListViewControllerDelegate
- (void)didSelectCarBrandType:(HYCICarBrandInfo *)brandTypeInfo
{
    for (HYCICarInfoFillType *type in self.additionInfoList)
    {
        if ([type.name isEqualToString:@"vehicleModelName"])  //品牌ß
        {
            type.value = brandTypeInfo.typeDescription;
        }
        else if ([type.name isEqualToString:@"vehicleId"])
        {
            type.value = brandTypeInfo.typeCode;
        }
    }
    
    [self.tableView reloadData];
}

- (void)didTextInputNext:(NSInteger)nextIndex
{
    while (nextIndex<[self.additionInfoList count])
    {
        HYCICarInfoFillType *type = [self.additionInfoList objectAtIndex:nextIndex];
        if (type.inputType.intValue == 10)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:nextIndex];
            HYCIFillCarInfoCell *cell = (HYCIFillCarInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.inputTF becomeFirstResponder];
            
            break;
        }
        
        nextIndex++;
    }
}

- (void)didEidtCheckStatus:(BOOL)checked
{
    if (!checked)
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.additionInfoList];
        for (HYCICarInfoFillType *type in tempArr)
        {
            if ([type.name isEqualToString:@"specialCarDate"]) //不显示过户日期
            {
                type.value = nil;
                [tempArr removeObject:type];
                break;
            }
        }
        
        self.additionInfoList = [tempArr copy];
    }
    else
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.additionInfoList];
        for (HYCICarInfoFillType *type in self.additionInfoList)
        {
            if ([type.name isEqualToString:@"specialCarDate"]) //不显示过户日期
            {
                type.value = nil;
                [tempArr addObject:type];
                break;
            }
        }
        
        self.additionInfoList = [tempArr copy];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.additionInfoList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fillCarInfoCellId = @"fillCFarInfoCellId";
    
    HYCIFillCarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fillCarInfoCellId];
    
    if (!cell)
    {
        cell = [[HYCIFillCarInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:fillCarInfoCellId];
        cell.delegate = self;
    }
    
    //处理下一项的问题
    cell.tag = indexPath.section;
    
    if (indexPath.section < [self.additionInfoList count])
    {
        HYCICarInfoFillType *type = [self.additionInfoList objectAtIndex:indexPath.section];
        [cell setInfoType:type];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [self.additionInfoList count])
    {
        HYCICarInfoFillType *type = [self.additionInfoList objectAtIndex:indexPath.section];
        switch (type.inputType.integerValue)
        {
                
            case 21:  //下拉
                [self.view endEditing:YES];
                self.pickerView.tag = indexPath.section;
                [self.pickerView setDataSouce:[type inputValueList]];
                [self.pickerView showWithAnimation:YES];
                break;
            case 40:  //日期
                [self.view endEditing:YES];
                self.datePickerView.tag = indexPath.section;
                [self.datePickerView showWithAnimation:YES];
                break;
            case 100:  //品牌搜索
            {
                [self.view endEditing:YES];
                HYCICarBrandListViewController *vc = [[HYCICarBrandListViewController alloc] init];
                vc.delegate = self;
//                vc.keyWord = self.vichelSearchKey;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
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
