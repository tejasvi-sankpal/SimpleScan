//
//  ViewController.m
//  TextRecognitionDemo
//
//  Created by Admin on 13/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import "ViewController.h"
#import "CustomListTableViewCell.h"
#import "ScannerViewController.h"
#import "documentDetailsViewController.h"
#import "UIColor+UIColor_TPAdditions.h"


@interface ViewController ()

@property (strong, nonatomic) VCFloatingActionButton *cameraButton;
@property(nonatomic,strong)NSMutableArray *fetchedDocuments;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor loginNavThemeColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor loginNavTextColor] forKey:NSForegroundColorAttributeName];
    _fetchedDocuments = [[NSMutableArray alloc] init];
    
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, [UIScreen mainScreen].bounds.size.height - 80 - 20, 80, 80);
    
    _cameraButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"camera1"] andPressedImage:[UIImage imageNamed:@"cross"] withScrollview:_docListTableview];
    
    //_cameraButton.imageArray = @[@"fb-icon",@"twitter-icon",@"google-icon",@"linkedin-icon"];
    //_cameraButton.labelArray = @[@"Facebook",@"Twitter",@"Google Plus",@"Linked in"];
    
    _cameraButton.hideWhileScrolling = YES;
    _cameraButton.delegate = self;
    
    
    _docListTableview.dataSource = self;
    _docListTableview.delegate = self;
    
    
    [self.view addSubview:_cameraButton];
    
    //[self zoomIn];
   // [self zoomOut];
       
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadImagesFromDocumentsDirectory];
    [self.docListTableview reloadData];
    if ([_fetchedDocuments count] == 0) {
        [self.docListTableview setHidden:YES];
        [_noDataView setHidden:NO];
    }else{
        [self.docListTableview setHidden:NO];
        [_noDataView setHidden:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if ([_fetchedDocuments count] == 0) {
        [self zoomIn];
    }
}

#pragma mark FloatMenuDelegate Methods

-(void) didSelectMenuOptionAtIndex{
    NSLog(@"Floating action tapped index");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ScannerViewController *scannerVC = [sb instantiateViewControllerWithIdentifier:@"ScannerView"];
    [self.navigationController pushViewController:scannerVC animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_fetchedDocuments count] == 0) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        [self.cameraButton.layer.presentationLayer hitTest:touchLocation];
    }
   
//    for (UIButton *button in self.cameraButton)
//    {
//        if ([button.layer.presentationLayer hitTest:touchLocation])
//        {
//            // This button was hit whilst moving - do something with it here
//            break;
//        }
//    }
}

#pragma mark Zoom In Zoom Out Methods

-(void)zoomIn{
    [UIView animateWithDuration:0.5f delay:0
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _cameraButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finished){
        if ([_fetchedDocuments count] == 0) {
            [self zoomOut];
        }

    }];
    
}

-(void)zoomOut{
    [UIView animateWithDuration:0.5f delay:0
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _cameraButton.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished){
        if ([_fetchedDocuments count] == 0) {
            [self zoomIn];
        }
     }];
   }



#pragma mark UITableviewDataSource and UITableviewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_fetchedDocuments count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocsCell"];
    
    if (cell == nil) {
        cell = [(CustomListTableViewCell*)[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DocsCell"];
    }
    
    NSString *currentDocString = [_fetchedDocuments objectAtIndex:indexPath.row];
    NSInteger index = currentDocString.length - 13 ;
    cell.docName.text = [currentDocString substringToIndex:index];
    
   cell.docDate.text = [currentDocString substringWithRange:NSMakeRange(8,19)];
    
    cell.docPic.image = [self getImageFromString:[_fetchedDocuments objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    documentDetailsViewController *docVC = [sb instantiateViewControllerWithIdentifier:@"DocumentDetails"];
    docVC.documentDetails = [_fetchedDocuments objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:docVC animated:YES];
    
}

-(UIImage *)getImageFromString:(NSString*)imgName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *folderPath = [documentsPath   stringByAppendingPathComponent:@"MyDocuments"];
    
    NSString *imagePath = [folderPath stringByAppendingPathComponent:imgName];
    UIImage *tempImage = [UIImage imageWithContentsOfFile:imagePath];
    return tempImage;

}

-(void)loadImagesFromDocumentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *folderPath = [documentsPath   stringByAppendingPathComponent:@"MyDocuments"];  // subDirectory
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    
    _fetchedDocuments = [NSMutableArray arrayWithArray:directoryContents];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
