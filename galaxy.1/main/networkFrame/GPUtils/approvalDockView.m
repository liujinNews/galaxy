//
//  approvalDockView.m
//  galaxy
//
//  Created by 赵碚 on 15/8/7.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "approvalDockView.h"
#import "dockAssView.h"
#define frameSize 49

@implementation approvalDockView
{
    NSMutableArray * viewArray;
    NSArray * imgArray;
    int curViewTag;
    NSArray * textArray;
}

static approvalDockView * DockView = nil;
-(void)clear{
    DockView = nil;
}
+(approvalDockView *)shareInstance{
    if (DockView == nil) {
        DockView = [[approvalDockView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    }
    return DockView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewArray = [NSMutableArray array];
        textArray = [NSArray arrayWithObjects:@"退回",@"拒绝",@"同意", nil];
        curViewTag = -1;
        [self setDockFrame];
    }
    return self;
}

//设置当前VC
- (void)setCurrentViewController:(UIViewController *)curVC {
    self.vc = curVC;
}

- (void)setDockFrame {
    //间隔数量
    CGFloat spaceNum = (CGFloat)(textArray.count + 1);
    //间隔宽度
    CGFloat spaceWidth = (ScreenRect.size.width - (CGFloat)(textArray.count * frameSize)) / spaceNum;
    //开始创建tabbar项
    for (int index = 0; index < textArray.count; index ++) {
        CGFloat x = spaceWidth*(CGFloat)(index+1)+(CGFloat)(index*frameSize);
        NSString * imgName = textArray[index];
        dockAssView * da = [[dockAssView alloc]initWithFrame:CGRectMake(x, 0, 49, 49)];
        da.tag = index;
        [da initContentsName:imgName Text:textArray[index] Color:[UIColor grayColor]];
        
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dockAssViewTap:)];
        tapGR.numberOfTapsRequired = 1;
        [da addGestureRecognizer:tapGR];
        //加添view对象到数组中保存,以备后面修改时调用
        [viewArray addObject:da];
        //添加到当前view中显示
        [self addSubview:da];
    }
}

//设置当前页面需要变色的bottomView
- (void)setDockViewContent:(int)index {
    curViewTag = index;
    for (int i = 0; i < viewArray.count; i ++) {
        dockAssView * dsview = (dockAssView *)[viewArray objectAtIndex:i];
        if (i == index) {
            [dsview setContentsName:imgArray[i] Color:Color_form_TextFieldBackgroundColor];
        } else {
            [dsview setContentsName:imgArray[i] Color:[UIColor lightGrayColor]];
        }
    }
}

//设置红点显示状态
- (void)setRedBallShowState:(int)index IsShow:(BOOL)isShow {
    dockAssView * ds = viewArray[index];
    ds.redBallImgView.hidden = isShow;
}

-(void)dockAssViewTap:(UITapGestureRecognizer *)tap{
    if (curViewTag == tap.view.tag) {
        return;
    }
    switch (tap.view.tag) {
        case 0:{
            //临时关闭隐式动画
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            
            self.alert = [[UIAlertView alloc]initWithTitle:@"退回" message:@"请输入原因（必填）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退回", nil];
            [self.alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [self.alert show];
            [CATransaction commit];
        }
            break;
        case 1:{
            //临时关闭隐式动画
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            
            self.alert = [[UIAlertView alloc]initWithTitle:@"拒绝" message:@"请输入原因（必填）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拒绝", nil];
            [self.alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [self.alert show];
            [CATransaction commit];
        }
            break;
        case 2:{
            //临时关闭隐式动画
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            
            self.alert = [[UIAlertView alloc]initWithTitle:@"同意" message:@"请输入原因（非必填）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil];
            [self.alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [self.alert show];
            [CATransaction commit];
        }
            break;
        default:
            break;
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.alert resignFirstResponder];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
