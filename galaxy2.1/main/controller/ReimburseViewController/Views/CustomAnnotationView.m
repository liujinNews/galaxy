//
//  CustomAnnotationView.m
//  galaxy
//
//  Created by hfk on 2017/8/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "CustomAnnotationView.h"
#define kWidth  22.f
#define kHeight 34.f

@implementation CustomAnnotationView

#pragma mark - Life Cycle
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -17, kWidth, kHeight)];
        [self addSubview:self.portraitImageView];
    }
    
    return self;
}
- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
