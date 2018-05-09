//
//  WWTabBar.m
//  WWAnimationTabbar
//
//  Created by 天奕 on 16/1/20.
//  Copyright © 2016年 William. All rights reserved.
//

#import "WWTabBar.h"
#import "WWTabBarButton.h"


#define Background_Color    [UIColor colorWithRed:227/255.0 green:229/255.0 blue:230/255.0 alpha:1]
#define Slider_Color        [UIColor colorWithRed:214/255.0 green:76/255.0 blue:14/255.0 alpha:1]

#define COLOR_MAIN     [UIColor colorWithRed:52.0/255.0 green:147.0/255.0 blue:213.0/255.0 alpha:1]

#define COLOR_ACCOUNT_BACK     [UIColor colorWithRed:34.0/255.0 green:53.0/255.0 blue:72.0/255.0 alpha:1]

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface WWTabBar ()

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong) UIView *slidingView;

@end

@implementation WWTabBar

-(UIView *)slidingView {
    if (!_slidingView) {
        _slidingView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, self.frame.size.width/4, 3)];
        _slidingView.backgroundColor = COLOR_MAIN;
        [self addSubview:_slidingView];
    }
    return _slidingView;
}

- (instancetype)initWithFrame:(CGRect)frame increasedHeight:(CGFloat)height; {
    CGRect tFrame = frame;
    tFrame.origin.y = frame.origin.y - height;
    tFrame.size.height = frame.size.height + height;
    frame = tFrame;
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    self.backgroundColor = Background_Color;

//    [self.layer setShadowOffset:CGSizeMake(-1, -1)];
//    [self.layer setShadowColor:[UIColor darkGrayColor].CGColor];
//    self.layer.shadowOpacity = 1;
//    self.layer.shadowRadius = 2;
    
    [self slidingView];
}

- (void)addButtonWithImage:(UIImage *)icon name:(NSString *)name index:(NSInteger)index{
    WWTabBarButton *btn = [WWTabBarButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/8 - 11, 13, 22, 25)];
    iconView.image = icon;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [btn addSubview: iconView];
    
    UILabel *tabName = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width/4, 13)];
    tabName.text = name;
    tabName.textColor = [UIColor whiteColor];
    tabName.font = [UIFont fontWithName:@"Oxygen" size: 10.0f];
    tabName.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:tabName];
    
    
    UIImage *image_unselected = [UIImage imageNamed:@"tab_unselected"];
    UIImage *image_selected = [UIImage imageNamed:@"tab_selected"];
    [btn setImage:image_unselected forState:UIControlStateNormal];
    [btn setImage:image_selected forState:UIControlStateSelected];
    
    [self addSubview:btn];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
    if (index == 1) {
        btn.selected = YES;
        self.selectedBtn = btn;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = 0;
    NSMutableArray *btnSubviews = [NSMutableArray array];
    for (UIView * subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [btnSubviews addObject:subview];
            count++;
        }
    }
    for (int i = 0; i < count; i++) {
        UIButton *btn = btnSubviews[i];
        btn.tag = i;
        
        CGFloat x = i * self.bounds.size.width / count;
        CGFloat y = 0;
        CGFloat width = self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height - y;
        btn.frame = CGRectMake(x, y, width, height);
    }
}

- (void)clickBtn:(UIButton *)button {
    
    if (self.selectedBtn != button) {

        [UIView animateWithDuration:0 animations:^{
            CGRect orignFrame = self.slidingView.frame;
            self.slidingView.frame = CGRectMake(WIDTH*button.tag/4, 59, orignFrame.size.width, 3);
        }];
    }
    
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:button.tag];
    }
}



@end
