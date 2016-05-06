//
//  HYProductFilterViewController.m
//  Teshehui
//
//  Created by HYZB on 15/1/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductFilterViewController.h"
#import "HYProductFilterCell.h"
#import "HYProductFilterSectionView.h"
#import "HYProductFilterPriceCell.h"
#import "HYKeyboardHandler.h"

@interface HYProductFilterViewController ()
<UITableViewDelegate,
UITableViewDataSource,
HYMallFullOrderSectionDelegate,
UITextFieldDelegate,
HYKeyboardHandlerDelegate>

@property (nonatomic, retain) UITableView* menuTableView;

@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation HYProductFilterViewController

- (void)dealloc
{
    [_keyboardHandler stopListen];
}

- (void)loadView
{
    CGRect frame = ScreenRect;
    frame.origin.y = self.layoutOffset ? 64 : 0;
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFScalePoint(16), self.contentView.bounds.size.height)];
    leftView.backgroundColor = [UIColor blackColor];
   
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(4),
                                                                           (self.contentView.bounds.size.height-TFScalePoint(8))/2,
                                                                           TFScalePoint(6),
                                                                           TFScalePoint(8))];
    imageView.image = [UIImage imageNamed:@"i_sx_r"];
    [leftView addSubview:imageView];
    
    [self.contentView addSubview:leftView];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    // 列表
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(16,
                                                                       0,
                                                                       self.contentView.bounds.size.width-16,
                                                                       self.contentView.bounds.size.height-44)];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.menuTableView.separatorColor = [UIColor colorWithWhite:0.6 alpha:1.0];
//    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.menuTableView registerNib:[UINib nibWithNibName:@"HYProductFilterPriceCell" bundle:nil] forCellReuseIdentifier:@"priceCell"];
    [self.contentView addSubview:self.menuTableView];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuTableView.frame.size.width, 44)];
//    headerView.backgroundColor = [UIColor colorWithRed:247.0/255.0
//                                                 green:247.0/255.0
//                                                  blue:247.0/255.0
//                                                 alpha:1.0];
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 12, 100, 20)];
//    titleLab.font = [UIFont systemFontOfSize:18];
//    titleLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.backgroundColor = [UIColor clearColor];
//    titleLab.text = @"筛选";
//    [headerView addSubview:titleLab];
//    
//    self.menuTableView.tableHeaderView = headerView;
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(16, self.contentView.bounds.size.height-44, self.menuTableView.frame.size.width, 44)];
//    toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    toolView.backgroundColor = [UIColor greenColor];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setFrame:CGRectMake(0, 0, self.menuTableView.frame.size.width/2, 44)];
    [resetBtn setBackgroundColor:[UIColor colorWithRed:235.0/255.0
                                                   green:155.0/255.0
                                                    blue:40.0/255.0
                                                   alpha:1.0]];
    [resetBtn setTitle:@"重置"
                forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [resetBtn addTarget:self
                   action:@selector(resetEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:resetBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(self.menuTableView.frame.size.width/2,
                                 0,
                                 self.menuTableView.frame.size.width/2,
                                 44)];
    [doneBtn setTitle:@"确定"
                        forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:[UIColor colorWithRed:216.0/255.0
                                                           green:42.0/255.0
                                                            blue:46.0/255.0
                                                           alpha:1.0]];
    [doneBtn setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [doneBtn addTarget:self
                           action:@selector(doneEvent:)
                 forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneBtn];
    [self.contentView addSubview:toolView];
//    self.contentView.clipsToBounds = YES;
    
    self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
    [self.keyboardHandler startListen];
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

- (void)resetEvent:(id)sender
{
    self.filterData.cateIndex = -1;
    self.filterData.brandIndex = -1;
    self.filterData.selectedCategory = nil;
    self.filterData.parentCategory = nil;
    self.filterData.selectedBrand = nil;
    self.filterData.maxPrice = nil;
    self.filterData.minPrice = nil;
    [self.menuTableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(didUpdateFilterCondition:)])
    {
        [self.delegate didUpdateFilterCondition:self.filterData];
    }
}

- (void)doneEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didFilterSettingFinished:)])
    {
        [self.delegate didFilterSettingFinished:self.filterData];
    }
}

- (void)didUpdateCondition
{
    if ([self.delegate respondsToSelector:@selector(didUpdateFilterCondition:)])
    {
        [self.delegate didUpdateFilterCondition:self.filterData];
    }
}

