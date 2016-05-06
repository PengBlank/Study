//
//  DownMenuView.m
//  DownMenu
//
//  Created by apple_administrator on 15/9/1.
//  Copyright (c) 2015年 Tkun. All rights reserved.
//

#define kTableViewCellHeight 44
#define kTableViewHeight g_fitFloat(@[@300,@400,@450])

#import "DownMenuView.h"
#import "DefineConfig.h"
#import "categoryInfo.h"
#import "categoryCell.h"
#import "SubCategoryCell.h"
#import "UIColor+hexColor.h"

@interface DownMenuView ()
{
    NSMutableArray  *_categoryDateSource;
    NSMutableArray  *_secondItemSoruce;
    NSMutableArray  *_sortItemSoruce;
    
    NSInteger       _leftIndex;
    NSInteger       _rightIndex;
    NSObject       *_tmpObj;
}
@property (nonatomic, strong) UIView                    *backgroundView;
@property (nonatomic, strong) UIButton                  *backgroundBtn;
@property (nonatomic, strong) UIImageView               *buttomImageView; // 底部imageView
@property (nonatomic, strong) UIView                    *baseView;
@property (nonatomic, assign) BOOL                      isRefresh;
@property (nonatomic, assign) BOOL                      isSelectAll;

@property (nonatomic, copy)   TopicListViewHideBlock    hiddenblock;
@end

@implementation DownMenuView

- (instancetype)initWithFrame:(CGRect)frame hiddenBlock:(TopicListViewHideBlock)block;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _hiddenblock = block;
        
        _categoryDateSource = [[NSMutableArray alloc] init];
        _secondItemSoruce = [[NSMutableArray alloc] init];
         _sortItemSoruce = [[NSMutableArray alloc] initWithObjects:@"离我最近",@"最新发布",nil];
        _buttomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 ,kScreen_Width, 21)];
        _buttomImageView.image = [UIImage imageNamed:@"icon_chose_bottom"];
        [self addSubview:_buttomImageView];
        

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationHideCategoryMenuItem object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChange) name:kNotificationHideCategoryMenuItem object:nil];
}

//- (void)willRemoveSubview:(UIView *)subview{
//    
//    [super willRemoveSubview:subview];
//    
//}

- (void)notificationChange{
    [self dismiss];
}


- (void)initCategoryTable{
    
    if (self.leftTableView == nil) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGRect tmpRect = CGRectMake(0, 0, bounds.size.width, self.frame.size.height);
        self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, tmpRect.size.height) style:UITableViewStylePlain];
        self.leftTableView.delegate  = self;
        self.leftTableView.dataSource = self;
        self.leftTableView.backgroundColor = [UIColor colorWithHexColor:@"f3f3f3" alpha:1];
        self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.leftTableView.tableFooterView = [[UIView alloc] init];
    
        [self addSubview:self.leftTableView];
    }
    
    if (self.rightableView == nil) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGRect tmpRect = CGRectMake(0, 0, bounds.size.width, self.frame.size.height);
        self.rightableView = [[UITableView alloc]initWithFrame:CGRectMake(100, 0, bounds.size.width - 100, tmpRect.size.height) style:UITableViewStylePlain];
        self.rightableView.delegate  = self;
        self.rightableView.dataSource = self;
        self.rightableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rightableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:self.rightableView];
    }
}

- (void)initSortTable{
    if (self.sortTableView == nil) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGRect tmpRect = CGRectMake(0, 0, bounds.size.width, self.frame.size.height);
        self.sortTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, tmpRect.size.height) style:UITableViewStylePlain];
        self.sortTableView.delegate  = self;
        self.sortTableView.dataSource = self;
        self.sortTableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:self.sortTableView];
    }
}


- (void)bindData:(NSMutableArray *)objArray index:(NSInteger)index;{
    _categoryType = index;
    [_categoryDateSource removeAllObjects];
    [_categoryDateSource addObjectsFromArray:objArray];
    
    if (_categoryDateSource.count != 0) {
        
        if (index == 0) {
             categoryInfo *cInfo = [_categoryDateSource firstObject];
            _tmpObj = cInfo;
            [_secondItemSoruce removeAllObjects];
             [_secondItemSoruce addObjectsFromArray:cInfo.SubCategorys];
        }else if (index == 1){
            cityInfo *cInfo = [_categoryDateSource firstObject];
            _tmpObj = cInfo;
            [_secondItemSoruce removeAllObjects];
            [_secondItemSoruce addObjectsFromArray:cInfo.SubAdress];
        }
    }

    if (index != 2 && _categoryDateSource.count != 0) {
        [self.leftTableView reloadData];
        [self.rightableView reloadData];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        [self.sortTableView reloadData];
    }
    
}

