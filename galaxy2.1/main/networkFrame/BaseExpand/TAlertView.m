//
//  TAlertView.m
//  Taxation
//
//  Created by Seven on 15-1-13.
//  Copyright (c) 2015年 Allgateways. All rights reserved.
//

#import "TAlertView.h"
#import "UIFont+AppFont.h"
#import "UIImage+LogN.h"

#define kString(_S)                            NSLocalizedString(_S, @"")

@interface TAlertView ()<UITextViewDelegate,UITextFieldDelegate>{
   ALERT_TYPE _alert_type;
}
@property (nonatomic, strong) UIView *dialogView;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, strong) NSString *messageString;

@property (nonatomic, strong) action sure;
@property (nonatomic, strong) action cancel;
@property (nonatomic, strong) actionReturn sureReturn;
@property (nonatomic, strong) action camera;
@property (nonatomic, strong) action photo;

@property (nonatomic, strong) UITextView *txf;
@property (nonatomic, strong) UITextField *txf_paw;
@property (nonatomic, assign) NSString *str;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UITapGestureRecognizer *ges;
@end

@implementation TAlertView

- (id)initWithTitle:(NSString *)title withSubTitle:(NSString *)subtitle message:(NSString *)msg;
{
   self = [super init];
   if (self){
      self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
      _titleString = Custing(title, nil); //title;
      _subTitleString=Custing(subtitle, nil);
      _messageString = Custing(msg, nil);
      self.ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction:)];
      [self addGestureRecognizer:self.ges];
   }
   return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)msg cancelStr:(NSString *)cancelStr sureStr:(NSString *)surStr
{
   self.cancelStr = cancelStr;
   self.surStr = surStr;
   return [self initWithTitle:title withSubTitle:nil message:msg];
}


