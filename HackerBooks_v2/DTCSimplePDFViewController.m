//
//  DTCSimplePDFViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCSimplePDFViewController.h"
#import "DTCBook.h"
#import "DTCPdf.h"
#import "DTCLibraryViewController.h"


@interface DTCSimplePDFViewController ()

@end


@implementation DTCSimplePDFViewController

#pragma mark - Init
-(id) initWithModel:(DTCBook *) model{
    if (self = [super init]) {
        _model = model;
        self.title = model.title;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.activityView.hidden = YES;
    
    [self syncWithModel];
    
    // Alta en notificaciones de library
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(notifyThatBookDidChange:)
               name:DTCLIBRARY_DID_SELECT_BOOK_NOTIFICATION
             object:nil];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notifications
-(void) notifyThatBookDidChange:(NSNotification *) notification{
    // Get new selected book in the table
    DTCBook *newBook = [notification.userInfo objectForKey:DTCLIBRARY_BOOK_SELECTED_KEY];
    self.model = newBook;
    
    // Update view with new book data
    [self syncWithModel];
}



#pragma mark - Util
-(void) syncWithModel{
    
    self.title = self.model.title;
    
    NSLog(@"PDF: %@", self.model.pdfUrl);
    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    
//    NSURL *localURL = [self localURLForRemoteURL:[NSURL URLWithString:self.model.pdfUrl]];
//    if ([fm fileExistsAtPath:[localURL path]]) {
    if(self.model.pdf.pdfData){
        NSLog(@"PDF EXISTE");
        [self.pdfViewer loadData:self.model.pdf.pdfData
                      MIMEType:@"application/pdf"
              textEncodingName:@"UTF-8"
                       baseURL:nil];
        
    }else{
        NSLog(@"PDF NO EXISTE");
        // No está en local
        // Hay que descargar y guardar
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.pdfUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdfViewer loadData:data
                              MIMEType:@"application/pdf"
                      textEncodingName:@"UTF-8"
                               baseURL:nil];
                
                [self.activityView stopAnimating];
                self.activityView.hidden = YES;
                
                self.model.pdf.pdfData = data;
                
                //[data writeToURL:localURL
                     // atomically:YES];
            });
        });
    }
}

-(NSURL*)documentsDirectory{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSURL *docs = [[fm URLsForDirectory:NSDocumentDirectory
                              inDomains:NSUserDomainMask] lastObject];
    return docs;
}

-(NSURL *) localURLForRemoteURL:(NSURL*) remoteURL{
    
    NSString *fileName = [remoteURL lastPathComponent];
    NSURL *local = [[self documentsDirectory] URLByAppendingPathComponent:fileName];
    
    return local;
}


@end
