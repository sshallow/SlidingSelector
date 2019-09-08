//
//  SSViewController.m
//  SlidingSelector
//
//  Created by sshallow on 09/08/2019.
//  Copyright (c) 2019 sshallow. All rights reserved.
//

#import "SSViewController.h"
#import <SlidingSelector.h>

@interface SSViewController ()<SlidingSelectorDelegate>

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SlidingSelector *selector = [[SlidingSelector alloc] initWithFrame:CGRectMake((self.view.frame.size.width-350)/2, 344, 350, 54)];
    selector.decelerate = YES;
    selector.itemArray = @[@"chg",@"vol",@"pe",@"ps"];
    selector.delegate = self;
    [self.view addSubview:selector];
}

- (void)SlidingSelectorDelegateSortButton:(NSInteger)index withState:(SortButtonState)sortState {
    NSLog(@"***** index ：%ld ***** sortState：%ld *****",index,sortState);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
