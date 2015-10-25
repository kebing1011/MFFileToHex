//
//  main.m
//  MFHexToFile
//
//  Created by mao on 10/25/15.
//  Copyright © 2015 Maokebing. All rights reserved.
//

#import <Foundation/Foundation.h>

UInt8 valueByChar(unichar aChar)
{
	UInt8 value = 0;
	
	if (aChar >= 'a' && aChar <= 'f') {
		value += (aChar - 'a' + 10);
	}else {
		value += (aChar - '0');
	}
	
	return value;
}


NSData* string2data(NSString *string) {
	NSString* hexString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
	hexString = [hexString stringByReplacingOccurrencesOfString:@"<" withString:@""];
	hexString = [hexString stringByReplacingOccurrencesOfString:@">" withString:@""];
	
	NSMutableData* data = [NSMutableData data];
	for (int i = 0; i < string.length; i+=2) {
		unichar high = [string characterAtIndex:i];
		unichar low =[string characterAtIndex:i+1];
		
		UInt8 value = 0;
		value += valueByChar(high) * 16;
		value += valueByChar(low);
		
		[data appendBytes:&value length:1];
	}
	return data;
}

BOOL Hex2File(NSString* inFilePath, NSString* outFilePath, NSError **error) {
	if (![[NSFileManager defaultManager] fileExistsAtPath:inFilePath]) {
		*error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@ not exist!", inFilePath] code:-1 userInfo:nil];
		return false;
	}
	
	NSString* string = [[NSString alloc] initWithContentsOfFile:inFilePath encoding:NSUTF8StringEncoding error:error];
	if (!string) {
		return false;
	}
	
	NSData* data = string2data(string);
	return [data writeToFile:outFilePath options:NSDataWritingAtomic error:error];
}

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		if (argc <= 2) {
			printf("usage: hex2file hex_file out_file\n");
			return 0;
		}
		
		NSString* fileIn = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
		NSString* fileOut = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
		NSError* error = nil;
		
		BOOL sucess = Hex2File(fileIn, fileOut, &error);
		
		if (!sucess) {
			printf("%s\n", [error.localizedDescription cStringUsingEncoding:NSUTF8StringEncoding]);
		}
	}
	return 0;
}