- (void)showInView:(UIView *)view index:(NSInteger)index
{
    _categoryType = index;
    _baseView = view;
    
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setTag:100];
//        [_backgroundView setFrame:CGRectMake(0, kNavBarHeight + 44, kScreen_Width  , kScreen_Height - 44)];
        [_backgroundView setFrame:CGRectMake(0, 44 + 35 + kNavBarHeight, kScreen_Width  , kScreen_Height)];
        [_backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];

    }
    
    if (_backgroundBtn == nil) {
        _backgroundBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backgroundBtn setTag:101];
        [_backgroundBtn setBackgroundColor:[UIColor clearColor]];
        [_backgroundBtn setFrame:_backgroundView.bounds];
        [_backgroundBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
  
    [_backgroundView addSubview:_backgroundBtn];
    [_backgroundView addSubview:self];
    [view addSubview:_backgroundView];

    if (index != 2) {
        

        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        NSInteger rightNum = [_rightableView numberOfRowsInSection:0];
        if(num < rightNum){
            num = rightNum;
        }
        
        CGFloat tableViewHeight = num * kTableViewCellHeight > kTableViewHeight ? kTableViewHeight:num*kTableViewCellHeight;
         self.isShow = YES;
        [UIView animateWithDuration:0.3f animations:^{
         
            [self setFrame:CGRectMake(0, 0, kScreen_Width, tableViewHeight + 18)];
            [_buttomImageView setFrame:CGRectMake(0, self.frame.size.height - 21, kScreen_Width, 18)];
            [self.leftTableView setFrame:CGRectMake(0, 0, kScreen_Width, tableViewHeight)];
            [self.rightableView setFrame:CGRectMake(100, 0, kScreen_Width - 100,tableViewHeight)];
            
        } completion:^(BOOL finished) {
           
        }] ;
        
    }else{
        
        NSInteger num = [_sortTableView numberOfRowsInSection:0];
        CGFloat tableViewHeight = num * kTableViewCellHeight > kTableViewHeight ? kTableViewHeight:num*kTableViewCellHeight;
        
        [UIView animateWithDuration:0.4f animations:^{
            [self setFrame:CGRectMake(0, 0, kScreen_Width, tableViewHeight + 18)];
            [_buttomImageView setFrame:CGRectMake(0, self.frame.size.height - 21, kScreen_Width, 18)];
            [self.sortTableView setFrame:CGRectMake(0, 0, kScreen_Width, tableViewHeight)];
            
        } completion:^(BOOL finished) {
            self.isShow = YES;
        }];
    }
}