-(UIView *)creatDialogView{
   UIView *dialog = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*0.87, 164)];
   dialog.backgroundColor=Color_form_TextFieldBackgroundColor;
   [dialog.layer setMasksToBounds:YES];
   [dialog.layer setCornerRadius:10.0];
   
   UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 90, 20)];
   title.font = [UIFont appFontWithSize:16];
   title.textColor = Color_GrayDark_Same_20;
   title.textAlignment = NSTextAlignmentLeft;
   title.text = self.titleString;
   [dialog addSubview:title];
   
   UILabel *Subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
   Subtitle.font = [UIFont appFontWithSize:14];
   Subtitle.textColor =Color_GrayDark_Same_20;
   Subtitle.textAlignment = NSTextAlignmentRight;
   Subtitle.text =_subTitleString ;
   Subtitle.center = CGPointMake(175,2+title.bounds.size.height);
   [dialog addSubview:Subtitle];
   
   
   if (_alert_type == ALERT_TIP_ACTION){
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      button.titleLabel.font = [UIFont appFontWithSize:18];
      button.frame = CGRectMake(0, 0, 142, 49);
      button.center = CGPointMake(dialog.bounds.size.width / 4, dialog.bounds.size.height - button.bounds.size.height);
      
      [button addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
      [button setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
      
      [button setTitle:self.surStr?Custing(self.surStr, nil):Custing(@"确定", nil)forState:UIControlStateNormal];
      //       [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      //        [button setBackgroundImage:[UIImage imageNamed:@"close_dialog_sure_normal"] forState:UIControlStateNormal];
      //        [button setBackgroundImage:[UIImage imageNamed:@"close_dialog_sure_focus"] forState:UIControlStateHighlighted];
      [dialog addSubview:button];
      
      button = [UIButton buttonWithType:UIButtonTypeCustom];
      button.titleLabel.font = [UIFont appFontWithSize:18];
      button.frame = CGRectMake(0, 0, 142, 49);
      button.center = CGPointMake((dialog.bounds.size.width / 4) * 3, dialog.bounds.size.height - button.bounds.size.height);
      [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
      //        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      //[button setTitle:kString(@"取消") forState:UIControlStateNormal];
      [button setTitle:self.cancelStr?Custing(self.cancelStr, nil):Custing(@"取消", nil) forState:UIControlStateNormal];
      [button setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateNormal];
      //        [button setBackgroundImage:[UIImage imageNamed:@"close_dialog_cancle_normal"] forState:UIControlStateNormal];
      //        [button setBackgroundImage:[UIImage imageNamed:@"close_dialog_cancle_focus"] forState:UIControlStateHighlighted];
      [dialog addSubview:button];
      
      UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dialog.bounds.size.width - 20, 85)];
      contentLabel.font = [UIFont appFontWithSize:18];
      contentLabel.numberOfLines = 0;
      //    contentLabel.lineBreakMode =
      contentLabel.center = CGPointMake(dialog.bounds.size.width / 2, 95);
      contentLabel.textColor = RGBA(0, 0, 0, 0.7);
      contentLabel.text = self.messageString;
      [dialog addSubview:contentLabel];
      
   }else if(_alert_type == ALERT_TIP){
      UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dialog.bounds.size.width - 20, 130)];
      contentLabel.font = [UIFont appFontWithSize:16];
      contentLabel.textAlignment = NSTextAlignmentCenter;
      contentLabel.numberOfLines = 0;
      //    contentLabel.lineBreakMode =
      contentLabel.center = CGPointMake(dialog.bounds.size.width / 2, 95);
      contentLabel.textColor = RGBA(0, 0, 0, 0.7);
      contentLabel.text = self.messageString;
      [dialog addSubview:contentLabel];
      
   }else if(_alert_type == ALERT_ACTION){
      //        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55 + (dialog.bounds.size.height - 55) / 2.0f / 2.0f - 15, 30, 30)];
      //        imagev.image = [UIImage imageNamed:@"0.png"];
      //        [dialog addSubview:imagev];
      //
      //        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imagev.frame.origin.x + imagev.frame.size.width + 10, imagev.frame.origin.y, 100, imagev.bounds.size.height)];
      //        textLabel.text = kString(@"相册");
      //        textLabel.font = [UIFont systemFontOfSize:17];
      //        textLabel.textColor = [UIColor colorWithRed:0.0f green:.0f blue:.0f alpha:.7f];
      //        [dialog addSubview:textLabel];
      //
      //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      //        button.frame = CGRectMake(0, 55, dialog.bounds.size.width, (dialog.bounds.size.height - 55) / 2.0f);
      //        [button setBackgroundImage:[UIImage imageFromColor:Color_form_TextFieldBackgroundColor] forState:UIControlStateNormal];
      //        [button addTarget:self action:@selector(photo:) forControlEvents:UIControlEventTouchUpInside];
      //        [dialog addSubview:button];
      //        [dialog sendSubviewToBack:button];
      //
      //        CALayer *line = [CALayer layer];
      //        line.frame = CGRectMake(0, 55 + (dialog.bounds.size.height - 55) / 2.0f - 3, dialog.bounds.size.width, .5);
      //        line.backgroundColor = [UIColor grayColor].CGColor;
      //        [dialog.layer addSublayer:line];
      //
      //        button = [UIButton buttonWithType:UIButtonTypeCustom];
      //        button.frame = CGRectMake(0, 55 + (dialog.bounds.size.height - 55) / 2.0f, dialog.bounds.size.width, (dialog.bounds.size.height - 55) / 2.0f - 10);
      //        [button setBackgroundImage:[UIImage imageFromColor:Color_form_TextFieldBackgroundColor] forState:UIControlStateNormal];
      //        [button addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];
      //        [dialog addSubview:button];
      //        [dialog sendSubviewToBack:button];
      //
      //        imagev = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55 + (dialog.bounds.size.height - 55) / 2.0f + (dialog.bounds.size.height - 55) / 2.0f / 2.0f - 15, 30, 30)];
      //        imagev.image = [UIImage imageNamed:@"picker_camera"];
      //        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imagev.frame.origin.x + imagev.frame.size.width + 10, imagev.frame.origin.y, 100, imagev.bounds.size.height)];
      //        textLabel.text = kString(@"我的相机");
      //        textLabel.font = [UIFont systemFontOfSize:17];
      //        textLabel.textColor = [UIColor colorWithRed:0.0f green:.0f blue:.0f alpha:.7f];
      //        [dialog addSubview:textLabel];
      //
      //        [dialog addSubview:imagev];
      
   }else if (_alert_type == ALERT_DATEPICKER){
      UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, dialog.bounds.size.width, dialog.bounds.size.height - 60)];
      [dialog addSubview:picker];
   }else if (_alert_type == ALERT_TXF){
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      button.titleLabel.font =Font_Important_18_20;
      button.frame = CGRectMake((Main_Screen_Width*0.87)/2, 120, (Main_Screen_Width*0.87)/2, 45);
//      [button.layer setMasksToBounds:YES];
//      [button.layer setCornerRadius:4.0];
//      [button.layer setBorderWidth:1.0];
//      button.layer.borderColor=Color_Blue_Important_20.CGColor;
      [button addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
      [button setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
      [button setTitle:Custing(@"确定", nil) forState:UIControlStateNormal];
//      button.backgroundColor=Color_Blue_Important_20;
      [dialog addSubview:button];
      
      button = [UIButton buttonWithType:UIButtonTypeCustom];
      [button setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateNormal];
      button.titleLabel.font =Font_Important_18_20;
      button.frame = CGRectMake(0, 120, (Main_Screen_Width*0.87)/2, 45);
//      [button.layer setMasksToBounds:YES];
//      [button.layer setCornerRadius:4.0];
//      [button.layer setBorderWidth:1.0];
//      button.layer.borderColor=Color_Blue_Important_20.CGColor;
//      button.backgroundColor=Color_form_TextFieldBackgroundColor;
      [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
      [button setTitle:Custing(@"取消", nil) forState:UIControlStateNormal];
      [dialog addSubview:button];
      
      // ------
      UIImageView *image = [[UIImageView alloc]init];
      image.backgroundColor = Color_LineGray_Same_20;
      image.frame = CGRectMake(0, 120, (Main_Screen_Width*0.87), 1);
      [dialog addSubview:image];
      
      UIImageView *image1 = [[UIImageView alloc]init];
      image1.backgroundColor = Color_LineGray_Same_20;
      image1.frame = CGRectMake((Main_Screen_Width*0.87)/2, 120, 1, 45);
      [dialog addSubview:image1];
      
      self.txf = [[UITextView alloc] initWithFrame:CGRectMake(13, 38, (Main_Screen_Width*0.87)-26, 73)];
      self.txf.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1];
      self.txf.delegate = self;
      self.txf.font=Font_cellTitle_14 ;
      [self.txf becomeFirstResponder];
      [dialog addSubview:self.txf];
      
      NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage];
      _label = [[UILabel alloc]init];
      if ([language isEqualToString:@"zh-Hans"]) {
         _label.frame=CGRectMake(17, 44, 213, 20);
      }else if([language isEqualToString:@"en"]){
         _label.frame=CGRectMake(17, 38, 213, 36);
         _label.numberOfLines=2;
      }
//      _label.backgroundColor=[UIColor redColor];
      _label.enabled = NO;
      _label.text = _messageString;
      _label.font =  [UIFont systemFontOfSize:15];
      _label.textColor = [UIColor lightGrayColor];
      [dialog addSubview:_label];
      
      [self removeGestureRecognizer:self.ges];
      self.ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txflostReginer:)];
      [self addGestureRecognizer:self.ges];
   }else if (_alert_type == ALERT_ACTIONS){
      NSUInteger count = _arrActions.count;
      CGFloat contentheight = 168.0;
      CGFloat contentWidth = dialog.bounds.size.width - 20;
      
      UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentheight)];
      contentView.center = CGPointMake(dialog.bounds.size.width / 2, 135);
      //  contentView.backgroundColor = [UIColor yellowColor];
      [dialog addSubview:contentView];
      
      for (CGFloat i = 0; i < count; i++){
         UIButton *  button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.titleLabel.font = [UIFont appFontWithSize:18];
         button.frame = CGRectMake(0, 0, dialog.bounds.size.width - 20, contentheight / count);
         CGPoint p = CGPointMake(contentWidth / 2, contentheight * ((i * 2.0 + 1.0) / ((CGFloat)count * 2.0)));
         
         button.center = p;
         button.tag = (int)i;
         [button addTarget:self action:@selector(customActions:) forControlEvents:UIControlEventTouchUpInside];
         [button setTitleColor:Color_Unsel_TitleColor forState:UIControlStateNormal];
         NSString *str = self.arrTitle[(int)i];
         [button setTitle:Custing(str, nil) forState:UIControlStateNormal];
         [contentView addSubview:button];
         
         UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 1)];
         p = CGPointMake(contentWidth / 2, contentheight * ((i + 1) * 2) / ((CGFloat)count * 2.0));
         //NSLog(@"%f, %f", p.x, p.y);
         line.center = p;
         
         line.backgroundColor = [UIColor lightGrayColor];
         if (i != count - 1)
            [contentView addSubview:line];
      }
   }else if (_alert_type == ALERT_PAW){
      title.frame=CGRectMake(20, 0, Main_Screen_Width*0.87-40, 40);
      title.textAlignment = NSTextAlignmentCenter;

      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      button.titleLabel.font =Font_Important_18_20;
      button.frame = CGRectMake((Main_Screen_Width*0.87)/2, 90, (Main_Screen_Width*0.87)/2, 45);
      [button addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
      [button setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
      [button setTitle:Custing(@"确定", nil) forState:UIControlStateNormal];
      [dialog addSubview:button];
      
      button = [UIButton buttonWithType:UIButtonTypeCustom];
      [button setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateNormal];
      button.titleLabel.font =Font_Important_18_20;
      button.frame = CGRectMake(0, 90, (Main_Screen_Width*0.87)/2, 45);
      [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
      [button setTitle:Custing(@"取消", nil) forState:UIControlStateNormal];
      [dialog addSubview:button];
      
      UIImageView *image = [[UIImageView alloc]init];
      image.backgroundColor = Color_LineGray_Same_20;
      image.frame = CGRectMake(0, 90, (Main_Screen_Width*0.87), 1);
      [dialog addSubview:image];
      
      UIImageView *image1 = [[UIImageView alloc]init];
      image1.backgroundColor = Color_LineGray_Same_20;
      image1.frame = CGRectMake((Main_Screen_Width*0.87)/2, 90, 1, 45);
      [dialog addSubview:image1];
      
      self.txf_paw = [[UITextField alloc] initWithFrame:CGRectMake(13, 38, (Main_Screen_Width*0.87)-26, 40)];
      self.txf_paw.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1];
      self.txf_paw.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
      self.txf_paw.leftViewMode = UITextFieldViewModeAlways;
      self.txf_paw.delegate = self;
      self.txf_paw.placeholder=_messageString;
      [self.txf_paw setSecureTextEntry:YES];
      self.txf_paw.font=Font_cellTitle_14 ;
      [self.txf_paw becomeFirstResponder];
      [dialog addSubview:self.txf_paw];
      
      [self removeGestureRecognizer:self.ges];
      self.ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txflostReginer:)];
      [self addGestureRecognizer:self.ges];
   }
   
   return dialog;
}

