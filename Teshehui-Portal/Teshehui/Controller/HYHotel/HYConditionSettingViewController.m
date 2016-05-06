//
//  HYConditionSettingViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYConditionSettingViewController.h"
#import "HYHotelConditionLeftCell.h"
#import "HYHotelConditionRightCell.h"

#import "HYHotelDistrictInfo.h"
#import "HYHotelCommercialInfo.h"
#import "HYHotelDistance.h"

#define LEFTTABLETAG   10
#define RIGHTTABLETAG   11

@interface HYConditionSettingViewController ()
{
    NSInteger _leftIndex;
    NSInteger _rightIndex;
    
    NSInteger _selectedIdx;    //已选中对象，可能是distance等等。。
}

@property (nonatomic, strong) UITableView *lTableView;
@property (nonatomic, strong) UITableView *rTableView;

@property (nonatomic, strong) NSArray *lDataSource;
@property (nonatomic, strong) NSArray *rDataSource;

@end

@implementation HYConditionSettingViewController

- (IBAction)backToRootViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _leftIndex = 0;
        _rightIndex = 0;
        _viewType = HotelConditionCommercial|
        HotelConditionDistrict|
        HotelConditionDistance;
    }
    
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:223.0f/255.0f
                                           green:223.0f/255.0f
                                            blue:223.0f/255.0f
                                           alpha:1.0f];
    self.view = view;
    
    //tableview
    CGRect lTabelFrame = CGRectMake(0, 0, 120, frame.size.height);
    UITableView *lt = [[UITableView alloc] initWithFrame:lTabelFrame
                                                          style:UITableViewStylePlain];
	lt.delegate = self;
	lt.dataSource = self;
    lt.tag = LEFTTABLETAG;
    lt.separatorStyle = UITableViewCellSeparatorStyleNone;
    lt.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    lt.scrollEnabled = NO;
    [self.view addSubview:lt];
    self.lTableView = lt;
    
    CGRect rTabelFrame = CGRectMake(120, 0, CGRectGetWidth(self.view.frame)-120, frame.size.height);
    UITableView *rt = [[UITableView alloc] initWithFrame:rTabelFrame
                                                   style:UITableViewStylePlain];
	rt.delegate = self;
	rt.dataSource = self;
    rt.tag = RIGHTTABLETAG;
    rt.separatorStyle = UITableViewCellSeparatorStyleNone;
    rt.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rt];
    self.rTableView = rt;
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 45, 320, 45)];
//    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 290, 35)];
//    UIImage *bg = [UIImage imageNamed:@"person_buttom_orange1_normal.png"];
//    bg = [bg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//    [submit setBackgroundImage:bg forState:UIControlStateNormal];
//    [submit setTitle:@"确定" forState:UIControlStateNormal];
//    submit.titleLabel.textColor = [UIColor whiteColor];
//    submit.titleLabel.font = [UIFont systemFontOfSize:18.0];
//    [submit addTarget:self
//               action:@selector(submitAction:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:submit];
//    
//    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    gray.backgroundColor = [UIColor lightGrayColor];
//    [footerView addSubview:gray];
//    
//    [self.view addSubview:footerView];
    
}

//- (void)submitAction:(UIButton *)btn
//{
//    //[self.condition m_commit];
//    [self.navigationController popViewControllerAnimated:YES];
//    if ([self.delegate respondsToSelector:@selector(didSelectCondition:type:)])
//    {
//        [self.delegate didSelectCondition:self.condition type:self.viewType];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"筛选";
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ConditionType)selectedType
{
//    return typeOfViewTypesAtIndex(_viewType, _leftIndex);
    int i = 0;
    int idx = 0;
    while (i < 7 && idx <= _leftIndex)
    {
        if (_viewType & (1 << i)) {
            if (idx == _leftIndex) {
                break;
            }
            idx ++;
        }
        i++;
    }
    return (1 << i);
}

//- (void)setCondition:(HYHotelCondition *)condition
//{
//    _condition = condition;
//    //[_condition m_begin_edit];
//}

#pragma mark - private methods
- (void)loadDataSource
{
    //价格星级的条件列表
    self.lDataSource = [self.condition getConditionListWithType:self.viewType];
    self.rDataSource = [self.condition getSubConditionListWithType:[self selectedType]];
    
    switch ([self selectedType])
    {
        case HotelConditionDistance:
            _selectedIdx = self.condition.distance.index;
            break;
        case HotelConditionCommercial:
            _selectedIdx = self.condition.commercialIndex;
            break;
        case HotelConditionDistrict:
            _selectedIdx = self.condition.districtIndex;
            break;
        default:
            _selectedIdx = -1;
            break;
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == _lTableView)
    {
        count = [self.lDataSource count];
    }
    else
    {
        count = [self.rDataSource count];
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _lTableView)
    {
        static NSString *leftCellId = @"leftCellId";
        HYHotelConditionLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellId];
        if (cell == nil)
        {
            cell = [[HYHotelConditionLeftCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:leftCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.hiddenLine = YES;
        }
        
        BOOL select = (indexPath.row == _leftIndex);
        [cell setCheck:select];
        
        if (indexPath.row < [self.lDataSource count])
        {
            NSString *string = [self.lDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = string;
        }
        
        return cell;
    }
    else
    {
        static NSString *rightCellId = @"rightCellId";
        HYHotelConditionRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellId];
        if (cell == nil)
        {
            cell = [[HYHotelConditionRightCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:rightCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.hiddenLine = YES;
        }
        
        [cell setCheck:(indexPath.row == _selectedIdx)];
        
        if (indexPath.row < [self.rDataSource count])
        {
            id obj = [self.rDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = [self displayForObject:obj];
        }
        
        return cell;
    }
}

- (NSString *)displayForObject:(id)obj
{
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *string = (NSString *)obj;
        return string;
    }
    else if ([obj isKindOfClass:[HYHotelDistrictInfo class]])
    {
        HYHotelDistrictInfo *h = (HYHotelDistrictInfo *)obj;
        return h.name;
    }
    else if ([obj isKindOfClass:[HYHotelCommercialInfo class]])
    {
        HYHotelCommercialInfo *h = (HYHotelCommercialInfo *)obj;
        return h.name;
    }
    else if ([obj isKindOfClass:[HYHotelDistance class]])
    {
        HYHotelDistance *h = (HYHotelDistance *)obj;
        return h.distanceDesc;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _lTableView)
    {
        _rightIndex = 0;
        
        if (_leftIndex != indexPath.row)
        {
            _leftIndex = indexPath.row;
            
            [self loadDataSource];
            [self.lTableView reloadData];
            [self.rTableView reloadData];
        }
    }
    else
    {
        _rightIndex = indexPath.row;
        
        //更新选中的条件
        [self.condition selectConditionType:[self selectedType] atIndex:_rightIndex];
        
        
        //[tableView reloadData];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(didSelectCondition:type:)])
        {
            [self.delegate didSelectCondition:self.condition type:self.viewType];
        }
    }
}

@end
