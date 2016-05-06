//
//  HYMessageViewController.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMessageViewController.h"
#import "HYGetMessageRequest.h"
#import "HYGetMessageResponse.h"
#import "HYMessageCell.h"
#import "HYMessageInfo.h"
#import "HYLoadHubView.h"

#define pageSize @"10"
@interface HYMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    HYGetMessageRequest* _GetMessageRequest;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recommendList;

@property(nonatomic,assign) NSInteger page;

@end

@implementation HYMessageViewController

-(void)dealloc
{
    [_GetMessageRequest cancel];
    _GetMessageRequest = nil;
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page = 1;
	
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:tableview];
    [self.view addSubview:tableview];
    
    self.tableView = tableview;
    _recommendList = [[NSMutableArray alloc]initWithCapacity:0];
    [self getHomePageList];
}

-(void)getHomePageList
{
    if (!_GetMessageRequest)
    {
        _GetMessageRequest = [[HYGetMessageRequest alloc] init];
    }
    
    _GetMessageRequest.page = [NSString stringWithFormat:@"%ld",_page];
    _GetMessageRequest.num_per_page = pageSize;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_GetMessageRequest sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        if (result && [result isKindOfClass:[HYGetMessageResponse class]])
        {
            HYGetMessageResponse *response = (HYGetMessageResponse *)result;
            NSArray *array = response.MessageArray;
            [b_self.recommendList addObjectsFromArray:array];
            [b_self.tableView reloadData];
        }
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommendList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HYMessageCell"];
    if (cell == nil) {
        cell = [[HYMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HYMessageCell"];
    }
    HYMessageInfo* info = [_recommendList objectAtIndex:indexPath.row];
    [cell setList:info];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMessageInfo* info = [_recommendList objectAtIndex:indexPath.row];
    CGSize titleSize = [info.content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                constrainedToSize:CGSizeMake(TFScalePoint(300), MAXFLOAT)
                                    lineBreakMode:NSLineBreakByCharWrapping];
    return titleSize.height+30;
}


@end
