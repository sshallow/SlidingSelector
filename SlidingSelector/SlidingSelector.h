//
//  SlidingSelector.h
//  SlidingSelector
//
//  Created by shangshuai on 2019/5/22.
//  Copyright © 2019 ink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SortButtonState) {
    SortButtonStateDescending      = 0,     //降序
    SortButtonStateAscending       = 1,     //升序
};

@protocol SlidingSelectorDelegate <NSObject>

- (void)SlidingSelectorDelegateSortButton:(NSInteger)index withState:(SortButtonState)sortState;

@end

@interface SlidingSelector : UIView

/** item 数组 */
@property (nonatomic, strong) NSArray <NSString *> *itemArray;
/** 单个宽度 */
@property (nonatomic, assign) NSUInteger itemWidth;
/** 拖动是否有减速 */
@property (nonatomic, assign) BOOL decelerate;
/** 右侧排序按钮状态(降序/升序) */
@property (nonatomic, assign) SortButtonState sortState;
/** 代理 */
@property (nonatomic, weak  ) id <SlidingSelectorDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