- (void)dismiss{
    
    if ([self superview]) {
        _isRefresh = NO;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _backgroundView.alpha  = 0;
            [self setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            [_buttomImageView setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            [self.leftTableView setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            [self.rightableView setFrame:CGRectMake(100, 0, kScreen_Width - 100, 0)];
            [self.sortTableView setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            
        } completion:^(BOOL finished) {
            self.isShow = NO;
            [_backgroundView removeFromSuperview];
            [_backgroundBtn removeFromSuperview];
            _backgroundView = nil;
            _backgroundBtn = nil;
            if (self.hiddenblock) {
                self.hiddenblock();
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationHideCategoryMenuItem object:nil];
        }];
        
    }
}

- (void)hidenView{
    
    if ([self superview]) {
        _isRefresh = NO;

        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _backgroundView.alpha  = 0;
            [self setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            [_buttomImageView setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            [self.leftTableView setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            [self.rightableView setFrame:CGRectMake(100, 0, kScreen_Width - 100, 0)];
            [self.sortTableView setFrame:CGRectMake(0, 0, kScreen_Width, 0)];
            
        } completion:^(BOOL finished) {
            self.isShow = NO;
            [_backgroundView removeFromSuperview];
            [_backgroundBtn removeFromSuperview];
            _backgroundView = nil;
            _backgroundBtn = nil;
            if (self.hiddenblock) {
                self.hiddenblock();
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationHideCategoryMenuItem object:nil];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _leftTableView) {
        return _categoryDateSource.count + 1;
    }else if (tableView == _rightableView){
        return _isSelectAll ? 0 : _secondItemSoruce.count + 1;
    }else{
        return _sortItemSoruce.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_categoryType != 2) {
        
        
        if (tableView == _leftTableView) {
            static NSString *ID = @"categoryCell";
            categoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell = [[categoryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:ID];
                [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
                cell.textLabel.textColor = [UIColor colorWithHexColor:@"666666" alpha:1.0];
            }
            
            if (indexPath.row == 0) {
                if (_categoryType == 0) {
                    cell.textLabel.text = @"全部分类";
                }else if (_categoryType == 1){
                     cell.textLabel.text = @"全城";
                }
                cell.merchantCountLabel.text = nil;
            }else{
                
                if (_categoryType == 0) {
                    categoryInfo *cInfo = _categoryDateSource[indexPath.row - 1];
                    cell.textLabel.text = cInfo.Name;
                    cell.merchantCountLabel.text = nil;
                }else if (_categoryType == 1){
                    cityInfo *cInfo = _categoryDateSource[indexPath.row - 1];
                    cell.textLabel.text = cInfo.Name;
                    cell.merchantCountLabel.text = nil;
                }
            }
            
            return cell;
            
        }else{
            static NSString *ID = @"sub";
            SubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil)
            {
                cell = [[SubCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:ID];
            }
            
            if (indexPath.row == 0) {
                if (!_isSelectAll) {
                    cell.titleLabel.text = @"全部";
                    cell.merchantCountLabel.text = nil;

                }else{
                    cell.titleLabel.text = nil;
                    cell.merchantCountLabel.text = nil;
                }
            }else{

                if (_categoryType == 0) {
                    categoryInfo *cInfo = _secondItemSoruce[indexPath.row - 1];
                    cell.titleLabel.text = _isSelectAll ? @"" : cInfo.Name;
                   
                    if (!_isSelectAll) {
                        cell.merchantCountLabel.text = [NSString stringWithFormat:@"%@",@(cInfo.MerchantCount)];
 
                    }else{
                        cell.merchantCountLabel.text = nil;
                    }
                }else if (_categoryType == 1){
                    cityInfo *cInfo = _secondItemSoruce[indexPath.row - 1];
                    cell.titleLabel.text = _isSelectAll ? @"" : cInfo.Name;
                    cell.merchantCountLabel.text = nil;

                }
            }
            return cell;
        }
        
    }
    static NSString *cellID = @"cellID";
    SubCategoryCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SubCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text = _sortItemSoruce[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        if (_categoryType == 1) {
            
            if (indexPath.row == 0) {
                _isSelectAll = YES;
                [_rightableView reloadData];
                if (_delegate && [_delegate respondsToSelector:@selector(selectedRowWithIndx:)]) {
                    [_delegate selectedRowWithIndx:indexPath.row];
                }
            }else{
                 _isSelectAll = NO;
                cityInfo *cInfo= _categoryDateSource[indexPath.row - 1];
                _tmpObj = cInfo;
                [_secondItemSoruce removeAllObjects];
                [_secondItemSoruce addObjectsFromArray:cInfo.SubAdress];
                [_rightableView reloadData];
            }

        }else if (_categoryType == 0){
            
            if (indexPath.row == 0) {
                _isSelectAll = YES;
                [_rightableView reloadData];
                if (_delegate && [_delegate respondsToSelector:@selector(selectedRowWithIndx:)]) {
                    [_delegate selectedRowWithIndx:indexPath.row];
                }
            } else {
                 _isSelectAll = NO;
                categoryInfo *cInfo= _categoryDateSource[indexPath.row - 1];
                _tmpObj = cInfo;
                [_secondItemSoruce removeAllObjects];
                [_secondItemSoruce addObjectsFromArray:cInfo.SubCategorys];
                [_rightableView reloadData];
            }
        }
      
    }else if(tableView == self.rightableView){
     
        if (indexPath.row == 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(selectedRowWithObj:isAll:)]) {
                [_delegate selectedRowWithObj:_tmpObj isAll:YES];
            }
        }else{
            if (_categoryType == 0) {
                categoryInfo *cInfo = _secondItemSoruce[indexPath.row - 1];
                if (_delegate && [_delegate respondsToSelector:@selector(selectedRowWithObj:)]) {
                    [_delegate selectedRowWithObj:cInfo];
                }
            }else if (_categoryType == 1){
                cityInfo *cInfo = _secondItemSoruce[indexPath.row - 1];
                if (_delegate && [_delegate respondsToSelector:@selector(selectedRowWithObj:)]) {
                    [_delegate selectedRowWithObj:cInfo];
                }
            }

        }
       
    }else if(tableView == self.sortTableView){
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedRowWithItem:)]) {
            [_delegate selectedRowWithItem:_sortItemSoruce[indexPath.row]];
        }
    }
}

- (void)dealloc{
   // [self removeFromSuperview];
}


@end
