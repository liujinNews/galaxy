//
//  EditAndLookImgView.m
//  galaxy
//
//  Created by hfk on 2017/7/14.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "EditAndLookImgView.h"
static NSString *const CellIdentifier = @"ProcureCollectCell";

@implementation EditAndLookImgView
- (instancetype)initWithFrame:(CGRect)frame withEditStatus:(NSInteger)EditStatus{
    self = [super initWithFrame:frame];
    if (self) {
        _EditStatus=EditStatus;
        if (_EditStatus==1 || _EditStatus==3) {
            UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
            view.backgroundColor=Color_White_Same_20;
            _gapView = view;
            [self addSubview:view];
        }
        
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.minimumInteritemSpacing =1;
        _layOut.minimumLineSpacing =1;
        _layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.imgCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, (_EditStatus==1||_EditStatus==3)?10:0, Main_Screen_Width-12-10, 70) collectionViewLayout:_layOut];
        self.imgCollectView.delegate = self;
        self.imgCollectView.dataSource = self;
        self.imgCollectView.backgroundColor =Color_WhiteWeak_Same_20;
        [self.imgCollectView registerClass:[ProcureCollectCell class] forCellWithReuseIdentifier:CellIdentifier];
        [self addSubview:self.imgCollectView];
    }
    return self;
}
- (instancetype)initWithBaseView:(UIView *)bgView withEditStatus:(NSInteger)EditStatus withModel:(MyProcurementModel *)model{
    self = [super init];
    if (self) {
        
        _bgView = bgView;
        
        _bgView.clipsToBounds=YES;
    
        _EditStatus=EditStatus;
        
        if (_EditStatus == 1 && [model.isOnlyRead isEqualToString:@"1"]) {
            _EditStatus = 3;
        }
        
        _view_Head=[[UIView alloc]init];
        _view_Head.backgroundColor=Color_White_Same_20;
        [self addSubview:_view_Head];
        
        self.titleLab=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLab];
        
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.minimumInteritemSpacing =1;
        _layOut.minimumLineSpacing =1;
        _layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.imgCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layOut];
        self.imgCollectView.delegate = self;
        self.imgCollectView.dataSource = self;
        self.imgCollectView.backgroundColor =Color_WhiteWeak_Same_20;
        [self.imgCollectView registerClass:[ProcureCollectCell class] forCellWithReuseIdentifier:CellIdentifier];
        [self addSubview:self.imgCollectView];
        
        NSInteger height=0;
        NSInteger baseHeiht=0;
        
        if (_EditStatus==1||_EditStatus==3) {
            _view_Head.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
            height = 10;
            baseHeiht = 88;
        }else{
            baseHeiht = 78;
        }
        if ([NSString isEqualToNull:model.Description]) {
            self.titleLab.frame=CGRectMake(12, height+5, Main_Screen_Width-12, 20);
            self.titleLab.text=[NSString stringWithFormat:@"%@",model.Description];
            height += 25;
            baseHeiht += 25;
        }
        self.imgCollectView.frame=CGRectMake(8, height, Main_Screen_Width-12-8, 70);
        [_bgView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(baseHeiht));
        }];
        self.frame=CGRectMake(0, 0, Main_Screen_Width, baseHeiht);
    }
    return self;
}

- (void)updateWithTotalArray:(NSMutableArray *)arr  WithImgArray:(NSMutableArray *)imgArr{
    
    if (_EditStatus != 1 && arr.count == 0) {
        self.imgCollectView.hidden = YES;
        NSInteger height=0;
        NSInteger baseHeiht=0;
        if (_EditStatus==3) {
            _view_Head.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
            height = 10;
            baseHeiht = 60;
        }else{
            baseHeiht = 50;
        }
        self.titleLab.frame = CGRectMake(12, height, Main_Screen_Width-12, 50);
        [_bgView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(baseHeiht));
        }];
        self.frame = CGRectMake(0, 0, Main_Screen_Width, baseHeiht);
        
    }else{
        [GPUtils updateImageDataWithTotalArray:arr WithImageArray:imgArr WithMaxCount:self.maxCount];
        self.totalArray = arr;
        self.imageArray = imgArr;
        [self.imgCollectView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 70);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (Main_Screen_Width==320) {
        return 3;
    }else{
        return 5;
    }
}


