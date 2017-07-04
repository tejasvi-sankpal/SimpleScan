//
//  ScannerViewController.h
//  TextRecognitionDemo
//
//  Created by Admin on 14/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropView.h"
#import "CLImageEditor.h"


@interface ScannerViewController : UIViewController <UIImagePickerControllerDelegate, ImageCropViewControllerDelegate, UIAlertViewDelegate, CLImageEditorDelegate>{
    
    ImageCropView* imageCropView;
    UIImage* capturedimage;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)fetchTextButtonAction:(id)sender;
- (IBAction)getPDFButtonAction:(id)sender;
- (IBAction)takeButtonAction:(id)sender;
- (IBAction)ChooseButtonAction:(id)sender;
- (IBAction)cropButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)editButtonAction:(id)sender;

@end
