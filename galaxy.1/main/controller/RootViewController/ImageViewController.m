//
//  ImageViewController.m
//  galaxy
//
//  Created by hfk on 15/11/13.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+WebCache.h"
@interface ImageViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *photoView;
@end

@implementation ImageViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_Unsel_TitleColor;
    [self createImageView];
}
-(void)createImageView
{
    _photoView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Width)];
    _photoView.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2);
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
//    _photoView.
    if ([_photoImageArray[_index] isKindOfClass:[NSDictionary class]]) {
        [_photoView sd_setImageWithURL:[NSURL URLWithString:[_photoImageArray[_index]objectForKey:@"filepath"]]];
    }else{
        ZLPhotoAssets *asset = _photoImageArray[_index];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            _photoView.image= [asset aspectRatioImage];
        }else if ([asset isKindOfClass:[NSString class]]){
            [_photoView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset]];
        }else if([asset isKindOfClass:[UIImage class]]){
            _photoView.image = (UIImage *)asset;
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            _photoView.image = [asset thumbImage];
        }
        
        
    }
    
    _photoView.userInteractionEnabled=YES;
    [self.view addSubview:_photoView];
    
    UITapGestureRecognizer *tapImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tapImage.delegate = self;
    [self.view addGestureRecognizer:tapImage];
    
    UIPinchGestureRecognizer *pinGes=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGes:)];
    pinGes.delegate=self;
    [_photoView addGestureRecognizer:pinGes];
    
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    
    // 设置拖动最少需要几个手指同时触摸
    panGes.minimumNumberOfTouches = 1;
    // 设置拖动最多可以有几个手指同时触摸
    panGes.maximumNumberOfTouches = 1;
    [_photoView addGestureRecognizer:panGes];
    
    
}

//点击图片查看图片
-(void)tapImage:(UITapGestureRecognizer *)tapGesture{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 处理缩放手势的方法
- (void)pinchGes:(UIPinchGestureRecognizer *)ges
{
    NSLog(@"%@",NSStringFromCGRect(_photoView.frame));
    ges.view.transform = CGAffineTransformScale(ges.view.transform, ges.scale, ges.scale);
    ges.scale = 1.0;
    
    if (_photoView.frame.size.width>Main_Screen_Width*2) {
        _photoView.frame=CGRectMake(0, 0, Main_Screen_Width*2, Main_Screen_Width*2);
        _photoView.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2);
        
    }else if (_photoView.frame.size.width<Main_Screen_Width/2){
        _photoView.frame=CGRectMake(0, 0, Main_Screen_Width/2, Main_Screen_Width/2);
        _photoView.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2);
    }
    
}

- (void)panGes:(UIPanGestureRecognizer *)ges
{
    CGPoint trans = [ges translationInView:self.view];
    ges.view.transform = CGAffineTransformTranslate(ges.view.transform, trans.x, trans.y);
    [ges setTranslation:CGPointZero inView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
