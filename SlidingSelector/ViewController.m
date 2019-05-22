//
//  ViewController.m
//  SlidingSelector
//
//  Created by shangshuai on 2019/5/22.
//  Copyright © 2019 ink. All rights reserved.
//

#import "ViewController.h"
#import "SlidingSelector.h"

@interface ViewController ()<SlidingSelectorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SlidingSelector *selector = [[SlidingSelector alloc] initWithFrame:CGRectMake((self.view.frame.size.width-350)/2, 344, 350, 54)];
    selector.decelerate = YES;
    selector.itemArray = @[@"chg",@"vol",@"pe",@"ps"];
    selector.delegate = self;
    [self.view addSubview:selector];
}

- (void)SlidingSelectorDelegateSortButton:(NSInteger)index withState:(SortButtonState)sortState {
    NSLog(@"***** index ：%ld ***** sortState：%ld *****",index,sortState);
}

@end
