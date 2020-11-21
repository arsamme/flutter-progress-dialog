# ars_progress_dialog  
  Nice customizable progress dialog package for Flutter projects.

### Example
![example gif](https://raw.githubusercontent.com/arsamme/flutter-progress-dialog/main/example/doc/example.gif)

## Getting Started    
 ### Install  
Add dependency to pubspec.yaml file :  
`ars_progress_dialog: 0.0.1`  
  
### Import  
Import class in your project :  
`import 'package:ars_progress_dialog/dialog.dart';`  
  
## Showing Dialog  
### Show simple progress dialog :  

```  
ArsProgressDialog progressDialog = ArsProgressDialog(
	context,
	blur: 2,
	backgroundColor: Color(0x33000000),
	animationDuration: Duration(milliseconds: 500));
	
	progressDialog.show(); // show dialog
	progressDialog.dismiss(); //close dialog
``` 
  
### Customize loading widget :  
  
```  
 ArsProgressDialog progressDialog = ArsProgressDialog(
	 context,
	 blur: 2,
	 backgroundColor: Color(0x33000000),
	 loadingWidget: Container(
		 width: 150,
		 height: 150,
		 color: Colors.red,
		 child: CircularProgressIndicator(),    
    ));  
```