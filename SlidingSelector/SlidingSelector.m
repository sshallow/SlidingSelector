//
//  SlidingSelector.m
//  SlidingSelector
//
//  Created by shangshuai on 2019/5/22.
//  Copyright © 2019 ink. All rights reserved.
//

#import "SlidingSelector.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SlidingSelector ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) CAShapeLayer *centerLayer;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIButton *sortButton;

@end

@implementation SlidingSelector

@synthesize itemArray = _itemArray;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:25/255.0 green:66/255.0 blue:84/255.0 alpha:1];
    self.layer.cornerRadius = 10;
    
    [self addSubview:self.centerView];
    [self addSubview:self.contentScrollView];
    [self addSubview:self.sortButton];
    
    /** 默认 */
    self.sortState = SortButtonStateDescending;
    self.decelerate = YES;
    self.itemWidth = 100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (fmod(scrollView.contentOffset.x, 100.0) == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSoundWithCompletion(1157, nil);
            [self impactFeedBack];
        });
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //关闭减速
    if (!self.decelerate) {
        CGFloat targetContentOffsetX = scrollView.contentOffset.x;
        NSInteger index = round(targetContentOffsetX / self.itemWidth);
        CGFloat targetX = index * self.itemWidth;
        [scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //关闭减速
    if (!self.decelerate) {
        CGFloat targetContentOffsetX = scrollView.contentOffset.x;
        NSInteger index = round(targetContentOffsetX / self.itemWidth);
        CGFloat targetX = index * self.itemWidth;
        [scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //开启减速
    if (self.decelerate) {
        CGFloat targetContentOffsetX = (*targetContentOffset).x;
        NSInteger index = round(targetContentOffsetX / self.itemWidth);
        CGFloat targetX = index * self.itemWidth;
        targetContentOffset->x = targetX;
        
        self.sortButton.selected = NO;
        self.sortState = SortButtonStateDescending;
        if (_delegate && [_delegate respondsToSelector:@selector(SlidingSelectorDelegateSortButton:withState:)]) {
            [_delegate SlidingSelectorDelegateSortButton:index withState:self.sortState];
        }
    }
}

#pragma mark 私有方法

- (void)itemClick:(UIButton *)item {
    self.sortButton.selected = NO;
    self.sortState = SortButtonStateDescending;
    
    [self.contentScrollView setContentOffset:CGPointMake(item.center.x - self.contentScrollView.center.x, 0) animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(SlidingSelectorDelegateSortButton:withState:)]) {
        [_delegate SlidingSelectorDelegateSortButton:item.tag - 10000 withState:self.sortState];
    }
}

//震动
- (void)impactFeedBack {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedBack prepare];
        [impactFeedBack impactOccurred];
    }
}

- (void)sortButtonClick:(UIButton *)button {
    self.sortButton.selected = !self.sortButton.isSelected;
    self.sortState = self.sortButton.isSelected ? SortButtonStateAscending : SortButtonStateDescending;
    if (_delegate && [_delegate respondsToSelector:@selector(SlidingSelectorDelegateSortButton:withState:)]) {
        [_delegate SlidingSelectorDelegateSortButton:self.contentScrollView.contentOffset.x / self.itemWidth withState:self.sortState];
    }
}

#pragma mark overwrite setter

- (void)setItemArray:(NSMutableArray<NSString *> *)itemArray {
    _itemArray = itemArray;
    /** 根据内容设置contentSize */
    self.contentScrollView.contentSize = CGSizeMake(itemArray.count * self.itemWidth + self.contentScrollView.bounds.size.width - self.itemWidth, 0);
    self.centerView.frame = CGRectMake((self.bounds.size.width - self.itemWidth) / 2, 0, self.itemWidth, self.bounds.size.height);
    self.sortButton.frame = CGRectMake((self.bounds.size.width - self.itemWidth) / 2 + self.itemWidth - 30, 0, 25, self.bounds.size.height);
    
    /** 首个 item 居中要偏移的位置 */
    CGFloat firstOffsetX = self.contentScrollView.bounds.size.width/2 - self.itemWidth/2;
    [_itemArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(idx * self.itemWidth + firstOffsetX, 0, self.itemWidth, self.frame.size.height)];
        item.tag = 10000 + idx;
        [item setTitle:obj forState:UIControlStateNormal];
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:item];
    }];
}

#pragma mark 懒加载
- (NSArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [[NSArray alloc] init];
    }
    return _itemArray;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.layer.cornerRadius = 10;
        _contentScrollView.layer.borderWidth = 2;
        _contentScrollView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:202/255.0 blue:175/255.0 alpha:1].CGColor;
    }
    return _contentScrollView;
}

- (CAShapeLayer *)centerLayer {
    if (!_centerLayer) {
        _centerLayer = [CAShapeLayer layer];
    }
    return _centerLayer;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - self.itemWidth) / 2, 0, self.itemWidth, self.bounds.size.height)];
        _centerView.backgroundColor = [UIColor colorWithRed:27/255.0 green:127/255.0 blue:124/255.0 alpha:1];
        _centerView.layer.cornerRadius = 10;
        _centerView.layer.borderWidth = 1.3;
        _centerView.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:202/255.0 blue:175/255.0 alpha:1] CGColor];
    }
    return _centerView;
}

- (UIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [[UIButton alloc] initWithFrame:CGRectMake(self.itemWidth - 30, 0, 25, self.bounds.size.height)];
        [_sortButton setImage:[UIImage imageNamed:@"descending"] forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"ascending"] forState:UIControlStateSelected];
        [_sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _sortButton.selected = NO;
    }
    return _sortButton;
}

@end
