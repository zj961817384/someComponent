//
//  ZZZPointView.h
//  ZZZMyProject
//
//  Created by zzzzz on 2017/3/7.
//  Copyright © 2017年 zzzzz. All rights reserved.
//

#import <UIKit/UIKit.h>


#define NORMALCOLOR [UIColor whiteColor]
#define RIGHTCOLOR [UIColor greenColor]
#define ERRORCOLOR [UIColor redColor]
#define SELECTCOLOR [UIColor blueColor]

/**
 九宫格的每个点的对象
 */
@interface ZZZPointView : UIView

@property (nonatomic, copy) NSString *value;//代表的值

/**
 选中按钮

 @return 是否成功被选中，如果之前已经被选中过了，这个方法就会返回NO
 */
- (BOOL)selectPoint;

/**
 取消选中状态
 */
- (void)unSelect;

/**
 错误的状态
 */
- (void)errorStatu;

/**
 正确的状态
 */
- (void)rightStatu;

@end
