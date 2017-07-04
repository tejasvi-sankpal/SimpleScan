//
//  getPDFViewController.m
//  TextRecognitionDemo
//
//  Created by Admin on 14/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import "getPDFViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PDFImageConverter.h"

@interface getPDFViewController (){
    NSData *pdfData;
}

@end

@implementation getPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        CGSize pageSize = CGSizeMake(_webview.frame.size.width, _webview.frame.size.height);
        CGRect imageBoundsRect = CGRectMake(0, 0, _webview.frame.size.width, _webview.frame.size.height);
    
        pdfData = [PDFImageConverter convertImageToPDF:_pdfImage
                                                withResolution: 300 maxBoundsRect: imageBoundsRect pageSize: pageSize];
    
    [self.activityIndicator startAnimating];
    [self.webview loadData:pdfData
                  MIMEType:@"application/pdf"
          textEncodingName:@"UTF-8"
                   baseURL:nil];
    
//        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/image.pdf"];
//        [pdfData writeToFile:path atomically:NO];
//    
//        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"pdf"];
//        NSURL *targetURL = [NSURL fileURLWithPath:path1];
//        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
//        [_webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebviewDelegate Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.activityIndicator stopAnimating];
    
   
    NSLog(@"finish");
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.activityIndicator stopAnimating];
    
   
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareButtonAction:(id)sender {
    
    NSData *pdf = pdfData;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Test", pdf] applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
@end
