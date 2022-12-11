# bundler

### Flutter Asset Bundler
Bundle the given directory into a single AES encrypted file.

### Usage
add this dev-dependancy to your project add execute the following commands to use the bundler  
Pack Bundle:  
`flutter pub run bundler:pack assets bundle 1234567890abcdef`
Unpack/Verify Bundle:  
`flutter pub run bundler:unpack bundle temp 1234567890abcdef`  


[Future]
Use the flutter-bundler package to load the bundle