#pragma mark setter/getter
- (void)setFilterData:(HYProductFilterDataManeger *)filterData
{
    if (filterData != _filterData)
    {
        _filterData = filterData;
        _filterData.maxWidth = self.contentView.bounds.size.width-20;
        _filterData.textFont = [UIFont systemFontOfSize:14];
    }
    
    [self.menuTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_filterData indexedSections] length];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isExpand = [_filterData sectionIsExpanded:indexPath.section];
    NSInteger index = [[_filterData indexedSections] indexAtPosition:indexPath.section];
    if (index == 0)
    {
        if ([self.filterData heightForBrandsItem] > 90)
        {
            return isExpand ? [self.filterData heightForBrandsItem] : 90;
        }
        else
        {
            return [self.filterData heightForBrandsItem];
        }
    }
    else if (index == 1)
    {
        if ([self.filterData heightForCatesItem] > 90)
        {
            return isExpand ? [self.filterData heightForCatesItem] : 90;
        }
        else
        {
            return [self.filterData heightForCatesItem];
        }
    }
    else
    {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sidebarMenuCellIdentifier = @"sidebarMenuCellIdentifier";
    HYProductFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
    if(!cell)
    {
        cell = [[HYProductFilterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:sidebarMenuCellIdentifier];
    }
    
    [cell setMaxWidth:self.filterData.maxWidth];
    [cell setTextFont:self.filterData.textFont];
    
    __weak typeof(self) bself = self;
    NSIndexPath *indexedSection = [_filterData indexedSections];
    if (indexPath.section < indexedSection.length)
    {
        NSInteger index = [indexedSection indexAtPosition:indexPath.section];
        if (0 == index)  //品牌
        {
            cell.currSelectIndex = self.filterData.brandIndex;
            cell.curSelectItem = nil;
            [cell setItems:[self.filterData brandTitles]];
            
            cell.indexChange = ^ (NSInteger index){
                bself.filterData.brandIndex = index;
                [bself didUpdateCondition];
            };
        }
        else if (1 == index)  //分类
        {
            cell.currSelectIndex = self.filterData.cateIndex;
            cell.curSelectItem = self.filterData.selectedCategory.cate_name;
            
            [cell setItems:[self.filterData cateTitles]];
            cell.indexChange = ^ (NSInteger index){
                bself.filterData.cateIndex = index;
                [bself didUpdateCondition];
            };
        }
        else if (2 == index)
        {
            HYProductFilterPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
            cell.minField.delegate = self;
            cell.maxField.delegate = self;
            cell.minField.tag = 100;
            cell.maxField.tag = 101;
            cell.minField.keyboardType = UIKeyboardTypeNumberPad;
            cell.maxField.keyboardType = UIKeyboardTypeNumberPad;
            cell.minField.text = _filterData.minPrice;
            cell.maxField.text = _filterData.maxPrice;
            self.textField = cell.minField;
            return cell;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 0;
    }
    
    return 20;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    footerView.backgroundColor = [UIColor colorWithRed:247.0/255.0
                                                 green:247.0/255.0
                                                  blue:247.0/255.0
                                                 alpha:1.0];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HYProductFilterSectionView *headerView = [[HYProductFilterSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.delegate = self;
    headerView.tag = section;
    headerView.isExpend = [_filterData sectionIsExpanded:section];
    
    NSIndexPath *indexedSection = [_filterData indexedSections];
    if (indexedSection.length > section)
    {
        NSInteger index = [indexedSection indexAtPosition:section];
        switch (index)
        {
            case 0:
                headerView.title = self.filterData.brandInfo.attributeName;
                break;
            case 1:
                headerView.title = @"分类";
                break;
            case 2:
                headerView.title = @"价格";
                break;
            default:
                break;
        }
    }
    
    return headerView;
}

/**
 *  点击header回调
 *
 *  @param section
 */
- (void)didExpandCellWithSection:(NSInteger)section
{
    [_filterData reverseSectionExpand:section];
    [self.menuTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self autoShowHideSidebar];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - text
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.keyboardHandler.inputView = textField;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.keyboardHandler.inputView = textField;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100)
    {
        _filterData.minPrice = textField.text;
    }
    else if (textField.tag == 101)
    {
        _filterData.maxPrice = textField.text;
    }
}

//- (void)keyboardChangeFrame:(CGRect)kFrame
//{
//    
//    [self.menuTableView setContentOffset:CGPointMake(0, 500) animated:YES];
//}

- (void)inputView:(UIView *)inputView willCoveredWithOffset:(CGFloat)offset
{
    CGPoint contentOffset = self.menuTableView.contentOffset;
    contentOffset.y += offset + 74;
    [self.menuTableView setContentOffset:contentOffset animated:YES];
}

- (void)didHide
{
    [self.keyboardHandler stopListen];
    if ([self.delegate respondsToSelector:@selector(sideDidHide)]) {
        [self.delegate sideDidHide];
    }
}

- (void)sidebarDidShown
{
    [self.keyboardHandler startListen];
    if ([self.delegate respondsToSelector:@selector(sideDidShow)]) {
        [self.delegate sideDidShow];
    }
}

@end