#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_EditStatus==1) {
        NSInteger num=0;
        if (_totalArray.count<_maxCount) {
            num=_totalArray.count+1;
        }else if(_totalArray.count==_maxCount){
            num=_totalArray.count;
        }
        return num;
    }else{
        return _totalArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.Imagecell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (_EditStatus==1) {
        for (UIView *view in self.Imagecell.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
        if (_totalArray.count<_maxCount) {
            [self.Imagecell configCellHasAddWith:_totalArray withRow:indexPath.row];
            if (_totalArray.count!=0&&indexPath.row<=_totalArray.count-1) {
                if ([GPUtils isFileType:_totalArray[indexPath.row]]) {
                    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(55, 0, 20, 20)];
                    [btn setImage:[UIImage imageNamed:@"share_ImageDelete"] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteImages:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=indexPath.row+10;
                    [self.Imagecell addSubview:btn];
                }
            }
        }else if(_totalArray.count==_maxCount){
            [self.Imagecell configNoAddCellWith:_totalArray withRow:indexPath.row];
            if ([GPUtils isFileType:_totalArray[indexPath.row]]) {
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(55, 0, 20, 20)];
                [btn setImage:[UIImage imageNamed:@"share_ImageDelete"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(deleteImages:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=indexPath.row+10;
                [self.Imagecell addSubview:btn];
            }
        }
        
    }else{
        [self.Imagecell configNoAddCellWith:_totalArray withRow:indexPath.row];
    }
    return self.Imagecell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeKeyBoard];
    if (_EditStatus==1) {
        if (_totalArray.count<_maxCount) {
            if (_totalArray.count==0) {
                [self addPhotoView];
            }else{
                if (indexPath.row<=_totalArray.count-1) {
                    [self showFileImageWithIndex:indexPath.row];
                }else{
                    [self addPhotoView];
                }
            }
        }else if(_totalArray.count==_maxCount){
            [self showFileImageWithIndex:indexPath.row];
        }
    }else{
        [self showFileImageWithIndex:indexPath.row];
    }
}


-(void)deleteImages:(UIButton *)btn{
    [self closeKeyBoard];
    UIAlertView *deleteImagesAler = [[UIAlertView alloc]initWithTitle:@"" message:Custing(@"确认删除?", nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"删除", nil), nil];
    deleteImagesAler.tag=btn.tag-10;
    [deleteImagesAler show];
}
#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [_totalArray removeObjectAtIndex:alertView.tag];
        [GPUtils updateImageDataWithTotalArray:self.totalArray WithImageArray:self.imageArray WithMaxCount:self.maxCount];
        [self.imgCollectView reloadData];
    }
}
//MARK:相册选择
-(void)addPhotoView{
    HClActionSheet * actionSheet = [[HClActionSheet alloc] initWithTitle:nil style:HClSheetStyleWeiChat itemTitles:@[Custing(@"拍照", nil),Custing(@"从手机相册选择",nil)]];
    actionSheet.delegate = self;
    actionSheet.tag = 100;
    actionSheet.itemTextColor =Color_cellContent;
    actionSheet.itemTextFont=Font_selectTitle_15;
    actionSheet.cancleTextColor =Color_cellContent;
    actionSheet.cancleTextFont=Font_selectTitle_15;
    actionSheet.cancleTitle = Custing(@"取消", nil);
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        if (index==0) {
            //打开照相机拍照
            [weakSelf openCamera];
        }else if (index==1){
            //打开本地相册
            [weakSelf openLocalPhoto];
        }
    }];
}
//MARK:发票图片选择(相机和相册)
- (void)openCamera{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVc.maxCount = (_maxCount-_totalArray.count)>0?_maxCount-_totalArray.count:0;
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
        if (cameras.count!=0) {
            [weakSelf.totalArray addObjectsFromArray:cameras];
            [GPUtils updateImageDataWithTotalArray:weakSelf.totalArray WithImageArray:weakSelf.imageArray WithMaxCount:weakSelf.maxCount];
            [weakSelf.imgCollectView reloadData];
        }
    };
    UIViewController *vc=[GPUtils getCurrentVC];
    [cameraVc showPickerVc:vc];
}

- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    
    // 最多能选3张图片
    pickerVc.maxCount =(_maxCount-_totalArray.count)>0?_maxCount-_totalArray.count:0;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    UIViewController *vc=[GPUtils getCurrentVC];
    [pickerVc showPickerVc:vc];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.totalArray addObjectsFromArray:assets];
        [GPUtils updateImageDataWithTotalArray:weakSelf.totalArray WithImageArray:weakSelf.imageArray WithMaxCount:weakSelf.maxCount];
        [weakSelf.imgCollectView reloadData];
    };
    
}
//MARK:显示图片或者文件
- (void)showFileImageWithIndex:(NSInteger)index;{
    NSString *type = @"";
    if ([_totalArray[index] isKindOfClass:[NSDictionary class]]) {
        type = _totalArray[index][@"extensionname"];
    }
    if ([type isEqualToString:@".pdf"]||[type isEqualToString:@".doc"]||[type isEqualToString:@".docx"]||[type isEqualToString:@".xls"]||[type isEqualToString:@".xlsx"]||[type isEqualToString:@".txt"]) {
        [self showFileWithUrlDate:_totalArray[index][@"filepath"]];
    }else if([type isEqualToString:@".zip"]||[type isEqualToString:@".rar"]||[type isEqualToString:@".7z"]||[type isEqualToString:@".csv"]){
        UIViewController *vc=[GPUtils getCurrentVC];
        [[GPAlertView sharedAlertView]showAlertText:vc WithText:Custing(@"文件暂不支持本地查看", nil) duration:2.0];
    }else{
        [self showImageWithImageDate:_imageArray WithIndex:index];
    }
    
}
- (void)showFileWithUrlDate:(NSString *)urlstr{
    PDFLookViewController *pdf = [[PDFLookViewController alloc]init];
    pdf.url =urlstr;
    pdf.hasBack=YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pdf];
    [[GPUtils getCurrentVC] presentViewController:nav animated:YES completion:nil];
}

- (void)showImageWithImageDate:(NSMutableArray *)imageArray WithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    pickerBrowser.editing = NO;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    _showImageArray=[NSMutableArray arrayWithArray:imageArray];
    UIViewController *vc=[GPUtils getCurrentVC];
    [pickerBrowser showPickerVc:vc];
}
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _showImageArray.count;
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [_showImageArray objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    ProcureCollectCell *cell = (ProcureCollectCell *)[self.imgCollectView cellForItemAtIndexPath:indexPath];
    photo.toView = cell.PhotoImgView;
    //    NSLog(@"toview image frame %@",NSStringFromCGRect(photo.toView.frame));
    // 缩略图
    photo.thumbImage = cell.PhotoImgView.image;
    
    //    photo.thumbImage = [cell.PhotoImgView.image scaleToSize:CGSizeMake(cell.PhotoImgView.image.size.width*2, cell.PhotoImgView.image.size.height*2)];
    return photo;
}

-(void)closeKeyBoard{
    UIViewController *vc=[GPUtils getCurrentVC];
    [vc.view endEditing:YES];
}
//-(void)deleteImages:(UIButton *)btn{
//    if (self.deleteBlock) {
//        self.deleteBlock(btn.tag);
//    }
//}
//-(void)addPhotoView{
//    if (self.AddBlock) {
//        self.AddBlock();
//    }
//}
//-(void)showFileImg:(NSInteger)index{
//    if (self.showBlock) {
//        self.showBlock(index);
//    }
//}
//- (void)updateWithArray:(NSMutableArray *)arr{
//    self.totalArray=arr;
//    [self.imgCollectView reloadData];
//}


@end
