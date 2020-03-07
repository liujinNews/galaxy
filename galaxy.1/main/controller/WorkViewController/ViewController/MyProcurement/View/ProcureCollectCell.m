//
//  ProcureCollectCell.m
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ProcureCollectCell.h"

@implementation ProcureCollectCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)configCellHasAddWith:(NSMutableArray *)imageArray withRow:(NSInteger)row{
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.mainView.center=self.contentView.center;
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    _PhotoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 60,60)];
    _PhotoImgView.backgroundColor=[UIColor whiteColor];
    [self.mainView addSubview:_PhotoImgView];
    
    _titleLab=[GPUtils createLable:CGRectMake(0, 50, 60, 10) text:nil font:Font_Same_10_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.mainView addSubview:_titleLab];

    if (imageArray.count==0) {
        _PhotoImgView.image=[UIImage imageNamed:@"share_AddPhoto"];
    }else{
        if (row<=imageArray.count-1) {
            if ([imageArray[row] isKindOfClass:[NSDictionary class]]) {
                NSString *typestring=[NSString stringWithFormat:@"%@",imageArray[row][@"extensionname"]];
                NSString *titleString=[NSString stringWithFormat:@"%@",imageArray[row][@"displayname"]];
                if ([typestring isEqualToString:@".doc"]||[typestring isEqualToString:@".docx"]) {
                    _PhotoImgView.image=[UIImage imageNamed:@"Work_Word"];
                    _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
                }else if ([typestring isEqualToString:@".xls"]||[typestring isEqualToString:@".xlsx"]){
                    _PhotoImgView.image=[UIImage imageNamed:@"Work_Excel"];
                    _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
                }else if ([typestring isEqualToString:@".pdf"]){
                    _PhotoImgView.image=[UIImage imageNamed:@"Work_Pdf"];
                    _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
                }else if ([typestring isEqualToString:@".csv"]){
                    _PhotoImgView.image=[UIImage imageNamed:@"Work_Csv"];
                    _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
                }else if ([typestring isEqualToString:@".txt"]){
                    _PhotoImgView.image=[UIImage imageNamed:@"Work_Txt"];
                    _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
                }else if ([typestring isEqualToString:@".zip"]||[typestring isEqualToString:@".rar"]||[typestring isEqualToString:@".7z"]){
                    _PhotoImgView.image=[UIImage imageNamed:@"Work_Zip"];
                    _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
                }else{
                    [_PhotoImgView sd_setImageWithURL:[NSURL URLWithString:[imageArray[row] objectForKey:@"filepath"]]];
                }
            }else{
                ZLPhotoAssets *asset =imageArray[row];
                if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                    _PhotoImgView.image = [asset aspectRatioImage];
                }else if ([asset isKindOfClass:[NSString class]]){
                    [_PhotoImgView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset]];
                }else if([asset isKindOfClass:[UIImage class]]){
                    _PhotoImgView.image = (UIImage *)asset;
                }else if ([asset isKindOfClass:[ZLCamera class]]){
                    _PhotoImgView.image = [asset thumbImage];
                }
            }
        }else{
            _PhotoImgView.image=[UIImage imageNamed:@"share_AddPhoto"];
        }
        
    }
}
-(void)configNoAddCellWith:(NSMutableArray *)imageArray withRow:(NSInteger)row{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.mainView.center=self.contentView.center;
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    _PhotoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 60,60)];
    _PhotoImgView.backgroundColor=[UIColor whiteColor];
    [self.mainView addSubview:_PhotoImgView];

    _titleLab=[GPUtils createLable:CGRectMake(0, 50, 60, 10) text:nil font:Font_Same_10_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.mainView addSubview:_titleLab];
    
    if ([imageArray[row] isKindOfClass:[NSDictionary class]]) {
        NSString *typestring=[NSString stringWithFormat:@"%@",imageArray[row][@"extensionname"]];
        NSString *titleString=[NSString stringWithFormat:@"%@",imageArray[row][@"displayname"]];
        if ([typestring isEqualToString:@".doc"]||[typestring isEqualToString:@".docx"]) {
            _PhotoImgView.image=[UIImage imageNamed:@"Work_Word"];
            _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
        }else if ([typestring isEqualToString:@".xls"]||[typestring isEqualToString:@".xlsx"]){
            _PhotoImgView.image=[UIImage imageNamed:@"Work_Excel"];
            _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
        }else if ([typestring isEqualToString:@".pdf"]){
            _PhotoImgView.image=[UIImage imageNamed:@"Work_Pdf"];
            _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
        }else if ([typestring isEqualToString:@".csv"]){
            _PhotoImgView.image=[UIImage imageNamed:@"Work_Csv"];
            _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
        }else if ([typestring isEqualToString:@".txt"]){
            _PhotoImgView.image=[UIImage imageNamed:@"Work_Txt"];
            _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
        }else if ([typestring isEqualToString:@".zip"]||[typestring isEqualToString:@".rar"]||[typestring isEqualToString:@".7z"]){
            _PhotoImgView.image=[UIImage imageNamed:@"Work_Zip"];
            _titleLab.text=[NSString isEqualToNull:titleString]?titleString:@"";
        }else{
            [_PhotoImgView sd_setImageWithURL:[NSURL URLWithString:[imageArray[row] objectForKey:@"filepath"]]];
        }
    }else{
        ZLPhotoAssets *asset =imageArray[row];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            _PhotoImgView.image = [asset aspectRatioImage];
        }else if ([asset isKindOfClass:[NSString class]]){
            [_PhotoImgView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset]];
        }else if([asset isKindOfClass:[UIImage class]]){
            _PhotoImgView.image = (UIImage *)asset;
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            _PhotoImgView.image = [asset thumbImage];
        }
    }
}
@end
