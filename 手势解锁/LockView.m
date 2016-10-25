//
//  LockView.m
//  手势解锁
//
//  Created by mac on 2016/10/24.
//  Copyright © 2016年 United Network Services Ltd. of Shenzhen City. All rights reserved.
//

#import "LockView.h"
@interface LockView()
@property (nonatomic,strong)NSMutableArray *selectedBtns;
@property (nonatomic,assign)CGPoint currentPoint;
@end
@implementation LockView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [self addPanGester];
    [self addSubView];
    [super awakeFromNib];
}

- (void)addPanGester
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取触摸点
    self.currentPoint = [pan locationInView:self];

    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, self.currentPoint)&&btn.selected==NO) {// 点在没有选中的按钮上面才连线
            btn.selected = YES;
            // 保存到数组中
            [self.selectedBtns addObject:btn];

        }
    }
    // 重绘
    [self setNeedsDisplay];
    if (pan.state==UIGestureRecognizerStateEnded) {
        //创建可变字符串保存密码
        NSMutableString *strM = [NSMutableString string];
        for (UIButton *btn in self.selectedBtns) {
            [strM appendFormat:@"%zd",btn.tag];
        }
        NSLog(@"%@",strM);
        //还原界面

        // 取消所有按钮的选中
        [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
        // 清空画线，把选中按钮清空
        [self.selectedBtns removeAllObjects];
        [self setNeedsDisplay];
    }


}
- (void)addSubView
{
    for (NSInteger i=0; i<9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.tag = i;
        [self addSubview:btn];
    }

}
#pragma mark 绘线
- (void)drawRect:(CGRect)rect
{
    if(self.selectedBtns.count==0)return;
    // 把所有选中的按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSInteger count = self.selectedBtns.count;
    for (NSInteger i=0; i<count; i++) {
        UIButton *btn = self.selectedBtns[i];
        if (i==0) {
            //设置起点
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    // 连线手指到触摸点
    [path addLineToPoint:self.currentPoint];
    [[UIColor greenColor] set];
    path.lineWidth = 10;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 74;
    CGFloat h = 74;
    NSInteger cols = 3;
    CGFloat margin = (self.bounds.size.width-cols*w)/(cols+1);
    for (NSInteger i=0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat col = i%cols;
        CGFloat row = i/cols;
        x = margin+(margin+w)*col;
        y = 30+(margin+h)*row;
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (NSMutableArray *)selectedBtns
{
    if (!_selectedBtns) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}

@end
