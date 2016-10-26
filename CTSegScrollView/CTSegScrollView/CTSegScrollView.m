//
//  CTSegScrollView.m
//  CTSegScrollView
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "CTSegScrollView.h"

@interface CTSegScrollView()<UIScrollViewDelegate>

@property (nonatomic,copy)      NSArray*    titleArray;
@property (nonatomic,strong)    UIView*     selectView;
@property (nonatomic,assign)    NSInteger   selectIndex;
@property (nonatomic,assign)    CGFloat     itemWidth;
@property (nonatomic,strong)    UIScrollView* scrollView;
@property (nonatomic,strong)    UIView      *topView;
@property (nonatomic,strong)    UIView      *spLine;
@end

@implementation CTSegScrollView

#pragma mark - Public Method

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray delegate:(id <CTSegScrollViewDelegate>) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = [titleArray copy];
        self.selectIndex = 0.f;
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleColor = [UIColor blueColor];
        self.topViewHeight = 30.f;
        self.delegate = delegate;
        self.selectViewHeight = 4.f;
        self.selectViewColor = [UIColor colorWithRed:3.0f/255.0f green:138.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    }
    return self;
}

#pragma mark - Private Method

- (void)setupView
{
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.topViewHeight)];
    topView.backgroundColor = self.topViewColor;
    self.topView = topView;
    [self addSubview:topView];
    
    UIView* spLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.topViewHeight - 0.5, DEVICE_WIDTH, 0.5)];
    spLine.backgroundColor = [UIColor clearColor];
    self.spLine = spLine;
    [self addSubview:spLine];
    
    self.itemWidth = (self.frame.size.width - 40)/[self.titleArray count];
    
    for (NSInteger i = 0; i < [self.titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + self.itemWidth*i, 0, self.itemWidth,self.topViewHeight);
        button.titleLabel.font = self.titleFont;
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
    }
    
    self.selectView = [[UIView alloc] init];
    self.selectView.backgroundColor = self.selectViewColor;
    self.selectView.frame = [self frameForSelectView];
    [topView addSubview:self.selectView];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topViewHeight, self.frame.size.width, self.frame.size.height - self.topViewHeight)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[self.titleArray count], scrollView.frame.size.height);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSMutableArray* viewArray = [@[] mutableCopy];
    for (NSInteger i = 0 ; i < [self.titleArray count]; i++) {
        UIView* view;
        if (self.delegate) {
            view = [self.delegate segScrollViewWithIndex:i];
            view.frame = CGRectMake(self.frame.size.width * i,0.f, view.frame.size.width,view.frame.size.height);
        }else
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0.f, self.frame.size.width, self.frame.size.height - self.topViewHeight)];
        }
        [scrollView addSubview:view];
        [viewArray addObject:view];
    }
    self.viewArray = [viewArray copy];
}

- (CGRect)frameForSelectView
{
    NSString* title = self.titleArray[self.selectIndex];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:self.titleFont}];
    
    CGRect rect = CGRectMake(20 + self.itemWidth * self.selectIndex + self.itemWidth/2 - titleSize.width/2, self.topViewHeight - self.selectViewHeight,titleSize.width, self.selectViewHeight);
    
    return rect;
}

- (CGRect)frameForSelectViewByOffset:(CGFloat)offset
{
    NSInteger leftIndex = offset/self.frame.size.width;
    NSString* leftTitle = self.titleArray[leftIndex];
    CGSize leftTitleSize = [leftTitle sizeWithAttributes:@{NSFontAttributeName:self.titleFont}];
    
    NSInteger rightIndex;
    CGSize rightTitleSize;
    if ((leftIndex + 1) >= [self.titleArray count]) {
        rightTitleSize = CGSizeMake(0, 0);
    }else
    {
        rightIndex = leftIndex + 1;
        NSString* rightTitle = self.titleArray[rightIndex];
        rightTitleSize = [rightTitle sizeWithAttributes:@{NSFontAttributeName:self.titleFont}];
    }
    
    CGFloat currentWidth = (rightTitleSize.width - leftTitleSize.width)/self.frame.size.width*(offset - self.frame.size.width*leftIndex) + leftTitleSize.width;
    
    CGFloat currentCenterX = self.itemWidth/2+self.itemWidth/self.frame.size.width*offset;
    
    CGRect rect = {currentCenterX - 0.5*currentWidth + 20,self.topViewHeight - self.selectViewHeight,currentWidth,self.selectViewHeight};
    
    return rect;
}

- (void)titleBtnClick:(UIButton *)btn
{
    [self selectAtIndex:btn.tag];
}

- (void)selectAtIndex:(NSInteger)index
{
    self.selectIndex = index;
    
    [UIView animateWithDuration:0.30 animations:^{
        self.selectView.frame = [self frameForSelectView];
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*index, 0)];
    }];
    
    if (self.delegate) {
        [self.delegate segScrollViewAppearWithIndex:index];
    }
    
}


#pragma mark - Event Method


#pragma mark - Setters & Getters

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.selectView.frame = [self frameForSelectViewByOffset:offset.x];
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (void)setTopViewColor:(UIColor *)topViewColor
{
    _topViewColor = topViewColor;
    self.topView.backgroundColor = topViewColor;
}

- (void)setSpLineColor:(UIColor *)spLineColor
{
    _spLineColor = spLineColor;
    self.spLine.backgroundColor = spLineColor;
}

@end
