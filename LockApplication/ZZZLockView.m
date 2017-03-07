//
//  ZZZLockView.m
//  ZZZMyProject
//
//  Created by zzzzz on 2017/3/7.
//  Copyright © 2017年 zzzzz. All rights reserved.
//

#import "ZZZLockView.h"
#import "ZZZPointView.h"

//#define MYPASSWORD @"1211200222"
#define MYPASSWORD @"00102011021222"

@interface ZZZLockView ()


@property (nonatomic, strong) NSMutableArray<ZZZPointView *> *buttonArr;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) NSMutableArray<ZZZPointView *> *selectPointArr;
@property (nonatomic, copy) UnLockSuccess successBlock;

@property (nonatomic, assign) CGPoint endPt;
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation ZZZLockView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	
	self.backgroundColor = [UIColor purpleColor];
	self.password = @"";
	[self layoutButtonPoint];
	
	return self;
}

- (void)layoutButtonPoint {
	self.buttonArr = [NSMutableArray array];
	self.selectPointArr = [NSMutableArray array];
	self.lineColor = SELECTCOLOR;
	
	CGFloat window_width = [UIScreen mainScreen].bounds.size.width;
	CGFloat pointW = window_width / 6;//每个按钮的宽度
	CGFloat interval = (window_width - pointW * 3) / 4;//每个按钮的间隔
	CGFloat startY = [UIScreen mainScreen].bounds.size.height - window_width;
	
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			ZZZPointView *v = [[ZZZPointView alloc] initWithFrame:CGRectMake(i * pointW + interval * (i + 1), startY + (pointW + interval) * j, pointW, pointW)];
			v.value = [NSString stringWithFormat:@"%d%d", i, j];
			[self addSubview:v];
			[_buttonArr addObject:v];
		}
	}
	
}

- (void)lockAPP:(UnLockSuccess)unLockSuccess {
	self.successBlock = unLockSuccess;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	for (ZZZPointView *v in _buttonArr) {
		if (CGRectContainsPoint(v.frame, pt)) {//如果pt点在frame内
			if ([v selectPoint]) {
				self.password = [NSString stringWithFormat:@"%@%@", _password, v.value];
				[_selectPointArr addObject:v];
			}
		}
	}
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	self.endPt = pt;
	for (ZZZPointView *v in _buttonArr) {
		if (CGRectContainsPoint(v.frame, pt)) {//如果pt点在frame内
			if ([v selectPoint]) {
				self.password = [NSString stringWithFormat:@"%@%@", _password, v.value];
				[_selectPointArr addObject:v];
			}
		}
	}
	[self setNeedsDisplay];
}

//划线
- (void)drawLine:(CGPoint)endPt {
	if (_selectPointArr.count == 0) {
		return;
	}
	UIBezierPath *path = [UIBezierPath bezierPath];
	for (ZZZPointView *sv in _selectPointArr) {
		if (0 == [_selectPointArr indexOfObject:sv]) {
			[path moveToPoint:sv.center];
		} else {
			[path addLineToPoint:sv.center];
		}
	}
	[path addLineToPoint:endPt];
	
	path.lineWidth = 20;
	path.lineCapStyle = kCGLineCapRound;
	path.lineJoinStyle = kCGLineJoinRound;
	[_lineColor setStroke];//设置边框的颜色
	[path stroke];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	self.userInteractionEnabled = NO;//显示结果，阻断用户交互
	NSLog(@"%@", _password);
	self.endPt = [_selectPointArr lastObject].center;
	[self setNeedsDisplay];
	if ([_password isEqualToString:MYPASSWORD]) {
		self.lineColor = RIGHTCOLOR;
		for (ZZZPointView *errV in _selectPointArr) {
			[errV rightStatu];
		}
		self.successBlock();
	} else {
		self.lineColor = ERRORCOLOR;
		for (ZZZPointView *errV in _selectPointArr) {
			[errV errorStatu];
		}
	}
	__weak typeof(self) wSelf = self;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		__weak typeof(wSelf) sSelf = wSelf;
		sSelf.lineColor = SELECTCOLOR;
		[sSelf.selectPointArr removeAllObjects];
		[sSelf setNeedsDisplay];
		[sSelf clearSelectButton];
		self.userInteractionEnabled = YES;//结果显示完毕，开启用户交互
	});
	self.password = @"";
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	self.lineColor = SELECTCOLOR;
	[self.selectPointArr removeAllObjects];
	[self clearSelectButton];
}


/**
 清空选中按钮
 */
- (void)clearSelectButton {
	for (ZZZPointView *v in _buttonArr) {
		[v unSelect];
	}
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	[self drawLine:self.endPt];
}


@end
