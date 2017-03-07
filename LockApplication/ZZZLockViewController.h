//
//  ZZZLockViewController.h
//  ZZZMyProject
//
//  Created by zzzzz on 2017/3/7.
//  Copyright © 2017年 zzzzz. All rights reserved.
//

/**
 使用方法

 直接初始化一个vc对象，这个然后将解锁成功的代码写在唯一的一个方法的block里
 颜色可以在代码里面调整
 */
#import <UIKit/UIKit.h>

typedef void(^UnLockSuccess)();
/**
 锁屏VC
 */
@interface ZZZLockViewController : UIViewController

- (void)lockAPP:(UnLockSuccess)unLockSuccess;

@end
