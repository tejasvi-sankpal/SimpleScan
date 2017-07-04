//
//  fetchTextViewController.h
//  TextRecognitionDemo
//
//  Created by Admin on 14/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface fetchTextViewController : UIViewController<G8TesseractDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)UIImage *receivedImage;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)shareAction:(id)sender;

@end
