# Rob-sDringkingAPP

## Requirements

- iOS 8.0+ 
- Xcode 8

## Configuration

- 1. This app should be run after server depolyment.
- 2. The server should be deployed Apcahe, PHP and Mysql enviorment.
- 3. You should revise loginUrl in each ViewController according you server configeration, please use Command + F to find it.
- 4. The server must depoly following PHP files in `htdocs` file   
-　　login.php  
-　　recording.php  
-　　SSTreaction.php  
-　　SSTrecording.php  
- 5. Mysql server must contains following 4 tales:   
-　　Table: MyGuests (user information)   
-　　Table: Record (DDT results)  
-　　Table: SSTRecord (SST blocks results)  
-　　Table: SSTReact (SST each trial's results)  

## Contribution

- Login and Register Interface : Yucheng Yang, Taoji Feng  
- DDT task : Yucheng Yang  
- SST task : Taoji Feng  
- Server code: Yucheng Yang  
