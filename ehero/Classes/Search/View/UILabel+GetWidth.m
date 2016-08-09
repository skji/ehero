//
//  UILabel+GetWidth.m
//  ehero
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 ehero. All rights reserved.
//

#import "UILabel+GetWidth.h"

@implementation UILabel (GetWidth)

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
