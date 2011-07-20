//
//  NSFileUtility.h
//  DupuisWeb
//
//  Created by mac1 on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileUtility : NSObject {

}

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithString:(NSString*)rvb;

+ (NSString*)retourneTime:(NSDate*)ladate format:(NSString*)format;

+ (void)createDirectoryAtPath:(NSString*)path;
+ (void)removeDirectoryAtPath:(NSString*)path;

+ (NSString*)retourneBundlePath;
+ (NSString*)retourneBundlePathForFile:(NSString *)file;
+ (NSString*)retourneBundlePathForFile:(NSString *)file inDirectory:(NSString*)directory;
+ (NSString*)retourneDocumentPath:(NSString *)file;

+ (NSArray*)subpathsAtPath:(NSString*)path;
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path;

+ (BOOL)verifyIfFileExistInBundle:(NSString*)filename;
+ (BOOL)verifyIfFileExistInDocument:(NSString*)filename;
+ (BOOL)verifyIfFileExistAtPath:(NSString*)path;

+ (NSString*)getFilenameFromURL:(NSURL*)url;
+ (NSString*)getFilenameFromStringURL:(NSString*)url;
+ (NSString*)getFilenameWithoutExtension:(NSString*)filename;
+ (NSString*)getFilenameWithNewExtension:(NSString*)filename ext:(NSString*)extension;

+ (BOOL)createEditableCopyOfFileIfNeeded:(NSString*)fileToCopy;
+ (void)createEditableCopyOfFileIfNeeded:(NSString*)fileToCopy withOtherFilename:(NSString*)filename;
+ (void)createEditableDictionaryPlistIfNeeded:(NSString*)filename;
+ (BOOL)createEditableCopyOfFileIfNeededWithPath:(NSString*)filePath toPath:(NSString*)destPath;

+ (BOOL)moveFile:(NSString*)fileToMove FromPath:(NSString*)from ToDestination:(NSString*)destination;

+ (void)removeFileFromDocuments:(NSString*)filename;
+ (void)removeUnusedFiles:(NSDictionary*)newlist;

+ (void)writeFileToList:(NSString*)filename;

+ (CGFloat)DegreesToRadians:(CGFloat)degrees;
+ (CGFloat)RadiansToDegrees:(CGFloat)radians;
+ (CGPoint)pointSurCercleDeRayon:(float)rayon AvecCentre:(CGPoint)centre EtAngle:(float)angle EtDecalage:(float)decalage;
+ (float)getAngle:(CGPoint)v1 :(CGPoint)v2;

+ (bool)CGRectIntersectsCircle:(CGPoint)centre :(CGFloat)radius :(CGRect)rect;


@end
