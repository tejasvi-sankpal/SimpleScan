//
//  getPDFViewController.h
//  TextRecognitionDemo
//
//  Created by Admin on 14/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getPDFViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,strong)UIImage *pdfImage;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)shareButtonAction:(id)sender;

@end
