//
//  BackgroundView.m
//  手势解锁
//
//  Created by mac on 2016/10/24.
//  Copyright © 2016年 United Network Services Ltd. of Shenzhen City. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"Home_refresh_bg"];
    [image drawInRect:rect];
}

@end
