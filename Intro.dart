
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Intro extends StatefulWidget {
  Intro({super.key});
  
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int ind=0;
  Color col=Color.fromARGB(255, 30, 68, 166);
  String lemail="";
  String lpassword="";
  String Semail="";
  String Spassword="";
  String Scpassword="";
  String err="";
  bool load=false;
  final GlobalKey<FormState> SformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> lformKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicep = MediaQuery.of(context).padding;
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> list=[getStart(devicep,screenSize),login(devicep,screenSize),signs(devicep,screenSize)];
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: devicep.top),
          child: Column(
            children: [
              AnimatedContainer(
                height: screenSize.height*10/100,
                width: screenSize.width*30/100,
                duration: Duration(seconds: 1),
                child: Center(
                  child: LinearProgressIndicator(
                    color: (ind==0)?Colors.black54:col,
                    value: ind*50/100+0.5,
                  ),
                ),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  child: Container(height: screenSize.height*78/100-devicep.top,
                  width: screenSize.width,
                  child: list[ind],
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: screenSize.height*12/100,
                  child: InkWell(
                    onTap: () async{
                      if(ind==0)
                      {
                        setState(() {
                        ind=1;
                      });
                      }
                      else{
                        if(ind==1){
                        if(SformKey.currentState!.validate()){
                        
                        try{
                          FirebaseAuth.instance.createUserWithEmailAndPassword(email: Semail, password: Spassword);
                          
                        
                          
                        }
                        catch(e){
                          
                          setState(() {
                            
                          
                            err="user already exist!";
                          });
                          
                        }
                         
                      }
                      }
                      else{
                         
                        if(lformKey.currentState!.validate()){
                          setState(() {
                            load=!load;
                          });
                        try{
                          FirebaseAuth.instance.signInWithEmailAndPassword(email: lemail, password: lpassword);

                        }
                        catch(e){
                          setState(() {
                            load=!load;
                            err="wrong id or password";
                          });
                        }
                      }
                      else{
                        
                      }
                       
                      }
                      }
                      
                      
                    },
                    child: (ind==0)?button(screenSize,"Get Started",false):button( screenSize,"Sign up",load),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
  Widget getStart(EdgeInsets devicep,Size screenSize){
    return Container(
      child: Column(
        children: [
          SizedBox(height: screenSize.height*20/100-devicep.top,),
          Container(
            height: screenSize.height*30/100,
            child: Image(image: AssetImage("assets/logo.png"),fit: BoxFit.cover,),
          ),
          Text("hello!",style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenSize.height*3/100),),
          SizedBox(height: screenSize.height*3/100,),
          Text("You Need to Create an account.",style: TextStyle(fontWeight: FontWeight.w500,fontSize: screenSize.height*2.2/100),)
        ],
      ),
    );
  }
  Widget login(EdgeInsets devicep,Size screenSize){
    return Container(
      child: Form(
        key: SformKey,
        child: Column(
          children: [
            SizedBox(height: screenSize.height*10/100-devicep.top,),
            Text("Create your Account",style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenSize.height*3/100),),
            SizedBox(height: screenSize.height*4/100,),
            
            Container(
              height: screenSize.height*12/100,
              width: screenSize.width*75/100,
              child: TextFormField(
                validator: (value){
                  if(value==null)
                  {
                    return "cannot be empty";
                  }
                  else if(value.length<10)
                  {
                    return "invalid email";
                  }
                  else if(value.substring(value.length-10,value.length)!="@gmail.com"){
                    return "invalid email";
                  }
                  return null;
                },
                onChanged: (value){
                  Semail=value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.alternate_email_sharp),
                  hintText: "Enter your Email ID"
                ),
              ),
            ),
            SizedBox(height: screenSize.height*2/100,),
            Container(
              height: screenSize.height*12/100,
              width: screenSize.width*75/100,
              child: TextFormField(
                obscureText: true,
                validator: (value){
                  if(value==null || value.length<6)
                  {
                    return "password too short";
                  }
                  else{
                    return null;
                  }
                },
                onChanged: (value){
                  Spassword=value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(CupertinoIcons.lock_circle),
                  hintText: "Password",
                  
                ),
              ),
            ),
            SizedBox(height: screenSize.height*2/100,),
            Container(
              height: screenSize.height*12/100,
              width: screenSize.width*75/100,
              child: TextFormField(
                validator: (value){
                  if(value!=Spassword){
                    return "Password mismatch";
                  }
                  return null;
                },
                obscureText: true,
                onChanged: (value){
                  Scpassword=value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                 prefixIcon: Icon(CupertinoIcons.lock_circle),
                  hintText: "Confirm password"
                ),
              ),
            ),
             SizedBox(height: screenSize.height*1/100,),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Have an Account? "),
              InkWell(onTap: (){setState(() {
                ind=2;
              });}, child: Text("Sign in",style: TextStyle(color: Colors.blue),))
            ],),
            Text(err,style: TextStyle(fontSize: 13,color: Colors.red),)
          ],
        ),
      ),
    );
  }
  Widget button(Size size,String content,bool load)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.height*3/100),
        color: col
        
      ),
      width: size.width*80/100,
      height: size.height*9/100,
      margin: EdgeInsets.only(bottom: size.height*3/100),
      child: Center(child:(load)?CircularProgressIndicator(): Text(content,style: TextStyle(color: Colors.white,fontSize: size.height*2.3/100),)),
    );
  }
  Widget signs(EdgeInsets devicep,Size screenSize){
    return Container(
      child: Form(
        key: lformKey,
        child: Column(
          children: [
            SizedBox(height: screenSize.height*10/100-devicep.top,),
            Text("Create your Account",style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenSize.height*3/100),),
            SizedBox(height: screenSize.height*4/100,),
            
            Container(
              height: screenSize.height*12/100,
              width: screenSize.width*75/100,
              child: TextFormField(
                
                validator: (value){
                    if(value==null)
                    {
                      return "cannot be empty";
                    }
                    else if(value.length<10)
                    {
                      return "invalid email";
                    }
                    else if(value.substring(value.length-10,value.length)!="@gmail.com"){
                      return "invalid email";
                    }
                    return null;
                  },
                onChanged: (value){
                  lemail=value;
                },
                
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.alternate_email_sharp),
                  hintText: "Enter your Email ID"
                ),
              ),
            ),
            SizedBox(height: screenSize.height*2/100,),
            Container(
              height: screenSize.height*12/100,
              width: screenSize.width*75/100,
              child: TextFormField(
                
                validator: (value){
                  if(value==null || value.length<6)
                  {
                    return "password too short";
                  }
                  return  null;
                },
                obscureText: true,
                onChanged: (value){
                  lpassword=value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(CupertinoIcons.lock_circle),
                  hintText: "Password",
                  
                ),
              ),
            ),
            SizedBox(height: screenSize.height*1/100,),
            
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("New User? "),
              InkWell(onTap: (){setState(() {
                ind=1;
              });}, child: Text("Sign up",style: TextStyle(color: Colors.blue),))
            ],),
            Text(err,style: TextStyle(fontSize: 13,color: Colors.red),)
          ],
        ),
      ),
    );
  }
}