- (void)showWithTXFActionSure:(actionWithStr)actionStr cancel:(action)cancel
{
   _alert_type = ALERT_TXF;
   self.actionStr = actionStr;
   self.cancel = cancel;
   [self showAlert];
}
- (void)showPawWithTXFActionSure:(actionWithStr)actionStr cancel:(action)cancel{
   _alert_type = ALERT_PAW;
   self.actionStr = actionStr;
   self.cancel = cancel;
   [self showAlert];
}


- (void) textViewDidChange:(UITextView *)textView{
   if ([textView.text length] == 0) {
      [_label setHidden:NO];
   }else{
      [_label setHidden:YES];
   }
}


-(void)showWithActionSure:(action)sure cancel:(action)cancel{
   _alert_type = ALERT_TIP_ACTION;
   self.sure = sure;
   self.cancel = cancel;
   [self showAlert];
}

-(void)showTips{
   _alert_type = ALERT_TIP;
   [self showAlert];
}

-(void)showActionCamera:(action)camera photoA:(action)picker{
   _alert_type = ALERT_ACTION;
   self.camera = camera;
   self.photo = picker;
   [self showAlert];
}


- (void)showActionDate:(actionWithParam)dateselected{
   _alert_type = ALERT_DATEPICKER;
   [self showAlert];
}



