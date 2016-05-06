//
//  HYCIQuoteDeclarationViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQuoteDeclarationViewController.h"
#import "HYCIGetDeclarationRequest.h"
#import "HYCIGetDeclarationResponse.h"

@interface HYCIQuoteDeclarationViewController ()

@property (nonatomic, strong) HYCIGetDeclarationRequest *request;

@end

@implementation HYCIQuoteDeclarationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投保声明";
    [self getStatement];
}

- (void)getStatement
{
    if (!_request)
    {
        _request = [[HYCIGetDeclarationRequest alloc] init];
    }
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_request sendReuqest:^(id result, NSError *error)
    {
        [b_self updateWithResponse:result error:error];
    }];
}

- (void)updateWithResponse:(HYCIGetDeclarationResponse*)response error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (!error)
    {
        NSString *statement = response.statement;
        CGSize size = [statement sizeWithFont:self.contentLabel.font
                            constrainedToSize:CGSizeMake(CGRectGetWidth(self.contentLabel.frame), 2000)];
        CGRect frame = self.contentLabel.frame;
        frame.size.height = size.height;
        self.contentLabel.frame = frame;
        self.contentLabel.text = statement;
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame),
                                                 size.height + 2*CGRectGetMinY(self.contentLabel.frame));
    }
    else
    {
        
    }
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

@end
