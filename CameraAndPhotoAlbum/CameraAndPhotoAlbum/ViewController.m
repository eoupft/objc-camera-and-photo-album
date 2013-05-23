//
//  ViewController.m
//  CameraAndPhotoAlbum
//
//  Created by 廣川政樹 on 2013/05/23.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define BTN_CAMERA 0
#define BTN_READ   1
#define BTN_WRITE  2

@implementation ViewController

//初期化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //カメラボタンの生成
    UIButton *btnCamera = [self makeButton:CGRectMake(self.view.center.x - 100, self.view.center.y - 200, 200, 40)
                                      text:@"カメラ起動"
                                       tag:BTN_CAMERA];
    [self.view addSubview:btnCamera];
    
    //フォト読み込みボタンの生成
    UIButton *btnRead = [self makeButton:CGRectMake(self.view.center.x - 100, self.view.center.y - 140, 200, 40)
                                    text:@"フォトライブラリを開く"
                                     tag:BTN_READ];
    [self.view addSubview:btnRead];
    
    //フォト書き込みボタンの生成
    UIButton* btnWrite=[self makeButton:CGRectMake(self.view.center.x - 100, self.view.center.y - 80, 200, 40)
                                   text:@"写真を書き込む"
                                    tag:BTN_WRITE];
    [self.view addSubview:btnWrite];
    
    //イメージビューの生成
    _imageView= [self makeImageView:CGRectMake(self.view.center.x - 100, 320, 200, 200)
                              image:nil];
    [self.view addSubview:_imageView];
}

//アラートの表示
- (void)showAlert:(NSString *)title text:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//テキストボタンの生成
- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text tag:(int)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:text forState:UIControlStateNormal];
    [button setFrame:rect];
    [button setTag:tag];
    [button addTarget:self
               action:@selector(clickButton:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//イメージビューの生成
- (UIImageView *)makeImageView:(CGRect)rect image:(UIImage *)image {
    UIImageView *imageView= [[UIImageView alloc] init];
    [imageView setFrame:rect];
    [imageView setImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    return imageView;
}

//イメージピッカーのオープン
- (void)openPicker:(UIImagePickerControllerSourceType)sourceType {
    //カメラとフォトアルバムの利用可能チェック
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self showAlert:@"" text:@"利用できません"];
        return;
    }
    
    //イメージピッカー
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    //ビューコントローラのビューを開く
    [self presentViewController:picker animated:YES completion:nil];
}

//イメージピッカーのイメージ取得時に呼ばれる
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //イメージの指定
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageView setImage:image];
    
    //ビューコントローラのビューを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//イメージピッカーのキャンセル時に呼ばれる
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerCtl {
    //ビューコントローラのビューを閉じる
    [[pickerCtl presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//ボタンクリック時のイベント処理
- (IBAction)clickButton:(UIButton *)sender {
    if (sender.tag == BTN_CAMERA) {
        [self openPicker:UIImagePickerControllerSourceTypeCamera];
    } else if (sender.tag == BTN_READ) {
        [self openPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (sender.tag == BTN_WRITE) {
        UIImage *image = [_imageView image];
        if (image == nil) return;
        
        //イメージのフォトアルバムへの書き込み
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       @selector(finishExport:didFinishSavingWithError:contextInfo:),
                                       NULL);
    }
}

//フォト書き込み完了
- (void)finishExport:(UIImage *)image didFinishSavingWithError:(NSError *)error
         contextInfo:(void *)contextInfo {
    if (error == nil) {
        [self showAlert:@"" text:@"フォト書き込み完了"];
    } else {
        [self showAlert:@"" text:@"フォト書き込み失敗"];
    }
}

@end
