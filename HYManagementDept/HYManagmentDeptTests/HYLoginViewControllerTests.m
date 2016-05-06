//
//  HYLoginViewControllerTests.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HYLoginViewController.h"
#import "HYLoginView.h"
#import <OCMock/OCMock.h>

@interface HYLoginViewControllerTests : XCTestCase

@end

@implementation HYLoginViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadView
{
    HYLoginViewController *c = [[HYLoginViewController alloc] init];
    [c view];
    XCTAssertNotNil(c, @"c is nili");
    XCTAssertNotNil(c.view, @"view is nil");
    
    HYLoginView *v = (HYLoginView *)c.view;
    XCTAssert(v.nameField.delegate == c, @"");
    XCTAssert(v.passField.delegate == c, @"");
    
    XCTAssert([v.rememberPassBtn.allTargets containsObject:c], @"");
    XCTAssert([v.rememberNameBtn.allTargets containsObject:c], @"");
}

- (void)testEditingAction
{
    HYLoginViewController *c = [[HYLoginViewController alloc] init];
    [c loadView];
    id v_m = [OCMockObject partialMockForObject:c.view];
    OCMExpect([v_m endEditing:YES]);
    SEL edit = NSSelectorFromString(@"editingTapAction:");
    [c performSelector:edit];
    OCMVerifyAll(v_m);
}

- (void)testRecognizerShouldBegin
{
    BOOL result;
    HYLoginViewController *c = [[HYLoginViewController alloc] init];
    result = [c gestureRecognizerShouldBegin:nil];
    XCTAssertEqual(result, NO, @"");
    
    UIGestureRecognizer *g = [[UIGestureRecognizer alloc] init];
    result = [c gestureRecognizerShouldBegin:g];
    XCTAssertEqual(result, NO, @"");
    
    g = [c valueForKey:@"editingTap"];
    BOOL edi = [[c valueForKey:@"_isEditing"] boolValue];
    result = [c gestureRecognizerShouldBegin:g];
    XCTAssertEqual(result, edi, @"");
}

- (void)testKeyboardWillShow
{
    HYLoginViewController *c = [[HYLoginViewController alloc] init];
    id c_m = OCMPartialMock(c);
    [[c_m expect] getAppropriateOffset];
    //[[c_m expect] xMoveViewWithOffset:[[OCMArg any]floatValue]];
    [[[c_m expect] ignoringNonObjectArgs] xMoveViewWithOffset:0];
    [c setValue:[NSNumber numberWithBool:NO] forKey:@"_isEditing"];
    
    [c_m keyboardWillShow:nil];
    
    BOOL edi = [[c valueForKey:@"_isEditing"]  boolValue];
    XCTAssertEqual(edi, YES, @"");
    [c_m verify];
}

- (void)testKeyboardWillHide
{
    HYLoginViewController *c = [[HYLoginViewController alloc] init];
    id c_m = OCMPartialMock(c);
    [[c_m expect] getAppropriateOffset];
    //[[c_m expect] xMoveViewWithOffset:[[OCMArg any]floatValue]];
    [[[c_m expect] ignoringNonObjectArgs] xMoveViewWithOffset:0];
    [c setValue:[NSNumber numberWithBool:YES] forKey:@"_isEditing"];
    
    [c_m keyboardWillHide:nil];
    
    BOOL edi = [[c valueForKey:@"_isEditing"]  boolValue];
    XCTAssertEqual(edi, NO, @"");
    [c_m verify];
}

@end