- (void)showWithAcitons:(NSArray *)arr arrActions:(NSArray *)arrAcitons{
   _alert_type = ALERT_ACTIONS;
   _arrTitle = arr;
   _arrActions = arrAcitons;
   [self showAlert];
}

-(void)showAlert{
   _dialogView = [self creatDialogView];
   
   if (_alert_type == ALERT_TXF){
//      _dialogView.center = CGPointMake(self.bounds.size.width / 2, (Main_Screen_Height-330-164));
      _dialogView.frame = CGRectMake((Main_Screen_Width*0.13)/2, (Main_Screen_Height-360-164), Main_Screen_Width *0.87, 164);
   }else if (_alert_type == ALERT_PAW){
      _dialogView.frame = CGRectMake((Main_Screen_Width*0.13)/2, (Main_Screen_Height-400-135), Main_Screen_Width *0.87, 135);
   }else{
      _dialogView.center = CGPointMake(self.bounds.size.width / 2, 100);
   }
   
   
   _dialogView.layer.shouldRasterize = YES;
   _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
   
   self.layer.shouldRasterize = YES;
   self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
   //    _dialogView.layer.zPosition = 9999;
   _dialogView.layer.opacity = 0.5f;
   _dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
   
   self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
   
   [self addSubview:_dialogView];
   [self bringSubviewToFront:_dialogView];//把_dialogView移到最前
   //    self
   UIWindow *win =[UIApplication sharedApplication].keyWindow ;
   [win addSubview:self];
   [win makeKeyAndVisible];
   [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                       self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                       self.dialogView.layer.opacity = 1.0f;
                       self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                       self.ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction:)];
                       [self addGestureRecognizer:self.ges];
                    }
                    completion:NULL
    ];
}


// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
   CATransform3D currentTransform = _dialogView.layer.transform;
   
   CGFloat startRotation = [[_dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
   CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
   
   _dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
   _dialogView.layer.opacity = 1.0f;
   
   [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                    animations:^{
                       self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                       _dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                       _dialogView.layer.opacity = 0.0f;
                    }
                    completion:^(BOOL finished) {
                       for (UIView *v in [self subviews]) {
                          [v removeFromSuperview];
                       }
                       [self removeFromSuperview];
                    }
    ];
}

-(void)sureAction:(id)sender{
   if (_alert_type == ALERT_TXF) {
      self.actionStr(self.txf.text);
   }else if (_alert_type == ALERT_PAW){
      self.actionStr(self.txf_paw.text);
   }else if (self.sure) {
      self.sure();
   }
   if (_alert_type != ALERT_PAW) {
      [self close];
   }
}

-(void)closeAction:(id)sender{
   if (self.cancel) {
      self.cancel();
   }
   
   [self close];
}

-(void)txflostReginer:(id)sender{
   [self.txf resignFirstResponder];
}

-(void)photo:(id)sender{
   if (self.photo) {
      self.photo();
   }
   [self close];
}

-(void)camera:(id)sender{
   if (self.camera) {
      self.camera();
   }
   [self close];
}

-(void)customActions:(UIButton *)sender{
   [self close];
   if (self.arrActions) {
      void (^block)(void) = self.arrActions[sender.tag];
      block();
   }
   
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
