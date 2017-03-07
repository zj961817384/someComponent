//
//  ZZZLockViewController.m
//  ZZZMyProject
//
//  Created by zzzzz on 2017/3/7.
//  Copyright © 2017年 zzzzz. All rights reserved.
//

#import "ZZZLockViewController.h"
#import "ZZZLockView.h"

@interface ZZZLockViewController ()

@property (nonatomic, copy) UnLockSuccess successBlock;

@property (nonatomic, strong) ZZZLockView *lockView;

@end

@implementation ZZZLockViewController

- (instancetype)init {
	self = [super init];
	
	self.lockView = [[ZZZLockView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_lockView];
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
}

- (void)lockAPP:(__autoreleasing UnLockSuccess)unLockSuccess {
	self.successBlock = unLockSuccess;
	[_lockView lockAPP:unLockSuccess];
//	NSLog(@"解锁回调");
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
