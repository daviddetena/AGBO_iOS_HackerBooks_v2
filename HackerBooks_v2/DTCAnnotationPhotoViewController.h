//
//  DTCAnnotationPhotoViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCPhoto;

@interface DTCAnnotationPhotoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

// Model
@property (strong,nonatomic) DTCPhoto *model;


#pragma mark - Init
// Designated
-(id) initWithModel:(DTCPhoto *) model;

#pragma mark - Actions
- (IBAction)takePicture:(id)sender;
- (IBAction)applyFilter:(id)sender;
- (IBAction)deletePhoto:(id)sender;



@end
