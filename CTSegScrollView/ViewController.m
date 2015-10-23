//
//  ViewController.m
//  CTSegScrollView
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "ViewController.h"
#import "CTSegScrollView.h"

@interface ViewController ()<CTSegScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 44)];
    titleLabel.text = @"消息";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:88.0f/255.0f green:88.0f/255.0f blue:88.0f/255.0f alpha:1.0f];
    [self.view addSubview:titleLabel];
    
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, DEVICE_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topLine];
    
    CTSegScrollView* segView = [[CTSegScrollView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT - 64) titleArray:@[@"通知",@"赞与感谢",@"私信"] delegate:self];
    [self.view addSubview:segView];
    
    
}

- (UIView *)segScrollViewWithIndex:(NSInteger)index
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - 64 - 30)];
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    text.text = [NSString stringWithFormat:@"%ld",index];
    [view addSubview:text];
    
    return view;
}

- (void)segScrollViewAppearWithIndex:(NSInteger)index
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
