//
//  ImageViewController.h
//  galaxy
//
//  Created by hfk on 15/11/13.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
-(id)initWithType:(NSString *)type;
@property(nonatomic,strong)NSDictionary *photoImageDict;
@property(nonatomic,strong)UIImage *photoImageDictImage;


@property(nonatomic,strong)NSMutableArray *photoImageArray;//展示图片数组
@property(nonatomic,assign)NSInteger index;//展示图片第几张
@end
