//
//  CustomAnnotationView.h
//  galaxy
//
//  Created by hfk on 2017/8/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImage *portrait;

@end
