//
//  DTCSimplePDFViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCBook;

@interface DTCSimplePDFViewController : UIViewController

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIWebView *pdfViewer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

// Model
@property (strong,nonatomic) DTCBook *model;


#pragma mark - Init
-(id) initWithModel:(DTCBook *) model;


#pragma mark - Actions

@end
