//
//  ZZZPointView.m
//  ZZZMyProject
//
//  Created by zzzzz on 2017/3/7.
//  Copyright © 2017年 zzzzz. All rights reserved.
//

#import "ZZZPointView.h"


@interface ZZZPointView	()

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation ZZZPointView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	self.isSelect = NO;
	[self setBackgroundColor:[UIColor clearColor]];
	self.lineColor = [UIColor clearColor];
	[self createView];
	return self;
}

- (void)createView {
	self.layer.borderColor = NORMALCOLOR.CGColor;
	self.layer.cornerRadius = self.frame.size.width / 2;
	self.layer.borderWidth = 1;
}

- (BOOL)selectPoint {
	if (!_isSelect) {
		_isSelect = YES;
		[self beSelected];
		return YES;
	}
	return NO;
}

- (void)unSelect {
	_isSelect = NO;
	self.layer.borderColor = NORMALCOLOR.CGColor;
	self.lineColor = [UIColor clearColor];
	[self setNeedsDisplay];
}

- (void)beSelected {
	self.layer.borderColor = SELECTCOLOR.CGColor;
	self.lineColor = SELECTCOLOR;
	[self setNeedsDisplay];
}

- (void)errorStatu {
	self.layer.borderColor = ERRORCOLOR.CGColor;
	self.lineColor = ERRORCOLOR;
	[self setNeedsDisplay];
}

- (void)rightStatu {
	self.layer.borderColor = RIGHTCOLOR.CGColor;
	self.lineColor = RIGHTCOLOR;
	[self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	UIBezierPath *ppp = [UIBezierPath bezierPath];
	[self.lineColor setFill];//设置填充颜色
	[ppp addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2) radius:self.frame.size.width / 3 startAngle:0 endAngle:2 * M_PI clockwise:YES];
	[ppp fill];
}


@end
